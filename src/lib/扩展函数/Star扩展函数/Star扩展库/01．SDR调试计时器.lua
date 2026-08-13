--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local SDR_Index = 0
local function hashHandle()
    local g = _G
    local function pick(name)
        if g[name] ~= nil then
            return g[name]
        end
        if jglobals and jglobals[name] ~= nil then
            return jglobals[name]
        end
        if jass and jass[name] ~= nil then
            return jass[name]
        end
        return nil
    end
    local ____pick_result_0 = pick("StarBaseHT")
    if ____pick_result_0 == nil then
        ____pick_result_0 = pick("YDHASH_HANDLE")
    end
    local ____pick_result_0_1 = ____pick_result_0
    if ____pick_result_0_1 == nil then
        ____pick_result_0_1 = pick("YDHT")
    end
    local ____pick_result_0_1_2 = ____pick_result_0_1
    if ____pick_result_0_1_2 == nil then
        ____pick_result_0_1_2 = pick("udg_YDHASH_HANDLE")
    end
    local ____pick_result_0_1_2_3 = ____pick_result_0_1_2
    if ____pick_result_0_1_2_3 == nil then
        ____pick_result_0_1_2_3 = pick("udg_YDHT")
    end
    return ____pick_result_0_1_2_3
end
function ____exports.SDR_DebugTimer(t, time, isloop, Target, trig)
    local ht = hashHandle()
    if not ht then
        return
    end
    local id = jass:GetHandleId(t)
    jass:SaveTimerHandle(ht, SDR_Index, 0, t)
    jass:SaveInteger(ht, id, 0, SDR_Index)
    jass:SaveReal(ht, id, 1, time)
    jass:SaveBoolean(ht, id, 2, isloop)
    jass:SaveStr(ht, id, 3, Target)
    jass:SaveStr(ht, id, 4, trig)
    SDR_Index = SDR_Index + 1
end
return ____exports
