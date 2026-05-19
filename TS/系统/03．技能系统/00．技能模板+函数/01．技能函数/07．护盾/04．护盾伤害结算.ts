/** @noSelfInFile */
/**
 * 护盾伤害结算
 *
 * 职责：
 * - 在伤害计算完成后、YDWESetEventDamage 之前介入
 * - 按优先级吸收伤害
 * - 处理护盾破碎
 * - 返回剩余伤害
 */

import { 护盾实例, 护盾类型, 伤害信息 } from "./01．护盾类型";
import { 获取单位护盾实例列表, 删除护盾实例, 取句柄ID, 获取所有活动护盾实例 } from "./02．护盾实例";
import { 获取可匹配护盾列表 } from "./03．护盾优先级";
import { 显示护盾破碎漂浮文字 } from "./08．护盾回调模板";
const { RMinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  RMinBJ: (this: void, a: number, b: number) => number;
};

const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (context: {
    target: any;
    attacker: any;
    baseDamage: number;
    currentDamage: number;
    isPhysicalDamage: boolean;
    isMagicDamage: boolean;
    isEnhancedDamage: boolean;
    isTrueDamage: boolean;
    isMetalDamage?: boolean;
    isWoodDamage?: boolean;
    isWaterDamage?: boolean;
    isFireDamage?: boolean;
    isThunderDamage?: boolean;
    isLightDamage?: boolean;
    isDarkDamage?: boolean;
    isNormalAttack: boolean;
    isSkillAttack: boolean;
    isSkillDamage: boolean;
  }) => number, priority?: number) => number;
};

/** 最近一次护盾吸收量（供伤害测试读取） */
export let 最近护盾吸收量 = 0;
/** 最近一次护盾吸收类型（供伤害测试读取） */
export let 最近护盾吸收类型 = "";

let shieldModifierRegistered = false;

/**
 * 护盾吸收结果
 */
export interface 护盾吸收结果 {
  /** 剩余伤害（未被护盾吸收的部分） */
  剩余伤害: number;
  /** 总吸收量 */
  总吸收量: number;
  /** 实际参与吸收的首个护盾类型：0=通用/其他，1=物理，2=魔法 */
  闪色类型: number;
  /** 被破碎的护盾列表 */
  破碎护盾: 护盾实例[];
}

function 取护盾闪色类型(this: void, 护盾: 护盾实例): number {
  if (护盾.类型 === 护盾类型.物理) return 1;
  if (护盾.类型 === 护盾类型.魔法) return 2;
  if (护盾.类型 === 护盾类型.强化) return 3;
  if (护盾.类型 === 护盾类型.火) return 4;
  if (护盾.类型 === 护盾类型.水 || 护盾.类型 === 护盾类型.冰) return 5;
  if (护盾.类型 === 护盾类型.雷) return 6;
  if (护盾.类型 === 护盾类型.金 || 护盾.类型 === 护盾类型.毒) return 7;
  if (护盾.类型 === 护盾类型.木 || 护盾.类型 === 护盾类型.风) return 8;
  if (护盾.类型 === 护盾类型.光) return 9;
  if (护盾.类型 === 护盾类型.暗) return 10;
  return 0;
}

function 取护盾吸收类型名称(this: void, 护盾: 护盾实例, 伤害: 伤害信息): string {
  if (护盾.类型 === 护盾类型.物理) return "物理";
  if (护盾.类型 === 护盾类型.魔法) return "魔法";
  if (护盾.类型 === 护盾类型.强化) return "强化";
  if (护盾.类型 === 护盾类型.金 || 护盾.类型 === 护盾类型.毒) return 护盾.类型 === 护盾类型.毒 ? "毒" : "金";
  if (护盾.类型 === 护盾类型.木 || 护盾.类型 === 护盾类型.风) return 护盾.类型 === 护盾类型.风 ? "风" : "木";
  if (护盾.类型 === 护盾类型.水 || 护盾.类型 === 护盾类型.冰) return 护盾.类型 === 护盾类型.冰 ? "冰" : "水";
  if (护盾.类型 === 护盾类型.火) return "火";
  if (护盾.类型 === 护盾类型.雷) return "雷";
  if (护盾.类型 === 护盾类型.光) return "光";
  if (护盾.类型 === 护盾类型.暗) return "暗";
  if (伤害.是物理伤害) return "物理";
  if (伤害.是魔法伤害) return "魔法";
  return "通用";
}

function 构建伤害信息(
  this: void,
  目标: any,
  伤害值: number,
  是物理伤害: boolean,
  是魔法伤害: boolean,
  攻击者?: any,
  属性?: Partial<伤害信息>
): 伤害信息 {
  return {
    目标,
    攻击者,
    伤害值,
    是物理伤害,
    是魔法伤害,
    是真实伤害: 属性?.是真实伤害 === true,
    是强化伤害: 属性?.是强化伤害 === true,
    是火属性伤害: 属性?.是火属性伤害 === true,
    是水属性伤害: 属性?.是水属性伤害 === true || 属性?.是冰属性伤害 === true,
    是冰属性伤害: 属性?.是冰属性伤害 === true || 属性?.是水属性伤害 === true,
    是雷属性伤害: 属性?.是雷属性伤害 === true,
    是金属性伤害: 属性?.是金属性伤害 === true || 属性?.是毒属性伤害 === true,
    是木属性伤害: 属性?.是木属性伤害 === true || 属性?.是风属性伤害 === true,
    是风属性伤害: 属性?.是风属性伤害 === true || 属性?.是木属性伤害 === true,
    是暗属性伤害: 属性?.是暗属性伤害 === true,
    是光属性伤害: 属性?.是光属性伤害 === true,
    是毒属性伤害: 属性?.是毒属性伤害 === true || 属性?.是金属性伤害 === true,
    是普攻: 属性?.是普攻 === true,
  };
}

/**
 * 用护盾吸收伤害
 *
 * @param 目标 受伤单位
 * @param 伤害值 待结算伤害
 * @param 是物理伤害 是否物理伤害
 * @param 是魔法伤害 是否魔法伤害
 * @param 攻击者 攻击者（可选，用于破碎回调）
 * @returns 吸收结果
 */
export function 吸收伤害(
  目标: any,
  伤害值: number,
  是物理伤害: boolean,
  是魔法伤害: boolean,
  攻击者?: any,
  属性?: Partial<伤害信息>
): 护盾吸收结果 {
  const 结果: 护盾吸收结果 = {
    剩余伤害: 伤害值,
    总吸收量: 0,
    闪色类型: 0,
    破碎护盾: [],
  };

  // 重置上次吸收记录
  最近护盾吸收量 = 0;
  最近护盾吸收类型 = "";
  const gReset = globalThis as any;
  gReset._shieldAbsorbAmount = 0;
  gReset._shieldAbsorbType = "";

  const 单位ID = 取句柄ID(目标);
  if (单位ID === 0) return 结果;

  // 获取单位所有护盾
  const 全部护盾 = 获取单位护盾实例列表(单位ID);
  if (全部护盾.length === 0) return 结果;

  const 伤害 = 构建伤害信息(目标, 伤害值, 是物理伤害, 是魔法伤害, 攻击者, 属性);
  // 获取按优先级排序的可匹配护盾（通用护盾吸收所有伤害，包括真实伤害）
  const 可用护盾 = 获取可匹配护盾列表(全部护盾, 伤害);

  // 按优先级依次吸收
  for (const 护盾 of 可用护盾) {
    if (结果.剩余伤害 <= 0) break;

    const 吸收量 = RMinBJ(护盾.当前值, 结果.剩余伤害);
    if (吸收量 > 0 && 结果.总吸收量 <= 0) {
      结果.闪色类型 = 取护盾闪色类型(护盾);
    }
    护盾.当前值 -= 吸收量;
    结果.剩余伤害 -= 吸收量;
    结果.总吸收量 += 吸收量;

    // 记录最近吸收信息（供伤害测试显示）
    最近护盾吸收量 = 结果.总吸收量;
    最近护盾吸收类型 = 取护盾吸收类型名称(护盾, 伤害);
    const g = globalThis as any;
    g._shieldAbsorbAmount = 最近护盾吸收量;
    g._shieldAbsorbType = 最近护盾吸收类型;

    // 护盾破碎
    if (护盾.当前值 <= 0) {
      结果.破碎护盾.push(护盾);
      删除护盾实例(护盾.id);

      // 自动显示破碎漂浮文字
      显示护盾破碎漂浮文字(目标, 护盾.类型);

      // 触发破碎回调
      if (typeof 护盾.破碎回调 === "function") {
        护盾.破碎回调(目标, 护盾.id, 吸收量);
      }

      // 触发结束回调
      if (typeof 护盾.结束回调 === "function") {
        护盾.结束回调(目标, 护盾.id, "破碎");
      }
    }
  }

  return 结果;
}

/**
 * 注册护盾吸收到伤害系统
 *
 * 在主计算流程的 YDWESetEventDamage 之前调用
 */
export function 注册护盾吸收钩子(): void {
  if (shieldModifierRegistered) return;
  shieldModifierRegistered = true;
  registerDamageModifier((context) => {
    const 结果 = 吸收伤害(
      context.target,
      context.currentDamage,
      context.isPhysicalDamage,
      context.isMagicDamage,
      context.attacker,
      {
        是真实伤害: context.isTrueDamage === true,
        是强化伤害: context.isEnhancedDamage === true,
        是火属性伤害: context.isFireDamage === true,
        是水属性伤害: context.isWaterDamage === true,
        是冰属性伤害: context.isWaterDamage === true,
        是雷属性伤害: context.isThunderDamage === true,
        是金属性伤害: context.isMetalDamage === true,
        是木属性伤害: context.isWoodDamage === true,
        是风属性伤害: context.isWoodDamage === true,
        是暗属性伤害: context.isDarkDamage === true,
        是光属性伤害: context.isLightDamage === true,
        是毒属性伤害: context.isMetalDamage === true,
        是普攻: context.isNormalAttack === true,
      }
    );
    // 护盾条闪色
    if (结果.总吸收量 > 0) {
      const g = globalThis as any;
      const 护盾条闪色 = (g as any)._shieldBarFlashColor;
      if (typeof 护盾条闪色 === "function") {
        护盾条闪色(context.target, 结果.闪色类型);
      }
    }
    return 结果.剩余伤害;
  }, 100);
}

export {};
