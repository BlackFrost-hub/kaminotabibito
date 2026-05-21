--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_0.resolveItemIdByName
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____require_result_2["单位持有伤害事件装备"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____require_result_2["造成伤害事件伤害"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____require_result_2["伤害事件伤害类型"]
local _____4F24_5BB3_4E8B_4EF6_653B_51FB_7C7B_578B = ____require_result_2["伤害事件攻击类型"]
local ____require_result_3 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____8BFB_53D6_73A9_5BB6_5C5E_6027 = ____require_result_3["读取玩家属性"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.06．精英单位判断")
local _____662F_5426_6076_9B54_5355_4F4D = ____require_result_4["是否恶魔单位"]
local _____72F1_9B54_77ED_5315_7269_54C1ID = stringToFourCCSafe(resolveItemIdByName("狱魔短匕"))
local _____9B54_6CD5_52A0_6210_9608_503C = 0.01
local _____989D_5916_4F24_5BB3_7CFB_6570 = 0.45
____exports["处理狱魔短匕最终伤害"] = function(ctx)
    if _____72F1_9B54_77ED_5315_7269_54C1ID == 0 then
        return
    end
    if ctx == nil or ctx.attacker == nil or ctx.attacker == 0 or ctx.target == nil or ctx.target == 0 or ctx.snapshot == nil then
        return
    end
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.attacker, _____72F1_9B54_77ED_5315_7269_54C1ID) then
        return
    end
    if not (ctx.applied > 0) then
        return
    end
    if _____8BFB_53D6_73A9_5BB6_5C5E_6027(ctx.attacker, "魔法伤害") <= _____9B54_6CD5_52A0_6210_9608_503C then
        return
    end
    if ctx.snapshot.rawAttackType ~= _____4F24_5BB3_4E8B_4EF6_653B_51FB_7C7B_578B["普通"] then
        return
    end
    if ctx.snapshot.rawDamageType == _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["普通"] then
        return
    end
    if ctx.snapshot.rawDamageType == _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["强化"] then
        return
    end
    if _____662F_5426_6076_9B54_5355_4F4D(ctx.target) ~= true then
        return
    end
    _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(ctx.attacker, ctx.target, ctx.applied * _____989D_5916_4F24_5BB3_7CFB_6570, _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["强化"])
end
return ____exports
