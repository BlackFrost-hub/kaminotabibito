--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
local addThreat = ____require_result_0.addThreat
--- 直接给「敌人」对「仇恨目标」累加指定数值的仇恨
____exports["增加单位仇恨"] = function(_____654C_4EBA, _____4EC7_6068_76EE_6807, _____6570_503C)
    addThreat(_____654C_4EBA, _____4EC7_6068_76EE_6807, _____6570_503C)
end
--- 按「相当于造成目标 X% 最大生命伤害」的仇恨量累加。
-- 
-- @param 相当于最大生命比例 例如 0.3 → 加 300 点仇恨
____exports["增加生命比例仇恨"] = function(_____654C_4EBA, _____4EC7_6068_76EE_6807, _____76F8_5F53_4E8E_6700_5927_751F_547D_6BD4_4F8B)
    addThreat(
        _____654C_4EBA,
        _____4EC7_6068_76EE_6807,
        math.floor(_____76F8_5F53_4E8E_6700_5927_751F_547D_6BD4_4F8B * 1000 + 0.5)
    )
end
return ____exports
