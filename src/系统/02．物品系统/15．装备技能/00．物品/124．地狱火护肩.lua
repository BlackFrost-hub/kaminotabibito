--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____09_FF0E_88C5_5907_901A_7528_673A_5236 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.index")
local _____521B_5EFA_5355_4F4D_5BF9_5355_4F4D_6682_5B58_6570_503C = ____09_FF0E_88C5_5907_901A_7528_673A_5236["创建单位对单位暂存数值"]
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_0.resolveItemIdByName
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____require_result_2["单位持有伤害事件装备"]
local _____53D6_6700_5927_751F_547D = ____require_result_2["取最大生命"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____require_result_2["造成伤害事件伤害"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____require_result_2["伤害事件伤害类型"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.index")
local _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7 = ____require_result_3["装备触发概率通过"]
local jass = require("jass.common")
local GetHeroStr = jass.GetHeroStr
local GetUnitLevel = jass.GetUnitLevel
local _____5730_72F1_706B_62A4_80A9_7269_54C1ID = stringToFourCCSafe(resolveItemIdByName("地狱火护肩"))
local _____5B8C_5168_62B5_6321_751F_547D_7CFB_6570 = 0.02
local _____6982_7387 = 0.3
local _____51CF_4F24_540E_7CFB_6570 = 0.6
local _____53CD_51FB_529B_91CF_7CFB_6570 = 4
local _____5730_72F1_706B_62A4_80A9_53CD_51FB_4F24_5BB3 = _____521B_5EFA_5355_4F4D_5BF9_5355_4F4D_6682_5B58_6570_503C("地狱火护肩反击伤害")
local _____5730_72F1_706B_62A4_80A9_53CD_51FB_8FDB_884C_4E2D = false
____exports["处理地狱火护肩伤害修正"] = function(context, _____5F53_524D_4F24_5BB3)
    if _____5730_72F1_706B_62A4_80A9_7269_54C1ID == 0 then
        return _____5F53_524D_4F24_5BB3
    end
    if _____5730_72F1_706B_62A4_80A9_53CD_51FB_8FDB_884C_4E2D then
        return _____5F53_524D_4F24_5BB3
    end
    if context == nil or context.target == nil or context.target == 0 or context.attacker == nil or context.attacker == 0 then
        return _____5F53_524D_4F24_5BB3
    end
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(context.target, _____5730_72F1_706B_62A4_80A9_7269_54C1ID) then
        return _____5F53_524D_4F24_5BB3
    end
    local _____5B8C_5168_62B5_6321_9608_503C = _____53D6_6700_5927_751F_547D(context.target) * _____5B8C_5168_62B5_6321_751F_547D_7CFB_6570 + GetUnitLevel(context.target)
    if _____5F53_524D_4F24_5BB3 < _____5B8C_5168_62B5_6321_9608_503C then
        return 0
    end
    if not _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7(_____6982_7387, context.target) then
        return _____5F53_524D_4F24_5BB3
    end
    _____5730_72F1_706B_62A4_80A9_53CD_51FB_4F24_5BB3["写入"](
        context.target,
        context.attacker,
        GetHeroStr(context.target, true) * _____53CD_51FB_529B_91CF_7CFB_6570,
        2
    )
    return _____5F53_524D_4F24_5BB3 * _____51CF_4F24_540E_7CFB_6570
end
____exports["处理地狱火护肩最终伤害"] = function(ctx)
    if ctx == nil or ctx.target == nil or ctx.target == 0 or ctx.attacker == nil or ctx.attacker == 0 then
        return
    end
    local _____53CD_51FB_4F24_5BB3 = _____5730_72F1_706B_62A4_80A9_53CD_51FB_4F24_5BB3["消耗"](ctx.target, ctx.attacker)
    if not (_____53CD_51FB_4F24_5BB3 ~= nil and _____53CD_51FB_4F24_5BB3 > 0) then
        return
    end
    _____5730_72F1_706B_62A4_80A9_53CD_51FB_8FDB_884C_4E2D = true
    do
        local ____try, ____error = pcall(function()
            _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(ctx.target, ctx.attacker, _____53CD_51FB_4F24_5BB3, _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["强化"])
        end)
        do
            _____5730_72F1_706B_62A4_80A9_53CD_51FB_8FDB_884C_4E2D = false
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
return ____exports
