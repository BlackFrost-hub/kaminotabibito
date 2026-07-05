--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.01．运行时上下文")
local _____589E_52A0_73A9_5BB6_8150_8D25_503C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["增加玩家腐败值"]
local _____6E05_9664_73A9_5BB6_8150_8D25_503C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["清除玩家腐败值"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local ____13_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.13．台词播放")
local _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD = ____13_FF0E_53F0_8BCD_64AD_653E["播放莫尔特斯台词"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local jass = require("jass.common")
local AddSpecialEffect = jass.AddSpecialEffect
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomInt = jass.GetRandomInt
local Location = jass.Location
local RemoveLocation = jass.RemoveLocation
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_3["施加快速减速Buff"]
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_5.addDelayedCallback
local ____require_result_6 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_6["读取单位攻击力"]
local ____require_result_7 = require("系统.05．Buff系统.03．Buff表.01．Boss.09．莫尔特斯")
local _____83AB_5C14_7279_65AFBuffID = ____require_result_7["莫尔特斯BuffID"]
local ____require_result_8 = require("lib.扩展函数.BJ函数.11．贴图函数")
local CreateUbersplatBJ = ____require_result_8.CreateUbersplatBJ
local ShowUbersplatBJ = ____require_result_8.ShowUbersplatBJ
local _____8150_673D_9886_57DF_6839_987B_5EF6_8FDF_4E0A_4E0B_6587 = nil
local function _____521B_5EFA_8150_673D_9886_57DF_6CBC_6CFD_5730_8868(context)
    local grid = context["根须宫格"]
    if grid == nil then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽领域"]
    local color = cfg["沼泽贴图颜色"]
    do
        local i = 0
        while i < grid["格子列表"].length do
            do
                local cell = grid["格子列表"][i]
                if cell == nil then
                    goto __continue5
                end
                local loc = Location(cell["中心X"], cell["中心Y"])
                local ubersplat = CreateUbersplatBJ(
                    cfg["沼泽贴图类型"],
                    loc,
                    color.r,
                    color.g,
                    color.b,
                    color.a,
                    cfg["沼泽贴图强制暂停"],
                    cfg["沼泽贴图无出生时间"]
                )
                RemoveLocation(loc)
                if ubersplat == nil or ubersplat == 0 then
                    goto __continue5
                end
                ShowUbersplatBJ(true, ubersplat)
                local ____self_9 = context["清理"]
                ____self_9["登记贴图"](____self_9, "莫尔特斯-腐朽领域沼泽", ubersplat)
            end
            ::__continue5::
            i = i + 1
        end
    end
end
local function _____521B_5EFA_51C0_5316_7B26_6587(context)
    local grid = context["根须宫格"]
    if grid == nil then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽领域"]
    local cells = {
        grid["获取格子"](grid, 0, 0),
        grid["获取格子"](grid, 0, 2),
        grid["获取格子"](grid, 2, 0),
        grid["获取格子"](grid, 2, 2)
    }
    do
        local i = 0
        while i < cfg["净化符文数量"] and i < #cells do
            do
                local cell = cells[i + 1]
                if cell == nil then
                    goto __continue11
                end
                local effect = AddSpecialEffect(cfg["净化符文模型路径"], cell["中心X"], cell["中心Y"])
                local ____self_10 = context["清理"]
                ____self_10["登记特效"](____self_10, "莫尔特斯-净化符文", effect)
                _____521B_5EFA_6280_80FD_63D0_793A_5708({
                    ["类型"] = "白色安全圆",
                    X = cell["中心X"],
                    Y = cell["中心Y"],
                    ["半径"] = cfg["净化符文半径"],
                    ["持续时间"] = cfg["净化持续秒"]
                })
            end
            ::__continue11::
            i = i + 1
        end
    end
end
local function _____5904_7406_51C0_5316_7B26_6587(context, hero)
    local grid = context["根须宫格"]
    if grid == nil then
        return false
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽领域"]
    local cells = {
        grid["获取格子"](grid, 0, 0),
        grid["获取格子"](grid, 0, 2),
        grid["获取格子"](grid, 2, 0),
        grid["获取格子"](grid, 2, 2)
    }
    do
        local i = 0
        while i < #cells do
            do
                local cell = cells[i + 1]
                if cell == nil then
                    goto __continue16
                end
                local dx = GetUnitX(hero) - cell["中心X"]
                local dy = GetUnitY(hero) - cell["中心Y"]
                if dx * dx + dy * dy <= cfg["净化符文半径"] * cfg["净化符文半径"] then
                    _____6E05_9664_73A9_5BB6_8150_8D25_503C(context, hero, _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败值"]["净化光斑每秒清除"])
                    registerManualBuff(
                        hero,
                        _____83AB_5C14_7279_65AFBuffID["净化庇护"],
                        1.2,
                        1,
                        {sourceName = "莫尔特斯-净化符文"}
                    )
                    return true
                end
            end
            ::__continue16::
            i = i + 1
        end
    end
    return false
end
local function _____83AB_5C14_7279_65AF_8150_673D_6CBC_6CFD_6839_987B()
    local variable = _____8150_673D_9886_57DF_6839_987B_5EF6_8FDF_4E0A_4E0B_6587
    _____8150_673D_9886_57DF_6839_987B_5EF6_8FDF_4E0A_4E0B_6587 = nil
    if variable == nil then
        return
    end
    local context = variable.context
    local target = variable.target
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    AddSpecialEffect(_____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽根须穿刺"]["穿刺特效路径"], variable.X, variable.Y)
    _____9020_6210AOE_6280_80FD_4F24_5BB3({
        ["来源"] = context["Boss单位"],
        ["目标"] = target,
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context["Boss单位"]),
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_PLANT,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "Boss技能"
    })
    _____589E_52A0_73A9_5BB6_8150_8D25_503C(context, target, _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽根须穿刺"]["腐败值"])
end
____exports["尝试触发莫尔特斯腐朽领域"] = function(context)
    if context["腐朽领域已触发"] or context["阶段"] < 3 or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    context["腐朽领域已触发"] = true
    _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD(context["Boss单位"], "低血量")
    _____521B_5EFA_8150_673D_9886_57DF_6CBC_6CFD_5730_8868(context)
    _____521B_5EFA_51C0_5316_7B26_6587(context)
end
____exports["处理莫尔特斯腐朽领域周期"] = function(context, nowMs)
    if not context["腐朽领域已触发"] or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐朽领域"]
    if context["下次沼泽腐败时间"] <= 0 then
        context["下次沼泽腐败时间"] = nowMs
    end
    if nowMs < context["下次沼泽腐败时间"] then
        return
    end
    context["下次沼泽腐败时间"] = nowMs + cfg["沼泽腐败间隔秒"] * 1000
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue29
                end
                if _____5904_7406_51C0_5316_7B26_6587(context, hero) then
                    goto __continue29
                end
                _____65BD_52A0_5FEB_901F_51CF_901FBuff(
                    context["Boss单位"],
                    hero,
                    cfg["减速比例"],
                    cfg["减速比例"],
                    1.3
                )
                _____589E_52A0_73A9_5BB6_8150_8D25_503C(context, hero, cfg["沼泽每跳腐败值"])
            end
            ::__continue29::
            i = i + 1
        end
    end
    if context["下次沼泽根须时间"] <= 0 then
        context["下次沼泽根须时间"] = nowMs + cfg["根须触发间隔秒"] * 1000
    end
    if nowMs >= context["下次沼泽根须时间"] and #heroes > 0 then
        context["下次沼泽根须时间"] = nowMs + cfg["根须触发间隔秒"] * 1000
        local target = heroes[GetRandomInt(0, #heroes - 1) + 1]
        if _____5355_4F4D_6709_6548(target) then
            local x = GetUnitX(target)
            local y = GetUnitY(target)
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "圆形",
                X = x,
                Y = y,
                ["半径"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["根须领域"]["单格边长"] * 0.5,
                ["持续时间"] = 1
            })
            _____8150_673D_9886_57DF_6839_987B_5EF6_8FDF_4E0A_4E0B_6587 = {context = context, target = target, X = x, Y = y}
            local id = addDelayedCallback(1000, _____83AB_5C14_7279_65AF_8150_673D_6CBC_6CFD_6839_987B)
            local ____self_11 = context["清理"]
            ____self_11["登记延迟回调"](____self_11, "莫尔特斯-腐朽沼泽根须", id)
        end
    end
end
____exports["注册莫尔特斯腐朽领域"] = function()
end
return ____exports
