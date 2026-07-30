--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_0["开始硬直"]
local ____require_result_1 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_1["显示常规技能吟唱条"]
____exports["开始米亚常规施法"] = function(unit, _____541F_5531_79D2, _____6807_9898_6587_672C, _____63D0_793A_6587_672C, _____786C_76F4_79D2)
    _____5F00_59CB_786C_76F4(unit, _____786C_76F4_79D2 or _____541F_5531_79D2)
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({["总时长"] = _____541F_5531_79D2, ["颜色ID"] = 3, ["标题文本"] = _____6807_9898_6587_672C, ["提示文本"] = _____63D0_793A_6587_672C})
end
return ____exports
