/** @noSelfInFile */

import { 逆回十六夜单位技能配置 } from "./00．配置";
import { 调整玩家属性 } from "../../../00．技能模板+函数/01．技能函数/20．物品辅助/16．属性位移与指令";
import { 执行非伤害生命移除 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/09．非伤害生命移除";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerDodgeBypassPredicate } = require("系统.04．伤害系统.05．闪避系统.01．闪避核心") as {
  registerDodgeBypassPredicate: (this: void, callback: (this: void, context: any) => boolean) => void;
};
const { registerPlayerHeroListener, getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  registerPlayerHeroListener: (this: void, callback: (this: void, player: any, hero: any) => void) => void;
  getRegisteredPlayerHero: (this: void, player: any) => any;
};

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const Player = jass.Player as (id: number) => any;
const 十六夜单位类型ID = stringToFourCCSafe(逆回十六夜单位技能配置.单位类型ID);
const 已绑定玩家: Record<number, true | undefined> = {};

function 是逆回十六夜(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) === 十六夜单位类型ID;
}

function 更新十六夜被动属性(this: void, player: any, hero: any): void {
  if (player == null || player === 0) return;
  const playerId = jass.GetPlayerId(player) as number;
  const shouldApply = 是逆回十六夜(hero);
  const applied = 已绑定玩家[playerId] === true;
  if (shouldApply === applied) return;
  const direction = shouldApply ? 1 : -1;
  调整玩家属性(hero, "眩晕抗性", 逆回十六夜单位技能配置.被动.眩晕抗性 * direction);
  调整玩家属性(hero, "被暴击率", 逆回十六夜单位技能配置.被动.被暴击率减少 * direction);
  if (shouldApply) 已绑定玩家[playerId] = true;
  else delete 已绑定玩家[playerId];
}

function 十六夜非普攻闪避豁免(this: void, context: any): boolean {
  return 是逆回十六夜(context?.attacker) && context?.isNormalAttack !== true;
}

function on十六夜最终物理伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!是逆回十六夜(attacker) || !(applied > 0) || snapshot?.isPhysicalDamage !== true) return;
  执行非伤害生命移除({
    目标: target,
    数值: applied * 逆回十六夜单位技能配置.被动.物理伤害额外扣血比例,
    不致死: false,
    显示文字: true,
  });
}

function 初始化已有十六夜属性(this: void): void {
  for (let i = 0; i < 16; i++) {
    const player = Player(i);
    更新十六夜被动属性(player, getRegisteredPlayerHero(player));
  }
}

export function 注册逆回十六夜被动(this: void): void {
  registerPlayerHeroListener(更新十六夜被动属性);
  registerDodgeBypassPredicate(十六夜非普攻闪避豁免);
  registerAppliedFinalDamageListener(on十六夜最终物理伤害);
  初始化已有十六夜属性();
}

注册逆回十六夜被动();

