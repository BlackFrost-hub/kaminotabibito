--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local function _____521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587(boss, _____6E05_7406)
    return {
        ["Boss单位"] = boss,
        ["清理"] = _____6E05_7406,
        ["增伤累计伤害"] = 0,
        ["解控累计伤害"] = 0,
        ["下一增伤层ID"] = 1,
        ["增伤层列表"] = {},
        ["心脏掌握冷却结束毫秒"] = 0,
        ["束缚目标"] = nil,
        ["束缚闪电"] = nil,
        ["束缚周期ID"] = 0,
        ["束缚反伤中"] = false,
        ["束缚清理已登记"] = false
    }
end
local _____6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "杀戮食人魔", ["创建上下文"] = _____521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587, ["死亡时自动清理"] = true})
____exports["获取杀戮食人魔上下文"] = function(boss)
    return _____6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取或创建杀戮食人魔上下文"] = function(boss)
    return _____6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["获取全部杀戮食人魔上下文"] = function()
    return _____6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
end
____exports["清理杀戮食人魔上下文"] = function(boss)
    _____6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
return ____exports
