--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["创建测试中心平移映射"] = function(_____6B63_5F0F_4E2D_5FC3X, _____6B63_5F0F_4E2D_5FC3Y, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y)
    return {["偏移X"] = _____6D4B_8BD5_4E2D_5FC3X - _____6B63_5F0F_4E2D_5FC3X, ["偏移Y"] = _____6D4B_8BD5_4E2D_5FC3Y - _____6B63_5F0F_4E2D_5FC3Y}
end
____exports["按测试映射平移坐标"] = function(_____70B9, _____6620_5C04)
    return {x = _____70B9.x + _____6620_5C04["偏移X"], y = _____70B9.y + _____6620_5C04["偏移Y"]}
end
____exports["按测试映射平移XY坐标"] = function(_____70B9, _____6620_5C04)
    return {X = _____70B9.X + _____6620_5C04["偏移X"], Y = _____70B9.Y + _____6620_5C04["偏移Y"]}
end
____exports["按测试映射平移矩形"] = function(_____77E9_5F62, _____6620_5C04)
    return {
        ID = _____77E9_5F62.ID,
        ["名称"] = _____77E9_5F62["名称"],
        ["左"] = _____77E9_5F62["左"] + _____6620_5C04["偏移X"],
        ["右"] = _____77E9_5F62["右"] + _____6620_5C04["偏移X"],
        ["下"] = _____77E9_5F62["下"] + _____6620_5C04["偏移Y"],
        ["上"] = _____77E9_5F62["上"] + _____6620_5C04["偏移Y"]
    }
end
____exports["根据测试中心平移坐标"] = function(_____70B9, _____6B63_5F0F_4E2D_5FC3, _____6D4B_8BD5_4E2D_5FC3)
    return ____exports["按测试映射平移坐标"](
        _____70B9,
        ____exports["创建测试中心平移映射"](_____6B63_5F0F_4E2D_5FC3.x, _____6B63_5F0F_4E2D_5FC3.y, _____6D4B_8BD5_4E2D_5FC3.x, _____6D4B_8BD5_4E2D_5FC3.y)
    )
end
____exports["根据测试中心平移XY坐标"] = function(_____70B9, _____6B63_5F0F_4E2D_5FC3, _____6D4B_8BD5_4E2D_5FC3)
    return ____exports["按测试映射平移XY坐标"](
        _____70B9,
        ____exports["创建测试中心平移映射"](_____6B63_5F0F_4E2D_5FC3.x, _____6B63_5F0F_4E2D_5FC3.y, _____6D4B_8BD5_4E2D_5FC3.x, _____6D4B_8BD5_4E2D_5FC3.y)
    )
end
____exports["根据测试中心平移矩形"] = function(_____77E9_5F62, _____6B63_5F0F_4E2D_5FC3, _____6D4B_8BD5_4E2D_5FC3)
    return ____exports["按测试映射平移矩形"](
        _____77E9_5F62,
        ____exports["创建测试中心平移映射"](_____6B63_5F0F_4E2D_5FC3.x, _____6B63_5F0F_4E2D_5FC3.y, _____6D4B_8BD5_4E2D_5FC3.x, _____6D4B_8BD5_4E2D_5FC3.y)
    )
end
____exports["复制平移测试坐标数组"] = function(_____70B9_4F4D, _____6620_5C04)
    local result = {}
    do
        local i = 0
        while i < #_____70B9_4F4D do
            result[#result + 1] = ____exports["按测试映射平移坐标"](_____70B9_4F4D[i + 1], _____6620_5C04)
            i = i + 1
        end
    end
    return result
end
____exports["复制平移测试矩形数组"] = function(_____77E9_5F62_5217_8868, _____6620_5C04)
    local result = {}
    do
        local i = 0
        while i < #_____77E9_5F62_5217_8868 do
            result[#result + 1] = ____exports["按测试映射平移矩形"](_____77E9_5F62_5217_8868[i + 1], _____6620_5C04)
            i = i + 1
        end
    end
    return result
end
return ____exports
