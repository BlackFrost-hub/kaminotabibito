--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.00．配置")
local _____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["里科特单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建里科特上下文"]
local _____5237_65B0_91CC_79D1_7279_9636_6BB5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新里科特阶段"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.02．数值与表现配置")
local _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["里科特数值与表现配置"]
local ____10_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.10．台词播放")
local _____64AD_653E_91CC_79D1_7279_53F0_8BCD = ____10_FF0E_53F0_8BCD_64AD_653E["播放里科特台词"]
local ____13_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.13．公共工具")
local _____5355_4F4D_6709_6548 = ____13_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____13_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____8DDD_79BB_5E73_65B9XY = ____13_FF0E_516C_5171_5DE5_5177["距离平方XY"]
local ____16_FF0EBoss_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．Boss技能壳监听注册器")
local _____6CE8_518CBoss_6280_80FD_58F3_76D1_542C = ____16_FF0EBoss_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册Boss技能壳监听"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ShowUnit = jass.ShowUnit
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local UnitDamageTarget = jass.UnitDamageTarget
local GetRandomInt = jass.GetRandomInt
local ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_0["读取单位攻击力"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_3["获取Boss技能随机敌对英雄"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_4["施加快速控制Buff"]
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_4["施加快速减速Buff"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．物品技能工具")
local _____65BD_52A0_7729_6655 = ____require_result_5["施加眩晕"]
local _____91CC_79D1_7279_5355_4F4D_7C7B_578BID = stringToFourCC(_____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6E6E_706D_4E4B_98CE_6280_80FDID = stringToFourCC(_____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之风"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____64AD_653E_9650_65F6_70B9_7279_6548(model, x, y, duration)
    if model == "" then
        return
    end
    local effect = AddSpecialEffect(model, x, y)
    local id = addDelayedCallback(
        duration * 1000,
        function()
            DestroyEffect(effect)
        end
    )
    if id == 0 then
        DestroyEffect(effect)
    end
end
local function _____65BD_52A0_6E6E_706D_4E4B_98CE_968F_673A_63A7_5236(boss, hero)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之风"]
    local roll = GetRandomInt(0, 2)
    if roll == 0 then
        _____65BD_52A0_7729_6655(boss, hero, cfg["随机眩晕秒"])
    elseif roll == 1 then
        _____65BD_52A0_5FEB_901F_63A7_5236Buff(boss, hero, 2, cfg["随机控制持续秒"])
    else
        _____65BD_52A0_5FEB_901F_51CF_901FBuff(
            boss,
            hero,
            cfg["随机减速比例"],
            cfg["随机减速比例"],
            cfg["随机减速秒"]
        )
    end
end
local function _____7ED3_7B97_6E6E_706D_4E4B_98CE_4E00_8DF3(data)
    local context = data.context
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or data["剩余跳数"] <= 0 then
        removePeriodicCallback(data["周期ID"])
        ShowUnit(boss, true)
        return
    end
    data["剩余跳数"] = data["剩余跳数"] - 1
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之风"]
    local bx = GetUnitX(boss)
    local by = GetUnitY(boss)
    local radius2 = cfg["半径"] * cfg["半径"]
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["Boss攻击力比例"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "圆形",
        X = bx,
        Y = by,
        ["半径"] = cfg["半径"],
        ["持续时间"] = cfg["tick秒"],
        ["来源单位"] = boss
    })
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue13
                end
                if _____8DDD_79BB_5E73_65B9XY(
                    GetUnitX(hero),
                    GetUnitY(hero),
                    bx,
                    by
                ) > radius2 then
                    goto __continue13
                end
                UnitDamageTarget(
                    boss,
                    hero,
                    damage,
                    false,
                    false,
                    ATTACK_TYPE_MAGIC,
                    DAMAGE_TYPE_MAGIC,
                    WEAPON_TYPE_WHOKNOWS
                )
                _____65BD_52A0_5FEB_901F_63A7_5236Buff(boss, hero, 2, cfg["沉默秒"])
            end
            ::__continue13::
            i = i + 1
        end
    end
    local randomHero = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss, boss, cfg["半径"])
    if _____5355_4F4D_6709_6548(randomHero) then
        _____65BD_52A0_6E6E_706D_4E4B_98CE_968F_673A_63A7_5236(boss, randomHero)
    end
end
local function _____91CA_653E_91CC_79D1_7279_6E6E_706D_4E4B_98CE(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["湮灭之风"]
    _____64AD_653E_91CC_79D1_7279_53F0_8BCD(boss, "湮灭之风")
    _____64AD_653E_9650_65F6_70B9_7279_6548(
        cfg["扩散特效路径"],
        GetUnitX(boss),
        GetUnitY(boss),
        cfg["扩散特效持续秒"]
    )
    _____64AD_653E_9650_65F6_70B9_7279_6548(
        cfg["风场特效路径"],
        GetUnitX(boss),
        GetUnitY(boss),
        cfg["风场特效持续秒"]
    )
    if _____5237_65B0_91CC_79D1_7279_9636_6BB5(context) < 3 then
        ShowUnit(boss, false)
    end
    local data = {context = context, ["剩余跳数"] = cfg["持续秒"] / cfg["tick秒"], ["周期ID"] = 0}
    data["周期ID"] = addPeriodicCallback(
        cfg["tick秒"] * 1000,
        function()
            _____7ED3_7B97_6E6E_706D_4E4B_98CE_4E00_8DF3(data)
        end
    )
    local ____self_6 = context["清理"]
    ____self_6["登记周期回调"](____self_6, "里科特-湮灭之风周期", data["周期ID"])
    local id = addDelayedCallback(
        cfg["持续秒"] * 1000,
        function()
            ShowUnit(boss, true)
            removePeriodicCallback(data["周期ID"])
        end
    )
    local ____self_7 = context["清理"]
    ____self_7["登记延迟回调"](____self_7, "里科特-湮灭之风结束", id)
end
local function ____on_91CC_79D1_7279_6E6E_706D_4E4B_98CE_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6E6E_706D_4E4B_98CE_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____91CC_79D1_7279_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    _____91CA_653E_91CC_79D1_7279_6E6E_706D_4E4B_98CE(context)
end
____exports["注册里科特湮灭之风"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518CBoss_6280_80FD_58F3_76D1_542C({
        ["名称"] = "08．湮灭之风",
        ["Boss单位类型ID"] = _____91CC_79D1_7279_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6E6E_706D_4E4B_98CE_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_91CC_79D1_7279_6E6E_706D_4E4B_98CE_65BD_6CD5(boss, _____6E6E_706D_4E4B_98CE_6280_80FDID)
        end
    })
end
return ____exports
