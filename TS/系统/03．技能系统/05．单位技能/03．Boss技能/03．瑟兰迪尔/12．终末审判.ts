/** @noSelfInFile */

import type { 瑟兰迪尔运行时上下文 } from "./03．运行时上下文";
import { 瑟兰迪尔数值与表现配置 } from "./02．数值与表现配置";
import { 播放瑟兰迪尔台词 } from "./15．台词播放";

const { getServerTime, addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const { 显示大招吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示大招吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { 创建白色圆形提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效") as {
  创建白色圆形提示圈: (this: void, x: number, y: number, r: number, time: number, speed?: number) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};

const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const R2I = jass.R2I as (value: number) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 距离平方(this: void, ax: number, ay: number, bx: number, by: number): number {
  const dx = ax - bx;
  const dy = ay - by;
  return dx * dx + dy * dy;
}

function 播放点特效(this: void, model: string, x: number, y: number, duration = 1, scale = 1): void {
  const effect = AddSpecialEffect(model, x, y);
  if (effect != null && effect !== 0) {
    if (scale !== 1) EXSetEffectSize(effect, scale);
    YDWETimerDestroyEffectSafe(duration, effect);
  }
}

function 播放Boss蓄力Tick(this: void, boss: any): void {
  const config = 瑟兰迪尔数值与表现配置.终末审判;
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  SetUnitTimeScale(boss, 1);
  SetUnitAnimationByIndex(boss, 8);
  播放点特效(config.蓄力特效, x, y, 0.6, config.蓄力法阵缩放);
  播放点特效(config.法阵叠加特效, x, y, 0.6, config.蓄力法阵缩放);
}

function 创建终末审判爆炸特效(this: void, x: number, y: number): void {
  const config = 瑟兰迪尔数值与表现配置.终末审判;
  播放点特效(config.爆炸特效, x, y, 2);
  播放点特效(config.爆炸特效2, x, y, 2);
  播放点特效(config.爆炸特效3, x, y, 2);
}

function 计算爆炸特效前置延迟毫秒(this: void): number {
  const config = 瑟兰迪尔数值与表现配置.终末审判;
  const delayMs = R2I(config.爆炸延迟秒 * 1000) - config.爆炸特效提前毫秒;
  if (delayMs < 0) return 0;
  return delayMs;
}

export function 尝试触发瑟兰迪尔终末审判(this: void, context: 瑟兰迪尔运行时上下文): void {
  const config = 瑟兰迪尔数值与表现配置.终末审判;
  const now = getServerTime();
  if (context.上次终末审判Ms > 0 && now - context.上次终末审判Ms < config.周期秒 * 1000) return;
  context.上次终末审判Ms = now;
  释放瑟兰迪尔终末审判(context);
}

export function 释放瑟兰迪尔终末审判(this: void, context: 瑟兰迪尔运行时上下文): void {
  const config = 瑟兰迪尔数值与表现配置.终末审判;
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  播放瑟兰迪尔台词(boss, "终末审判");
  开始硬直(boss, config.引导秒);
  显示大招吟唱条({
    总时长: config.引导秒,
    颜色ID: config.吟唱条颜色ID,
    标题文本: config.吟唱条标题文本,
    提示文本: config.吟唱条提示文本,
  });
  播放Boss蓄力Tick(boss);

  const 蓄力TickID = addPeriodicCallback(config.蓄力Tick毫秒, function 瑟兰迪尔终末审判蓄力Tick(this: void): void {
    if (!单位有效(boss)) {
      removePeriodicCallback(蓄力TickID);
      关闭吟唱条("大招");
      return;
    }
    播放Boss蓄力Tick(boss);
  });

  addDelayedCallback(R2I(config.引导秒 * 1000), function 瑟兰迪尔终末审判布阵(this: void): void {
    removePeriodicCallback(蓄力TickID);
    关闭吟唱条("大招");
    if (!单位有效(boss)) return;
    SetUnitAnimationByIndex(boss, 5);
    const bossX = GetUnitX(boss);
    const bossY = GetUnitY(boss);
    播放点特效(config.蓄力完成特效, bossX, bossY, 2, config.蓄力完成冲击缩放);
    播放点特效(config.警示特效, bossX, bossY, config.爆炸延迟秒 + 0.5, config.场地法阵缩放);
    播放点特效(config.法阵叠加特效, bossX, bossY, config.爆炸延迟秒 + 0.5, config.场地法阵缩放);
    创建白色圆形提示圈(bossX, bossY, config.安全区半径, config.爆炸延迟秒 + 0.5);
    const heroes = 获取Boss技能敌对英雄列表(boss);
    const xs: number[] = [];
    const ys: number[] = [];
    const targets: any[] = [];
    for (let i = 0; i < heroes.length; i++) {
      const target = heroes[i];
      xs.push(GetUnitX(target));
      ys.push(GetUnitY(target));
      targets.push(target);
    }

    addDelayedCallback(500, function 瑟兰迪尔终末审判恢复动作(this: void): void {
      if (!单位有效(boss)) return;
      SetUnitTimeScale(boss, 1);
      SetUnitAnimationByIndex(boss, 0);
    });

    addDelayedCallback(计算爆炸特效前置延迟毫秒(), function 瑟兰迪尔终末审判爆炸预表现(this: void): void {
      if (!单位有效(boss)) return;
      for (let i = 0; i < targets.length; i++) {
        if (!单位有效(targets[i])) continue;
        创建终末审判爆炸特效(xs[i], ys[i]);
      }
    });

    addDelayedCallback(R2I(config.爆炸延迟秒 * 1000), function 瑟兰迪尔终末审判伤害结算(this: void): void {
      if (!单位有效(boss)) return;
      const bossX = GetUnitX(boss);
      const bossY = GetUnitY(boss);
      const safeRadius2 = config.安全区半径 * config.安全区半径;
      for (let i = 0; i < targets.length; i++) {
        const target = targets[i];
        if (!单位有效(target)) continue;
        if (距离平方(GetUnitX(target), GetUnitY(target), bossX, bossY) > safeRadius2) {
          const damage = (读取单位攻击力(boss) * config.爆炸伤害Boss攻击力比例
            + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config.爆炸伤害目标最大生命比例) * config.爆炸伤害总倍率;
          造成AOE技能伤害({
            来源: boss,
            目标: target,
            伤害: damage,
            attack: false,
            ranged: false,
            attackType: jass.ATTACK_TYPE_NORMAL,
            伤害类型: jass.DAMAGE_TYPE_MAGIC,
            weaponType: jass.WEAPON_TYPE_WHOKNOWS,
            来源类型: "Boss技能",
          });
        }
      }
    });
  });
}

export function 注册瑟兰迪尔终末审判(this: void): void {
}
