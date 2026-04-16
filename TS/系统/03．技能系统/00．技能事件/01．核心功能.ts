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

const { TriggerRegisterAnyUnitEventBJ } = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterAnyUnitEventBJ: (trig: any, whichEvent: any) => void;
};

type SpellCallback = (castingUnit: any, spellAbilityId: number) => void;

const channelListeners: SpellCallback[] = [];
const effectListeners: SpellCallback[] = [];

let _initialized = false;

function onSpellChannel(this: void): void {
  const castingUnit = jass.GetTriggerUnit();
  if (castingUnit == null) return;
  const spellAbilityId = jass.GetSpellAbilityId();
  if (spellAbilityId == null) return;

  for (let i = 0; i < channelListeners.length; i++) {
    const cb = channelListeners[i];
    if (typeof cb === "function") {
      cb(castingUnit, spellAbilityId);
    }
  }
}

function onSpellEffect(this: void): void {
  const castingUnit = jass.GetTriggerUnit();
  if (castingUnit == null) return;
  const spellAbilityId = jass.GetSpellAbilityId();
  if (spellAbilityId == null) return;

  for (let i = 0; i < effectListeners.length; i++) {
    const cb = effectListeners[i];
    if (typeof cb === "function") {
      cb(castingUnit, spellAbilityId);
    }
  }
}

export function registerSpellChannelListener(callback: SpellCallback): void {
  if (typeof callback !== "function") return;
  channelListeners.push(callback);
}

export function unregisterSpellChannelListener(callback: SpellCallback): void {
  const idx = channelListeners.indexOf(callback);
  if (idx >= 0) channelListeners.splice(idx, 1);
}

export function registerSpellEffectListener(callback: SpellCallback): void {
  if (typeof callback !== "function") return;
  effectListeners.push(callback);
}

export function unregisterSpellEffectListener(callback: SpellCallback): void {
  const idx = effectListeners.indexOf(callback);
  if (idx >= 0) effectListeners.splice(idx, 1);
}

export function init(this: void): void {
  if (_initialized) return;
  _initialized = true;

  const channelTrig = jass.CreateTrigger();
  TriggerRegisterAnyUnitEventBJ(channelTrig, jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL);
  jass.TriggerAddAction(channelTrig, onSpellChannel);

  const effectTrig = jass.CreateTrigger();
  TriggerRegisterAnyUnitEventBJ(effectTrig, jass.EVENT_PLAYER_UNIT_SPELL_EFFECT);
  jass.TriggerAddAction(effectTrig, onSpellEffect);
}

export {};
