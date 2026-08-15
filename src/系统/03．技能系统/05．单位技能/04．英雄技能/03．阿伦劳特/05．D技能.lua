local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____13_FF0E_963F_4F26_52B3_7279 = require("系统.05．Buff系统.03．Buff表.02．英雄.13．阿伦劳特")
local _____963F_4F26_52B3_7279BuffID = ____13_FF0E_963F_4F26_52B3_7279["阿伦劳特BuffID"]
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.04．英雄技能.03．阿伦劳特.00．配置")
local _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_1["阿伦劳特单位技能配置"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.04．英雄技能.03．阿伦劳特.00B．形态与状态管理")
local _____662F_963F_4F26_52B3_7279_82F1_96C4 = ____require_result_2["是阿伦劳特英雄"]
local _____662F_5149_5F62_6001 = ____require_result_2["是光形态"]
local _____662F_6697_5F62_6001 = ____require_result_2["是暗形态"]
local _____6DFB_52A0_539F_751FBuff_6301_7EED = ____require_result_2["添加原生Buff持续"]
local _____79FB_9664_539F_751FBuff = ____require_result_2["移除原生Buff"]
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_3.registerSpellEffectListener
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_5.addDelayedCallback
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_6["调整玩家属性"]
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_6["临时调整攻击"]
local ____require_result_7 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_7.doHeal
local ____require_result_8 = require("系统.05．Buff系统.05．Buff清除函数")
local _____79FB_9664_5355_4F4D_8D1F_9762Buff = ____require_result_8["移除单位负面Buff"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧")
local _____5F00_59CB_65E0_654C_5E27 = ____require_result_9["开始无敌帧"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedUnitEffect = ____require_result_10.createTimedUnitEffect
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJass = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
local SetUnitStateJapi = japi.SetUnitState
local GetHeroStr = jass.GetHeroStr
local DzSetUnitID = japi.DzSetUnitID
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_ATTACK = jass.ConvertUnitState(21)
local _____5149_5F62_6001_5355_4F4DID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["光形态单位ID"])
local _____6697_5F62_6001_5355_4F4DID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["暗形态单位ID"])
local ____D_6280_80FDID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["D技能ID"])
local _____5207_6362_52A0_653BBuffID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["切换加攻BuffID"])
--- 切换后重设最大生命 = 30 + 力量 × 1.35（源 切换.j）
local function _____91CD_8BBE_5F62_6001_6700_5927_751F_547D(unit)
    SetUnitStateJapi(
        unit,
        UNIT_STATE_MAX_LIFE,
        30 + GetHeroStr(unit, false) * 1.35
    )
end
--- 光 H00F → 暗 H00G
local function _____5149_5F62_6001_5207_6362_4E3A_6697(unit)
    local ____D_914D_7F6E = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.D
    DzSetUnitID(unit, _____6697_5F62_6001_5355_4F4DID)
    registerManualBuff(unit, _____963F_4F26_52B3_7279BuffID["裁决圣剑形态"], 999, 0)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____963F_4F26_52B3_7279BuffID["光之圣剑形态"])
    _____91CD_8BBE_5F62_6001_6700_5927_751F_547D(unit)
    createTimedUnitEffect(unit, "origin", ____D_914D_7F6E["光切暗特效A"], ____D_914D_7F6E["切换特效持续秒"])
    createTimedUnitEffect(unit, "origin", ____D_914D_7F6E["光切暗特效B"], ____D_914D_7F6E["切换特效持续秒"])
    _____8C03_6574_73A9_5BB6_5C5E_6027(
        unit,
        ____D_914D_7F6E["光治疗加成属性名"],
        __TS__Number(-____D_914D_7F6E["光治疗加成"])
    )
    _____8C03_6574_73A9_5BB6_5C5E_6027(
        unit,
        ____D_914D_7F6E["光魔法伤害加成属性名"],
        __TS__Number(-____D_914D_7F6E["光魔法伤害加成"])
    )
    _____8C03_6574_73A9_5BB6_5C5E_6027(unit, ____D_914D_7F6E["暗生命恢复增幅属性名"], ____D_914D_7F6E["暗生命恢复增幅"])
    _____8C03_6574_73A9_5BB6_5C5E_6027(unit, ____D_914D_7F6E["暗受到治疗加成属性名"], ____D_914D_7F6E["暗受到治疗加成"])
    local _____5DF2_635F_5931_751F_547D = math.max(
        0,
        GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) - GetUnitStateJass(unit, UNIT_STATE_LIFE)
    )
    doHeal({
        HealSource = unit,
        HealTarget = unit,
        HealAmount = _____5DF2_635F_5931_751F_547D * ____D_914D_7F6E["恢复已损失生命比例"],
        ItemHeal = false,
        HealEffect = false
    })
    local _____653B_51FB_529B = GetUnitStateJapi(unit, UNIT_STATE_ATTACK)
    local _____52A0_653B_91CF = _____653B_51FB_529B * ____D_914D_7F6E["切换加攻比例"]
    if _____52A0_653B_91CF > 0 then
        _____4E34_65F6_8C03_6574_653B_51FB(unit, _____52A0_653B_91CF)
        _____6DFB_52A0_539F_751FBuff_6301_7EED(unit, _____5207_6362_52A0_653BBuffID, ____D_914D_7F6E["切换加攻持续秒"])
        registerManualBuff(unit, _____963F_4F26_52B3_7279BuffID["切换加攻"], 2, 0)
        addDelayedCallback(
            math.floor(____D_914D_7F6E["切换加攻持续秒"] * 1000 + 0.5),
            function()
                _____4E34_65F6_8C03_6574_653B_51FB(unit, -_____52A0_653B_91CF)
                _____79FB_9664_539F_751FBuff(unit, _____5207_6362_52A0_653BBuffID)
            end
        )
    end
end
--- 暗 H00G → 光 H00F
local function _____6697_5F62_6001_5207_6362_4E3A_5149(unit)
    local ____D_914D_7F6E = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.D
    DzSetUnitID(unit, _____5149_5F62_6001_5355_4F4DID)
    registerManualBuff(unit, _____963F_4F26_52B3_7279BuffID["光之圣剑形态"], 999, 0)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____963F_4F26_52B3_7279BuffID["裁决圣剑形态"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____963F_4F26_52B3_7279BuffID["切换加攻"])
    _____91CD_8BBE_5F62_6001_6700_5927_751F_547D(unit)
    createTimedUnitEffect(unit, "origin", ____D_914D_7F6E["暗切光特效A"], ____D_914D_7F6E["切换特效持续秒"])
    createTimedUnitEffect(unit, "origin", ____D_914D_7F6E["暗切光特效B"], ____D_914D_7F6E["切换特效持续秒"])
    _____8C03_6574_73A9_5BB6_5C5E_6027(unit, ____D_914D_7F6E["光治疗加成属性名"], ____D_914D_7F6E["光治疗加成"])
    _____8C03_6574_73A9_5BB6_5C5E_6027(unit, ____D_914D_7F6E["光魔法伤害加成属性名"], ____D_914D_7F6E["光魔法伤害加成"])
    _____8C03_6574_73A9_5BB6_5C5E_6027(
        unit,
        ____D_914D_7F6E["暗生命恢复增幅属性名"],
        __TS__Number(-____D_914D_7F6E["暗生命恢复增幅"])
    )
    _____8C03_6574_73A9_5BB6_5C5E_6027(
        unit,
        ____D_914D_7F6E["暗受到治疗加成属性名"],
        __TS__Number(-____D_914D_7F6E["暗受到治疗加成"])
    )
    _____79FB_9664_5355_4F4D_8D1F_9762Buff(unit, false)
    _____5F00_59CB_65E0_654C_5E27(unit, ____D_914D_7F6E["免伤秒"])
end
--- 入口：A0D8 施放触发形态切换
____exports["on阿伦劳特D切换"] = function(_____65BD_6CD5_5355_4F4D, abilityId)
    if abilityId ~= ____D_6280_80FDID then
        return
    end
    if not _____662F_963F_4F26_52B3_7279_82F1_96C4(_____65BD_6CD5_5355_4F4D) then
        return
    end
    if _____662F_5149_5F62_6001(_____65BD_6CD5_5355_4F4D) then
        _____5149_5F62_6001_5207_6362_4E3A_6697(_____65BD_6CD5_5355_4F4D)
        return
    end
    if _____662F_6697_5F62_6001(_____65BD_6CD5_5355_4F4D) then
        _____6697_5F62_6001_5207_6362_4E3A_5149(_____65BD_6CD5_5355_4F4D)
    end
end
registerSpellEffectListener(____exports["on阿伦劳特D切换"])
return ____exports
