/** @noSelfInFile */
/**
 * 爱蜜莉雅 - Q：冰之矢（A4）
 *
 * - 点目标：以施法方向为主；单位目标：仅短距离追踪修正（规划 4.2）。
 * - 发射/命中/穿晶/终点节点分别结算与清理（同一技能实例管理）。
 * - 一次 Q 最多主动读取一枚冰晶；读取后在终点生成新节点（消耗旧支点、建立新支点）。
 * - D 强化：命中或触发冰晶后追加短距离追踪冰弹（不重复碎冰、不额外消耗冰晶）。
 * - 弹道完成/打断/死亡统一清理轨迹与节点引用。
 */

import { 爱蜜莉雅技能配置, 爱蜜莉雅Q配置, 爱蜜莉雅普攻配置 } from "./00．配置";
import { 登记爱蜜莉雅技能清理, 消费爱蜜莉雅D强化, 播放爱蜜莉雅动作 } from "./02．公共状态与冰晶";
import {
  结算爱蜜莉雅技能命中,
  创建爱蜜莉雅场上冰晶,
  取最近冰晶,
  读取爱蜜莉雅冰晶节点,
} from "./03．被动效果";

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;

const { 发射弹道, 获取弹道当前位置 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂") as {
  发射弹道: (this: void, 参数: any) => any;
  获取弹道当前位置: (this: void, 弹道: any) => { X: number; Y: number };
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 读取单位攻击力, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};

const 英雄单位类型ID = jass.FourCC(爱蜜莉雅技能配置.单位类型ID) as number;
const Q技能类型ID = jass.FourCC(爱蜜莉雅技能配置.Q.技能ID) as number;

/** 分裂冰刃：从冰晶位置向前/侧方扇形分裂（复用冰矢模型，小缩放） */
function 发射分裂冰刃(this: void, 施法者: any, X: number, Y: number, 中心角: number, 技能实例ID: number | undefined): void {
  const 数量 = 爱蜜莉雅Q配置.分裂冰刃数量;
  const 伤害 = 读取单位攻击力(施法者) * 爱蜜莉雅Q配置.分裂冰刃伤害攻击力倍率;
  for (let i = 0; i < 数量; i++) {
    const 偏移 = (i - (数量 - 1) / 2) * 18;
    发射弹道({
      名称: "爱蜜莉雅-Q分裂冰刃",
      所有者: 施法者,
      发射X: X,
      发射Y: Y,
      发射方向角: 中心角 + 偏移,
      速度: 爱蜜莉雅Q配置.分裂冰刃速度,
      轨迹: { 类型: "直线", 距离: 350 },
      命中半径: 80,
      影响目标: "敌方",
      碰撞消失: true,
      每单位最大命中次数: 1,
      伤害值: 伤害,
      伤害类型: DAMAGE_TYPE_COLD,
      来源类型: "单位技能",
      技能ID: Q技能类型ID,
      技能实例ID,
      技能标签: "爱蜜莉雅-Q分裂冰刃",
      伤害形态: "单体",
      参与技能伤害加成: true,
      模型: 爱蜜莉雅Q配置.弹道模型,
      缩放: 0.6,
    });
  }
}

/**
 * D 强化：命中或穿晶后追加短距离追踪冰弹（不重复碎冰/不耗冰晶）。
 * 先确认发射条件再消费资源：点地施法无目标时改向冰弹方向直线发射，不白扣强化次数。
 */
function 发射Q帕克冰弹(this: void, 施法者: any, 目标: any, 技能实例ID: number | undefined, 方向角: number): void {
  const 有目标 = 目标 != null && 目标 !== 0;
  if (!消费爱蜜莉雅D强化(施法者)) return;
  const 发射参数: any = {
    名称: "爱蜜莉雅-Q帕克冰弹",
    所有者: 施法者,
    发射方向角: 有目标 ? 两点角度(GetUnitX(施法者), GetUnitY(施法者), GetUnitX(目标), GetUnitY(目标)) : 方向角,
    速度: 爱蜜莉雅Q配置.弹道速度 * 1.2,
    轨迹: 有目标 ? { 类型: "追踪", 目标, 追踪转向速度: 540 } : { 类型: "直线", 距离: 450 },
    命中半径: 90,
    影响目标: "敌方",
    碰撞消失: true,
    每单位最大命中次数: 1,
    伤害值: 读取单位攻击力(施法者) * 0.5,
    伤害类型: DAMAGE_TYPE_COLD,
    来源类型: "单位技能",
    技能ID: Q技能类型ID,
    技能实例ID,
    技能标签: "爱蜜莉雅-Q帕克冰弹",
    伤害形态: "单体",
    参与技能伤害加成: false,
    模型: 爱蜜莉雅普攻配置.帕克追击模型,
    缩放: 爱蜜莉雅普攻配置.帕克追击缩放,
  };
  发射弹道(发射参数);
}

function 释放Q冰之矢(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0) return;
  播放爱蜜莉雅动作(施法者, 爱蜜莉雅Q配置.动作索引, 0.8);
  const 伤害 = 读取单位攻击力(施法者) * 爱蜜莉雅Q配置.伤害攻击力倍率;
  const 来源键 = "Q:" + (技能实例ID ?? 0);

  const 目标单位 = GetSpellTargetUnit();
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 起点X = GetUnitX(施法者);
  const 起点Y = GetUnitY(施法者);
  const 基础方向 = 两点角度(起点X, 起点Y, 目标X, 目标Y);
  const 轨迹 = 目标单位 != null && 目标单位 !== 0
    ? { 类型: "追踪", 目标: 目标单位, 追踪转向速度: 360 }
    : { 类型: "直线", 距离: 爱蜜莉雅Q配置.最大距离 };

  let 已穿晶 = false;

  const 弹道 = 发射弹道({
    名称: "爱蜜莉雅-Q冰之矢",
    所有者: 施法者,
    发射方向角: 基础方向,
    速度: 爱蜜莉雅Q配置.弹道速度,
    轨迹,
    命中半径: 爱蜜莉雅Q配置.命中半径,
    影响目标: "敌方",
    碰撞消失: true,
    每单位最大命中次数: 1,
    // 主冰矢不传 伤害值：伤害由 on命中 统一结算（结算爱蜜莉雅技能命中 含碎冰/受控增伤/寒意），
    // 避免弹道工厂自动结算与 on命中 造成双重扣血。
    伤害类型: DAMAGE_TYPE_COLD,
    来源类型: "单位技能",
    技能ID: Q技能类型ID,
    技能实例ID,
    技能标签: "爱蜜莉雅-Q冰之矢",
    伤害形态: "单体",
    参与技能伤害加成: true,
    模型: 爱蜜莉雅Q配置.弹道模型,
    on命中: function Q命中(this: void, 目标: any, _弹幕ID: number): void {
      结算爱蜜莉雅技能命中(施法者, 目标, 来源键, {
        伤害值: 伤害,
        技能ID: Q技能类型ID,
        技能实例ID,
        标签: "爱蜜莉雅-Q冰之矢",
        伤害类型: DAMAGE_TYPE_COLD,
      });
      发射Q帕克冰弹(施法者, 目标, 技能实例ID, 基础方向);
    },
    onTick: function Q穿晶检测(this: void, 实例: any, _delta: number): void {
      if (已穿晶 || 实例 == null) return;
      const 节点 = 取最近冰晶(施法者, 实例.当前X, 实例.当前Y, 爱蜜莉雅Q配置.穿晶距离);
      if (节点 == null) return;
      const 坐标 = 读取爱蜜莉雅冰晶节点(施法者, 节点);
      if (坐标 == null) return;
      已穿晶 = true;
      // 穿晶：冰晶碎裂 + 分裂冰刃 + D 强化冰弹
      创建点特效({
        模型路径: 爱蜜莉雅Q配置.穿晶特效模型,
        X: 坐标.X,
        Y: 坐标.Y,
        Z: 20,
        缩放: 1.2,
        持续秒: 0.8,
      });
      发射分裂冰刃(施法者, 坐标.X, 坐标.Y, 实例.当前方向角 ?? 基础方向, 技能实例ID);
      发射Q帕克冰弹(施法者, 目标单位, 技能实例ID, 实例.当前方向角 ?? 基础方向);
    },
    on到达点: function Q终点(this: void, 弹幕ID: number, _原因: string): void {
      // 终点生成新冰晶节点（超上限按配置替换最旧）
      const 位置 = 获取弹道当前位置(弹道);
      创建爱蜜莉雅场上冰晶(施法者, "Q", 位置.X, 位置.Y, 爱蜜莉雅Q配置.终点冰晶持续秒);
      void 弹幕ID;
    },
  });

  // 登记技能清理：中断/死亡时销毁弹道
  const 注销 = 登记爱蜜莉雅技能清理(施法者, "Q弹道-" + (技能实例ID ?? 0), function Q弹道清理(this: void): void {
    if (弹道 != null) 弹道.中断();
  });
  void 注销;
}

export function 注册爱蜜莉雅Q(this: void): void {
  注册单位技能壳监听({
    名称: "爱蜜莉雅-冰之矢（Q）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 爱蜜莉雅技能配置.Q.技能ID,
    获取或创建上下文: function Q上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放Q冰之矢,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 6,
  });
}

export {};
