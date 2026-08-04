local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local SetStackedSoundBJ = ____require_result_0.SetStackedSoundBJ
local Rect = jass.Rect
local RemoveRect = jass.RemoveRect
local CreateSound = jass.CreateSound
local StopSound = jass.StopSound
local _____533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6_72B6_6001_8868 = {}
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____8BFB_53D6_5168_5C40_53E5_67C4(_____53D8_91CF_540D)
    if _____53D8_91CF_540D == nil or _____53D8_91CF_540D == "" then
        return nil
    end
    return jglobals[_____53D8_91CF_540D] or nil
end
--- 统一的矩形音频低层挂载入口，静态配置、剧情动作和 Boss 战都从这里调用。
____exports["挂载区域背景音乐句柄"] = function(add, soundHandle, rectHandle)
    if not _____53E5_67C4_6709_6548(soundHandle) or not _____53E5_67C4_6709_6548(rectHandle) then
        return false
    end
    SetStackedSoundBJ(add, soundHandle, rectHandle)
    return true
end
____exports["卸载区域背景音乐句柄"] = function(soundHandle, rectHandle)
    return ____exports["挂载区域背景音乐句柄"](false, soundHandle, rectHandle)
end
____exports["停止区域背景音乐句柄"] = function(soundHandle)
    if not _____53E5_67C4_6709_6548(soundHandle) then
        return false
    end
    StopSound(soundHandle, true, false)
    return true
end
____exports["移除区域背景音乐矩形"] = function(rectHandle)
    if not _____53E5_67C4_6709_6548(rectHandle) then
        return false
    end
    RemoveRect(rectHandle)
    return true
end
--- 兼容剧情配置里的“gg_snd_xxx @ gg_rct_xxx; ...”表达式。
____exports["切换区域背景音乐表达式"] = function(expr, add)
    if expr == nil or expr == "" then
        return 0
    end
    local count = 0
    local list = __TS__StringSplit(expr, ";")
    do
        local i = 0
        while i < #list do
            do
                local item = __TS__StringTrim(list[i + 1])
                if #item == 0 then
                    goto __continue15
                end
                local at = (string.find(item, "@", nil, true) or 0) - 1
                if at < 0 then
                    goto __continue15
                end
                local soundHandle = _____8BFB_53D6_5168_5C40_53E5_67C4(__TS__StringTrim(__TS__StringSubstring(item, 0, at)))
                local rectHandle = _____8BFB_53D6_5168_5C40_53E5_67C4(__TS__StringTrim(__TS__StringSubstring(item, at + 1)))
                if ____exports["挂载区域背景音乐句柄"](add, soundHandle, rectHandle) then
                    count = count + 1
                end
            end
            ::__continue15::
            i = i + 1
        end
    end
    return count
end
local function _____8FD0_884C_65F6_914D_7F6E_6709_6548(_____914D_7F6E)
    return _____914D_7F6E["键"] ~= "" and _____914D_7F6E["音乐路径"] ~= "" and (_____914D_7F6E["区域全局名"] ~= nil and _____914D_7F6E["区域全局名"] ~= "" or _____914D_7F6E["左"] ~= nil and _____914D_7F6E["右"] ~= nil and _____914D_7F6E["下"] ~= nil and _____914D_7F6E["上"] ~= nil and _____914D_7F6E["左"] < _____914D_7F6E["右"] and _____914D_7F6E["下"] < _____914D_7F6E["上"])
end
--- 注册运行时区域。注册只创建句柄，不自动播放；需要播放时显式调用启用。
____exports["注册运行时区域背景音乐"] = function(_____914D_7F6E)
    if not _____8FD0_884C_65F6_914D_7F6E_6709_6548(_____914D_7F6E) then
        return false
    end
    if _____533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6_72B6_6001_8868[_____914D_7F6E["键"]] ~= nil then
        return true
    end
    local _____4F7F_7528_5730_56FE_77E9_5F62 = _____914D_7F6E["区域全局名"] ~= nil and _____914D_7F6E["区域全局名"] ~= ""
    local _____4F7F_7528_5730_56FE_77E9_5F62_1
    if _____4F7F_7528_5730_56FE_77E9_5F62 then
        _____4F7F_7528_5730_56FE_77E9_5F62_1 = _____8BFB_53D6_5168_5C40_53E5_67C4(_____914D_7F6E["区域全局名"])
    else
        _____4F7F_7528_5730_56FE_77E9_5F62_1 = Rect(_____914D_7F6E["左"], _____914D_7F6E["下"], _____914D_7F6E["右"], _____914D_7F6E["上"])
    end
    local _____77E9_5F62 = _____4F7F_7528_5730_56FE_77E9_5F62_1
    if not _____53E5_67C4_6709_6548(_____77E9_5F62) then
        return false
    end
    local _____97F3_9891 = CreateSound(
        _____914D_7F6E["音乐路径"],
        true,
        true,
        true,
        10,
        10,
        "DefaultEAXON"
    )
    if not _____53E5_67C4_6709_6548(_____97F3_9891) then
        if not _____4F7F_7528_5730_56FE_77E9_5F62 then
            ____exports["移除区域背景音乐矩形"](_____77E9_5F62)
        end
        return false
    end
    _____533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6_72B6_6001_8868[_____914D_7F6E["键"]] = {["矩形"] = _____77E9_5F62, ["音频"] = _____97F3_9891, ["已挂载"] = false, ["是否自建矩形"] = not _____4F7F_7528_5730_56FE_77E9_5F62}
    return true
end
____exports["启用运行时区域背景音乐"] = function(_____952E)
    local _____72B6_6001 = _____533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6_72B6_6001_8868[_____952E]
    if _____72B6_6001 == nil then
        return false
    end
    if _____72B6_6001["已挂载"] then
        return true
    end
    if not ____exports["挂载区域背景音乐句柄"](true, _____72B6_6001["音频"], _____72B6_6001["矩形"]) then
        return false
    end
    _____72B6_6001["已挂载"] = true
    return true
end
____exports["停用运行时区域背景音乐"] = function(_____952E)
    local _____72B6_6001 = _____533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6_72B6_6001_8868[_____952E]
    if _____72B6_6001 == nil then
        return false
    end
    if not _____72B6_6001["已挂载"] then
        return true
    end
    ____exports["卸载区域背景音乐句柄"](_____72B6_6001["音频"], _____72B6_6001["矩形"])
    _____72B6_6001["已挂载"] = false
    return true
end
--- 停止音频并释放运行时创建的矩形；地图编辑器矩形只释放音频句柄。
____exports["清理运行时区域背景音乐"] = function(_____952E)
    local _____72B6_6001 = _____533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6_72B6_6001_8868[_____952E]
    if _____72B6_6001 == nil then
        return false
    end
    ____exports["停用运行时区域背景音乐"](_____952E)
    ____exports["停止区域背景音乐句柄"](_____72B6_6001["音频"])
    if _____72B6_6001["是否自建矩形"] then
        ____exports["移除区域背景音乐矩形"](_____72B6_6001["矩形"])
    end
    __TS__Delete(_____533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6_72B6_6001_8868, _____952E)
    return true
end
return ____exports
