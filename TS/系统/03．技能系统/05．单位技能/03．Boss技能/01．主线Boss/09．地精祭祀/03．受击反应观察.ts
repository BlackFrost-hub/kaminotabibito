/** @noSelfInFile */

import { 地精祭祀单位技能配置 } from './00．配置';

const { registerSpellEffectListener } = require('系统.00．核心系统.01．事件中心.08．技能事件中心') as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const jass = require('jass.common') as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;

const 地精祭祀单位类型ID = stringToFourCCSafe(地精祭祀单位技能配置.单位ID);
const 受击召唤技能ID = stringToFourCCSafe(地精祭祀单位技能配置.技能ID.受击召唤);
let 地精祭祀受击反应观察已注册 = false;

function on地精祭祀受击召唤生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 受击召唤技能ID || GetUnitTypeId(castingUnit) !== 地精祭祀单位类型ID) return;
}

export function 注册地精祭祀受击反应观察(this: void): void {
  if (地精祭祀受击反应观察已注册) return;
  地精祭祀受击反应观察已注册 = true;
  registerSpellEffectListener(on地精祭祀受击召唤生效);
}
