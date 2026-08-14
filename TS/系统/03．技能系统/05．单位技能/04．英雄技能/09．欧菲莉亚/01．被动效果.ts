/** @noSelfInFile */

import { 欧菲莉亚单位技能配置 } from "./00．配置";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 直接复活玩家英雄 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.04．英雄复活系统") as {
  直接复活玩家英雄: (this: void, dyingUnit: any) => boolean;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const 欧菲莉亚单位类型ID = stringToFourCCSafe(欧菲莉亚单位技能配置.单位类型ID);
const 欧菲莉亚R技能ID = stringToFourCCSafe(欧菲莉亚单位技能配置.R技能ID);
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;

const 被动复活冷却到期表: Record<number, number | undefined> = {};

function 设置欧菲莉亚被动复活生命(this: void, hero: any): void {
  const maxLife = GetUnitStateJapi(hero, jass.UNIT_STATE_MAX_LIFE) as number;
  if (!(maxLife > 0)) return;
  jass.SetUnitState(hero, jass.UNIT_STATE_LIFE, maxLife * 欧菲莉亚单位技能配置.R.被动复活生命百分比 * 0.01);
}

function 处理欧菲莉亚死亡被动(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0 || GetUnitTypeId(dyingUnit) !== 欧菲莉亚单位类型ID) return;
  const level = GetUnitAbilityLevel(dyingUnit, 欧菲莉亚R技能ID);
  if (!(level > 0)) return;

  const handleId = GetHandleId(dyingUnit);
  const now = getServerTime();
  const cooldownUntil = 被动复活冷却到期表[handleId] ?? 0;
  if (now < cooldownUntil) return;
  if (!直接复活玩家英雄(dyingUnit)) return;

  设置欧菲莉亚被动复活生命(dyingUnit);
  被动复活冷却到期表[handleId] = now
    + (欧菲莉亚单位技能配置.R.被动冷却基础秒
      - 欧菲莉亚单位技能配置.R.被动冷却每级减少秒 * level) * 1000;
}

registerDeathListener(处理欧菲莉亚死亡被动);

export {};
