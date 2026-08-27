local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____6D3E_53D1_5355_4F4D_53EC_5524_4E8B_4EF6, jass, playerUnitEvent, _____76D1_542C_5217_8868, _____5DF2_521D_59CB_5316, _____53D6_88AB_53EC_5524_5355_4F4D, _____53D6_53EC_5524_5355_4F4D
function _____6D3E_53D1_5355_4F4D_53EC_5524_4E8B_4EF6()
    local _____88AB_53EC_5524_5355_4F4D = _____53D6_88AB_53EC_5524_5355_4F4D()
    if _____88AB_53EC_5524_5355_4F4D == nil or _____88AB_53EC_5524_5355_4F4D == 0 then
        return
    end
    local _____53EC_5524_5355_4F4D = _____53D6_53EC_5524_5355_4F4D()
    do
        local i = 0
        while i < #_____76D1_542C_5217_8868 do
            local _____56DE_8C03 = _____76D1_542C_5217_8868[i + 1]
            if type(_____56DE_8C03) == "function" then
                _____56DE_8C03(_____88AB_53EC_5524_5355_4F4D, _____53EC_5524_5355_4F4D)
            end
            i = i + 1
        end
    end
end
____exports["初始化召唤事件中心"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    local _____89E6_53D1_5668 = jass:CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(_____89E6_53D1_5668, ____exports["召唤事件玩家ID列表"], jass.EVENT_PLAYER_UNIT_SUMMON)
    jass:TriggerAddAction(_____89E6_53D1_5668, _____6D3E_53D1_5355_4F4D_53EC_5524_4E8B_4EF6)
end
jass = require("jass.common")
playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
____exports["召唤事件玩家ID列表"] = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15
}
_____76D1_542C_5217_8868 = {}
_____5DF2_521D_59CB_5316 = false
_____53D6_88AB_53EC_5524_5355_4F4D = jass.GetSummonedUnit
_____53D6_53EC_5524_5355_4F4D = jass.GetSummoningUnit
local function _____662F_5426_5DF2_6CE8_518C_76D1_542C(_____56DE_8C03)
    do
        local i = 0
        while i < #_____76D1_542C_5217_8868 do
            if _____76D1_542C_5217_8868[i + 1] == _____56DE_8C03 then
                return true
            end
            i = i + 1
        end
    end
    return false
end
____exports["注册召唤监听"] = function(_____56DE_8C03)
    if type(_____56DE_8C03) ~= "function" then
        return
    end
    ____exports["初始化召唤事件中心"]()
    if not _____662F_5426_5DF2_6CE8_518C_76D1_542C(_____56DE_8C03) then
        _____76D1_542C_5217_8868[#_____76D1_542C_5217_8868 + 1] = _____56DE_8C03
    end
end
____exports["取消召唤监听"] = function(_____56DE_8C03)
    local index = __TS__ArrayIndexOf(_____76D1_542C_5217_8868, _____56DE_8C03)
    if index >= 0 then
        __TS__ArraySplice(_____76D1_542C_5217_8868, index, 1)
    end
end
return ____exports
