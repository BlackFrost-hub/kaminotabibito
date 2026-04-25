/**
 * 技能事件系统 - 核心功能
 *
 * 统一注册技能相关事件，提供回调注册接口供其他系统调用。
 * 避免每个系统各自创建技能触发器造成浪费。
 *
 * 支持事件：
 *   - SPELL_CHANNEL  准备使用技能
 *   - SPELL_EFFECT   发动技能效果
 *
 * 使用方式：
 *   const { registerSpellChannelListener, registerSpellEffectListener } =
 *     require("系统.03．技能系统.00．技能事件.01．核心功能") as { ... };
 *
 *   registerSpellChannelListener((castingUnit, spellAbilityId) => {
 *     // 处理准备施法逻辑
 *   });
 *
 *   registerSpellEffectListener((castingUnit, spellAbilityId) => {
 *     // 处理发动技能效果逻辑
 *   });
 */

const jass = require("jass.common") as any;

const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
  registerPlayerUnitEventForPlayerIds: (this: void, trig: any, playerIds: readonly number[], eventId: any, filter?: any) => void;
};

type SpellCallback = (castingUnit: any, spellAbilityId: number) => void;

const channelListeners: SpellCallback[] = [];
const effectListeners: SpellCallback[] = [];
const SPELL_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] as const;

let _initialized = false;

function hasListener(list: SpellCallback[], callback: SpellCallback): boolean {
  for (let i = 0; i < list.length; i++) {
    if (list[i] === callback) return true;
  }
  return false;
}

function dispatchSpellListeners(list: SpellCallback[], castingUnit: any, spellAbilityId: number): void {
  for (let i = 0; i < list.length; i++) {
    const callback = list[i];
    if (callback != null) callback(castingUnit, spellAbilityId);
  }
}

function onSpellChannel(this: void): void {
  const castingUnit = jass.GetTriggerUnit();
  if (castingUnit == null) return;
  const spellAbilityId = jass.GetSpellAbilityId();
  if (spellAbilityId == null) return;

  dispatchSpellListeners(channelListeners, castingUnit, spellAbilityId);
}

function onSpellEffect(this: void): void {
  const castingUnit = jass.GetTriggerUnit();
  if (castingUnit == null) return;
  const spellAbilityId = jass.GetSpellAbilityId();
  if (spellAbilityId == null) return;

  dispatchSpellListeners(effectListeners, castingUnit, spellAbilityId);
}

export function registerSpellChannelListener(callback: SpellCallback): void {
  if (typeof callback !== "function") return;
  init();
  if (!hasListener(channelListeners, callback)) channelListeners.push(callback);
}

export function unregisterSpellChannelListener(callback: SpellCallback): void {
  const idx = channelListeners.indexOf(callback);
  if (idx >= 0) channelListeners.splice(idx, 1);
}

export function registerSpellEffectListener(callback: SpellCallback): void {
  if (typeof callback !== "function") return;
  init();
  if (!hasListener(effectListeners, callback)) effectListeners.push(callback);
}

export function unregisterSpellEffectListener(callback: SpellCallback): void {
  const idx = effectListeners.indexOf(callback);
  if (idx >= 0) effectListeners.splice(idx, 1);
}

export function init(this: void): void {
  if (_initialized) return;
  _initialized = true;

  const channelTrig = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(channelTrig, SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL);
  jass.TriggerAddAction(channelTrig, onSpellChannel);

  const effectTrig = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(effectTrig, SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SPELL_EFFECT);
  jass.TriggerAddAction(effectTrig, onSpellEffect);
}

export {};
