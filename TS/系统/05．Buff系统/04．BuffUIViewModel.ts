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
const { 是否百分比装备属性名 } = require("lib.扩展函数.物品相关函数.装备数据查询") as {
  是否百分比装备属性名: (this: void, 属性名: string) => boolean;
};

const MAX_SLOTS = 20;
const jass = require("jass.common") as any;
const round = 数学运算.round;
setDebug("BuffUI.VM", false);

export interface BuffSlotViewModel {
  visible: boolean;
  iconPath: string;
  remainText: string;
  stackText: string;
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

function 是否百分比Buff字段(this: void, template: string, placeholder: string, 属性名: string | undefined): boolean {
  if (属性名 !== undefined && 属性名 !== "" && 是否百分比装备属性名(属性名)) return true;
  return template.indexOf(placeholder + "%") >= 0;
}

function formatBuffValue(this: void, template: string, placeholder: string, value: number, 属性名: string | undefined): string {
  const displayValue = 是否百分比Buff字段(template, placeholder, 属性名) && value > -1 && value < 1 ? value * 100 : value;
  return formatOneDecimal(displayValue);
}

function formatBuffSourceText(
  this: void,
  sourceName: string | undefined,
  effectSourceName: string | undefined,
  effectSourceType: "装备" | "技能" | undefined
): string {
  let sourceText = TIP_COLOR_SOURCE;
  if (sourceName !== undefined && sourceName !== "") {
    sourceText += "单位来源：『" + sourceName + "』";
  }
  if (effectSourceName !== undefined && effectSourceName !== "") {
    if (sourceText !== TIP_COLOR_SOURCE) sourceText += "|n";
    sourceText += (effectSourceType === "装备" ? "装备来源：『" : "技能来源：『") + effectSourceName + "』";
  }
  return sourceText + "|r";
}

function formatDotTooltip(
  template: string,
  durationForDisplay: number,
  effectValue: number,
  effectValue2: number,
  stack: number,
  sourceName: string | undefined,
  effectSourceName: string | undefined,
  effectSourceType: "装备" | "技能" | undefined,
  intervalSec: number,
  data属性名: string | undefined,
  data2属性名: string | undefined
): { bodyText: string; sourceText: string } {
  const rem = typeof durationForDisplay === "number" && isFinite(durationForDisplay) ? clampMin(durationForDisplay, 0) : 0;
  const val = typeof effectValue === "number" && isFinite(effectValue) ? effectValue : 0;
  const intv = typeof intervalSec === "number" && isFinite(intervalSec) && intervalSec > 0 ? intervalSec : 1;

  const timeStr = formatOneDecimal(rem);
  const damageStr = formatOneDecimal(val);
  const val2 = typeof effectValue2 === "number" && isFinite(effectValue2) ? effectValue2 : 0;
  const intervalStr = formatOneDecimal(intv);
  const dataStr = formatBuffValue(template, "data", val, data属性名);
  const dataStr1 = formatBuffValue(template, "data1", val, data属性名);
  const dataStr2 = formatBuffValue(template, "data2", val2, data2属性名);
  const direction = val >= 0 ? "增加" : "减少";

  let s = template;
  s = s.split("time").join(timeStr);
  s = s.split("持续时间").join(timeStr);
  s = s.split("interval").join(intervalStr);
  s = s.split("damage").join(damageStr);
  s = s.split("stack").join(tostringCompat(stack));
  s = s.split("增加或减少").join(direction);
  s = s.split("增加/减少").join(direction);
  s = s.split("增减").join(direction);
  s = s.split("data1").join(dataStr1);
  s = s.split("data2").join(dataStr2);
  s = s.split("data").join(dataStr);

  return {
    bodyText: TIP_COLOR_BODY + s + "|r",
    sourceText: formatBuffSourceText(sourceName, effectSourceName, effectSourceType),
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
      stackText: "",
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
          stack: rt.stack ?? 1,
          remaining: rt.remaining,
          iconRemaining: buffPoolMod.getDotIconDisplayRemaining(unit, bid, rt.remaining),
          sourceName: rt.sourceName,
          effectSourceName: rt.effectSourceName,
          effectSourceType: rt.effectSourceType,
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
        row.state.stack ?? 1,
        row.state.sourceName,
        row.state.effectSourceName,
        row.state.effectSourceType,
        meta.interval,
        typeof meta.data属性名 === "string" ? meta.data属性名 : undefined,
        typeof meta.data2属性名 === "string" ? meta.data2属性名 : undefined
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
      tooltipSourceText = formatBuffSourceText(row.state.sourceName, row.state.effectSourceName, row.state.effectSourceType);
    }

    const remainStr = formatBuffRemainOneDecimal(row.state.iconRemaining);
    const remainText = "|cffffffff" + remainStr + "|r";
    const 显示层数角标 = meta !== undefined && meta.maxStack > 1;
    const stack = typeof row.state.stack === "number" && row.state.stack >= 0 ? row.state.stack : 1;
    const stackText = 显示层数角标 ? "|cfffff2d9" + tostringCompat(stack) + "|r" : "";

    slots[i] = {
      visible: true,
      iconPath,
      remainText,
      stackText,
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
