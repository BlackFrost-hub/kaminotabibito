--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.07．地形系统.09．动态矩形区域注册表.03．地图预设矩形区域配置表")
local _____8BFB_53D6_5730_56FE_9884_8BBE_77E9_5F62_533A_57DF_914D_7F6E = ____require_result_0["读取地图预设矩形区域配置"]
local _____52A8_6001_77E9_5F62_533A_57DF = require("系统.07．地形系统.09．动态矩形区域注册表.02．动态矩形区域动作")
local _____83B7_53D6_52A8_6001_77E9_5F62_533A_57DF = _____52A8_6001_77E9_5F62_533A_57DF["获取动态矩形区域"]
local _____6309_914D_7F6E_952E_6CE8_518C_52A8_6001_77E9_5F62_533A_57DF = _____52A8_6001_77E9_5F62_533A_57DF["按配置键注册动态矩形区域"]
--- 通过语义名称读取地图预置矩形；兼容直接传入旧 gg_rct 变量名。
____exports["获取地图预设矩形区域"] = function(_____540D_79F0_6216_53D8_91CF_540D)
    if _____540D_79F0_6216_53D8_91CF_540D == nil or _____540D_79F0_6216_53D8_91CF_540D == "" then
        return nil
    end
    local _____914D_7F6E = _____8BFB_53D6_5730_56FE_9884_8BBE_77E9_5F62_533A_57DF_914D_7F6E(_____540D_79F0_6216_53D8_91CF_540D)
    local ____temp_1
    if _____914D_7F6E ~= nil then
        ____temp_1 = _____914D_7F6E["地图矩形变量名"]
    else
        ____temp_1 = _____540D_79F0_6216_53D8_91CF_540D
    end
    local _____53D8_91CF_540D = ____temp_1
    if _____53D8_91CF_540D == nil or _____53D8_91CF_540D == "" then
        return nil
    end
    return jglobals[_____53D8_91CF_540D] or nil
end
--- 地图预置矩形优先；没有预置定义时读取或创建已有动态矩形配置。
____exports["获取矩形区域"] = function(_____540D_79F0)
    local _____5730_56FE_77E9_5F62 = ____exports["获取地图预设矩形区域"](_____540D_79F0)
    if _____5730_56FE_77E9_5F62 ~= nil and _____5730_56FE_77E9_5F62 ~= 0 then
        return _____5730_56FE_77E9_5F62
    end
    return _____83B7_53D6_52A8_6001_77E9_5F62_533A_57DF(_____540D_79F0) or _____6309_914D_7F6E_952E_6CE8_518C_52A8_6001_77E9_5F62_533A_57DF(_____540D_79F0)
end
local function _____8FFD_52A0_77E9_5F62_533A_57DF(_____540D_79F0, _____7ED3_679C, _____5DF2_5C55_5F00_7EC4_5408)
    if _____540D_79F0 == nil or _____540D_79F0 == "" then
        return
    end
    local _____914D_7F6E = _____8BFB_53D6_5730_56FE_9884_8BBE_77E9_5F62_533A_57DF_914D_7F6E(_____540D_79F0)
    if _____914D_7F6E ~= nil and _____914D_7F6E["矩形区域名称列表"] ~= nil then
        if _____5DF2_5C55_5F00_7EC4_5408[_____540D_79F0] then
            return
        end
        _____5DF2_5C55_5F00_7EC4_5408[_____540D_79F0] = true
        do
            local i = 0
            while i < #_____914D_7F6E["矩形区域名称列表"] do
                _____8FFD_52A0_77E9_5F62_533A_57DF(_____914D_7F6E["矩形区域名称列表"][i + 1], _____7ED3_679C, _____5DF2_5C55_5F00_7EC4_5408)
                i = i + 1
            end
        end
        return
    end
    local _____77E9_5F62 = ____exports["获取矩形区域"](_____540D_79F0)
    if _____77E9_5F62 ~= nil and _____77E9_5F62 ~= 0 then
        _____7ED3_679C[#_____7ED3_679C + 1] = _____77E9_5F62
    end
end
____exports["获取矩形区域列表"] = function(_____540D_79F0_5217_8868)
    local _____7ED3_679C = {}
    local _____5DF2_5C55_5F00_7EC4_5408 = {}
    do
        local i = 0
        while i < #_____540D_79F0_5217_8868 do
            _____8FFD_52A0_77E9_5F62_533A_57DF(_____540D_79F0_5217_8868[i + 1], _____7ED3_679C, _____5DF2_5C55_5F00_7EC4_5408)
            i = i + 1
        end
    end
    return _____7ED3_679C
end
return ____exports
