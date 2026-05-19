--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.07．获得物品.00．公共.00．获得物品配置表")
local _____4EA1_4E4B_9B54_676F_914D_7F6E = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["亡之魔杯配置"]
local _____83B7_5F97_7269_54C1_88C5_5907ID = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["获得物品装备ID"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果")
local _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C = ____require_result_0["注册持有型周期效果"]
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.06．魔法恢复")
local doManaRegen = ____require_result_1.doManaRegen
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____53D6_5F53_524D_9B54_6CD5 = ____require_result_2["取当前魔法"]
local _____53D6_6700_5927_9B54_6CD5 = ____require_result_2["取最大魔法"]
local function ____on_4EA1_4E4B_9B54_676F_5468_671F(unit)
    local gain = (_____53D6_6700_5927_9B54_6CD5(unit) - _____53D6_5F53_524D_9B54_6CD5(unit)) * _____4EA1_4E4B_9B54_676F_914D_7F6E["恢复缺失魔法比例"]
    if not (gain > 0) then
        return
    end
    doManaRegen(unit, gain, false, true)
end
local function _____521D_59CB_5316_4EA1_4E4B_9B54_676F()
    if _____83B7_5F97_7269_54C1_88C5_5907ID["亡之魔杯"] == 0 then
        return
    end
    _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C({["物品类型ID"] = _____83B7_5F97_7269_54C1_88C5_5907ID["亡之魔杯"], ["间隔毫秒"] = _____4EA1_4E4B_9B54_676F_914D_7F6E["间隔毫秒"], ["周期回调"] = ____on_4EA1_4E4B_9B54_676F_5468_671F})
end
_____521D_59CB_5316_4EA1_4E4B_9B54_676F()
return ____exports
