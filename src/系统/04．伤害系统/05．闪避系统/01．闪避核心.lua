local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____901A_77E5_95EA_907F_6700_7EC8_4F24_5BB3_76D1_542C, _____95EA_907F_6700_7EC8_4F24_5BB3_6865_63A5, _____786E_4FDD_95EA_907F_6700_7EC8_4F24_5BB3_6865_63A5, registerAppliedFinalDamageListener, _____95EA_907F_6210_529F_8BB0_5F55_5217_8868, _____95EA_907F_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868, _____5DF2_6CE8_518C_95EA_907F_6700_7EC8_4F24_5BB3_6865_63A5
function _____901A_77E5_95EA_907F_6700_7EC8_4F24_5BB3_76D1_542C(record, applied, snapshot)
    do
        local i = 0
        while i < #_____95EA_907F_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868 do
            do
                local callback = _____95EA_907F_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868[i + 1]
                if callback == nil then
                    goto __continue15
                end
                callback(record, applied, snapshot)
            end
            ::__continue15::
            i = i + 1
        end
    end
end
function _____95EA_907F_6700_7EC8_4F24_5BB3_6865_63A5(target, attacker, applied, snapshot)
    do
        local i = 0
        while i < #_____95EA_907F_6210_529F_8BB0_5F55_5217_8868 do
            do
                local record = _____95EA_907F_6210_529F_8BB0_5F55_5217_8868[i + 1]
                if record == nil then
                    goto __continue19
                end
                if record.target ~= target or record.attacker ~= attacker then
                    goto __continue19
                end
                __TS__ArraySplice(_____95EA_907F_6210_529F_8BB0_5F55_5217_8868, i, 1)
                _____901A_77E5_95EA_907F_6700_7EC8_4F24_5BB3_76D1_542C(record, applied, snapshot)
                return
            end
            ::__continue19::
            i = i + 1
        end
    end
end
function _____786E_4FDD_95EA_907F_6700_7EC8_4F24_5BB3_6865_63A5()
    if _____5DF2_6CE8_518C_95EA_907F_6700_7EC8_4F24_5BB3_6865_63A5 then
        return
    end
    _____5DF2_6CE8_518C_95EA_907F_6700_7EC8_4F24_5BB3_6865_63A5 = true
    registerAppliedFinalDamageListener(_____95EA_907F_6700_7EC8_4F24_5BB3_6865_63A5)
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统")
local _____95EA_907F_6982_7387_901A_8FC7 = ____require_result_1["闪避概率通过"]
local ____require_result_2 = require("系统.04．伤害系统.04．命中系统.01．命中核心")
local _____8BFB_53D6_6B63_5411_547D_4E2D_7387_504F_79FB = ____require_result_2["读取正向命中率偏移"]
local ____require_result_3 = require("系统.04．伤害系统.05．闪避系统.00．闪避配置")
local _____95EA_907F_7CFB_7EDF_914D_7F6E = ____require_result_3["闪避系统配置"]
local ____require_result_4 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
registerAppliedFinalDamageListener = ____require_result_4.registerAppliedFinalDamageListener
local GetOwningPlayer = jass.GetOwningPlayer
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local function _____8C03_7528_73A9_5BB6_82F1_96C4_5224_5B9A(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    local hero = YDUserDataGetSafe("player", owner, "英雄", "unit")
    if hero == nil or hero == 0 then
        return false
    end
    return hero == unit or GetHandleId(hero) == GetHandleId(unit)
end
_____95EA_907F_6210_529F_8BB0_5F55_5217_8868 = {}
_____95EA_907F_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868 = {}
_____5DF2_6CE8_518C_95EA_907F_6700_7EC8_4F24_5BB3_6865_63A5 = false
local function _____8BFB_53D6_5355_4F4D_5B9E_6570(unit, _____5C5E_6027_540D)
    if unit == nil or unit == 0 then
        return 0
    end
    return __TS__Number(YDUserDataGetSafe("unit", unit, _____5C5E_6027_540D, "real")) or 0
end
function ____exports.registerDodgeAppliedFinalDamageListener(callback)
    if callback == nil then
        return
    end
    _____786E_4FDD_95EA_907F_6700_7EC8_4F24_5BB3_6865_63A5()
    do
        local i = 0
        while i < #_____95EA_907F_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868 do
            if _____95EA_907F_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868[i + 1] == callback then
                return
            end
            i = i + 1
        end
    end
    _____95EA_907F_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868[#_____95EA_907F_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868 + 1] = callback
end
local function _____8BB0_5F55_95EA_907F_6210_529F(record)
    _____786E_4FDD_95EA_907F_6700_7EC8_4F24_5BB3_6865_63A5()
    _____95EA_907F_6210_529F_8BB0_5F55_5217_8868[#_____95EA_907F_6210_529F_8BB0_5F55_5217_8868 + 1] = record
end
local function _____8BFB_53D6_73A9_5BB6_5B9E_6570(player, _____5C5E_6027_540D)
    if player == nil or player == 0 then
        return 0
    end
    return __TS__Number(YDUserDataGetSafe("player", player, _____5C5E_6027_540D, "real")) or 0
end
local function _____8BFB_53D6_5355_4F4D_5E03_5C14(unit, _____5C5E_6027_540D)
    if unit == nil or unit == 0 then
        return false
    end
    local value = YDUserDataGetSafe("unit", unit, _____5C5E_6027_540D, "boolean")
    return value == true or value == 1
end
local function _____8BFB_53D6_5355_4F4D_5B57_7B26_4E32_5F00_5173(unit, _____5C5E_6027_540D)
    if unit == nil or unit == 0 then
        return false
    end
    local value = YDUserDataGetSafe("unit", unit, _____5C5E_6027_540D, "string")
    if value == nil then
        return false
    end
    if value == true or value == 1 then
        return true
    end
    local text = string.lower(tostring(value))
    return text == "true" or text == "1"
end
local function _____8BFB_53D6_76EE_6807_57FA_7840_95EA_907F_7387(target)
    local _____5355_4F4D_95EA_907F = _____8BFB_53D6_5355_4F4D_5B9E_6570(target, "闪避率")
    if _____5355_4F4D_95EA_907F > 0.01 then
        return _____5355_4F4D_95EA_907F
    end
    local _____73A9_5BB6_95EA_907F = _____8BFB_53D6_73A9_5BB6_5B9E_6570(
        GetOwningPlayer(target),
        "闪避率"
    )
    if _____73A9_5BB6_95EA_907F <= 0.01 then
        return 0
    end
    if _____73A9_5BB6_95EA_907F > _____95EA_907F_7CFB_7EDF_914D_7F6E["玩家闪避率上限"] then
        _____73A9_5BB6_95EA_907F = _____95EA_907F_7CFB_7EDF_914D_7F6E["玩家闪避率上限"]
    end
    return _____73A9_5BB6_95EA_907F
end
____exports["执行闪避判定"] = function(context)
    local attacker = context.attacker
    local target = context.target
    local currentDamage = context.currentDamage
    if attacker == nil or attacker == 0 or target == nil or target == 0 then
        return {["结束链路"] = false, ["伤害"] = currentDamage, ["闪避概率"] = 0}
    end
    if currentDamage < _____95EA_907F_7CFB_7EDF_914D_7F6E["生效最低伤害"] then
        return {["结束链路"] = false, ["伤害"] = currentDamage, ["闪避概率"] = 0}
    end
    local _____6700_5927_751F_547D = GetUnitState(target, UNIT_STATE_MAX_LIFE)
    if _____6700_5927_751F_547D > 0 and currentDamage >= _____6700_5927_751F_547D * _____95EA_907F_7CFB_7EDF_914D_7F6E["最大生命伤害比例门槛"] then
        return {["结束链路"] = false, ["伤害"] = currentDamage, ["闪避概率"] = 0}
    end
    if context.isNormalAttack and context.isPhysicalDamage and _____8BFB_53D6_5355_4F4D_5E03_5C14(target, "普攻必中") then
        return {["结束链路"] = false, ["伤害"] = currentDamage, ["闪避概率"] = 0}
    end
    if _____8BFB_53D6_5355_4F4D_5B57_7B26_4E32_5F00_5173(attacker, "无视闪避") then
        return {["结束链路"] = false, ["伤害"] = currentDamage, ["闪避概率"] = 0}
    end
    local _____57FA_7840_95EA_907F_7387 = _____8BFB_53D6_76EE_6807_57FA_7840_95EA_907F_7387(target)
    if _____57FA_7840_95EA_907F_7387 <= 0.01 then
        return {["结束链路"] = false, ["伤害"] = currentDamage, ["闪避概率"] = 0}
    end
    local _____6709_6548_95EA_907F_7387 = _____57FA_7840_95EA_907F_7387 - _____8BFB_53D6_6B63_5411_547D_4E2D_7387_504F_79FB(attacker)
    if _____6709_6548_95EA_907F_7387 <= 0 then
        return {["结束链路"] = false, ["伤害"] = currentDamage, ["闪避概率"] = 0}
    end
    if _____6709_6548_95EA_907F_7387 > 1 then
        _____6709_6548_95EA_907F_7387 = 1
    end
    if not _____95EA_907F_6982_7387_901A_8FC7(_____6709_6548_95EA_907F_7387, target) then
        return {["结束链路"] = false, ["伤害"] = currentDamage, ["闪避概率"] = _____6709_6548_95EA_907F_7387}
    end
    local _____95EA_907F_540E_4F24_5BB3 = currentDamage * _____95EA_907F_7CFB_7EDF_914D_7F6E["敌人闪避后承伤比例"]
    if _____8C03_7528_73A9_5BB6_82F1_96C4_5224_5B9A(target) then
        _____95EA_907F_540E_4F24_5BB3 = 0
    end
    _____8BB0_5F55_95EA_907F_6210_529F({
        attacker = attacker,
        target = target,
        ["闪避前伤害"] = currentDamage,
        ["闪避后伤害"] = _____95EA_907F_540E_4F24_5BB3,
        ["闪避概率"] = _____6709_6548_95EA_907F_7387,
        isPhysicalDamage = context.isPhysicalDamage == true,
        isNormalAttack = context.isNormalAttack == true
    })
    return {["结束链路"] = true, ["伤害"] = _____95EA_907F_540E_4F24_5BB3, ["闪避概率"] = _____6709_6548_95EA_907F_7387}
end
return ____exports
