/** @noSelfInFile */

const jass = require("jass.common") as any;

type SelectionListener = (player: any, playerId: number, unit: any, isSelected: boolean) => void;

const selectedUnit: Record<number, any | null> = {};
const selectedCount: Record<number, number> = {};
const selectedUnitsByPlayer: Record<number, any[]> = {};
const selectionListeners: SelectionListener[] = [];
const registeredPlayers: Record<number, true | undefined> = {};

let selectedTrigger: any = null;
let deselectedTrigger: any = null;
let initialized = false;

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
  } else {
    const index = findSelectedUnitIndex(list, unit);
    if (index >= 0) {
      list.splice(index, 1);
    }
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
  if (deselectedTrigger == null || deselectedTrigger === 0) {
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
  }
  if (deselectedTrigger != null && deselectedTrigger !== 0) {
    jass.TriggerRegisterPlayerUnitEvent(deselectedTrigger, whichPlayer, jass.EVENT_PLAYER_UNIT_DESELECTED, null);
  }

  registeredPlayers[playerId] = true;
  initialized = true;
}

/**
 * 为指定玩家初始化“选中/取消选中”事件中心。
 * 只会对同一玩家注册一次原生事件，后续查询与监听都依赖这里维护的缓存。
 */
export function initPlayerSelectionCenter(whichPlayer: any): void {
  registerSelectionTriggersForPlayer(whichPlayer);
}

function normalizeSelectionListener(arg1: any, arg2?: any): SelectionListener | null {
  if (typeof arg1 === "function") return arg1 as SelectionListener;
  if (typeof arg2 === "function") return arg2 as SelectionListener;
  return null;
}

/**
 * 添加选中状态监听。
 * 回调会在单位被选中或取消选中后触发，参数里会给出玩家、playerId、单位和当前是否为选中动作。
 */
export function addSelectionListener(arg1: any, arg2?: any): void {
  const listener = normalizeSelectionListener(arg1, arg2);
  if (typeof listener !== "function") return;
  if (selectionListeners.indexOf(listener) >= 0) return;
  selectionListeners.push(listener);
}

/**
 * 移除之前注册的选中状态监听。
 */
export function removeSelectionListener(arg1: any, arg2?: any): void {
  const listener = normalizeSelectionListener(arg1, arg2);
  if (typeof listener !== "function") return;
  const index = selectionListeners.indexOf(listener);
  if (index >= 0) selectionListeners.splice(index, 1);
}

/**
 * 只在“恰好选中 1 个单位”时返回该单位。
 * 多选、未选中或事件中心尚未初始化时都会返回 null。
 */
export function getSoleSelectedUnitForPlayer(playerId: number): any | null {
  if (!initialized) return null;
  const unit = selectedUnit[playerId];
  const count = selectedCount[playerId] || 0;
  if (!unit || unit === 0) return null;
  if (count !== 1) return null;
  return unit;
}

/**
 * 在外部已知玩家当前唯一选中单位时，手动把状态种进事件中心。
 * 主要用于补齐“先有选中态，后初始化事件中心”这类不会补发原生事件的场景。
 */
export function seedSoleSelectedUnitForPlayer(whichPlayer: any, whichUnit: any): void {
  if (!isValidPlayer(whichPlayer)) return;

  const playerId = jass.GetPlayerId(whichPlayer);
  jass.DisplayTextToPlayer(whichPlayer, 0, 0, `SEL_SEED_PID_${playerId}`);
  if (!isRealUnit(whichUnit)) {
    jass.DisplayTextToPlayer(whichPlayer, 0, 0, "SEL_SEED_UNIT_INVALID");
    selectedCount[playerId] = 0;
    selectedUnit[playerId] = null;
    delete selectedUnitsByPlayer[playerId];
    return;
  }

  selectedUnitsByPlayer[playerId] = [whichUnit];
  selectedCount[playerId] = 1;
  selectedUnit[playerId] = whichUnit;
  jass.DisplayTextToPlayer(whichPlayer, 0, 0, `SEL_SEED_UNIT_${getUnitHandleId(whichUnit)}`);
}

/**
 * 返回指定玩家当前选中缓存的摘要，便于调试事件中心是否成功记录状态。
 */
export function getSelectionDebugForPlayer(playerId: number): string {
  const count = selectedCount[playerId] || 0;
  const unit = selectedUnit[playerId];
  const handleId = getUnitHandleId(unit);
  return `init=${initialized ? 1 : 0},count=${count},unit=${handleId}`;
}
