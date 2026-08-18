/** @noSelfInFile */
// 黑崎一护被动：卍解期间普攻命中敌人时，月牙天冲剩余冷却减少 0.55 秒。
// 源 JASS 真源：被动.j（普攻判定：DAMAGE_TYPE_NORMAL 且攻击伤害；卍解为真且 A01G 剩余冷却 > 0.5 时 −0.55）。
// 源 YDWESetUnitAbilityState(A01G, 1, ...) 直调迁移为同步冷却接口（项目规则：真实冷却走同步接口）。

import { 黑崎一护技能配置 } from "./00．配置";
import { 黑崎一护是否卍解 } from "./01．状态表";

const jass = require("jass.common") as any;

const { registerDamageCallback } = require("系统.04．伤害系统.01．伤害事件") as {
  registerDamageCallback: (
    this: void,
    cb: (
      this: void,
      unit: any,
      damage: number,
      damageType: number,
      fromDotTickBatch?: boolean,
      source?: any,
      isNormalAttack?: boolean,
    ) => void,
  ) => void;
};
const { 读取技能剩余冷却 } = require("系统.03．技能系统.01．技能冷却.05．技能冷却查询") as {
  读取技能剩余冷却: (this: void, 单位: any, 技能ID: number) => number;
};
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, 单位: any, 技能代码: number, 冷却: number, 最大冷却: number) => boolean;
};

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const IsUnitAlly = jass.IsUnitAlly as (this: void, unit: any, p: any) => boolean;
const IsUnitOwnedByPlayer = jass.IsUnitOwnedByPlayer as (this: void, unit: any, p: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;
const 配置 = 黑崎一护技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const Q类型ID = stringToFourCC(配置.Q.技能ID);

function 处理卍解普攻缩Q(this: void, unit: any, _damage: number, _damageType: number, _fromDotTickBatch?: boolean, source?: any, isNormalAttack?: boolean): void {
  if (isNormalAttack !== true) return;
  if (source == null || source === 0) return;
  if (GetUnitTypeId(source) !== 英雄单位类型ID) return;
  // 源：目标必须是施法者的敌人（非友方且非自己单位）
  const attackerPlayer = GetOwningPlayer(source);
  if (IsUnitAlly(unit, attackerPlayer) || IsUnitOwnedByPlayer(unit, attackerPlayer)) return;
  if (!黑崎一护是否卍解(source)) return;

  const 剩余 = 读取技能剩余冷却(source, Q类型ID);
  if (剩余 > 配置.被动.Q冷却剩余阈值秒) {
    const 新冷却 = 剩余 - 配置.被动.Q冷却缩减秒;
    技能_设置技能冷却时间(source, Q类型ID, 新冷却 > 0 ? 新冷却 : 0, 配置.Q.物编冷却秒);
  }
}

let 已注册 = false;

export function 注册黑崎一护被动(this: void): void {
  if (已注册) return;
  已注册 = true;
  registerDamageCallback(处理卍解普攻缩Q);
}

注册黑崎一护被动();

export {};
