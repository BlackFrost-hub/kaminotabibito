local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.03．运行时上下文")
local _____83B7_53D6_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取巴尔扎罗斯上下文"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯护卫配置"]
local _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯音效配置"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_0["创建召唤物"]
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local getBuffRuntime = ____require_result_1.getBuffRuntime
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_FixUnitStandingSafe = ____require_result_2.X_FixUnitStandingSafe
local X_RestoreUnitStandingSafe = ____require_result_2.X_RestoreUnitStandingSafe
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_3.registerDeathListener
local ____require_result_4 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_4.registerDamageModifier
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____62A4_536B_5F52_5C5EBoss_8868 = {}
local _____62A4_536B_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local _____7194_6838_5C01_5370_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = false
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____767B_8BB0_62A4_536B_5F52_5C5E(context, guard)
    local id = _____53D6_5355_4F4DID(guard)
    if id == 0 then
        return
    end
    _____62A4_536B_5F52_5C5EBoss_8868[id] = context["Boss单位"]
    local ____self_5 = context["清理"]
    ____self_5["登记清理"](
        ____self_5,
        "巴尔扎罗斯-护卫归属清理",
        function()
            __TS__Delete(_____62A4_536B_5F52_5C5EBoss_8868, id)
        end
    )
end
local function _____521B_5EFA_683C_9C81_59C6(context)
    local cfg = _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["格鲁姆"]
    return _____521B_5EFA_53EC_5524_7269({
        ["主人单位"] = context["Boss单位"],
        ["单位名称"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["格鲁姆"]["名称"],
        X = cfg.X,
        Y = cfg.Y,
        ["朝向"] = cfg["面向"],
        ["模型文件"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["格鲁姆"]["模型路径"],
        ["生命值"] = cfg["生命值"],
        ["生命值受小怪倍率"] = false,
        ["护甲"] = cfg["防御力"],
        ["攻击间隔"] = cfg["攻击间隔"]
    })
end
local function _____521B_5EFA_585E_62C9(context)
    local cfg = _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["塞拉"]
    return _____521B_5EFA_53EC_5524_7269({
        ["主人单位"] = context["Boss单位"],
        ["单位名称"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["塞拉"]["名称"],
        X = cfg.X,
        Y = cfg.Y,
        ["朝向"] = cfg["面向"],
        ["模型文件"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["塞拉"]["模型路径"],
        ["生命值"] = cfg["生命值"],
        ["生命值受小怪倍率"] = false,
        ["护甲"] = cfg["防御力"],
        ["攻击间隔"] = cfg["攻击间隔"],
        ["攻击范围"] = 650,
        ["普攻弹道模型"] = "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl",
        ["普攻弹道弧度"] = 0.15,
        ["普攻弹道速度"] = 900
    })
end
local function _____6DFB_52A0_7194_6838_5C01_5370(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    registerManualBuff(
        boss,
        _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["熔核封印"],
        999999,
        0.8,
        {sourceName = "巴尔扎罗斯"}
    )
    X_FixUnitStandingSafe(boss)
    context["熔核封印已解除"] = false
end
local function _____89E3_9664_7194_6838_5C01_5370(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["熔核封印已解除"] then
        return
    end
    context["熔核封印已解除"] = true
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["熔核封印"])
    X_RestoreUnitStandingSafe(boss)
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["转阶段2"]["封印破碎"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
end
local function _____53CC_62A4_536B_90FD_5DF2_6B7B_4EA1(context)
    return not _____5355_4F4D_6709_6548(context["格鲁姆"]) and not _____5355_4F4D_6709_6548(context["塞拉"])
end
local function ____on_5DF4_5C14_624E_7F57_65AF_62A4_536B_6B7B_4EA1(dyingUnit)
    local guardId = _____53D6_5355_4F4DID(dyingUnit)
    if guardId == 0 then
        return
    end
    local boss = _____62A4_536B_5F52_5C5EBoss_8868[guardId]
    if boss == nil or boss == 0 then
        return
    end
    __TS__Delete(_____62A4_536B_5F52_5C5EBoss_8868, guardId)
    local context = _____83B7_53D6_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587(boss)
    if context == nil then
        return
    end
    if dyingUnit == context["格鲁姆"] then
        context["格鲁姆"] = nil
    end
    if dyingUnit == context["塞拉"] then
        context["塞拉"] = nil
    end
    if _____53CC_62A4_536B_90FD_5DF2_6B7B_4EA1(context) then
        _____89E3_9664_7194_6838_5C01_5370(context)
    end
end
local function ____on_7194_6838_5C01_5370_4F24_5BB3_4FEE_6B63(context)
    local target = context.target
    if not _____5355_4F4D_6709_6548(target) then
        return context.currentDamage
    end
    if getBuffRuntime(target, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["熔核封印"]) == nil then
        return context.currentDamage
    end
    return context.currentDamage * 0.2
end
local function _____786E_4FDD_5168_5C40_76D1_542C()
    if not _____62A4_536B_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____62A4_536B_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____on_5DF4_5C14_624E_7F57_65AF_62A4_536B_6B7B_4EA1)
    end
    if not _____7194_6838_5C01_5370_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C then
        _____7194_6838_5C01_5370_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = true
        registerDamageModifier(____on_7194_6838_5C01_5370_4F24_5BB3_4FEE_6B63, 40)
    end
end
____exports["初始化巴尔扎罗斯熔核封印与护卫机制"] = function(context)
    if context["护卫机制已初始化"] then
        return
    end
    context["护卫机制已初始化"] = true
    _____786E_4FDD_5168_5C40_76D1_542C()
    _____6DFB_52A0_7194_6838_5C01_5370(context)
    context["格鲁姆"] = _____521B_5EFA_683C_9C81_59C6(context)
    context["塞拉"] = _____521B_5EFA_585E_62C9(context)
    local ____self_6 = context["清理"]
    ____self_6["登记单位"](____self_6, "巴尔扎罗斯-格鲁姆", context["格鲁姆"])
    local ____self_7 = context["清理"]
    ____self_7["登记单位"](____self_7, "巴尔扎罗斯-塞拉", context["塞拉"])
    _____767B_8BB0_62A4_536B_5F52_5C5E(context, context["格鲁姆"])
    _____767B_8BB0_62A4_536B_5F52_5C5E(context, context["塞拉"])
end
____exports["注册巴尔扎罗斯熔核封印与护卫机制"] = function()
    _____786E_4FDD_5168_5C40_76D1_542C()
end
return ____exports
