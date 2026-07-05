--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5355_4F4D_6709_6548, _____8DDD_79BB_5E73_65B9XY, _____9650_5236_751F_547D_503C, _____6CBB_7597_5355_4F4D, _____8BA1_7B97_5929_7F5A_534A_5F84, _____8BA1_7B97_5929_7F5A_4F24_5BB3, _____64AD_653E_5929_7F5A_7206_70B8_7279_6548, _____8BB0_5F55_5929_7F5A_73A9_5BB6_547D_4E2D, _____6536_96C6_5929_7F5A_547D_4E2D_5019_9009, _____662F_62A4_536B, _____89E6_53D1_5929_7F5A_6CE2_6B21, _____521B_5EFA_5929_7F5A_6CE2_6B21_5217_8868, ____on_5DF4_5C14_624E_7F57_65AF_738B_8005_5929_7F5A_751F_6548, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____521B_5EFA_591A_6CE2_5EF6_8FDFAOE, _____65BD_52A0_5355_4F53_653B_51FB_529B_63D0_9AD8Buff, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, YDWETimerDestroyEffectSafe, _____9020_6210AOE_6280_80FD_4F24_5BB3, GetUnitTypeId, GetUnitX, GetUnitY, GetUnitState, SetUnitState, IsUnitType, AddSpecialEffect, GetHandleId, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, UNIT_TYPE_DEAD, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS, EXSetEffectZ, EXSetEffectSize, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID, _____738B_8005_5929_7F5A_6280_80FDID
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建巴尔扎罗斯上下文"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯技能数值配置"]
local ____14_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.14．台词播放")
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放巴尔扎罗斯台词"]
local ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.16．灼热层数工具")
local _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED = ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177["施加巴尔扎罗斯灼热"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
function _____8DDD_79BB_5E73_65B9XY(unit, x, y)
    local dx = GetUnitX(unit) - x
    local dy = GetUnitY(unit) - y
    return dx * dx + dy * dy
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
function _____8BA1_7B97_5929_7F5A_534A_5F84(context)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["王者天罚"]
    if context["阶段"] >= 2 then
        return config["基础半径"] * config["第二阶段半径倍率"]
    end
    return config["基础半径"]
end
function _____8BA1_7B97_5929_7F5A_4F24_5BB3(boss, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["王者天罚"]
    return (_____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * config["伤害Boss攻击力比例"] + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config["伤害目标最大生命比例"]) * config["伤害总倍率"]
end
function _____64AD_653E_5929_7F5A_7206_70B8_7279_6548(x, y)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["王者天罚"]
    local effect = AddSpecialEffect(config["爆炸特效路径"], x, y)
    if effect == nil or effect == 0 then
        return
    end
    if type(EXSetEffectZ) == "function" then
        EXSetEffectZ(effect, config["爆炸特效高度"])
    end
    if type(EXSetEffectSize) == "function" then
        EXSetEffectSize(effect, config["爆炸特效缩放"])
    end
    YDWETimerDestroyEffectSafe(config["爆炸特效持续秒"], effect)
end
function _____8BB0_5F55_5929_7F5A_73A9_5BB6_547D_4E2D(context, target)
    local hid = GetHandleId(target) or 0
    if hid == 0 then
        return
    end
    context["王者天罚命中记录"][hid] = (context["王者天罚命中记录"][hid] or 0) + 1
    if context["王者天罚命中记录"][hid] >= 3 then
        _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED(target, _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["王者天罚"]["连续三波灼热层数"])
        context["王者天罚命中记录"][hid] = 0
    end
end
function _____6536_96C6_5929_7F5A_547D_4E2D_5019_9009(context)
    local result = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    if _____5355_4F4D_6709_6548(context["格鲁姆"]) then
        result[#result + 1] = context["格鲁姆"]
    end
    if _____5355_4F4D_6709_6548(context["塞拉"]) then
        result[#result + 1] = context["塞拉"]
    end
    if _____5355_4F4D_6709_6548(context["Boss单位"]) then
        result[#result + 1] = context["Boss单位"]
    end
    return result
end
function _____662F_62A4_536B(context, unit)
    return unit == context["格鲁姆"] or unit == context["塞拉"]
end
function _____89E6_53D1_5929_7F5A_6CE2_6B21(context, _____6CE2_6B21)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    _____64AD_653E_5929_7F5A_7206_70B8_7279_6548(_____6CE2_6B21.X, _____6CE2_6B21.Y)
    local radius2 = _____6CE2_6B21["半径"] * _____6CE2_6B21["半径"]
    local candidates = _____6536_96C6_5929_7F5A_547D_4E2D_5019_9009(context)
    do
        local i = 0
        while i < #candidates do
            do
                local unit = candidates[i + 1]
                if not _____5355_4F4D_6709_6548(unit) or _____8DDD_79BB_5E73_65B9XY(unit, _____6CE2_6B21.X, _____6CE2_6B21.Y) > radius2 then
                    goto __continue27
                end
                if unit == boss then
                    _____6CBB_7597_5355_4F4D(
                        boss,
                        GetUnitState(boss, UNIT_STATE_MAX_LIFE) * _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["王者天罚"]["命中自身治疗最大生命比例"]
                    )
                elseif _____662F_62A4_536B(context, unit) then
                    _____65BD_52A0_5355_4F53_653B_51FB_529B_63D0_9AD8Buff(
                        boss,
                        unit,
                        {
                            ["持续时间"] = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["王者天罚"]["护卫命中增攻持续秒"],
                            ["攻击力"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(unit) * _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["王者天罚"]["护卫命中增攻比例"]
                        }
                    )
                else
                    _____9020_6210AOE_6280_80FD_4F24_5BB3({
                        ["技能ID"] = _____738B_8005_5929_7F5A_6280_80FDID,
                        ["来源"] = boss,
                        ["目标"] = unit,
                        ["伤害"] = _____8BA1_7B97_5929_7F5A_4F24_5BB3(boss, unit),
                        attack = false,
                        ranged = true,
                        attackType = ATTACK_TYPE_CHAOS,
                        ["伤害类型"] = DAMAGE_TYPE_FIRE,
                        weaponType = WEAPON_TYPE_WHOKNOWS,
                        ["来源类型"] = "Boss技能"
                    })
                    _____8BB0_5F55_5929_7F5A_73A9_5BB6_547D_4E2D(context, unit)
                end
            end
            ::__continue27::
            i = i + 1
        end
    end
end
function _____521B_5EFA_5929_7F5A_6CE2_6B21_5217_8868(context)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["王者天罚"]
    local radius = _____8BA1_7B97_5929_7F5A_534A_5F84(context)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    local waves = {}
    do
        local h = 0
        while h < #heroes do
            do
                local hero = heroes[h + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue34
                end
                do
                    local i = 0
                    while i < #config["波次延迟秒"] do
                        waves[#waves + 1] = {
                            X = GetUnitX(hero),
                            Y = GetUnitY(hero),
                            ["半径"] = radius,
                            ["延迟秒"] = config["波次延迟秒"][i + 1]
                        }
                        i = i + 1
                    end
                end
            end
            ::__continue34::
            h = h + 1
        end
    end
    return waves
end
____exports["释放巴尔扎罗斯王者天罚"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["王者天罚"]
    local waves = _____521B_5EFA_5929_7F5A_6CE2_6B21_5217_8868(context)
    if #waves <= 0 then
        return
    end
    context["王者天罚命中记录"] = {}
    _____521B_5EFA_591A_6CE2_5EF6_8FDFAOE({
        ["清理"] = context["清理"],
        ["名称"] = "巴尔扎罗斯-王者天罚",
        ["波次列表"] = waves,
        ["on触发"] = function(_____6CE2_6B21)
            _____89E6_53D1_5929_7F5A_6CE2_6B21(context, _____6CE2_6B21)
        end
    })
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["硬直秒"] = config["施法硬直秒"],
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "大招",
            ["总时长"] = config["施法硬直秒"],
            ["颜色ID"] = config["吟唱条颜色ID"],
            ["标题文本"] = config["吟唱条标题文本"],
            ["提示文本"] = config["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(boss, "王者天罚")
        end,
        ["on生效"] = function()
        end
    })
end
function ____on_5DF4_5C14_624E_7F57_65AF_738B_8005_5929_7F5A_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____738B_8005_5929_7F5A_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放巴尔扎罗斯王者天罚"](context)
end
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_0["读取单位攻击力"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.03．多波延迟AOE")
_____521B_5EFA_591A_6CE2_5EF6_8FDFAOE = ____require_result_2["创建多波延迟AOE"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.02．攻击力提高")
_____65BD_52A0_5355_4F53_653B_51FB_529B_63D0_9AD8Buff = ____require_result_3["施加单体攻击力提高Buff"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_4["获取Boss技能敌对英雄列表"]
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDWETimerDestroyEffectSafe = ____require_result_5.YDWETimerDestroyEffectSafe
local ____require_result_6 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_6["造成AOE技能伤害"]
local jass = require("jass.common")
local japi = require("jass.japi")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitState = jass.GetUnitState
SetUnitState = jass.SetUnitState
IsUnitType = jass.IsUnitType
AddSpecialEffect = jass.AddSpecialEffect
GetHandleId = jass.GetHandleId
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS
DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
EXSetEffectZ = japi.EXSetEffectZ
EXSetEffectSize = japi.EXSetEffectSize
_____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____738B_8005_5929_7F5A_6280_80FDID = stringToFourCC(_____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["王者天罚"]["技能槽位"])
local _____738B_8005_5929_7F5A_5DF2_6CE8_518C = false
____exports["注册巴尔扎罗斯王者天罚"] = function()
    if _____738B_8005_5929_7F5A_5DF2_6CE8_518C then
        return
    end
    _____738B_8005_5929_7F5A_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "巴尔扎罗斯王者天罚",
        ["单位类型ID"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____738B_8005_5929_7F5A_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_5DF4_5C14_624E_7F57_65AF_738B_8005_5929_7F5A_751F_6548(boss, _____738B_8005_5929_7F5A_6280_80FDID)
        end
    })
end
return ____exports
