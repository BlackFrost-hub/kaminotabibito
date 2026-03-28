/**
 * 类原生 Buff 条：单选单位时，在屏幕固定区域横向展示 Debuff 图标（与 Buff 表 priority 排序）。
 * 依赖 dot伤害 已施加的反恢复/燃烧；英雄带「树枝」等装备攻击即可叠 DOT，选中目标后显示。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const EV_UNIT_SELECTED =
  jass.EVENT_PLAYER_UNIT_SELECTED != null ? jass.EVENT_PLAYER_UNIT_SELECTED : 58;
const EV_UNIT_DESELECTED =
  jass.EVENT_PLAYER_UNIT_DESELECTED != null
    ? jass.EVENT_PLAYER_UNIT_DESELECTED
    : jass.EVENT_PLAYER_UNIT_DESELECT_ALL != null
      ? jass.EVENT_PLAYER_UNIT_DESELECT_ALL
      : 59;

import { getGameUI } from "../00．核心系统/硬件函数";
import {
  createFrame,
  setFramePosition,
  setFrameSize,
  setFrameTexture,
  setFrameHoverEvents,
  setFramePointRelative,
  createTextLabel,
  FrameType,
  FramePoint,
  hideFrame,
  showFrame,
} from "../09．表现系统/UI工具";

const dotMod = require("系统.04．伤害系统.dot伤害") as {
  getUnitAntiHeal: (u: any) => { effect: number; remaining: number; sourceName?: string; _dotParsedDuration?: number } | null;
  getUnitBurn: (u: any) => { effect: number; remaining: number; sourceName?: string; _dotParsedDuration?: number } | null;
};
const buffPoolMod = require("系统.05．Buff系统.Buff系统") as {
  isUnitInBuffPool: (u: any) => boolean;
  getBuffIdsOnUnit: (u: any) => string[];
  getBuffRuntime: (u: any, buffID: string) => { effect: number; remaining: number } | null;
};
const buffTableMod = require("系统.05．Buff系统.01．Buff表") as {
  buffs: Record<string, { icon: string; tooltip: string; priority: number; buffName: string; interval: number }>;
};

/** 与 Buff 表 buffID 一致（可扩展其它表内 id） */
type BuffRowId = string;

interface BuffBarRow {
  id: BuffRowId;
  /** remaining：逻辑剩余秒；_dotParsedDuration：表意「持续总时长」（如 time3→3），提示文案用其固定显示，不随计时刷新 */
  state: { effect: number; remaining: number; sourceName?: string; _dotParsedDuration?: number };
}

/** 原生 Buff 区：左下肖像上方偏右，横向排列（归一化坐标，相对 GameUI） */
const BUFF_BAR_X0 = 0.204;
/** 相对初始 0.128 再上移 0.03（本坐标系 y 增大为往上） */
const BUFF_BAR_Y = 0.1655;
const ICON_W = 0.02;
const ICON_H = 16 / 600;
const ICON_GAP = 0.0005;
const MAX_SLOTS = 20;

const TIP_BOX_TEX = "war3mapImported\\wenbenkuang.blp";
const TIP_W = 0.22;
/** 两行说明（表文案 + 来源行）略增高 */
const TIP_H = 0.056;
const TIP_PAD = 0.005;
/** 提示框相对 Buff 图标顶边的纵向偏移（本坐标系 y 增大为往上） */
const TIP_OFFSET_Y_FROM_ICON_TOP = 0.07;
/** 提示第一行：偏暖的浅米色，在棕色底上易读 */
const TIP_COLOR_BODY = "|cfffff2d9";
/** 提示第二行（来源）：金色，与正文区分且更醒目 */
const TIP_COLOR_SOURCE = "|cffffd700";

/** 提示文案内数值一律去小数，向下取整为整数显示 */
function tooltipIntStr(n: number): string {
  if (typeof n !== "number" || !isFinite(n)) return "0";
  return `${Math.floor(Math.max(0, n))}`;
}

function formatDotTooltip(
  template: string,
  /** 提示里「持续时间」占位：优先用装备解析总时长（固定），否则用剩余秒数（非 DOT 等兜底） */
  durationForDisplay: number,
  dps: number,
  sourceName: string | undefined,
  intervalSec: number
): string {
  const rem = typeof durationForDisplay === "number" && isFinite(durationForDisplay) ? Math.max(0, durationForDisplay) : 0;
  const dpsN = typeof dps === "number" && isFinite(dps) ? dps : 0;
  const intv = typeof intervalSec === "number" && isFinite(intervalSec) && intervalSec > 0 ? intervalSec : 1;
  const rStr = tooltipIntStr(rem);
  const dStr = tooltipIntStr(dpsN);
  const iStr = tooltipIntStr(intv);
  let s = template;
  s = s.split("持续时间").join(rStr);
  s = s.split("interval").join(iStr);
  s = s.split("damage").join(dStr);
  const src = sourceName !== undefined && sourceName !== "" ? sourceName : "未知";
  return TIP_COLOR_BODY + s + "|r\n" + TIP_COLOR_SOURCE + "buff来源为「" + src + "」|r";
}

function tryDzFrameSetTooltipF2i(hostFrame: number, tooltipFrame: number): void {
  if (!hostFrame || hostFrame === 0 || !tooltipFrame || tooltipFrame === 0) return;
  const setTip = (japi as any).DzFrameSetTooltip;
  if (typeof setTip !== "function") return;
  const f2i = (japi as any).DzF2I;
  (pcall as any)(() => {
    const tipId = typeof f2i === "function" ? f2i(tooltipFrame) : tooltipFrame;
    setTip(hostFrame, tipId);
  });
}

interface SlotFrames {
  root: number;
  hit: number;
  tipBox: number;
  tipText: number;
}

const slots: SlotFrames[] = [];
/** 与槽位一一对应，仅当提示文案变化时才 DzFrameSetText，避免 0.5s 定时器无意义刷新 */
const lastTipStrBySlot: string[] = [];
/** 鼠标是否仍悬停在该槽 hit 上；定时 syncBuffBar 不可强行 hideFrame 提示，否则会误关 tooltip */
const slotHovering: boolean[] = [];
let refreshTimer: any = undefined;

/** 为 true 时向本地玩家刷诊断文字（选中数量、handleId、Buff 池、DOT 读数）。 */
export let BUFF_UI_DEBUG = false;
let lastBuffUiDbgKey = "";

function debugBuffUi(msg: string): void {
  if (!BUFF_UI_DEBUG) return;
  if (typeof (jass as any).GetLocalPlayer !== "function" || typeof (jass as any).DisplayTextToPlayer !== "function") return;
  const p = (jass as any).GetLocalPlayer();
  (jass as any).DisplayTextToPlayer(p, 0, 0, "[BuffUI] " + msg);
}

/**
 * 当前玩家选中单位数量 + 第一个选中（含敌方）。勿用 GroupEnumUnitsOfPlayer。
 * 优先 GroupEnumUnitsSelected；无则全图矩形枚举 + IsUnitSelected。
 */
function countSelectedForPlayer(p: any): { n: number; sole: any } {
  if (!p || p === 0) return { n: 0, sole: null };
  if (typeof (jass as any).CreateGroup !== "function") return { n: 0, sole: null };
  const g = (jass as any).CreateGroup();
  const useSelectedNative = typeof (jass as any).GroupEnumUnitsSelected === "function";
  if (useSelectedNative) {
    (jass as any).GroupEnumUnitsSelected(g, p, null as any);
  } else {
    if (
      typeof (jass as any).IsUnitSelected !== "function" ||
      typeof (jass as any).GetWorldBounds !== "function" ||
      typeof (jass as any).GroupEnumUnitsInRect !== "function"
    ) {
      (jass as any).DestroyGroup(g);
      return { n: 0, sole: null };
    }
    (jass as any).GroupEnumUnitsInRect(g, (jass as any).GetWorldBounds(), null as any);
  }
  let n = 0;
  let sole: any = null;
  while (true) {
    const u = (jass as any).FirstOfGroup(g);
    if (!u || u === 0) break;
    (jass as any).GroupRemoveUnit(g, u);
    if (!useSelectedNative && !(jass as any).IsUnitSelected(u, p)) continue;
    n++;
    if (sole === null) sole = u;
  }
  (jass as any).DestroyGroup(g);
  return { n, sole };
}

function getSoleSelectedUnitForPlayer(p: any): any {
  const { n, sole } = countSelectedForPlayer(p);
  if (n !== 1) return null;
  return sole;
}

function collectBuffRows(unit: any): BuffBarRow[] {
  const rows: BuffBarRow[] = [];
  if (!buffPoolMod.isUnitInBuffPool(unit)) return rows;
  const ids = buffPoolMod.getBuffIdsOnUnit(unit);
  for (let i = 0; i < ids.length; i++) {
    const bid = ids[i];
    if (bid === "D001") {
      const ah = dotMod.getUnitAntiHeal(unit);
      if (ah != null)
        rows.push({
          id: "D001",
          state: {
            effect: ah.effect,
            remaining: ah.remaining,
            sourceName: ah.sourceName,
            _dotParsedDuration: ah._dotParsedDuration,
          },
        });
    } else if (bid === "D002") {
      const br = dotMod.getUnitBurn(unit);
      if (br != null)
        rows.push({
          id: "D002",
          state: {
            effect: br.effect,
            remaining: br.remaining,
            sourceName: br.sourceName,
            _dotParsedDuration: br._dotParsedDuration,
          },
        });
    } else {
      const rt = buffPoolMod.getBuffRuntime(unit, bid);
      if (rt != null) rows.push({ id: bid, state: { effect: rt.effect, remaining: rt.remaining } });
    }
  }
  const buffs = buffTableMod.buffs;
  rows.sort((a, b) => {
    const pa = buffs[a.id] != null ? buffs[a.id].priority : 0;
    const pb = buffs[b.id] != null ? buffs[b.id].priority : 0;
    if (pa !== pb) return pb - pa;
    return a.id < b.id ? -1 : 1;
  });
  return rows;
}

function hideSlot(i: number): void {
  const s = slots[i];
  if (s == null) return;
  slotHovering[i] = false;
  lastTipStrBySlot[i] = "";
  if (s.tipText !== 0) hideFrame(s.tipText);
  if (s.tipBox !== 0) hideFrame(s.tipBox);
  if (s.hit !== 0) hideFrame(s.hit);
  if (s.root !== 0) hideFrame(s.root);
}

function hideAllSlots(): void {
  for (let i = 0; i < MAX_SLOTS; i++) hideSlot(i);
}

function syncBuffBar(): void {
  if (typeof jass.GetLocalPlayer !== "function") {
    hideAllSlots();
    return;
  }
  const lp = jass.GetLocalPlayer();
  const { n: selN, sole } = countSelectedForPlayer(lp);
  const hid =
    sole != null && sole !== 0 && typeof (jass as any).GetHandleId === "function"
      ? ((jass as any).GetHandleId(sole) as number)
      : 0;
  const inPool = sole != null && sole !== 0 && buffPoolMod.isUnitInBuffPool(sole);
  const ah = sole != null && sole !== 0 ? dotMod.getUnitAntiHeal(sole) : null;
  const br = sole != null && sole !== 0 ? dotMod.getUnitBurn(sole) : null;
  if (BUFF_UI_DEBUG) {
    const rowsProbe = sole != null && sole !== 0 && selN === 1 ? collectBuffRows(sole) : [];
    const key = `${selN}|${hid}|${inPool}|${ah != null}|${br != null}|${rowsProbe.length}`;
    if (key !== lastBuffUiDbgKey) {
      lastBuffUiDbgKey = key;
      debugBuffUi(
        `sel=${selN} hid=${hid} pool=${inPool ? 1 : 0} dotAH=${ah != null ? 1 : 0} dotBr=${br != null ? 1 : 0} rows=${rowsProbe.length}`
      );
    }
  }
  if (!sole || selN !== 1) {
    hideAllSlots();
    return;
  }
  const rows = collectBuffRows(sole);
  const buffs = buffTableMod.buffs;
  for (let i = 0; i < MAX_SLOTS; i++) {
    if (i >= rows.length) {
      hideSlot(i);
      continue;
    }
    const row = rows[i];
    const meta = buffs[row.id];
    const slot = slots[i];
    if (!meta || !slot) continue;
    const pd = row.state._dotParsedDuration;
    const durationForTip =
      typeof pd === "number" && isFinite(pd) && pd > 0 ? pd : row.state.remaining;
    const tipStr = formatDotTooltip(
      meta.tooltip,
      durationForTip,
      row.state.effect,
      row.state.sourceName,
      meta.interval
    );
    setFrameTexture(slot.root, meta.icon);
    if (slot.tipText && slot.tipText !== 0 && typeof (japi as any).DzFrameSetText === "function") {
      if (lastTipStrBySlot[i] !== tipStr) {
        lastTipStrBySlot[i] = tipStr;
        (japi as any).DzFrameSetText(slot.tipText, tipStr);
      }
    }
    showFrame(slot.root);
    if (slot.hit !== 0) showFrame(slot.hit);
    if (!slotHovering[i]) {
      if (slot.tipBox !== 0) hideFrame(slot.tipBox);
      if (slot.tipText !== 0) hideFrame(slot.tipText);
    }
  }
}

function onSelectionChanged(): void {
  if (typeof jass.GetLocalPlayer !== "function" || typeof jass.GetTriggerPlayer !== "function") return;
  if (jass.GetLocalPlayer() !== jass.GetTriggerPlayer()) return;
  syncBuffBar();
}

function createOneSlot(index: number, parent: number): SlotFrames | null {
  const x = BUFF_BAR_X0 + index * (ICON_W + ICON_GAP);
  const bd =
    createFrame({
      type: FrameType.BACKDROP,
      name: "BuffUIBarIcon" + index,
      parent,
      template: "template",
      visible: false,
    }) || 0;
  if (!bd || bd === 0) return null;
  setFramePosition(bd, { point: FramePoint.TOPLEFT, x, y: BUFF_BAR_Y });
  setFrameSize(bd, { width: ICON_W, height: ICON_H });
  setFrameTexture(bd, "ReplaceableTextures\\CommandButtons\\BTNStatUp.blp");
  if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(bd, 180);

  const hit =
    createFrame({
      type: FrameType.GLUETEXTBUTTON,
      name: "BuffUIBarHit" + index,
      parent: bd,
      template: "template",
      visible: false,
      enable: true,
      alpha: 0,
    }) || 0;
  if (hit && hit !== 0 && typeof (japi as any).DzFrameSetAllPoints === "function") {
    (japi as any).DzFrameSetAllPoints(hit, bd);
    if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(hit, 181);
    setFrameHoverEvents(
      hit,
      () => {
        slotHovering[index] = true;
        const s = slots[index];
        if (s != null && s.tipBox !== 0) showFrame(s.tipBox);
        if (s != null && s.tipText !== 0) showFrame(s.tipText);
      },
      () => {
        slotHovering[index] = false;
        const s = slots[index];
        if (s != null && s.tipText !== 0) hideFrame(s.tipText);
        if (s != null && s.tipBox !== 0) hideFrame(s.tipBox);
      },
      false
    );
  }

  const boxW = TIP_W + TIP_PAD * 2;
  const boxH = TIP_H + TIP_PAD * 2;
  /** 挂在 GameUI 上并提高 Level，避免被右侧相邻图标挡住 */
  const tipBox =
    createFrame({
      type: FrameType.BACKDROP,
      name: "BuffUIBarTip" + index,
      parent,
      template: "template",
      visible: false,
    }) || 0;
  if (tipBox && tipBox !== 0) {
    setFramePointRelative(
      tipBox,
      FramePoint.TOPLEFT,
      bd,
      FramePoint.TOPRIGHT,
      0.002,
      TIP_OFFSET_Y_FROM_ICON_TOP
    );
    setFrameSize(tipBox, { width: boxW, height: boxH });
    setFrameTexture(tipBox, TIP_BOX_TEX);
    // DzFrame：Level 越小越靠前。任务 UI 等常用 1～8，原先 70 会被盖住；与图标(180/181)分离即可
    if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(tipBox, 0);
    hideFrame(tipBox);
  }

  const tipText =
    createTextLabel(
      "BuffUIBarTipTxt" + index,
      tipBox && tipBox !== 0 ? tipBox : bd,
      "",
      tipBox && tipBox !== 0
        ? { relativeTo: tipBox, point: FramePoint.CENTER, relativePoint: FramePoint.CENTER, x: 0, y: 0 }
        : { relativeTo: bd, point: FramePoint.TOPLEFT, relativePoint: FramePoint.TOPRIGHT, x: 0.002, y: TIP_OFFSET_Y_FROM_ICON_TOP },
      { width: boxW * 0.92, height: boxH * 0.88 }
    ) || 0;
  if (tipText && tipText !== 0) {
    if (typeof (japi as any).DzFrameSetTextAlignment === "function") {
      (pcall as any)(() => {
        (japi as any).DzFrameSetTextAlignment(tipText, 0);
      });
    }
    if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(tipText, 0);
    hideFrame(tipText);
  }

  if (hit !== 0 && tipBox !== 0) tryDzFrameSetTooltipF2i(hit, tipBox);

  hideFrame(bd);
  return { root: bd, hit: hit || 0, tipBox: tipBox || 0, tipText: tipText || 0 };
}

function createUi(): void {
  const parent = getGameUI();
  if (parent === 0 || parent == null) return;
  for (let j = 0; j < MAX_SLOTS; j++) {
    lastTipStrBySlot[j] = "";
    slotHovering[j] = false;
  }
  for (let i = 0; i < MAX_SLOTS; i++) {
    const s = createOneSlot(i, parent);
    if (s != null) slots[i] = s;
  }
}

function registerTriggers(): void {
  const trig = typeof jass.CreateTrigger === "function" ? jass.CreateTrigger() : null;
  if (!trig) return;
  for (let i = 0; i < 16; i++) {
    if (typeof jass.TriggerRegisterPlayerUnitEvent === "function") {
      jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), EV_UNIT_SELECTED, undefined!);
      jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), EV_UNIT_DESELECTED, undefined!);
    }
  }
  if (typeof jass.TriggerAddAction === "function") {
    jass.TriggerAddAction(trig, onSelectionChanged);
  }
}

function startRefreshTimer(): void {
  if (refreshTimer != null) return;
  if (typeof jass.CreateTimer !== "function" || typeof jass.TimerStart !== "function") return;
  refreshTimer = jass.CreateTimer();
  jass.TimerStart(refreshTimer, 0.5, true, () => {
    syncBuffBar();
  });
}

export function init(): void {
  createUi();
  registerTriggers();
  startRefreshTimer();
}
