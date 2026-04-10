const jass = require("jass.common");
const japi = require("jass.japi");
const 硬件函数 = require("系统.00．核心系统.04．硬件函数");
const UI工具 = require("系统.09．表现系统.01．UI工具.index");
const buffPoolMod = require("系统.05．Buff系统.00．Buff系统");
const buffTableMod = require("系统.05．Buff系统.01．Buff表");
const BUFF_BAR_X0 = 0.204;
const BUFF_BAR_Y = 0.1655;
const ICON_W = 0.02;
const ICON_H = 16 / 600;
const ICON_GAP = 0.0005;
const MAX_SLOTS = 20;
const BUFF_BAR_REFRESH_SEC = 0.1;
const TIP_BOX_TEX = "UI\\wenbenkuang.blp";
const TIP_W = 0.22;
const TIP_H = 0.056;
const TIP_PAD = 0.005;
const TIP_OFFSET_Y_FROM_ICON_TOP = 0.07;
const TIP_COLOR_BODY = "|cfffff2d9";
const TIP_COLOR_SOURCE = "|cffffd700";
function tooltipIntStr(n) {
    if (typeof n !== "number" || !isFinite(n))
        return "0";
    return `${Math.floor(Math.max(0, n))}`;
}
function formatBuffRemainOneDecimal(rem) {
    if (typeof rem !== "number" || !isFinite(rem))
        return "0.0";
    return Math.max(0, rem).toFixed(1);
}
function formatDotTooltip(template, durationForDisplay, dps, sourceName, intervalSec) {
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
function tryDzFrameSetTooltipF2i(hostFrame, tooltipFrame) {
    if (!hostFrame || hostFrame === 0 || !tooltipFrame || tooltipFrame === 0)
        return;
    const setTip = japi.DzFrameSetTooltip;
    if (typeof setTip !== "function")
        return;
    const f2i = japi.DzF2I;
    pcall(() => {
        const tipId = typeof f2i === "function" ? f2i(tooltipFrame) : tooltipFrame;
        setTip(hostFrame, tipId);
    });
}
const slots = [];
const lastTipStrBySlot = [];
const lastRemainStrBySlot = [];
const slotHovering = [];
let refreshTimer = undefined;
let buffUiInitialized = false;
export let BUFF_UI_DEBUG = false;
let lastBuffUiDbgKey = "";
function debugBuffUi(msg) {
    if (!BUFF_UI_DEBUG)
        return;
    if (typeof jass.GetLocalPlayer !== "function" || typeof jass.DisplayTextToPlayer !== "function")
        return;
    const p = jass.GetLocalPlayer();
    jass.DisplayTextToPlayer(p, 0, 0, "[BuffUI] " + msg);
}
function countSelectedForPlayer(p) {
    if (!p || p === 0)
        return { n: 0, sole: null };
    if (typeof jass.CreateGroup !== "function")
        return { n: 0, sole: null };
    const g = jass.CreateGroup();
    const useSelectedNative = typeof jass.GroupEnumUnitsSelected === "function";
    if (useSelectedNative) {
        jass.GroupEnumUnitsSelected(g, p, null);
    }
    else {
        if (typeof jass.IsUnitSelected !== "function" ||
            typeof jass.GetWorldBounds !== "function" ||
            typeof jass.GroupEnumUnitsInRect !== "function") {
            jass.DestroyGroup(g);
            return { n: 0, sole: null };
        }
        jass.GroupEnumUnitsInRect(g, jass.GetWorldBounds(), null);
    }
    let n = 0;
    let sole = null;
    while (true) {
        const u = jass.FirstOfGroup(g);
        if (!u || u === 0)
            break;
        jass.GroupRemoveUnit(g, u);
        if (!useSelectedNative && !jass.IsUnitSelected(u, p))
            continue;
        n++;
        if (sole === null)
            sole = u;
    }
    jass.DestroyGroup(g);
    return { n, sole };
}
function getSoleSelectedUnitForPlayer(p) {
    const { n, sole } = countSelectedForPlayer(p);
    if (n !== 1)
        return null;
    return sole;
}
function isUnitRefLikelyValid(u) {
    if (u == null || u === 0)
        return false;
    if (typeof jass.GetUnitTypeId !== "function")
        return true;
    const tid = jass.GetUnitTypeId(u);
    return tid != null && tid !== 0;
}
function collectBuffRows(unit) {
    const rows = [];
    if (!buffPoolMod.isUnitInBuffPool(unit))
        return rows;
    const ids = buffPoolMod.getBuffIdsOnUnit(unit);
    for (let i = 0; i < ids.length; i++) {
        const bid = ids[i];
        const rt = buffPoolMod.getBuffRuntime(unit, bid);
        if (rt != null) {
            const real = rt.remaining;
            const iconRem = typeof buffPoolMod.getDotIconDisplayRemaining === "function"
                ? buffPoolMod.getDotIconDisplayRemaining(unit, bid, real)
                : real;
            const row = {
                id: bid,
                state: {
                    effect: rt.effect,
                    remaining: real,
                    iconRemaining: iconRem,
                    sourceName: rt.sourceName,
                },
                iconOverride: rt.iconOverride,
            };
            if (bid === "D001" || bid === "D002" || bid === "D003" || bid === "D004") {
                row.state._dotParsedDuration = rt._dotParsedDuration;
            }
            rows.push(row);
        }
    }
    const buffs = buffTableMod.buffs;
    rows.sort((a, b) => {
        const pa = buffs[a.id] != null ? buffs[a.id].priority : 0;
        const pb = buffs[b.id] != null ? buffs[b.id].priority : 0;
        if (pa !== pb)
            return pb - pa;
        return a.id < b.id ? -1 : 1;
    });
    return rows;
}
function hideSlot(i) {
    const s = slots[i];
    if (s == null)
        return;
    slotHovering[i] = false;
    lastTipStrBySlot[i] = "";
    lastRemainStrBySlot[i] = "";
    if (s.tipText !== 0)
        pcall(() => UI工具.hideFrame(s.tipText));
    if (s.tipBox !== 0)
        pcall(() => UI工具.hideFrame(s.tipBox));
    if (s.hit !== 0)
        pcall(() => UI工具.hideFrame(s.hit));
    if (s.root !== 0)
        pcall(() => UI工具.hideFrame(s.root));
}
function hideAllSlots() {
    for (let i = 0; i < MAX_SLOTS; i++)
        hideSlot(i);
}
function syncBuffBar() {
    pcall(() => {
        if (typeof jass.GetLocalPlayer !== "function") {
            hideAllSlots();
            return;
        }
        const lp = jass.GetLocalPlayer();
        if (lp == null || lp === 0)
            return;
        const { n: selN, sole } = countSelectedForPlayer(lp);
        const hid = sole != null && sole !== 0 && typeof jass.GetHandleId === "function"
            ? jass.GetHandleId(sole)
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
                debugBuffUi(`sel=${selN} hid=${hid} pool=${inPool ? 1 : 0} D001=${rtD001 != null ? 1 : 0} D002=${rtD002 != null ? 1 : 0} D003=${rtD003 != null ? 1 : 0} rows=${rowsProbe.length}`);
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
            if (!slot)
                continue;
            const iconTex = row.iconOverride !== undefined && row.iconOverride !== ""
                ? row.iconOverride
                : meta != null
                    ? meta.icon
                    : "";
            if (iconTex === "")
                continue;
            const pd = row.state._dotParsedDuration;
            const durationForTip = typeof pd === "number" && isFinite(pd) && pd > 0 ? pd : row.state.remaining;
            const tipStr = meta != null
                ? formatDotTooltip(meta.tooltip, durationForTip, row.state.effect, row.state.sourceName, meta.interval)
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
            pcall(() => UI工具.setFrameTexture(slot.root, iconTex));
            const remStr = formatBuffRemainOneDecimal(row.state.iconRemaining);
            if (slot.remainText && slot.remainText !== 0 && typeof japi.DzFrameSetText === "function") {
                if (lastRemainStrBySlot[i] !== remStr) {
                    lastRemainStrBySlot[i] = remStr;
                    pcall(() => japi.DzFrameSetText(slot.remainText, "|cffffffff" + remStr + "|r"));
                }
            }
            if (slot.tipText && slot.tipText !== 0 && typeof japi.DzFrameSetText === "function") {
                if (lastTipStrBySlot[i] !== tipStr) {
                    lastTipStrBySlot[i] = tipStr;
                    pcall(() => japi.DzFrameSetText(slot.tipText, tipStr));
                }
            }
            pcall(() => UI工具.showFrame(slot.root));
            if (slot.hit !== 0)
                pcall(() => UI工具.showFrame(slot.hit));
            if (!slotHovering[i]) {
                if (slot.tipBox !== 0)
                    pcall(() => UI工具.hideFrame(slot.tipBox));
                if (slot.tipText !== 0)
                    pcall(() => UI工具.hideFrame(slot.tipText));
            }
        }
    });
}
function createOneSlot(index, parent) {
    try {
        const x = BUFF_BAR_X0 + index * (ICON_W + ICON_GAP);
        const bd = UI工具.createFrame({
            type: UI工具.FrameType.BACKDROP,
            name: "BuffUIBarIcon" + index,
            parent,
            template: "template",
            visible: false,
        }) || 0;
        if (!bd || bd === 0)
            return null;
        pcall(() => UI工具.setFramePosition(bd, { point: UI工具.FramePoint.TOPLEFT, x, y: BUFF_BAR_Y }));
        pcall(() => UI工具.setFrameSize(bd, { width: ICON_W, height: ICON_H }));
        pcall(() => UI工具.setFrameTexture(bd, "ReplaceableTextures\\CommandButtons\\BTNStatUp.blp"));
        if (typeof japi.DzFrameSetLevel === "function")
            pcall(() => japi.DzFrameSetLevel(bd, 180));
        const remainText = UI工具.createTextLabel("BuffUIBarRemain" + index, bd, "|cffffffff0.0|r", {
            relativeTo: bd,
            point: UI工具.FramePoint.BOTTOM,
            relativePoint: UI工具.FramePoint.BOTTOM,
            x: 0,
            y: 0.001,
        }, { width: ICON_W, height: 0.014 }) || 0;
        if (remainText && remainText !== 0) {
            if (typeof japi.DzFrameSetTextAlignment === "function") {
                pcall(() => {
                    japi.DzFrameSetTextAlignment(remainText, UI工具.FramePoint.CENTER);
                });
            }
            if (typeof japi.DzFrameSetLevel === "function")
                pcall(() => japi.DzFrameSetLevel(remainText, 182));
        }
        const hit = UI工具.createFrame({
            type: UI工具.FrameType.GLUETEXTBUTTON,
            name: "BuffUIBarHit" + index,
            parent: bd,
            template: "template",
            visible: false,
            enable: true,
            alpha: 0,
        }) || 0;
        if (hit && hit !== 0 && typeof japi.DzFrameSetAllPoints === "function") {
            pcall(() => japi.DzFrameSetAllPoints(hit, bd));
            if (typeof japi.DzFrameSetLevel === "function")
                pcall(() => japi.DzFrameSetLevel(hit, 181));
            pcall(() => UI工具.setFrameHoverEvents(hit, () => {
                slotHovering[index] = true;
                const s = slots[index];
                if (s != null && s.tipBox !== 0)
                    pcall(() => UI工具.showFrame(s.tipBox));
                if (s != null && s.tipText !== 0)
                    pcall(() => UI工具.showFrame(s.tipText));
            }, () => {
                slotHovering[index] = false;
                const s = slots[index];
                if (s != null && s.tipText !== 0)
                    pcall(() => UI工具.hideFrame(s.tipText));
                if (s != null && s.tipBox !== 0)
                    pcall(() => UI工具.hideFrame(s.tipBox));
            }, false));
        }
        const boxW = TIP_W + TIP_PAD * 2;
        const boxH = TIP_H + TIP_PAD * 2;
        const tipBox = UI工具.createFrame({
            type: UI工具.FrameType.BACKDROP,
            name: "BuffUIBarTip" + index,
            parent,
            template: "template",
            visible: false,
        }) || 0;
        if (tipBox && tipBox !== 0) {
            pcall(() => UI工具.setFramePointRelative(tipBox, UI工具.FramePoint.TOPLEFT, bd, UI工具.FramePoint.TOPRIGHT, 0.002, TIP_OFFSET_Y_FROM_ICON_TOP));
            pcall(() => UI工具.setFrameSize(tipBox, { width: boxW, height: boxH }));
            pcall(() => UI工具.setFrameTexture(tipBox, TIP_BOX_TEX));
            if (typeof japi.DzFrameSetLevel === "function")
                pcall(() => japi.DzFrameSetLevel(tipBox, 0));
            pcall(() => UI工具.hideFrame(tipBox));
        }
        const tipText = UI工具.createTextLabel("BuffUIBarTipTxt" + index, tipBox && tipBox !== 0 ? tipBox : bd, "", tipBox && tipBox !== 0
            ? { relativeTo: tipBox, point: UI工具.FramePoint.CENTER, relativePoint: UI工具.FramePoint.CENTER, x: 0, y: 0 }
            : { relativeTo: bd, point: UI工具.FramePoint.TOPLEFT, relativePoint: UI工具.FramePoint.TOPRIGHT, x: 0.002, y: TIP_OFFSET_Y_FROM_ICON_TOP }, { width: boxW * 0.92, height: boxH * 0.88 }) || 0;
        if (tipText && tipText !== 0) {
            if (typeof japi.DzFrameSetTextAlignment === "function") {
                pcall(() => {
                    japi.DzFrameSetTextAlignment(tipText, 0);
                });
            }
            if (typeof japi.DzFrameSetLevel === "function")
                pcall(() => japi.DzFrameSetLevel(tipText, 0));
            pcall(() => UI工具.hideFrame(tipText));
        }
        if (hit !== 0 && tipBox !== 0)
            tryDzFrameSetTooltipF2i(hit, tipBox);
        pcall(() => UI工具.hideFrame(bd));
        return {
            root: bd,
            remainText: remainText || 0,
            hit: hit || 0,
            tipBox: tipBox || 0,
            tipText: tipText || 0,
        };
    }
    catch (e) {
        return null;
    }
}
function createUi() {
    pcall(() => {
        if (typeof jass.GetLocalPlayer !== "function")
            return;
        const lp = jass.GetLocalPlayer();
        if (lp == null || lp === 0)
            return;
        const parent = 硬件函数.getGameUI();
        if (parent === 0 || parent == null)
            return;
        for (let j = 0; j < MAX_SLOTS; j++) {
            lastTipStrBySlot[j] = "";
            lastRemainStrBySlot[j] = "";
            slotHovering[j] = false;
        }
        for (let i = 0; i < MAX_SLOTS; i++) {
            const s = createOneSlot(i, parent);
            if (s != null)
                slots[i] = s;
        }
    });
}
function startRefreshTimer() {
    pcall(() => {
        if (refreshTimer != null)
            return;
        if (typeof jass.CreateTimer !== "function" || typeof jass.TimerStart !== "function")
            return;
        refreshTimer = jass.CreateTimer();
        jass.TimerStart(refreshTimer, BUFF_BAR_REFRESH_SEC, true, () => {
            pcall(() => {
                if (typeof jass.GetLocalPlayer !== "function")
                    return;
                const lp = jass.GetLocalPlayer();
                if (lp == null || lp === 0)
                    return;
                syncBuffBar();
            });
        });
    });
}
export function init() {
    if (buffUiInitialized)
        return;
    buffUiInitialized = true;
    pcall(() => {
        if (typeof jass.CreateTimer === "function" && typeof jass.TimerStart === "function") {
            const delayTimer = jass.CreateTimer();
            jass.TimerStart(delayTimer, 1.0, false, () => {
                pcall(() => {
                    if (typeof jass.GetLocalPlayer !== "function") {
                        if (typeof jass.DestroyTimer === "function")
                            jass.DestroyTimer(delayTimer);
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
