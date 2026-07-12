--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8BA9_5355_4F4D_9762_5411_76EE_6807, _____53D6_5355_4F4D_653B_51FB_529B, _____64AD_653E_722A_51FB_8868_73B0, _____521B_5EFA_8150_5316_722A_51FB_6B8B_7559_533A, ____on_7C73_4E9A_8150_5316_722A_51FB_751F_6548, getServerTime, YDWETimerDestroyEffectSafe, _____521B_5EFA_6301_7EED_5371_9669_533A_57DF, _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3, jass, GetUnitTypeId, GetSpellTargetUnit, GetUnitX, GetUnitY, SetUnitFacing, SetUnitAnimationByIndex, ConvertUnitState, Atan2, AddSpecialEffect, GetUnitStateJapi, EXSetEffectSize, BJ_RADTODEG, _____7C73_4E9A_5355_4F4D_7C7B_578BID, _____8150_5316_722A_51FB_6280_80FDID
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建米亚上下文"]
local ____04_FF0E_8150_5316_611F_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.04．腐化感染")
local _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3 = ____04_FF0E_8150_5316_611F_67D3["添加米亚腐化感染"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____08_FF0E_6C61_67D3_6807_8BB0 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.08．污染标记")
local _____53D6_7C73_4E9A_6C61_67D3_6807_8BB0_4F24_5BB3_500D_7387 = ____08_FF0E_6C61_67D3_6807_8BB0["取米亚污染标记伤害倍率"]
local ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.12．平台超载惩罚")
local _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387 = ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A["取米亚平台超载伤害倍率"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位有效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function _____8BA9_5355_4F4D_9762_5411_76EE_6807(caster, target)
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local angle = Atan2(
        GetUnitY(target) - GetUnitY(caster),
        GetUnitX(target) - GetUnitX(caster)
    ) * BJ_RADTODEG
    SetUnitFacing(caster, angle)
end
function _____53D6_5355_4F4D_653B_51FB_529B(unit)
    if not _____5355_4F4D_6709_6548(unit) or type(GetUnitStateJapi) ~= "function" then
        return 1000
    end
    local value = GetUnitStateJapi(
        unit,
        ConvertUnitState(21)
    )
    return value > 0 and value or 1000
end
function _____64AD_653E_722A_51FB_8868_73B0(boss, target)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local effect = AddSpecialEffect(
        "Common\\Effect\\Form\\ClawMark\\reapers_claws_green.mdx",
        GetUnitX(target),
        GetUnitY(target)
    )
    if effect ~= nil and effect ~= 0 then
        if type(EXSetEffectSize) == "function" then
            EXSetEffectSize(effect, 1.3)
        end
        YDWETimerDestroyEffectSafe(1.2, effect)
    end
    SetUnitAnimationByIndex(boss, 7)
end
function _____521B_5EFA_8150_5316_722A_51FB_6B8B_7559_533A(context, x, y)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化爪击"]
    _____521B_5EFA_6301_7EED_5371_9669_533A_57DF({
        X = x,
        Y = y,
        ["半径"] = config["残留半径"],
        ["持续时间"] = config["残留持续秒"],
        ["检测间隔"] = 1,
        ["影响目标"] = "敌方",
        ["所有者"] = context["Boss单位"],
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["腐化残留云"],
        ["特效高度"] = 0,
        ["显示提示圈"] = false,
        ["on周期"] = function(_____533A_57DF_5185_5355_4F4D)
            do
                local i = 0
                while i < #_____533A_57DF_5185_5355_4F4D do
                    _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, _____533A_57DF_5185_5355_4F4D[i + 1], config["残留每秒腐化层数"], "腐化爪击残留")
                    i = i + 1
                end
            end
        end
    })
end
____exports["释放米亚腐化爪击"] = function(context, target)
    local boss = context["Boss单位"]
    local actualTarget = target
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(actualTarget) then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["腐化爪击"]
    context["上次腐化爪击Ms"] = getServerTime()
    _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "腐化爪击")
    _____8BA9_5355_4F4D_9762_5411_76EE_6807(boss, actualTarget)
    _____64AD_653E_722A_51FB_8868_73B0(boss, actualTarget)
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["技能ID"] = _____8150_5316_722A_51FB_6280_80FDID,
        ["来源"] = boss,
        ["目标"] = actualTarget,
        ["伤害"] = _____53D6_5355_4F4D_653B_51FB_529B(boss) * config["攻击力倍率"] * _____53D6_7C73_4E9A_6C61_67D3_6807_8BB0_4F24_5BB3_500D_7387(context, actualTarget) * _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387(actualTarget),
        attackType = jass.ATTACK_TYPE_CHAOS,
        ["伤害类型"] = jass.DAMAGE_TYPE_POISON,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "Boss技能"
    })
    _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, actualTarget, config["残留每秒腐化层数"], "腐化爪击")
    _____521B_5EFA_8150_5316_722A_51FB_6B8B_7559_533A(
        context,
        GetUnitX(actualTarget),
        GetUnitY(actualTarget)
    )
end
function ____on_7C73_4E9A_8150_5316_722A_51FB_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____8150_5316_722A_51FB_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____7C73_4E9A_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放米亚腐化爪击"](
        context,
        GetSpellTargetUnit()
    )
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDWETimerDestroyEffectSafe = ____require_result_1.YDWETimerDestroyEffectSafe
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域")
_____521B_5EFA_6301_7EED_5371_9669_533A_57DF = ____require_result_2["创建持续危险区域"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_3["造成单体技能伤害"]
jass = require("jass.common")
local japi = require("jass.japi")
GetUnitTypeId = jass.GetUnitTypeId
GetSpellTargetUnit = jass.GetSpellTargetUnit
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
SetUnitFacing = jass.SetUnitFacing
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
ConvertUnitState = jass.ConvertUnitState
Atan2 = jass.Atan2
AddSpecialEffect = jass.AddSpecialEffect
GetUnitStateJapi = japi.GetUnitState
EXSetEffectSize = japi.EXSetEffectSize
BJ_RADTODEG = 57.29577951308232
_____7C73_4E9A_5355_4F4D_7C7B_578BID = stringToFourCC(_____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["Boss单位ID"])
_____8150_5316_722A_51FB_6280_80FDID = stringToFourCC(_____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["腐化爪击技能"])
local _____7C73_4E9A_8150_5316_722A_51FB_5DF2_6CE8_518C = false
____exports["注册米亚腐化爪击"] = function()
    if _____7C73_4E9A_8150_5316_722A_51FB_5DF2_6CE8_518C then
        return
    end
    _____7C73_4E9A_8150_5316_722A_51FB_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "米亚-腐化爪击",
        ["单位类型ID"] = _____7C73_4E9A_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____8150_5316_722A_51FB_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_7C73_4E9A_8150_5316_722A_51FB_751F_6548(boss, _____8150_5316_722A_51FB_6280_80FDID)
        end
    })
end
return ____exports
