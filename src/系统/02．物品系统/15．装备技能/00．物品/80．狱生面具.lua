--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.07．获得物品.00．公共.00．获得物品配置表")
local _____72F1_751F_9762_5177_914D_7F6E = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["狱生面具配置"]
local _____83B7_5F97_7269_54C1_88C5_5907ID = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["获得物品装备ID"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果")
local _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C = ____require_result_0["注册持有型周期效果"]
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_1["减少魔法值"]
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____83B7_53D6_8303_56F4_654C_4EBA = ____require_result_2["获取范围敌人"]
local _____53D6_5355_4F4DX = ____require_result_2["取单位X"]
local _____53D6_5355_4F4DY = ____require_result_2["取单位Y"]
local _____53D6_6700_5927_9B54_6CD5 = ____require_result_2["取最大魔法"]
local _____9020_6210_6697_5F71_4F24_5BB3 = ____require_result_2["造成暗影伤害"]
local _____6267_884C_6CBB_7597 = ____require_result_2["执行治疗"]
local function ____on_72F1_751F_9762_5177_5468_671F(unit)
    local consumed = -_____51CF_5C11_9B54_6CD5_503C(
        unit,
        _____53D6_6700_5927_9B54_6CD5(unit) * _____72F1_751F_9762_5177_914D_7F6E["最大魔法消耗比例"],
        true,
        false
    )
    if not (consumed > 0) then
        return
    end
    local targets = _____83B7_53D6_8303_56F4_654C_4EBA(
        unit,
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit),
        _____72F1_751F_9762_5177_914D_7F6E["作用范围"]
    )
    do
        local i = 0
        while i < #targets do
            _____9020_6210_6697_5F71_4F24_5BB3(unit, targets[i + 1], consumed)
            i = i + 1
        end
    end
    _____6267_884C_6CBB_7597(unit, unit, consumed, 0)
end
local function _____521D_59CB_5316_72F1_751F_9762_5177()
    if _____83B7_5F97_7269_54C1_88C5_5907ID["狱生面具"] == 0 then
        return
    end
    _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C({["物品类型ID"] = _____83B7_5F97_7269_54C1_88C5_5907ID["狱生面具"], ["间隔毫秒"] = _____72F1_751F_9762_5177_914D_7F6E["间隔毫秒"], ["周期回调"] = ____on_72F1_751F_9762_5177_5468_671F})
end
_____521D_59CB_5316_72F1_751F_9762_5177()
return ____exports
