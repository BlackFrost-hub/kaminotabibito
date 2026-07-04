--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____23_FF0E_53E5_67C4_6C38_4E45_6807_8BB0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.23．句柄永久标记")
local _____521B_5EFA_53E5_67C4_6C38_4E45_6807_8BB0 = ____23_FF0E_53E5_67C4_6C38_4E45_6807_8BB0["创建句柄永久标记"]
____exports["创建单位永久标记"] = function(_____540D_79F0)
    local _____6807_8BB0_5668 = _____521B_5EFA_53E5_67C4_6C38_4E45_6807_8BB0(_____540D_79F0)
    return {
        ["名称"] = _____540D_79F0,
        ["标记"] = function(unit)
            _____6807_8BB0_5668["标记"](unit)
        end,
        ["存在"] = function(unit)
            return _____6807_8BB0_5668["存在"](unit)
        end,
        ["标记若不存在"] = function(unit)
            return _____6807_8BB0_5668["标记若不存在"](unit)
        end,
        ["清空"] = function(unit)
            _____6807_8BB0_5668["清空"](unit)
        end
    }
end
return ____exports
