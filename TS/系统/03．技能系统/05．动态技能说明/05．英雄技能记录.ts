/**
 * 动态技能说明 - 英雄技能记录
 *
 * 职责：
 * - 在英雄注册时，为该英雄挂接 SPELL_EFFECT
 * - 在英雄第一次释放 Q/W/E/R/D 技能时，记录该热键位对应的技能 rawcode
 * - 提供 TS 侧查询接口，供按钮悬浮等模块直接读取
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitEventTrigger: (this: void, trigger: any, unit: any, eventId: any, once?: boolean) => () => void;
};
const commandBarAbility = require("系统.03．技能系统.05．动态技能说明.07．命令卡技能槽位") as {
  按命令卡推断热键: (this: void, abilityId: number) => 英雄技能热键位 | null;
};

const ydweAbility = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  ABILITY_DATA_HOTKEY: number;
  YDWEGetUnitAbilityDataString: (u: any, abilcode: number, level: number, dataType: number) => string;
};
const { YDWEGetUnitAbilityDataString } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  YDWEGetUnitAbilityDataString: (u: any, abilcode: number, level: number, dataType: number) => string;
};

export type 英雄技能热键位 = "Q" | "W" | "E" | "R" | "D";

export type 英雄技能记录 = {
  Q?: number;
  W?: number;
  E?: number;
  R?: number;
  D?: number;
};

const 英雄技能记录表: Map<number, 英雄技能记录> = new Map();
const 已挂接英雄: Set<number> = new Set();
let 技能记录触发器: any = null;

function isValidHandle(handle: any): boolean {
  return handle != null && handle !== 0;
}

function getHandleId(handle: any): number {
  if (!isValidHandle(handle)) return 0;
  return (jass.GetHandleId(handle) as number) || 0;
}

function ensure技能记录触发器(): any {
  if (技能记录触发器 != null) return 技能记录触发器;
  技能记录触发器 = jass.CreateTrigger();
  jass.TriggerAddAction(技能记录触发器, on英雄技能生效);
  return 技能记录触发器;
}

function 归一化热键(this: void, rawHotkey: string): 英雄技能热键位 | null {
  const hotkey = tostring(rawHotkey);
  if (hotkey === "Q" || hotkey === "q") return "Q";
  if (hotkey === "W" || hotkey === "w") return "W";
  if (hotkey === "E" || hotkey === "e") return "E";
  if (hotkey === "R" || hotkey === "r") return "R";
  if (hotkey === "D" || hotkey === "d") return "D";
  return null;
}

function 读取技能热键(this: void, whichHero: any, abilityId: number): 英雄技能热键位 | null {
  if (!isValidHandle(whichHero) || abilityId === 0) return null;

  const rawHotkey = YDWEGetUnitAbilityDataString(whichHero, abilityId, 1, ydweAbility.ABILITY_DATA_HOTKEY);
  if (rawHotkey == null || rawHotkey === "") return null;
  return 归一化热键(rawHotkey);
}

function 当前是否本机选中英雄(this: void, whichHero: any): boolean {
  if (!isValidHandle(whichHero)) return false;
  const localPlayer = jass.GetLocalPlayer();
  if (!isValidHandle(localPlayer)) return false;
  if (jass.GetOwningPlayer(whichHero) !== localPlayer) return false;

  const focused = japi.DzGetMouseFocus();
  if (focused == null) {
    // 这里只做保守校验：至少确保单位归属本机。
  }
  return true;
}

function 按命令卡推断热键(this: void, whichHero: any, abilityId: number): 英雄技能热键位 | null {
  if (!当前是否本机选中英雄(whichHero)) return null;
  return commandBarAbility.按命令卡推断热键(abilityId);
}

function 写入技能记录(this: void, whichHero: any, hotkey: 英雄技能热键位, abilityId: number): void {
  const heroId = getHandleId(whichHero);
  if (heroId === 0 || abilityId === 0) return;

  let record = 英雄技能记录表.get(heroId);
  if (record == null) {
    record = {};
    英雄技能记录表.set(heroId, record);
  }

  if (record[hotkey] != null && record[hotkey] !== 0) return;
  record[hotkey] = abilityId;
}

function on英雄技能生效(this: void): void {
  const whichHero = jass.GetTriggerUnit();
  if (!isValidHandle(whichHero)) return;

  const abilityId = (jass.GetSpellAbilityId() as number) || 0;
  if (abilityId === 0) return;

  const hotkey = 读取技能热键(whichHero, abilityId);
  const finalHotkey = hotkey ?? 按命令卡推断热键(whichHero, abilityId);
  if (finalHotkey == null) return;

  写入技能记录(whichHero, finalHotkey, abilityId);
}

export function registerHeroSkillRecordHero(this: void, whichHero: any): void {
  if (!isValidHandle(whichHero)) return;

  const heroId = getHandleId(whichHero);
  if (heroId === 0 || 已挂接英雄.has(heroId)) return;

  unitSpecificEventCenter.registerUnitEventTrigger(ensure技能记录触发器(), whichHero, jass.EVENT_UNIT_SPELL_EFFECT);
  已挂接英雄.add(heroId);
}

export function getHeroRecordedSkill(this: void, whichHero: any, hotkey: 英雄技能热键位): number {
  const heroId = getHandleId(whichHero);
  if (heroId === 0) return 0;
  const record = 英雄技能记录表.get(heroId);
  if (record == null) return 0;
  return (record[hotkey] as number) || 0;
}

export function getHeroRecordedSkills(this: void, whichHero: any): 英雄技能记录 | null {
  const heroId = getHandleId(whichHero);
  if (heroId === 0) return null;
  return 英雄技能记录表.get(heroId) || null;
}

export {};
