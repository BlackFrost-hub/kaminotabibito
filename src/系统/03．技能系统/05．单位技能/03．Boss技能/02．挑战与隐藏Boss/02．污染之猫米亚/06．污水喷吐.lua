--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____70B9_5728_524D_65B9_6247_5F62_5185, _____8BA9_5355_4F4D_9762_5411_76EE_6807, _____64AD_653E_55B7_5410_8868_73B0, _____521B_5EFA_6C61_6C34_55B7_5410_6B8B_7559_533A, ____on_7C73_4E9A_6C61_6C34_55B7_5410_751F_6548, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868Ex, _____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807, _____521B_5EFA_70B9_7279_6548, _____521B_5EFA_6301_7EED_5371_9669_533A_57DF, jass, GetUnitTypeId, GetUnitX, GetUnitY, GetUnitFacing, SetUnitFacing, SetUnitAnimationByIndex, SetUnitTimeScale, CosBJ, SinBJ, Atan2, BJ_RADTODEG, _____7C73_4E9A_5355_4F4D_7C7B_578BID, _____6C61_6C34_55B7_5410_6280_80FDID
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建米亚上下文"]
local ____04_FF0E_8150_5316_611F_67D3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.04．腐化感染")
local _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3 = ____04_FF0E_8150_5316_611F_67D3["添加米亚腐化感染"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local _____7C73_4E9A_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚音效配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["延迟播放Boss坐标音效"]
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____08_FF0E_6C61_67D3_6807_8BB0 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.08．污染标记")
local _____53D6_7C73_4E9A_6C61_67D3_6807_8BB0_4F24_5BB3_500D_7387 = ____08_FF0E_6C61_67D3_6807_8BB0["取米亚污染标记伤害倍率"]
local ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.12．平台超载惩罚")
local _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387 = ____12_FF0E_5E73_53F0_8D85_8F7D_60E9_7F5A["取米亚平台超载伤害倍率"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位有效"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBoss_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行Boss技能伤害"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
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
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污水喷吐"]
    local facing = GetUnitFacing(boss)
    local x = GetUnitX(boss) + CosBJ(facing) * 120
    local y = GetUnitY(boss) + SinBJ(facing) * 120
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = config["喷吐特效路径"],
        X = x,
        Y = y,
        ["Z轴角度"] = facing,
        ["缩放"] = config["喷吐特效缩放"],
        ["持续秒"] = config["喷吐特效持续秒"]
    })
    SetUnitTimeScale(boss, config["动画速度"])
    SetUnitAnimationByIndex(boss, config["动画编号"])
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
        ["提示圈"] = {["类型"] = "敌方圆形"},
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
    _____64AD_653E_7C73_4E9A_53F0_8BCD(boss, "污水喷吐")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____7C73_4E9A_97F3_6548_914D_7F6E["污水喷吐"]["前摇蓄力"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____7C73_4E9A_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548(
        _____7C73_4E9A_97F3_6548_914D_7F6E["污水喷吐"]["持续喷射"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____7C73_4E9A_97F3_6548_914D_7F6E["污水喷吐"]["持续喷射延迟Ms"],
        _____7C73_4E9A_97F3_6548_914D_7F6E["默认裁断距离"]
    )
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
                    goto __continue16
                end
                _____6267_884CBoss_6280_80FD_4F24_5BB3({
                    ["技能ID"] = _____6C61_6C34_55B7_5410_6280_80FDID,
                    ["来源"] = boss,
                    ["目标"] = target,
                    ["伤害公式"] = {
                        ["来源攻击力比例"] = config["直接伤害Boss攻击力比例"],
                        ["目标最大生命比例"] = config["直接伤害目标最大生命比例"],
                        ["总倍率"] = config["直接伤害总倍率"] * _____53D6_7C73_4E9A_6C61_67D3_6807_8BB0_4F24_5BB3_500D_7387(context, target) * _____53D6_7C73_4E9A_5E73_53F0_8D85_8F7D_4F24_5BB3_500D_7387(target)
                    },
                    attackType = jass.ATTACK_TYPE_CHAOS,
                    ["伤害类型"] = jass.DAMAGE_TYPE_POISON,
                    weaponType = jass.WEAPON_TYPE_WHOKNOWS,
                    ["伤害形态"] = "AOE"
                })
                _____6DFB_52A0_7C73_4E9A_8150_5316_611F_67D3(context, target, config["直接腐化层数"], "污水喷吐")
            end
            ::__continue16::
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
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868Ex = ____require_result_0["获取Boss技能敌对英雄列表Ex"]
_____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807 = ____require_result_0["获取Boss技能应攻击目标"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_1["创建点特效"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域")
_____521B_5EFA_6301_7EED_5371_9669_533A_57DF = ____require_result_2["创建持续危险区域"]
jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFacing = jass.GetUnitFacing
SetUnitFacing = jass.SetUnitFacing
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
SetUnitTimeScale = jass.SetUnitTimeScale
CosBJ = jass.CosBJ
SinBJ = jass.SinBJ
Atan2 = jass.Atan2
BJ_RADTODEG = 57.29577951308232
_____7C73_4E9A_5355_4F4D_7C7B_578BID = stringToFourCC(_____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["Boss单位ID"])
_____6C61_6C34_55B7_5410_6280_80FDID = stringToFourCC(_____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["污水喷吐技能"])
local _____7C73_4E9A_6C61_6C34_55B7_5410_5DF2_6CE8_518C = false
____exports["注册米亚污水喷吐"] = function()
    if _____7C73_4E9A_6C61_6C34_55B7_5410_5DF2_6CE8_518C then
        return
    end
    _____7C73_4E9A_6C61_6C34_55B7_5410_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "米亚-污水喷吐",
        ["单位类型ID"] = _____7C73_4E9A_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6C61_6C34_55B7_5410_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_7C73_4E9A_6C61_6C34_55B7_5410_751F_6548(boss, _____6C61_6C34_55B7_5410_6280_80FDID)
        end
    })
end
return ____exports
