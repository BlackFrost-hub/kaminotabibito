/** @noSelfInFile */
// Centralized spell event registration.

const jass = require("jass.common") as any;

const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
  registerPlayerUnitEventForPlayerIds: (this: void, trig: any, playerIds: readonly number[], eventId: any, filter?: any) => void;
};

type SpellCallback = (this: void, castingUnit: any, spellAbilityId: number) => void;
type SkillLearnCallback = (learningUnit: any, learnedAbilityId: number) => void;

export const SPELL_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] as const;

const channelListeners: SpellCallback[] = [];
const effectListeners: SpellCallback[] = [];
const endcastListeners: SpellCallback[] = [];
const skillLearnListeners: SkillLearnCallback[] = [];
let initialized = false;
let skillLearnInitialized = false;

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

function dispatchSkillLearnListeners(list: SkillLearnCallback[], learningUnit: any, learnedAbilityId: number): void {
  for (let i = 0; i < list.length; i++) {
    const callback = list[i];
    if (callback != null) callback(learningUnit, learnedAbilityId);
  }
}

function onSpellChannel(): void {
  const castingUnit = jass.GetTriggerUnit();
  if (castingUnit == null) return;
  const spellAbilityId = jass.GetSpellAbilityId();
  if (spellAbilityId == null) return;

  dispatchSpellListeners(channelListeners, castingUnit, spellAbilityId);
}

function onSpellEffect(): void {
  const castingUnit = jass.GetTriggerUnit();
  if (castingUnit == null) return;
  const spellAbilityId = jass.GetSpellAbilityId();
  if (spellAbilityId == null) return;

  dispatchSpellListeners(effectListeners, castingUnit, spellAbilityId);
}

function onSpellEndcast(): void {
  const castingUnit = jass.GetTriggerUnit();
  if (castingUnit == null) return;
  const spellAbilityId = jass.GetSpellAbilityId();
  if (spellAbilityId == null) return;

  dispatchSpellListeners(endcastListeners, castingUnit, spellAbilityId);
}

function onSkillLearn(): void {
  const learningUnit = jass.GetTriggerUnit();
  if (learningUnit == null) return;
  const learnedAbilityId = jass.GetLearnedSkill();
  if (learnedAbilityId == null) return;

  dispatchSkillLearnListeners(skillLearnListeners, learningUnit, learnedAbilityId);
}

/**
 * 注册技能准备阶段监听。
 * 第一次使用时会自动初始化事件中心；同一回调不会重复注册。
 */
export function registerSpellChannelListener(callback: SpellCallback): void {
  if (typeof callback !== "function") return;
  initSpellEventCenter();
  if (!hasListener(channelListeners, callback)) channelListeners.push(callback);
}

/**
 * 取消技能准备阶段监听。
 */
export function unregisterSpellChannelListener(callback: SpellCallback): void {
  const index = channelListeners.indexOf(callback);
  if (index >= 0) channelListeners.splice(index, 1);
}

/**
 * 注册技能生效阶段监听。
 * 第一次使用时会自动初始化事件中心；同一回调不会重复注册。
 */
export function registerSpellEffectListener(callback: SpellCallback): void {
  if (typeof callback !== "function") return;
  initSpellEventCenter();
  if (!hasListener(effectListeners, callback)) effectListeners.push(callback);
}

/**
 * 取消技能生效阶段监听。
 */
export function unregisterSpellEffectListener(callback: SpellCallback): void {
  const index = effectListeners.indexOf(callback);
  if (index >= 0) effectListeners.splice(index, 1);
}

/**
 * 注册技能结束施法监听。
 * 第一次使用时会自动初始化事件中心；同一回调不会重复注册。
 */
export function registerSpellEndcastListener(this: void, callback: SpellCallback): void {
  if (typeof callback !== "function") return;
  initSpellEventCenter();
  if (!hasListener(endcastListeners, callback)) endcastListeners.push(callback);
}

/**
 * 取消技能结束施法监听。
 */
export function unregisterSpellEndcastListener(this: void, callback: SpellCallback): void {
  const index = endcastListeners.indexOf(callback);
  if (index >= 0) endcastListeners.splice(index, 1);
}

/**
 * 注册学习技能监听。
 * 第一次使用时会自动初始化事件；同一回调不会重复注册。
 */
export function registerSkillLearnListener(callback: SkillLearnCallback): void {
  if (typeof callback !== "function") return;
  initSkillLearnEvent();
  if (!hasListener(skillLearnListeners, callback as any)) skillLearnListeners.push(callback);
}

/**
 * 取消学习技能监听。
 */
export function unregisterSkillLearnListener(callback: SkillLearnCallback): void {
  const index = skillLearnListeners.indexOf(callback);
  if (index >= 0) skillLearnListeners.splice(index, 1);
}

/**
 * 初始化技能事件中心。
 * 统一注册 SPELL_CHANNEL / SPELL_EFFECT / SPELL_ENDCAST 三类原生事件，并集中派发给监听器。
 */
export function initSpellEventCenter(): void {
  if (initialized) return;
  initialized = true;

  const channelTrigger = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(channelTrigger, SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL);
  jass.TriggerAddAction(channelTrigger, onSpellChannel);

  const effectTrigger = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(effectTrigger, SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SPELL_EFFECT);
  jass.TriggerAddAction(effectTrigger, onSpellEffect);

  const endcastTrigger = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(endcastTrigger, SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SPELL_ENDCAST);
  jass.TriggerAddAction(endcastTrigger, onSpellEndcast);
}

/**
 * 初始化学习技能事件。
 */
export function initSkillLearnEvent(): void {
  if (skillLearnInitialized) return;
  skillLearnInitialized = true;

  const learnTrigger = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(learnTrigger, SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_HERO_SKILL);
  jass.TriggerAddAction(learnTrigger, onSkillLearn);
}

export {};
