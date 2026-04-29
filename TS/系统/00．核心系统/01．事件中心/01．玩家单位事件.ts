/** @noSelfInFile */
// Shared player-unit event registry.
// Native TriggerRegisterPlayerUnitEvent is registered once per player/event.

const jass = require("jass.common") as any;

export const DEFAULT_PLAYER_UNIT_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 13] as const;

const dispatchTriggers: Record<string, any[]> = {};
const registeredKeys: Record<string, boolean> = {};
let masterTrigger: any = null;

function normalizeFilter(filter?: any): any {
  return filter == null ? null : filter;
}

function eventKey(player: any, eventId: any): string {
  const playerId = jass.GetPlayerId(player);
  return tostring(playerId) + ":" + tostring(eventId);
}

function currentEventKey(): string {
  const player = jass.GetTriggerPlayer();
  const playerId = jass.GetPlayerId(player);
  const eventId = jass.GetTriggerEventId();
  return tostring(playerId) + ":" + tostring(eventId);
}

function hasTrigger(list: any[], trig: any): boolean {
  for (let i = 0; i < list.length; i++) {
    if (list[i] === trig) return true;
  }
  return false;
}

function dispatchPlayerUnitEvent(key: string): void {
  const list = dispatchTriggers[key];
  if (!list) return;
  for (let i = 0; i < list.length; i++) {
    const trig = list[i];
    if (!trig) continue;
    const passed = typeof jass.TriggerEvaluate === "function" ? jass.TriggerEvaluate(trig) : true;
    if (passed) jass.TriggerExecute(trig);
  }
}

function dispatchPlayerUnitEventMaster(): void {
  dispatchPlayerUnitEvent(currentEventKey());
}

function ensureMasterTrigger(): any {
  if (masterTrigger) return masterTrigger;
  masterTrigger = jass.CreateTrigger();
  jass.TriggerAddAction(masterTrigger, dispatchPlayerUnitEventMaster);
  return masterTrigger;
}

function ensureNativeRegistration(player: any, eventId: any, key: string): void {
  if (registeredKeys[key]) return;
  const master = ensureMasterTrigger();
  registeredKeys[key] = true;
  dispatchTriggers[key] = dispatchTriggers[key] || [];
  jass.TriggerRegisterPlayerUnitEvent(master, player, eventId, null);
}

export function registerPlayerUnitEvent(trig: any, player: any, eventId: any, filter?: any): void {
  if (!trig || !player || !eventId) return;
  const normalizedFilter = normalizeFilter(filter);
  if (normalizedFilter) {
    jass.TriggerRegisterPlayerUnitEvent(trig, player, eventId, normalizedFilter);
    return;
  }
  const key = eventKey(player, eventId);
  ensureNativeRegistration(player, eventId, key);
  const list = dispatchTriggers[key];
  if (!hasTrigger(list, trig)) list.push(trig);
}

export function registerPlayerUnitEventById(trig: any, playerId: number, eventId: any, filter?: any): void {
  registerPlayerUnitEvent(trig, jass.Player(playerId), eventId, filter);
}

export function registerPlayerUnitEventForPlayerIds(
  trig: any,
  playerIds: readonly number[],
  eventId: any,
  filter?: any
): void {
  if (!trig || !eventId) return;
  for (let i = 0; i < playerIds.length; i++) {
    registerPlayerUnitEventById(trig, playerIds[i], eventId, filter);
  }
}

export function registerDefaultPlayerUnitEvent(trig: any, eventId: any, filter?: any): void {
  registerPlayerUnitEventForPlayerIds(trig, DEFAULT_PLAYER_UNIT_EVENT_PLAYER_IDS, eventId, filter);
}

export {};
