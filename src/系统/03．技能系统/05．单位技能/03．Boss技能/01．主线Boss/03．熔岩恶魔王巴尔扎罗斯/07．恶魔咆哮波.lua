--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____53D6_76EE_6807_5355_4F4D, _____53D6_65B9_5411_89D2, _____662F_5DF4_5C14_624E_7F57_65AF_62A4_536B, _____6536_96C6_5486_54EE_6CE2_5019_9009_5355_4F4D, _____6CBB_7597_5355_4F4D, _____8BA1_7B97_5486_54EE_6CE2_4F24_5BB3, _____8BB0_5F55_5486_54EE_6CE2_73A9_5BB6_547D_4E2D, _____64AD_653E_6076_9B54_5486_54EE_6CE2_84C4_529B_7279_6548, _____64AD_653E_6076_9B54_5486_54EE_6CE2_51B2_51FB_7279_6548, _____521B_5EFA_5486_54EE_6CE2_9884_8B66, _____6267_884C_5486_54EE_6CE2_547D_4E2D, _____521B_5EFA_5486_54EE_6CE2_5224_5B9A, ____on_5DF4_5C14_624E_7F57_65AF_6076_9B54_5486_54EE_6CE2_751F_6548, _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____521B_5EFA_7EBF_6BB5_5371_9669_533A, _____83B7_53D6Boss_6280_80FD_6700_9AD8_4EC7_6068_76EE_6807, _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, getServerTime, _____521B_5EFA_70B9_7279_6548, _____65BD_52A0_5FEB_901F_63A7_5236Buff, CosBJ, SinBJ, _____9020_6210AOE_6280_80FD_4F24_5BB3, _____83B7_53D6Boss_62A4_536B_5217_8868, _____662F_5426_6307_5B9ABoss_62A4_536B, doHeal, GetUnitStateJapi, GetUnitTypeId, GetHandleId, GetUnitX, GetUnitY, Atan2, UNIT_STATE_MAX_LIFE, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS, BJ_RADTODEG, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID, _____6076_9B54_5486_54EE_6CE2_6280_80FDID, _____5FEB_901F_63A7_5236__51FB_6655
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建巴尔扎罗斯上下文"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯技能数值配置"]
local _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯音效配置"]
local ____14_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.14．台词播放")
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放巴尔扎罗斯台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
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
    return _____662F_5426_6307_5B9ABoss_62A4_536B(unit, context["Boss单位"])
end
function _____6536_96C6_5486_54EE_6CE2_5019_9009_5355_4F4D(context)
    local result = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    local guards = _____83B7_53D6Boss_62A4_536B_5217_8868(context["Boss单位"], true)
    do
        local i = 0
        while i < #guards do
            result[#result + 1] = guards[i + 1]
            i = i + 1
        end
    end
    return result
end
function _____6CBB_7597_5355_4F4D(source, unit, amount)
    if not _____5355_4F4D_6709_6548(unit) or amount <= 0 then
        return
    end
    doHeal({
        HealSource = source,
        HealTarget = unit,
        HealAmount = amount,
        ItemHeal = false,
        HealEffect = false
    })
end
function _____8BA1_7B97_5486_54EE_6CE2_4F24_5BB3(boss, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["恶魔咆哮波"]
    return _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, target, {["来源攻击力比例"] = config["伤害Boss攻击力比例"], ["目标最大生命比例"] = config["伤害目标最大生命比例"], ["总倍率"] = config["伤害总倍率"]})
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
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = config["聚火特效路径"],
        X = x,
        Y = y,
        Z = config["聚火特效高度"],
        ["缩放"] = config["聚火特效缩放"],
        ["Z轴角度"] = angle,
        ["持续秒"] = config["聚火特效持续秒"]
    })
end
function _____64AD_653E_6076_9B54_5486_54EE_6CE2_51B2_51FB_7279_6548(boss, angle)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["恶魔咆哮波"]
    local x = GetUnitX(boss) + CosBJ(angle) * config["冲击特效前移"]
    local y = GetUnitY(boss) + SinBJ(angle) * config["冲击特效前移"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = config["冲击特效路径"],
        X = x,
        Y = y,
        Z = config["冲击特效高度"],
        ["缩放"] = config["冲击特效缩放"],
        ["X轴角度"] = config["冲击特效X轴旋转角度"],
        ["Y轴角度"] = config["冲击特效Y轴旋转角度"],
        ["Z轴角度"] = angle + config["冲击特效朝向修正角度"],
        ["持续秒"] = config["冲击特效持续秒"]
    })
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
            boss,
            unit,
            GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) * _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["恶魔咆哮波"]["护卫命中治疗最大生命比例"]
        )
        return
    end
    _____9020_6210AOE_6280_80FD_4F24_5BB3({
        ["技能ID"] = _____6076_9B54_5486_54EE_6CE2_6280_80FDID,
        ["来源"] = boss,
        ["目标"] = unit,
        ["伤害"] = _____8BA1_7B97_5486_54EE_6CE2_4F24_5BB3(boss, unit),
        attack = false,
        ranged = true,
        attackType = ATTACK_TYPE_CHAOS,
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "Boss技能"
    })
    _____8BB0_5F55_5486_54EE_6CE2_73A9_5BB6_547D_4E2D(context, unit)
end
function _____521B_5EFA_5486_54EE_6CE2_5224_5B9A(context, angle)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["恶魔咆哮波"]
    local boss = context["Boss单位"]
    _____64AD_653E_6076_9B54_5486_54EE_6CE2_51B2_51FB_7279_6548(boss, angle)
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["恶魔咆哮波"]["发射"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
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
        ["提示圈"] = {["类型"] = "方向直线", ["来源单位"] = boss},
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
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
_____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____require_result_0["计算组合技能伤害"]
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
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_6["创建点特效"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_7["施加快速控制Buff"]
local ____require_result_8 = require("lib.扩展函数.BJ函数.12．数学函数")
CosBJ = ____require_result_8.CosBJ
SinBJ = ____require_result_8.SinBJ
local ____require_result_9 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_9["造成AOE技能伤害"]
local ____require_result_10 = require("系统.01．单位系统.10．护卫系统.index")
_____83B7_53D6Boss_62A4_536B_5217_8868 = ____require_result_10["获取Boss护卫列表"]
_____662F_5426_6307_5B9ABoss_62A4_536B = ____require_result_10["是否指定Boss护卫"]
local ____require_result_11 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
doHeal = ____require_result_11.doHeal
local jass = require("jass.common")
local japi = require("jass.japi")
GetUnitStateJapi = japi.GetUnitState
GetUnitTypeId = jass.GetUnitTypeId
GetHandleId = jass.GetHandleId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
Atan2 = jass.Atan2
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS
DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local EXSetEffectZ = japi.EXSetEffectZ
local EXSetEffectSize = japi.EXSetEffectSize
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
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "巴尔扎罗斯恶魔咆哮波",
        ["单位类型ID"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6076_9B54_5486_54EE_6CE2_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_5DF4_5C14_624E_7F57_65AF_6076_9B54_5486_54EE_6CE2_751F_6548(boss, _____6076_9B54_5486_54EE_6CE2_6280_80FDID)
        end
    })
end
return ____exports
