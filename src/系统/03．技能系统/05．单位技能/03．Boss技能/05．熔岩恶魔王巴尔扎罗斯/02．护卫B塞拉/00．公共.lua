--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯技能数值配置"]
local ____14_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.14．台词播放")
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放巴尔扎罗斯台词"]
local ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.16．灼热层数工具")
local _____83B7_53D6_5DF4_5C14_624E_7F57_65AF_707C_70ED_5C42_6570 = ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177["获取巴尔扎罗斯灼热层数"]
local _____51CF_5C11_5DF4_5C14_624E_7F57_65AF_707C_70ED_5C42_6570 = ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177["减少巴尔扎罗斯灼热层数"]
local _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED = ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177["施加巴尔扎罗斯灼热"]
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_0["读取单位攻击力"]
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_1["造成技能伤害"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_2["启动基础施法时间线"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_4["施加快速减速Buff"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_5["创建原生弹幕"]
local ____require_result_6 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_6["获取Boss技能随机敌对英雄"]
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_6["获取Boss技能敌对英雄列表"]
local ____require_result_7 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_7.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_7["移除单位指定Buff"]
local ____require_result_8 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_8.registerDamageModifier
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_9["创建点特效"]
local _____521B_5EFA_5FAA_73AF_70B9_7279_6548 = ____require_result_9["创建循环点特效"]
local _____505C_6B62_5FAA_73AF_70B9_7279_6548 = ____require_result_9["停止循环点特效"]
local ____require_result_10 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_10.getUnitsInRange
local ____require_result_11 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_11.isUnitEnemy
local ____require_result_12 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_12.addPeriodicCallback
local removePeriodicCallback = ____require_result_12.removePeriodicCallback
local getServerTime = ____require_result_12.getServerTime
local ____require_result_13 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_13.CosBJ
local SinBJ = ____require_result_13.SinBJ
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local IsUnitType = jass.IsUnitType
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local Atan2 = jass.Atan2
local SquareRoot = jass.SquareRoot
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local BJ_RADTODEG = 57.29577951308232
local _____585E_62C9_51B0_7130_53CC_661F_4E0B_6B21Ms_8868 = {}
local _____585E_62C9_7EDD_5BF9_96F6_5EA6_4E0B_6B21Ms_8868 = {}
local _____585E_62C9_5143_7D20_8F6C_6362_4E0B_6B21Ms_8868 = {}
local _____585E_62C9_5FD9_788C_5230Ms_8868 = {}
local _____585E_62C9_5F62_6001_8868 = {}
local _____96F6_5EA6_9886_57DF_51CF_4F24_5230_671FMs_8868 = {}
local _____7EDD_5BF9_96F6_5EA6_9886_57DF_72B6_6001_8868 = {}
local _____5F31_8FFD_8E2A_5F39_4F53_72B6_6001_8868 = {}
local _____585E_62C9_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = false
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____53D6_65B9_5411_89D2(fromX, fromY, toX, toY)
    return Atan2(toY - fromY, toX - fromX) * BJ_RADTODEG
end
local function _____70B9_8DDD_79BB_5E73_65B9(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return dx * dx + dy * dy
end
local function _____70B9_5728_5706_5185(x, y, cx, cy, radius)
    return _____70B9_8DDD_79BB_5E73_65B9(x, y, cx, cy) <= radius * radius
end
local function _____53D6_585E_62C9_5F62_6001(context)
    if context["塞拉当前形态"] == "冰霜" then
        return "冰霜"
    end
    return "火焰"
end
local function _____53D6_5F62_6001_6280_80FD_500D_7387(context, _____7C7B_578B)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["元素转换"]
    local _____5F53_524D = _____53D6_585E_62C9_5F62_6001(context)
    if _____5F53_524D == "火焰" and _____7C7B_578B == "火焰" then
        return 1 + config["火焰形态技能伤害加成"]
    end
    if _____5F53_524D == "冰霜" and _____7C7B_578B == "冰霜" then
        return 1 + config["冰霜形态技能伤害加成"]
    end
    return 1
end
local function _____76EE_6807_5728_7EDD_5BF9_96F6_5EA6_9886_57DF_5185(sera, target)
    if not _____5355_4F4D_6709_6548(target) then
        return false
    end
    local _____72B6_6001 = _____7EDD_5BF9_96F6_5EA6_9886_57DF_72B6_6001_8868[_____53D6_5355_4F4DID(sera)]
    if _____72B6_6001 == nil or getServerTime() >= _____72B6_6001["结束Ms"] then
        return false
    end
    return _____70B9_5728_5706_5185(
        GetUnitX(target),
        GetUnitY(target),
        _____72B6_6001.X,
        _____72B6_6001.Y,
        _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["绝对零度领域"]["半径"]
    )
end
local function _____53D6_6700_9AD8_707C_70ED_82F1_96C4(context, _____53EA_53D6_9886_57DF_5185)
    local sera = context["塞拉"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    local best = nil
    local bestStack = -1
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue18
                end
                if _____53EA_53D6_9886_57DF_5185 and not _____76EE_6807_5728_7EDD_5BF9_96F6_5EA6_9886_57DF_5185(sera, hero) then
                    goto __continue18
                end
                local stack = _____83B7_53D6_5DF4_5C14_624E_7F57_65AF_707C_70ED_5C42_6570(hero)
                if stack > bestStack then
                    best = hero
                    bestStack = stack
                end
            end
            ::__continue18::
            i = i + 1
        end
    end
    return best
end
local function _____53D6_585E_62C9_6280_80FD_76EE_6807(context)
    local fieldTarget = _____53D6_6700_9AD8_707C_70ED_82F1_96C4(context, true)
    if _____5355_4F4D_6709_6548(fieldTarget) then
        return fieldTarget
    end
    local scorched = _____53D6_6700_9AD8_707C_70ED_82F1_96C4(context, false)
    if _____5355_4F4D_6709_6548(scorched) then
        return scorched
    end
    return _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(context["Boss单位"])
end
local function _____8BA1_7B97_51B0_7130_76EE_6807_4F4D_7F6E(context, target)
    local sera = context["塞拉"]
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["绝对零度领域"]
    if not _____5355_4F4D_6709_6548(sera) or not _____5355_4F4D_6709_6548(target) then
        return {
            X = _____5355_4F4D_6709_6548(sera) and GetUnitX(sera) or 0,
            Y = _____5355_4F4D_6709_6548(sera) and GetUnitY(sera) or 0
        }
    end
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    local dx = GetUnitX(sera) - targetX
    local dy = GetUnitY(sera) - targetY
    local distance = SquareRoot(dx * dx + dy * dy)
    if distance <= 1 then
        return {X = targetX, Y = targetY}
    end
    return {X = targetX + dx / distance * config["目标附近偏移"], Y = targetY + dy / distance * config["目标附近偏移"]}
end
local function _____521B_5EFA_585E_62C9_70B9_7279_6548(_____6A21_578B_8DEF_5F84, x, y, z, scale, duration)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____6A21_578B_8DEF_5F84,
        X = x,
        Y = y,
        Z = z,
        ["缩放"] = scale,
        ["持续秒"] = duration
    })
end
local function _____9020_6210_585E_62C9Boss_6280_80FD_4F24_5BB3(source, target, amount, damageType, _____4F24_5BB3_5F62_6001)
    if not _____5355_4F4D_6709_6548(source) or not _____5355_4F4D_6709_6548(target) or not (amount > 0) then
        return
    end
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = source,
        ["目标"] = target,
        ["伤害"] = amount,
        ranged = true,
        attackType = ATTACK_TYPE_CHAOS,
        ["伤害类型"] = damageType,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "Boss技能",
        ["伤害形态"] = _____4F24_5BB3_5F62_6001
    })
end
____exports["塞拉公共"] = {
    ["巴尔扎罗斯单位技能配置"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E,
    ["巴尔扎罗斯技能数值配置"] = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E,
    ["播放巴尔扎罗斯台词"] = _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD,
    ["获取巴尔扎罗斯灼热层数"] = _____83B7_53D6_5DF4_5C14_624E_7F57_65AF_707C_70ED_5C42_6570,
    ["减少巴尔扎罗斯灼热层数"] = _____51CF_5C11_5DF4_5C14_624E_7F57_65AF_707C_70ED_5C42_6570,
    ["施加巴尔扎罗斯灼热"] = _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED,
    ["读取单位攻击力"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B,
    ["启动基础施法时间线"] = _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF,
    ["创建技能提示圈"] = _____521B_5EFA_6280_80FD_63D0_793A_5708,
    ["施加快速减速Buff"] = _____65BD_52A0_5FEB_901F_51CF_901FBuff,
    ["创建原生弹幕"] = _____521B_5EFA_539F_751F_5F39_5E55,
    ["获取Boss技能随机敌对英雄"] = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4,
    ["获取Boss技能敌对英雄列表"] = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868,
    registerManualBuff = registerManualBuff,
    ["移除单位指定Buff"] = _____79FB_9664_5355_4F4D_6307_5B9ABuff,
    registerDamageModifier = registerDamageModifier,
    ["创建点特效"] = _____521B_5EFA_70B9_7279_6548,
    ["创建循环点特效"] = _____521B_5EFA_5FAA_73AF_70B9_7279_6548,
    ["停止循环点特效"] = _____505C_6B62_5FAA_73AF_70B9_7279_6548,
    getUnitsInRange = getUnitsInRange,
    isUnitEnemy = isUnitEnemy,
    addPeriodicCallback = addPeriodicCallback,
    removePeriodicCallback = removePeriodicCallback,
    getServerTime = getServerTime,
    CosBJ = CosBJ,
    SinBJ = SinBJ,
    GetHandleId = GetHandleId,
    GetUnitX = GetUnitX,
    GetUnitY = GetUnitY,
    GetUnitState = GetUnitState,
    GetUnitFlyHeight = GetUnitFlyHeight,
    IsUnitType = IsUnitType,
    SetUnitAnimationByIndex = SetUnitAnimationByIndex,
    SetUnitTimeScale = SetUnitTimeScale,
    Atan2 = Atan2,
    SquareRoot = SquareRoot,
    UNIT_STATE_MAX_LIFE = UNIT_STATE_MAX_LIFE,
    UNIT_TYPE_DEAD = UNIT_TYPE_DEAD,
    ATTACK_TYPE_CHAOS = ATTACK_TYPE_CHAOS,
    DAMAGE_TYPE_FIRE = DAMAGE_TYPE_FIRE,
    DAMAGE_TYPE_COLD = DAMAGE_TYPE_COLD,
    WEAPON_TYPE_WHOKNOWS = WEAPON_TYPE_WHOKNOWS,
    BJ_RADTODEG = BJ_RADTODEG,
    ["塞拉冰焰双星下次Ms表"] = _____585E_62C9_51B0_7130_53CC_661F_4E0B_6B21Ms_8868,
    ["塞拉绝对零度下次Ms表"] = _____585E_62C9_7EDD_5BF9_96F6_5EA6_4E0B_6B21Ms_8868,
    ["塞拉元素转换下次Ms表"] = _____585E_62C9_5143_7D20_8F6C_6362_4E0B_6B21Ms_8868,
    ["塞拉忙碌到Ms表"] = _____585E_62C9_5FD9_788C_5230Ms_8868,
    ["塞拉形态表"] = _____585E_62C9_5F62_6001_8868,
    ["零度领域减伤到期Ms表"] = _____96F6_5EA6_9886_57DF_51CF_4F24_5230_671FMs_8868,
    ["绝对零度领域状态表"] = _____7EDD_5BF9_96F6_5EA6_9886_57DF_72B6_6001_8868,
    ["弱追踪弹体状态表"] = _____5F31_8FFD_8E2A_5F39_4F53_72B6_6001_8868,
    ["单位有效"] = _____5355_4F4D_6709_6548,
    ["取单位ID"] = _____53D6_5355_4F4DID,
    ["取方向角"] = _____53D6_65B9_5411_89D2,
    ["点距离平方"] = _____70B9_8DDD_79BB_5E73_65B9,
    ["点在圆内"] = _____70B9_5728_5706_5185,
    ["取塞拉形态"] = _____53D6_585E_62C9_5F62_6001,
    ["取形态技能倍率"] = _____53D6_5F62_6001_6280_80FD_500D_7387,
    ["目标在绝对零度领域内"] = _____76EE_6807_5728_7EDD_5BF9_96F6_5EA6_9886_57DF_5185,
    ["取最高灼热英雄"] = _____53D6_6700_9AD8_707C_70ED_82F1_96C4,
    ["取塞拉技能目标"] = _____53D6_585E_62C9_6280_80FD_76EE_6807,
    ["计算冰焰目标位置"] = _____8BA1_7B97_51B0_7130_76EE_6807_4F4D_7F6E,
    ["创建塞拉点特效"] = _____521B_5EFA_585E_62C9_70B9_7279_6548,
    ["造成塞拉Boss技能伤害"] = _____9020_6210_585E_62C9Boss_6280_80FD_4F24_5BB3
}
return ____exports
