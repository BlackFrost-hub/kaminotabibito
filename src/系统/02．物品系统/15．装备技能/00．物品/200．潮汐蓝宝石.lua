--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C["施加临时属性效果"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____53D6_88C5_5907_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却并显示"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["祖地秘境战利品装备名"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local _____84DD_5B9D_77F3_56DE_84DD_7279_6548 = "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl"
____exports["处理潮汐蓝宝石使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["潮汐蓝宝石"]) then
        return
    end
    local unit = ctx["施法单位"]
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["潮汐蓝宝石"]
    local _____51B7_5374_952E = _____53D6_88C5_5907_51B7_5374_952E(unit, _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D["潮汐蓝宝石"], "物品使用")
    if _____88C5_5907_51B7_5374_4E2D(_____51B7_5374_952E) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(_____51B7_5374_952E, cfg["冷却秒"], unit, _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D["潮汐蓝宝石"])
    local _____6700_5927_9B54_6CD5 = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_MANA)
    local _____5F53_524D_9B54_6CD5 = GetUnitState(unit, jass.UNIT_STATE_MANA)
    SetUnitState(unit, jass.UNIT_STATE_MANA, _____5F53_524D_9B54_6CD5 + _____6700_5927_9B54_6CD5 * cfg["魔法百分比"])
    _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(unit, cfg["恢复持续毫秒"], {{["类型"] = "玩家属性", ["属性名"] = "魔法恢复%", ["数值"] = cfg["恢复提升"]}})
    _____64AD_653E_5355_4F4D_7279_6548(
        _____84DD_5B9D_77F3_56DE_84DD_7279_6548,
        unit,
        "origin",
        1.2,
        0.9
    )
end
return ____exports
