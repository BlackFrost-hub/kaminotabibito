local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____04A_FF0E_5FEB_901FBuff_5171_4EAB = require("lib.扩展函数.Star扩展函数.Star扩展库.04A．快速Buff共享")
local SFB_Unit = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.SFB_Unit
local ____SFB__8D1F_9762BUFF = ____04A_FF0E_5FEB_901FBuff_5171_4EAB["SFB_负面BUFF"]
local SUC_IsUnitStructure = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.SUC_IsUnitStructure
local SUC_IsValidUnit = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.SUC_IsValidUnit
local getSfbBuffId = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.getSfbBuffId
local getUnitSourceName = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.getUnitSourceName
local normalizeRealValue = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.normalizeRealValue
--- Star扩展库 - 快速Buff诅咒
-- 
-- 单独拆分原因：
-- - 诅咒是纯 TS 数值逻辑，不属于通用原生 Buff 施加骨架
-- - 从 04A 抽离后，04A 只保留共享状态 / 映射 / 通用施加函数
local jass = require("jass.common")
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local YDUserDataGet = YDUserDataGetSafe
local YDUserDataSet = YDUserDataSetSafe
local CURSE_ACCURACY_ATTR = "命中率"
____exports.SFB_CURSE_DEFAULT_ACCURACY_REDUCTION = 0.33
local curseAccuracyStateByHid = {}
local function getSafeHandleId(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit)
end
local function getUnitRawAccuracyValue(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return normalizeRealValue(YDUserDataGet("unit", unit, CURSE_ACCURACY_ATTR, "real"))
end
local function getOwnerRawAccuracyValue(owner)
    if owner == nil or owner == 0 then
        return 0
    end
    return normalizeRealValue(YDUserDataGet("player", owner, CURSE_ACCURACY_ATTR, "real"))
end
local function getUnitEffectiveAccuracyValue(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    local unitValue = getUnitRawAccuracyValue(unit)
    if unitValue ~= 0 then
        return unitValue
    end
    return getOwnerRawAccuracyValue(GetOwningPlayer(unit))
end
local function shouldUsePlayerAccuracy(unit)
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    local playerId = GetPlayerId(owner)
    return playerId >= 0 and playerId <= 3
end
local function writeTrackedAccuracy(state, value, unitOrHid)
    if state.usePlayerAttr then
        if state.ownerPlayer ~= nil and state.ownerPlayer ~= 0 then
            YDUserDataSet(
                "player",
                state.ownerPlayer,
                CURSE_ACCURACY_ATTR,
                "real",
                value
            )
        end
        return
    end
    local ____temp_2
    if unitOrHid ~= nil and unitOrHid ~= 0 and type(unitOrHid) ~= "number" then
        ____temp_2 = unitOrHid
    else
        ____temp_2 = state.targetUnit
    end
    local unit = ____temp_2
    if unit ~= nil and unit ~= 0 then
        YDUserDataSet(
            "unit",
            unit,
            CURSE_ACCURACY_ATTR,
            "real",
            value
        )
    end
end
local function onSfbCurseRemoved(unitOrHid)
    local hid = type(unitOrHid) == "number" and unitOrHid or ((unitOrHid == nil or unitOrHid == 0) and 0 or GetHandleId(unitOrHid))
    if hid == 0 then
        return
    end
    local state = curseAccuracyStateByHid[hid]
    if state == nil then
        return
    end
    writeTrackedAccuracy(state, state.previousAccuracy, unitOrHid)
    __TS__Delete(curseAccuracyStateByHid, hid)
end
____exports["SFB_施加自定义诅咒Buff"] = function(sourceUnit, u, time)
    if not SUC_IsValidUnit(u) or time <= 0 then
        return
    end
    if SUC_IsUnitStructure(u) then
        return
    end
    if u == SFB_Unit then
        return
    end
    local hid = GetHandleId(u)
    local buffID = getSfbBuffId(____SFB__8D1F_9762BUFF["诅咒"])
    if hid == 0 or buffID == nil or buffID == "" then
        return
    end
    local state = curseAccuracyStateByHid[hid]
    if state == nil then
        local owner = GetOwningPlayer(u)
        state = {
            targetUnit = u,
            ownerPlayer = owner,
            usePlayerAttr = shouldUsePlayerAccuracy(u),
            previousAccuracy = shouldUsePlayerAccuracy(u) and getOwnerRawAccuracyValue(owner) or getUnitRawAccuracyValue(u)
        }
        curseAccuracyStateByHid[hid] = state
        local nextAccuracy = getUnitEffectiveAccuracyValue(u) - ____exports.SFB_CURSE_DEFAULT_ACCURACY_REDUCTION
        writeTrackedAccuracy(state, nextAccuracy, u)
    end
    registerManualBuff(
        u,
        buffID,
        time,
        0,
        {
            sourceName = getUnitSourceName(sourceUnit, u),
            onRemove = onSfbCurseRemoved
        }
    )
end
return ____exports
