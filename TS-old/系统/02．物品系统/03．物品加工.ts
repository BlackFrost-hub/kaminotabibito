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
const itemsData = (require("系统.02．物品系统.01．装备数据") as { default: Record<string, { recipe?: string }> }).default;
const { withTimer, stopTimer, createTimedEffect } = require("系统.00．核心系统.01．封装函数") as {
  withTimer: (delaySec: number, callback: () => void) => any;
  stopTimer: (t: any) => void;
  createTimedEffect: (modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { CreateFloatTextAtPoint } = require("系统.00．核心系统.03．漂浮文字函数") as {
  CreateFloatTextAtPoint: (x: number, y: number, text: string, options?: any) => any;
};
const { stringToFourCC, fourCCToString } = require("系统.00．核心系统.01．封装函数") as {
  stringToFourCC: (s: string) => number;
  fourCCToString: (fourcc: number) => string;
};

const CAMPFIRE_ID = 0x68303043; // 'h00C'
const EFFECT_FIREBOMB = "war3mapImported\\Firebomb.mdl";

type ResultOpt = { prob?: number; itemId: number; qty: number };
type RecipeParsed = { cookSec: number; timeoutSec: number; results: ResultOpt[] };

type ItemState = {
  campfire: any;
  stage: "raw" | "done";
  cookTimer?: any;
  burnTimer?: any;
};

const itemState = new Map<any, ItemState>();          // item -> state
const campfireItems = new Map<any, Set<any>>();       // campfire -> items

function isCampfire(u: any): boolean {
  return typeof (jass as any).GetUnitTypeId === "function" && (jass as any).GetUnitTypeId(u) === CAMPFIRE_ID;
}

/** 使用 01．封装函数.ts 中的 stringToFourCC */
function fourCCToInt(id: string): number {
  return stringToFourCC(id);
}

/** 使用 01．封装函数.ts 中的 fourCCToString */
function getItemIdStr(item: any): string {
  const itemId = typeof (jass as any).GetItemTypeId === "function" ? (jass as any).GetItemTypeId(item) : 0;
  return fourCCToString(itemId);
}

function getItemNameSafe(item: any): string {
  return typeof (jass as any).GetItemName === "function" ? (jass as any).GetItemName(item) : "物品";
}

function getItemChargesSafe(item: any): number {
  if (typeof (jass as any).GetItemCharges !== "function") return 1;
  const n = (jass as any).GetItemCharges(item);
  const v = Math.floor((Number(n as any) as any) ?? 0) || 0;
  return v > 0 ? v : 1;
}

function setItemChargesSafe(item: any, n: number): void {
  if (!item) return;
  if (typeof (jass as any).SetItemCharges !== "function") return;
  const v = Math.floor(n) || 1;
  (jass as any).SetItemCharges(item, v > 0 ? v : 1);
}

function getUnitXY(u: any): { x: number; y: number } {
  const x = typeof (jass as any).GetUnitX === "function" ? (jass as any).GetUnitX(u) : 0;
  const y = typeof (jass as any).GetUnitY === "function" ? (jass as any).GetUnitY(u) : 0;
  return { x, y };
}

function floatBurnText(campfire: any, itemName: string): void {
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
  if (typeof (jass as any).AddSpecialEffect !== "function") return;
  const { x, y } = getUnitXY(campfire);
  createTimedEffect(EFFECT_FIREBOMB, x, y, 0, 2.0);
}

function getRecipeForItem(item: any): RecipeParsed | null {
  const idStr = getItemIdStr(item);
  const entry = (itemsData as any)[idStr] as { recipe?: string } | undefined;
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

  const cookSec = Math.floor(parseFloat(cookStr) || 0);
  const timeoutSec = Math.floor(parseFloat(timeoutStr) || 0);
  if (cookSec <= 0) return null;

  const rawOpts = resultsStr.split(";").map((s) => s.trim()).filter((s) => s !== "");
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
    const qty = Math.floor(parseFloat(qtyPart) || 1);
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
    const idx = (math as any).random(1, results.length);
    return (results as any)[idx];
  }
  let roll = (math as any).random() * total;
  for (let i = 0; i < results.length; i++) {
    roll -= weights[i];
    if (roll <= 0) return results[i];
  }
  return results[results.length - 1];
}

function createItemAtCampfire(campfire: any, itemId: number): any {
  const { x, y } = getUnitXY(campfire);
  if (typeof (jass as any).CreateItem !== "function") return null;
  return (jass as any).CreateItem(itemId, x, y);
}

function tryGiveItemToCampfire(campfire: any, item: any): boolean {
  if (!item) return false;
  if (typeof (jass as any).UnitAddItem !== "function") return false;
  return !!(jass as any).UnitAddItem(campfire, item);
}

function stopAndDestroyTimer(t: any): void {
  if (!t) return;
  stopTimer(t);
}

function untrackItem(item: any): void {
  const st = itemState.get(item);
  if (!st) return;
  if (st.cookTimer) stopAndDestroyTimer(st.cookTimer);
  if (st.burnTimer) stopAndDestroyTimer(st.burnTimer);
  itemState.delete(item);

  const set = campfireItems.get(st.campfire);
  if (set) {
    set.delete(item);
    if (set.size === 0) campfireItems.delete(st.campfire);
  }
}

function startBurnTimer(item: any, campfire: any, sec: number): void {
  const t = (jass as any).CreateTimer?.();
  if (!t || typeof (jass as any).TimerStart !== "function") return;
  const st = itemState.get(item);
  if (st) st.burnTimer = t;
  (jass as any).TimerStart(t, sec, false, () => {
    if (!itemState.has(item)) {
      return;
    }
    const name = getItemNameSafe(item);
    floatBurnText(campfire, name);
    if (typeof (jass as any).RemoveItem === "function") (jass as any).RemoveItem(item);
    untrackItem(item);
  });
}

function startCookTimer(item: any, campfire: any, recipe: RecipeParsed): void {
  const t = (jass as any).CreateTimer?.();
  if (!t || typeof (jass as any).TimerStart !== "function") return;
  const st = itemState.get(item);
  if (st) st.cookTimer = t;
  (jass as any).TimerStart(t, recipe.cookSec, false, () => {
    if (!itemState.has(item)) {
      return;
    }
    // 加工完成：替换物品
    playFinishEffect(campfire);

    const chosen = pickResult(recipe.results);
    const inputCharges = getItemChargesSafe(item); // 例如“生鱼大”堆叠 10 次
    // 删除原物品
    if (typeof (jass as any).RemoveItem === "function") (jass as any).RemoveItem(item);
    // 从追踪中移除原 item（会销毁 cookTimer）
    untrackItem(item);

    // 生成结果：必须优先留在篝火物品栏（先删原材料，保证至少空 1 格）
    // 若一次产出多个：尽量塞进篝火；塞不下的“多余产物”按 20% 概率掉在篝火脚下，否则不生成。
    const timeout = recipe.timeoutSec > 0 ? recipe.timeoutSec : 0;
    let remaining = chosen.qty * inputCharges;

    // 先尽量塞进篝火
    while (remaining > 0) {
      const it = createItemAtCampfire(campfire, chosen.itemId);
      if (!it) break;
      // 优先把数量塞到 charges，减少占格；一次尽量放完
      setItemChargesSafe(it, remaining);
      const ok = tryGiveItemToCampfire(campfire, it);
      if (!ok) {
        // 放不进：这是“多余产物”，按 20% 概率留地上，否则移除
        const roll = (math as any).random(1, 100);
        if (roll > 20 && typeof (jass as any).RemoveItem === "function") (jass as any).RemoveItem(it);
        // 若 roll<=20，就留在地上（不计入篝火超时烤焦）
      } else {
        // 在篝火内：开始超时烤焦
        itemState.set(it, { campfire, stage: "done" });
        let set = campfireItems.get(campfire);
        if (!set) { set = new Set<any>(); campfireItems.set(campfire, set); }
        set.add(it);
        if (timeout > 0) startBurnTimer(it, campfire, timeout);
      }
      // 这次创建的 item 已承载 remaining（charges），认为全部产出已处理
      remaining = 0;
      // 若篝火满了，会进入 !ok 分支，后续都会按 20% 掉地上处理
    }
  });
}

function onAnyPickup(): void {
  const u = typeof (jass as any).GetTriggerUnit === "function" ? (jass as any).GetTriggerUnit() : undefined;
  const item = typeof (jass as any).GetManipulatedItem === "function" ? (jass as any).GetManipulatedItem() : undefined;
  if (!u || !item) return;

  // 取回：其他单位拾取了处于追踪中的 item
  if (!isCampfire(u)) {
    if (itemState.has(item)) {
      untrackItem(item);
    }
    return;
  }

  // 放入篝火
  if (itemState.has(item)) return;

  const recipe = getRecipeForItem(item);
  const campfire = u;
  itemState.set(item, { campfire, stage: "raw" });
  let set = campfireItems.get(campfire);
  if (!set) { set = new Set<any>(); campfireItems.set(campfire, set); }
  set.add(item);

  if (!recipe) {
    // 无 recipe：15 秒烤焦倒计时
    startBurnTimer(item, campfire, 15);
  } else {
    // 有 recipe：加工计时器；加工完成后再开超时计时器
    startCookTimer(item, campfire, recipe);
  }
}

function onAnyDeath(): void {
  const u = typeof (jass as any).GetTriggerUnit === "function" ? (jass as any).GetTriggerUnit() : undefined;
  if (!u || !isCampfire(u)) return;
  const set = campfireItems.get(u);
  if (!set) return;
  // 取消所有关联计时器（不删除物品，让物品按游戏规则掉落/保留）
  for (const it of set) {
    untrackItem(it);
  }
  campfireItems.delete(u);
}

export function init物品加工(): void {
  if (
    typeof (jass as any).CreateTrigger !== "function" ||
    typeof (jass as any).TriggerAddAction !== "function" ||
    typeof (jass as any).Player !== "function"
  ) return;

  // 玩家1-4（0..3）拾取物品
  const pickEv = (jass as any).EVENT_PLAYER_UNIT_PICKUP_ITEM ?? 18;
  const trigPick = (jass as any).CreateTrigger();
  for (let i = 0; i <= 3; i++) {
    if (typeof (jass as any).TriggerRegisterPlayerUnitEvent === "function") {
      (jass as any).TriggerRegisterPlayerUnitEvent(trigPick, (jass as any).Player(i), pickEv, undefined!);
    }
  }
  (jass as any).TriggerAddAction(trigPick, onAnyPickup);

  // 兜底：玩家把物品从篝火丢到地上/丢出背包时，取消加工计时器
  const dropEv = (jass as any).EVENT_PLAYER_UNIT_DROP_ITEM ?? 19;
  const trigDrop = (jass as any).CreateTrigger();
  for (let i = 0; i <= 3; i++) {
    if (typeof (jass as any).TriggerRegisterPlayerUnitEvent === "function") {
      (jass as any).TriggerRegisterPlayerUnitEvent(trigDrop, (jass as any).Player(i), dropEv, undefined!);
    }
  }
  (jass as any).TriggerAddAction(trigDrop, () => {
    const unit = typeof (jass as any).GetManipulatingUnit === "function" ? (jass as any).GetManipulatingUnit() : undefined;
    const item = typeof (jass as any).GetManipulatedItem === "function" ? (jass as any).GetManipulatedItem() : undefined;
    if (unit && item && isCampfire(unit) && itemState.has(item)) {
      untrackItem(item);
    }
  });

  // 篝火死亡：取消计时器
  const trigDeath = (jass as any).CreateTrigger();
  if (typeof (jass as any).TriggerRegisterPlayerUnitEvent === "function") {
    const ev = (jass as any).EVENT_PLAYER_UNIT_DEATH ?? 56;
    for (let i = 0; i < 16; i++) {
      (jass as any).TriggerRegisterPlayerUnitEvent(trigDeath, (jass as any).Player(i), ev, undefined!);
    }
  }
  (jass as any).TriggerAddAction(trigDeath, onAnyDeath);
}

// 自动初始化（也可在 main.ts 显式调用）
init物品加工();

export {};
