--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____53D6_6700_5927_751F_547D = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取最大生命"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____20_FF0E_7269_54C1_8F85_52A9["施加临时属性效果"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_751F_547D_503C = ____require_result_0["减少生命值"]
____exports["处理嗜狱恶剑使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["嗜狱恶剑"]) then
        return
    end
    local unit = ctx["施法单位"]
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["嗜狱恶剑"]
    _____51CF_5C11_751F_547D_503C(
        unit,
        _____53D6_6700_5927_751F_547D(unit) * cfg["自伤最大生命比例"],
        true,
        false,
        nil,
        1
    )
    _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(unit, cfg["持续毫秒"], {{["类型"] = "攻击", ["数值"] = cfg["攻击增加"]}, {["类型"] = "玩家属性", ["属性名"] = "必定暴击", ["数值"] = cfg["必定暴击"]}})
    registerManualBuff(
        unit,
        _____5E38_89C4BuffID["嗜狱恶剑_嗜狱"],
        cfg["持续毫秒"] / 1000,
        cfg["攻击增加"],
        {sourceUnit = unit, effectSourceName = "嗜狱恶剑", effectSourceType = "装备"}
    )
end
return ____exports
