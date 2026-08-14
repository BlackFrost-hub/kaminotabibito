--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8BBE_7F6E_751F_547D_767E_5206_6BD4, _____8BBE_7F6E_9B54_6CD5_767E_5206_6BD4, _____82F1_96C4_8131_6218_5B8C_6210, ____Boss_8131_6218_5B8C_6210, jass, GetUnitStateJapi, g, GetPlayersAll, QuestMessageBJ, getRegisteredPlayerHero, _____8131_6218_79FB_901F_6280_80FDID
function _____8BBE_7F6E_751F_547D_767E_5206_6BD4(unit, pct)
    local maxLife = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE)
    jass.SetUnitState(unit, jass.UNIT_STATE_LIFE, maxLife * (pct > 0 and pct or 0) * 0.01)
end
function _____8BBE_7F6E_9B54_6CD5_767E_5206_6BD4(unit, pct)
    local maxMana = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_MANA)
    jass.SetUnitState(unit, jass.UNIT_STATE_MANA, maxMana * (pct > 0 and pct or 0) * 0.01)
end
function _____82F1_96C4_8131_6218_5B8C_6210(_____73A9_5BB6_7F16_53F7)
    local owner = jass.Player(_____73A9_5BB6_7F16_53F7)
    if owner == nil or owner == 0 then
        return
    end
    local unit = getRegisteredPlayerHero(owner)
    if unit == nil or unit == 0 then
        return
    end
    jass.DisplayTimedTextToPlayer(
        owner,
        0,
        0,
        30,
        "|cffffff00『系统提示』：|r『进入脱战状态』！生命和魔法已恢复。"
    )
    jass.UnitAddAbility(unit, _____8131_6218_79FB_901F_6280_80FDID)
    _____8BBE_7F6E_751F_547D_767E_5206_6BD4(unit, 100)
    _____8BBE_7F6E_9B54_6CD5_767E_5206_6BD4(unit, 100)
    jass.SetUnitPathing(unit, true)
end
function ____Boss_8131_6218_5B8C_6210()
    local boss = g.udg_Boss
    if boss == nil or boss == 0 then
        return
    end
    if jass.IsUnitType(boss, jass.UNIT_TYPE_DEAD) then
        return
    end
    _____8BBE_7F6E_751F_547D_767E_5206_6BD4(boss, 100)
    _____8BBE_7F6E_9B54_6CD5_767E_5206_6BD4(boss, 100)
    local bossName = jass.GetUnitName(boss)
    QuestMessageBJ(
        GetPlayersAll(),
        jass.bj_QUESTMESSAGE_WARNING,
        ("|cffffff00『系统消息』|r：|cffff0000Boss|r|cffff6600『" .. tostring(bossName)) .. "』|r由于太久没受到玩家伤害脱战回血了。"
    )
end
jass = require("jass.common")
local japi = require("jass.japi")
GetUnitStateJapi = japi.GetUnitState
g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.07．杂项")
GetPlayersAll = ____require_result_0.GetPlayersAll
local ____require_result_1 = require("lib.扩展函数.BJ函数.06．任务消息")
QuestMessageBJ = ____require_result_1.QuestMessageBJ
local function _____62E5_6709Buff(unit, buffId)
    if unit == nil or unit == 0 then
        return false
    end
    return jass.GetUnitAbilityLevel(unit, buffId) > 0
end
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_2.registerAppliedFinalDamageListener
local function _____6CE8_518C_6700_7EC8_4F24_5BB3_56DE_8C03(cb)
    registerAppliedFinalDamageListener(cb)
end
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
getRegisteredPlayerHero = ____require_result_3.getRegisteredPlayerHero
local ____require_result_4 = require("系统.00．核心系统.03．脱战系统.00．脱战规则")
local _____8131_6218_5F00_5173 = ____require_result_4["脱战开关"]
local _____73A9_5BB6_82F1_96C4_8131_6218_65F6_95F4_79D2 = ____require_result_4["玩家英雄脱战时间秒"]
local ____Boss_8131_6218_65F6_95F4_79D2 = ____require_result_4["Boss脱战时间秒"]
_____8131_6218_79FB_901F_6280_80FDID = ____require_result_4["脱战移速技能ID"]
local _____8131_6218BuffID = ____require_result_4["脱战BuffID"]
local _____8131_6218_4F24_5BB3_9608_503C_6BD4_4F8B = ____require_result_4["脱战伤害阈值比例"]
local centerTimer = _G
local _____82F1_96C4_8131_6218_8BA1_65F6_5668ID = {
    0,
    0,
    0,
    0,
    0
}
local ____Boss_8131_6218_8BA1_65F6_5668ID = 0
local function _____662F_73A9_5BB6_82F1_96C4(unit)
    if unit == nil then
        return false
    end
    return getRegisteredPlayerHero(jass.GetOwningPlayer(unit)) == unit
end
local function _____53D6_73A9_5BB6_7F16_53F7(unit)
    if unit == nil then
        return -1
    end
    local owner = jass.GetOwningPlayer(unit)
    if owner == nil then
        return -1
    end
    return jass.GetPlayerId(owner)
end
local function _____542F_52A8_82F1_96C4_8131_6218_8BA1_65F6(_____73A9_5BB6_7F16_53F7)
    if _____73A9_5BB6_7F16_53F7 < 0 or _____73A9_5BB6_7F16_53F7 > 3 then
        return
    end
    local _____7D22_5F15 = _____73A9_5BB6_7F16_53F7 + 1
    local _____65E7_4EFB_52A1ID = _____82F1_96C4_8131_6218_8BA1_65F6_5668ID[_____7D22_5F15 + 1]
    if _____65E7_4EFB_52A1ID ~= 0 then
        centerTimer.removeDelayedCallback(_____65E7_4EFB_52A1ID)
    end
    _____82F1_96C4_8131_6218_8BA1_65F6_5668ID[_____7D22_5F15 + 1] = centerTimer.addDelayedCallback(
        _____73A9_5BB6_82F1_96C4_8131_6218_65F6_95F4_79D2 * 1000,
        function()
            if _____82F1_96C4_8131_6218_8BA1_65F6_5668ID[_____7D22_5F15 + 1] == 0 then
                return
            end
            _____82F1_96C4_8131_6218_8BA1_65F6_5668ID[_____7D22_5F15 + 1] = 0
            _____82F1_96C4_8131_6218_5B8C_6210(_____73A9_5BB6_7F16_53F7)
        end
    )
end
local function _____542F_52A8Boss_8131_6218_8BA1_65F6()
    if ____Boss_8131_6218_8BA1_65F6_5668ID ~= 0 then
        centerTimer.removeDelayedCallback(____Boss_8131_6218_8BA1_65F6_5668ID)
    end
    ____Boss_8131_6218_8BA1_65F6_5668ID = centerTimer.addDelayedCallback(
        ____Boss_8131_6218_65F6_95F4_79D2 * 1000,
        function()
            if ____Boss_8131_6218_8BA1_65F6_5668ID == 0 then
                return
            end
            ____Boss_8131_6218_8BA1_65F6_5668ID = 0
            ____Boss_8131_6218_5B8C_6210()
        end
    )
end
local function _____68C0_67E5_79FB_9664_8131_6218Buff(unit, damage)
    if not _____62E5_6709Buff(unit, _____8131_6218BuffID) then
        return
    end
    local _____6700_5927_751F_547D = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE)
    local _____9608_503C = _____6700_5927_751F_547D * _____8131_6218_4F24_5BB3_9608_503C_6BD4_4F8B
    if damage >= _____9608_503C then
        jass.UnitRemoveAbility(unit, _____8131_6218_79FB_901F_6280_80FDID)
        jass.UnitRemoveAbility(unit, _____8131_6218BuffID)
        local owner = jass.GetOwningPlayer(unit)
        jass.DisplayTimedTextToPlayer(
            owner,
            0,
            0,
            30,
            "|cffff0000『进入战斗状态』|r"
        )
    end
end
local function _____5355_4F4D_53D7_4F24_4E8B_4EF6(unit, _attacker, damage, _snapshot)
    if jass.IsUnitIllusion(unit) then
        return
    end
    if damage < 1 then
        return
    end
    local boss = g.udg_Boss
    if unit == boss then
        _____542F_52A8Boss_8131_6218_8BA1_65F6()
        return
    end
    if not _____662F_73A9_5BB6_82F1_96C4(unit) then
        return
    end
    _____68C0_67E5_79FB_9664_8131_6218Buff(unit, damage)
    local _____73A9_5BB6_7F16_53F7 = _____53D6_73A9_5BB6_7F16_53F7(unit)
    _____542F_52A8_82F1_96C4_8131_6218_8BA1_65F6(_____73A9_5BB6_7F16_53F7)
end
local _____5DF2_521D_59CB_5316 = false
____exports["初始化脱战系统"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    if not _____8131_6218_5F00_5173 then
        return
    end
    _____6CE8_518C_6700_7EC8_4F24_5BB3_56DE_8C03(_____5355_4F4D_53D7_4F24_4E8B_4EF6)
end
return ____exports
