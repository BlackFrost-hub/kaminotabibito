/** @noSelfInFile */

import { 里科特单位技能配置 } from "./00．配置";
import { 获取或创建里科特上下文, 刷新里科特阶段, type 里科特运行时上下文 } from "./01．运行时上下文";
import { 里科特数值与表现配置, 里科特音效配置 } from "./02．数值与表现配置";
import { 播放里科特台词 } from "./10．台词播放";
import { 单位有效, stringToFourCC, 距离平方XY } from "./13．公共工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 创建持续危险区域, type 持续危险区域实例 } from "../../../../00．技能模板+函数/04．机制组件/03．持续危险区/01．持续危险区域";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const ShowUnit = jass.ShowUnit as (whichUnit: any, show: boolean) => void;
const GetRandomInt = jass.GetRandomInt as (lowBound: number, highBound: number) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const { createTimedEffect } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { 获取Boss技能敌对英雄列表, 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  获取Boss技能随机敌对英雄: (this: void, boss: any, centerUnit?: any, radius?: number) => any;
};
const { 施加快速控制Buff, 施加快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速控制Buff: (this: void, source: any, target: any, controlType: number, duration: number) => void;
  施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number) => void;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  施加眩晕: (this: void, source: any, target: any, duration: number) => void;
};
const { X_FixUnitStandingSafe, X_RestoreUnitStandingSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_FixUnitStandingSafe: (this: void, unit: any) => void;
  X_RestoreUnitStandingSafe: (this: void, unit: any) => void;
};

interface 湮灭风场 {
  context: 里科特运行时上下文;
  BossID: number;
  已锁定移动: boolean;
  区域实例?: 持续危险区域实例;
  已结束: boolean;
}

const 里科特单位类型ID = stringToFourCC(里科特单位技能配置.单位ID);
const 湮灭之风技能ID = stringToFourCC(里科特数值与表现配置.湮灭之风.技能槽位);
const 当前湮灭风场表: Record<number, 湮灭风场 | undefined> = {};
let 已注册 = false;

function 结束湮灭之风(this: void, data: 湮灭风场): void {
  if (data.已结束) return;
  data.已结束 = true;
  if (当前湮灭风场表[data.BossID] === data) delete 当前湮灭风场表[data.BossID];
  if (data.区域实例 != null) {
    const 区域实例 = data.区域实例;
    data.区域实例 = undefined;
    区域实例.销毁();
  }
  const boss = data.context.Boss单位;
  if (boss == null || boss === 0) return;
  ShowUnit(boss, true);
  if (data.已锁定移动) X_RestoreUnitStandingSafe(boss);
}

function 清理湮灭之风(this: void, value?: any): void {
  const data = value as 湮灭风场 | undefined;
  if (data != null) 结束湮灭之风(data);
}

function 施加湮灭之风随机控制(this: void, boss: any, hero: any): void {
  const cfg = 里科特数值与表现配置.湮灭之风;
  const roll = GetRandomInt(0, 2);
  if (roll === 0) {
    施加眩晕(boss, hero, cfg.随机眩晕秒);
  } else if (roll === 1) {
    施加快速控制Buff(boss, hero, 2, cfg.随机控制持续秒);
  } else {
    施加快速减速Buff(boss, hero, cfg.随机减速比例, cfg.随机减速比例, cfg.随机减速秒);
  }
}

function 结算湮灭之风一跳(this: void, data: 湮灭风场): void {
  const context = data.context;
  const boss = context.Boss单位;
  if (data.已结束 || !单位有效(boss)) {
    结束湮灭之风(data);
    return;
  }
  const cfg = 里科特数值与表现配置.湮灭之风;
  const bx = GetUnitX(boss);
  const by = GetUnitY(boss);
  const radius2 = cfg.半径 * cfg.半径;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (距离平方XY(GetUnitX(hero), GetUnitY(hero), bx, by) > radius2) continue;
    执行BossAOE技能伤害({
      技能ID: 湮灭之风技能ID,
      来源: boss,
      目标: hero,
      伤害公式: {
        来源攻击力比例: cfg.Boss攻击力比例,
      },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_MAGIC,
      weaponType: WEAPON_TYPE_WHOKNOWS,
    });
    施加快速控制Buff(boss, hero, 2, cfg.沉默秒);
  }
  const randomHero = 获取Boss技能随机敌对英雄(boss, boss, cfg.半径);
  if (单位有效(randomHero)) 施加湮灭之风随机控制(boss, randomHero);
}

export function 释放里科特湮灭之风(this: void, context: 里科特运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 里科特数值与表现配置.湮灭之风;
  const bossId = GetHandleId(boss);
  const current = 当前湮灭风场表[bossId];
  if (current != null) 结束湮灭之风(current);
  const stage = 刷新里科特阶段(context);
  播放里科特台词(boss, "湮灭之风");
  播放Boss坐标音效(里科特音效配置.湮灭之风.风场展开, GetUnitX(boss), GetUnitY(boss), 里科特音效配置.默认裁断距离);
  createTimedEffect(cfg.扩散特效路径, GetUnitX(boss), GetUnitY(boss), 0, cfg.扩散特效持续秒);
  createTimedEffect(cfg.风场特效路径, GetUnitX(boss), GetUnitY(boss), 0, cfg.风场特效持续秒);
  const 应锁定移动 = stage < 3;
  if (应锁定移动) {
    X_FixUnitStandingSafe(boss);
    ShowUnit(boss, false);
  }

  const data: 湮灭风场 = {
    context,
    BossID: bossId,
    已锁定移动: 应锁定移动,
    已结束: false,
  };
  当前湮灭风场表[bossId] = data;
  data.区域实例 = 创建持续危险区域({
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    锚点单位: boss,
    半径: cfg.半径,
    持续时间: cfg.持续秒,
    检测间隔: cfg.tick秒,
    所有者: boss,
    影响目标: "敌方",
    提示圈: {
      类型: "圆形",
      锚点单位: boss,
      半径: cfg.半径,
      持续时间: cfg.持续秒,
      可手动销毁: true,
    },
    on周期: function 里科特湮灭之风区域周期(this: void): void {
      结算湮灭之风一跳(data);
    },
    on销毁: function 里科特湮灭之风区域销毁(this: void): void {
      结束湮灭之风(data);
    },
  });
  context.清理.登记清理("里科特-湮灭之风移动锁", 清理湮灭之风, data);
  if (stage >= 3) {
    启动基础施法时间线({
      名称: "里科特-湮灭之风施法",
      施法者: boss,
      硬直秒: cfg.施法硬直秒,
      生效延迟秒: cfg.持续秒,
      动画编号: 8,
      动画速度: cfg.动画速度,
      后续动画编号: 9,
      后续动画速度: 1,
      后续动画延迟毫秒: cfg.施法动作原始时长秒 * 1000 / cfg.动画速度,
      恢复动画编号: 3,
      清理: context.清理,
      on生效: function 里科特湮灭之风施法表现结束(this: void): void {},
    });
  }
}

function on里科特湮灭之风施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 湮灭之风技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 里科特单位类型ID) return;
  const context = 获取或创建里科特上下文(castingUnit);
  if (context == null) return;
  释放里科特湮灭之风(context);
}

export function 注册里科特湮灭之风(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "08．湮灭之风",
    单位类型ID: 里科特单位类型ID,
    技能ID: 湮灭之风技能ID,
    获取或创建上下文: 获取或创建里科特上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 里科特运行时上下文, boss: any): void {
      on里科特湮灭之风施法(boss, 湮灭之风技能ID);
    },
  });
}
