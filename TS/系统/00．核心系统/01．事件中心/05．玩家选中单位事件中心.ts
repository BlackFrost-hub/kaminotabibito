/** @noSelfInFile */
// 玩家选中单位事件中心
// 使用本地库 TriggerRegisterPlayerSelectionEventBJ 注册选中/取消选中事件
// 维护每个玩家的唯一选中单位（仅单选语义）

const jass = require("jass.common") as any;

// playerId → 当前选中的单位（null 表示无选中或多选）
const selectedUnit: Record<number, any | null> = {};
// playerId → 当前选中计数（用于判断多选）
const selectedCount: Record<number, number> = {};
// playerId → 选中单位数组（仅用于维护单选/多选语义，避免生成 Lua 后落回 pairs）
const selectedUnitsByPlayer: Record<number, any[]> = {};

let _initialized = false;
const registeredPlayers: Record<number, true | undefined> = {};

/**
 * 输出调试信息
 */
function dbg(this: void, tag: string, ...args: any[]): void {
  const p = (globalThis as any).print as ((m: string) => void) | undefined;
  if (typeof p === "function") {
    const parts: string[] = [];
    for (const a of args) {
      if (a === null) parts.push("null");
      else if (a === undefined) parts.push("undef");
      else parts.push(String(a));
    }
    p("[SelectionCenter] " + tag + " " + parts.join(" "));
  }
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
  const count = list.length;
  selectedCount[playerId] = count;
  selectedUnit[playerId] = count === 1 ? list[0] : null;
}

function isRealUnit(unit: any): boolean {
  return !!unit && unit !== 0 && jass.GetUnitTypeId(unit) !== 0;
}

function getUnitHandleId(unit: any): number {
  if (!unit || unit === 0) return 0;
  return typeof jass.GetHandleId === "function" ? jass.GetHandleId(unit) : 0;
}

function findSelectedUnitIndex(list: any[], unit: any): number {
  const hid = getUnitHandleId(unit);
  if (hid === 0) return -1;
  for (let i = 0; i < list.length; i++) {
    if (getUnitHandleId(list[i]) === hid) return i;
  }
  return -1;
}

/**
 * 处理选中/取消选择事件
 * @param isSelected - true表示选中事件，false表示取消选择事件
 * @remarks
 * - 选中单位：记录为当前选中单位
 * - 选中物品：视为取消选择当前单位
 * - 选中其他（既不是单位也不是物品）：视为取消选择当前单位
 * - 取消选择：清空选中单位
 */
function handleSelectionEvent(isSelected: boolean): void {
  const player = jass.GetTriggerPlayer();
  if (!player || player === 0) return;

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

  const unitName = typeof (jass as any).GetUnitName === "function" ? (jass as any).GetUnitName(unit) : "unknown";
  const hid = getUnitHandleId(unit);
  if (hid === 0) return;

  const list = getSelectedUnitList(playerId);
  if (isSelected) {
    if (findSelectedUnitIndex(list, unit) < 0) {
      list.push(unit);
    }
    dbg("SELECTED", "playerId=" + playerId, "unit=" + unit, "hid=" + hid, "name=" + unitName);
  } else {
    const index = findSelectedUnitIndex(list, unit);
    if (index >= 0) {
      list.splice(index, 1);
    }
    dbg("DESELECTED", "playerId=" + playerId, "unit=" + unit, "hid=" + hid, "name=" + unitName);
  }
  refreshPlayerSelectionSummary(playerId);
}

function onPlayerUnitSelectedAction(): void { handleSelectionEvent(true); }
function onPlayerUnitDeselectedAction(): void { handleSelectionEvent(false); }

function isValidPlayer(whichPlayer: any): boolean {
  return !!whichPlayer && whichPlayer !== 0;
}

/**
 * 为单个玩家注册选中/取消选择触发器。
 */
function registerSelectionTriggersForPlayer(whichPlayer: any): void {
  if (!isValidPlayer(whichPlayer)) return;
  const playerId = jass.GetPlayerId(whichPlayer);
  if (registeredPlayers[playerId]) return;
  const hasDeselectEvent = (jass as any).EVENT_PLAYER_UNIT_DESELECTED !== undefined &&
                           (jass as any).EVENT_PLAYER_UNIT_DESELECTED !== null;
  const trigSel = jass.CreateTrigger();
  const selResult = jass.TriggerRegisterPlayerUnitEvent(trigSel, whichPlayer, jass.EVENT_PLAYER_UNIT_SELECTED, null);
  if (selResult) {
    jass.TriggerAddAction(trigSel, onPlayerUnitSelectedAction);
  }
  if (hasDeselectEvent) {
    const trigDesel = jass.CreateTrigger();
    const deselResult = jass.TriggerRegisterPlayerUnitEvent(trigDesel, whichPlayer, jass.EVENT_PLAYER_UNIT_DESELECTED, null);
    if (deselResult) {
      jass.TriggerAddAction(trigDesel, onPlayerUnitDeselectedAction);
    }
  }
  registeredPlayers[playerId] = true;
  _initialized = true;
}

/**
 * 为指定玩家初始化选中单位事件监听。
 */
export function initPlayerSelectionCenter(this: void, whichPlayer: any): void {
  registerSelectionTriggersForPlayer(whichPlayer);
}

/**
 * 获取玩家当前唯一选中的单位
 * @param playerId - 玩家ID（0-15）
 * @returns 如果玩家只选中了一个单位，返回该单位；否则返回null
 */
export function getSoleSelectedUnitForPlayer(playerId: number): any | null {
  const unit = selectedUnit[playerId];
  const count = selectedCount[playerId] || 0;
  if (!unit || unit === 0) return null;
  if (count !== 1) return null;
  return unit;
}
