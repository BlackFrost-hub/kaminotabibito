/** @noSelfInFile */
// BuffUI ViewModel 层：纯数据计算，全端对称执行，不操作 frame

import * as buffPoolMod from "./00．Buff系统";
import * as buffTableMod from "./01．Buff表";

const 数学运算 = require("lib.扩展函数.封装函数.01．通用工具.07．数学运算") as {
  round: (this: void, value: number) => number;
};
const { debugLog, setDebug } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (module: string, ...args: any[]) => void;
  setDebug: (module: string, on: boolean) => void;
};

const MAX_SLOTS = 20;
const jass = require("jass.common") as any;
const round = 数学运算.round;
setDebug("BuffUI.VM", false);

export interface BuffSlotViewModel {
  visible: boolean;
  iconPath: string;
  remainText: string;
  tooltipBodyText: string;
  tooltipSourceText: string;
}

export interface BuffBarViewModel {
  slots: BuffSlotViewModel[];
}

const TIP_COLOR_BODY = "|cfffff2d9";
const TIP_COLOR_SOURCE = "|cffffd700";

function clampMin(value: number, min: number): number {
  return value < min ? min : value;
}

function formatOneDecimal(n: number): string {
  if (typeof n !== "number" || !isFinite(n)) return "0.0";
  const scaled = round(clampMin(n, 0) * 10);
  const intPart = jass.R2I(scaled / 10);
  const fracPart = scaled % 10;
  return `${intPart}.${fracPart}`;
}

function formatDotTooltip(
  template: string,
  durationForDisplay: number,
  effectValue: number,
  effectValue2: number,
  sourceName: string | undefined,
  intervalSec: number
): { bodyText: string; sourceText: string } {
  const rem = typeof durationForDisplay === "number" && isFinite(durationForDisplay) ? clampMin(durationForDisplay, 0) : 0;
  const val = typeof effectValue === "number" && isFinite(effectValue) ? effectValue : 0;
  const intv = typeof intervalSec === "number" && isFinite(intervalSec) && intervalSec > 0 ? intervalSec : 1;

  const timeStr = formatOneDecimal(rem);
  const damageStr = formatOneDecimal(val);
  const damageStr2 = formatOneDecimal(typeof effectValue2 === "number" && isFinite(effectValue2) ? effectValue2 : 0);
  const intervalStr = formatOneDecimal(intv);
  const dataStr = formatOneDecimal(val <= 1 ? val * 100 : val);

  let s = template;
  s = s.split("time").join(timeStr);
  s = s.split("持续时间").join(timeStr);
  s = s.split("interval").join(intervalStr);
  s = s.split("damage").join(damageStr);
  s = s.split("data1").join(damageStr);
  s = s.split("data2").join(damageStr2);
  s = s.split("data").join(dataStr);

  const src = sourceName !== undefined && sourceName !== "" ? sourceName : "未记录";
  return {
    bodyText: TIP_COLOR_BODY + s + "|r",
    sourceText: TIP_COLOR_SOURCE + "来源：" + src + "|r",
  };
}

function formatBuffRemainOneDecimal(rem: number): string {
  return formatOneDecimal(rem);
}

function isUnitValid(unit: any): boolean {
  return !!(unit && unit !== 0);
}

export function buildBuffBarViewModel(unit: any | null): BuffBarViewModel {
  const slots: BuffSlotViewModel[] = [];
  for (let i = 0; i < MAX_SLOTS; i++) {
    slots.push({
      visible: false,
      iconPath: "",
      remainText: "",
      tooltipBodyText: "",
      tooltipSourceText: "",
    });
  }

  if (!unit || !isUnitValid(unit)) {
    debugLog("BuffUI.VM", "return-empty", "reason=invalid-unit", "unit=" + tostringCompat(unit));
    return { slots };
  }

  const inBuffPool = buffPoolMod.isUnitInBuffPool(unit);
  if (!inBuffPool) {
    debugLog("BuffUI.VM", "return-empty", "reason=not-in-buff-pool", "unit=" + tostringCompat(unit));
    return { slots };
  }

  const ids = buffPoolMod.getBuffIdsOnUnit(unit);
  debugLog("BuffUI.VM", "unit=" + tostringCompat(unit), "inPool=" + tostringCompat(inBuffPool), "idsLen=" + ids.length);
  const rows: Array<{
    id: string;
    state: any;
    iconOverride?: string;
  }> = [];

  for (let i = 0; i < ids.length; i++) {
    const bid = ids[i];
    const rt = buffPoolMod.getBuffRuntime(unit, bid);
    if (rt) {
      rows.push({
        id: bid,
        state: {
          effect: rt.effect,
          effect2: rt.effect2 ?? 0,
          remaining: rt.remaining,
          iconRemaining: buffPoolMod.getDotIconDisplayRemaining(unit, bid, rt.remaining),
          sourceName: rt.sourceName,
          _dotParsedDuration: (rt as any)._dotParsedDuration,
        },
        iconOverride: rt.iconOverride,
      });
    }
  }

  const buffs = buffTableMod.buffs;
  rows.sort((a, b) => {
    const pa = buffs[a.id]?.priority ?? 0;
    const pb = buffs[b.id]?.priority ?? 0;
    if (pa !== pb) return pb - pa;
    return a.id < b.id ? -1 : 1;
  });

  for (let i = 0; i < MAX_SLOTS && i < rows.length; i++) {
    const row = rows[i];
    const meta = buffs[row.id];
    const iconPath = row.iconOverride && row.iconOverride !== "" ? row.iconOverride : meta?.icon ?? "";
    if (iconPath === "") continue;

    const pd = row.state._dotParsedDuration;
    const durationForTip = typeof pd === "number" && isFinite(pd) && pd > 0 ? pd : row.state.remaining;

    let tooltipBodyText = "";
    let tooltipSourceText = "";
    if (meta !== undefined) {
      const tooltipParts = formatDotTooltip(
        meta.tooltip,
        durationForTip,
        row.state.effect,
        row.state.effect2 ?? 0,
        row.state.sourceName,
        meta.interval
      );
      tooltipBodyText = tooltipParts.bodyText;
      tooltipSourceText = tooltipParts.sourceText;
    } else {
      tooltipBodyText =
        TIP_COLOR_BODY +
        row.id +
        " 剩余 " +
        formatOneDecimal(row.state.remaining) +
        " 秒，效果1 " +
        formatOneDecimal(row.state.effect) +
        "，效果2 " +
        formatOneDecimal(row.state.effect2 ?? 0) +
        "|r";
      tooltipSourceText =
        TIP_COLOR_SOURCE +
        "来源：" +
        (row.state.sourceName && row.state.sourceName !== "" ? row.state.sourceName : "未记录") +
        "|r";
    }

    const remainStr = formatBuffRemainOneDecimal(row.state.iconRemaining);
    const remainText = "|cffffffff" + remainStr + "|r";

    slots[i] = {
      visible: true,
      iconPath,
      remainText,
      tooltipBodyText,
      tooltipSourceText,
    };
  }

  let visibleCount = 0;
  for (let i = 0; i < slots.length; i++) {
    if (slots[i].visible === true) visibleCount++;
  }
  debugLog("BuffUI.VM", "unit=" + tostringCompat(unit), "rowsLen=" + rows.length, "visible=" + visibleCount);

  return { slots };
}

export function getMaxSlots(): number {
  return MAX_SLOTS;
}

function tostringCompat(value: any): string {
  if (value == null) return "nil";
  return "" + value;
}
