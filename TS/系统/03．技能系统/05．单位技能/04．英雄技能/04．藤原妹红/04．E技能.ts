/** @noSelfInFile */

import { 藤原妹红单位技能配置 } from "./00．配置";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const { YDWESetUnitAbilityStateSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWESetUnitAbilityStateSafe: (this: void, unit: any, abilityId: number, stateType: number, value: number) => boolean;
};
const { getCooldownReduction, applyCooldownCap, calcActualCooldown } = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算") as {
  getCooldownReduction: (this: void, unit: any) => number;
  applyCooldownCap: (this: void, reduction: number, abilityId: number, capIncrease: number) => number;
  calcActualCooldown: (this: void, baseCooldown: number, reduction: number) => number;
};
const stringToFourCCSafe = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版").stringToFourCCSafe as (this: void, value: string) => number;

const 单位类型ID = stringToFourCCSafe(藤原妹红单位技能配置.单位类型ID);
const 符卡开关技能ID = stringToFourCCSafe(藤原妹红单位技能配置.符卡开关技能ID);
const 符卡关闭技能ID = stringToFourCCSafe(藤原妹红单位技能配置.符卡关闭技能ID);
const 符卡开关冷却秒 = 12;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;

function 设置技能显示(this: void, unit: any, skillIds: readonly string[], available: boolean): void {
  const owner = GetOwningPlayer(unit);
  for (let i = 0; i < skillIds.length; i++) {
    const abilityId = stringToFourCCSafe(skillIds[i]);
    SetPlayerAbilityAvailable(owner, abilityId, available);
  }
}

function 开启符卡模式(this: void, _context: any, caster: any): void {
  设置技能显示(caster, 藤原妹红单位技能配置.普通模式技能ID列表, false);
  设置技能显示(caster, 藤原妹红单位技能配置.符卡模式技能ID列表, true);
  UnitAddAbility(caster, 符卡关闭技能ID);
  UnitRemoveAbility(caster, 符卡开关技能ID);
}

export function 关闭藤原妹红符卡模式(this: void, caster: any, 施放符卡后进入冷却: boolean = false): void {
  if (caster == null || caster === 0) return;
  设置技能显示(caster, 藤原妹红单位技能配置.符卡模式技能ID列表, false);
  设置技能显示(caster, 藤原妹红单位技能配置.普通模式技能ID列表, true);
  UnitAddAbility(caster, 符卡开关技能ID);
  UnitRemoveAbility(caster, 符卡关闭技能ID);

  if (施放符卡后进入冷却) {
    const reduction = getCooldownReduction(caster);
    const cappedReduction = applyCooldownCap(reduction, 符卡开关技能ID, 0);
    const actualCooldown = calcActualCooldown(符卡开关冷却秒, cappedReduction);
    YDWESetUnitAbilityStateSafe(caster, 符卡开关技能ID, 1, actualCooldown);
  }
}

function 关闭符卡模式技能监听(this: void, _context: any, caster: any): void {
  关闭藤原妹红符卡模式(caster, false);
}

function 获取藤原妹红技能上下文(this: void, unit: any): any {
  return unit;
}

export function 注册藤原妹红符卡模式(this: void): void {
  注册单位技能壳监听({
    名称: "藤原妹红-开启符卡",
    单位类型ID: 单位类型ID,
    技能ID: 符卡开关技能ID,
    获取或创建上下文: 获取藤原妹红技能上下文,
    创建独立技能实例: false,
    释放技能: 开启符卡模式,
  });
  注册单位技能壳监听({
    名称: "藤原妹红-关闭符卡",
    单位类型ID: 单位类型ID,
    技能ID: 符卡关闭技能ID,
    获取或创建上下文: 获取藤原妹红技能上下文,
    创建独立技能实例: false,
    释放技能: 关闭符卡模式技能监听,
  });
}

注册藤原妹红符卡模式();

export const 藤原妹红E技能状态 = {
  已完成设计: true,
  已完成实现: true,
  开启技能: "A0GG",
  关闭技能: "A0GF",
  模式切换: "全局同步切换技能可用性，符卡施放后自动恢复普通模式",
} as const;

export {};
