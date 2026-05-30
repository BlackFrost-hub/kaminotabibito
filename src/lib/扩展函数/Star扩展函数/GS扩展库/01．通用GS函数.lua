--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.12．数学函数")
local RAbsBJ = ____require_result_0.RAbsBJ
local ____jglobals_bj_RADTODEG_1 = jglobals.bj_RADTODEG
if ____jglobals_bj_RADTODEG_1 == nil then
    ____jglobals_bj_RADTODEG_1 = 57.29577951308232
end
local BJ_RADTODEG = ____jglobals_bj_RADTODEG_1
local ____require_result_2 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_2.QuestMessageBJ
local function abs(value)
    return RAbsBJ(value)
end
function ____exports.SoHeroHatm(c)
    if c == nil or c == 0 then
        return 0
    end
    local inventoryAbilityId = 1095658094
    if jass.GetUnitAbilityLevel(c, inventoryAbilityId) <= 0 then
        return 0
    end
    local n = 0
    do
        local i = 0
        while i <= 5 do
            if jass.UnitItemInSlot(c, i) ~= nil then
                n = n + 1
            end
            i = i + 1
        end
    end
    return n
end
function ____exports.GS_news(P, S)
    if P == nil or P == 0 or S == nil then
        return
    end
    local F = jass.CreateForce()
    if F == nil or F == 0 then
        return
    end
    jass.ForceAddPlayer(F, P)
    local ____QuestMessageBJ_4 = QuestMessageBJ
    local ____jglobals_bj_QUESTMESSAGE_UPDATED_3 = jglobals.bj_QUESTMESSAGE_UPDATED
    if ____jglobals_bj_QUESTMESSAGE_UPDATED_3 == nil then
        ____jglobals_bj_QUESTMESSAGE_UPDATED_3 = 1
    end
    ____QuestMessageBJ_4(F, ____jglobals_bj_QUESTMESSAGE_UPDATED_3, S)
    jass.DestroyForce(F)
end
function ____exports.GS_DisplayTimedTextToForcetakes(ply, r, str)
    if ply == nil or ply == 0 or str == nil then
        return
    end
    jass.DisplayTimedTextToPlayer(
        ply,
        0,
        0,
        r,
        str
    )
end
function ____exports.GS_UnitSector(u1, u2, r)
    if r == nil or r == false or r == "" then
        r = 0
    end
    if u1 == nil or u1 == 0 or u2 == nil or u2 == 0 then
        return false
    end
    local angle1 = jass.GetUnitFacing(u1) or 0
    local dy = (jass.GetUnitY(u1) or 0) - (jass.GetUnitY(u2) or 0)
    local dx = (jass.GetUnitX(u1) or 0) - (jass.GetUnitX(u2) or 0)
    local angle2 = BJ_RADTODEG * jass.Atan2(dy, dx)
    return abs(abs(angle1 - angle2 - 180) - 180) > r
end
function ____exports.GS_Sector(angle1, angle2)
    if angle1 == nil or angle1 == false or angle1 == "" then
        angle1 = 0
    end
    if angle2 == nil or angle2 == false or angle2 == "" then
        angle2 = 0
    end
    return abs(abs(angle1 - angle2 - 180) - 180)
end
return ____exports
