--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____53D6_88C5_5907_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却并显示"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.01．持续恢复生命魔法")
local _____65BD_52A0_6301_7EED_6062_590D_751F_547D_9B54_6CD5 = ____require_result_0["施加持续恢复生命魔法"]
local _____6DF1_4E95_6D3B_6C34_56CAID = _____7269_54C1_4F7F_7528_88C5_5907ID["深井活水囊"]
local _____6DF1_4E95_6D3B_6C34_56CA_914D_7F6E = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["深井活水囊"]
____exports["处理深井活水囊使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____6DF1_4E95_6D3B_6C34_56CAID) then
        return
    end
    local unit = ctx["施法单位"]
    local _____51B7_5374_952E = _____53D6_88C5_5907_51B7_5374_952E(unit, "深井活水囊", "物品使用")
    if _____88C5_5907_51B7_5374_4E2D(_____51B7_5374_952E) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(_____51B7_5374_952E, _____6DF1_4E95_6D3B_6C34_56CA_914D_7F6E["冷却毫秒"] / 1000, unit, "深井活水囊")
    _____65BD_52A0_6301_7EED_6062_590D_751F_547D_9B54_6CD5(
        unit,
        unit,
        {
            BuffID = "C027",
            ["图标路径"] = "ReplaceableTextures\\CommandButtons\\BTNRejuvenation.blp",
            ["特效路径"] = "Abilities\\Spells\\NightElf\\Rejuvenation\\RejuvenationTarget.mdl",
            ["特效挂点"] = "origin",
            ["特效键"] = "深井活水囊",
            ["持续时间"] = 1,
            ["间隔"] = 1,
            ["每跳生命恢复"] = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE) * _____6DF1_4E95_6D3B_6C34_56CA_914D_7F6E["生命百分比"],
            ["每跳魔法恢复"] = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_MANA) * _____6DF1_4E95_6D3B_6C34_56CA_914D_7F6E["魔法百分比"],
            ["效果来源名称"] = "深井活水囊",
            ["效果来源类型"] = "装备"
        }
    )
end
return ____exports
