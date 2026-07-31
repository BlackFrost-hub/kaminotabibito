/** @noSelfInFile */

import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 获取或创建米亚上下文 } from "./03．运行时上下文";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚技能数值配置, 米亚音效配置 } from "./02．数值与表现配置";
import { 播放米亚台词 } from "./15．台词播放";
import { 开始米亚常规施法 } from "./19．施法提示";
import { 延迟播放Boss坐标音效, 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 取米亚污染标记伤害倍率 } from "./08．污染标记";
import { 取米亚平台超载伤害倍率 } from "./12．平台超载惩罚";
import { stringToFourCC, 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 执行Boss技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const { 获取Boss技能敌对英雄列表Ex, 获取Boss技能应攻击目标 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表Ex: (this: void, boss: any, centerUnit?: any, radius?: number) => any[];
  获取Boss技能应攻击目标: (this: void, boss: any) => { targetRef: any } | null;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 创建持续危险区域 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域") as {
  创建持续危险区域: (this: void, 参数: any) => any;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { ceil } = require("lib.扩展函数.封装函数.01．通用工具.07．数学运算") as {
  ceil: (this: void, value: number) => number;
};
const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;

const BJ_RADTODEG = 57.29577951308232;
const 米亚单位类型ID = stringToFourCC(米亚单位技能配置.Boss单位ID);
const 污水喷吐技能ID = stringToFourCC(米亚单位技能配置.污水喷吐技能);
let 米亚污水喷吐已注册 = false;

interface 米亚污水喷吐结算变量 {
  context: 米亚运行时上下文;
  朝向: number;
  中心X: number;
  中心Y: number;
}

interface 米亚单位坐标 {
  x: number;
  y: number;
}

interface 米亚污水喷吐表现周期变量 {
  context: 米亚运行时上下文;
  boss: any;
  中心X: number;
  中心Y: number;
  朝向: number;
  当前Tick数: number;
  每Tick伤害倍率: number;
  剩余Tick数: number;
  周期ID: number;
}

function 读取米亚单位坐标(this: void, unit: any): 米亚单位坐标 | undefined {
  if (unit == null || unit === 0) return undefined;
  const x = GetUnitX(unit);
  const y = GetUnitY(unit);
  if (x == null || y == null) return undefined;
  return { x, y };
}

function 点在前方扇形内(this: void, 中心X: number, 中心Y: number, target: any, range: number, halfAngle: number, facing: number): boolean {
  if (target == null || target === 0 || !单位有效(target)) return false;
  const target坐标 = 读取米亚单位坐标(target);
  if (target坐标 == null) return false;
  const dx = target坐标.x - 中心X;
  const dy = target坐标.y - 中心Y;
  const distance2 = dx * dx + dy * dy;
  if (distance2 > range * range) return false;
  const 安全朝向 = facing == null ? 0 : facing;
  const forwardX = CosBJ(安全朝向);
  const forwardY = SinBJ(安全朝向);
  if (forwardX == null || forwardY == null) return false;
  const dot = dx * forwardX + dy * forwardY;
  if (dot <= 0) return false;
  const cosLimit = CosBJ(halfAngle);
  if (cosLimit == null) return false;
  return dot * dot >= distance2 * cosLimit * cosLimit;
}

function 让单位面向目标(this: void, caster: any, target: any, caster坐标?: 米亚单位坐标): void {
  if (!单位有效(caster) || !单位有效(target)) return;
  const 来源坐标 = caster坐标 != null ? caster坐标 : 读取米亚单位坐标(caster);
  const 目标坐标 = 读取米亚单位坐标(target);
  if (来源坐标 == null || 目标坐标 == null) return;
  const angle = Atan2(目标坐标.y - 来源坐标.y, 目标坐标.x - 来源坐标.x) * BJ_RADTODEG;
  if (angle == null) return;
  SetUnitFacing(caster, angle);
}

function 执行米亚污水喷吐伤害Tick(this: void, data: 米亚污水喷吐表现周期变量): void {
  const context = data.context;
  const boss = data.boss;
  const config = 米亚技能数值配置.污水喷吐;
  const targets = 获取Boss技能敌对英雄列表Ex(boss);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!单位有效(target) || !点在前方扇形内(data.中心X, data.中心Y, target, config.喷吐距离, config.喷吐半角, data.朝向)) continue;
    执行Boss技能伤害({
      技能ID: 污水喷吐技能ID,
      来源: boss,
      目标: target,
      伤害公式: {
        来源攻击力比例: config.直接伤害Boss攻击力比例,
        目标最大生命比例: config.直接伤害目标最大生命比例,
        总倍率: config.直接伤害总倍率 * data.每Tick伤害倍率 * 取米亚污染标记伤害倍率(context, target) * 取米亚平台超载伤害倍率(target),
      },
      attackType: jass.ATTACK_TYPE_NORMAL,
      伤害类型: jass.DAMAGE_TYPE_POISON,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      伤害形态: "AOE",
      标签: "米亚污水喷吐Tick",
    });
    if (data.当前Tick数 === 1) {
      添加米亚腐化感染(context, target, config.直接腐化层数, "污水喷吐");
    }
  }
}

function 播放米亚污水喷吐表现Tick(this: void, variable?: any): void {
  const data = variable as 米亚污水喷吐表现周期变量 | undefined;
  if (data == null) return;
  if (data.剩余Tick数 <= 0) {
    if (data.周期ID > 0) {
      removePeriodicCallback(data.周期ID);
      data.周期ID = 0;
    }
    return;
  }
  const context = data.context;
  const boss = data.boss;
  if (context == null || context.清理 == null || context.清理.已清理() || !单位有效(boss)) {
    if (data.周期ID > 0) {
      removePeriodicCallback(data.周期ID);
      data.周期ID = 0;
    }
    return;
  }
  const config = 米亚技能数值配置.污水喷吐;
  const 安全朝向 = data.朝向 == null ? 0 : data.朝向;
  const forwardX = CosBJ(安全朝向);
  const forwardY = SinBJ(安全朝向);
  if (data.中心X == null || data.中心Y == null || forwardX == null || forwardY == null) {
    if (data.周期ID > 0) {
      removePeriodicCallback(data.周期ID);
      data.周期ID = 0;
    }
    return;
  }
  const x = data.中心X + forwardX * config.喷吐特效前移距离;
  const y = data.中心Y + forwardY * config.喷吐特效前移距离;
  创建点特效({
    模型路径: config.喷吐特效路径,
    X: x,
    Y: y,
    Z轴角度: 安全朝向,
    缩放: config.喷吐特效缩放,
    持续秒: config.喷吐特效单次生命周期秒,
    红: config.喷吐特效红,
    绿: config.喷吐特效绿,
    蓝: config.喷吐特效蓝,
    透明度: config.喷吐特效透明度,
  });
  执行米亚污水喷吐伤害Tick(data);
  data.当前Tick数 = data.当前Tick数 + 1;
  data.剩余Tick数 = data.剩余Tick数 - 1;
  if (data.剩余Tick数 <= 0 && data.周期ID > 0) {
    removePeriodicCallback(data.周期ID);
    data.周期ID = 0;
  }
}

function 播放喷吐表现(this: void, context: 米亚运行时上下文, boss: any, 中心X: number, 中心Y: number, facing: number): void {
  if (context == null || context.清理 == null || context.清理.已清理() || boss == null || boss === 0 || !单位有效(boss)) {
    return;
  }
  const config = 米亚技能数值配置.污水喷吐;
  const tick秒 = config.喷吐特效Tick秒;
  const 总Tick数 = tick秒 > 0 ? ceil(config.喷吐特效持续秒 / tick秒) : 0;
  if (总Tick数 <= 0) return;
  const data: 米亚污水喷吐表现周期变量 = {
    context,
    boss,
    中心X,
    中心Y,
    朝向: facing,
    当前Tick数: 1,
    每Tick伤害倍率: 1 / 总Tick数,
    剩余Tick数: 总Tick数,
    周期ID: 0,
  };
  播放米亚污水喷吐表现Tick(data);
  if (data.剩余Tick数 <= 0) return;
  data.周期ID = addPeriodicCallback(tick秒 * 1000, 播放米亚污水喷吐表现Tick, data);
  context.清理.登记周期回调("米亚-污水喷吐表现Tick", data.周期ID);
}

function 创建污水喷吐残留区(this: void, context: 米亚运行时上下文, 中心X: number, 中心Y: number, facing: number): void {
  if (context == null || context.清理 == null || context.清理.已清理()) return;
  const boss = context.Boss单位;
  if (boss == null || boss === 0 || !单位有效(boss)) return;
  const config = 米亚技能数值配置.污水喷吐;
  const 安全朝向 = facing == null ? 0 : facing;
  const forwardX = CosBJ(安全朝向);
  const forwardY = SinBJ(安全朝向);
  if (中心X == null || 中心Y == null || forwardX == null || forwardY == null) return;
  const x = 中心X + forwardX * (config.喷吐距离 * 0.55);
  const y = 中心Y + forwardY * (config.喷吐距离 * 0.55);
  创建持续危险区域({
    X: x,
    Y: y,
    半径: config.残留半径,
    持续时间: config.残留持续秒,
    检测间隔: 1,
    影响目标: "敌方",
    所有者: boss,
    模型路径: 米亚单位技能配置.特效.腐化残留云,
    特效高度: 0,
    提示圈: { 类型: "敌方圆形" },
    on周期: function 米亚污水喷吐残留区周期(this: void, 区域内单位: any[]): void {
      if (context == null || context.清理 == null || context.清理.已清理()) return;
      for (let i = 0; i < 区域内单位.length; i++) {
        添加米亚腐化感染(context, 区域内单位[i], config.残留每秒腐化层数, "污水喷吐残留");
      }
    },
  });
}

function 结算米亚污水喷吐(this: void, variable?: any): void {
  const data = variable as 米亚污水喷吐结算变量 | undefined;
  if (data == null) return;
  const context = data.context;
  if (context == null || context.清理 == null || context.清理.已清理()) return;
  const boss = context.Boss单位;
  const boss有效 = boss != null && boss !== 0 && 单位有效(boss);
  if (!boss有效) return;
  const 中心X = data.中心X;
  const 中心Y = data.中心Y;
  if (中心X == null || 中心Y == null) return;

  const config = 米亚技能数值配置.污水喷吐;
  const 安全朝向 = data.朝向 == null ? GetUnitFacing(boss) : data.朝向;
  const 最终朝向 = 安全朝向 == null ? 0 : 安全朝向;
  SetUnitFacing(boss, 最终朝向);
  播放喷吐表现(context, boss, 中心X, 中心Y, 最终朝向);
  创建污水喷吐残留区(context, 中心X, 中心Y, 最终朝向);

}

export function 释放米亚污水喷吐(this: void, context: 米亚运行时上下文): void {
  if (context == null || context.清理 == null || context.清理.已清理()) return;
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const config = 米亚技能数值配置.污水喷吐;
  const threatTarget = 获取Boss技能应攻击目标(boss)?.targetRef;
  const boss坐标 = 读取米亚单位坐标(boss);
  if (boss坐标 == null) return;
  if (单位有效(threatTarget)) 让单位面向目标(boss, threatTarget, boss坐标);
  const 当前朝向 = GetUnitFacing(boss);
  const facing = 当前朝向 == null ? 0 : 当前朝向;
  SetUnitFacing(boss, facing);
  播放米亚台词(boss, "污水喷吐");
  播放Boss坐标音效(米亚音效配置.污水喷吐.前摇蓄力, boss坐标.x, boss坐标.y, 米亚音效配置.默认裁断距离);
  延迟播放Boss坐标音效(米亚音效配置.污水喷吐.持续喷射, boss坐标.x, boss坐标.y, 米亚音效配置.污水喷吐.持续喷射延迟Ms, 米亚音效配置.默认裁断距离);
  开始米亚常规施法(boss, config.总硬直秒, "污水喷吐", `1秒后向正面喷吐${config.喷吐特效持续秒}秒，范围${config.喷吐距离}码、${config.喷吐半角 * 2}°扇形（离开米亚正面）`, config.总硬直秒);
  SetUnitTimeScale(boss, config.动画速度);
  SetUnitAnimationByIndex(boss, config.动画编号);
  创建技能提示圈({
    类型: "红色扇形",
    X: boss坐标.x,
    Y: boss坐标.y,
    半径: config.喷吐距离,
    扇形角度: config.喷吐半角 * 2,
    朝向: facing,
    持续时间: config.前摇秒,
    来源单位: boss,
  });
  const delayedId = addDelayedCallback(config.前摇秒 * 1000, 结算米亚污水喷吐, {
    context,
    朝向: facing,
    中心X: boss坐标.x,
    中心Y: boss坐标.y,
  } as 米亚污水喷吐结算变量);
  context.清理.登记延迟回调("米亚-污水喷吐结算", delayedId);
}

export function 注册米亚污水喷吐(this: void): void {
  if (米亚污水喷吐已注册) return;
  米亚污水喷吐已注册 = true;
  注册单位技能壳监听({
    名称: "米亚-污水喷吐",
    单位类型ID: 米亚单位类型ID,
    技能ID: 污水喷吐技能ID,
    获取或创建上下文: 获取或创建米亚上下文,
    释放技能: function 米亚污水喷吐监听释放(this: void, _context: 米亚运行时上下文, boss: any): void {
      on米亚污水喷吐生效(boss, 污水喷吐技能ID);
    },
  });
}

function on米亚污水喷吐生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 污水喷吐技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 米亚单位类型ID) return;
  const context = 获取或创建米亚上下文(castingUnit);
  if (context == null) return;
  释放米亚污水喷吐(context);
}
