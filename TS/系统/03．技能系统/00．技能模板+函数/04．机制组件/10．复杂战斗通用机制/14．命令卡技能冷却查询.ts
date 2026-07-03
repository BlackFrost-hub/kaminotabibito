/** @noSelfInFile */

import { 命令卡技能热键位, 命令卡热键槽位表, 读取命令卡按钮能力Id } from "../../../01．技能冷却/04．命令卡技能槽位";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const DzGetUnitAbilityCool = japi.DzGetUnitAbilityCool as ((unit: any, abilityId: number) => number) | undefined;

export function 取命令卡热键技能ID(this: void, 热键: 命令卡技能热键位): number {
  for (let i = 0; i < 命令卡热键槽位表.length; i++) {
    const [x, y, key] = 命令卡热键槽位表[i];
    if (key === 热键) return 读取命令卡按钮能力Id(x, y);
  }
  return 0;
}

export function 单位技能是否冷却中(this: void, 单位: any, 技能ID: number): boolean {
  if (单位 == null || 单位 === 0 || 技能ID === 0) return false;
  if (GetUnitAbilityLevel(单位, 技能ID) <= 0) return false;
  if (typeof DzGetUnitAbilityCool !== "function") return false;
  return DzGetUnitAbilityCool(单位, 技能ID) > 0;
}

export function 命令卡热键技能是否冷却中(this: void, 单位: any, 热键: 命令卡技能热键位): boolean {
  return 单位技能是否冷却中(单位, 取命令卡热键技能ID(热键));
}

export function 命令卡技能是否全部冷却中(this: void, 单位: any, 热键列表: 命令卡技能热键位[] = ["Q", "W", "E", "R"]): boolean {
  for (let i = 0; i < 热键列表.length; i++) {
    if (!命令卡热键技能是否冷却中(单位, 热键列表[i])) return false;
  }
  return true;
}
