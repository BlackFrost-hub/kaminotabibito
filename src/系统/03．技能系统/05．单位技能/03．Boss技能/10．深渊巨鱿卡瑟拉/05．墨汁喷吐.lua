--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.00．配置")
local _____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["卡瑟拉单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建卡瑟拉上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.02．数值与表现配置")
local _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉数值与表现配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.11．台词播放")
local _____64AD_653E_5361_745F_62C9_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放卡瑟拉台词"]
local ____14_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.14．公共工具")
local _____5355_4F4D_6709_6548 = ____14_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____14_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____53D6_5355_4F4D_95F4_89D2_5EA6 = ____14_FF0E_516C_5171_5DE5_5177["取单位间角度"]
local _____53D6_5750_6807_89D2_5EA6 = ____14_FF0E_516C_5171_5DE5_5177["取坐标角度"]
local _____8DDD_79BBXY = ____14_FF0E_516C_5171_5DE5_5177["距离XY"]
local _____89D2_5EA6_5DEE = ____14_FF0E_516C_5171_5DE5_5177["角度差"]
local _____6781_5750_6807X = ____14_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____14_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local removePeriodicCallback = ____require_result_2.removePeriodicCallback
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_4["获取Boss技能敌对英雄列表"]
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_4["获取Boss技能随机敌对英雄"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.13．属性抗性门槛")
local _____6EE1_8DB3_5C5E_6027_6297_6027_95E8_69DB = ____require_result_5["满足属性抗性门槛"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.10．战斗视野压制")
local _____65BD_52A0_6218_6597_89C6_91CE_538B_5236 = ____require_result_6["施加战斗视野压制"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_7["施加快速控制Buff"]
local ____require_result_8 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_8.registerManualBuff
local ____require_result_9 = require("系统.05．Buff系统.03．Buff表.01．Boss.08．卡瑟拉")
local _____5361_745F_62C9BuffID = ____require_result_9["卡瑟拉BuffID"]
local _____5361_745F_62C9_5355_4F4D_7C7B_578BID = stringToFourCC(_____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____58A8_6C41_55B7_5410_6280_80FDID = stringToFourCC(_____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____53D6_58A8_6C41_55B7_5410_76EE_6807(boss)
    local spellTarget = GetSpellTargetUnit()
    if _____5355_4F4D_6709_6548(spellTarget) then
        return spellTarget
    end
    return _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss, boss, 1400)
end
local function _____64AD_653E_58A8_6C41_5730_9762_7279_6548(context, x, y)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]
    local model = cfg["墨汁残留模型路径"]
    if model == "" then
        return
    end
    local effect = AddSpecialEffect(model, x, y)
    local ____self_10 = context["清理"]
    ____self_10["登记特效"](____self_10, "卡瑟拉-墨汁地面残留", effect)
    local id = addDelayedCallback(
        cfg["残留秒"] * 1000,
        function()
            DestroyEffect(effect)
        end
    )
    local ____self_11 = context["清理"]
    ____self_11["登记延迟回调"](____self_11, "卡瑟拉-墨汁残留特效销毁", id)
end
local function _____5355_4F4D_5728_58A8_6C41_6247_5F62_5185(unit, area)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]
    local ux = GetUnitX(unit)
    local uy = GetUnitY(unit)
    if _____8DDD_79BBXY(ux, uy, area["起点X"], area["起点Y"]) > cfg["扇形半径"] then
        return false
    end
    local angle = _____53D6_5750_6807_89D2_5EA6(area["起点X"], area["起点Y"], ux, uy)
    return _____89D2_5EA6_5DEE(angle, area["方向角"]) <= cfg["扇形角度"] * 0.5
end
local function _____7ED3_7B97_58A8_6C41_533A_57DF_4E00_8DF3(area)
    local boss = area.context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or area["剩余跳数"] <= 0 then
        removePeriodicCallback(area["周期ID"])
        return
    end
    area["剩余跳数"] = area["剩余跳数"] - 1
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local affected = {}
    local baseDamage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["每秒Boss攻击力比例"]
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) or not _____5355_4F4D_5728_58A8_6C41_6247_5F62_5185(hero, area) then
                    goto __continue12
                end
                local resisted = _____6EE1_8DB3_5C5E_6027_6297_6027_95E8_69DB(hero, "水", cfg["水抗门槛"], true)
                local factor = resisted and cfg["达标效果倍率"] or 1
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害"] = baseDamage * factor,
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_COLD,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能"
                })
                _____65BD_52A0_5FEB_901F_63A7_5236Buff(boss, hero, 2, cfg["tick秒"] * factor)
                registerManualBuff(
                    hero,
                    _____5361_745F_62C9BuffID["墨汁遮蔽"],
                    cfg["tick秒"] + 0.2,
                    factor,
                    {sourceName = "卡瑟拉-墨汁遮蔽"}
                )
                affected[#affected + 1] = hero
            end
            ::__continue12::
            i = i + 1
        end
    end
    if #affected > 0 then
        _____65BD_52A0_6218_6597_89C6_91CE_538B_5236({
            ["名称"] = "卡瑟拉-墨汁视野压制",
            ["来源单位"] = boss,
            ["目标列表"] = affected,
            ["持续时间"] = cfg["tick秒"] + 0.2,
            ["视野减少值"] = cfg["视野降低"],
            BuffID = _____5361_745F_62C9BuffID["墨汁遮蔽"],
            ["叠加键"] = "卡瑟拉-墨汁遮蔽"
        })
    end
end
local function _____5F00_59CB_58A8_6C41_6B8B_7559_533A_57DF(context, x, y, angle)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]
    local area = {
        context = context,
        ["起点X"] = x,
        ["起点Y"] = y,
        ["方向角"] = angle,
        ["剩余跳数"] = cfg["残留秒"] / cfg["tick秒"],
        ["周期ID"] = 0
    }
    area["周期ID"] = addPeriodicCallback(
        cfg["tick秒"] * 1000,
        function()
            _____7ED3_7B97_58A8_6C41_533A_57DF_4E00_8DF3(area)
        end
    )
    local ____self_12 = context["清理"]
    ____self_12["登记周期回调"](____self_12, "卡瑟拉-墨汁残留周期", area["周期ID"])
end
____exports["释放卡瑟拉墨汁喷吐"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local target = _____53D6_58A8_6C41_55B7_5410_76EE_6807(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["墨汁喷吐"]
    local bx = GetUnitX(boss)
    local by = GetUnitY(boss)
    local angle = _____53D6_5355_4F4D_95F4_89D2_5EA6(boss, target)
    local effectX = _____6781_5750_6807X(bx, angle, cfg["扇形半径"] * 0.45)
    local effectY = _____6781_5750_6807Y(by, angle, cfg["扇形半径"] * 0.45)
    _____64AD_653E_5361_745F_62C9_53F0_8BCD(boss, "墨汁喷吐")
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "扇形",
        X = bx,
        Y = by,
        ["半径"] = cfg["扇形半径"],
        ["角度"] = cfg["扇形角度"],
        ["朝向"] = angle,
        ["持续时间"] = cfg["持续秒"],
        ["来源单位"] = boss
    })
    _____64AD_653E_58A8_6C41_5730_9762_7279_6548(context, effectX, effectY)
    local area = {
        context = context,
        ["起点X"] = bx,
        ["起点Y"] = by,
        ["方向角"] = angle,
        ["剩余跳数"] = cfg["持续秒"] / cfg["tick秒"],
        ["周期ID"] = 0
    }
    area["周期ID"] = addPeriodicCallback(
        cfg["tick秒"] * 1000,
        function()
            _____7ED3_7B97_58A8_6C41_533A_57DF_4E00_8DF3(area)
        end
    )
    local ____self_13 = context["清理"]
    ____self_13["登记周期回调"](____self_13, "卡瑟拉-墨汁喷吐周期", area["周期ID"])
    local id = addDelayedCallback(
        cfg["持续秒"] * 1000,
        function()
            _____5F00_59CB_58A8_6C41_6B8B_7559_533A_57DF(context, bx, by, angle)
        end
    )
    local ____self_14 = context["清理"]
    ____self_14["登记延迟回调"](____self_14, "卡瑟拉-墨汁残留开始", id)
end
local function ____on_5361_745F_62C9_58A8_6C41_55B7_5410_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____58A8_6C41_55B7_5410_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5361_745F_62C9_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放卡瑟拉墨汁喷吐"](context)
end
____exports["注册卡瑟拉墨汁喷吐"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "05．墨汁喷吐",
        ["单位类型ID"] = _____5361_745F_62C9_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____58A8_6C41_55B7_5410_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_5361_745F_62C9_58A8_6C41_55B7_5410_65BD_6CD5(boss, _____58A8_6C41_55B7_5410_6280_80FDID)
        end
    })
end
return ____exports
