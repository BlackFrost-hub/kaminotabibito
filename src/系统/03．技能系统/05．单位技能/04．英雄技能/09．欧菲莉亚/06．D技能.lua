local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.09．欧菲莉亚.00．配置")
local _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["欧菲莉亚单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.09．欧菲莉亚.00A．表现工具")
local _____64AD_653E_6B27_83F2_8389_4E9A_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放欧菲莉亚单位音效"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_1["调整玩家属性"]
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_3.registerSpellEffectListener
local _____6B27_83F2_8389_4E9A_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____6B27_83F2_8389_4E9AD_6280_80FDID = stringToFourCCSafe(_____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["D技能ID"])
local _____6B27_83F2_8389_4E9AD_539F_751F_72B6_6001_6280_80FDID = stringToFourCCSafe(_____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.D["原生状态技能ID"])
local GetUnitTypeId = jass.GetUnitTypeId
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local function _____6B27_83F2_8389_4E9AD_89E3_9664(target, _buffID, row)
    if target == nil or target == 0 then
        return
    end
    local ____temp_7
    local ____opt_result_6
    if row ~= nil then
        ____opt_result_6 = row.effect
    end
    if type(____opt_result_6) == "number" and row.effect > 0 then
        ____temp_7 = row.effect
    else
        ____temp_7 = _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.D["魔抗增加"]
    end
    local value = ____temp_7
    _____8C03_6574_73A9_5BB6_5C5E_6027(
        target,
        "魔抗",
        __TS__Number(-value)
    )
end
local function _____5904_7406_6B27_83F2_8389_4E9AD(caster, abilityId)
    if abilityId ~= _____6B27_83F2_8389_4E9AD_6280_80FDID or GetUnitTypeId(caster) ~= _____6B27_83F2_8389_4E9A_5355_4F4D_7C7B_578BID then
        return
    end
    local target = GetSpellTargetUnit()
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local cfg = _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.D
    _____64AD_653E_6B27_83F2_8389_4E9A_5355_4F4D_97F3_6548(caster, cfg["全局音效键"])
    _____8C03_6574_73A9_5BB6_5C5E_6027(target, "魔抗", cfg["魔抗增加"])
    jass:UnitAddAbility(target, _____6B27_83F2_8389_4E9AD_539F_751F_72B6_6001_6280_80FDID)
    registerManualBuff(
        target,
        cfg.BuffID,
        cfg["持续秒"],
        cfg["魔抗增加"],
        {
            sourceUnit = caster,
            sourceName = "欧菲莉亚-守护屏障",
            stack = 1,
            nativeBuffAbilityIds = {_____6B27_83F2_8389_4E9AD_539F_751F_72B6_6001_6280_80FDID},
            onRemove = _____6B27_83F2_8389_4E9AD_89E3_9664
        }
    )
end
registerSpellEffectListener(_____5904_7406_6B27_83F2_8389_4E9AD)
return ____exports
