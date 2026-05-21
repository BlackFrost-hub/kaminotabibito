--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_0["按名字反查物品ID"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.物品相关函数.物品判断函数")
local GetItemOfTypeFromUnitBJ = ____require_result_2.GetItemOfTypeFromUnitBJ
local GetHeroLevel = jass.GetHeroLevel
local GetHeroStr = jass.GetHeroStr
local GetHeroAgi = jass.GetHeroAgi
local GetHeroInt = jass.GetHeroInt
local SetHeroStr = jass.SetHeroStr
local SetHeroAgi = jass.SetHeroAgi
local SetHeroInt = jass.SetHeroInt
local SetItemDroppable = jass.SetItemDroppable
____exports["生命之吻装备名"] = "生命之吻"
____exports["生命之吻物品类型ID"] = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(____exports["生命之吻装备名"]))
____exports["生命之吻每两级全属性"] = 3
____exports["生命之吻可丢弃等级间隔"] = 20
local function _____83B7_53D6_751F_547D_4E4B_543B_7269_54C1(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    if ____exports["生命之吻物品类型ID"] == 0 then
        return nil
    end
    return GetItemOfTypeFromUnitBJ(_____5355_4F4D, ____exports["生命之吻物品类型ID"])
end
____exports["单位是否持有生命之吻"] = function(_____5355_4F4D)
    return _____83B7_53D6_751F_547D_4E4B_543B_7269_54C1(_____5355_4F4D) ~= nil
end
____exports["同步生命之吻可丢弃状态"] = function(_____5355_4F4D)
    local _____7269_54C1 = _____83B7_53D6_751F_547D_4E4B_543B_7269_54C1(_____5355_4F4D)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return
    end
    local _____5F53_524D_7B49_7EA7 = GetHeroLevel(_____5355_4F4D) or 0
    local _____53EF_4E22_5F03 = _____5F53_524D_7B49_7EA7 > 0 and _____5F53_524D_7B49_7EA7 % ____exports["生命之吻可丢弃等级间隔"] == 0
    SetItemDroppable(_____7269_54C1, _____53EF_4E22_5F03)
end
____exports["处理生命之吻升级效果"] = function(_____5355_4F4D)
    if not ____exports["单位是否持有生命之吻"](_____5355_4F4D) then
        return
    end
    local _____5F53_524D_7B49_7EA7 = GetHeroLevel(_____5355_4F4D) or 0
    if _____5F53_524D_7B49_7EA7 > 0 and _____5F53_524D_7B49_7EA7 % 2 == 0 then
        SetHeroStr(
            _____5355_4F4D,
            GetHeroStr(_____5355_4F4D, false) + ____exports["生命之吻每两级全属性"],
            false
        )
        SetHeroAgi(
            _____5355_4F4D,
            GetHeroAgi(_____5355_4F4D, false) + ____exports["生命之吻每两级全属性"],
            false
        )
        SetHeroInt(
            _____5355_4F4D,
            GetHeroInt(_____5355_4F4D, false) + ____exports["生命之吻每两级全属性"],
            false
        )
    end
    ____exports["同步生命之吻可丢弃状态"](_____5355_4F4D)
end
____exports["生命之吻升级规则"] = {["装备名"] = ____exports["生命之吻装备名"], ["物品类型ID"] = ____exports["生命之吻物品类型ID"], ["处理升级"] = ____exports["处理生命之吻升级效果"], ["处理拾取"] = ____exports["同步生命之吻可丢弃状态"]}
return ____exports
