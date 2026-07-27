--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.04．持续治疗效果")
local startHot = ____require_result_1.startHot
local function _____6301_7EED_6062_590D_7ED3_675F_6761_4EF6_6052_771F(______76EE_6807_5355_4F4D)
    return true
end
____exports["施加持续恢复生命魔法"] = function(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____53C2_6570)
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        return
    end
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    registerManualBuff(
        _____76EE_6807_5355_4F4D,
        _____53C2_6570.BuffID,
        _____53C2_6570["持续时间"],
        _____53C2_6570["每跳生命恢复"],
        {
            effectValue2 = _____53C2_6570["每跳魔法恢复"],
            sourceUnit = _____6765_6E90_5355_4F4D,
            effectSourceName = _____53C2_6570["效果来源名称"],
            effectSourceType = _____53C2_6570["效果来源类型"],
            iconOverride = _____53C2_6570["图标路径"],
            effectModelOverride = _____53C2_6570["特效路径"]
        }
    )
    startHot(
        _____76EE_6807_5355_4F4D,
        _____6765_6E90_5355_4F4D,
        _____53C2_6570["每跳生命恢复"],
        _____53C2_6570["每跳魔法恢复"],
        _____53C2_6570["持续时间"],
        _____53C2_6570["间隔"],
        {BuffID = _____53C2_6570.BuffID, ["结束条件检测"] = _____6301_7EED_6062_590D_7ED3_675F_6761_4EF6_6052_771F, ["特效"] = {["特效路径"] = _____53C2_6570["特效路径"], ["特效挂点"] = _____53C2_6570["特效挂点"], ["是否绑定单位"] = true, ["特效键"] = _____53C2_6570["特效键"]}}
    )
end
return ____exports
