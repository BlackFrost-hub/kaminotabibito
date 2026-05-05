/** @noSelfInFile */

const jass = require("jass.common") as any;

const {
  YDWESetUnitAbilityDataString,
  EXExecuteScript,
  getObjectProperty,
  ObjectType,
  ABILITY_DATA_UBERTIP,
} = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  YDWESetUnitAbilityDataString: (u: any, abilcode: number, level: number, dataType: number, value: string) => boolean;
  EXExecuteScript: (script: string) => string;
  getObjectProperty: (objectType: number, objectId: number | string, property: string) => string;
  ObjectType: { ABILITY: number };
  ABILITY_DATA_UBERTIP: number;
};
const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: string) => any;
  YDUserDataSet: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: string, value: any) => void;
};
const { getSoleSelectedUnitForPlayer } = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  getSoleSelectedUnitForPlayer: (playerId: number) => any | null;
};

const PLAYER_HERO_ATTR = "英雄";
const SLOT_ROW = 2;
const UPDATE_INTERVAL_MS = 1000;
const SLOT_KEYS = ["Q技能", "W技能", "E技能", "R技能"] as const;
const SLOT_COLUMNS = [0, 1, 2, 3] as const;

let periodicInstalled = false;

function replaceAllText(text: string, search: string, replacement: string): string {
  if (search === "") return text;
  return text.split(search).join(replacement);
}

function getRegisteredHeroForLocalPlayer(): any | null {
  const localPlayer = jass.GetLocalPlayer();
  if (!localPlayer || localPlayer === 0) return null;
  return YDUserDataGet("player", localPlayer, PLAYER_HERO_ATTR, "unit");
}

function getSelectedRegisteredHeroForLocalPlayer(): any | null {
  const localPlayer = jass.GetLocalPlayer();
  if (!localPlayer || localPlayer === 0) return null;

  const playerId = jass.GetPlayerId(localPlayer);
  const selectedUnit = getSoleSelectedUnitForPlayer(playerId);
  if (!selectedUnit || selectedUnit === 0) return null;

  const registeredHero = getRegisteredHeroForLocalPlayer();
  if (!registeredHero || registeredHero === 0) return null;
  if (selectedUnit !== registeredHero) return null;

  return registeredHero;
}

function resolveAbilityIdBySlot(column: number): number {
  const rawAbility = EXExecuteScript(`require 'jass.message'.button(${column},${SLOT_ROW})`);
  const abilityId = parseInt(rawAbility, 10);
  return isFinite(abilityId) ? abilityId : 0;
}

function extractCurrentLevelSegment(template: string, level: number): string {
  if (!template) return "";
  if (level <= 1) {
    const nextMarker = template.indexOf("等级 2");
    return nextMarker >= 0 ? template.slice(0, nextMarker).trim() : template.trim();
  }

  const currentMarker = `等级 ${level}`;
  const currentStart = template.indexOf(currentMarker);
  if (currentStart < 0) return template.trim();

  let nextLevel = level + 1;
  let nextStart = -1;
  while (nextLevel <= 20 && nextStart < 0) {
    nextStart = template.indexOf(`等级 ${nextLevel}`, currentStart + currentMarker.length);
    nextLevel++;
  }

  return (nextStart >= 0 ? template.slice(currentStart, nextStart) : template.slice(currentStart)).trim();
}

function renderTooltipText(hero: any, rawTemplate: string, level: number): string {
  let result = extractCurrentLevelSegment(rawTemplate, level);
  if (result === "") return "";

  const intelligence = jass.GetHeroInt(hero, true) || 0;
  const intTimes3 = (intelligence * 3).toString();
  const intTimes3AndLevel = (intelligence * 3 * level).toString();

  result = replaceAllText(result, "智力×3×技能等级", intTimes3AndLevel);
  result = replaceAllText(result, "智力x3x技能等级", intTimes3AndLevel);
  result = replaceAllText(result, "智力*3*技能等级", intTimes3AndLevel);
  result = replaceAllText(result, "智力×3", intTimes3);
  result = replaceAllText(result, "智力x3", intTimes3);
  result = replaceAllText(result, "智力*3", intTimes3);
  result = replaceAllText(result, "技能等级", level.toString());
  return result;
}

function recordHeroSlotAbility(hero: any, slotKey: typeof SLOT_KEYS[number], abilityId: number): void {
  if (!hero || hero === 0 || !abilityId) return;
  YDUserDataSet("unit", hero, slotKey, "integer", abilityId);
}

function getHeroSlotAbility(hero: any, slotKey: typeof SLOT_KEYS[number]): number {
  const abilityId = YDUserDataGet("unit", hero, slotKey, "integer");
  return typeof abilityId === "number" ? abilityId : 0;
}

function refreshOneSlot(hero: any, slotKey: typeof SLOT_KEYS[number], column: number): void {
  if (!hero || hero === 0) return;

  let abilityId = resolveAbilityIdBySlot(column);
  if (abilityId) {
    recordHeroSlotAbility(hero, slotKey, abilityId);
  } else {
    abilityId = getHeroSlotAbility(hero, slotKey);
  }
  if (!abilityId) return;

  const level = jass.GetUnitAbilityLevel(hero, abilityId) || 0;
  if (level <= 0) return;

  const rawTemplate = getObjectProperty(ObjectType.ABILITY, abilityId, "Researchubertip") || "";
  if (rawTemplate === "") return;

  const renderedText = renderTooltipText(hero, rawTemplate, level);
  if (renderedText === "") return;

  YDWESetUnitAbilityDataString(hero, abilityId, level, ABILITY_DATA_UBERTIP, renderedText);
}

function refreshHeroQWER(hero: any): void {
  refreshOneSlot(hero, SLOT_KEYS[0], SLOT_COLUMNS[0]);
  refreshOneSlot(hero, SLOT_KEYS[1], SLOT_COLUMNS[1]);
  refreshOneSlot(hero, SLOT_KEYS[2], SLOT_COLUMNS[2]);
  refreshOneSlot(hero, SLOT_KEYS[3], SLOT_COLUMNS[3]);
}

function onPeriodicUpdate(): void {
  const hero = getSelectedRegisteredHeroForLocalPlayer();
  if (!hero || hero === 0) return;
  refreshHeroQWER(hero);
}

export function initSkillButtonHover(this: any): void {
  if (periodicInstalled) return;
  periodicInstalled = true;

  const { addPeriodicCallback } = globalThis as unknown as {
    addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  };
  addPeriodicCallback(UPDATE_INTERVAL_MS, onPeriodicUpdate);
}

export function onPlayerHeroRegistered(this: any, whichPlayer: any, whichHero: any): void {
  if (!whichPlayer || whichPlayer === 0 || !whichHero || whichHero === 0) return;
  YDUserDataSet("unit", whichHero, SLOT_KEYS[0], "integer", 0);
  YDUserDataSet("unit", whichHero, SLOT_KEYS[1], "integer", 0);
  YDUserDataSet("unit", whichHero, SLOT_KEYS[2], "integer", 0);
  YDUserDataSet("unit", whichHero, SLOT_KEYS[3], "integer", 0);
}
