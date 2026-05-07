local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local DOT_TYPE_TO_BUFF_ID = ____00_FF0EBuff_7CFB_7EDF.DOT_TYPE_TO_BUFF_ID
local getBuffRuntimeByHid = ____00_FF0EBuff_7CFB_7EDF.getBuffRuntimeByHid
local ____04_FF0EDOT_5DE5_5177 = require("系统.04．伤害系统.01．DOT定义.04．DOT工具")
local collectActiveDotPairs = ____04_FF0EDOT_5DE5_5177.collectActiveDotPairs
local deleteDotState = ____04_FF0EDOT_5DE5_5177.deleteDotState
local getDotState = ____04_FF0EDOT_5DE5_5177.getDotState
local ignoredTargetFlat = ____04_FF0EDOT_5DE5_5177.ignoredTargetFlat
local isValidDotStateRow = ____04_FF0EDOT_5DE5_5177.isValidDotStateRow
local makeDotFlatKey = ____04_FF0EDOT_5DE5_5177.makeDotFlatKey
local BUFF_ID_TO_DOT_TYPE = {D001 = "antiHeal", D002 = "burn", D003 = "poison", D004 = "trollCurse"}
local function dotTypeIdFromBuffId(buffID)
    return BUFF_ID_TO_DOT_TYPE[buffID] or nil
end
function ____exports.createDotStateSync(deps)
    local dotTypes = deps.dotTypes
    local notifyBuffPool = deps.notifyBuffPool
    local removeDotTicksForTargetHid = deps.removeDotTicksForTargetHid
    local function syncDotRemainingFromBuffPool()
        local ____pairs = collectActiveDotPairs()
        do
            local pi = 0
            while pi < #____pairs do
                do
                    local ____pairs_index_0 = ____pairs[pi + 1]
                    local typeId = ____pairs_index_0.typeId
                    local hid = ____pairs_index_0.hid
                    local buffID = DOT_TYPE_TO_BUFF_ID[typeId]
                    if buffID == nil or buffID == "" then
                        goto __continue6
                    end
                    local state = getDotState(typeId, hid)
                    if state == nil or not isValidDotStateRow(state) then
                        deleteDotState(typeId, hid)
                        goto __continue6
                    end
                    local rt = getBuffRuntimeByHid(hid, buffID)
                    if rt == nil or rt.remaining <= 0 then
                        local cfg = __TS__ArrayFind(
                            dotTypes,
                            function(____, c) return c.id == typeId end
                        )
                        if cfg ~= nil and type(cfg.onEnd) == "function" then
                            local uref = state._dotUnitRef
                            local ____self_2 = cfg
                            local ____self_2_onEnd_3 = ____self_2.onEnd
                            local ____temp_1
                            if uref ~= nil then
                                ____temp_1 = uref
                            else
                                ____temp_1 = hid
                            end
                            ____self_2_onEnd_3(____self_2, ____temp_1, state)
                        end
                        notifyBuffPool(typeId, hid, nil)
                        deleteDotState(typeId, hid)
                        removeDotTicksForTargetHid(typeId, hid)
                        local key = makeDotFlatKey(typeId, hid)
                        __TS__Delete(ignoredTargetFlat, key)
                        goto __continue6
                    end
                    state.remaining = rt.remaining
                    state.effect = rt.effect
                    if rt.sourceName ~= nil then
                        state.sourceName = rt.sourceName
                    end
                    if rt._dotParsedDuration ~= nil then
                        state._dotParsedDuration = rt._dotParsedDuration
                    end
                    local key = makeDotFlatKey(typeId, hid)
                    ignoredTargetFlat[key] = true
                end
                ::__continue6::
                pi = pi + 1
            end
        end
    end
    local function clearDotByBuffPoolExpire(buffID, hid)
        local typeId = dotTypeIdFromBuffId(buffID)
        if typeId == nil or hid == 0 then
            return
        end
        local state = getDotState(typeId, hid)
        if state ~= nil and isValidDotStateRow(state) then
            local cfg = __TS__ArrayFind(
                dotTypes,
                function(____, c) return c.id == typeId end
            )
            if cfg ~= nil and type(cfg.onEnd) == "function" then
                local uref = state._dotUnitRef
                local ____self_5 = cfg
                local ____self_5_onEnd_6 = ____self_5.onEnd
                local ____temp_4
                if uref ~= nil then
                    ____temp_4 = uref
                else
                    ____temp_4 = hid
                end
                ____self_5_onEnd_6(____self_5, ____temp_4, state)
            end
        end
        deleteDotState(typeId, hid)
        local key = makeDotFlatKey(typeId, hid)
        __TS__Delete(ignoredTargetFlat, key)
        removeDotTicksForTargetHid(typeId, hid)
    end
    return {syncDotRemainingFromBuffPool = syncDotRemainingFromBuffPool, clearDotByBuffPoolExpire = clearDotByBuffPoolExpire}
end
return ____exports
