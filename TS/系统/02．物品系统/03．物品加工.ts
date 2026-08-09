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
const R2I = jass.R2I as (value: number) => number;
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { onItemPickup, onItemDrop } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
  onItemDrop: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const itemRelatedFns = require("lib.扩展函数.物品相关函数.index") as {
  getItemDataEntry: (this: void, item: any) => { recipe?: string } | null;
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const 漂浮文字模块 = require("lib.扩展函数.封装函数.03．漂浮文字.index") as {
  CreateFloatTextAtPoint: (this: void, x: number, y: number, text: string, options?: any) => any;
};
const CreateFloatTextAtPoint = 漂浮文字模块.CreateFloatTextAtPoint as
  | ((this: void, x: number, y: number, text: string, options?: any) => any)
  | undefined;
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (this: void, s: string) => number;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.index") as {
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 创建世界坐标进度UI, 更新世界坐标进度UI, 销毁世界坐标进度UI } = require("系统.09．表现系统.15．世界坐标进度UI.index") as {
  创建世界坐标进度UI: (this: void, 参数: any) => any;
  更新世界坐标进度UI: (this: void, ui: any, 当前值: number, 立即更新?: boolean) => void;
  销毁世界坐标进度UI: (this: void, ui: any) => void;
};

const CAMPFIRE_ID = 0x68303043; // 'h00C'
const EFFECT_FIREBOMB = "war3mapImported\\Firebomb.mdl";
const CAMPFIRE_EVENT_PLAYER_IDS = [0, 1, 2, 3] as const;
const 加工UI基础高度 = 100;
const 加工UI屏幕行距 = 0.010;

type ResultOpt = { prob?: number; itemId: number; qty: number };
type RecipeParsed = { cookSec: number; timeoutSec: number; results: ResultOpt[] };

type ItemState = {
  item: any;
  campfire: any;
  stage: "raw" | "done";
  cookTimer?: any;
  burnTimer?: any;
  UI?: any;
  行号?: number;
  开始毫秒?: number;
  到期毫秒?: number;
};

const itemState: Record<number, ItemState | undefined> = {};       // itemHandleId -> state
const campfireItems: Record<number, number[] | undefined> = {};     // campfireHandleId -> itemHandleId 列表

const 物品加工计时检查间隔毫秒 = 10;
const 物品加工任务ID列表: number[] = [];
const 物品加工任务类型列表: ("burn" | "cook")[] = [];
const 物品加工任务物品列表: any[] = [];
const 物品加工任务篝火列表: any[] = [];
const 物品加工任务超时秒列表: number[] = [];
const 物品加工任务结果列表: ResultOpt[][] = [];
const 物品加工任务到期毫秒列表: number[] = [];
let 物品加工计时检查回调ID = 0;
let 下一个物品加工任务ID = 0;
let 正在将加工产物放回篝火 = false;

function getHandleIdSafe(handle: any): number {
  if (!handle) return 0;
  return ((jass as any).GetHandleId(handle) as number) || 0;
}

function 取物品加工行号(this: void, item: any): number {
  const itemId = getHandleIdSafe(item);
  const state = itemState[itemId];
  return state?.行号 ?? 0;
}

function 分配物品加工行号(this: void, campfireId: number): number {
  const items = campfireItems[campfireId];
  if (items == null || items.length === 0) return 0;
  let row = 0;
  while (true) {
    let occupied = false;
    for (let i = 0; i < items.length; i++) {
      const state = itemState[items[i]];
      if (state != null && state.行号 === row) {
        occupied = true;
        break;
      }
    }
    if (!occupied) return row;
    row += 1;
  }
}

function 创建物品加工UI(this: void, item: any, campfire: any, maximum: number, current: number, title: string): any {
  if (!(maximum > 0)) return null;
  const { x, y } = getUnitXY(campfire);
  return 创建世界坐标进度UI({
    X: x,
    Y: y,
    Z: 加工UI基础高度,
    屏幕Y偏移: 取物品加工行号(item) * 加工UI屏幕行距,
    最大值: maximum,
    当前值: current,
    标题: title,
    数值后缀: "秒",
    类型: "自然",
    平滑过渡秒: 0.05,
    初始显示: true,
    雾中可见: false,
  });
}

function 销毁物品加工UI(this: void, state: ItemState | undefined): void {
  if (state == null || state.UI == null) return;
  销毁世界坐标进度UI(state.UI);
  state.UI = undefined;
}

function 刷新物品加工UI(this: void, item: any, now: number, type: "burn" | "cook"): void {
  const state = itemState[getHandleIdSafe(item)];
  if (state == null || state.UI == null || state.开始毫秒 == null || state.到期毫秒 == null) return;
  if (type === "cook") {
    const elapsed = (now - state.开始毫秒) / 1000;
    更新世界坐标进度UI(state.UI, elapsed);
    return;
  }
  const remaining = (state.到期毫秒 - now) / 1000;
  更新世界坐标进度UI(state.UI, remaining > 0 ? remaining : 0);
}

function 处理烤焦到期(this: void, item: any, campfire: any): void {
  const itemId = getHandleIdSafe(item);
  if (itemId === 0 || !itemState[itemId]) return;
  const name = getItemNameSafe(item);
  floatBurnText(campfire, name);
  (jass as any).RemoveItem(item);
  untrackItem(item);
}

function 处理加工到期(this: void, item: any, campfire: any, timeoutSec: number, results: ResultOpt[]): void {
  const itemId = getHandleIdSafe(item);
  if (itemId === 0 || !itemState[itemId]) return;
  const state = itemState[itemId];
  const oldRow = state?.行号 ?? 0;
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
        itemState[itemId] = { item: it, campfire, stage: "done", 行号: oldRow };
        let items = campfireItems[campfireId];
        if (!items) { items = []; campfireItems[campfireId] = items; }
        items.push(itemId);
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
  const v = R2I((Number(n as any) as any) ?? 0) || 0;
  return v > 0 ? v : 1;
}

function setItemChargesSafe(item: any, n: number): void {
  if (!item) return;
  const v = R2I(n) || 1;
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
  const recipe: string | undefined = entry && entry.recipe ? entry.recipe : undefined;
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

  const cookSec = R2I(parseFloat(cookStr) || 0);
  const timeoutSec = R2I(parseFloat(timeoutStr) || 0);
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
    const qty = R2I(parseFloat(qtyPart) || 1);
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
    return results[idx - 1];
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
  return 创建物品并注册排泄监听(itemId, x, y);
}

function tryGiveItemToCampfire(campfire: any, item: any): boolean {
  if (!item) return false;
  正在将加工产物放回篝火 = true;
  const success = !!(jass as any).UnitAddItem(campfire, item);
  正在将加工产物放回篝火 = false;
  return success;
}

function 停止物品加工计时检查(this: void): void {
  if (物品加工计时检查回调ID <= 0) return;
  removePeriodicCallback(物品加工计时检查回调ID);
  物品加工计时检查回调ID = 0;
}

function 确保物品加工计时检查(this: void): void {
  if (物品加工计时检查回调ID > 0) return;
  物品加工计时检查回调ID = addPeriodicCallback(物品加工计时检查间隔毫秒, on物品加工计时检查);
}

function 取消物品加工任务(this: void, taskId: number): void {
  if (!(taskId > 0)) return;
  for (let i = 0; i < 物品加工任务ID列表.length; i++) {
    if (物品加工任务ID列表[i] === taskId) {
      物品加工任务ID列表[i] = 0;
      return;
    }
  }
}

function 取消物品加工任务引用(t: any): void {
  if (!t) return;
  取消物品加工任务(t as number);
}

function 安排物品加工任务(
  this: void,
  类型: "burn" | "cook",
  item: any,
  campfire: any,
  delaySec: number,
  timeoutSec: number,
  results: ResultOpt[],
): number {
  下一个物品加工任务ID += 1;
  物品加工任务ID列表.push(下一个物品加工任务ID);
  物品加工任务类型列表.push(类型);
  物品加工任务物品列表.push(item);
  物品加工任务篝火列表.push(campfire);
  物品加工任务超时秒列表.push(timeoutSec);
  物品加工任务结果列表.push(results);
  物品加工任务到期毫秒列表.push(getServerTime() + delaySec * 1000);
  确保物品加工计时检查();
  return 下一个物品加工任务ID;
}

function on物品加工计时检查(this: void): void {
  const now = getServerTime();
  let writeIndex = 0;
  for (let i = 0; i < 物品加工任务ID列表.length; i++) {
    const taskId = 物品加工任务ID列表[i];
    if (!(taskId > 0)) {
      continue;
    }
    if (now >= 物品加工任务到期毫秒列表[i]) {
      if (物品加工任务类型列表[i] === "burn") {
        处理烤焦到期(物品加工任务物品列表[i], 物品加工任务篝火列表[i]);
      } else {
        处理加工到期(
          物品加工任务物品列表[i],
          物品加工任务篝火列表[i],
          物品加工任务超时秒列表[i],
          物品加工任务结果列表[i],
        );
      }
    } else {
      刷新物品加工UI(物品加工任务物品列表[i], now, 物品加工任务类型列表[i]);
      物品加工任务ID列表[writeIndex] = taskId;
      物品加工任务类型列表[writeIndex] = 物品加工任务类型列表[i];
      物品加工任务物品列表[writeIndex] = 物品加工任务物品列表[i];
      物品加工任务篝火列表[writeIndex] = 物品加工任务篝火列表[i];
      物品加工任务超时秒列表[writeIndex] = 物品加工任务超时秒列表[i];
      物品加工任务结果列表[writeIndex] = 物品加工任务结果列表[i];
      物品加工任务到期毫秒列表[writeIndex] = 物品加工任务到期毫秒列表[i];
      writeIndex += 1;
    }
  }

  for (let i = 物品加工任务ID列表.length - 1; i >= writeIndex; i--) {
    物品加工任务ID列表.pop();
    物品加工任务类型列表.pop();
    物品加工任务物品列表.pop();
    物品加工任务篝火列表.pop();
    物品加工任务超时秒列表.pop();
    物品加工任务结果列表.pop();
    物品加工任务到期毫秒列表.pop();
  }

  if (物品加工任务ID列表.length <= 0) {
    停止物品加工计时检查();
  }
}

function untrackItem(item: any): void {
  const itemId = getHandleIdSafe(item);
  if (itemId === 0) return;
  const st = itemState[itemId];
  if (!st) return;
  销毁物品加工UI(st);
  if (st.cookTimer) 取消物品加工任务引用(st.cookTimer);
  if (st.burnTimer) 取消物品加工任务引用(st.burnTimer);
  itemState[itemId] = undefined;

  const campfireId = getHandleIdSafe(st.campfire);
  const items = campfireItems[campfireId];
  if (items) {
    for (let i = 0; i < items.length; i++) {
      if (items[i] === itemId) {
        items.splice(i, 1);
        break;
      }
    }
    if (items.length === 0) campfireItems[campfireId] = undefined;
  }
}

function startBurnTimer(item: any, campfire: any, sec: number): void {
  const st = itemState[getHandleIdSafe(item)];
  if (st == null) return;
  销毁物品加工UI(st);
  const startMs = getServerTime();
  st.开始毫秒 = startMs;
  st.到期毫秒 = startMs + sec * 1000;
  if (sec > 0) {
    st.UI = 创建物品加工UI(item, campfire, sec, sec, st.stage === "done" ? "烧烤失败" : getItemNameSafe(item));
  }
  const taskId = 安排物品加工任务("burn", item, campfire, sec, 0, []);
  st.burnTimer = taskId;
}

function startCookTimer(item: any, campfire: any, recipe: RecipeParsed): void {
  const st = itemState[getHandleIdSafe(item)];
  if (st == null) return;
  销毁物品加工UI(st);
  const startMs = getServerTime();
  st.开始毫秒 = startMs;
  st.到期毫秒 = startMs + recipe.cookSec * 1000;
  st.UI = 创建物品加工UI(item, campfire, recipe.cookSec, 0, getItemNameSafe(item));
  const taskId = 安排物品加工任务("cook", item, campfire, recipe.cookSec, recipe.timeoutSec, recipe.results);
  st.cookTimer = taskId;
}

function onAnyPickup(this: void, u: any, item: any): void {
  if (!u || !item) return;
  if (正在将加工产物放回篝火 && isCampfire(u)) return;

  // 取回：其他单位拾取了处于追踪中的 item
  if (!isCampfire(u)) {
    const itemId = getHandleIdSafe(item);
    if (itemId !== 0 && itemState[itemId]) {
      untrackItem(item);
    }
    return;
  }

  // 放入篝火
  const itemId = getHandleIdSafe(item);
  const campfireId = getHandleIdSafe(u);
  if (itemId === 0 || campfireId === 0) return;
  if (itemState[itemId]) return;

  const recipe = getRecipeForItem(item);
  const campfire = u;
  let items = campfireItems[campfireId];
  if (!items) { items = []; campfireItems[campfireId] = items; }
  const 行号 = 分配物品加工行号(campfireId);
  itemState[itemId] = { item, campfire, stage: "raw", 行号 };
  items.push(itemId);

  if (!recipe) {
    // 无 recipe：15 秒烤焦倒计时
    startBurnTimer(item, campfire, 15);
  } else {
    // 有 recipe：加工计时器；加工完成后再开超时计时器
    startCookTimer(item, campfire, recipe);
  }
}

function 处理物品丢弃事件(this: void, unit: any, item: any): void {
  const itemId = getHandleIdSafe(item);
  if (unit && item && isCampfire(unit) && itemId !== 0 && itemState[itemId]) {
    untrackItem(item);
  }
}

function onCampfireDeath(this: void, dyingUnit: any): void {
  if (!dyingUnit || !isCampfire(dyingUnit)) return;
  const campfireId = getHandleIdSafe(dyingUnit);
  const items = campfireItems[campfireId];
  if (!items) return;
  const itemIds = items.slice();
  for (let i = 0; i < itemIds.length; i++) {
    const st = itemState[itemIds[i]];
    if (st) {
      untrackItem(st.item);
    }
  }
  campfireItems[campfireId] = undefined;
}

export function init物品加工(): void {
  // 使用物品事件中心注册，减少触发器数量
  onItemPickup(onAnyPickup);
  onItemDrop(处理物品丢弃事件);

  registerDeathListener(onCampfireDeath);
}

// 自动初始化（也可在 main.ts 显式调用）
init物品加工();

export {};
