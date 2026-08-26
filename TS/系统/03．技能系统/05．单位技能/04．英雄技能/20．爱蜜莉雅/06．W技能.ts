/** @noSelfInFile */
/**
 * 爱蜜莉雅 - W：冰花绽放（A5）
 *
 * - 目标点创建冰花 + 真实减速区域（视觉范围不代替判定；判定由持续危险区域承载）。
 * - 持续期间按配置周期结算（伤害/寒意/减速），不每 tick 重建完整特效。
 * - 二段：窗口内再次按 W 锁定方向引爆冰花（扇形冰片 + 引爆伤害），窗口结束后再次按 W 创建新区域。
 * - 自然结束 / 主动引爆 / 打断 / 死亡走可区分的收尾路径（H-01 实例统一收束）。
 */

import { 爱蜜莉雅技能配置, 爱蜜莉雅W配置, 爱蜜莉雅被动配置 } from "./00．配置";
import { 创建战斗技能实例, 查询战斗技能实例 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/27．战斗技能实例生命周期工厂";
import { 播放爱蜜莉雅动作 } from "./02．公共状态与冰晶";
import { 标记目标在爱蜜莉雅区域, 取消标记目标在爱蜜莉雅区域 } from "./04．普攻联动";

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;

const { 创建持续危险区域 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域") as {
  创建持续危险区域: (this: void, 参数: any) => any;
};
const { 施加快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速减速Buff: (this: void, source: any, target: any, as: number, ms: number, time: number, sourceName?: string, sourceType?: "装备" | "技能", displayBuffID?: string) => void;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, 参数: any) => number;
};
const { 发射弹道 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂") as {
  发射弹道: (this: void, 参数: any) => any;
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
const W技能类型ID = jass.FourCC(爱蜜莉雅技能配置.W.技能ID) as number;

interface W冰花数据 {
  区域: any;
  目标X: number;
  目标Y: number;
  已二段: boolean;
}

function W区域内目标结算(this: void, 施法者: any, 区域内单位: any[], 技能实例ID: number | undefined, 伤害值: number, 施加寒意: boolean): void {
  if (区域内单位 == null || 区域内单位.length <= 0) return;
  const 目标列表: any[] = [];
  for (let i = 0; i < 区域内单位.length; i++) 目标列表.push(区域内单位[i]);
  造成批量AOE技能伤害({
    来源: 施法者,
    目标列表,
    伤害: 伤害值,
    伤害类型: DAMAGE_TYPE_COLD,
    来源类型: "单位技能",
    技能ID: W技能类型ID,
    技能实例ID,
    标签: "爱蜜莉雅-W冰花",
    参与技能伤害加成: true,
  });
  if (施加寒意) {
    for (let i = 0; i < 目标列表.length; i++) {
      施加W寒意(施法者, 目标列表[i], 技能实例ID);
    }
  }
}

// 避免循环依赖：寒意由 03 被动提供；此处直接引入函数引用
const { 施加爱蜜莉雅寒意 } = require("./03．被动效果") as {
  施加爱蜜莉雅寒意: (this: void, 施法者: any, 目标: any, 来源键: string) => boolean;
};

function 施加W寒意(this: void, 施法者: any, 目标: any, 技能实例ID: number | undefined): void {
  施加爱蜜莉雅寒意(施法者, 目标, "W:" + (技能实例ID ?? 0));
}

function 二段引爆W(this: void, 施法者: any, 控制器: any, 技能实例ID: number | undefined): void {
  const 数据 = 控制器.数据 as W冰花数据;
  if (数据 == null || 数据.已二段) return;
  数据.已二段 = true;
  const 方向 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), GetSpellTargetX(), GetSpellTargetY());
  const 伤害 = 读取单位攻击力(施法者) * 爱蜜莉雅W配置.二段伤害攻击力倍率;
  const 冰片伤害 = 读取单位攻击力(施法者) * 爱蜜莉雅W配置.冰片伤害攻击力倍率;
  const 区域内单位 = 数据.区域 != null ? 数据.区域.区域效果.当前区域内单位 : [];
  // 引爆伤害（区域内）
  W区域内目标结算(施法者, 区域内单位, 技能实例ID, 伤害, true);
  // 扇形冰片弹幕
  const 数量 = 爱蜜莉雅W配置.冰片数量;
  for (let i = 0; i < 数量; i++) {
    const 偏移 = (i - (数量 - 1) / 2) * 12;
    发射弹道({
      名称: "爱蜜莉雅-W冰片",
      所有者: 施法者,
      发射X: 数据.目标X,
      发射Y: 数据.目标Y,
      发射方向角: 方向 + 偏移,
      速度: 爱蜜莉雅W配置.冰片速度,
      轨迹: { 类型: "直线", 距离: 500 },
      命中半径: 80,
      影响目标: "敌方",
      碰撞消失: true,
      每单位最大命中次数: 1,
      伤害值: 冰片伤害,
      伤害类型: DAMAGE_TYPE_COLD,
      来源类型: "单位技能",
      技能ID: W技能类型ID,
      技能实例ID,
      技能标签: "爱蜜莉雅-W冰片",
      伤害形态: "单体",
      参与技能伤害加成: true,
      模型: 爱蜜莉雅W配置.冰片模型,
      缩放: 0.8,
    });
  }
  // 收束区域（销毁触发 on销毁，不再结算自然结束伤害）
  数据.区域.销毁();
  控制器.完成();
}

function 释放W冰花(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0) return;
  播放爱蜜莉雅动作(施法者, 爱蜜莉雅W配置.动作索引, 0.9);
  // 二段：已有活跃 W 且未二段
  const 活跃列表 = 查询战斗技能实例(施法者, "W冰花");
  for (let i = 0; i < 活跃列表.length; i++) {
    const 活跃 = 活跃列表[i];
    const 数据 = 活跃.数据 as W冰花数据;
    if (数据 != null && !数据.已二段) {
      二段引爆W(施法者, 活跃, 技能实例ID);
      return;
    }
  }

  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 数据: W冰花数据 = { 区域: null, 目标X, 目标Y, 已二段: false };
  const 控制器 = 创建战斗技能实例({
    技能键: "W冰花",
    施法者,
    技能实例ID,
    数据,
    结束回调: function W结束(this: void, _原因: string, _控制器: any): void {
      // 兜底清理（若区域未销毁）
      if (数据.区域 != null) 数据.区域.销毁();
    },
  });

  const 区域 = 创建持续危险区域({
    X: 目标X,
    Y: 目标Y,
    半径: 爱蜜莉雅W配置.半径,
    持续时间: 爱蜜莉雅W配置.持续秒,
    影响目标: "敌方",
    on进入: function W目标进入(this: void, 单位: any): void {
      标记目标在爱蜜莉雅区域(单位);
      施加快速减速Buff(施法者, 单位, 0, 爱蜜莉雅W配置.减速百分比, 爱蜜莉雅W配置.周期秒, "爱蜜莉雅-W", "技能");
    },
    on离开: function W目标离开(this: void, 单位: any): void {
      取消标记目标在爱蜜莉雅区域(单位);
    },
    on周期: function W周期(this: void, 区域内单位: any[]): void {
      // 周期寒意（配置开启时）
      if (爱蜜莉雅W配置.周期施加寒意) {
        for (let i = 0; i < 区域内单位.length; i++) 施加W寒意(施法者, 区域内单位[i], 技能实例ID);
      }
    },
    on销毁: function W区域销毁(this: void): void {
      // 自然结束：绽放伤害 + 标记清理
      if (!数据.已二段) {
        const 区域内单位 = 区域.区域效果.当前区域内单位;
        W区域内目标结算(施法者, 区域内单位, 技能实例ID, 读取单位攻击力(施法者) * 爱蜜莉雅W配置.自然结束伤害攻击力倍率, true);
        for (let i = 0; i < 区域内单位.length; i++) 取消标记目标在爱蜜莉雅区域(区域内单位[i]);
        控制器.完成();
      } else {
        数据.区域 = null;
      }
    },
  });
  数据.区域 = 区域;

  // 冰花 + 寒气边界表现（持续秒自销毁；一套主体不重建）
  创建点特效({
    模型路径: 爱蜜莉雅W配置.冰花模型,
    X: 目标X,
    Y: 目标Y,
    Z: 10,
    缩放: 1,
    持续秒: 爱蜜莉雅W配置.持续秒,
  });
  创建点特效({
    模型路径: 爱蜜莉雅W配置.寒气模型,
    X: 目标X,
    Y: 目标Y,
    Z: 5,
    缩放: 爱蜜莉雅W配置.半径 / 100,
    持续秒: 爱蜜莉雅W配置.持续秒,
  });
}

export function 注册爱蜜莉雅W(this: void): void {
  注册单位技能壳监听({
    名称: "爱蜜莉雅-冰花绽放（W）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 爱蜜莉雅技能配置.W.技能ID,
    获取或创建上下文: function W上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放W冰花,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 爱蜜莉雅W配置.持续秒 + 1,
  });
}

export {};
