local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____901A_77E5_66B4_51FB_6700_7EC8_4F24_5BB3_76D1_542C, _____66B4_51FB_6700_7EC8_4F24_5BB3_6865_63A5, _____786E_4FDD_66B4_51FB_6700_7EC8_4F24_5BB3_6865_63A5, registerAppliedFinalDamageListener, _____66B4_51FB_6210_529F_8BB0_5F55_5217_8868, _____66B4_51FB_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868, _____5DF2_6CE8_518C_66B4_51FB_6700_7EC8_4F24_5BB3_6865_63A5
function _____901A_77E5_66B4_51FB_6700_7EC8_4F24_5BB3_76D1_542C(record, applied, snapshot)
    do
        local i = 0
        while i < #_____66B4_51FB_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868 do
            do
                local callback = _____66B4_51FB_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868[i + 1]
                if callback == nil then
                    goto __continue26
                end
                callback(record, applied, snapshot)
            end
            ::__continue26::
            i = i + 1
        end
    end
end
function _____66B4_51FB_6700_7EC8_4F24_5BB3_6865_63A5(target, attacker, applied, snapshot)
    do
        local i = 0
        while i < #_____66B4_51FB_6210_529F_8BB0_5F55_5217_8868 do
            do
                local record = _____66B4_51FB_6210_529F_8BB0_5F55_5217_8868[i + 1]
                if record == nil then
                    goto __continue30
                end
                if record.target ~= target or record.attacker ~= attacker then
                    goto __continue30
                end
                __TS__ArraySplice(_____66B4_51FB_6210_529F_8BB0_5F55_5217_8868, i, 1)
                _____901A_77E5_66B4_51FB_6700_7EC8_4F24_5BB3_76D1_542C(record, applied, snapshot)
                return
            end
            ::__continue30::
            i = i + 1
        end
    end
end
function _____786E_4FDD_66B4_51FB_6700_7EC8_4F24_5BB3_6865_63A5()
    if _____5DF2_6CE8_518C_66B4_51FB_6700_7EC8_4F24_5BB3_6865_63A5 then
        return
    end
    _____5DF2_6CE8_518C_66B4_51FB_6700_7EC8_4F24_5BB3_6865_63A5 = true
    registerAppliedFinalDamageListener(_____66B4_51FB_6700_7EC8_4F24_5BB3_6865_63A5)
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.01A．玩家英雄判定")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_1["是玩家英雄组单位"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统")
local _____66B4_51FB_6982_7387_901A_8FC7 = ____require_result_2["暴击概率通过"]
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_3.getRegisteredPlayerHero
local ____require_result_4 = require("系统.04．伤害系统.06．暴击系统.00．暴击配置")
local _____66B4_51FB_7CFB_7EDF_914D_7F6E = ____require_result_4["暴击系统配置"]
local ____require_result_5 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
registerAppliedFinalDamageListener = ____require_result_5.registerAppliedFinalDamageListener
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local function _____8C03_7528_73A9_5BB6_82F1_96C4_5224_5B9A(unit)
    return _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(unit) == true
end
local _____66B4_51FB_7387_4FEE_6B63_5668_5217_8868 = {}
_____66B4_51FB_6210_529F_8BB0_5F55_5217_8868 = {}
_____66B4_51FB_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868 = {}
_____5DF2_6CE8_518C_66B4_51FB_6700_7EC8_4F24_5BB3_6865_63A5 = false
local function _____8BFB_53D6_5355_4F4D_5B9E_6570(unit, _____5C5E_6027_540D)
    if unit == nil or unit == 0 then
        return 0
    end
    return __TS__Number(YDUserDataGetSafe("unit", unit, _____5C5E_6027_540D, "real")) or 0
end
local function _____8BFB_53D6_73A9_5BB6_5B9E_6570(player, _____5C5E_6027_540D)
    if player == nil or player == 0 then
        return 0
    end
    return __TS__Number(YDUserDataGetSafe("player", player, _____5C5E_6027_540D, "real")) or 0
end
local function _____9650_5236_4E0A_9650(value, max)
    if value > max then
        return max
    end
    return value
end
function ____exports.registerCritRateModifier(callback)
    if callback == nil then
        return
    end
    do
        local i = 0
        while i < #_____66B4_51FB_7387_4FEE_6B63_5668_5217_8868 do
            if _____66B4_51FB_7387_4FEE_6B63_5668_5217_8868[i + 1] == callback then
                return
            end
            i = i + 1
        end
    end
    _____66B4_51FB_7387_4FEE_6B63_5668_5217_8868[#_____66B4_51FB_7387_4FEE_6B63_5668_5217_8868 + 1] = callback
end
--- 装备特例只在这里修正“暴击率”，不直接改伤害。
-- 例如森魔连弩把特定远程普攻暴击率拉到 100%，精光中鞋把正向命中折算到暴击率。
local function _____5E94_7528_66B4_51FB_7387_4FEE_6B63(context)
    local rate = context["暴击率"]
    do
        local i = 0
        while i < #_____66B4_51FB_7387_4FEE_6B63_5668_5217_8868 do
            do
                local callback = _____66B4_51FB_7387_4FEE_6B63_5668_5217_8868[i + 1]
                if callback == nil then
                    goto __continue16
                end
                context["暴击率"] = rate
                local nextRate = callback(context)
                if type(nextRate) == "number" then
                    rate = nextRate
                end
            end
            ::__continue16::
            i = i + 1
        end
    end
    return rate
end
function ____exports.registerCritAppliedFinalDamageListener(callback)
    if callback == nil then
        return
    end
    _____786E_4FDD_66B4_51FB_6700_7EC8_4F24_5BB3_6865_63A5()
    do
        local i = 0
        while i < #_____66B4_51FB_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868 do
            if _____66B4_51FB_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868[i + 1] == callback then
                return
            end
            i = i + 1
        end
    end
    _____66B4_51FB_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868[#_____66B4_51FB_6700_7EC8_4F24_5BB3_76D1_542C_5217_8868 + 1] = callback
end
local function _____8BB0_5F55_66B4_51FB_6210_529F(record)
    _____786E_4FDD_66B4_51FB_6700_7EC8_4F24_5BB3_6865_63A5()
    _____66B4_51FB_6210_529F_8BB0_5F55_5217_8868[#_____66B4_51FB_6210_529F_8BB0_5F55_5217_8868 + 1] = record
end
local function _____83B7_53D6_66B4_51FB_5F52_5C5E_5355_4F4D(attacker, target)
    if attacker == nil or attacker == 0 then
        return attacker
    end
    if target ~= nil and target ~= 0 and attacker == target then
        return attacker
    end
    if IsUnitType(attacker, UNIT_TYPE_HERO) == true then
        return attacker
    end
    local owner = GetOwningPlayer(attacker)
    if owner == nil or owner == 0 then
        return attacker
    end
    local playerId = GetPlayerId(owner)
    if playerId < 0 or playerId > 4 then
        return attacker
    end
    local hero = getRegisteredPlayerHero(owner)
    local ____temp_6
    if hero ~= nil and hero ~= 0 then
        ____temp_6 = hero
    else
        ____temp_6 = attacker
    end
    return ____temp_6
end
local function _____8BFB_53D6_653B_51FB_8005_66B4_51FB_5C5E_6027(attacker)
    if _____8C03_7528_73A9_5BB6_82F1_96C4_5224_5B9A(attacker) then
        local owner = GetOwningPlayer(attacker)
        return {
            ["暴击率"] = _____8BFB_53D6_73A9_5BB6_5B9E_6570(owner, "暴击率"),
            ["暴击伤害"] = _____9650_5236_4E0A_9650(
                _____8BFB_53D6_73A9_5BB6_5B9E_6570(owner, "暴击伤害"),
                _____66B4_51FB_7CFB_7EDF_914D_7F6E["玩家暴击伤害上限"]
            )
        }
    end
    local _____5355_4F4D_66B4_51FB_7387 = _____8BFB_53D6_5355_4F4D_5B9E_6570(attacker, "暴击率")
    if _____5355_4F4D_66B4_51FB_7387 > 0.01 then
        return {
            ["暴击率"] = _____5355_4F4D_66B4_51FB_7387,
            ["暴击伤害"] = _____8BFB_53D6_5355_4F4D_5B9E_6570(attacker, "暴击伤害")
        }
    end
    local owner = GetOwningPlayer(attacker)
    return {
        ["暴击率"] = _____8BFB_53D6_73A9_5BB6_5B9E_6570(owner, "暴击率"),
        ["暴击伤害"] = _____9650_5236_4E0A_9650(
            _____8BFB_53D6_73A9_5BB6_5B9E_6570(owner, "暴击伤害"),
            _____66B4_51FB_7CFB_7EDF_914D_7F6E["玩家暴击伤害上限"]
        )
    }
end
local function _____8BFB_53D6_653B_51FB_8005_5FC5_5B9A_66B4_51FB(attacker)
    if _____8C03_7528_73A9_5BB6_82F1_96C4_5224_5B9A(attacker) then
        return _____8BFB_53D6_73A9_5BB6_5B9E_6570(
            GetOwningPlayer(attacker),
            "必定暴击"
        ) > 0
    end
    if _____8BFB_53D6_5355_4F4D_5B9E_6570(attacker, "必定暴击") > 0 then
        return true
    end
    return _____8BFB_53D6_73A9_5BB6_5B9E_6570(
        GetOwningPlayer(attacker),
        "必定暴击"
    ) > 0
end
local function _____8BFB_53D6_76EE_6807_88AB_66B4_51FB_7387(target)
    if _____8C03_7528_73A9_5BB6_82F1_96C4_5224_5B9A(target) then
        return _____8BFB_53D6_73A9_5BB6_5B9E_6570(
            GetOwningPlayer(target),
            "被暴击率"
        )
    end
    return _____8BFB_53D6_5355_4F4D_5B9E_6570(target, "被暴击率")
end
local function _____8BFB_53D6_76EE_6807_88AB_66B4_51FB_4F24_5BB3(attacker, target)
    if attacker == target then
        return 0
    end
    local _____5355_4F4D_51CF_514D = _____8BFB_53D6_5355_4F4D_5B9E_6570(target, "被暴击伤害")
    if _____5355_4F4D_51CF_514D ~= 0 then
        return _____5355_4F4D_51CF_514D
    end
    if _____8C03_7528_73A9_5BB6_82F1_96C4_5224_5B9A(target) then
        return _____9650_5236_4E0A_9650(
            _____8BFB_53D6_73A9_5BB6_5B9E_6570(
                GetOwningPlayer(target),
                "被暴击伤害"
            ),
            _____66B4_51FB_7CFB_7EDF_914D_7F6E["玩家被暴击伤害上限"]
        )
    end
    return 0
end
local function _____662F_5426_53EF_66B4_51FB_4F24_5BB3(context)
    local _____662F_5426_653B_51FB_4F24_5BB3 = context.isNormalAttack or context.isSkillAttack
    if not _____662F_5426_653B_51FB_4F24_5BB3 then
        return false
    end
    return context.isPhysicalDamage or context.isEnhancedDamage or context.isSkillAttack
end
____exports["执行暴击判定"] = function(context)
    local attacker = context.attacker
    local target = context.target
    local currentDamage = context.currentDamage
    if attacker == nil or attacker == 0 or target == nil or target == 0 then
        return {["伤害"] = currentDamage, ["暴击概率"] = 0, ["暴击倍率"] = 1, ["是否暴击"] = false}
    end
    if currentDamage < _____66B4_51FB_7CFB_7EDF_914D_7F6E["生效最低伤害"] or not _____662F_5426_53EF_66B4_51FB_4F24_5BB3(context) then
        return {["伤害"] = currentDamage, ["暴击概率"] = 0, ["暴击倍率"] = 1, ["是否暴击"] = false}
    end
    local _____66B4_51FB_5F52_5C5E_5355_4F4D = _____83B7_53D6_66B4_51FB_5F52_5C5E_5355_4F4D(attacker, target)
    local _____6765_6E90_5C5E_6027 = _____8BFB_53D6_653B_51FB_8005_66B4_51FB_5C5E_6027(_____66B4_51FB_5F52_5C5E_5355_4F4D)
    local _____662F_5426_5FC5_5B9A_66B4_51FB = _____8BFB_53D6_653B_51FB_8005_5FC5_5B9A_66B4_51FB(_____66B4_51FB_5F52_5C5E_5355_4F4D)
    local _____6709_6548_66B4_51FB_7387 = 1
    if not _____662F_5426_5FC5_5B9A_66B4_51FB then
        local _____4FEE_6B63_540E_66B4_51FB_7387 = _____5E94_7528_66B4_51FB_7387_4FEE_6B63({
            attacker = attacker,
            target = target,
            ["暴击归属单位"] = _____66B4_51FB_5F52_5C5E_5355_4F4D,
            currentDamage = currentDamage,
            ["暴击率"] = _____6765_6E90_5C5E_6027["暴击率"],
            isPhysicalDamage = context.isPhysicalDamage == true,
            isEnhancedDamage = context.isEnhancedDamage == true,
            isNormalAttack = context.isNormalAttack == true,
            isRangedAttack = context.isRangedAttack == true,
            isSkillAttack = context.isSkillAttack == true
        })
        if _____4FEE_6B63_540E_66B4_51FB_7387 <= 0.01 then
            return {["伤害"] = currentDamage, ["暴击概率"] = 0, ["暴击倍率"] = 1, ["是否暴击"] = false}
        end
        _____6709_6548_66B4_51FB_7387 = _____4FEE_6B63_540E_66B4_51FB_7387 - _____8BFB_53D6_76EE_6807_88AB_66B4_51FB_7387(target)
        if _____6709_6548_66B4_51FB_7387 <= 0 then
            return {["伤害"] = currentDamage, ["暴击概率"] = 0, ["暴击倍率"] = 1, ["是否暴击"] = false}
        end
        if _____6709_6548_66B4_51FB_7387 > 1 then
            _____6709_6548_66B4_51FB_7387 = 1
        end
        if not _____66B4_51FB_6982_7387_901A_8FC7(_____6709_6548_66B4_51FB_7387, _____66B4_51FB_5F52_5C5E_5355_4F4D) then
            return {["伤害"] = currentDamage, ["暴击概率"] = _____6709_6548_66B4_51FB_7387, ["暴击倍率"] = 1, ["是否暴击"] = false}
        end
    end
    local _____57FA_7840_500D_7387 = context.isSkillAttack and _____66B4_51FB_7CFB_7EDF_914D_7F6E["技能攻击基础倍率"] or _____66B4_51FB_7CFB_7EDF_914D_7F6E["普通攻击基础倍率"]
    local _____66B4_51FB_500D_7387 = _____57FA_7840_500D_7387 + _____6765_6E90_5C5E_6027["暴击伤害"] - _____8BFB_53D6_76EE_6807_88AB_66B4_51FB_4F24_5BB3(attacker, target)
    if _____66B4_51FB_500D_7387 < _____66B4_51FB_7CFB_7EDF_914D_7F6E["最低输出倍率"] then
        _____66B4_51FB_500D_7387 = _____66B4_51FB_7CFB_7EDF_914D_7F6E["最低输出倍率"]
    end
    local _____66B4_51FB_540E_4F24_5BB3 = currentDamage * _____66B4_51FB_500D_7387
    _____8BB0_5F55_66B4_51FB_6210_529F({
        attacker = attacker,
        target = target,
        ["暴击归属单位"] = _____66B4_51FB_5F52_5C5E_5355_4F4D,
        ["暴击前伤害"] = currentDamage,
        ["暴击后伤害"] = _____66B4_51FB_540E_4F24_5BB3,
        ["暴击概率"] = _____6709_6548_66B4_51FB_7387,
        ["暴击倍率"] = _____66B4_51FB_500D_7387,
        isNormalAttack = context.isNormalAttack == true,
        isRangedAttack = context.isRangedAttack == true,
        isSkillAttack = context.isSkillAttack == true
    })
    return {["伤害"] = _____66B4_51FB_540E_4F24_5BB3, ["暴击概率"] = _____6709_6548_66B4_51FB_7387, ["暴击倍率"] = _____66B4_51FB_500D_7387, ["是否暴击"] = true}
end
return ____exports
