/** @noSelfInFile */

const japi = require("jass.japi") as any;

const DzSetUnitAbilityTip = japi.DzSetUnitAbilityTip as ((unit: any, abilityId: number, tip: string) => boolean) | undefined;
const DzSetUnitAbilityUpdate = japi.DzSetUnitAbilityUpdate as ((unit: any, abilityId: number) => boolean) | undefined;

export interface 单位技能壳提示配置 {
  技能ID: string;
  提示: string;
}

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

export function 设置单位技能壳普通提示(this: void, 单位: any, 配置列表: readonly 单位技能壳提示配置[]): void {
  if (单位 == null || 单位 === 0) return;
  if (typeof DzSetUnitAbilityTip !== "function") return;
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    if (配置.技能ID == null || 配置.技能ID.length < 4 || 配置.提示 === "") continue;
    const 技能ID = stringToFourCC(配置.技能ID);
    DzSetUnitAbilityTip(单位, 技能ID, 配置.提示);
    if (typeof DzSetUnitAbilityUpdate === "function") {
      DzSetUnitAbilityUpdate(单位, 技能ID);
    }
  }
}
