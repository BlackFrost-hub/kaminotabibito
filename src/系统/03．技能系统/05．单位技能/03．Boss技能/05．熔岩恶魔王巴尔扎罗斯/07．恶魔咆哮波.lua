--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5355_4F4D_6709_6548, _____53D6_76EE_6807_5355_4F4D, _____53D6_65B9_5411_89D2, _____662F_5DF4_5C14_624E_7F57_65AF_62A4_536B, _____6536_96C6_5486_54EE_6CE2_5019_9009_5355_4F4D, _____9650_5236_751F_547D_503C, _____6CBB_7597_5355_4F4D, _____8BA1_7B97_5486_54EE_6CE2_4F24_5BB3, _____8BB0_5F55_5486_54EE_6CE2_73A9_5BB6_547D_4E2D, _____64AD_653E_6076_9B54_5486_54EE_6CE2_84C4_529B_7279_6548, _____64AD_653E_6076_9B54_5486_54EE_6CE2_51B2_51FB_7279_6548, _____521B_5EFA_5486_54EE_6CE2_9884_8B66, _____6267_884C_5486_54EE_6CE2_547D_4E2D, _____521B_5EFA_5486_54EE_6CE2_5224_5B9A, ____on_5DF4_5C14_624E_7F57_65AF_6076_9B54_5486_54EE_6CE2_751F_6548, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____521B_5EFA_7EBF_6BB5_5371_9669_533A, _____83B7_53D6Boss_6280_80FD_6700_9AD8_4EC7_6068_76EE_6807, _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, getServerTime, YDWETimerDestroyEffectSafe, _____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C, _____65BD_52A0_5FEB_901F_63A7_5236Buff, CosBJ, SinBJ, GetUnitTypeId, GetHandleId, GetUnitX, GetUnitY, GetUnitState, SetUnitState, IsUnitType, UnitDamageTarget, AddSpecialEffect, Atan2, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, UNIT_TYPE_DEAD, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS, EXSetEffectZ, EXSetEffectSize, BJ_RADTODEG, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID, _____6076_9B54_5486_54EE_6CE2_6280_80FDID, _____5FEB_901F_63A7_5236__51FB_6655
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建巴尔扎罗斯上下文"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯技能数值配置"]
local ____14_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.14．台词播放")
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放巴尔扎罗斯台词"]
local ____16_FF0EBoss_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．Boss技能壳监听注册器")
local _____6CE8_518CBoss_6280_80FD_58F3_76D1_542C = ____16_FF0EBoss_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册Boss技能壳监听"]
local ____19_FF0EBoss_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．Boss公共工具")
local stringToFourCC = ____19_FF0EBoss_516C_5171_5DE5_5177.stringToFourCC
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
function _____53D6_76EE_6807_5355_4F4D(boss)
    local entry = _____83B7_53D6Boss_6280_80FD_6700_9AD8_4EC7_6068_76EE_6807(boss)
    if entry ~= nil and _____5355_4F4D_6709_6548(entry.targetRef) then
        return entry.targetRef
    end
    return _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
end
function _____53D6_65B9_5411_89D2(boss, target)
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) then
        return 0
    end
    return Atan2(
        GetUnitY(target) - GetUnitY(boss),
        GetUnitX(target) - GetUnitX(boss)
    ) * BJ_RADTODEG
end
function _____662F_5DF4_5C14_624E_7F57_65AF_62A4_536B(context, unit)
    return unit ~= nil and unit ~= 0 and (unit == context["格鲁姆"] or unit == context["塞拉"])
end
function _____6536_96C6_5486_54EE_6CE2_5019_9009_5355_4F4D(context)
    local result = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    if _____5355_4F4D_6709_6548(context["格鲁姆"]) then
        result[#result + 1] = context["格鲁姆"]
    end
    if _____5355_4F4D_6709_6548(context["塞拉"]) then
        result[#result + 1] = context["塞拉"]
    end
    return result
end
function _____9650_5236_751F_547D_503C(value, maxLife)
    if value < 1 then
        return 1
    end
    if value > maxLife then
        return maxLife
    end
    return value
end
function _____6CBB_7597_5355_4F4D(unit, amount)
    if not _____5355_4F4D_6709_6548(unit) or amount <= 0 then
        return
    end
    local maxLife = GetUnitState(unit, UNIT_STATE_MAX_LIFE)
    local life = GetUnitState(unit, UNIT_STATE_LIFE)
    SetUnitState(
        unit,
        UNIT_STATE_LIFE,
        _____9650_5236_751F_547D_503C(life + amount, maxLife)
    )
end
function _____8BA1_7B97_5486_54EE_6CE2_4F24_5BB3(boss, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["恶魔咆哮波"]
    return (_____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * config["伤害Boss攻击力比例"] + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config["伤害目标最大生命比例"]) * config["伤害总倍率"]
end
function _____8BB0_5F55_5486_54EE_6CE2_73A9_5BB6_547D_4E2D(context, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["恶魔咆哮波"]
    local hid = GetHandleId(target) or 0
    if hid == 0 then
        return
    end
    local now = getServerTime()
    local last = context["恶魔咆哮波命中记录"][hid] or 0
    context["恶魔咆哮波命中记录"][hid] = now
    if last > 0 and now - last <= config["连续命中窗口秒"] * 1000 then
        _____65BD_52A0_5FEB_901F_63A7_5236Buff(context["Boss单位"], target, _____5FEB_901F_63A7_5236__51FB_6655, config["连续命中眩晕秒"])
    end
end
function _____64AD_653E_6076_9B54_5486_54EE_6CE2_84C4_529B_7279_6548(boss, angle)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["恶魔咆哮波"]
    local x = GetUnitX(boss) + CosBJ(angle) * config["冲击特效前移"]
    local y = GetUnitY(boss) + SinBJ(angle) * config["冲击特效前移"]
    local effect = AddSpecialEffect(config["聚火特效路径"], x, y)
    if effect == nil or effect == 0 then
        return
    end
    if type(EXSetEffectZ) == "function" then
        EXSetEffectZ(effect, config["聚火特效高度"])
    end
    if type(EXSetEffectSize) == "function" then
        EXSetEffectSize(effect, config["聚火特效缩放"])
    end
    _____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C(effect, {["Z轴角度"] = angle})
    YDWETimerDestroyEffectSafe(config["聚火特效持续秒"], effect)
end
function _____64AD_653E_6076_9B54_5486_54EE_6CE2_51B2_51FB_7279_6548(boss, angle)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["恶魔咆哮波"]
    local x = GetUnitX(boss) + CosBJ(angle) * config["冲击特效前移"]
    local y = GetUnitY(boss) + SinBJ(angle) * config["冲击特效前移"]
    local effect = AddSpecialEffect(config["冲击特效路径"], x, y)
    if effect == nil or effect == 0 then
        return
    end
    if type(EXSetEffectZ) == "function" then
        EXSetEffectZ(effect, config["冲击特效高度"])
    end
    if type(EXSetEffectSize) == "function" then
        EXSetEffectSize(effect, config["冲击特效缩放"])
    end
    _____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C(effect, {["X轴角度"] = config["冲击特效X轴旋转角度"], ["Y轴角度"] = config["冲击特效Y轴旋转角度"], ["Z轴角度"] = angle + config["冲击特效朝向修正角度"]})
    YDWETimerDestroyEffectSafe(config["冲击特效持续秒"], effect)
end
function _____521B_5EFA_5486_54EE_6CE2_9884_8B66(boss, angle)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["恶魔咆哮波"]
    local centerX = GetUnitX(boss) + CosBJ(angle) * (config["路径长度"] * 0.5)
    local centerY = GetUnitY(boss) + SinBJ(angle) * (config["路径长度"] * 0.5)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "矩形",
        X = centerX,
        Y = centerY,
        ["宽度"] = config["路径宽度"],
        ["长度"] = config["路径长度"],
        ["朝向"] = angle,
        ["持续时间"] = config["施法硬直秒"]
    })
end
function _____6267_884C_5486_54EE_6CE2_547D_4E2D(context, unit)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(unit) then
        return
    end
    if _____662F_5DF4_5C14_624E_7F57_65AF_62A4_536B(context, unit) then
        _____6CBB_7597_5355_4F4D(
            unit,
            GetUnitState(unit, UNIT_STATE_MAX_LIFE) * _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["恶魔咆哮波"]["护卫命中治疗最大生命比例"]
        )
        return
    end
    UnitDamageTarget(
        boss,
        unit,
        _____8BA1_7B97_5486_54EE_6CE2_4F24_5BB3(boss, unit),
        false,
        true,
        ATTACK_TYPE_CHAOS,
        DAMAGE_TYPE_FIRE,
        WEAPON_TYPE_WHOKNOWS
    )
    _____8BB0_5F55_5486_54EE_6CE2_73A9_5BB6_547D_4E2D(context, unit)
end
function _____521B_5EFA_5486_54EE_6CE2_5224_5B9A(context, angle)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["恶魔咆哮波"]
    local boss = context["Boss单位"]
    _____64AD_653E_6076_9B54_5486_54EE_6CE2_51B2_51FB_7279_6548(boss, angle)
    _____521B_5EFA_7EBF_6BB5_5371_9669_533A({
        ["清理"] = context["清理"],
        ["名称"] = "巴尔扎罗斯-恶魔咆哮波",
        ["起点X"] = GetUnitX(boss),
        ["起点Y"] = GetUnitY(boss),
        ["方向角"] = angle,
        ["长度"] = config["路径长度"],
        ["宽度"] = config["路径宽度"],
        ["持续秒"] = config["路径持续秒"],
        ["Tick间隔毫秒"] = config["路径Tick毫秒"],
        ["单位列表"] = function()
            return _____6536_96C6_5486_54EE_6CE2_5019_9009_5355_4F4D(context)
        end,
        ["提示圈"] = false,
        ["on进入"] = function(unit)
            _____6267_884C_5486_54EE_6CE2_547D_4E2D(context, unit)
        end
    })
end
____exports["释放巴尔扎罗斯恶魔咆哮波"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local target = _____53D6_76EE_6807_5355_4F4D(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["恶魔咆哮波"]
    local angle = _____53D6_65B9_5411_89D2(boss, target)
    _____521B_5EFA_5486_54EE_6CE2_9884_8B66(boss, angle)
    _____64AD_653E_6076_9B54_5486_54EE_6CE2_84C4_529B_7279_6548(boss, angle)
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标X"] = GetUnitX(boss) + CosBJ(angle) * config["路径长度"],
        ["目标Y"] = GetUnitY(boss) + SinBJ(angle) * config["路径长度"],
        ["硬直秒"] = config["施法硬直秒"],
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["动画速度"],
        ["重播动作延迟毫秒"] = 30,
        ["生效前重新面向"] = false,
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = config["施法硬直秒"],
            ["颜色ID"] = config["吟唱条颜色ID"],
            ["标题文本"] = config["吟唱条标题文本"],
            ["提示文本"] = config["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(boss, "恶魔咆哮波")
        end,
        ["on生效"] = function()
            _____521B_5EFA_5486_54EE_6CE2_5224_5B9A(context, angle)
        end
    })
end
function ____on_5DF4_5C14_624E_7F57_65AF_6076_9B54_5486_54EE_6CE2_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6076_9B54_5486_54EE_6CE2_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放巴尔扎罗斯恶魔咆哮波"](context)
end
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_0["读取单位攻击力"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.02．线段危险区")
_____521B_5EFA_7EBF_6BB5_5371_9669_533A = ____require_result_3["创建线段危险区"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_6700_9AD8_4EC7_6068_76EE_6807 = ____require_result_4["获取Boss技能最高仇恨目标"]
_____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_4["获取Boss技能随机敌对英雄"]
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_4["获取Boss技能敌对英雄列表"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
getServerTime = ____require_result_5.getServerTime
local ____require_result_6 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDWETimerDestroyEffectSafe = ____require_result_6.YDWETimerDestroyEffectSafe
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C = ____require_result_7["设置特效XYZ轴旋转"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_8["施加快速控制Buff"]
local ____require_result_9 = require("lib.扩展函数.BJ函数.12．数学函数")
CosBJ = ____require_result_9.CosBJ
SinBJ = ____require_result_9.SinBJ
local jass = require("jass.common")
local japi = require("jass.japi")
GetUnitTypeId = jass.GetUnitTypeId
GetHandleId = jass.GetHandleId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitState = jass.GetUnitState
SetUnitState = jass.SetUnitState
IsUnitType = jass.IsUnitType
UnitDamageTarget = jass.UnitDamageTarget
AddSpecialEffect = jass.AddSpecialEffect
Atan2 = jass.Atan2
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS
DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
EXSetEffectZ = japi.EXSetEffectZ
EXSetEffectSize = japi.EXSetEffectSize
BJ_RADTODEG = 57.29577951308232
_____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____6076_9B54_5486_54EE_6CE2_6280_80FDID = stringToFourCC(_____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["恶魔咆哮波"]["技能槽位"])
_____5FEB_901F_63A7_5236__51FB_6655 = 0
local _____6076_9B54_5486_54EE_6CE2_5DF2_6CE8_518C = false
____exports["注册巴尔扎罗斯恶魔咆哮波"] = function()
    if _____6076_9B54_5486_54EE_6CE2_5DF2_6CE8_518C then
        return
    end
    _____6076_9B54_5486_54EE_6CE2_5DF2_6CE8_518C = true
    _____6CE8_518CBoss_6280_80FD_58F3_76D1_542C({
        ["名称"] = "巴尔扎罗斯恶魔咆哮波",
        ["Boss单位类型ID"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6076_9B54_5486_54EE_6CE2_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_5DF4_5C14_624E_7F57_65AF_6076_9B54_5486_54EE_6CE2_751F_6548(boss, _____6076_9B54_5486_54EE_6CE2_6280_80FDID)
        end
    })
end
return ____exports
