--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.07．击杀回复触发模板")
local _____6CE8_518C_51FB_6740_56DE_590D_89E6_53D1_6A21_677F = ____require_result_0["注册击杀回复触发模板"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____require_result_1["单位持有装备"]
local function _____76D7_8D3C_9996_9886_5FBD_8BB0_89E6_53D1_6761_4EF6(event)
    return _____5355_4F4D_6301_6709_88C5_5907(event["击杀单位"], "盗贼首领徽记")
end
_____6CE8_518C_51FB_6740_56DE_590D_89E6_53D1_6A21_677F({
    ["名称"] = "盗贼首领徽记",
    ["冷却秒数"] = 0.5,
    ["恢复魔法值"] = 50,
    ["恢复最大魔法比例"] = 0.05,
    ["使用默认魔法特效"] = true,
    ["触发条件"] = _____76D7_8D3C_9996_9886_5FBD_8BB0_89E6_53D1_6761_4EF6
})
return ____exports
