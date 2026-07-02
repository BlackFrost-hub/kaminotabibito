--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_6D4B_8BD5_7CFB_7EDF_8F85_52A9_51FD_6570 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04 = ____00_FF0E_6D4B_8BD5_7CFB_7EDF_8F85_52A9_51FD_6570["创建测试中心平移映射"]
local _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_5750_6807 = ____00_FF0E_6D4B_8BD5_7CFB_7EDF_8F85_52A9_51FD_6570["按测试映射平移坐标"]
local _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_77E9_5F62 = ____00_FF0E_6D4B_8BD5_7CFB_7EDF_8F85_52A9_51FD_6570["按测试映射平移矩形"]
____exports["创建Boss测试场地上下文"] = function(_____573A_5730)
    local _____6620_5C04 = _____521B_5EFA_6D4B_8BD5_4E2D_5FC3_5E73_79FB_6620_5C04(_____573A_5730["正式中心"].x, _____573A_5730["正式中心"].y, _____573A_5730["测试空地中心"].x, _____573A_5730["测试空地中心"].y)
    return {
        ["场地"] = _____573A_5730,
        ["映射"] = _____6620_5C04,
        ["平移坐标"] = function(_____70B9)
            return _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_5750_6807(_____70B9, _____6620_5C04)
        end,
        ["平移矩形"] = function(_____77E9_5F62)
            return _____6309_6D4B_8BD5_6620_5C04_5E73_79FB_77E9_5F62(_____77E9_5F62, _____6620_5C04)
        end
    }
end
return ____exports
