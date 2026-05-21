--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_0.resolveItemIdByName
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____require_result_2["单位持有伤害事件装备"]
local _____53D6_6700_5927_751F_547D = ____require_result_2["取最大生命"]
local _____9632_5FA1_8718_86DB_9879_94FE_7269_54C1ID = stringToFourCCSafe(resolveItemIdByName("防御蜘蛛项链"))
local _____51CF_4F24_7CFB_6570 = 0.02
____exports["处理防御蜘蛛项链伤害修正"] = function(context, _____5F53_524D_4F24_5BB3)
    if _____9632_5FA1_8718_86DB_9879_94FE_7269_54C1ID == 0 then
        return _____5F53_524D_4F24_5BB3
    end
    if context == nil or context.target == nil or context.target == 0 then
        return _____5F53_524D_4F24_5BB3
    end
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(context.target, _____9632_5FA1_8718_86DB_9879_94FE_7269_54C1ID) then
        return _____5F53_524D_4F24_5BB3
    end
    return _____5F53_524D_4F24_5BB3 - _____53D6_6700_5927_751F_547D(context.target) * _____51CF_4F24_7CFB_6570
end
return ____exports
