--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8DDD_79BB_5E73_65B9 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位间距离平方"]
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local _____5355_4F4D_5DF2_6B7B_4EA1 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位已标记死亡"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚技能数值配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.15．台词播放")
local _____64AD_653E_7C73_4E9A_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放米亚台词"]
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local _____83B7_53D6Boss_6280_80FD_4EC7_6068_76EE_6807_5217_8868 = ____require_result_1["获取Boss技能仇恨目标列表"]
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
local setThreat = ____require_result_2.setThreat
local ____require_result_3 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_3.doHeal
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitName = jass.GetUnitName
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IssueTargetOrder = jass.IssueTargetOrder
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local function _____53D6_5355_4F4D_4EC7_6068(entries, unit)
    local hid = _____53D6_5355_4F4DID(unit)
    do
        local i = 0
        while i < #entries do
            if entries[i + 1].targetHid == hid then
                return entries[i + 1].threat
            end
            i = i + 1
        end
    end
    return 0
end
local function _____53D6_76EE_6807_8150_5316_5C42_6570(context, target)
    local ____self_4 = context["腐化层数控制器"]
    return ____self_4["取层数"](____self_4, target)
end
local function _____6062_590DBoss_751F_547D(boss, ratio)
    if not _____5355_4F4D_5B58_6D3B(boss) or ratio <= 0 then
        return
    end
    doHeal({
        HealSource = boss,
        HealTarget = boss,
        HealAmount = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * ratio,
        ItemHeal = false,
        HealEffect = false
    })
end
local function _____5904_7406_65E7_6807_8BB0_6B7B_4EA1(context)
    local target = context["污染标记目标"]
    if not _____5355_4F4D_5DF2_6B7B_4EA1(target) then
        return
    end
    _____6062_590DBoss_751F_547D(context["Boss单位"], _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染标记"]["标记目标死亡恢复生命比例"])
    _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "污染标记", 2)
    context["污染标记目标"] = nil
end
local function _____9009_62E9_6C61_67D3_6807_8BB0_76EE_6807(context)
    local boss = context["Boss单位"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local highestStack = 0
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_5B58_6D3B(hero) then
                    goto __continue13
                end
                local stack = _____53D6_76EE_6807_8150_5316_5C42_6570(context, hero)
                if stack > highestStack then
                    highestStack = stack
                end
            end
            ::__continue13::
            i = i + 1
        end
    end
    if highestStack <= 0 then
        return nil
    end
    local current = context["污染标记目标"]
    if _____5355_4F4D_5B58_6D3B(current) and _____53D6_76EE_6807_8150_5316_5C42_6570(context, current) == highestStack then
        return current
    end
    local threatEntries = _____83B7_53D6Boss_6280_80FD_4EC7_6068_76EE_6807_5217_8868(boss)
    local best = nil
    local bestThreat = -1
    local bestDistance = 999999999
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_5B58_6D3B(hero) or _____53D6_76EE_6807_8150_5316_5C42_6570(context, hero) ~= highestStack then
                    goto __continue19
                end
                local threat = _____53D6_5355_4F4D_4EC7_6068(threatEntries, hero)
                local dist = _____8DDD_79BB_5E73_65B9(boss, hero)
                if best == nil or threat > bestThreat or threat == bestThreat and dist < bestDistance then
                    best = hero
                    bestThreat = threat
                    bestDistance = dist
                end
            end
            ::__continue19::
            i = i + 1
        end
    end
    return best
end
local function _____5237_65B0_6807_8BB0Buff(context, target)
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染标记"]
    registerManualBuff(
        target,
        _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E.BuffID["污染标记"],
        config["Buff持续秒"],
        config["对标记目标伤害提高"] * 100,
        {
            sourceName = GetUnitName(context["Boss单位"]),
            iconOverride = "BuffIcon\\Boss\\Mia\\pollution_mark.blp",
            effectModelOverride = "war3mapImported\\Acid Ex.mdx"
        }
    )
end
local function _____5F3A_5236_653B_51FB_6C61_67D3_6807_8BB0_76EE_6807(context, target)
    if not _____5355_4F4D_5B58_6D3B(context["Boss单位"]) or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    setThreat(context["Boss单位"], target, 1000)
    IssueTargetOrder(context["Boss单位"], "attack", target)
end
____exports["取米亚污染标记伤害倍率"] = function(context, target)
    if context["阶段"] ~= 1 then
        return 1
    end
    if not _____5355_4F4D_5B58_6D3B(target) or target ~= context["污染标记目标"] then
        return 1
    end
    return 1 + _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染标记"]["对标记目标伤害提高"]
end
____exports["刷新米亚污染标记"] = function(context, nowMs)
    _____5904_7406_65E7_6807_8BB0_6B7B_4EA1(context)
    if context["阶段"] ~= 1 then
        context["污染标记目标"] = nil
        return
    end
    local config = _____7C73_4E9A_6280_80FD_6570_503C_914D_7F6E["污染标记"]
    if nowMs - context["上次污染标记Ms"] < config["检测间隔Ms"] then
        return
    end
    context["上次污染标记Ms"] = nowMs
    local target = _____9009_62E9_6C61_67D3_6807_8BB0_76EE_6807(context)
    if not _____5355_4F4D_5B58_6D3B(target) then
        context["污染标记目标"] = nil
        return
    end
    local changed = context["污染标记目标"] ~= target
    context["污染标记目标"] = target
    _____5237_65B0_6807_8BB0Buff(context, target)
    _____5F3A_5236_653B_51FB_6C61_67D3_6807_8BB0_76EE_6807(context, target)
    if changed then
        context["上次污染标记低频台词Ms"] = nowMs
        _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "污染标记", 0)
    elseif nowMs - context["上次污染标记低频台词Ms"] >= 10000 then
        context["上次污染标记低频台词Ms"] = nowMs
        _____64AD_653E_7C73_4E9A_53F0_8BCD(context["Boss单位"], "污染标记", 1)
    end
end
return ____exports
