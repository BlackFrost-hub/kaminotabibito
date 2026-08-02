/** @noSelfInFile */

import { 里科特单位技能配置 } from "./00．配置";
import { 获取或创建里科特上下文, 刷新里科特阶段, type 里科特阶段, type 里科特运行时上下文 } from "./01．运行时上下文";
import { 里科特数值与表现配置, 里科特音效配置 } from "./02．数值与表现配置";
import { 播放里科特台词 } from "./10．台词播放";
import { 单位有效, stringToFourCC, 取单位间角度 } from "./13．公共工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 提交预计算BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import { 创建延迟改向弹幕, type 延迟改向弹幕上下文 } from "../../../../00．技能模板+函数/00．技能模板/09．复杂战斗模板/03．延迟改向弹幕模板";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能随机敌对英雄: (this: void, boss: any, centerUnit?: any, radius?: number) => any;
};

const 里科特单位类型ID = stringToFourCC(里科特单位技能配置.单位ID);
const 追击风刃技能ID = stringToFourCC(里科特数值与表现配置.追击风刃.技能槽位);
let 已注册 = false;

function 取追击目标(this: void, boss: any): any {
  const target = GetSpellTargetUnit();
  return 单位有效(target) ? target : 获取Boss技能随机敌对英雄(boss, boss, 里科特数值与表现配置.追击风刃.施法距离 + 300);
}

function 取追击风刃阶段改向角度(this: void, context: 里科特运行时上下文, 阶段: 里科特阶段, 上下文: 延迟改向弹幕上下文): number | undefined {
  const cfg = 里科特数值与表现配置.追击风刃;
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(上下文.弹幕单位)) return undefined;
  if (阶段 >= 3) {
    const target = 获取Boss技能随机敌对英雄(boss, boss, 2000);
    return 单位有效(target) ? 取单位间角度(上下文.弹幕单位, target) : undefined;
  }
  return 取单位间角度(上下文.弹幕单位, boss);
}

function 发射追击风刃(this: void, context: 里科特运行时上下文, 阶段: 里科特阶段, angle: number, 起点X: number, 起点Y: number): void {
  const boss = context.Boss单位;
  const cfg = 里科特数值与表现配置.追击风刃;
  const damage = 读取单位攻击力(boss) * cfg.Boss攻击力比例;
  创建延迟改向弹幕({
    名称: "里科特-追击风刃改向",
    清理: context.清理,
    弹幕: {
      所有者: boss,
      所属玩家: GetOwningPlayer(boss),
      X: 起点X,
      Y: 起点Y,
      方向角: angle,
      速度: cfg.速度,
      最大距离: 阶段 === 1 ? cfg.射程 : cfg.射程 * cfg.阶段改向最大距离倍率,
      命中半径: cfg.命中半径,
      影响目标: "敌方",
      碰撞消失: false,
      每单位最大命中次数: 1,
      模型: cfg.模型路径,
      缩放: cfg.缩放,
      飞行高度: cfg.飞行高度,
      on命中: function 里科特追击风刃命中(this: void, target: any): void {
        if (!单位有效(target)) return;
        提交预计算BossAOE技能伤害({
          技能ID: 追击风刃技能ID,
          来源: boss,
          目标: target,
          伤害: damage,
          attack: false,
          ranged: false,
          attackType: ATTACK_TYPE_NORMAL,
          伤害类型: DAMAGE_TYPE_MAGIC,
          weaponType: WEAPON_TYPE_WHOKNOWS,
        });
      },
    },
    自动改向: 阶段 !== 1,
    改向时重置命中记录: 阶段 !== 1,
    改向延迟秒: 阶段 >= 3 ? cfg.P3追踪延迟秒 : cfg.P2回转延迟秒,
    新速度: cfg.速度,
    取改向角度: function 里科特追击风刃取改向角度(this: void, 上下文: 延迟改向弹幕上下文): number | undefined {
      return 取追击风刃阶段改向角度(context, 阶段, 上下文);
    },
  });
}

export function 释放里科特追击风刃(this: void, context: 里科特运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const target = 取追击目标(boss);
  if (!单位有效(target)) return;
  const cfg = 里科特数值与表现配置.追击风刃;
  const 阶段 = 刷新里科特阶段(context);
  const 起点X = GetUnitX(boss);
  const 起点Y = GetUnitY(boss);
  const angle = 取单位间角度(boss, target);
  const 施法预警 = 创建技能提示圈({
    类型: "矩形",
    X: 起点X,
    Y: 起点Y,
    宽度: cfg.命中半径 * 2,
    长度: cfg.射程,
    朝向: angle,
    持续时间: cfg.前摇秒,
    来源单位: boss,
    可手动销毁: true,
  });
  if (施法预警 != null && 施法预警 !== 0) {
    context.清理.登记限时特效("里科特-追击风刃施法预警", 施法预警, cfg.前摇秒 * 1000);
  }
  启动基础施法时间线({
    施法者: boss,
    目标单位: target,
    硬直秒: cfg.前摇秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    恢复动画编号: cfg.恢复动画编号,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.前摇秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
    },
    播放台词: function 里科特追击风刃台词(this: void): void {
      播放里科特台词(boss, "追击风刃");
    },
    on生效: function 里科特追击风刃生效(this: void): void {
      播放Boss坐标音效(里科特音效配置.追击风刃.发射, GetUnitX(boss), GetUnitY(boss), 里科特音效配置.默认裁断距离);
      发射追击风刃(context, 阶段, angle, 起点X, 起点Y);
    },
  });
}

export function 注册里科特追击风刃(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "05．追击风刃",
    单位类型ID: 里科特单位类型ID,
    技能ID: 追击风刃技能ID,
    获取或创建上下文: 获取或创建里科特上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 里科特运行时上下文, boss: any): void {
      on里科特追击风刃生效(boss, 追击风刃技能ID);
    },
  });
}

function on里科特追击风刃生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 追击风刃技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 里科特单位类型ID) return;
  const context = 获取或创建里科特上下文(castingUnit);
  if (context == null) return;
  释放里科特追击风刃(context);
}
