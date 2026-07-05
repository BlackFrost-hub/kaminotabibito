--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯技能数值配置"]
local ____14_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.14．台词播放")
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放巴尔扎罗斯台词"]
local ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.16．灼热层数工具")
local _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED = ____16_FF0E_707C_70ED_5C42_6570_5DE5_5177["施加巴尔扎罗斯灼热"]
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_0["读取单位攻击力"]
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_1["造成技能伤害"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_2["启动基础施法时间线"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.02．线段危险区")
local _____521B_5EFA_7EBF_6BB5_5371_9669_533A = ____require_result_4["创建线段危险区"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_6700_9AD8_4EC7_6068_76EE_6807 = ____require_result_5["获取Boss技能最高仇恨目标"]
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_5["获取Boss技能随机敌对英雄"]
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_5["获取Boss技能敌对英雄列表"]
local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_6.addPeriodicCallback
local removePeriodicCallback = ____require_result_6.removePeriodicCallback
local getServerTime = ____require_result_6.getServerTime
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_7["施加快速控制Buff"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C = ____require_result_8["设置特效XYZ轴旋转"]
local ____require_result_9 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_9.YDWETimerDestroyEffectSafe
local ____require_result_10 = require("lib.扩展函数.BJ函数.12．数学函数")
local CosBJ = ____require_result_10.CosBJ
local SinBJ = ____require_result_10.SinBJ
local jass = require("jass.common")
local japi = require("jass.japi")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local Atan2 = jass.Atan2
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local EXSetEffectZ = japi.EXSetEffectZ
local EXSetEffectSize = japi.EXSetEffectSize
local BJ_RADTODEG = 57.29577951308232
local _____5FEB_901F_63A7_5236__51FB_6655 = 0
local _____683C_9C81_59C6_91CD_9524_4E0B_6B21Ms_8868 = {}
local _____683C_9C81_59C6_706B_5F84_4E0B_6B21Ms_8868 = {}
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____53D6_76EE_6807_5355_4F4D(context)
    local entry = _____83B7_53D6Boss_6280_80FD_6700_9AD8_4EC7_6068_76EE_6807(context["Boss单位"])
    if entry ~= nil and _____5355_4F4D_6709_6548(entry.targetRef) then
        return entry.targetRef
    end
    return _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(context["Boss单位"])
end
local function _____53D6_65B9_5411_89D2(from, to)
    if not _____5355_4F4D_6709_6548(from) or not _____5355_4F4D_6709_6548(to) then
        return 0
    end
    return Atan2(
        GetUnitY(to) - GetUnitY(from),
        GetUnitX(to) - GetUnitX(from)
    ) * BJ_RADTODEG
end
local function _____89D2_5EA6_5DEE_7EDD_5BF9_503C(a, b)
    local diff = a - b
    while diff > 180 do
        diff = diff - 360
    end
    while diff < -180 do
        diff = diff + 360
    end
    return diff >= 0 and diff or -diff
end
local function _____70B9_5230_5355_4F4D_8DDD_79BB_5E73_65B9(unit, x, y)
    local dx = GetUnitX(unit) - x
    local dy = GetUnitY(unit) - y
    return dx * dx + dy * dy
end
local function _____8BA1_7B97_706B_5F84_6301_7EED_4F24_5BB3(grum)
    return _____8BFB_53D6_5355_4F4D_653B_51FB_529B(grum) * _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩火径"]["持续伤害攻击力比例"] * _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩火径"]["伤害总倍率"]
end
local function _____8BA1_7B97_706B_5F84_7A7F_8D8A_4F24_5BB3(grum, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩火径"]
    return (_____8BFB_53D6_5355_4F4D_653B_51FB_529B(grum) * config["穿越伤害攻击力比例"] + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config["穿越伤害目标最大生命比例"]) * config["伤害总倍率"]
end
local function _____9020_6210_683C_9C81_59C6Boss_6280_80FD_4F24_5BB3(source, target, amount, _____4F24_5BB3_5F62_6001)
    if not _____5355_4F4D_6709_6548(source) or not _____5355_4F4D_6709_6548(target) or not (amount > 0) then
        return
    end
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = source,
        ["目标"] = target,
        ["伤害"] = amount,
        ranged = true,
        attackType = ATTACK_TYPE_CHAOS,
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "Boss技能",
        ["伤害形态"] = _____4F24_5BB3_5F62_6001
    })
end
local function _____64AD_653E_70B9_7279_6548(model, x, y, z, scale, duration, angle)
    local effect = AddSpecialEffect(model, x, y)
    if effect == nil or effect == 0 then
        return nil
    end
    if type(EXSetEffectZ) == "function" then
        EXSetEffectZ(effect, z)
    end
    if type(EXSetEffectSize) == "function" then
        EXSetEffectSize(effect, scale)
    end
    if angle ~= nil then
        _____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C(effect, {["Z轴角度"] = angle})
    end
    YDWETimerDestroyEffectSafe(duration, effect)
    return effect
end
____exports["格鲁姆公共"] = {
    ["巴尔扎罗斯技能数值配置"] = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E,
    ["播放巴尔扎罗斯台词"] = _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD,
    ["施加巴尔扎罗斯灼热"] = _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED,
    ["读取单位攻击力"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B,
    ["启动基础施法时间线"] = _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF,
    ["创建技能提示圈"] = _____521B_5EFA_6280_80FD_63D0_793A_5708,
    ["创建线段危险区"] = _____521B_5EFA_7EBF_6BB5_5371_9669_533A,
    ["获取Boss技能最高仇恨目标"] = _____83B7_53D6Boss_6280_80FD_6700_9AD8_4EC7_6068_76EE_6807,
    ["获取Boss技能随机敌对英雄"] = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4,
    ["获取Boss技能敌对英雄列表"] = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868,
    addPeriodicCallback = addPeriodicCallback,
    removePeriodicCallback = removePeriodicCallback,
    getServerTime = getServerTime,
    ["施加快速控制Buff"] = _____65BD_52A0_5FEB_901F_63A7_5236Buff,
    ["设置特效XYZ轴旋转"] = _____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C,
    YDWETimerDestroyEffectSafe = YDWETimerDestroyEffectSafe,
    CosBJ = CosBJ,
    SinBJ = SinBJ,
    GetHandleId = GetHandleId,
    GetUnitX = GetUnitX,
    GetUnitY = GetUnitY,
    GetUnitState = GetUnitState,
    IsUnitType = IsUnitType,
    AddSpecialEffect = AddSpecialEffect,
    Atan2 = Atan2,
    UNIT_STATE_MAX_LIFE = UNIT_STATE_MAX_LIFE,
    UNIT_TYPE_DEAD = UNIT_TYPE_DEAD,
    ATTACK_TYPE_CHAOS = ATTACK_TYPE_CHAOS,
    DAMAGE_TYPE_FIRE = DAMAGE_TYPE_FIRE,
    WEAPON_TYPE_WHOKNOWS = WEAPON_TYPE_WHOKNOWS,
    EXSetEffectZ = EXSetEffectZ,
    EXSetEffectSize = EXSetEffectSize,
    BJ_RADTODEG = BJ_RADTODEG,
    ["快速控制_击晕"] = _____5FEB_901F_63A7_5236__51FB_6655,
    ["格鲁姆重锤下次Ms表"] = _____683C_9C81_59C6_91CD_9524_4E0B_6B21Ms_8868,
    ["格鲁姆火径下次Ms表"] = _____683C_9C81_59C6_706B_5F84_4E0B_6B21Ms_8868,
    ["单位有效"] = _____5355_4F4D_6709_6548,
    ["取单位ID"] = _____53D6_5355_4F4DID,
    ["取目标单位"] = _____53D6_76EE_6807_5355_4F4D,
    ["取方向角"] = _____53D6_65B9_5411_89D2,
    ["角度差绝对值"] = _____89D2_5EA6_5DEE_7EDD_5BF9_503C,
    ["点到单位距离平方"] = _____70B9_5230_5355_4F4D_8DDD_79BB_5E73_65B9,
    ["计算火径持续伤害"] = _____8BA1_7B97_706B_5F84_6301_7EED_4F24_5BB3,
    ["计算火径穿越伤害"] = _____8BA1_7B97_706B_5F84_7A7F_8D8A_4F24_5BB3,
    ["造成格鲁姆Boss技能伤害"] = _____9020_6210_683C_9C81_59C6Boss_6280_80FD_4F24_5BB3,
    ["播放点特效"] = _____64AD_653E_70B9_7279_6548
}
return ____exports
