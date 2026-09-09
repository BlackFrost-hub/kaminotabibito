--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8BBE_7F6E_751F_547D_767E_5206_6BD4, _____8BBE_7F6E_9B54_6CD5_767E_5206_6BD4, ____Boss_4ECD_6709_6548, _____82F1_96C4_8131_6218_5B8C_6210, _____542F_52A8Boss_8131_6218_8BA1_65F6, ____onBoss_8131_6218_8BA1_65F6_5B8C_6210, jass, SetUnitState, GetUnitTypeId, IsUnitType, GetUnitName, R2SW, GetUnitStateJapi, g, GetPlayersAll, QuestMessageBJ, getRegisteredPlayerHero, ____Boss_8131_6218_65F6_95F4_79D2, _____8131_6218_79FB_901F_6280_80FDID, centerTimer, ____Boss_8131_6218_8BA1_65F6_5668ID, ____Boss_8131_6218_8BA1_65F6_6682_505C_6DF1_5EA6, _____5F53_524D_8BA1_65F6Boss
local ____01_FF0EBoss_9636_6BB5_72B6_6001 = require("系统.00．核心系统.03．脱战系统.01．Boss阶段状态")
local _____8BFB_53D6Boss_5F53_524D_9636_6BB5_9608_503C = ____01_FF0EBoss_9636_6BB5_72B6_6001["读取Boss当前阶段阈值"]
local ____02_FF0EBoss_8131_6218_56DE_8840_89C4_5219 = require("系统.00．核心系统.03．脱战系统.02．Boss脱战回血规则")
local _____8BA1_7B97Boss_8131_6218_76EE_6807_751F_547D_6BD4_4F8B = ____02_FF0EBoss_8131_6218_56DE_8840_89C4_5219["计算Boss脱战目标生命比例"]
function _____8BBE_7F6E_751F_547D_767E_5206_6BD4(unit, pct)
    local maxLife = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE)
    SetUnitState(unit, jass.UNIT_STATE_LIFE, maxLife * (pct > 0 and pct or 0) * 0.01)
end
function _____8BBE_7F6E_9B54_6CD5_767E_5206_6BD4(unit, pct)
    local maxMana = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_MANA)
    SetUnitState(unit, jass.UNIT_STATE_MANA, maxMana * (pct > 0 and pct or 0) * 0.01)
end
function ____Boss_4ECD_6709_6548(boss)
    return boss ~= nil and boss ~= 0 and GetUnitTypeId(boss) ~= 0 and not IsUnitType(boss, jass.UNIT_TYPE_DEAD)
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
function _____542F_52A8Boss_8131_6218_8BA1_65F6()
    local boss = g.udg_Boss
    if not ____Boss_4ECD_6709_6548(boss) then
        return
    end
    if _____5F53_524D_8BA1_65F6Boss ~= boss then
        _____5F53_524D_8BA1_65F6Boss = boss
        ____Boss_8131_6218_8BA1_65F6_6682_505C_6DF1_5EA6 = 0
    end
    if ____Boss_8131_6218_8BA1_65F6_6682_505C_6DF1_5EA6 > 0 then
        return
    end
    if ____Boss_8131_6218_8BA1_65F6_5668ID ~= 0 then
        centerTimer.removeDelayedCallback(____Boss_8131_6218_8BA1_65F6_5668ID)
    end
    ____Boss_8131_6218_8BA1_65F6_5668ID = centerTimer.addDelayedCallback(____Boss_8131_6218_65F6_95F4_79D2 * 1000, ____onBoss_8131_6218_8BA1_65F6_5B8C_6210, boss)
end
function ____onBoss_8131_6218_8BA1_65F6_5B8C_6210(variable)
    local boss = variable
    if ____Boss_8131_6218_8BA1_65F6_5668ID == 0 or _____5F53_524D_8BA1_65F6Boss ~= boss then
        return
    end
    ____Boss_8131_6218_8BA1_65F6_5668ID = 0
    if boss ~= g.udg_Boss or not ____Boss_4ECD_6709_6548(boss) or ____Boss_8131_6218_8BA1_65F6_6682_505C_6DF1_5EA6 > 0 then
        return
    end
    local _____6700_5927_751F_547D = GetUnitStateJapi(boss, jass.UNIT_STATE_MAX_LIFE)
    if not (_____6700_5927_751F_547D > 0) then
        return
    end
    local _____5F53_524D_751F_547D = GetUnitStateJapi(boss, jass.UNIT_STATE_LIFE)
    local _____5F53_524D_6BD4_4F8B = _____5F53_524D_751F_547D / _____6700_5927_751F_547D
    local _____9636_6BB5_9608_503C = _____8BFB_53D6Boss_5F53_524D_9636_6BB5_9608_503C(boss)
    local _____76EE_6807_6BD4_4F8B = _____8BA1_7B97Boss_8131_6218_76EE_6807_751F_547D_6BD4_4F8B(_____5F53_524D_6BD4_4F8B, _____9636_6BB5_9608_503C)
    if _____76EE_6807_6BD4_4F8B > _____5F53_524D_6BD4_4F8B then
        SetUnitState(boss, jass.UNIT_STATE_LIFE, _____6700_5927_751F_547D * _____76EE_6807_6BD4_4F8B)
    end
    _____8BBE_7F6E_9B54_6CD5_767E_5206_6BD4(boss, 100)
    _____542F_52A8Boss_8131_6218_8BA1_65F6()
    if _____76EE_6807_6BD4_4F8B <= _____5F53_524D_6BD4_4F8B then
        return
    end
    QuestMessageBJ(
        GetPlayersAll(),
        jass.bj_QUESTMESSAGE_WARNING,
        ((((((((((((("|cffffff00『脱战恢复』|r |cffff6600" .. GetUnitName(boss)) .. "|r\n") .. "|cffcccccc生命：|r |cff66ccff") .. R2SW(_____5F53_524D_6BD4_4F8B * 100, 1, 2)) .. "%|r") .. " |cffcccccc→|r |cff99ff99") .. R2SW(_____76EE_6807_6BD4_4F8B * 100, 1, 2)) .. "%|r") .. " |cff99ff99（+") .. R2SW((_____76EE_6807_6BD4_4F8B - _____5F53_524D_6BD4_4F8B) * 100, 1, 2)) .. "%）|r\n") .. "|cffcccccc若持续未受伤，|r|cffffff00") .. tostring(____Boss_8131_6218_65F6_95F4_79D2)) .. "秒|r|cffcccccc后再次恢复。|r"
    )
end
jass = require("jass.common")
local japi = require("jass.japi")
SetUnitState = jass.SetUnitState
GetUnitTypeId = jass.GetUnitTypeId
IsUnitType = jass.IsUnitType
GetUnitName = jass.GetUnitName
R2SW = jass.R2SW
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
____Boss_8131_6218_65F6_95F4_79D2 = ____require_result_4["Boss脱战时间秒"]
_____8131_6218_79FB_901F_6280_80FDID = ____require_result_4["脱战移速技能ID"]
local _____8131_6218BuffID = ____require_result_4["脱战BuffID"]
local _____8131_6218_4F24_5BB3_9608_503C_6BD4_4F8B = ____require_result_4["脱战伤害阈值比例"]
centerTimer = _G
local _____82F1_96C4_8131_6218_8BA1_65F6_5668ID = {
    0,
    0,
    0,
    0,
    0
}
____Boss_8131_6218_8BA1_65F6_5668ID = 0
____Boss_8131_6218_8BA1_65F6_6682_505C_6DF1_5EA6 = 0
_____5F53_524D_8BA1_65F6Boss = nil
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
--- 长时间 Boss 机制期间暂停脱战回血计时；支持嵌套调用。
____exports["暂停Boss脱战计时"] = function()
    if not ____Boss_4ECD_6709_6548(g.udg_Boss) then
        return
    end
    if _____5F53_524D_8BA1_65F6Boss ~= g.udg_Boss then
        _____5F53_524D_8BA1_65F6Boss = g.udg_Boss
        ____Boss_8131_6218_8BA1_65F6_6682_505C_6DF1_5EA6 = 0
    end
    ____Boss_8131_6218_8BA1_65F6_6682_505C_6DF1_5EA6 = ____Boss_8131_6218_8BA1_65F6_6682_505C_6DF1_5EA6 + 1
    if ____Boss_8131_6218_8BA1_65F6_5668ID ~= 0 then
        centerTimer.removeDelayedCallback(____Boss_8131_6218_8BA1_65F6_5668ID)
        ____Boss_8131_6218_8BA1_65F6_5668ID = 0
    end
end
--- Boss 机制完成或 Boss 死亡后恢复脱战计时。恢复从 0 秒重新计时。
____exports["恢复Boss脱战计时"] = function()
    if ____Boss_8131_6218_8BA1_65F6_6682_505C_6DF1_5EA6 <= 0 then
        return
    end
    ____Boss_8131_6218_8BA1_65F6_6682_505C_6DF1_5EA6 = ____Boss_8131_6218_8BA1_65F6_6682_505C_6DF1_5EA6 - 1
    if ____Boss_8131_6218_8BA1_65F6_6682_505C_6DF1_5EA6 == 0 then
        _____542F_52A8Boss_8131_6218_8BA1_65F6()
    end
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
