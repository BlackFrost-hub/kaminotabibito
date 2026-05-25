local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____01_FF0E_533A_57DF_80CC_666F_97F3_4E50_914D_7F6E_8868 = require("系统.07．地形系统.07．区域背景音乐.01．区域背景音乐配置表")
local _____533A_57DF_80CC_666F_97F3_4E50_914D_7F6E_8868 = ____01_FF0E_533A_57DF_80CC_666F_97F3_4E50_914D_7F6E_8868.default
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local SetStackedSoundBJ = ____require_result_0.SetStackedSoundBJ
local GetRandomInt = jass.GetRandomInt
local _____968F_673A_73AF_5883_97F3_4E50_7ED3_679C = __TS__New(Map)
local function _____8BFB_53D6_533A_57DF_53E5_67C4(_____533A_57DF_53D8_91CF_540D)
    if _____533A_57DF_53D8_91CF_540D == nil or _____533A_57DF_53D8_91CF_540D == "" then
        return nil
    end
    return jglobals[_____533A_57DF_53D8_91CF_540D] or nil
end
local function _____8BFB_53D6_97F3_9891_53E5_67C4(_____97F3_4E50_53D8_91CF_540D)
    if _____97F3_4E50_53D8_91CF_540D == nil or _____97F3_4E50_53D8_91CF_540D == "" then
        return nil
    end
    return jglobals[_____97F3_4E50_53D8_91CF_540D] or nil
end
local function _____5378_8F7D_533A_57DF_97F3_9891(rectHandle, soundVarName)
    local soundHandle = _____8BFB_53D6_97F3_9891_53E5_67C4(soundVarName)
    if rectHandle == nil or rectHandle == 0 or soundHandle == nil or soundHandle == 0 then
        return false
    end
    SetStackedSoundBJ(false, soundHandle, rectHandle)
    return true
end
local function _____6302_8F7D_533A_57DF_97F3_9891(rectHandle, soundVarName)
    local soundHandle = _____8BFB_53D6_97F3_9891_53E5_67C4(soundVarName)
    if rectHandle == nil or rectHandle == 0 or soundHandle == nil or soundHandle == 0 then
        return false
    end
    SetStackedSoundBJ(true, soundHandle, rectHandle)
    return true
end
local function _____83B7_53D6_73AF_5883_97F3_4E50_53D8_91CF_540D(_____914D_7F6E)
    local _____968F_673A_5217_8868 = _____914D_7F6E["随机环境音乐变量名列表"]
    if _____968F_673A_5217_8868 ~= nil and #_____968F_673A_5217_8868 > 0 then
        local _____7EC4_540D = _____914D_7F6E["随机音乐组"] or _____914D_7F6E["场景定义"]
        local _____5DF2_8BB0_5F55_7ED3_679C = _____968F_673A_73AF_5883_97F3_4E50_7ED3_679C:get(_____7EC4_540D)
        if _____5DF2_8BB0_5F55_7ED3_679C ~= nil and _____5DF2_8BB0_5F55_7ED3_679C ~= "" then
            return _____5DF2_8BB0_5F55_7ED3_679C
        end
        local _____7D22_5F15 = GetRandomInt(1, #_____968F_673A_5217_8868) - 1
        local _____53D8_91CF_540D = _____968F_673A_5217_8868[_____7D22_5F15 + 1]
        if _____53D8_91CF_540D ~= nil and _____53D8_91CF_540D ~= "" then
            _____968F_673A_73AF_5883_97F3_4E50_7ED3_679C:set(_____7EC4_540D, _____53D8_91CF_540D)
            return _____53D8_91CF_540D
        end
    end
    return _____914D_7F6E["默认环境音乐变量名"]
end
____exports["初始化区域环境背景音乐"] = function()
    local count = 0
    _____968F_673A_73AF_5883_97F3_4E50_7ED3_679C:clear()
    do
        local i = 0
        while i < #_____533A_57DF_80CC_666F_97F3_4E50_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____533A_57DF_80CC_666F_97F3_4E50_914D_7F6E_8868[i + 1]
                local rectHandle = _____8BFB_53D6_533A_57DF_53E5_67C4(_____914D_7F6E["区域变量名"])
                if rectHandle == nil or rectHandle == 0 then
                    goto __continue16
                end
                local _____73AF_5883_97F3_4E50_53D8_91CF_540D = _____83B7_53D6_73AF_5883_97F3_4E50_53D8_91CF_540D(_____914D_7F6E)
                if _____6302_8F7D_533A_57DF_97F3_9891(rectHandle, _____73AF_5883_97F3_4E50_53D8_91CF_540D) then
                    count = count + 1
                end
            end
            ::__continue16::
            i = i + 1
        end
    end
    return count
end
____exports["清空单个区域背景音乐"] = function(_____914D_7F6E)
    local rectHandle = _____8BFB_53D6_533A_57DF_53E5_67C4(_____914D_7F6E["区域变量名"])
    if rectHandle == nil or rectHandle == 0 then
        return 0
    end
    local count = 0
    if _____5378_8F7D_533A_57DF_97F3_9891(rectHandle, _____914D_7F6E["默认环境音乐变量名"]) then
        count = count + 1
    end
    local _____968F_673A_5217_8868 = _____914D_7F6E["随机环境音乐变量名列表"]
    if _____968F_673A_5217_8868 ~= nil then
        do
            local i = 0
            while i < #_____968F_673A_5217_8868 do
                if _____5378_8F7D_533A_57DF_97F3_9891(rectHandle, _____968F_673A_5217_8868[i + 1]) then
                    count = count + 1
                end
                i = i + 1
            end
        end
    end
    if _____5378_8F7D_533A_57DF_97F3_9891(rectHandle, _____914D_7F6E["战斗音乐变量名"]) then
        count = count + 1
    end
    if _____5378_8F7D_533A_57DF_97F3_9891(rectHandle, _____914D_7F6E["胜利音乐变量名"]) then
        count = count + 1
    end
    return count
end
____exports["清空指定场景区域背景音乐"] = function(_____573A_666F_5B9A_4E49)
    if _____573A_666F_5B9A_4E49 == nil or _____573A_666F_5B9A_4E49 == "" then
        return 0
    end
    local count = 0
    do
        local i = 0
        while i < #_____533A_57DF_80CC_666F_97F3_4E50_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____533A_57DF_80CC_666F_97F3_4E50_914D_7F6E_8868[i + 1]
                if _____914D_7F6E["场景定义"] ~= _____573A_666F_5B9A_4E49 then
                    goto __continue31
                end
                count = count + ____exports["清空单个区域背景音乐"](_____914D_7F6E)
            end
            ::__continue31::
            i = i + 1
        end
    end
    return count
end
____exports["清空全部区域背景音乐"] = function()
    local count = 0
    do
        local i = 0
        while i < #_____533A_57DF_80CC_666F_97F3_4E50_914D_7F6E_8868 do
            count = count + ____exports["清空单个区域背景音乐"](_____533A_57DF_80CC_666F_97F3_4E50_914D_7F6E_8868[i + 1])
            i = i + 1
        end
    end
    return count
end
____exports["init区域背景音乐"] = function()
    ____exports["初始化区域环境背景音乐"]()
end
return ____exports
