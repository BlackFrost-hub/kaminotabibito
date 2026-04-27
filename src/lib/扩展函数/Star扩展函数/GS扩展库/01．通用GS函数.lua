--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_0.QuestMessageBJ
local function abs(self, value)
    return math.abs(value)
end
function ____exports.SoHeroHatm(self, c)
    if c == nil or c == 0 then
        return 0
    end
    local inventoryAbilityId = 1095658094
    if jass:GetUnitAbilityLevel(c, inventoryAbilityId) <= 0 then
        return 0
    end
    local n = 0
    do
        local i = 0
        while i <= 5 do
            if jass:UnitItemInSlot(c, i) ~= nil then
                n = n + 1
            end
            i = i + 1
        end
    end
    return n
end
function ____exports.GS_news(self, P, S)
    if P == nil or P == 0 or S == nil then
        return
    end
    local F = jass:CreateForce()
    if F == nil or F == 0 then
        return
    end
    jass:ForceAddPlayer(F, P)
    local ____QuestMessageBJ_2 = QuestMessageBJ
    local ____jglobals_bj_QUESTMESSAGE_UPDATED_1 = jglobals.bj_QUESTMESSAGE_UPDATED
    if ____jglobals_bj_QUESTMESSAGE_UPDATED_1 == nil then
        ____jglobals_bj_QUESTMESSAGE_UPDATED_1 = 1
    end
    ____QuestMessageBJ_2(nil, F, ____jglobals_bj_QUESTMESSAGE_UPDATED_1, S)
    jass:DestroyForce(F)
end
function ____exports.GS_DisplayTimedTextToForcetakes(self, ply, r, str)
    if ply == nil or ply == 0 or str == nil then
        return
    end
    jass:DisplayTimedTextToPlayer(
        ply,
        0,
        0,
        r,
        str
    )
end
function ____exports.GS_UnitSector(self, u1, u2, r)
    if u1 == nil or u1 == 0 or u2 == nil or u2 == 0 then
        return false
    end
    local angle1 = jass:GetUnitFacing(u1) or 0
    local dy = (jass:GetUnitY(u1) or 0) - (jass:GetUnitY(u2) or 0)
    local dx = (jass:GetUnitX(u1) or 0) - (jass:GetUnitX(u2) or 0)
    local ____jglobals_bj_RADTODEG_3 = jglobals.bj_RADTODEG
    if ____jglobals_bj_RADTODEG_3 == nil then
        ____jglobals_bj_RADTODEG_3 = 180 / math.pi
    end
    local angle2 = ____jglobals_bj_RADTODEG_3 * jass:Atan2(dy, dx)
    return abs(
        nil,
        abs(nil, angle1 - angle2 - 180) - 180
    ) > r
end
function ____exports.GS_Sector(self, angle1, angle2)
    return abs(
        nil,
        abs(nil, angle1 - angle2 - 180) - 180
    )
end
return ____exports
