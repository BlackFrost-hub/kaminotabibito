--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.03．运行时上下文")
local _____83B7_53D6_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取巴尔扎罗斯上下文"]
local ____14_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.14．台词播放")
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放巴尔扎罗斯台词"]
local _____64AD_653E_683C_9C81_59C6_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放格鲁姆台词"]
local _____64AD_653E_585E_62C9_53F0_8BCD = ____14_FF0E_53F0_8BCD_64AD_653E["播放塞拉台词"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置")
local _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯护卫配置"]
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯技能数值配置"]
local _____5DF4_5C14_624E_7F57_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["巴尔扎罗斯音效配置"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_0["创建单位坐标跟随特效"]
local _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_0["销毁单位坐标跟随特效"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_1["创建召唤物"]
local ____require_result_2 = require("系统.01．单位系统.10．护卫系统.index")
local _____521B_5EFA_81EA_5B9A_4E49_62A4_536B_5355_4F4D = ____require_result_2["创建自定义护卫单位"]
local _____83B7_53D6_62A4_536B_6240_5C5EBoss = ____require_result_2["获取护卫所属Boss"]
local _____5904_7406Boss_7ED3_675F_5168_90E8_62A4_536B = ____require_result_2["处理Boss结束全部护卫"]
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_3.registerManualBuff
local getBuffRuntime = ____require_result_3.getBuffRuntime
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_3["移除单位指定Buff"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_FixUnitStandingSafe = ____require_result_4.X_FixUnitStandingSafe
local X_RestoreUnitStandingSafe = ____require_result_4.X_RestoreUnitStandingSafe
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_5.registerDeathListener
local ____require_result_6 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_6.registerDamageModifier
local ____require_result_7 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_7.addDelayedCallback
local getServerTime = ____require_result_7.getServerTime
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____62A4_536B_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local _____7194_6838_5C01_5370_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = false
local function _____521B_5EFA_683C_9C81_59C6(context)
    local cfg = _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["格鲁姆"]
    return _____521B_5EFA_81EA_5B9A_4E49_62A4_536B_5355_4F4D(
        {
            ["主Boss单位"] = context["Boss单位"],
            ["护卫类型"] = "巴尔扎罗斯:格鲁姆",
            ["护卫血条优先级"] = 200,
            ["标记为召唤单位"] = true,
            ["Boss结束处理"] = "移除"
        },
        function()
            return _____521B_5EFA_53EC_5524_7269({
                ["主人单位"] = context["Boss单位"],
                ["单位类型"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["格鲁姆"]["单位ID"],
                ["单位名称"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["格鲁姆"]["名称"],
                X = cfg.X,
                Y = cfg.Y,
                ["朝向"] = cfg["面向"],
                ["生命值"] = cfg["生命值"],
                ["生命值受小怪倍率"] = false,
                ["护甲"] = cfg["防御力"],
                ["攻击间隔"] = cfg["攻击间隔"]
            })
        end
    )
end
local function _____521B_5EFA_585E_62C9(context)
    local cfg = _____5DF4_5C14_624E_7F57_65AF_62A4_536B_914D_7F6E["塞拉"]
    return _____521B_5EFA_81EA_5B9A_4E49_62A4_536B_5355_4F4D(
        {
            ["主Boss单位"] = context["Boss单位"],
            ["护卫类型"] = "巴尔扎罗斯:塞拉",
            ["护卫血条优先级"] = 200,
            ["标记为召唤单位"] = true,
            ["Boss结束处理"] = "移除"
        },
        function()
            return _____521B_5EFA_53EC_5524_7269({
                ["主人单位"] = context["Boss单位"],
                ["单位类型"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["塞拉"]["单位ID"],
                ["单位名称"] = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["塞拉"]["名称"],
                X = cfg.X,
                Y = cfg.Y,
                ["朝向"] = cfg["面向"],
                ["生命值"] = cfg["生命值"],
                ["生命值受小怪倍率"] = false,
                ["护甲"] = cfg["防御力"],
                ["攻击间隔"] = cfg["攻击间隔"]
            })
        end
    )
end
local function _____6DFB_52A0_7194_6838_5C01_5370(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔核封印"]
    registerManualBuff(
        boss,
        _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["熔核封印"],
        999999,
        0.8,
        {sourceName = "巴尔扎罗斯"}
    )
    X_FixUnitStandingSafe(boss)
    _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
        boss,
        config["特效路径"],
        config["特效键"],
        config["特效缩放"],
        config["特效高度"],
        nil,
        config["动画索引"]
    )
    local ____self_8 = context["清理"]
    ____self_8["登记清理"](
        ____self_8,
        "巴尔扎罗斯-熔核封印特效",
        function()
            _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(boss, config["特效键"])
        end
    )
    context["熔核封印已解除"] = false
end
local function _____89E3_9664_7194_6838_5C01_5370(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["熔核封印已解除"] then
        return
    end
    context["熔核封印已解除"] = true
    _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(boss, _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔核封印"]["特效键"])
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
    local boss = _____83B7_53D6_62A4_536B_6240_5C5EBoss(dyingUnit)
    if boss == nil or boss == 0 then
        return
    end
    local context = _____83B7_53D6_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587(boss)
    if context == nil then
        return
    end
    if dyingUnit == context["格鲁姆"] then
        _____64AD_653E_683C_9C81_59C6_53F0_8BCD(dyingUnit, "死亡", 0)
        context["格鲁姆"] = nil
    end
    if dyingUnit == context["塞拉"] then
        _____64AD_653E_585E_62C9_53F0_8BCD(dyingUnit, "死亡", 0)
        context["塞拉"] = nil
    end
    if not _____53CC_62A4_536B_90FD_5DF2_6B7B_4EA1(context) then
        return
    end
    _____89E3_9664_7194_6838_5C01_5370(context)
    context["阶段"] = 2
    local bossUnit = context["Boss单位"]
    context["阶段3台词最早Ms"] = getServerTime() + 14500
    addDelayedCallback(
        6000,
        function()
            if _____5355_4F4D_6709_6548(bossUnit) then
                _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(bossUnit, "转阶段2", 0)
            end
        end
    )
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
____exports["初始化巴尔扎罗斯熔核封印与护卫机制"] = function(context, _____8DF3_8FC7_62A4_536B_521B_5EFA)
    if _____8DF3_8FC7_62A4_536B_521B_5EFA == nil then
        _____8DF3_8FC7_62A4_536B_521B_5EFA = false
    end
    if context["护卫机制已初始化"] then
        return
    end
    context["护卫机制已初始化"] = true
    _____786E_4FDD_5168_5C40_76D1_542C()
    _____6DFB_52A0_7194_6838_5C01_5370(context)
    if _____8DF3_8FC7_62A4_536B_521B_5EFA then
        return
    end
    context["格鲁姆"] = _____521B_5EFA_683C_9C81_59C6(context)
    context["塞拉"] = _____521B_5EFA_585E_62C9(context)
    local boss = context["Boss单位"]
    local ____self_9 = context["清理"]
    ____self_9["登记清理"](
        ____self_9,
        "巴尔扎罗斯-护卫登记清理",
        function()
            _____5904_7406Boss_7ED3_675F_5168_90E8_62A4_536B(boss)
        end
    )
    local grum = context["格鲁姆"]
    local sera = context["塞拉"]
    addDelayedCallback(
        7000,
        function()
            if _____5355_4F4D_6709_6548(grum) then
                _____64AD_653E_683C_9C81_59C6_53F0_8BCD(grum, "响应召令", 0)
            end
        end
    )
    addDelayedCallback(
        10300,
        function()
            if _____5355_4F4D_6709_6548(sera) then
                _____64AD_653E_585E_62C9_53F0_8BCD(sera, "响应召令", 0)
            end
        end
    )
end
____exports["注册巴尔扎罗斯熔核封印与护卫机制"] = function()
    _____786E_4FDD_5168_5C40_76D1_542C()
end
return ____exports
