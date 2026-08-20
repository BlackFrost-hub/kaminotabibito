/** @noSelfInFile */

import { 克劳德单位技能配置 } from "./00．配置";
import { 消耗空牙Q联动 } from "./00A．联动状态";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力, 单位存活, 两点角度 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean) => number;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, 参数: any) => number;
};
const { 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始击退: (this: void, unit: any, 参数: any) => number;
};
const { 开始跳跃作为被击退击飞 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.03．对外接口") as {
  开始跳跃作为被击退击飞: (this: void, unit: any, 参数: any) => number;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 施加单体护甲降低Buff } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.04．护甲降低") as {
  施加单体护甲降低Buff: (this: void, source: any, target: any, 参数: any) => boolean;
};
const { getTargetArmor: getTargetArmor普通版 } = require("系统.04．伤害系统.00．伤害计算.01．属性读取") as {
  getTargetArmor: (this: void, self: undefined, target: any) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { X_SetUnitMovableSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_SetUnitMovableSafe: (this: void, unit: any, movable: boolean) => void;
};
const { 获取范围敌军, 在坐标播放特效 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
  在坐标播放特效: (model: string, x: number, y: number, z: number, size: number, lifeSec: number) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { CreateFloatTextAtPoint } = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字") as {
  CreateFloatTextAtPoint: (this: void, x: number, y: number, text: string, options?: any) => any;
};
const { 创建原生弹幕, 获取原生弹幕, 销毁原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: any) => { 弹幕ID: number; 销毁: (this: void, 原因?: string) => void };
  获取原生弹幕: (this: void, id: number) => any;
  销毁原生弹幕: (this: void, id: number, 原因?: string) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, 模块名: string, ...参数: any[]) => void;
};
const 模块名 = "克劳德-Q";
const 施法暂停来源 = "克劳德-Q-施法";
const { PlaySoundOnUnitBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, unit: any) => void;
};

const 获取句柄ID = jass.GetHandleId as (this: void, handle: any) => number;
const 获取技能目标单位 = jass.GetSpellTargetUnit as (this: void) => any;
const 获取技能目标X = jass.GetSpellTargetX as (this: void) => number;
const 获取技能目标Y = jass.GetSpellTargetY as (this: void) => number;
const 获取单位X = jass.GetUnitX as (this: void, unit: any) => number;
const 获取单位Y = jass.GetUnitY as (this: void, unit: any) => number;
const 获取单位类型ID = jass.GetUnitTypeId as (this: void, unit: any) => number;
const 获取单位拥有者 = jass.GetOwningPlayer as (this: void, unit: any) => any;
const 获取单位状态 = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const 判断单位类型 = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const 判断敌对 = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const 设置时间流速 = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const 设置单位飞行高度 = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const 获取单位飞行高度 = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const 获取单位默认飞行高度 = jass.GetUnitDefaultFlyHeight as (this: void, unit: any) => number;
const 设置单位X = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const 设置单位Y = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const 判断地形可行走 = jass.IsTerrainPathable as (this: void, x: number, y: number, pathingType: any) => boolean;
const 随机实数 = jass.GetRandomReal as (this: void, min: number, max: number) => number;
const 设置动作 = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const 设置技能可用 = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const 添加技能 = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const 移除技能 = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;
const 计算余弦 = jass.Cos as (this: void, radians: number) => number;
const 计算正弦 = jass.Sin as (this: void, radians: number) => number;
const 角度转弧度 = jass.bj_DEGTORAD as number;
const 最大魔法状态 = jass.UNIT_STATE_MAX_MANA as any;
const 当前魔法状态 = jass.UNIT_STATE_MANA as any;
const 敌方单位类型 = jass.UNIT_TYPE_ANCIENT as any;
const 机械单位类型 = jass.UNIT_TYPE_MECHANICAL as any;
const 攻击类型 = jass.ATTACK_TYPE_NORMAL as any;
const 魔法伤害类型 = jass.DAMAGE_TYPE_MAGIC as any;
const 未知武器类型 = jass.WEAPON_TYPE_WHOKNOWS as any;
const 普通伤害类型 = jass.DAMAGE_TYPE_NORMAL as any;
const 可行走路径类型 = jass.PATHING_TYPE_WALKABILITY as any;

const 配置 = 克劳德单位技能配置.Q;
const 联动配置 = 克劳德单位技能配置.W;
const 单位类型ID = stringToFourCCSafe(克劳德单位技能配置.单位ID);
const 初段技能ID = stringToFourCCSafe(配置.初段技能ID);
const 二段技能ID = stringToFourCCSafe(配置.二段技能ID);
const 三段技能ID = stringToFourCCSafe(配置.三段技能ID);
interface 克劳德Q状态 {
  施法者: any;
  阶段: 0 | 1 | 2;
  进行中: boolean;
  等待输入: boolean;
  代次: number;
  蓄力回调ID: number;
  施法硬直回调ID: number;
  施法硬直代次: number;
  蓄力站桩中: boolean;
  追加输入次数: number;
  目标单位: any;
  目标X: number;
  目标Y: number;
  方向角: number;
  技能实例ID?: number;
  弹幕ID: number;
  路径特效累计秒: number;
  空牙联动: boolean;
  空牙联动方向: number;
}

interface Q蓄力回调参数 {
  状态: 克劳德Q状态;
  代次: number;
}

interface Q施法硬直回调参数 {
  状态: 克劳德Q状态;
  代次: number;
}

interface Q命中表现状态 {
  施法者: any;
  目标: any;
  模式: "初段上升" | "初段下降" | "二段乱斩" | "三段上升" | "三段下降";
  Tick: number;
  累计毫秒: number;
  初始X: number;
  初始Y: number;
  方向角: number;
  总伤害: number;
  已结算伤害: Record<number, number>;
}

const 状态表: Record<number, 克劳德Q状态 | undefined> = {};
const 弹幕状态表: Record<number, 克劳德Q状态 | undefined> = {};
const Q命中表现表: Record<number, Q命中表现状态 | undefined> = {};
let 下一个Q命中表现ID = 0;
let Q命中表现驱动ID = 0;

function 创建Q命中表现(this: void, caster: any, target: any, 模式: Q命中表现状态["模式"], 方向角: number): Q命中表现状态 {
  下一个Q命中表现ID += 1;
  const id = 下一个Q命中表现ID;
  const 表现: Q命中表现状态 = {
    施法者: caster,
    目标: target,
    模式,
    Tick: 0,
    累计毫秒: 0,
    初始X: 获取单位X(target),
    初始Y: 获取单位Y(target),
    方向角,
    总伤害: 模式 === "二段乱斩" ? 读取单位攻击力(caster) * 配置.二段伤害倍率 : 0,
    已结算伤害: {},
  };
  Q命中表现表[id] = 表现;
  return 表现;
}

function 清理Q命中表现(this: void, id: number): void {
  const 表现 = Q命中表现表[id];
  if (表现 == null) return;
  if (单位存活(表现.目标)) {
    移除单位暂停(表现.目标, `克劳德-Q-命中表现-${id}`);
    设置单位飞行高度(表现.目标, 获取单位默认飞行高度(表现.目标), 0);
    设置时间流速(表现.目标, 1);
    设置动作(表现.目标, 0);
  }
  delete Q命中表现表[id];
}

function Q命中表现Tick(this: void, id: number, 间隔毫秒: number): void {
  const 表现 = Q命中表现表[id];
  if (表现 == null || !单位存活(表现.目标) || !单位存活(表现.施法者)) {
    清理Q命中表现(id);
    return;
  }
  表现.累计毫秒 += 10;
  if (表现.累计毫秒 < 间隔毫秒) return;
  表现.累计毫秒 = 0;
  const target = 表现.目标;
  const source = `克劳德-Q-命中表现-${id}`;
  if (表现.模式 === "初段上升" || 表现.模式 === "初段下降") {
    表现.Tick += 1;
    const delta = 表现.模式 === "初段上升" ? 配置.初段每Tick高度 : -配置.初段每Tick高度;
    设置单位飞行高度(target, 获取单位飞行高度(target) + delta, 0);
    if (表现.Tick >= 配置.初段升降Tick数) {
      if (表现.模式 === "初段上升") {
        表现.模式 = "初段下降";
        表现.Tick = 0;
      } else {
        清理Q命中表现(id);
      }
    }
    return;
  }
  if (表现.模式 === "二段乱斩") {
    表现.Tick += 1;
    const 斩击面向角度 = 随机实数(0, 360);
    const angle = 斩击面向角度 * 角度转弧度;
    const radius = 随机实数(配置.二段乱斩随机半径最小值, 配置.二段乱斩随机半径最大值);
    const x = 表现.初始X + 计算余弦(angle) * radius;
    const y = 表现.初始Y + 计算正弦(angle) * radius;
    if (!判断地形可行走(x, y, 可行走路径类型)) {
      设置单位X(target, x);
      设置单位Y(target, y);
    }
    const targets = 获取范围敌军(表现.施法者, x, y, 100);
    const 进度值 = 表现.Tick / 配置.二段乱斩Tick数;
    const 当前进度 = 进度值 > 1 ? 1 : 进度值;
    const 当前应结算总额 = 表现.总伤害 * 当前进度;
    const 待结算目标: any[] = [];
    const 待结算伤害: number[] = [];
    for (const hitTarget of targets) {
      if (!目标合法(表现.施法者, hitTarget)) continue;
      const targetId = 获取句柄ID(hitTarget);
      const 已结算 = 表现.已结算伤害[targetId] ?? 0;
      const 本次伤害 = 当前应结算总额 - 已结算;
      if (本次伤害 <= 0) continue;
      表现.已结算伤害[targetId] = 已结算 + 本次伤害;
      待结算目标.push(hitTarget);
      待结算伤害.push(本次伤害);
    }
    for (let index = 0; index < 待结算目标.length; index += 1) {
      造成批量AOE技能伤害({ 来源: 表现.施法者, 目标列表: [待结算目标[index]], 伤害: 待结算伤害[index], 伤害类型: 魔法伤害类型, attack: true, ranged: false, attackType: 攻击类型, weaponType: 未知武器类型, 来源类型: "单位技能", 技能ID: 二段技能ID, 标签: "克劳德-Q-二段剑气切割" });
    }
    const 斩击Z = 获取单位飞行高度(target) + 随机实数(配置.二段乱斩随机高度最小值, 配置.二段乱斩随机高度最大值);
    创建点特效({ 模型路径: 配置.二段乱斩特效模型, X: x, Y: y, Z: 斩击Z, 面向角度: 斩击面向角度, 缩放: 配置.二段乱斩特效缩放, 动画速度: 配置.二段乱斩特效速度, 持续秒: 配置.二段乱斩特效持续秒 });
    创建点特效({ 模型路径: 配置.二段乱斩叠加特效模型, X: x, Y: y, Z: 斩击Z, 面向角度: 斩击面向角度, 缩放: 配置.二段乱斩叠加特效缩放, 动画速度: 配置.二段乱斩叠加特效速度, 持续秒: 配置.二段乱斩叠加特效持续秒 });
    if (表现.Tick >= 配置.二段乱斩Tick数) 清理Q命中表现(id);
    return;
  }
  表现.Tick += 1;
  const delta = 表现.模式 === "三段上升" ? 配置.三段每Tick高度 : -配置.三段每Tick高度;
  设置单位飞行高度(target, 获取单位飞行高度(target) + delta, 0);
  const x = 获取单位X(target) + 计算余弦(表现.方向角 * 角度转弧度) * 配置.三段每Tick前进距离;
  const y = 获取单位Y(target) + 计算正弦(表现.方向角 * 角度转弧度) * 配置.三段每Tick前进距离;
  if (!判断地形可行走(x, y, 可行走路径类型)) { 设置单位X(target, x); 设置单位Y(target, y); }
  if (表现.Tick >= (表现.模式 === "三段上升" ? 配置.三段升降Tick数 : 配置.三段下降Tick数)) {
    if (表现.模式 === "三段上升") {
      表现.模式 = "三段下降";
      表现.Tick = 0;
    } else {
      清理Q命中表现(id);
    }
  }
}

function Q命中表现驱动(this: void): void {
  for (const key in Q命中表现表) {
    const id = Number(key);
    const 表现 = Q命中表现表[id];
    if (表现 == null) continue;
    const 间隔毫秒 = 表现.模式 === "初段上升" || 表现.模式 === "初段下降" || 表现.模式 === "二段乱斩" || 表现.模式 === "三段上升"
      ? 配置.初段升降间隔秒 * 1000
      : 配置.三段下降间隔秒 * 1000;
    Q命中表现Tick(id, 间隔毫秒);
  }
  if (Object.keys(Q命中表现表).length === 0 && Q命中表现驱动ID > 0) {
    removePeriodicCallback(Q命中表现驱动ID);
    Q命中表现驱动ID = 0;
  }
}

function 启动Q命中表现(this: void, caster: any, target: any, 模式: Q命中表现状态["模式"], 方向角: number, 间隔秒: number): void {
  const 表现 = 创建Q命中表现(caster, target, 模式, 方向角);
  const id = 下一个Q命中表现ID;
  添加单位暂停(target, `克劳德-Q-命中表现-${id}`);
  设置时间流速(target, 配置.命中动作速度);
  设置动作(target, 2);
  表现.累计毫秒 = 0;
  if (Q命中表现驱动ID === 0) Q命中表现驱动ID = addPeriodicCallback(10, Q命中表现驱动);
}

function 读取目标护甲(this: void, target: any): number {
  return getTargetArmor普通版(undefined, target);
}

function 获取或创建Q状态(this: void, unit: any): 克劳德Q状态 {
  const id = 获取句柄ID(unit);
  let state = 状态表[id];
  if (state == null) {
    state = {
      施法者: unit,
      阶段: 0,
      进行中: false,
      等待输入: false,
      代次: 0,
      蓄力回调ID: 0,
      施法硬直回调ID: 0,
      施法硬直代次: 0,
      蓄力站桩中: false,
      追加输入次数: 0,
      目标单位: null,
      目标X: 0,
      目标Y: 0,
      方向角: 0,
      弹幕ID: 0,
      路径特效累计秒: 0,
      空牙联动: false,
      空牙联动方向: 0,
    };
    状态表[id] = state;
  }
  return state;
}

function 播放Q音效(this: void, caster: any, 强化: boolean): void {
  const key = 强化 ? 配置.强化音效键 : 配置.初段音效键;
  const sound = jglobals[key];
  if (sound != null) PlaySoundOnUnitBJ(sound, 100, caster);
}

function 播放Q蓄力表现(this: void, caster: any, count: number): void {
  const text = count > 2 ? 配置.蓄力超出提示 : `${count}Hit`;
  const x = 获取单位X(caster);
  const y = 获取单位Y(caster);
  CreateFloatTextAtPoint(x, y, text, {
    size: 配置.蓄力文字大小,
    height: 配置.蓄力文字高度,
    red: 100,
    green: 20,
    blue: 20,
    alpha: 0,
    duration: 1,
    speedX: 0,
    speedY: 0.1,
  });
  创建点特效({
    模型路径: 配置.蓄力特效模型,
    X: x,
    Y: y,
    Z: 0,
    动画速度: 配置.蓄力特效速度,
    持续秒: 1,
  });
}

function 目标合法(this: void, caster: any, target: any): boolean {
  if (target == null || target === 0 || !单位存活(target)) return false;
  if (判断单位类型(target, 敌方单位类型) || 判断单位类型(target, 机械单位类型)) return false;
  return 判断敌对(target, 获取单位拥有者(caster));
}

function Q是否锁定目标(this: void, state: 克劳德Q状态): boolean {
  return !state.空牙联动 && state.目标单位 != null && state.目标单位 !== 0;
}

function 过滤Q弹幕目标(this: void, target: any, projectileId: number): boolean {
  const state = 弹幕状态表[projectileId];
  if (state == null) return false;
  if (Q是否锁定目标(state)) return target === state.目标单位 && 目标合法(state.施法者, target);
  return 目标合法(state.施法者, target);
}

function 播放Q爆炸(this: void, caster: any, x: number, y: number, radius: number, damage: number, state: 克劳德Q状态): void {
  在坐标播放特效(配置.爆炸模型, x, y, 0, 配置.爆炸缩放, 1.5);
  const targets = 获取范围敌军(caster, x, y, radius);
  const validTargets: any[] = [];
  for (const target of targets) {
    if (目标合法(caster, target)) validTargets.push(target);
  }
  if (validTargets.length === 0) return;
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: validTargets,
    伤害: damage,
    伤害类型: 魔法伤害类型,
    attack: true,
    ranged: false,
    attackType: 攻击类型,
    weaponType: 未知武器类型,
    来源类型: "单位技能",
    技能ID: 初段技能ID,
    技能实例ID: state.技能实例ID,
    标签: "克劳德-Q-剑气爆炸",
  });
}

function 处理Q命中(this: void, target: any, projectileId: number): void {
  const state = 弹幕状态表[projectileId];
  if (state == null || !state.进行中) {
    debugLogForce(模块名, "命中回调 状态无效", "弹幕ID", projectileId, "目标", target == null ? "nil" : 获取句柄ID(target));
    return;
  }
  const caster = state.施法者;
  debugLogForce(模块名, "命中回调进入", "弹幕ID", projectileId, "阶段", state.阶段, "目标", target == null ? "nil" : 获取句柄ID(target), "空牙联动", state.空牙联动);
  if (!单位存活(caster) || !目标合法(caster, target)) {
    debugLogForce(模块名, "命中回调 施法者或目标不合法", "施法者存活", 单位存活(caster), "目标ID", target == null ? "nil" : 获取句柄ID(target));
    return;
  }

  if (state.空牙联动) {
    施加眩晕(caster, target, 联动配置.空牙Q联动击飞秒, "克劳德-空牙联动Q-击飞", "技能");
    开始击退(target, {
      角度: state.空牙联动方向,
      距离: 联动配置.空牙Q联动击退距离,
      持续时间: 联动配置.空牙Q联动击飞秒,
      检查地形: true,
      暂停单位: false,
      禁用碰撞: true,
      来源单位: caster,
    });
    const armor = 读取目标护甲(target);
    if (armor > 0) {
      施加单体护甲降低Buff(caster, target, {
        BuffID: 联动配置.空牙Q联动护甲BuffID,
        持续时间: 联动配置.空牙Q联动护甲降低秒,
        护甲: armor * 联动配置.空牙Q联动护甲降低比例,
        叠加键: `克劳德-空牙联动Q-${获取句柄ID(caster)}`,
        效果来源名称: "克劳德-空牙联动Q",
        效果来源类型: "技能",
      });
    }
    return;
  }

  if (state.阶段 === 0) {
    debugLogForce(模块名, "命中结算 初段", "目标", 获取句柄ID(target), "施放击飞/爆炸");
    施加眩晕(caster, target, 配置.基础击飞秒, "克劳德-Q-基础击飞", "技能");
    启动Q命中表现(caster, target, "初段上升", state.方向角, 配置.初段升降间隔秒);
    开始击退(target, {
      角度: state.方向角,
      距离: 配置.基础击飞距离,
      持续时间: 配置.基础击飞秒,
      检查地形: true,
      暂停单位: false,
      禁用碰撞: true,
      来源单位: caster,
    });
    if (state.目标单位 != null) {
      const projectile = 获取原生弹幕(projectileId);
      if (projectile != null) {
        播放Q爆炸(caster, projectile.当前X, projectile.当前Y, 配置.指定目标爆炸范围, 读取单位攻击力(caster) * 配置.普通伤害倍率, state);
        销毁原生弹幕(projectileId, "命中消失");
      }
    }
  } else if (state.阶段 === 1) {
    debugLogForce(模块名, "命中结算 二段", "目标", 获取句柄ID(target));
    施加眩晕(caster, target, 配置.二段控制秒, "克劳德-Q-二段切割", "技能");
    启动Q命中表现(caster, target, "二段乱斩", state.方向角, 配置.二段乱斩间隔秒);
  } else {
    debugLogForce(模块名, "命中结算 三段", "目标", 获取句柄ID(target), "施放同方向跳跃击飞");
    设置动作(target, 2);
    设置时间流速(target, 配置.命中动作速度);
    开始跳跃作为被击退击飞(target, {
      角度: state.方向角,
      距离: 配置.三段跳跃距离,
      持续时间: 配置.三段跳跃持续秒,
      跳跃高度: 配置.三段跳跃高度,
      主单位: caster,
      主单位死亡时中断: true,
      暂停单位: true,
      朝向跟随跳跃: true,
    });
  }
}

function 处理Q到达终点(this: void, projectileId: number): void {
  const state = 弹幕状态表[projectileId];
  if (state == null || !state.进行中 || state.阶段 !== 0 || state.空牙联动) {
    debugLogForce(模块名, "到达终点 条件不符 忽略", "弹幕ID", projectileId, "状态存在", state != null, "阶段", state?.阶段, "空牙联动", state?.空牙联动);
    return;
  }
  const projectile = 获取原生弹幕(projectileId);
  if (projectile == null) {
    debugLogForce(模块名, "到达终点 弹幕对象不存在", "弹幕ID", projectileId);
    return;
  }
  debugLogForce(模块名, "到达终点 结算爆炸", "弹幕ID", projectileId, "X", projectile.当前X, "Y", projectile.当前Y);
  播放Q爆炸(state.施法者, projectile.当前X, projectile.当前Y, state.目标单位 != null ? 配置.指定目标爆炸范围 : 配置.普通末端范围, 读取单位攻击力(state.施法者) * 配置.普通伤害倍率, state);
}

function Q弹幕Tick(this: void, instance: any, _delta: number): void {
  const projectileId = instance.id as number;
  const state = 弹幕状态表[projectileId];
  // Q2 使用命中后的乱斩表现，只有 Q3/联动强化段生成持续路径剑气。
  if (state == null || !state.进行中 || state.阶段 !== 2) return;
  state.路径特效累计秒 += _delta;
  if (state.路径特效累计秒 < 配置.路径特效间隔秒) return;
  state.路径特效累计秒 -= 配置.路径特效间隔秒;
  const 剑气特效 = 创建点特效({
    模型路径: 配置.剑气模型,
    X: instance.当前X,
    Y: instance.当前Y,
    Z: 0,
    缩放: 配置.强化缩放,
  });
  if (剑气特效 != null && 剑气特效 !== 0) YDWETimerDestroyEffectSafe(配置.路径特效持续秒, 剑气特效);
  const 附加特效 = 创建点特效({
    模型路径: 配置.路径附加模型,
    X: instance.当前X,
    Y: instance.当前Y,
    Z: 0,
    缩放: 配置.路径附加缩放,
  });
  if (附加特效 != null && 附加特效 !== 0) YDWETimerDestroyEffectSafe(配置.路径特效持续秒, 附加特效);
}

function 清理Q施法硬直(this: void, state: 克劳德Q状态): void {
  if (state.施法硬直回调ID !== 0) {
    removeDelayedCallback(state.施法硬直回调ID);
    state.施法硬直回调ID = 0;
  }
  state.施法硬直代次 = 0;
  if (state.施法者 != null && state.施法者 !== 0) 移除单位暂停(state.施法者, 施法暂停来源);
}

function 清理Q状态(this: void, state: 克劳德Q状态, 保留施法硬直: boolean = false): void {
  if (!state.进行中) {
    if (!保留施法硬直) 清理Q施法硬直(state);
    return;
  }
  state.进行中 = false;
  state.等待输入 = false;
  state.代次 += 1;
  const caster = state.施法者;
  debugLogForce(模块名, "清理Q状态", "施法者", caster == null || caster === 0 ? "nil" : 获取句柄ID(caster), "阶段", state.阶段, "弹幕ID", state.弹幕ID);
  if (state.蓄力回调ID !== 0) {
    removeDelayedCallback(state.蓄力回调ID);
    state.蓄力回调ID = 0;
  }
  if (!保留施法硬直) 清理Q施法硬直(state);
  if (state.弹幕ID !== 0) {
    const projectileId = state.弹幕ID;
    state.弹幕ID = 0;
    delete 弹幕状态表[projectileId];
    if (获取原生弹幕(projectileId) != null) 销毁原生弹幕(projectileId, "手动销毁");
  }
  if (caster != null && caster !== 0) {
    if (state.蓄力站桩中) X_SetUnitMovableSafe(caster, true);
    if (!保留施法硬直) 移除单位暂停(caster, 施法暂停来源);
    设置时间流速(caster, 1);
    设置技能可用(获取单位拥有者(caster), 初段技能ID, true);
    移除技能(caster, 二段技能ID);
    移除技能(caster, 三段技能ID);
    设置技能可用(获取单位拥有者(caster), 二段技能ID, false);
    设置技能可用(获取单位拥有者(caster), 三段技能ID, false);
  }
  state.蓄力站桩中 = false;
  state.追加输入次数 = 0;
  state.阶段 = 0;
  state.技能实例ID = undefined;
  state.空牙联动 = false;
  state.空牙联动方向 = 0;
}

function Q施法硬直结束(this: void, variable?: any): void {
  const 参数 = variable as Q施法硬直回调参数 | undefined;
  if (参数 == null) return;
  const state = 参数.状态;
  if (state.施法硬直代次 !== 参数.代次) return;
  state.施法硬直回调ID = 0;
  state.施法硬直代次 = 0;
  if (state.施法者 == null || state.施法者 === 0) return;
  移除单位暂停(state.施法者, 施法暂停来源);
  debugLogForce(模块名, "Q施法硬直结束", "施法者", 获取句柄ID(state.施法者), "阶段", state.阶段, "追加输入次数", state.追加输入次数);
}

function Q弹幕结束(this: void, _reason: string, projectileId: number): void {
  const state = 弹幕状态表[projectileId];
  delete 弹幕状态表[projectileId];
  debugLogForce(模块名, "Q弹幕结束", "弹幕ID", projectileId, "原因", _reason, "状态存在", state != null);
  if (state == null) return;
  state.弹幕ID = 0;
  // 弹幕结束只回收当前弹幕；蓄力窗口仍存在时，不能把连段壳一起清掉。
  if (!state.等待输入) 清理Q状态(state, state.施法硬直回调ID !== 0);
}

function 发射Q(this: void, state: 克劳德Q状态): void {
  if (!state.进行中 || !单位存活(state.施法者)) {
    debugLogForce(模块名, "发射Q 前置不满足 清理", "进行中", state.进行中, "施法者存活", 单位存活(state.施法者));
    清理Q状态(state);
    return;
  }
  const caster = state.施法者;
  const startX = 获取单位X(caster) + 计算余弦(state.方向角 * 角度转弧度) * 配置.发射起点偏移;
  const startY = 获取单位Y(caster) + 计算正弦(state.方向角 * 角度转弧度) * 配置.发射起点偏移;
  const 锁定目标 = Q是否锁定目标(state);
  const targeted = 锁定目标 && 目标合法(caster, state.目标单位);
  const damage = 读取单位攻击力(caster) * (state.空牙联动 ? 联动配置.空牙Q联动伤害倍率 : state.阶段 === 0 ? 配置.普通伤害倍率 : state.阶段 === 1 ? 配置.二段伤害倍率 : 配置.三段伤害倍率);
  debugLogForce(模块名, "发射Q", "施法者", 获取句柄ID(caster), "阶段", state.阶段, "追加输入次数", state.追加输入次数, "空牙联动", state.空牙联动, "锁定目标", 锁定目标, "追踪目标", targeted, "方向角", state.方向角, "伤害", damage);
  播放Q音效(caster, state.空牙联动 || state.阶段 > 0);
  if (state.施法硬直回调ID !== 0) 清理Q施法硬直(state);
  const 施法暂停成功 = 添加单位暂停(caster, 施法暂停来源);
  设置动作(caster, state.空牙联动 ? 配置.强化动作索引 : state.阶段 === 0 ? 配置.初段动作索引 : 配置.强化动作索引);
  state.施法硬直代次 = state.代次;
  state.施法硬直回调ID = addDelayedCallback(配置.施法硬直秒 * 1000, Q施法硬直结束, { 状态: state, 代次: state.代次 } as Q施法硬直回调参数);
  debugLogForce(模块名, "Q正式发射施法硬直", "施法者", 获取句柄ID(caster), "暂停成功", 施法暂停成功, "阶段", state.阶段, "追加输入次数", state.追加输入次数);
  const projectile = 创建原生弹幕({
    所有者: caster,
    载体模式: "特效",
    X: startX,
    Y: startY,
    方向角: state.方向角,
    速度: 配置.飞行速度,
    生命周期: 配置.生命周期秒,
    最大距离: 配置.最大距离,
    命中半径: state.阶段 === 2 ? 配置.三段碰撞半径 : targeted ? 配置.指定目标碰撞半径 : 配置.普通碰撞半径,
    影响目标: "敌方",
    每单位最大命中次数: 1,
    碰撞消失: !state.空牙联动 && state.阶段 === 0 && targeted,
    不可阻挡: true,
    缩放: state.阶段 === 0 ? 配置.初段缩放 : 配置.强化缩放,
    附加特效1: state.阶段 <= 1 ? {
      模型: 配置.剑气模型,
      缩放: 配置.初段缩放,
    } : undefined,
    伤害值: damage,
    伤害类型: state.空牙联动 ? 普通伤害类型 : 魔法伤害类型,
    attack: true,
    攻击类型: 攻击类型,
    武器类型: 未知武器类型,
    来源类型: "单位技能",
    技能ID: 初段技能ID,
    技能实例ID: state.技能实例ID,
    技能标签: state.空牙联动 ? "克劳德-空牙联动Q" : "克劳德-Q-剑气",
    伤害形态: state.阶段 === 1 && 锁定目标 ? "单体" : "AOE",
    轨迹类型: targeted ? "追踪" : "直线",
    指定目标: targeted ? state.目标单位 : undefined,
    目标筛选: 过滤Q弹幕目标,
    on命中: 处理Q命中,
    onTick: Q弹幕Tick,
    on到达目标点: 处理Q到达终点,
    on结束: Q弹幕结束,
  });
  state.弹幕ID = projectile.弹幕ID;
  弹幕状态表[projectile.弹幕ID] = state;
}

function Q蓄力完成(this: void, variable?: any): void {
  const 参数 = variable as Q蓄力回调参数 | undefined;
  if (参数 == null) return;
  const state = 参数.状态;
  debugLogForce(模块名, "Q蓄力完成", "进行中", state.进行中, "阶段", state.阶段, "追加输入次数", state.追加输入次数, "代次", 参数.代次, "当前代次", state.代次);
  if (!state.进行中 || state.代次 !== 参数.代次) return;
  state.蓄力回调ID = 0;
  state.等待输入 = false;
  const caster = state.施法者;
  if (state.蓄力站桩中) {
    state.蓄力站桩中 = false;
    X_SetUnitMovableSafe(caster, true);
  }
  移除技能(caster, 二段技能ID);
  移除技能(caster, 三段技能ID);
  设置技能可用(获取单位拥有者(caster), 二段技能ID, false);
  设置技能可用(获取单位拥有者(caster), 三段技能ID, false);
  设置时间流速(caster, 1);
  发射Q(state);
}

function 消耗Q追加魔法(this: void, caster: any): boolean {
  const maxMana = 获取单位状态(caster, 最大魔法状态) || 0;
  const cost = maxMana * 0.1;
  const mana = 获取单位状态(caster, 当前魔法状态) || 0;
  debugLogForce(模块名, "Q追加魔耗判断", "施法者", 获取句柄ID(caster), "需求", cost, "当前蓝", mana);
  if (cost <= 0 || mana < cost) {
    debugLogForce(模块名, "Q追加魔耗不足 返回false", "需求", cost, "当前蓝", mana);
    return false;
  }
  减少魔法值(caster, cost, false, false);
  return true;
}

function 释放Q初段(this: void, state: 克劳德Q状态, caster: any, skillInstanceId?: number): void {
  debugLogForce(模块名, "释放Q初段 进入", "施法者", caster == null ? "nil" : 获取句柄ID(caster), "已在进行", state.进行中, "追加输入次数", state.追加输入次数, "技能实例ID", skillInstanceId);
  if (state.进行中) return;
  清理Q施法硬直(state);
  state.施法者 = caster;
  state.代次 += 1;
  const 当前代次 = state.代次;
  const 空牙联动 = 消耗空牙Q联动(caster);
  if (空牙联动 != null) {
    state.阶段 = 2;
    state.进行中 = true;
    state.等待输入 = false;
    state.蓄力站桩中 = false;
    state.目标单位 = null;
    state.目标X = 获取单位X(caster) + 计算余弦(空牙联动.方向角 * 角度转弧度) * 联动配置.冲锋距离;
    state.目标Y = 获取单位Y(caster) + 计算正弦(空牙联动.方向角 * 角度转弧度) * 联动配置.冲锋距离;
    state.方向角 = 空牙联动.方向角;
    state.技能实例ID = skillInstanceId;
    state.空牙联动 = true;
    state.空牙联动方向 = 空牙联动.方向角;
    debugLogForce(模块名, "释放Q初段 走空牙联动", "方向角", 空牙联动.方向角, "目标X", state.目标X, "目标Y", state.目标Y);
    state.蓄力回调ID = addDelayedCallback(10, Q蓄力完成, { 状态: state, 代次: 当前代次 } as Q蓄力回调参数);
    return;
  }
  state.空牙联动 = false;
  state.空牙联动方向 = 0;
  state.阶段 = 0;
  state.追加输入次数 = 0;
  state.进行中 = true;
  state.等待输入 = true;
  state.目标单位 = 获取技能目标单位();
  state.目标X = 获取技能目标X();
  state.目标Y = 获取技能目标Y();
  state.方向角 = 两点角度(获取单位X(caster), 获取单位Y(caster), state.目标X, state.目标Y);
  if (state.目标单位 != null && 目标合法(caster, state.目标单位)) {
    state.目标X = 获取单位X(state.目标单位);
    state.目标Y = 获取单位Y(state.目标单位);
    state.方向角 = 两点角度(获取单位X(caster), 获取单位Y(caster), state.目标X, state.目标Y);
  } else {
    state.目标单位 = null;
  }
  debugLogForce(模块名, "释放Q初段 正常路径", "目标单位", state.目标单位 == null ? "nil" : 获取句柄ID(state.目标单位), "目标X", state.目标X, "目标Y", state.目标Y, "方向角", state.方向角);
  state.技能实例ID = skillInstanceId;
  state.路径特效累计秒 = 0;
  const owner = 获取单位拥有者(caster);
  设置技能可用(owner, 初段技能ID, false);
  移除技能(caster, 二段技能ID);
  移除技能(caster, 三段技能ID);
  添加技能(caster, 二段技能ID);
  设置技能可用(owner, 二段技能ID, true);
  设置技能可用(owner, 三段技能ID, false);
  state.蓄力站桩中 = true;
  X_SetUnitMovableSafe(caster, false);
  设置时间流速(caster, 2);
  state.蓄力回调ID = addDelayedCallback(配置.蓄力秒 * 1000, Q蓄力完成, { 状态: state, 代次: 当前代次 } as Q蓄力回调参数);
}

function 释放Q二段(this: void, state: 克劳德Q状态, caster: any): void {
  debugLogForce(模块名, "释放Q二段 进入", "施法者", 获取句柄ID(caster), "技能ID", 二段技能ID, "进行中", state.进行中, "阶段", state.阶段, "追加输入次数", state.追加输入次数);
  if (!state.进行中 || !state.等待输入 || state.阶段 !== 0 || !消耗Q追加魔法(caster)) return;
  state.阶段 = 1;
  state.追加输入次数 += 1;
  播放Q蓄力表现(caster, 1);
  debugLogForce(模块名, "释放Q二段 成功进入阶段1", "实际追加输入次数", state.追加输入次数, "阶段", state.阶段);
  移除技能(caster, 二段技能ID);
  设置技能可用(获取单位拥有者(caster), 二段技能ID, false);
  添加技能(caster, 三段技能ID);
  设置技能可用(获取单位拥有者(caster), 三段技能ID, true);
}

function 释放Q三段(this: void, state: 克劳德Q状态, caster: any): void {
  debugLogForce(模块名, "释放Q三段 进入", "施法者", 获取句柄ID(caster), "技能ID", 三段技能ID, "进行中", state.进行中, "阶段", state.阶段, "追加输入次数", state.追加输入次数);
  if (!state.进行中 || !state.等待输入 || state.阶段 !== 1 || !消耗Q追加魔法(caster)) return;
  state.阶段 = 2;
  state.追加输入次数 += 1;
  state.等待输入 = false;
  播放Q蓄力表现(caster, 2);
  debugLogForce(模块名, "释放Q三段 成功进入阶段2", "实际追加输入次数", state.追加输入次数, "阶段", state.阶段);
  移除技能(caster, 三段技能ID);
  设置技能可用(获取单位拥有者(caster), 三段技能ID, false);
}

function Q初段可释放(this: void, state: 克劳德Q状态, _caster: any): boolean {
  return !state.进行中;
}

function Q二段可释放(this: void, state: 克劳德Q状态, _caster: any): boolean {
  return state.进行中 && state.等待输入 && state.阶段 === 0;
}

function Q三段可释放(this: void, state: 克劳德Q状态, _caster: any): boolean {
  return state.进行中 && state.等待输入 && state.阶段 === 1;
}

function 克劳德Q死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0 || 获取单位类型ID(dyingUnit) !== 单位类型ID) return;
  const state = 状态表[获取句柄ID(dyingUnit)];
  debugLogForce(模块名, "克劳德Q死亡清理", "死亡单位", 获取句柄ID(dyingUnit), "状态存在", state != null);
  if (state != null) 清理Q状态(state);
}

function 记录克劳德Q技能事件(this: void, castingUnit: any, spellAbilityId: number): void {
  if (castingUnit == null || castingUnit === 0 || 获取单位类型ID(castingUnit) !== 单位类型ID) return;
  if (spellAbilityId !== 初段技能ID && spellAbilityId !== 二段技能ID && spellAbilityId !== 三段技能ID) return;
  const state = 状态表[获取句柄ID(castingUnit)];
  debugLogForce(
    模块名,
    "技能事件诊断",
    "实际技能ID",
    spellAbilityId,
    "预期初段ID",
    初段技能ID,
    "预期二段ID",
    二段技能ID,
    "预期三段ID",
    三段技能ID,
    "阶段",
    state?.阶段,
    "等待输入",
    state?.等待输入,
    "追加输入次数",
    state?.追加输入次数,
  );
}

注册单位技能壳监听({
  名称: "克劳德-破晃击",
  单位类型ID,
  技能ID: 初段技能ID,
  获取或创建上下文: 获取或创建Q状态,
  可释放: Q初段可释放,
  释放技能: 释放Q初段,
  创建独立技能实例: true,
  独立技能来源类型: "单位技能",
  技能实例持续时间秒: 3,
});
注册单位技能壳监听({
  名称: "克劳德-破晃击二段",
  单位类型ID,
  技能ID: 二段技能ID,
  获取或创建上下文: 获取或创建Q状态,
  可释放: Q二段可释放,
  释放技能: 释放Q二段,
  创建独立技能实例: false,
});
注册单位技能壳监听({
  名称: "克劳德-破晃击三段",
  单位类型ID,
  技能ID: 三段技能ID,
  获取或创建上下文: 获取或创建Q状态,
  可释放: Q三段可释放,
  释放技能: 释放Q三段,
  创建独立技能实例: false,
});
registerDeathListener(克劳德Q死亡清理);
registerSpellEffectListener(记录克劳德Q技能事件);

export {};
