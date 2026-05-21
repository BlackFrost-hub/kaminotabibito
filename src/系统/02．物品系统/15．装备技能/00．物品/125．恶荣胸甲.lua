--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_0.resolveItemIdByName
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____require_result_2["单位持有伤害事件装备"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.index")
local _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7 = ____require_result_3["装备触发概率通过"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.06．暴击属性工具")
local _____8BFB_53D6_73A9_5BB6_66B4_51FB_7387 = ____require_result_4["读取玩家暴击率"]
local _____6076_8363_80F8_7532_7269_54C1ID = stringToFourCCSafe(resolveItemIdByName("恶荣胸甲"))
local _____57FA_7840_6982_7387 = 0.25
local _____51CF_4F24_540E_7CFB_6570 = 0.75
local function _____9650_5236_6982_7387(value)
    if value <= 0 then
        return 0
    end
    if value >= 1 then
        return 1
    end
    return value
end
____exports["处理恶荣胸甲伤害修正"] = function(context, _____5F53_524D_4F24_5BB3)
    if _____6076_8363_80F8_7532_7269_54C1ID == 0 then
        return _____5F53_524D_4F24_5BB3
    end
    if context == nil or context.target == nil or context.target == 0 then
        return _____5F53_524D_4F24_5BB3
    end
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(context.target, _____6076_8363_80F8_7532_7269_54C1ID) then
        return _____5F53_524D_4F24_5BB3
    end
    local _____89E6_53D1_6982_7387 = _____9650_5236_6982_7387(_____57FA_7840_6982_7387 + _____8BFB_53D6_73A9_5BB6_66B4_51FB_7387(context.target))
    if not _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7(_____89E6_53D1_6982_7387, context.target) then
        return _____5F53_524D_4F24_5BB3
    end
    return _____5F53_524D_4F24_5BB3 * _____51CF_4F24_540E_7CFB_6570
end
return ____exports
