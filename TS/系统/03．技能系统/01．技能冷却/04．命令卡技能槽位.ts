/** @noSelfInFile */

const japi = require("jass.japi") as any;
const ydweAbility = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  ABILITY_DATA_HOTKEY: number;
};
const { YDWEGetUnitAbilityDataStringSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWEGetUnitAbilityDataStringSafe: (this: void, u: any, abilcode: number, level: number, dataType: number) => string;
};
const { debugLog, setDebug } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLog: (this: void, module: string, ...args: any[]) => void;
  setDebug: (this: void, module: string, on: boolean) => void;
};
const 玩家英雄配置工具 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具") as {
  获取单位玩家英雄配置: (this: void, unit: any) => Record<string, any> | null;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};

/** QWERD 显示排查调试开关：true 时输出 D 槽位探测过程（聊天输入 -dc 打一次快照汇总）。 */
export const QWERD_DEBUG = true;
setDebug("QWERD调试", QWERD_DEBUG);

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

/** 读取命令卡按钮能力 ID 并输出调试日志（-dc 排查用，能看到原始返回）。 */
export function 调试读取命令卡按钮能力Id(this: void, x: number, y: number): number {
  const 按钮框体 = DzFrameGetCommandBarButton(y, x);
  const abilityId = 按钮框体 === 0 ? 0 : KKCommandButtonGetAbilityId(按钮框体) || 0;
  debugLog("QWERD调试", `按钮(${x},${y}) frame=${tostring(按钮框体)} abilityId=${tostring(abilityId)}`);
  return abilityId;
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

  const rawHotkey = YDWEGetUnitAbilityDataStringSafe(whichHero, abilityId, 1, ydweAbility.ABILITY_DATA_HOTKEY);
  if (rawHotkey == null || rawHotkey === "") return null;
  return 归一化热键(rawHotkey);
}

export function 获取D技能槽位(this: void, whichHero: any): readonly [number, number] {
  const 默认槽位 = 第二排技能槽位表[3];
  // 首选：按英雄配置登记的 D 技能 ID 匹配（平台对自定义能力的物编热键字符串读取不可靠）
  const 配置 = 玩家英雄配置工具.获取单位玩家英雄配置(whichHero);
  const dAbilityId = 配置 != null ? stringToFourCCSafe(配置["D技能"]) : 0;
  if (dAbilityId !== 0) {
    for (let i = 0; i < 第二排技能槽位表.length; i++) {
      const [x, y] = 第二排技能槽位表[i];
      if (读取命令卡按钮能力Id(x, y) === dAbilityId) return 第二排技能槽位表[i];
    }
  }
  // 兜底：热键字符串扫描
  for (let i = 0; i < 第二排技能槽位表.length; i++) {
    const [x, y] = 第二排技能槽位表[i];
    if (读取按钮技能热键(whichHero, x, y) === "D") return 第二排技能槽位表[i];
  }
  return 默认槽位;
}

/**
 * -dc 调试入口：转储本地选中英雄的命令卡两排按钮、热键读取结果与快照 D 槽位判定过程。
 */
export function 调试转储命令卡槽位(this: void, whichHero: any): void {
  debugLog("QWERD调试", "========== -dc 命令卡槽位转储开始 ==========");
  debugLog("QWERD调试", "hero=" + tostring(whichHero));
  // 第二排逐格：能力 ID + 原始热键 + 归一化结果
  for (let i = 0; i < 第二排技能槽位表.length; i++) {
    const [x, y] = 第二排技能槽位表[i];
    const abilityId = 读取命令卡按钮能力Id(x, y);
    const rawHotkey = whichHero != null && whichHero !== 0 && abilityId !== 0
      ? YDWEGetUnitAbilityDataStringSafe(whichHero, abilityId, 1, ydweAbility.ABILITY_DATA_HOTKEY)
      : "";
    debugLog("QWERD调试", `第二排(${x},${y}) abilityId=${tostring(abilityId)} rawHotkey=${tostring(rawHotkey)}`);
  }
  // 第三排 QWER 固定槽位（同时读热键，对比 heroAbility 与普通能力的热键读取差异）
  for (let i = 0; i < 命令卡热键槽位表.length - 1; i++) {
    const [x, y, 热键] = 命令卡热键槽位表[i];
    const abilityId = 读取命令卡按钮能力Id(x, y);
    const rawHotkey = whichHero != null && whichHero !== 0 && abilityId !== 0
      ? YDWEGetUnitAbilityDataStringSafe(whichHero, abilityId, 1, ydweAbility.ABILITY_DATA_HOTKEY)
      : "";
    debugLog("QWERD调试", `第三排(${x},${y}) 期望${热键} abilityId=${tostring(abilityId)} rawHotkey=${tostring(rawHotkey)}`);
  }
  const dSlot = 获取D技能槽位(whichHero);
  debugLog("QWERD调试", `D技能槽位判定结果 = (${dSlot[0]},${dSlot[1]})`);
  debugLog("QWERD调试", "========== -dc 命令卡槽位转储结束 ==========");
}

export {};
