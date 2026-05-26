/** @noSelfInFile */

const japi = require("jass.japi") as any;
const ydweAbility = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  ABILITY_DATA_HOTKEY: number;
  YDWEGetUnitAbilityDataString: (u: any, abilcode: number, level: number, dataType: number) => string;
};
const { YDWEGetUnitAbilityDataString } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  YDWEGetUnitAbilityDataString: (u: any, abilcode: number, level: number, dataType: number) => string;
};

const DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton as (row: number, column: number) => number;
const KKCommandButtonGetAbilityId = japi.KKCommandButtonGetAbilityId as (frame: number) => number;

export type 命令卡技能热键位 = "Q" | "W" | "E" | "R" | "D";

export const 命令卡热键槽位表: ReadonlyArray<readonly [number, number, 命令卡技能热键位]> = [
  [0, 2, "Q"],
  [1, 2, "W"],
  [2, 2, "E"],
  [3, 2, "R"],
  [0, 1, "D"],
] as const;

export const 第二排技能槽位表: ReadonlyArray<readonly [number, number]> = [
  [0, 1],
  [1, 1],
  [2, 1],
  [3, 1],
] as const;

export function 解析脚本返回整数(this: void, raw: any): number {
  if (raw == null || raw === "") return 0;
  if (typeof raw === "number" && raw === raw && isFinite(raw)) return raw;
  const value = parseInt(tostring(raw), 10);
  return isFinite(value) ? value : 0;
}

export function 读取命令卡按钮能力Id(this: void, x: number, y: number): number {
  const 按钮框体 = DzFrameGetCommandBarButton(y, x);
  if (按钮框体 === 0) return 0;
  return KKCommandButtonGetAbilityId(按钮框体) || 0;
}

export function 按命令卡推断热键(this: void, abilityId: number): 命令卡技能热键位 | null {
  if (abilityId === 0) return null;

  for (let i = 0; i < 命令卡热键槽位表.length; i++) {
    const [x, y, hotkey] = 命令卡热键槽位表[i];
    if (读取命令卡按钮能力Id(x, y) === abilityId) return hotkey;
  }
  return null;
}

function 归一化热键(this: void, rawHotkey: string): 命令卡技能热键位 | null {
  const hotkey = tostring(rawHotkey);
  if (hotkey === "Q" || hotkey === "q") return "Q";
  if (hotkey === "W" || hotkey === "w") return "W";
  if (hotkey === "E" || hotkey === "e") return "E";
  if (hotkey === "R" || hotkey === "r") return "R";
  if (hotkey === "D" || hotkey === "d") return "D";
  return null;
}

function 读取按钮技能热键(this: void, whichHero: any, x: number, y: number): 命令卡技能热键位 | null {
  if (whichHero == null || whichHero === 0) return null;
  const abilityId = 读取命令卡按钮能力Id(x, y);
  if (abilityId === 0) return null;

  const rawHotkey = YDWEGetUnitAbilityDataString(whichHero, abilityId, 1, ydweAbility.ABILITY_DATA_HOTKEY);
  if (rawHotkey == null || rawHotkey === "") return null;
  return 归一化热键(rawHotkey);
}

export function 获取D技能槽位(this: void, whichHero: any): readonly [number, number] {
  const 默认槽位 = 第二排技能槽位表[3];
  for (let i = 0; i < 第二排技能槽位表.length; i++) {
    const [x, y] = 第二排技能槽位表[i];
    const 热键 = 读取按钮技能热键(whichHero, x, y);
    if (热键 === "D") return 第二排技能槽位表[i];
  }
  return 默认槽位;
}

export {};
