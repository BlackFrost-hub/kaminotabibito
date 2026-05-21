/** @noSelfInFile */
/**
 * Star扩展库 - 快速Buff诅咒
 *
 * 单独拆分原因：
 * - 诅咒是纯 TS 数值逻辑，不属于通用原生 Buff 施加骨架
 * - 从 04A 抽离后，04A 只保留共享状态 / 映射 / 通用施加函数
 */
const jass = require("jass.common");
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统");
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版");
import { SFB_Unit, SFB_负面BUFF, SUC_IsUnitStructure, SUC_IsValidUnit, getSfbBuffId, getUnitSourceName, normalizeRealValue, } from "./04A．快速Buff共享";
const GetHandleId = jass["GetHandleId"];
const GetOwningPlayer = jass["GetOwningPlayer"];
const GetPlayerId = jass["GetPlayerId"];
const YDUserDataGet = YDUserDataGetSafe;
const YDUserDataSet = YDUserDataSetSafe;
const CURSE_ACCURACY_ATTR = "命中率";
export const SFB_CURSE_DEFAULT_ACCURACY_REDUCTION = 0.33;
const curseAccuracyStateByHid = {};
function getUnitRawAccuracyValue(unit) {
    if (unit == null || unit === 0)
        return 0;
    return normalizeRealValue(YDUserDataGet("unit", unit, CURSE_ACCURACY_ATTR, "real"));
}
function getOwnerRawAccuracyValue(owner) {
    if (owner == null || owner === 0)
        return 0;
    return normalizeRealValue(YDUserDataGet("player", owner, CURSE_ACCURACY_ATTR, "real"));
}
function getUnitEffectiveAccuracyValue(unit) {
    if (unit == null || unit === 0)
        return 0;
    const unitValue = getUnitRawAccuracyValue(unit);
    if (unitValue !== 0)
        return unitValue;
    return getOwnerRawAccuracyValue(GetOwningPlayer(unit));
}
function shouldUsePlayerAccuracy(unit) {
    const owner = GetOwningPlayer(unit);
    if (owner == null || owner === 0)
        return false;
    const playerId = GetPlayerId(owner);
    return playerId >= 0 && playerId <= 3;
}
function writeTrackedAccuracy(state, value, unitOrHid) {
    if (state.usePlayerAttr) {
        if (state.ownerPlayer != null && state.ownerPlayer !== 0) {
            YDUserDataSet("player", state.ownerPlayer, CURSE_ACCURACY_ATTR, "real", value);
        }
        return;
    }
    const unit = (unitOrHid != null && unitOrHid !== 0 && typeof unitOrHid !== "number")
        ? unitOrHid
        : state.targetUnit;
    if (unit != null && unit !== 0) {
        YDUserDataSet("unit", unit, CURSE_ACCURACY_ATTR, "real", value);
    }
}
function onSfbCurseRemoved(unitOrHid) {
    const hid = typeof unitOrHid === "number"
        ? unitOrHid
        : ((unitOrHid == null || unitOrHid === 0) ? 0 : GetHandleId(unitOrHid));
    if (hid === 0)
        return;
    const state = curseAccuracyStateByHid[hid];
    if (state == null)
        return;
    writeTrackedAccuracy(state, state.previousAccuracy, unitOrHid);
    delete curseAccuracyStateByHid[hid];
}
export function SFB_施加自定义诅咒Buff(sourceUnit, u, time) {
    if (!SUC_IsValidUnit(u) || time <= 0)
        return;
    if (SUC_IsUnitStructure(u))
        return;
    if (u === SFB_Unit)
        return;
    const hid = GetHandleId(u);
    const buffID = getSfbBuffId(SFB_负面BUFF.诅咒);
    if (hid === 0 || buffID == null || buffID === "")
        return;
    let state = curseAccuracyStateByHid[hid];
    if (state == null) {
        const owner = GetOwningPlayer(u);
        state = {
            targetUnit: u,
            ownerPlayer: owner,
            usePlayerAttr: shouldUsePlayerAccuracy(u),
            previousAccuracy: shouldUsePlayerAccuracy(u) ? getOwnerRawAccuracyValue(owner) : getUnitRawAccuracyValue(u),
        };
        curseAccuracyStateByHid[hid] = state;
        writeTrackedAccuracy(state, getUnitEffectiveAccuracyValue(u) - SFB_CURSE_DEFAULT_ACCURACY_REDUCTION, u);
    }
    registerManualBuff(u, buffID, time, 0, {
        sourceName: getUnitSourceName(sourceUnit, u),
        onRemove: onSfbCurseRemoved,
    });
}
