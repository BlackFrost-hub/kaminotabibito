--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local Rect = jass.Rect
local RemoveRect = jass.RemoveRect
local ____require_result_0 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local RectContainsUnit = ____require_result_0.RectContainsUnit
____exports["创建动态矩形区域组"] = function(_____540D_79F0, _____914D_7F6E_5217_8868)
    local _____533A_57DF_5217_8868 = {}
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
            _____533A_57DF_5217_8868[#_____533A_57DF_5217_8868 + 1] = {
                ["配置"] = _____914D_7F6E,
                ["矩形"] = Rect(_____914D_7F6E["左"], _____914D_7F6E["下"], _____914D_7F6E["右"], _____914D_7F6E["上"]),
                ["中心X"] = (_____914D_7F6E["左"] + _____914D_7F6E["右"]) / 2,
                ["中心Y"] = (_____914D_7F6E["下"] + _____914D_7F6E["上"]) / 2
            }
            i = i + 1
        end
    end
    return {["名称"] = _____540D_79F0, ["区域列表"] = _____533A_57DF_5217_8868}
end
____exports["销毁动态矩形区域组"] = function(_____533A_57DF_7EC4)
    if _____533A_57DF_7EC4 == nil then
        return
    end
    local _____533A_57DF_5217_8868 = _____533A_57DF_7EC4["区域列表"]
    do
        local i = 0
        while i < #_____533A_57DF_5217_8868 do
            local _____533A_57DF = _____533A_57DF_5217_8868[i + 1]
            if _____533A_57DF["矩形"] ~= nil and _____533A_57DF["矩形"] ~= 0 then
                RemoveRect(_____533A_57DF["矩形"])
                _____533A_57DF["矩形"] = nil
            end
            i = i + 1
        end
    end
end
____exports["单位所在动态矩形区域"] = function(_____5355_4F4D, _____533A_57DF_7EC4)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____533A_57DF_7EC4 == nil then
        return nil
    end
    local _____533A_57DF_5217_8868 = _____533A_57DF_7EC4["区域列表"]
    do
        local i = 0
        while i < #_____533A_57DF_5217_8868 do
            local _____533A_57DF = _____533A_57DF_5217_8868[i + 1]
            if _____533A_57DF["矩形"] ~= nil and _____533A_57DF["矩形"] ~= 0 and RectContainsUnit(_____533A_57DF["矩形"], _____5355_4F4D) then
                return _____533A_57DF
            end
            i = i + 1
        end
    end
    return nil
end
____exports["单位是否在动态矩形区域组内"] = function(_____5355_4F4D, _____533A_57DF_7EC4)
    return ____exports["单位所在动态矩形区域"](_____5355_4F4D, _____533A_57DF_7EC4) ~= nil
end
____exports["点是否在动态矩形配置内"] = function(x, y, _____914D_7F6E)
    return x >= _____914D_7F6E["左"] and x <= _____914D_7F6E["右"] and y >= _____914D_7F6E["下"] and y <= _____914D_7F6E["上"]
end
____exports["统计动态矩形区域内单位数量"] = function(_____533A_57DF, _____5355_4F4D_5217_8868)
    if _____533A_57DF == nil or _____533A_57DF["矩形"] == nil or _____533A_57DF["矩形"] == 0 then
        return 0
    end
    local _____6570_91CF = 0
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            local _____5355_4F4D = _____5355_4F4D_5217_8868[i + 1]
            if _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and RectContainsUnit(_____533A_57DF["矩形"], _____5355_4F4D) then
                _____6570_91CF = _____6570_91CF + 1
            end
            i = i + 1
        end
    end
    return _____6570_91CF
end
____exports["取动态矩形区域中心"] = function(_____533A_57DF)
    return {x = _____533A_57DF["中心X"], y = _____533A_57DF["中心Y"]}
end
return ____exports
