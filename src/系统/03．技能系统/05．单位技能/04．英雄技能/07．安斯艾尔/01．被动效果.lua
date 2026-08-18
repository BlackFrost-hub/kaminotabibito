local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.07．安斯艾尔.00．配置")
local _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["安斯艾尔单位技能配置"]
local ____16_FF0E_5B89_65AF_827E_5C14 = require("系统.05．Buff系统.03．Buff表.02．英雄.16．安斯艾尔")
local _____5B89_65AF_827E_5C14BuffID = ____16_FF0E_5B89_65AF_827E_5C14["安斯艾尔BuffID"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.02．计时器")
local createDelayedCall = ____require_result_0.createDelayedCall
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedUnitEffect = ____require_result_1.createTimedUnitEffect
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_2["调整玩家属性"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_3["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_3["单位存活"]
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_4["造成单体技能伤害"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.08．扩散伤害.扩散伤害")
local _____6269_6563_4F24_5BB3 = ____require_result_5["扩散伤害"]
local ____require_result_6 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_6.registerAppliedFinalDamageListener
local _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C = ____require_result_6["延后一帧执行伤害派生效果"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local ____require_result_8 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_8.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_8["移除单位指定Buff"]
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetWidgetLife = jass.GetWidgetLife
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetRandomInt = jass.GetRandomInt
local GetUnitStateJapi = japi.GetUnitState
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE
local DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local _____5B89_65AF_827E_5C14_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____88AB_52A8_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E["被动技能ID"])
local ____Q_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E["Q技能ID"])
local ____E_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E["E技能ID"])
local _____5723_5149_9644_9B54_7F13_5B58 = {}
local function _____662F_5B89_65AF_827E_5C14(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) == _____5B89_65AF_827E_5C14_5355_4F4D_7C7B_578BID
end
local function _____6E05_9664_5723_5149_9644_9B54(id, record)
    if _____5723_5149_9644_9B54_7F13_5B58[id] ~= record then
        return
    end
    if record["吸血已添加"] then
        _____8C03_6574_73A9_5BB6_5C5E_6027(record["单位"], "普攻伤害吸血", -_____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.Q["普攻吸血增加"])
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(record["单位"], _____5B89_65AF_827E_5C14BuffID["圣光附魔"])
    __TS__Delete(_____5723_5149_9644_9B54_7F13_5B58, id)
end
____exports["激活安斯艾尔圣光附魔"] = function(unit)
    if not _____662F_5B89_65AF_827E_5C14(unit) then
        return
    end
    local id = GetHandleId(unit)
    local record = _____5723_5149_9644_9B54_7F13_5B58[id]
    if record == nil or record["单位"] ~= unit then
        record = {["单位"] = unit, ["代数"] = 0, ["剩余次数"] = 0, ["吸血已添加"] = false}
        _____5723_5149_9644_9B54_7F13_5B58[id] = record
    end
    record["代数"] = record["代数"] + 1
    record["剩余次数"] = _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.Q["附魔次数"]
    if not record["吸血已添加"] then
        record["吸血已添加"] = true
        _____8C03_6574_73A9_5BB6_5C5E_6027(unit, "普攻伤害吸血", _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.Q["普攻吸血增加"])
    end
    registerManualBuff(
        unit,
        _____5B89_65AF_827E_5C14BuffID["圣光附魔"],
        _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.Q["持续秒"],
        0,
        {sourceUnit = unit, sourceName = "圣光附魔"}
    )
    local generation = record["代数"]
    local function ____on_5723_5149_9644_9B54_5230_671F()
        local current = _____5723_5149_9644_9B54_7F13_5B58[id]
        if current == nil or current ~= record or current["代数"] ~= generation then
            return
        end
        _____6E05_9664_5723_5149_9644_9B54(id, current)
    end
    createDelayedCall(_____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.Q["持续秒"], ____on_5723_5149_9644_9B54_5230_671F)
end
local function _____521B_5EFA_5B89_65AF_827E_5C14_8FFD_52A0_4F24_5BB3(source, target, damage, damageType, abilityId, tag, effectPath)
    local function ____on_6267_884C_8FFD_52A0_4F24_5BB3()
        if not _____5355_4F4D_5B58_6D3B(source) or not _____5355_4F4D_5B58_6D3B(target) then
            return
        end
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = source,
            ["目标"] = target,
            ["伤害"] = damage,
            ["伤害类型"] = damageType,
            ["来源类型"] = "单位技能",
            ["技能ID"] = abilityId,
            ["参与技能伤害加成"] = true,
            ["标签"] = tag
        })
        createTimedUnitEffect(target, _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.Q["特效挂点"], effectPath, _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.Q["特效持续秒"])
    end
    _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C(____on_6267_884C_8FFD_52A0_4F24_5BB3)
end
local function _____5C1D_8BD5_89E6_53D1_4E00_9A91_5F53_5148(attacker, target)
    local maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) or GetWidgetLife(target) + 0.01 < maxLife then
        return
    end
    local cfg = _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E["被动"]
    local damage = maxLife * cfg["目标最大生命比例"] + _____8BFB_53D6_5355_4F4D_653B_51FB_529B(attacker) * cfg["攻击力倍率"]
    _____521B_5EFA_5B89_65AF_827E_5C14_8FFD_52A0_4F24_5BB3(
        attacker,
        target,
        damage,
        DAMAGE_TYPE_DIVINE,
        _____88AB_52A8_6280_80FD_7C7B_578BID,
        "安斯艾尔-一骑当先",
        cfg["伤害特效"]
    )
end
local function _____5C1D_8BD5_6D88_8017_5723_5149_9644_9B54(attacker, target)
    local id = GetHandleId(attacker)
    local record = _____5723_5149_9644_9B54_7F13_5B58[id]
    if record == nil or record["单位"] ~= attacker or record["剩余次数"] <= 0 then
        return
    end
    record["剩余次数"] = record["剩余次数"] - 1
    local level = GetUnitAbilityLevel(attacker, ____Q_6280_80FD_7C7B_578BID)
    local cfg = _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.Q
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(attacker) * (cfg["基础攻击力倍率"] + cfg["每级攻击力倍率"] * level)
    local element = GetRandomInt(1, 3)
    if element == 1 then
        _____521B_5EFA_5B89_65AF_827E_5C14_8FFD_52A0_4F24_5BB3(
            attacker,
            target,
            damage,
            DAMAGE_TYPE_DIVINE,
            ____Q_6280_80FD_7C7B_578BID,
            "安斯艾尔-圣光附魔-光",
            cfg["光属性特效"]
        )
    elseif element == 2 then
        _____521B_5EFA_5B89_65AF_827E_5C14_8FFD_52A0_4F24_5BB3(
            attacker,
            target,
            damage,
            DAMAGE_TYPE_LIGHTNING,
            ____Q_6280_80FD_7C7B_578BID,
            "安斯艾尔-圣光附魔-雷",
            cfg["雷属性特效"]
        )
    else
        _____521B_5EFA_5B89_65AF_827E_5C14_8FFD_52A0_4F24_5BB3(
            attacker,
            target,
            damage,
            DAMAGE_TYPE_FIRE,
            ____Q_6280_80FD_7C7B_578BID,
            "安斯艾尔-圣光附魔-火",
            cfg["火属性特效"]
        )
    end
end
local function _____5C1D_8BD5_89E6_53D1_6269_6563_653B_51FB(attacker, target, applied, snapshot)
    local level = GetUnitAbilityLevel(attacker, ____E_6280_80FD_7C7B_578BID)
    if not (level > 0) then
        return
    end
    local cfg = _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.E
    local spreadRatio = cfg["基础扩散比例"] + cfg["每级扩散比例"] * level
    local function ____on_6267_884C_5B89_65AF_827E_5C14_6269_6563_4F24_5BB3()
        local attackerAlive = _____5355_4F4D_5B58_6D3B(attacker)
        local targetValid = target ~= nil and target ~= 0
        if not attackerAlive or not targetValid then
            return
        end
        local ____6269_6563_4F24_5BB3_21 = _____6269_6563_4F24_5BB3
        local ____attacker_17 = attacker
        local ____target_18 = target
        local ____applied_19 = applied
        local ____cfg__6269_6563_534A_5F84_20 = cfg["扩散半径"]
        local ____opt_result_11
        if snapshot ~= nil then
            ____opt_result_11 = snapshot.effectiveAttackType
        end
        local ____opt_result_11_12 = ____opt_result_11
        if ____opt_result_11_12 == nil then
            ____opt_result_11_12 = jass.ATTACK_TYPE_NORMAL
        end
        local ____opt_result_15
        if snapshot ~= nil then
            ____opt_result_15 = snapshot.effectiveWeaponType
        end
        local ____opt_result_15_16 = ____opt_result_15
        if ____opt_result_15_16 == nil then
            ____opt_result_15_16 = nil
        end
        ____6269_6563_4F24_5BB3_21({
            ["来源单位"] = ____attacker_17,
            ["主目标"] = ____target_18,
            ["伤害值"] = ____applied_19,
            ["扩散半径"] = ____cfg__6269_6563_534A_5F84_20,
            ["扩散百分比"] = spreadRatio,
            ["是否包含主目标"] = false,
            ["攻击类型"] = ____opt_result_11_12,
            ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
            ["武器类型"] = ____opt_result_15_16,
            ["来源类型"] = "普攻强化",
            ["技能ID"] = ____E_6280_80FD_7C7B_578BID,
            ["技能标签"] = "安斯艾尔-扩散攻击",
            ["参与技能伤害加成"] = false
        })
    end
    _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C(____on_6267_884C_5B89_65AF_827E_5C14_6269_6563_4F24_5BB3)
end
local function ____on_5B89_65AF_827E_5C14_666E_901A_653B_51FB_7ED3_7B97(target, attacker, applied, snapshot)
    if not _____662F_5B89_65AF_827E_5C14(attacker) then
        return
    end
    if not (applied > 0) then
        return
    end
    local ____opt_result_24
    if snapshot ~= nil then
        ____opt_result_24 = snapshot.isNormalAttack
    end
    local ____temp_28 = ____opt_result_24 ~= true
    if not ____temp_28 then
        local ____opt_result_27
        if snapshot ~= nil then
            ____opt_result_27 = snapshot.isWrappedSkillDamage
        end
        ____temp_28 = ____opt_result_27 == true
    end
    local ____temp_28_32 = ____temp_28
    if not ____temp_28_32 then
        local ____opt_result_31
        if snapshot ~= nil then
            ____opt_result_31 = snapshot.originalAttacker
        end
        ____temp_28_32 = ____opt_result_31 ~= attacker
    end
    if ____temp_28_32 then
        return
    end
    _____5C1D_8BD5_89E6_53D1_4E00_9A91_5F53_5148(attacker, target)
    _____5C1D_8BD5_6D88_8017_5723_5149_9644_9B54(attacker, target)
    _____5C1D_8BD5_89E6_53D1_6269_6563_653B_51FB(attacker, target, applied, snapshot)
end
____exports["注册安斯艾尔被动"] = function()
    registerAppliedFinalDamageListener(____on_5B89_65AF_827E_5C14_666E_901A_653B_51FB_7ED3_7B97)
end
____exports["注册安斯艾尔被动"]()
return ____exports
