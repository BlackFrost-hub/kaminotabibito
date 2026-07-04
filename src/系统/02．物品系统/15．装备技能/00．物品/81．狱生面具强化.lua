--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.07．获得物品.00．公共.00．获得物品配置表")
local _____72F1_751F_9762_5177_914D_7F6E = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["狱生面具配置"]
local _____83B7_5F97_7269_54C1_88C5_5907ID = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["获得物品装备ID"]
local ____07_FF0E_6B7B_4EA1_7ED3_7B97_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.07．死亡结算模板.index")
local _____8BB0_5F55_6216_5237_65B0_5EF6_8FDF_6B7B_4EA1_7ED3_7B97 = ____07_FF0E_6B7B_4EA1_7ED3_7B97_6A21_677F["记录或刷新延迟死亡结算"]
local _____5355_4F4D_662F_5426_6B7B_4EA1_6216_65E0_6548 = ____07_FF0E_6B7B_4EA1_7ED3_7B97_6A21_677F["单位是否死亡或无效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果")
local _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C = ____require_result_0["注册持有型周期效果"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听")
local _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF = ____require_result_1["获取单位当前持有指定物品数量"]
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_2["减少魔法值"]
local ____require_result_3 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_3.doHeal
local ____require_result_4 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____83B7_53D6_8303_56F4_654C_4EBA = ____require_result_4["获取范围敌人"]
local _____53D6_5355_4F4DX = ____require_result_4["取单位X"]
local _____53D6_5355_4F4DY = ____require_result_4["取单位Y"]
local _____53D6_6700_5927_9B54_6CD5 = ____require_result_4["取最大魔法"]
local _____53D6_6700_5927_751F_547D = ____require_result_4["取最大生命"]
local _____53D6_5F53_524D_751F_547D = ____require_result_4["取当前生命"]
local _____53D6_5F53_524D_9B54_6CD5 = ____require_result_4["取当前魔法"]
local _____9020_6210_6697_5F71_4F24_5BB3 = ____require_result_4["造成暗影伤害"]
local function _____5355_4F4D_5DF2_6B7B_4EA1(unit)
    return _____5355_4F4D_662F_5426_6B7B_4EA1_6216_65E0_6548(unit)
end
local function _____5355_4F4D_6301_6709_72F1_751F_9762_5177_5F3A_5316(unit)
    return _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF(unit, _____83B7_5F97_7269_54C1_88C5_5907ID["狱生面具强化"]) > 0
end
local function ____on_72F1_751F_9762_5177_5F3A_5316_51FB_6740_7ED3_7B97(_____4E0A_4E0B_6587)
    local source = _____4E0A_4E0B_6587["来源单位"]
    local heal = (_____53D6_6700_5927_751F_547D(source) - _____53D6_5F53_524D_751F_547D(source)) * _____72F1_751F_9762_5177_914D_7F6E["强化恢复比例"]
    local mana = (_____53D6_6700_5927_9B54_6CD5(source) - _____53D6_5F53_524D_9B54_6CD5(source)) * _____72F1_751F_9762_5177_914D_7F6E["强化恢复比例"]
    doHeal({
        HealSource = source,
        HealTarget = source,
        HealAmount = heal,
        HealManaAmount = mana,
        ItemHeal = true,
        HealEffect = true,
        ManaEffect = true
    })
end
local function _____8BB0_5F55_72F1_751F_9762_5177_5F3A_5316_76EE_6807(source, target)
    _____8BB0_5F55_6216_5237_65B0_5EF6_8FDF_6B7B_4EA1_7ED3_7B97({
        ["key前缀"] = "狱生面具强化",
        ["来源单位"] = source,
        ["目标单位"] = target,
        ["延迟毫秒"] = _____72F1_751F_9762_5177_914D_7F6E["强化延迟毫秒"],
        ["来源有效性检查"] = function(_____4E0A_4E0B_6587)
            return _____5355_4F4D_6301_6709_72F1_751F_9762_5177_5F3A_5316(_____4E0A_4E0B_6587["来源单位"])
        end,
        ["on目标死亡"] = ____on_72F1_751F_9762_5177_5F3A_5316_51FB_6740_7ED3_7B97
    })
end
local function ____on_72F1_751F_9762_5177_5F3A_5316_5468_671F(unit)
    local consumed = -_____51CF_5C11_9B54_6CD5_503C(
        unit,
        _____53D6_6700_5927_9B54_6CD5(unit) * _____72F1_751F_9762_5177_914D_7F6E["最大魔法消耗比例"],
        true,
        false
    )
    if not (consumed > 0) then
        return
    end
    local damage = consumed * _____72F1_751F_9762_5177_914D_7F6E["强化伤害倍率"]
    local targets = _____83B7_53D6_8303_56F4_654C_4EBA(
        unit,
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit),
        _____72F1_751F_9762_5177_914D_7F6E["作用范围"]
    )
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if _____5355_4F4D_5DF2_6B7B_4EA1(target) then
                    goto __continue10
                end
                _____8BB0_5F55_72F1_751F_9762_5177_5F3A_5316_76EE_6807(unit, target)
                _____9020_6210_6697_5F71_4F24_5BB3(unit, target, damage)
            end
            ::__continue10::
            i = i + 1
        end
    end
end
local function _____521D_59CB_5316_72F1_751F_9762_5177_5F3A_5316()
    if _____83B7_5F97_7269_54C1_88C5_5907ID["狱生面具强化"] == 0 then
        return
    end
    _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C({["物品类型ID"] = _____83B7_5F97_7269_54C1_88C5_5907ID["狱生面具强化"], ["间隔毫秒"] = _____72F1_751F_9762_5177_914D_7F6E["间隔毫秒"], ["周期回调"] = ____on_72F1_751F_9762_5177_5F3A_5316_5468_671F})
end
_____521D_59CB_5316_72F1_751F_9762_5177_5F3A_5316()
return ____exports
