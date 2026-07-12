--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5355_4F4D_6709_6548, _____8BA1_7B97_55B7_53D1_4F24_5BB3, _____521B_5EFA_968F_673A_843D_70B9, _____64AD_653E_55B7_53D1_7279_6548, _____521B_5EFA_7194_5CA9_6B8B_7559_533A, _____6267_884C_7194_5CA9_55B7_53D1_7206_53D1, ____on_5DF4_5C14_624E_7F57_65AF_7194_5CA9_55B7_53D1_751F_6548, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____521B_5EFA_6301_7EED_5371_9669_533A_57DF, _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4, YDWETimerDestroyEffectSafe, CosBJ, SinBJ, _____9020_6210AOE_6280_80FD_4F24_5BB3, GetUnitTypeId, GetUnitX, GetUnitY, GetUnitState, IsUnitType, AddSpecialEffect, GetRandomReal, UNIT_STATE_MAX_LIFE, UNIT_TYPE_DEAD, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS, EXSetEffectZ, EXSetEffectSize, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID, _____7194_5CA9_55B7_53D1_6280_80FDID
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建巴尔扎罗斯上下文"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯技能数值配置"]
local _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯音效配置"]
local ____14_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.14．台词播放")
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放巴尔扎罗斯台词"]
local ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.16．灼热层数工具")
local _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED = ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177["施加巴尔扎罗斯灼热"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["延迟播放Boss坐标音效"]
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.index")
local _____5F00_59CB_539F_5730_51FB_98DE = ____index["开始原地击飞"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
function _____8BA1_7B97_55B7_53D1_4F24_5BB3(boss, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩喷发"]
    return (_____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * config["爆发伤害Boss攻击力比例"] + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config["爆发伤害目标最大生命比例"]) * config["爆发伤害总倍率"]
end
function _____521B_5EFA_968F_673A_843D_70B9(boss, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩喷发"]
    if not _____5355_4F4D_6709_6548(target) then
        return {
            X = GetUnitX(boss),
            Y = GetUnitY(boss)
        }
    end
    local angle = GetRandomReal(0, 360)
    local distance = GetRandomReal(0, config["选点偏移半径"])
    return {
        X = GetUnitX(target) + CosBJ(angle) * distance,
        Y = GetUnitY(target) + SinBJ(angle) * distance
    }
end
function _____64AD_653E_55B7_53D1_7279_6548(x, y)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩喷发"]
    local paths = {config["爆发特效路径"], config["爆发叠加特效路径"], config["爆发一次性特效路径"]}
    do
        local i = 0
        while i < #paths do
            do
                local effect = AddSpecialEffect(paths[i + 1], x, y)
                if effect == nil or effect == 0 then
                    goto __continue8
                end
                if type(EXSetEffectZ) == "function" then
                    EXSetEffectZ(effect, config["爆发特效高度"])
                end
                if type(EXSetEffectSize) == "function" then
                    EXSetEffectSize(effect, config["爆发特效缩放"])
                end
                YDWETimerDestroyEffectSafe(config["爆发特效持续秒"], effect)
            end
            ::__continue8::
            i = i + 1
        end
    end
end
function _____521B_5EFA_7194_5CA9_6B8B_7559_533A(context, x, y)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩喷发"]
    local instance = _____521B_5EFA_6301_7EED_5371_9669_533A_57DF({
        X = x,
        Y = y,
        ["半径"] = config["残留半径"],
        ["持续时间"] = config["残留持续秒"],
        ["检测间隔"] = config["残留Tick秒"],
        ["影响目标"] = "敌方",
        ["所有者"] = context["Boss单位"],
        ["模型路径"] = config["残留特效路径"],
        ["特效高度"] = config["残留特效高度"],
        ["显示提示圈"] = false,
        ["on周期"] = function(units)
            local boss = context["Boss单位"]
            if not _____5355_4F4D_6709_6548(boss) then
                return
            end
            do
                local i = 0
                while i < #units do
                    do
                        local unit = units[i + 1]
                        if not _____5355_4F4D_6709_6548(unit) then
                            goto __continue16
                        end
                        local damage = GetUnitState(unit, UNIT_STATE_MAX_LIFE) * config["残留伤害目标最大生命比例"]
                        _____9020_6210AOE_6280_80FD_4F24_5BB3({
                            ["技能ID"] = _____7194_5CA9_55B7_53D1_6280_80FDID,
                            ["来源"] = boss,
                            ["目标"] = unit,
                            ["伤害"] = damage,
                            attack = false,
                            ranged = true,
                            attackType = ATTACK_TYPE_CHAOS,
                            ["伤害类型"] = DAMAGE_TYPE_FIRE,
                            weaponType = WEAPON_TYPE_WHOKNOWS,
                            ["来源类型"] = "Boss技能"
                        })
                        _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED(unit, config["残留灼热层数"])
                    end
                    ::__continue16::
                    i = i + 1
                end
            end
        end
    })
    local ____self_8 = context["清理"]
    ____self_8["登记清理"](
        ____self_8,
        "巴尔扎罗斯-熔岩喷发残留",
        function()
            instance["销毁"](instance)
        end
    )
end
function _____6267_884C_7194_5CA9_55B7_53D1_7206_53D1(context, _____843D_70B9)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩喷发"]
    _____64AD_653E_55B7_53D1_7279_6548(_____843D_70B9.X, _____843D_70B9.Y)
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["熔岩喷发"]["地面开裂"], _____843D_70B9.X, _____843D_70B9.Y, _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
    _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548(
        _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["熔岩喷发"]["熔岩上冲"],
        _____843D_70B9.X,
        _____843D_70B9.Y,
        _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["熔岩喷发"]["熔岩上冲延迟Ms"],
        _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____5EF6_8FDF_64AD_653EBoss_5750_6807_97F3_6548(
        _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["熔岩喷发"]["最后爆裂"],
        _____843D_70B9.X,
        _____843D_70B9.Y,
        _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["熔岩喷发"]["最后爆裂延迟Ms"],
        _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    local instance = _____521B_5EFA_6301_7EED_5371_9669_533A_57DF({
        X = _____843D_70B9.X,
        Y = _____843D_70B9.Y,
        ["半径"] = config["爆发半径"],
        ["持续时间"] = config["爆发持续顶飞秒"],
        ["检测间隔"] = 0.12,
        ["影响目标"] = "敌方",
        ["所有者"] = boss,
        ["显示提示圈"] = false,
        ["on进入"] = function(unit)
            if not _____5355_4F4D_6709_6548(unit) then
                return
            end
            _____9020_6210AOE_6280_80FD_4F24_5BB3({
                ["技能ID"] = _____7194_5CA9_55B7_53D1_6280_80FDID,
                ["来源"] = boss,
                ["目标"] = unit,
                ["伤害"] = _____8BA1_7B97_55B7_53D1_4F24_5BB3(boss, unit),
                attack = false,
                ranged = true,
                attackType = ATTACK_TYPE_CHAOS,
                ["伤害类型"] = DAMAGE_TYPE_FIRE,
                weaponType = WEAPON_TYPE_WHOKNOWS,
                ["来源类型"] = "Boss技能"
            })
            _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED(unit, config["爆发灼热层数"])
            _____5F00_59CB_539F_5730_51FB_98DE(unit, {
                ["持续时间"] = config["爆发持续顶飞秒"],
                ["最小高度"] = 180,
                ["最大高度"] = 260,
                ["暂停单位"] = false,
                ["主单位"] = boss,
                ["主单位死亡时中断"] = true,
                ["中断已有跳跃"] = true,
                ["冲击波模型"] = ""
            })
        end,
        ["on销毁"] = function()
            local ____self_9 = context["清理"]
            if ____self_9["已清理"](____self_9) then
                return
            end
            _____521B_5EFA_7194_5CA9_6B8B_7559_533A(context, _____843D_70B9.X, _____843D_70B9.Y)
        end
    })
    local ____self_10 = context["清理"]
    ____self_10["登记清理"](
        ____self_10,
        "巴尔扎罗斯-熔岩喷发爆发",
        function()
            instance["销毁"](instance)
        end
    )
end
____exports["释放巴尔扎罗斯熔岩喷发"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩喷发"]
    local target = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
    local _____843D_70B9 = _____521B_5EFA_968F_673A_843D_70B9(boss, target)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "渐变圆形",
        X = _____843D_70B9.X,
        Y = _____843D_70B9.Y,
        ["半径"] = config["爆发半径"],
        ["持续时间"] = config["爆发延迟秒"],
        ["来源单位"] = boss
    })
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标X"] = _____843D_70B9.X,
        ["目标Y"] = _____843D_70B9.Y,
        ["硬直秒"] = config["爆发延迟秒"],
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = config["爆发延迟秒"],
            ["颜色ID"] = config["吟唱条颜色ID"],
            ["标题文本"] = config["吟唱条标题文本"],
            ["提示文本"] = config["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(boss, "熔岩喷发")
        end,
        ["on生效"] = function()
            _____6267_884C_7194_5CA9_55B7_53D1_7206_53D1(context, _____843D_70B9)
        end
    })
end
function ____on_5DF4_5C14_624E_7F57_65AF_7194_5CA9_55B7_53D1_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____7194_5CA9_55B7_53D1_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放巴尔扎罗斯熔岩喷发"](context)
end
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_0["读取单位攻击力"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域")
_____521B_5EFA_6301_7EED_5371_9669_533A_57DF = ____require_result_3["创建持续危险区域"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_4["获取Boss技能随机敌对英雄"]
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDWETimerDestroyEffectSafe = ____require_result_5.YDWETimerDestroyEffectSafe
local ____require_result_6 = require("lib.扩展函数.BJ函数.12．数学函数")
CosBJ = ____require_result_6.CosBJ
SinBJ = ____require_result_6.SinBJ
local ____require_result_7 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_7["造成AOE技能伤害"]
local jass = require("jass.common")
local japi = require("jass.japi")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitState = jass.GetUnitState
IsUnitType = jass.IsUnitType
AddSpecialEffect = jass.AddSpecialEffect
GetRandomReal = jass.GetRandomReal
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS
DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
EXSetEffectZ = japi.EXSetEffectZ
EXSetEffectSize = japi.EXSetEffectSize
_____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____7194_5CA9_55B7_53D1_6280_80FDID = stringToFourCC(_____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩喷发"]["技能槽位"])
local _____7194_5CA9_55B7_53D1_5DF2_6CE8_518C = false
____exports["注册巴尔扎罗斯熔岩喷发"] = function()
    if _____7194_5CA9_55B7_53D1_5DF2_6CE8_518C then
        return
    end
    _____7194_5CA9_55B7_53D1_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "巴尔扎罗斯熔岩喷发",
        ["单位类型ID"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7194_5CA9_55B7_53D1_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_5DF4_5C14_624E_7F57_65AF_7194_5CA9_55B7_53D1_751F_6548(boss, _____7194_5CA9_55B7_53D1_6280_80FDID)
        end
    })
end
return ____exports
