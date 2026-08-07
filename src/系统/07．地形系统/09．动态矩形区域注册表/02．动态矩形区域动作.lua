local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_52A8_6001_77E9_5F62_533A_57DF_914D_7F6E_8868 = require("系统.07．地形系统.09．动态矩形区域注册表.01．动态矩形区域配置表")
local _____52A8_6001_77E9_5F62_533A_57DF_914D_7F6E_8868 = ____01_FF0E_52A8_6001_77E9_5F62_533A_57DF_914D_7F6E_8868["动态矩形区域配置表"]
local _____8BFB_53D6_52A8_6001_77E9_5F62_533A_57DF_914D_7F6E = ____01_FF0E_52A8_6001_77E9_5F62_533A_57DF_914D_7F6E_8868["读取动态矩形区域配置"]
---
-- @noSelfInFile
local jass = require("jass.common")
local Rect = jass.Rect
local RemoveRect = jass.RemoveRect
local _____52A8_6001_77E9_5F62_533A_57DF_72B6_6001_8868 = {}
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____914D_7F6E_6709_6548(_____914D_7F6E)
    return _____914D_7F6E["键"] ~= "" and _____914D_7F6E["左"] < _____914D_7F6E["右"] and _____914D_7F6E["下"] < _____914D_7F6E["上"]
end
--- 注册配置并创建矩形；同一键重复调用只返回原句柄。
____exports["注册动态矩形区域"] = function(_____914D_7F6E)
    if not _____914D_7F6E_6709_6548(_____914D_7F6E) then
        return nil
    end
    local _____5DF2_6709_72B6_6001 = _____52A8_6001_77E9_5F62_533A_57DF_72B6_6001_8868[_____914D_7F6E["键"]]
    if _____5DF2_6709_72B6_6001 ~= nil and _____53E5_67C4_6709_6548(_____5DF2_6709_72B6_6001["矩形"]) then
        return _____5DF2_6709_72B6_6001["矩形"]
    end
    _____52A8_6001_77E9_5F62_533A_57DF_914D_7F6E_8868[_____914D_7F6E["键"]] = _____914D_7F6E
    local _____77E9_5F62 = Rect(_____914D_7F6E["左"], _____914D_7F6E["下"], _____914D_7F6E["右"], _____914D_7F6E["上"])
    if not _____53E5_67C4_6709_6548(_____77E9_5F62) then
        return nil
    end
    _____52A8_6001_77E9_5F62_533A_57DF_72B6_6001_8868[_____914D_7F6E["键"]] = {["配置"] = _____914D_7F6E, ["矩形"] = _____77E9_5F62}
    return _____77E9_5F62
end
--- 使用配置表中的键创建矩形；调用方只保留句柄，不重复保存坐标。
____exports["按配置键注册动态矩形区域"] = function(_____952E)
    local _____914D_7F6E = _____8BFB_53D6_52A8_6001_77E9_5F62_533A_57DF_914D_7F6E(_____952E)
    local ____temp_0
    if _____914D_7F6E == nil then
        ____temp_0 = nil
    else
        ____temp_0 = ____exports["注册动态矩形区域"](_____914D_7F6E)
    end
    return ____temp_0
end
____exports["获取动态矩形区域"] = function(_____952E)
    local _____72B6_6001 = _____52A8_6001_77E9_5F62_533A_57DF_72B6_6001_8868[_____952E]
    local ____temp_1
    if _____72B6_6001 ~= nil and _____53E5_67C4_6709_6548(_____72B6_6001["矩形"]) then
        ____temp_1 = _____72B6_6001["矩形"]
    else
        ____temp_1 = nil
    end
    return ____temp_1
end
--- 注销并删除运行时矩形；配置保留，便于同一键后续重新创建。
____exports["注销动态矩形区域"] = function(_____952E)
    local _____72B6_6001 = _____52A8_6001_77E9_5F62_533A_57DF_72B6_6001_8868[_____952E]
    if _____72B6_6001 == nil then
        return false
    end
    if _____53E5_67C4_6709_6548(_____72B6_6001["矩形"]) then
        RemoveRect(_____72B6_6001["矩形"])
    end
    __TS__Delete(_____52A8_6001_77E9_5F62_533A_57DF_72B6_6001_8868, _____952E)
    return true
end
____exports["清理全部动态矩形区域"] = function()
    for _____952E in pairs(_____52A8_6001_77E9_5F62_533A_57DF_72B6_6001_8868) do
        ____exports["注销动态矩形区域"](_____952E)
    end
end
return ____exports
