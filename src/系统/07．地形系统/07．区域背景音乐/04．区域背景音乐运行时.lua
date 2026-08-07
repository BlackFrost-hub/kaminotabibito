local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local SetStackedSoundBJ = ____require_result_0.SetStackedSoundBJ
local ____require_result_1 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
local _____6CE8_518C_52A8_6001_77E9_5F62_533A_57DF = ____require_result_1["注册动态矩形区域"]
local _____6309_914D_7F6E_952E_6CE8_518C_52A8_6001_77E9_5F62_533A_57DF = ____require_result_1["按配置键注册动态矩形区域"]
local _____83B7_53D6_52A8_6001_77E9_5F62_533A_57DF = ____require_result_1["获取动态矩形区域"]
local _____8BFB_53D6_52A8_6001_77E9_5F62_533A_57DF_7EC4_5B50_533A_57DF_952E = ____require_result_1["读取动态矩形区域组子区域键"]
local _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF = ____require_result_1["注销动态矩形区域"]
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
--- 兼容剧情配置里的“声音全局名 @ 矩形全局名; ...”表达式。
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
                local rectName = __TS__StringTrim(__TS__StringSubstring(item, at + 1))
                local rectHandle = _____8BFB_53D6_5168_5C40_53E5_67C4(rectName) or _____83B7_53D6_52A8_6001_77E9_5F62_533A_57DF(rectName) or _____6309_914D_7F6E_952E_6CE8_518C_52A8_6001_77E9_5F62_533A_57DF(rectName)
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
    return _____914D_7F6E["键"] ~= "" and _____914D_7F6E["音乐路径"] ~= "" and (_____914D_7F6E["区域全局名"] ~= nil and _____914D_7F6E["区域全局名"] ~= "" or _____914D_7F6E["区域动态组键"] ~= nil and _____914D_7F6E["区域动态组键"] ~= "" or _____914D_7F6E["区域动态键"] ~= nil and _____914D_7F6E["区域动态键"] ~= "" or _____914D_7F6E["区域动态键列表"] ~= nil and #_____914D_7F6E["区域动态键列表"] > 0 or _____914D_7F6E["左"] ~= nil and _____914D_7F6E["右"] ~= nil and _____914D_7F6E["下"] ~= nil and _____914D_7F6E["上"] ~= nil and _____914D_7F6E["左"] < _____914D_7F6E["右"] and _____914D_7F6E["下"] < _____914D_7F6E["上"])
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
    local _____5171_4EAB_52A8_6001_77E9_5F62_952E_5217_8868 = {}
    if not _____4F7F_7528_5730_56FE_77E9_5F62 and _____914D_7F6E["区域动态键"] ~= nil and _____914D_7F6E["区域动态键"] ~= "" then
        _____5171_4EAB_52A8_6001_77E9_5F62_952E_5217_8868[#_____5171_4EAB_52A8_6001_77E9_5F62_952E_5217_8868 + 1] = _____914D_7F6E["区域动态键"]
    end
    if not _____4F7F_7528_5730_56FE_77E9_5F62 and _____914D_7F6E["区域动态键列表"] ~= nil then
        do
            local i = 0
            while i < #_____914D_7F6E["区域动态键列表"] do
                local _____952E = _____914D_7F6E["区域动态键列表"][i + 1]
                if _____952E ~= "" and __TS__ArrayIndexOf(_____5171_4EAB_52A8_6001_77E9_5F62_952E_5217_8868, _____952E) < 0 then
                    _____5171_4EAB_52A8_6001_77E9_5F62_952E_5217_8868[#_____5171_4EAB_52A8_6001_77E9_5F62_952E_5217_8868 + 1] = _____952E
                end
                i = i + 1
            end
        end
    end
    if not _____4F7F_7528_5730_56FE_77E9_5F62 and _____914D_7F6E["区域动态组键"] ~= nil and _____914D_7F6E["区域动态组键"] ~= "" then
        local _____5B50_533A_57DF_952E_5217_8868 = _____8BFB_53D6_52A8_6001_77E9_5F62_533A_57DF_7EC4_5B50_533A_57DF_952E(_____914D_7F6E["区域动态组键"], "背景音乐")
        do
            local i = 0
            while i < #_____5B50_533A_57DF_952E_5217_8868 do
                local _____952E = _____5B50_533A_57DF_952E_5217_8868[i + 1]
                if _____952E ~= "" and __TS__ArrayIndexOf(_____5171_4EAB_52A8_6001_77E9_5F62_952E_5217_8868, _____952E) < 0 then
                    _____5171_4EAB_52A8_6001_77E9_5F62_952E_5217_8868[#_____5171_4EAB_52A8_6001_77E9_5F62_952E_5217_8868 + 1] = _____952E
                end
                i = i + 1
            end
        end
    end
    local _____77E9_5F62_5217_8868 = {}
    local _____62E5_6709_52A8_6001_77E9_5F62_952E_5217_8868 = {}
    if _____4F7F_7528_5730_56FE_77E9_5F62 then
        local _____77E9_5F62 = _____8BFB_53D6_5168_5C40_53E5_67C4(_____914D_7F6E["区域全局名"])
        if _____53E5_67C4_6709_6548(_____77E9_5F62) then
            _____77E9_5F62_5217_8868[#_____77E9_5F62_5217_8868 + 1] = _____77E9_5F62
        end
    elseif #_____5171_4EAB_52A8_6001_77E9_5F62_952E_5217_8868 > 0 then
        do
            local i = 0
            while i < #_____5171_4EAB_52A8_6001_77E9_5F62_952E_5217_8868 do
                local _____77E9_5F62 = _____6309_914D_7F6E_952E_6CE8_518C_52A8_6001_77E9_5F62_533A_57DF(_____5171_4EAB_52A8_6001_77E9_5F62_952E_5217_8868[i + 1])
                if _____53E5_67C4_6709_6548(_____77E9_5F62) then
                    _____77E9_5F62_5217_8868[#_____77E9_5F62_5217_8868 + 1] = _____77E9_5F62
                end
                i = i + 1
            end
        end
    else
        local _____77E9_5F62_952E = "区域背景音乐." .. _____914D_7F6E["键"]
        local _____77E9_5F62 = _____6CE8_518C_52A8_6001_77E9_5F62_533A_57DF({
            ["键"] = _____77E9_5F62_952E,
            ["左"] = _____914D_7F6E["左"],
            ["右"] = _____914D_7F6E["右"],
            ["下"] = _____914D_7F6E["下"],
            ["上"] = _____914D_7F6E["上"],
            ["说明"] = "运行时区域背景音乐:" .. _____914D_7F6E["键"]
        })
        if _____53E5_67C4_6709_6548(_____77E9_5F62) then
            _____77E9_5F62_5217_8868[#_____77E9_5F62_5217_8868 + 1] = _____77E9_5F62
            _____62E5_6709_52A8_6001_77E9_5F62_952E_5217_8868[#_____62E5_6709_52A8_6001_77E9_5F62_952E_5217_8868 + 1] = _____77E9_5F62_952E
        end
    end
    if #_____77E9_5F62_5217_8868 == 0 then
        return false
    end
    local _____97F3_9891 = CreateSound(
        _____914D_7F6E["音乐路径"],
        true,
        false,
        false,
        10,
        10,
        "DefaultEAXON"
    )
    if not _____53E5_67C4_6709_6548(_____97F3_9891) then
        do
            local i = 0
            while i < #_____62E5_6709_52A8_6001_77E9_5F62_952E_5217_8868 do
                _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF(_____62E5_6709_52A8_6001_77E9_5F62_952E_5217_8868[i + 1])
                i = i + 1
            end
        end
        return false
    end
    _____533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6_72B6_6001_8868[_____914D_7F6E["键"]] = {["矩形列表"] = _____77E9_5F62_5217_8868, ["音频"] = _____97F3_9891, ["已挂载"] = false, ["拥有动态矩形键列表"] = _____62E5_6709_52A8_6001_77E9_5F62_952E_5217_8868}
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
    do
        local i = 0
        while i < #_____72B6_6001["矩形列表"] do
            if not ____exports["挂载区域背景音乐句柄"](true, _____72B6_6001["音频"], _____72B6_6001["矩形列表"][i + 1]) then
                return false
            end
            i = i + 1
        end
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
    do
        local i = 0
        while i < #_____72B6_6001["矩形列表"] do
            ____exports["卸载区域背景音乐句柄"](_____72B6_6001["音频"], _____72B6_6001["矩形列表"][i + 1])
            i = i + 1
        end
    end
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
    do
        local i = 0
        while i < #_____72B6_6001["拥有动态矩形键列表"] do
            _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF(_____72B6_6001["拥有动态矩形键列表"][i + 1])
            i = i + 1
        end
    end
    __TS__Delete(_____533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6_72B6_6001_8868, _____952E)
    return true
end
return ____exports
