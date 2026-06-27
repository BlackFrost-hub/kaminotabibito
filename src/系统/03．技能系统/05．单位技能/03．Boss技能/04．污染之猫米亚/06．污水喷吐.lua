--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC, _____5355_4F4D_6709_6548, _____53D6_5355_4F4D_653B_51FB_529B, _____8BA1_7B97_6C61_6C34_55B7_5410_76F4_63A5_4F24_5BB3, _____70B9_5728_524D_65B9_6247_5F62_5185, _____8BA9_5355_4F4D_9762_5411_76EE_6807, _____64AD_653E_55B7_5410_8868_73B0, _____521B_5EFA_6C61_6C34_55B7_5410_6B8B_7559_533A, ____on_7C73_4E9A_6C61_6C34_55B7_5410_751F_6548, getServerTime, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868Ex, _____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807, YDWETimerDestroyEffectSafe, _____521B_5EFA_6301_7EED_5371_9669_533A_57DF, jass, GetUnitTypeId, GetUnitX, GetUnitY, GetUnitFacing, GetUnitState, SetUnitFacing, SetUnitAnimationByIndex, UnitDamageTarget, ConvertUnitState, CosBJ, SinBJ, Atan2, AddSpecialEffect, BlzSetSpecialEffectYaw, GetUnitStateJapi, EXSetEffectSize, UNIT_STATE_MAX_LIFE, BJ_DEGTORAD, BJ_RADTODEG, _____7C73_4E9A_5355_4F4D_7C7B_578BID, _____6C61_6C34_55B7_5410_6280_80FDID
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建米亚上下文"]
local ____04_FF0E_8150_5316_611F_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.04．腐化感染")
local _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3 = ____04_FF0E_8150_5316_611F_67D3["添加米亚腐化感染"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____08_FF0E_6C61_67D3_6807_8BB0 = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.08．污染标记")
local _____53D6_7C73_4E9A_6C61_67D3_6807_8BB0_4F24_5BB3_500D_7387 = ____08_FF0E_6C61_67D3_6807_8BB0["取米亚污染标记伤害倍率"]
local ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A = require("系统.03．技能系统.05．单位技能.03．Boss技能.04．污染之猫米亚.12．平台超载惩罚")
local _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387 = ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A["取米亚平台超载伤害倍率"]
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0
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
function _____8BA1_7B97_6C61_6C34_55B7_5410_76F4_63A5_4F24_5BB3(boss, target)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水喷吐"]
    return (_____53D6_5355_4F4D_653B_51FB_529B(boss) * config["直接伤害Boss攻击力比例"] + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config["直接伤害目标最大生命比例"]) * config["直接伤害总倍率"]
end
function _____70B9_5728_524D_65B9_6247_5F62_5185(boss, target, range, halfAngle)
    local dx = GetUnitX(target) - GetUnitX(boss)
    local dy = GetUnitY(target) - GetUnitY(boss)
    local distance2 = dx * dx + dy * dy
    if distance2 > range * range then
        return false
    end
    local facing = GetUnitFacing(boss)
    local forwardX = CosBJ(facing)
    local forwardY = SinBJ(facing)
    local dot = dx * forwardX + dy * forwardY
    if dot <= 0 then
        return false
    end
    local cosLimit = CosBJ(halfAngle)
    return dot * dot >= distance2 * cosLimit * cosLimit
end
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
function _____64AD_653E_55B7_5410_8868_73B0(boss)
    local facing = GetUnitFacing(boss)
    local x = GetUnitX(boss) + CosBJ(facing) * 120
    local y = GetUnitY(boss) + SinBJ(facing) * 120
    local effect = AddSpecialEffect("Common\\Effect\\Element\\poison\\[AKE]war3AKE.com - 6158867876016216905550325.mdx", x, y)
    if effect ~= nil and effect ~= 0 then
        if type(EXSetEffectSize) == "function" then
            EXSetEffectSize(effect, 1.2)
        end
        if type(BlzSetSpecialEffectYaw) == "function" then
            BlzSetSpecialEffectYaw(effect, facing * BJ_DEGTORAD)
        end
        YDWETimerDestroyEffectSafe(1.5, effect)
    end
    SetUnitAnimationByIndex(boss, 5)
end
function _____521B_5EFA_6C61_6C34_55B7_5410_6B8B_7559_533A(context)
    local boss = context["Boss单位"]
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水喷吐"]
    local facing = GetUnitFacing(boss)
    local x = GetUnitX(boss) + CosBJ(facing) * (config["喷吐距离"] * 0.55)
    local y = GetUnitY(boss) + SinBJ(facing) * (config["喷吐距离"] * 0.55)
    _____521B_5EFA_6301_7EED_5371_9669_533A_57DF({
        X = x,
        Y = y,
        ["半径"] = config["残留半径"],
        ["持续时间"] = config["残留持续秒"],
        ["检测间隔"] = 1,
        ["影响目标"] = "敌方",
        ["所有者"] = boss,
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["腐化残留云"],
        ["特效高度"] = 0,
        ["显示提示圈"] = false,
        ["on周期"] = function(_____533A_57DF_5185_5355_4F4D)
            do
                local i = 0
                while i < #_____533A_57DF_5185_5355_4F4D do
                    _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, _____533A_57DF_5185_5355_4F4D[i + 1], config["残留每秒腐化层数"], "污水喷吐残留")
                    i = i + 1
                end
            end
        end
    })
end
____exports["释放米亚污水喷吐"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水喷吐"]
    context["上次污水喷吐Ms"] = getServerTime()
    _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "污水喷吐")
    local threatTarget = _____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807(boss)
    if threatTarget ~= nil then
        _____8BA9_5355_4F4D_9762_5411_76EE_6807(boss, threatTarget.targetRef)
    end
    _____64AD_653E_55B7_5410_8868_73B0(boss)
    _____521B_5EFA_6C61_6C34_55B7_5410_6B8B_7559_533A(context)
    local targets = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868Ex(boss, boss, config["喷吐距离"])
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not _____5355_4F4D_6709_6548(target) or not _____70B9_5728_524D_65B9_6247_5F62_5185(boss, target, config["喷吐距离"], config["喷吐半角"]) then
                    goto __continue24
                end
                UnitDamageTarget(
                    boss,
                    target,
                    _____8BA1_7B97_6C61_6C34_55B7_5410_76F4_63A5_4F24_5BB3(boss, target) * _____53D6_7C73_4E9A_6C61_67D3_6807_8BB0_4F24_5BB3_500D_7387(context, target) * _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387(target),
                    false,
                    false,
                    jass.ATTACK_TYPE_CHAOS,
                    jass.DAMAGE_TYPE_POISON,
                    jass.WEAPON_TYPE_WHOKNOWS
                )
                _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, target, config["直接腐化层数"], "污水喷吐")
            end
            ::__continue24::
            i = i + 1
        end
    end
end
function ____on_7C73_4E9A_6C61_6C34_55B7_5410_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6C61_6C34_55B7_5410_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____7C73_4E9A_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放米亚污水喷吐"](context)
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
getServerTime = ____require_result_0.getServerTime
local _____6280_80FD_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868Ex = ____require_result_1["获取Boss技能敌对英雄列表Ex"]
_____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807 = ____require_result_1["获取Boss技能应攻击目标"]
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDWETimerDestroyEffectSafe = ____require_result_2.YDWETimerDestroyEffectSafe
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域")
_____521B_5EFA_6301_7EED_5371_9669_533A_57DF = ____require_result_3["创建持续危险区域"]
jass = require("jass.common")
local japi = require("jass.japi")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFacing = jass.GetUnitFacing
GetUnitState = jass.GetUnitState
SetUnitFacing = jass.SetUnitFacing
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
UnitDamageTarget = jass.UnitDamageTarget
ConvertUnitState = jass.ConvertUnitState
CosBJ = jass.CosBJ
SinBJ = jass.SinBJ
Atan2 = jass.Atan2
AddSpecialEffect = jass.AddSpecialEffect
BlzSetSpecialEffectYaw = jass.BlzSetSpecialEffectYaw
GetUnitStateJapi = japi.GetUnitState
EXSetEffectSize = japi.EXSetEffectSize
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
BJ_DEGTORAD = 0.017453292519943295
BJ_RADTODEG = 57.29577951308232
_____7C73_4E9A_5355_4F4D_7C7B_578BID = stringToFourCC(_____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["Boss单位ID"])
_____6C61_6C34_55B7_5410_6280_80FDID = stringToFourCC(_____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["污水喷吐技能"])
local _____7C73_4E9A_6C61_6C34_55B7_5410_5DF2_6CE8_518C = false
____exports["注册米亚污水喷吐"] = function()
    if _____7C73_4E9A_6C61_6C34_55B7_5410_5DF2_6CE8_518C then
        return
    end
    _____7C73_4E9A_6C61_6C34_55B7_5410_5DF2_6CE8_518C = true
    _____6280_80FD_4E8B_4EF6_4E2D_5FC3.registerSpellEffectListener(____on_7C73_4E9A_6C61_6C34_55B7_5410_751F_6548)
end
return ____exports
