--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____6BD4_5B89_8840_722A_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["比安血爪物品ID"]
local ____00_FF0E_65BD_6CD5_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.02．施法触发.00．施法触发配置")
local _____6BD4_5B89_8840_722A_914D_7F6E = ____00_FF0E_65BD_6CD5_89E6_53D1_914D_7F6E["比安血爪配置"]
local ____02_FF0E_4E34_65F6_9644_52A0_653B_51FB = require("系统.02．物品系统.15．装备技能.03．主动技能.02．施法触发.02．临时附加攻击")
local _____65BD_52A0_4E34_65F6_9644_52A0_653B_51FB = ____02_FF0E_4E34_65F6_9644_52A0_653B_51FB["施加临时附加攻击"]
local ____require_result_0 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_0.UnitHasItemOfTypeBJ
local function _____5355_4F4D_6301_6709_6BD4_5B89_8840_722A(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    if _____6BD4_5B89_8840_722A_7269_54C1ID <= 0 then
        return false
    end
    return UnitHasItemOfTypeBJ(_____5355_4F4D, _____6BD4_5B89_8840_722A_7269_54C1ID) == true
end
____exports["处理比安血爪施法"] = function(_____65BD_6CD5_5355_4F4D)
    if not _____5355_4F4D_6301_6709_6BD4_5B89_8840_722A(_____65BD_6CD5_5355_4F4D) then
        return
    end
    _____65BD_52A0_4E34_65F6_9644_52A0_653B_51FB(_____65BD_6CD5_5355_4F4D, _____6BD4_5B89_8840_722A_914D_7F6E["附加攻击"], _____6BD4_5B89_8840_722A_914D_7F6E["持续时间"])
end
return ____exports
