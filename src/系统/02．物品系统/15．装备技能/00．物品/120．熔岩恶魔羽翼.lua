--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_0.resolveItemIdByName
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____require_result_2["单位持有伤害事件装备"]
local _____53D6_5355_4F4DX = ____require_result_2["取单位X"]
local _____53D6_5355_4F4DY = ____require_result_2["取单位Y"]
local _____7194_5CA9_6076_9B54_7FBD_7FFC_7269_54C1ID = stringToFourCCSafe(resolveItemIdByName("熔岩恶魔羽翼"))
local _____8DDD_79BB_9608_503C = 300
local _____8DDD_79BB_9608_503C_5E73_65B9 = _____8DDD_79BB_9608_503C * _____8DDD_79BB_9608_503C
local _____51CF_4F24_540E_7CFB_6570 = 0.8
local function _____53D6_4E24_70B9_8DDD_79BB_5E73_65B9(unitA, unitB)
    local dx = _____53D6_5355_4F4DX(unitA) - _____53D6_5355_4F4DX(unitB)
    local dy = _____53D6_5355_4F4DY(unitA) - _____53D6_5355_4F4DY(unitB)
    return dx * dx + dy * dy
end
____exports["处理熔岩恶魔羽翼伤害修正"] = function(context, _____5F53_524D_4F24_5BB3)
    if _____7194_5CA9_6076_9B54_7FBD_7FFC_7269_54C1ID == 0 then
        return _____5F53_524D_4F24_5BB3
    end
    if context == nil or context.target == nil or context.target == 0 or context.attacker == nil or context.attacker == 0 then
        return _____5F53_524D_4F24_5BB3
    end
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(context.target, _____7194_5CA9_6076_9B54_7FBD_7FFC_7269_54C1ID) then
        return _____5F53_524D_4F24_5BB3
    end
    if _____53D6_4E24_70B9_8DDD_79BB_5E73_65B9(context.target, context.attacker) <= _____8DDD_79BB_9608_503C_5E73_65B9 then
        return _____5F53_524D_4F24_5BB3
    end
    return _____5F53_524D_4F24_5BB3 * _____51CF_4F24_540E_7CFB_6570
end
return ____exports
