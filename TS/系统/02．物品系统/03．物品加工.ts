/** @noSelfInFile */
/**
 * 物品加工系统（篝火 h00C）
 *
 * 触发：
 * - 玩家1-4（Player(0..3)）单位拾取物品：EVENT_PLAYER_UNIT_PICKUP_ITEM
 *
 * 规则：
 * - 只有“篝火单位（h00C）”拾取物品才进入加工/烤焦逻辑
 * - 玩家从篝火取回物品：表现为“其他单位拾取该 item”，此时取消对应计时器
 *
 * recipe 格式：
 *   h00C:加工秒数->结果:超时秒数
 *   结果支持多项，用 ; 分隔；支持概率：20%I036*1；支持数量：I02H*2
 *   示例：
 *   - h00C:10->I02H*2:5
 *   - h00C:20->I034*1;20%I036*1:5
 */

const jass = require("jass.common") as any;
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (timer: any) => void;
};
const itemEventCenter = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (callback: (unit: any, item: any) => void) => number;
  onItemDrop: (callback: (unit: any, item: any) => void) => number;
};
const itemRelatedFns = require("lib.扩展函数.物品相关函数.index") as {
  getItemDataEntry: (this: void, item: any) => any | null;
};
const { withTimer, stopTimer, createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  withTimer: (delaySec: number, callback: () => void) => any;
  stopTimer: (t: any) => void;
  createTimedEffect: (modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const 漂浮文字模块 = require("lib.扩展函数.封装函数.03．漂浮文字.index") as {
  CreateFloatTextAtPoint: (this: void, x: number, y: number, text: string, options?: any) => any;
};
const CreateFloatTextAtPoint = 漂浮文字模块.CreateFloatTextAtPoint as
  | ((this: void, x: number, y: number, text: string, options?: any) => any)
  | undefined;
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (s: string) => number;
};
const { setLastCreatedItem } = require("系统.02．物品系统.09．装备排泄") as {
  setLastCreatedItem: (item: any) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const CAMPFIRE_ID = 0x68303043; // 'h00C'
const EFFECT_FIREBOMB = "war3mapImported\\Firebomb.mdl";
const CAMPFIRE_EVENT_PLAYER_IDS = [0, 1, 2, 3] as const;

type ResultOpt = { prob?: number; itemId: number; qty: number };
type RecipeParsed = { cookSec: number; timeoutSec: number; results: ResultOpt[] };

type ItemState = {
  item: any;
  campfire: any;
  stage: "raw" | "done";
  cookTimer?: any;
  burnTimer?: any;
};

const itemState = new Map<number, ItemState>();       // itemHandleId -> state
const campfireItems = new Map<number, Set<number>>(); // campfireHandleId -> itemHandleId 集合

const burnTimerCtxByHid: Record<number, { item: any; campfire: any }> = {};
const cookTimerCtxByHid: Record<number, { item: any; campfire: any; timeoutSec: number; results: ResultOpt[] }> = {};

function getHandleIdSafe(handle: any): number {
  if (!handle) return 0;
  return ((jass as any).GetHandleId(handle) as number) || 0;
}

function onBurnTimerExpire(this: void): void {
  const t = (jass as any).GetExpiredTimer();
  if (!t) return;
  const hid = (jass as any).GetHandleId(t) as number;
  const ctx = burnTimerCtxByHid[hid];
  delete burnTimerCtxByHid[hid];
  if (!ctx) return;
  const { item, campfire } = ctx;
  const itemId = getHandleIdSafe(item);
  if (itemId === 0 || !itemState.has(itemId)) return;
  const name = getItemNameSafe(item);
  floatBurnText(campfire, name);
  (jass as any).RemoveItem(item);
  untrackItem(item);
  safeDestroyTimer(t);
}

function onCookTimerExpire(this: void): void {
  const t = (jass as any).GetExpiredTimer();
  if (!t) return;
  const hid = (jass as any).GetHandleId(t) as number;
  const ctx = cookTimerCtxByHid[hid];
  delete cookTimerCtxByHid[hid];
  if (!ctx) return;
  const { item, campfire, timeoutSec, results } = ctx;
  const itemId = getHandleIdSafe(item);
  if (itemId === 0 || !itemState.has(itemId)) return;
  // 加工完成：替换物品
  playFinishEffect(campfire);

  const chosen = pickResult(results);
  const inputCharges = getItemChargesSafe(item); // 例如"生鱼大"堆叠 10 次
  // 删除原物品
  (jass as any).RemoveItem(item);
  // 从追踪中移除原 item（会销毁 cookTimer）
  untrackItem(item);

  // 生成结果：必须优先留在篝火物品栏（先删原材料，保证至少空 1 格）
  // 若一次产出多个：尽量塞进篝火；塞不下的"多余产物"按 20% 概率掉在篝火脚下，否则不生成。
  const timeout = timeoutSec > 0 ? timeoutSec : 0;
  let remaining = chosen.qty * inputCharges;

  // 先尽量塞进篝火
  while (remaining > 0) {
    const it = createItemAtCampfire(campfire, chosen.itemId);
    if (!it) break;
    // 优先把数量塞到 charges，减少占格；一次尽量放完
    setItemChargesSafe(it, remaining);
    const ok = tryGiveItemToCampfire(campfire, it);
    if (!ok) {
      // 放不进：这是"多余产物"，按 20% 概率留地上，否则移除
      const roll = (jass as any).GetRandomInt(1, 100);
      if (roll > 20) (jass as any).RemoveItem(it);
      // 若 roll<=20，就留在地上（不计入篝火超时烤焦）
    } else {
      // 在篝火内：开始超时烤焦
      const itemId = getHandleIdSafe(it);
      const campfireId = getHandleIdSafe(campfire);
      if (itemId !== 0 && campfireId !== 0) {
        itemState.set(itemId, { item: it, campfire, stage: "done" });
        let set = campfireItems.get(campfireId);
        if (!set) { set = new Set<number>(); campfireItems.set(campfireId, set); }
        set.add(itemId);
      }
      if (timeout > 0) startBurnTimer(it, campfire, timeout);
    }
    // 这次创建的 item 已承载 remaining（charges），认为全部产出已处理
    remaining = 0;
    // 若篝火满了，会进入 !ok 分支，后续都会按 20% 掉地上处理
  }
}

function isCampfire(u: any): boolean {
  return (jass as any).GetUnitTypeId(u) === CAMPFIRE_ID;
}

/** 使用 01．封装函数.ts 中的 stringToFourCC */
function fourCCToInt(id: string): number {
  return stringToFourCC(id);
}

function getItemNameSafe(item: any): string {
  return (jass as any).GetItemName(item);
}

function getItemChargesSafe(item: any): number {
  const n = (jass as any).GetItemCharges(item);
  const v = jass.R2I((Number(n as any) as any) ?? 0) || 0;
  return v > 0 ? v : 1;
}

function setItemChargesSafe(item: any, n: number): void {
  if (!item) return;
  const v = jass.R2I(n) || 1;
  (jass as any).SetItemCharges(item, v > 0 ? v : 1);
}

function getUnitXY(u: any): { x: number; y: number } {
  const x = (jass as any).GetUnitX(u);
  const y = (jass as any).GetUnitY(u);
  return { x, y };
}

function floatBurnText(campfire: any, itemName: string): void {
  if (typeof CreateFloatTextAtPoint !== "function") return;
  const { x, y } = getUnitXY(campfire);
  CreateFloatTextAtPoint(x, y, `${itemName}被烤焦了！`, {
    red: 255,
    green: 0,
    blue: 0,
    alpha: 0,
    duration: 3,
    speedY: 0.07,
    size: 10,
    height: 50,
  });
}

function playFinishEffect(campfire: any): void {
  const { x, y } = getUnitXY(campfire);
  createTimedEffect(EFFECT_FIREBOMB, x, y, 0, 2.0);
}

function getRecipeForItem(item: any): RecipeParsed | null {
  const entry = itemRelatedFns.getItemDataEntry(item);
  const recipe = entry && entry.recipe ? entry.recipe : undefined;
  if (!recipe) return null;

  // 只处理 h00C: 前缀
  const prefix = "h00C:";
  if (recipe.indexOf(prefix) !== 0) return null;
  const rest = recipe.substring(prefix.length);
  const arrowIdx = rest.indexOf("->");
  // Lua 5.1 目标不支持 lastIndexOf，这里手动找最后一个 ':'
  let colonIdx = -1;
  for (let i = rest.length - 1; i >= 0; i--) {
    if (rest.substring(i, i + 1) === ":") { colonIdx = i; break; }
  }
  if (arrowIdx < 0 || colonIdx < 0 || colonIdx <= arrowIdx + 2) return null;

  const cookStr = rest.substring(0, arrowIdx).trim();
  const resultsStr = rest.substring(arrowIdx + 2, colonIdx).trim();
  const timeoutStr = rest.substring(colonIdx + 1).trim();

  const cookSec = jass.R2I(parseFloat(cookStr) || 0);
  const timeoutSec = jass.R2I(parseFloat(timeoutStr) || 0);
  if (cookSec <= 0) return null;

  const rawOpts = resultsStr.split(";").map((s: string) => s.trim()).filter((s: string) => s !== "");
  if (rawOpts.length === 0) return null;

  const opts: ResultOpt[] = [];
  for (const raw of rawOpts) {
    let s = raw;
    let prob: number | undefined = undefined;
    const pctIdx = s.indexOf("%");
    if (pctIdx > 0) {
      const p = parseFloat(s.substring(0, pctIdx).trim());
      if (!isNaN(p) && p > 0) prob = p;
      s = s.substring(pctIdx + 1).trim();
    }
    const starIdx = s.indexOf("*");
    const idPart = (starIdx >= 0 ? s.substring(0, starIdx) : s).trim();
    const qtyPart = (starIdx >= 0 ? s.substring(starIdx + 1) : "").trim();
    const qty = jass.R2I(parseFloat(qtyPart) || 1);
    const itemId = fourCCToInt(idPart);
    if (itemId !== 0 && qty > 0) opts.push({ prob, itemId, qty });
  }
  if (opts.length === 0) return null;

  return { cookSec, timeoutSec, results: opts };
}

function pickResult(results: ResultOpt[]): ResultOpt {
  let sumExplicit = 0;
  let unspecified = 0;
  for (const r of results) {
    if (typeof r.prob === "number") sumExplicit += r.prob;
    else unspecified++;
  }
  let base = 0;
  if (unspecified > 0) {
    const remain = 100 - sumExplicit;
    base = remain > 0 ? remain / unspecified : 0;
  }
  let total = 0;
  const weights: number[] = [];
  for (let i = 0; i < results.length; i++) {
    const w = typeof results[i].prob === "number" ? (results[i].prob as number) : base;
    const ww = w > 0 ? w : 0;
    weights[i] = ww;
    total += ww;
  }
  // 全 0：均匀
  if (total <= 0) {
    const idx = (jass as any).GetRandomInt(1, results.length);
    return (results as any)[idx];
  }
  let roll = ((jass as any).GetRandomReal(0, 1) as number) * total;
  for (let i = 0; i < results.length; i++) {
    roll -= weights[i];
    if (roll <= 0) return results[i];
  }
  return results[results.length - 1];
}

function createItemAtCampfire(campfire: any, itemId: number): any {
  const { x, y } = getUnitXY(campfire);
  const item = (jass as any).CreateItem(itemId, x, y);
  if (item) setLastCreatedItem(item);
  return item;
}

function tryGiveItemToCampfire(campfire: any, item: any): boolean {
  if (!item) return false;
  return !!(jass as any).UnitAddItem(campfire, item);
}

function stopAndDestroyTimer(t: any): void {
  if (!t) return;
  stopTimer(t);
  (jass as any).DestroyTimer(t);
}

function untrackItem(item: any): void {
  const itemId = getHandleIdSafe(item);
  if (itemId === 0) return;
  const st = itemState.get(itemId);
  if (!st) return;
  if (st.cookTimer) stopAndDestroyTimer(st.cookTimer);
  if (st.burnTimer) stopAndDestroyTimer(st.burnTimer);
  itemState.delete(itemId);

  const campfireId = getHandleIdSafe(st.campfire);
  const set = campfireItems.get(campfireId);
  if (set) {
    set.delete(itemId);
    if (set.size === 0) campfireItems.delete(campfireId);
  }
}

function startBurnTimer(item: any, campfire: any, sec: number): void {
  const st = itemState.get(getHandleIdSafe(item));
  const t = (jass as any).CreateTimer();
  if (!t) return;
  burnTimerCtxByHid[(jass as any).GetHandleId(t) as number] = { item, campfire };
  safeTimerStart(t, sec, false, onBurnTimerExpire);
  if (st) st.burnTimer = t;
}

function startCookTimer(item: any, campfire: any, recipe: RecipeParsed): void {
  const t = (jass as any).CreateTimer();
  if (!t) return;
  const st = itemState.get(getHandleIdSafe(item));
  if (st) st.cookTimer = t;
  cookTimerCtxByHid[(jass as any).GetHandleId(t) as number] = {
    item,
    campfire,
    timeoutSec: recipe.timeoutSec,
    results: recipe.results,
  };
  safeTimerStart(t, recipe.cookSec, false, onCookTimerExpire);
}

function onAnyPickup(): void {
  const u = (jass as any).GetTriggerUnit();
  const item = (jass as any).GetManipulatedItem();
  if (!u || !item) return;

  // 取回：其他单位拾取了处于追踪中的 item
  if (!isCampfire(u)) {
    const itemId = getHandleIdSafe(item);
    if (itemId !== 0 && itemState.has(itemId)) {
      untrackItem(item);
    }
    return;
  }

  // 放入篝火
  const itemId = getHandleIdSafe(item);
  const campfireId = getHandleIdSafe(u);
  if (itemId === 0 || campfireId === 0) return;
  if (itemState.has(itemId)) return;

  const recipe = getRecipeForItem(item);
  const campfire = u;
  itemState.set(itemId, { item, campfire, stage: "raw" });
  let set = campfireItems.get(campfireId);
  if (!set) { set = new Set<number>(); campfireItems.set(campfireId, set); }
  set.add(itemId);

  if (!recipe) {
    // 无 recipe：15 秒烤焦倒计时
    startBurnTimer(item, campfire, 15);
  } else {
    // 有 recipe：加工计时器；加工完成后再开超时计时器
    startCookTimer(item, campfire, recipe);
  }
}

function onCampfireDeath(this: void, dyingUnit: any): void {
  if (!dyingUnit || !isCampfire(dyingUnit)) return;
  const campfireId = getHandleIdSafe(dyingUnit);
  const set = campfireItems.get(campfireId);
  if (!set) return;
  const itemIds = Array.from(set.values());
  for (let i = 0; i < itemIds.length; i++) {
    const st = itemState.get(itemIds[i]);
    if (st) {
      untrackItem(st.item);
    }
  }
  campfireItems.delete(campfireId);
}

export function init物品加工(): void {
  // 使用物品事件中心注册，减少触发器数量
  itemEventCenter.onItemPickup((unit, item) => {
    onAnyPickup();
  });

  itemEventCenter.onItemDrop((unit, item) => {
    const itemId = getHandleIdSafe(item);
    if (unit && item && isCampfire(unit) && itemId !== 0 && itemState.has(itemId)) {
      untrackItem(item);
    }
  });

  registerDeathListener(onCampfireDeath);
}

// 自动初始化（也可在 main.ts 显式调用）
init物品加工();

export {};
