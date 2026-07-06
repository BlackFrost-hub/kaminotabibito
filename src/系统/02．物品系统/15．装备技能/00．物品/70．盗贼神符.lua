--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____20_FF0E_7269_54C1_8F85_52A9["施加临时属性效果"]
local _____5355_4F4D_662F_82F1_96C4 = ____20_FF0E_7269_54C1_8F85_52A9["单位是英雄"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____20_FF0E_7269_54C1_8F85_52A9["播放单位特效"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_1.onItemPickup
local GetItemTypeId = jass.GetItemTypeId
local GetWidgetLife = jass.GetWidgetLife
local UnitRemoveItem = jass.UnitRemoveItem
local RemoveItem = jass.RemoveItem
local _____76D7_8D3C_795E_7B26_62A4_7532ID = stringToFourCCSafe("I0FK")
local _____76D7_8D3C_795E_7B26_9B54_6297ID = stringToFourCCSafe("I0FL")
local _____76D7_8D3C_795E_7B26_6301_7EED_6BEB_79D2 = 10000
local _____76D7_8D3C_795E_7B26_751F_6548_7279_6548 = "Abilities\\Spells\\Items\\AItb\\AItbTarget.mdl"
local function _____65BD_52A0_76D7_8D3C_795E_7B26_62A4_7532(unit)
    _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(unit, _____76D7_8D3C_795E_7B26_6301_7EED_6BEB_79D2, {{["类型"] = "护甲", ["数值"] = 15}})
end
local function _____65BD_52A0_76D7_8D3C_795E_7B26_9B54_6297(unit)
    if _____5355_4F4D_662F_82F1_96C4(unit) then
        _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(unit, _____76D7_8D3C_795E_7B26_6301_7EED_6BEB_79D2, {{["类型"] = "玩家属性", ["属性名"] = "魔抗", ["数值"] = 0.2}})
    else
        _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(unit, _____76D7_8D3C_795E_7B26_6301_7EED_6BEB_79D2, {{["类型"] = "单位属性", ["属性名"] = "魔抗", ["数值"] = 0.2}})
    end
end
local function _____5F3A_5236_751F_6548_76D7_8D3C_795E_7B26(unit, item, itemTypeId)
    UnitRemoveItem(unit, item)
    RemoveItem(item)
    _____64AD_653E_5355_4F4D_7279_6548(_____76D7_8D3C_795E_7B26_751F_6548_7279_6548, unit, "origin", 1)
    if itemTypeId == _____76D7_8D3C_795E_7B26_62A4_7532ID then
        _____65BD_52A0_76D7_8D3C_795E_7B26_62A4_7532(unit)
    else
        _____65BD_52A0_76D7_8D3C_795E_7B26_9B54_6297(unit)
    end
end
local function ____on_76D7_8D3C_795E_7B26_5B9E_9645_62FE_53D6(unit, item)
    if item == nil or item == 0 then
        return
    end
    local itemTypeId = GetItemTypeId(item)
    if unit == nil or unit == 0 or GetWidgetLife(unit) <= 0.405 then
        return
    end
    if itemTypeId ~= _____76D7_8D3C_795E_7B26_62A4_7532ID and itemTypeId ~= _____76D7_8D3C_795E_7B26_9B54_6297ID then
        return
    end
    _____5F3A_5236_751F_6548_76D7_8D3C_795E_7B26(unit, item, itemTypeId)
end
onItemPickup(____on_76D7_8D3C_795E_7B26_5B9E_9645_62FE_53D6)
return ____exports
