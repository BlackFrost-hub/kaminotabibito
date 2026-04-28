/** @noSelfInFile */

const jass = require("jass.common") as any;
const { debugLog, setDebug } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (module: string, ...args: any[]) => void;
  setDebug: (module: string, on: boolean) => void;
};

type SelectionListener = (player: any, playerId: number, unit: any, isSelected: boolean) => void;

const selectedUnit: Record<number, any | null> = {};
const selectedCount: Record<number, number> = {};
const selectedUnitsByPlayer: Record<number, any[]> = {};
const selectionListeners: SelectionListener[] = [];
const registeredPlayers: Record<number, true | undefined> = {};

let selectedTrigger: any = null;
let deselectedTrigger: any = null;
let initialized = false;

const hasDeselectEvent =
  (jass as any).EVENT_PLAYER_UNIT_DESELECTED !== undefined &&
  (jass as any).EVENT_PLAYER_UNIT_DESELECTED !== null;

// 启用调试（仅关键事件）
setDebug("SelectionCenter", true);

function dbg(tag: string, ...args: any[]): void {
  debugLog("SelectionCenter", tag, ...args);
}

function isValidPlayer(whichPlayer: any): boolean {
  return !!whichPlayer && whichPlayer !== 0;
}

function isRealUnit(whichUnit: any): boolean {
  return !!whichUnit && whichUnit !== 0 && jass.GetUnitTypeId(whichUnit) !== 0;
}

function getUnitHandleId(whichUnit: any): number {
  if (!whichUnit || whichUnit === 0) return 0;
  return typeof jass.GetHandleId === "function" ? jass.GetHandleId(whichUnit) : 0;
}

function getSelectedUnitList(playerId: number): any[] {
  let list = selectedUnitsByPlayer[playerId];
  if (list == null) {
    list = [];
    selectedUnitsByPlayer[playerId] = list;
  }
  return list;
}

function refreshPlayerSelectionSummary(playerId: number): void {
  const list = selectedUnitsByPlayer[playerId];
  if (list == null || list.length === 0) {
    selectedCount[playerId] = 0;
    selectedUnit[playerId] = null;
    return;
  }
  selectedCount[playerId] = list.length;
  selectedUnit[playerId] = list.length === 1 ? list[0] : null;
}

function findSelectedUnitIndex(list: any[], whichUnit: any): number {
  const hid = getUnitHandleId(whichUnit);
  if (hid === 0) return -1;
  for (let i = 0; i < list.length; i++) {
    if (getUnitHandleId(list[i]) === hid) return i;
  }
  return -1;
}

function dispatchSelectionListeners(player: any, playerId: number, unit: any, isSelected: boolean): void {
  for (let i = 0; i < selectionListeners.length; i++) {
    selectionListeners[i](player, playerId, unit, isSelected);
  }
}

function handleSelectionEvent(isSelected: boolean): void {
  const player = jass.GetTriggerPlayer();
  if (!isValidPlayer(player)) return;

  const playerId = jass.GetPlayerId(player);
  const unit = jass.GetTriggerUnit();

  if (!isRealUnit(unit)) {
    if (!isSelected) {
      selectedCount[playerId] = 0;
      selectedUnit[playerId] = null;
      delete selectedUnitsByPlayer[playerId];
    }
    return;
  }

  const list = getSelectedUnitList(playerId);
  const hid = getUnitHandleId(unit);
  if (hid === 0) return;

  if (isSelected) {
    if (findSelectedUnitIndex(list, unit) < 0) {
      list.push(unit);
    }
    dbg("SELECTED", "playerId=" + playerId, "unit=" + unit, "hid=" + hid);
  } else {
    const index = findSelectedUnitIndex(list, unit);
    if (index >= 0) {
      list.splice(index, 1);
    }
    dbg("DESELECTED", "playerId=" + playerId, "unit=" + unit, "hid=" + hid);
  }

  refreshPlayerSelectionSummary(playerId);
  dispatchSelectionListeners(player, playerId, unit, isSelected);
}

function onPlayerUnitSelectedAction(): void {
  handleSelectionEvent(true);
}

function onPlayerUnitDeselectedAction(): void {
  handleSelectionEvent(false);
}

function ensureSelectionTriggers(): void {
  if (selectedTrigger == null || selectedTrigger === 0) {
    selectedTrigger = jass.CreateTrigger();
    jass.TriggerAddAction(selectedTrigger, onPlayerUnitSelectedAction);
  }
  if (hasDeselectEvent && (deselectedTrigger == null || deselectedTrigger === 0)) {
    deselectedTrigger = jass.CreateTrigger();
    jass.TriggerAddAction(deselectedTrigger, onPlayerUnitDeselectedAction);
  }
}

function registerSelectionTriggersForPlayer(whichPlayer: any): void {
  if (!isValidPlayer(whichPlayer)) return;
  const playerId = jass.GetPlayerId(whichPlayer);
  if (registeredPlayers[playerId]) return;

  ensureSelectionTriggers();

  if (selectedTrigger != null && selectedTrigger !== 0) {
    jass.TriggerRegisterPlayerUnitEvent(selectedTrigger, whichPlayer, jass.EVENT_PLAYER_UNIT_SELECTED, null);
    dbg("REGISTER", "playerId=" + playerId, "trigger=" + selectedTrigger);
  }
  if (hasDeselectEvent && deselectedTrigger != null && deselectedTrigger !== 0) {
    jass.TriggerRegisterPlayerUnitEvent(deselectedTrigger, whichPlayer, jass.EVENT_PLAYER_UNIT_DESELECTED, null);
  }

  registeredPlayers[playerId] = true;
  initialized = true;
}

export function initPlayerSelectionCenter(whichPlayer: any): void {
  registerSelectionTriggersForPlayer(whichPlayer);
}

function normalizeSelectionListener(arg1: any, arg2?: any): SelectionListener | null {
  if (typeof arg1 === "function") return arg1 as SelectionListener;
  if (typeof arg2 === "function") return arg2 as SelectionListener;
  return null;
}

export function addSelectionListener(arg1: any, arg2?: any): void {
  const listener = normalizeSelectionListener(arg1, arg2);
  if (typeof listener !== "function") return;
  if (selectionListeners.indexOf(listener) >= 0) return;
  selectionListeners.push(listener);
}

export function removeSelectionListener(arg1: any, arg2?: any): void {
  const listener = normalizeSelectionListener(arg1, arg2);
  if (typeof listener !== "function") return;
  const index = selectionListeners.indexOf(listener);
  if (index >= 0) selectionListeners.splice(index, 1);
}

export function getSoleSelectedUnitForPlayer(playerId: number): any | null {
  if (!initialized) return null;
  const unit = selectedUnit[playerId];
  const count = selectedCount[playerId] || 0;
  // 注：GET 调试已禁用，避免每0.1秒刷屏
  // dbg("GET", "playerId=" + playerId, "count=" + count, "unit=" + unit);
  if (!unit || unit === 0) return null;
  if (count !== 1) return null;
  return unit;
}
