local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
local ____04_FF0EDOT_5DE5_5177 = require("系统.04．伤害系统.01．DOT定义.04．DOT工具")
local collectHidsInTab = ____04_FF0EDOT_5DE5_5177.collectHidsInTab
local isValidDotStateRow = ____04_FF0EDOT_5DE5_5177.isValidDotStateRow
local tabDeleteHid = ____04_FF0EDOT_5DE5_5177.tabDeleteHid
local tabRowForHid = ____04_FF0EDOT_5DE5_5177.tabRowForHid
local BUFF_ID_TO_DOT_TYPE = {D001 = "antiHeal", D002 = "burn", D003 = "poison", D004 = "trollCurse"}
local function dotTypeIdFromBuffId(self, buffID)
    return BUFF_ID_TO_DOT_TYPE[buffID] or nil
end
function ____exports.createDotStateSync(self, deps)
    local function syncDotRemainingFromBuffPool(self)
        local buffM = require("系统.05．Buff系统.00．Buff系统")
        local map = buffM.DOT_TYPE_TO_BUFF_ID
        if map == nil or type(buffM.getBuffRuntimeByHid) ~= "function" then
            return
        end
        for typeId in pairs(deps.stateByType) do
            do
                local __continue6
                repeat
                    local tab = deps.stateByType[typeId]
                    if tab == nil then
                        __continue6 = true
                        break
                    end
                    local buffID = map[typeId]
                    if buffID == nil or buffID == "" then
                        __continue6 = true
                        break
                    end
                    local hids = collectHidsInTab(nil, tab)
                    do
                        local hi = 0
                        while hi < #hids do
                            do
                                local __continue10
                                repeat
                                    local kn = hids[hi + 1]
                                    local v = tabRowForHid(nil, tab, kn)
                                    if v == nil or not isValidDotStateRow(nil, v) then
                                        tabDeleteHid(nil, tab, kn)
                                        __continue10 = true
                                        break
                                    end
                                    local rt = buffM:getBuffRuntimeByHid(kn, buffID)
                                    if rt == nil or rt.remaining <= 0 then
                                        local cfg = __TS__ArrayFind(
                                            deps.dotTypes,
                                            function(____, c) return c.id == typeId end
                                        )
                                        if cfg ~= nil and type(cfg.onEnd) == "function" then
                                            local uref = v._dotUnitRef
                                            local ____self_1 = cfg
                                            local ____self_1_onEnd_2 = ____self_1.onEnd
                                            local ____temp_0
                                            if uref ~= nil then
                                                ____temp_0 = uref
                                            else
                                                ____temp_0 = kn
                                            end
                                            ____self_1_onEnd_2(____self_1, ____temp_0, v)
                                        end
                                        deps:notifyBuffPool(typeId, kn, nil)
                                        tabDeleteHid(nil, tab, kn)
                                        deps:removeDotTicksForTargetHid(typeId, kn)
                                        __continue10 = true
                                        break
                                    end
                                    v.remaining = rt.remaining
                                    v.effect = rt.effect
                                    if rt.sourceName ~= nil then
                                        v.sourceName = rt.sourceName
                                    end
                                    if rt._dotParsedDuration ~= nil then
                                        v._dotParsedDuration = rt._dotParsedDuration
                                    end
                                    __continue10 = true
                                until true
                                if not __continue10 then
                                    break
                                end
                            end
                            hi = hi + 1
                        end
                    end
                    __continue6 = true
                until true
                if not __continue6 then
                    break
                end
            end
        end
    end
    local function clearDotByBuffPoolExpire(self, buffID, hid)
        local typeId = dotTypeIdFromBuffId(nil, buffID)
        if typeId == nil or hid == 0 then
            return
        end
        local tab = deps.stateByType[typeId]
        if tab == nil then
            return
        end
        local v = tabRowForHid(nil, tab, hid)
        if v ~= nil and isValidDotStateRow(nil, v) then
            local cfg = __TS__ArrayFind(
                deps.dotTypes,
                function(____, c) return c.id == typeId end
            )
            if cfg ~= nil and type(cfg.onEnd) == "function" then
                local uref = v._dotUnitRef
                local ____self_4 = cfg
                local ____self_4_onEnd_5 = ____self_4.onEnd
                local ____temp_3
                if uref ~= nil then
                    ____temp_3 = uref
                else
                    ____temp_3 = hid
                end
                ____self_4_onEnd_5(____self_4, ____temp_3, v)
            end
        end
        tabDeleteHid(nil, tab, hid)
        deps:removeDotTicksForTargetHid(typeId, hid)
    end
    return {syncDotRemainingFromBuffPool = syncDotRemainingFromBuffPool, clearDotByBuffPoolExpire = clearDotByBuffPoolExpire}
end
return ____exports
