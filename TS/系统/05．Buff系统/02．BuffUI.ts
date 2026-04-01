const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const 硬件函数 = require("系统.00．核心系统.04．硬件函数") as { getGameUI: () => number };
const UI工具 = require("系统.09．表现系统.01．UI工具") as {
  createFrame: (options: any) => number;
  setFramePosition: (frame: number, options: any) => void;
  setFrameSize: (frame: number, options: any) => void;
  setFrameTexture: (frame: number, texture: string) => void;
  setFrameHoverEvents: (frame: number, onHover: () => void, onUnhover: () => void, enable: boolean) => void;
  setFramePointRelative: (frame: number, point: number, relativeTo: number, relativePoint: number, x: number, y: number) => void;
  createTextLabel: (name: string, parent: number, text: string, position: any, size: any) => number;
  FrameType: { BACKDROP: number; GLUETEXTBUTTON: number };
  FramePoint: { TOPLEFT: number; TOPRIGHT: number; CENTER: number; BOTTOM: number };
  hideFrame: (frame: number) => void;
  showFrame: (frame: number) => void;
};

const buffPoolMod = require("系统.05．Buff系统.00．Buff系统") as {
  isUnitInBuffPool: (u: any) => boolean;
  getBuffIdsOnUnit: (u: any) => string[];
  getBuffRuntime: (
    u: any,
    buffID: string
  ) => {
    effect: number;
    remaining: number;
    sourceName?: string;
    _dotParsedDuration?: number;
    iconOverride?: string;
  } | null;
  getDotIconDisplayRemaining: (u: any, buffID: string, realRemaining: number) => number;
};
const buffTableMod = require("系统.05．Buff系统.01．Buff表") as {
  buffs: Record<string, { icon: string; tooltip: string; priority: number; buffName: string; interval: number }>;
};

type BuffRowId = string;

interface BuffBarRow {
  id: BuffRowId;
  state: {
    effect: number;
    remaining: number;
    iconRemaining: number;
    sourceName?: string;
    _dotParsedDuration?: number;
  };
  iconOverride?: string;
}

const BUFF_BAR_X0 = 0.204;
const BUFF_BAR_Y = 0.1655;
const ICON_W = 0.02;
const ICON_H = 16 / 600;
const ICON_GAP = 0.0005;
const MAX_SLOTS = 20;
const BUFF_BAR_REFRESH_SEC = 0.1;

const TIP_BOX_TEX = "war3mapImported\\wenbenkuang.blp";
const TIP_W = 0.22;
const TIP_H = 0.056;
const TIP_PAD = 0.005;
const TIP_OFFSET_Y_FROM_ICON_TOP = 0.07;
const TIP_COLOR_BODY = "|cfffff2d9";
const TIP_COLOR_SOURCE = "|cffffd700";

function tooltipIntStr(n: number): string {
  if (typeof n !== "number" || !isFinite(n)) return "0";
  return `${Math.floor(Math.max(0, n))}`;
}

function formatBuffRemainOneDecimal(rem: number): string {
  if (typeof rem !== "number" || !isFinite(rem)) return "0.0";
  return Math.max(0, rem).toFixed(1);
}

function formatDotTooltip(
  template: string,
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
  remainText: number;
  hit: number;
  tipBox: number;
  tipText: number;
}

const slots: SlotFrames[] = [];
const lastTipStrBySlot: string[] = [];
const lastRemainStrBySlot: string[] = [];
const slotHovering: boolean[] = [];
let refreshTimer: any = undefined;
let buffUiInitialized = false;

export let BUFF_UI_DEBUG = false;
let lastBuffUiDbgKey = "";

function debugBuffUi(msg: string): void {
  if (!BUFF_UI_DEBUG) return;
  if (typeof (jass as any).GetLocalPlayer !== "function" || typeof (jass as any).DisplayTextToPlayer !== "function") return;
  const p = (jass as any).GetLocalPlayer();
  (jass as any).DisplayTextToPlayer(p, 0, 0, "[BuffUI] " + msg);
}

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

function isUnitRefLikelyValid(u: any): boolean {
  if (u == null || u === 0) return false;
  if (typeof (jass as any).GetUnitTypeId !== "function") return true;
  const tid = (jass as any).GetUnitTypeId(u) as number;
  return tid != null && tid !== 0;
}

function collectBuffRows(unit: any): BuffBarRow[] {
  const rows: BuffBarRow[] = [];
  if (!buffPoolMod.isUnitInBuffPool(unit)) return rows;
  const ids = buffPoolMod.getBuffIdsOnUnit(unit);
  for (let i = 0; i < ids.length; i++) {
    const bid = ids[i];
    if (bid === "D001" || bid === "D002" || bid === "D003" || bid === "D004") {
      const rt = buffPoolMod.getBuffRuntime(unit, bid);
      if (rt != null) {
        const real = rt.remaining;
        const iconRem =
          typeof buffPoolMod.getDotIconDisplayRemaining === "function"
            ? buffPoolMod.getDotIconDisplayRemaining(unit, bid, real)
            : real;
        rows.push({
          id: bid,
          state: {
            effect: rt.effect,
            remaining: real,
            iconRemaining: iconRem,
            sourceName: rt.sourceName,
            _dotParsedDuration: rt._dotParsedDuration,
          },
          iconOverride: rt.iconOverride,
        });
      }
    } else {
      const rt = buffPoolMod.getBuffRuntime(unit, bid);
      if (rt != null) {
        const real = rt.remaining;
        const iconRem =
          typeof buffPoolMod.getDotIconDisplayRemaining === "function"
            ? buffPoolMod.getDotIconDisplayRemaining(unit, bid, real)
            : real;
        rows.push({
          id: bid,
          state: {
            effect: rt.effect,
            remaining: real,
            iconRemaining: iconRem,
            sourceName: rt.sourceName,
          },
          iconOverride: rt.iconOverride,
        });
      }
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
  lastRemainStrBySlot[i] = "";
  if (s.tipText !== 0) (pcall as any)(() => UI工具.hideFrame(s.tipText));
  if (s.tipBox !== 0) (pcall as any)(() => UI工具.hideFrame(s.tipBox));
  if (s.hit !== 0) (pcall as any)(() => UI工具.hideFrame(s.hit));
  if (s.root !== 0) (pcall as any)(() => UI工具.hideFrame(s.root));
}

function hideAllSlots(): void {
  for (let i = 0; i < MAX_SLOTS; i++) hideSlot(i);
}

function syncBuffBar(): void {
  (pcall as any)(() => {
    if (typeof jass.GetLocalPlayer !== "function") {
      hideAllSlots();
      return;
    }
    const lp = jass.GetLocalPlayer();
    if (lp == null || lp === 0) return;

    const { n: selN, sole } = countSelectedForPlayer(lp);
    const hid =
      sole != null && sole !== 0 && typeof (jass as any).GetHandleId === "function"
        ? ((jass as any).GetHandleId(sole) as number)
        : 0;
    const soleOk = sole != null && sole !== 0 && isUnitRefLikelyValid(sole);
    const inPool = soleOk && buffPoolMod.isUnitInBuffPool(sole);
    const rtD001 = soleOk ? buffPoolMod.getBuffRuntime(sole, "D001") : null;
    const rtD002 = soleOk ? buffPoolMod.getBuffRuntime(sole, "D002") : null;
    const rtD003 = soleOk ? buffPoolMod.getBuffRuntime(sole, "D003") : null;
    if (BUFF_UI_DEBUG) {
      const rowsProbe = soleOk && selN === 1 ? collectBuffRows(sole) : [];
      const key = `${selN}|${hid}|${inPool}|${rtD001 != null}|${rtD002 != null}|${rtD003 != null}|${rowsProbe.length}`;
      if (key !== lastBuffUiDbgKey) {
        lastBuffUiDbgKey = key;
        debugBuffUi(
          `sel=${selN} hid=${hid} pool=${inPool ? 1 : 0} D001=${rtD001 != null ? 1 : 0} D002=${rtD002 != null ? 1 : 0} D003=${rtD003 != null ? 1 : 0} rows=${rowsProbe.length}`
        );
      }
    }
    if (!soleOk || selN !== 1) {
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
      if (!slot) continue;
      const iconTex =
        row.iconOverride !== undefined && row.iconOverride !== ""
          ? row.iconOverride
          : meta != null
            ? meta.icon
            : "";
      if (iconTex === "") continue;
      const pd = row.state._dotParsedDuration;
      const durationForTip =
        typeof pd === "number" && isFinite(pd) && pd > 0 ? pd : row.state.remaining;
      const tipStr =
        meta != null
          ? formatDotTooltip(
              meta.tooltip,
              durationForTip,
              row.state.effect,
              row.state.sourceName,
              meta.interval
            )
          : TIP_COLOR_BODY +
            row.id +
            " 剩余 " +
            tooltipIntStr(row.state.remaining) +
            " 秒，伤害/秒 " +
            tooltipIntStr(row.state.effect) +
            "|r\n" +
            TIP_COLOR_SOURCE +
            "buff来源为「" +
            (row.state.sourceName !== undefined && row.state.sourceName !== "" ? row.state.sourceName : "未知") +
            "」|r";
      (pcall as any)(() => UI工具.setFrameTexture(slot.root, iconTex));
      const remStr = formatBuffRemainOneDecimal(row.state.iconRemaining);
      if (slot.remainText && slot.remainText !== 0 && typeof (japi as any).DzFrameSetText === "function") {
        if (lastRemainStrBySlot[i] !== remStr) {
          lastRemainStrBySlot[i] = remStr;
          (pcall as any)(() => (japi as any).DzFrameSetText(slot.remainText, "|cffffffff" + remStr + "|r"));
        }
      }
      if (slot.tipText && slot.tipText !== 0 && typeof (japi as any).DzFrameSetText === "function") {
        if (lastTipStrBySlot[i] !== tipStr) {
          lastTipStrBySlot[i] = tipStr;
          (pcall as any)(() => (japi as any).DzFrameSetText(slot.tipText, tipStr));
        }
      }
      (pcall as any)(() => UI工具.showFrame(slot.root));
      if (slot.hit !== 0) (pcall as any)(() => UI工具.showFrame(slot.hit));
      if (!slotHovering[i]) {
        if (slot.tipBox !== 0) (pcall as any)(() => UI工具.hideFrame(slot.tipBox));
        if (slot.tipText !== 0) (pcall as any)(() => UI工具.hideFrame(slot.tipText));
      }
    }
  });
}

function createOneSlot(index: number, parent: number): SlotFrames | null {
  try {
    const x = BUFF_BAR_X0 + index * (ICON_W + ICON_GAP);
    const bd =
      UI工具.createFrame({
        type: UI工具.FrameType.BACKDROP,
        name: "BuffUIBarIcon" + index,
        parent,
        template: "template",
        visible: false,
      }) || 0;
    if (!bd || bd === 0) return null;
    (pcall as any)(() => UI工具.setFramePosition(bd, { point: UI工具.FramePoint.TOPLEFT, x, y: BUFF_BAR_Y }));
    (pcall as any)(() => UI工具.setFrameSize(bd, { width: ICON_W, height: ICON_H }));
    (pcall as any)(() => UI工具.setFrameTexture(bd, "ReplaceableTextures\\CommandButtons\\BTNStatUp.blp"));
    if (typeof (japi as any).DzFrameSetLevel === "function") (pcall as any)(() => (japi as any).DzFrameSetLevel(bd, 180));

    const remainText =
      UI工具.createTextLabel(
        "BuffUIBarRemain" + index,
        bd,
        "|cffffffff0.0|r",
        {
          relativeTo: bd,
          point: UI工具.FramePoint.BOTTOM,
          relativePoint: UI工具.FramePoint.BOTTOM,
          x: 0,
          y: 0.001,
        },
        { width: ICON_W, height: 0.014 }
      ) || 0;
    if (remainText && remainText !== 0) {
      if (typeof (japi as any).DzFrameSetTextAlignment === "function") {
        (pcall as any)(() => {
          (japi as any).DzFrameSetTextAlignment(remainText, UI工具.FramePoint.CENTER);
        });
      }
      if (typeof (japi as any).DzFrameSetLevel === "function") (pcall as any)(() => (japi as any).DzFrameSetLevel(remainText, 182));
    }

    const hit =
      UI工具.createFrame({
        type: UI工具.FrameType.GLUETEXTBUTTON,
        name: "BuffUIBarHit" + index,
        parent: bd,
        template: "template",
        visible: false,
        enable: true,
        alpha: 0,
      }) || 0;
    if (hit && hit !== 0 && typeof (japi as any).DzFrameSetAllPoints === "function") {
      (pcall as any)(() => (japi as any).DzFrameSetAllPoints(hit, bd));
      if (typeof (japi as any).DzFrameSetLevel === "function") (pcall as any)(() => (japi as any).DzFrameSetLevel(hit, 181));
      (pcall as any)(() => UI工具.setFrameHoverEvents(
        hit,
        () => {
          slotHovering[index] = true;
          const s = slots[index];
          if (s != null && s.tipBox !== 0) (pcall as any)(() => UI工具.showFrame(s.tipBox));
          if (s != null && s.tipText !== 0) (pcall as any)(() => UI工具.showFrame(s.tipText));
        },
        () => {
          slotHovering[index] = false;
          const s = slots[index];
          if (s != null && s.tipText !== 0) (pcall as any)(() => UI工具.hideFrame(s.tipText));
          if (s != null && s.tipBox !== 0) (pcall as any)(() => UI工具.hideFrame(s.tipBox));
        },
        false
      ));
    }

    const boxW = TIP_W + TIP_PAD * 2;
    const boxH = TIP_H + TIP_PAD * 2;
    const tipBox =
      UI工具.createFrame({
        type: UI工具.FrameType.BACKDROP,
        name: "BuffUIBarTip" + index,
        parent,
        template: "template",
        visible: false,
      }) || 0;
    if (tipBox && tipBox !== 0) {
      (pcall as any)(() => UI工具.setFramePointRelative(
        tipBox,
        UI工具.FramePoint.TOPLEFT,
        bd,
        UI工具.FramePoint.TOPRIGHT,
        0.002,
        TIP_OFFSET_Y_FROM_ICON_TOP
      ));
      (pcall as any)(() => UI工具.setFrameSize(tipBox, { width: boxW, height: boxH }));
      (pcall as any)(() => UI工具.setFrameTexture(tipBox, TIP_BOX_TEX));
      if (typeof (japi as any).DzFrameSetLevel === "function") (pcall as any)(() => (japi as any).DzFrameSetLevel(tipBox, 0));
      (pcall as any)(() => UI工具.hideFrame(tipBox));
    }

    const tipText =
      UI工具.createTextLabel(
        "BuffUIBarTipTxt" + index,
        tipBox && tipBox !== 0 ? tipBox : bd,
        "",
        tipBox && tipBox !== 0
          ? { relativeTo: tipBox, point: UI工具.FramePoint.CENTER, relativePoint: UI工具.FramePoint.CENTER, x: 0, y: 0 }
          : { relativeTo: bd, point: UI工具.FramePoint.TOPLEFT, relativePoint: UI工具.FramePoint.TOPRIGHT, x: 0.002, y: TIP_OFFSET_Y_FROM_ICON_TOP },
        { width: boxW * 0.92, height: boxH * 0.88 }
      ) || 0;
    if (tipText && tipText !== 0) {
      if (typeof (japi as any).DzFrameSetTextAlignment === "function") {
        (pcall as any)(() => {
          (japi as any).DzFrameSetTextAlignment(tipText, 0);
        });
      }
      if (typeof (japi as any).DzFrameSetLevel === "function") (pcall as any)(() => (japi as any).DzFrameSetLevel(tipText, 0));
      (pcall as any)(() => UI工具.hideFrame(tipText));
    }

    if (hit !== 0 && tipBox !== 0) tryDzFrameSetTooltipF2i(hit, tipBox);

    (pcall as any)(() => UI工具.hideFrame(bd));
    return {
      root: bd,
      remainText: remainText || 0,
      hit: hit || 0,
      tipBox: tipBox || 0,
      tipText: tipText || 0,
    };
  } catch (e) {
    return null;
  }
}

function createUi(): void {
  (pcall as any)(() => {
    if (typeof jass.GetLocalPlayer !== "function") return;
    const lp = jass.GetLocalPlayer();
    if (lp == null || lp === 0) return;
    const parent = 硬件函数.getGameUI();
    if (parent === 0 || parent == null) return;
    for (let j = 0; j < MAX_SLOTS; j++) {
      lastTipStrBySlot[j] = "";
      lastRemainStrBySlot[j] = "";
      slotHovering[j] = false;
    }
    for (let i = 0; i < MAX_SLOTS; i++) {
      const s = createOneSlot(i, parent);
      if (s != null) slots[i] = s;
    }
  });
}

function startRefreshTimer(): void {
  (pcall as any)(() => {
    if (refreshTimer != null) return;
    if (typeof jass.CreateTimer !== "function" || typeof jass.TimerStart !== "function") return;
    refreshTimer = jass.CreateTimer();
    jass.TimerStart(refreshTimer, BUFF_BAR_REFRESH_SEC, true, () => {
      (pcall as any)(() => {
        if (typeof jass.GetLocalPlayer !== "function") return;
        const lp = jass.GetLocalPlayer();
        if (lp == null || lp === 0) return;
        syncBuffBar();
      });
    });
  });
}

export function init(): void {
  if (buffUiInitialized) return;
  buffUiInitialized = true;
  
  (pcall as any)(() => {
    if (typeof jass.CreateTimer === "function" && typeof jass.TimerStart === "function") {
      const delayTimer = jass.CreateTimer();
      jass.TimerStart(delayTimer, 1.0, false, () => {
        (pcall as any)(() => {
          if (typeof jass.GetLocalPlayer !== "function") {
            if (typeof jass.DestroyTimer === "function") jass.DestroyTimer(delayTimer);
            return;
          }
          const lp = jass.GetLocalPlayer();
          if (lp != null && lp !== 0) {
            createUi();
          }
          startRefreshTimer();
          if (typeof jass.DestroyTimer === "function") {
            jass.DestroyTimer(delayTimer);
          }
        });
      });
    }
  });
}
