--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04_FF0E_533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6 = require("系统.07．地形系统.07．区域背景音乐.04．区域背景音乐运行时")
local _____6CE8_518C_8FD0_884C_65F6_533A_57DF_80CC_666F_97F3_4E50 = ____04_FF0E_533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6["注册运行时区域背景音乐"]
local _____542F_7528_8FD0_884C_65F6_533A_57DF_80CC_666F_97F3_4E50 = ____04_FF0E_533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6["启用运行时区域背景音乐"]
local _____505C_7528_8FD0_884C_65F6_533A_57DF_80CC_666F_97F3_4E50 = ____04_FF0E_533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6["停用运行时区域背景音乐"]
local _____6E05_7406_8FD0_884C_65F6_533A_57DF_80CC_666F_97F3_4E50 = ____04_FF0E_533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6["清理运行时区域背景音乐"]
local _____5378_8F7D_533A_57DF_80CC_666F_97F3_4E50_53E5_67C4 = ____04_FF0E_533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6["卸载区域背景音乐句柄"]
local _____505C_6B62_533A_57DF_80CC_666F_97F3_4E50_53E5_67C4 = ____04_FF0E_533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6["停止区域背景音乐句柄"]
local _____79FB_9664_533A_57DF_80CC_666F_97F3_4E50_77E9_5F62 = ____04_FF0E_533A_57DF_80CC_666F_97F3_4E50_8FD0_884C_65F6["移除区域背景音乐矩形"]
---
-- @noSelfInFile
local jglobals = require("jass.globals")
____exports["封印守卫战区域音乐配置"] = {
    ["键"] = "第三章.封印守卫战",
    ["音乐路径"] = "Sound\\BGM\\Scene\\SealCore\\void_light_seal_land_80k.mp3",
    ["左"] = -928,
    ["右"] = 2848,
    ["下"] = -11648,
    ["上"] = -8160
}
____exports["第二章精灵城背景音乐配置"] = {["键"] = "第二章.精灵城背景", ["音乐路径"] = "Sound\\BGM\\Scene\\SealCore\\Ryo Kondo - Abode of the Ancient Gods.mp3", ["区域全局名"] = "gg_rct__________u"}
____exports["第二章精灵城王宫背景音乐配置"] = {
    ["键"] = "第二章.精灵城王宫背景",
    ["音乐路径"] = "Sound\\BGM\\Scene\\SealCore\\Falcom Sound Team J.D.K. - Royal Castle.mp3",
    ["左"] = -12672,
    ["右"] = -3872,
    ["下"] = -12832,
    ["上"] = -10848
}
____exports["第二章精灵城区域122背景音乐配置"] = {["键"] = "第二章.精灵城区域122背景", ["音乐路径"] = "Sound\\BGM\\Scene\\SealCore\\Falcom Sound Team J.D.K. - Guardian of the Sacred Treasure.mp3", ["区域全局名"] = "gg_rct______________122"}
____exports["第二章菲利斯攻城区域背景音乐配置"] = {
    ["键"] = "第二章.菲利斯攻城区域背景",
    ["音乐路径"] = "Sound\\BGM\\Scene\\SealCore\\Falcom Sound Team J.D.K. - Guardian of the Sacred Treasure.mp3",
    ["左"] = -8480,
    ["右"] = -3648,
    ["下"] = -16736,
    ["上"] = -12672
}
--- 巴尔扎罗斯死亡后，通往亚伦柯斯前的封印墓地背景音乐区域。
____exports["第三章亚伦柯斯前导区域背景音乐配置"] = {
    ["键"] = "第三章.亚伦柯斯前导区域",
    ["音乐路径"] = "Sound\\BGM\\Scene\\SealCore\\Falcom Sound Team J.D.K. - Seal of Time (Original).mp3",
    ["左"] = 4832,
    ["右"] = 11616,
    ["下"] = -17088,
    ["上"] = -14624
}
local _____56FE4_533A_57DF_5168_5C40_540D = "gg_rct______________027"
local _____56FE4_65E7_80CC_666F_97F3_4E50_5168_5C40_540D = "gg_snd_baiyihu_yueya"
local _____56FE4_65E7_80CC_666F_97F3_4E50_5DF2_6E05_7406 = false
local _____7B2C_4E09_7AE0_4E9A_4F26_67EF_65AF_524D_5BFC_533A_57DF_80CC_666F_97F3_4E50_5DF2_6C38_4E45_6E05_7406 = false
____exports["注册动态区域背景音乐"] = function(_____914D_7F6E)
    return _____6CE8_518C_8FD0_884C_65F6_533A_57DF_80CC_666F_97F3_4E50(_____914D_7F6E)
end
____exports["添加动态区域背景音乐"] = function(_____952E)
    return _____542F_7528_8FD0_884C_65F6_533A_57DF_80CC_666F_97F3_4E50(_____952E)
end
____exports["移除动态区域背景音乐"] = function(_____952E)
    return _____505C_7528_8FD0_884C_65F6_533A_57DF_80CC_666F_97F3_4E50(_____952E)
end
____exports["清理动态区域背景音乐"] = function(_____952E)
    return _____6E05_7406_8FD0_884C_65F6_533A_57DF_80CC_666F_97F3_4E50(_____952E)
end
--- 移除编辑器图4区域原有的环境音效并释放该矩形；清理后不再恢复。
local function _____6E05_7406_56FE4_65E7_80CC_666F_97F3_4E50()
    if _____56FE4_65E7_80CC_666F_97F3_4E50_5DF2_6E05_7406 then
        return true
    end
    local _____77E9_5F62 = jglobals[_____56FE4_533A_57DF_5168_5C40_540D]
    local _____97F3_9891 = jglobals[_____56FE4_65E7_80CC_666F_97F3_4E50_5168_5C40_540D]
    _____5378_8F7D_533A_57DF_80CC_666F_97F3_4E50_53E5_67C4(_____97F3_9891, _____77E9_5F62)
    _____505C_6B62_533A_57DF_80CC_666F_97F3_4E50_53E5_67C4(_____97F3_9891)
    _____79FB_9664_533A_57DF_80CC_666F_97F3_4E50_77E9_5F62(_____77E9_5F62)
    _____56FE4_65E7_80CC_666F_97F3_4E50_5DF2_6E05_7406 = true
    return true
end
____exports["注册封印守卫战区域音乐"] = function()
    return ____exports["注册动态区域背景音乐"](____exports["封印守卫战区域音乐配置"])
end
____exports["启用封印守卫战区域音乐"] = function()
    if not ____exports["注册封印守卫战区域音乐"]() then
        return false
    end
    return ____exports["添加动态区域背景音乐"](____exports["封印守卫战区域音乐配置"]["键"])
end
____exports["停用封印守卫战区域音乐"] = function()
    return ____exports["移除动态区域背景音乐"](____exports["封印守卫战区域音乐配置"]["键"])
end
____exports["清理封印守卫战区域音乐"] = function()
    return ____exports["清理动态区域背景音乐"](____exports["封印守卫战区域音乐配置"]["键"])
end
____exports["注册第二章精灵城背景音乐"] = function()
    return ____exports["注册动态区域背景音乐"](____exports["第二章精灵城背景音乐配置"])
end
____exports["启用第二章精灵城背景音乐"] = function()
    if not ____exports["注册第二章精灵城背景音乐"]() then
        return false
    end
    return ____exports["添加动态区域背景音乐"](____exports["第二章精灵城背景音乐配置"]["键"])
end
____exports["停用第二章精灵城背景音乐"] = function()
    return ____exports["移除动态区域背景音乐"](____exports["第二章精灵城背景音乐配置"]["键"])
end
____exports["清理第二章精灵城背景音乐"] = function()
    return ____exports["清理动态区域背景音乐"](____exports["第二章精灵城背景音乐配置"]["键"])
end
____exports["注册第二章精灵城王宫背景音乐"] = function()
    return ____exports["注册动态区域背景音乐"](____exports["第二章精灵城王宫背景音乐配置"])
end
____exports["启用第二章精灵城王宫背景音乐"] = function()
    if not ____exports["注册第二章精灵城王宫背景音乐"]() then
        return false
    end
    return ____exports["添加动态区域背景音乐"](____exports["第二章精灵城王宫背景音乐配置"]["键"])
end
____exports["停用第二章精灵城王宫背景音乐"] = function()
    return ____exports["移除动态区域背景音乐"](____exports["第二章精灵城王宫背景音乐配置"]["键"])
end
____exports["清理第二章精灵城王宫背景音乐"] = function()
    return ____exports["清理动态区域背景音乐"](____exports["第二章精灵城王宫背景音乐配置"]["键"])
end
____exports["注册第二章精灵城区域122背景音乐"] = function()
    return ____exports["注册动态区域背景音乐"](____exports["第二章精灵城区域122背景音乐配置"])
end
____exports["启用第二章精灵城区域122背景音乐"] = function()
    if not ____exports["注册第二章精灵城区域122背景音乐"]() then
        return false
    end
    return ____exports["添加动态区域背景音乐"](____exports["第二章精灵城区域122背景音乐配置"]["键"])
end
____exports["停用第二章精灵城区域122背景音乐"] = function()
    return ____exports["移除动态区域背景音乐"](____exports["第二章精灵城区域122背景音乐配置"]["键"])
end
____exports["清理第二章精灵城区域122背景音乐"] = function()
    return ____exports["清理动态区域背景音乐"](____exports["第二章精灵城区域122背景音乐配置"]["键"])
end
____exports["注册第二章菲利斯攻城区域背景音乐"] = function()
    return ____exports["注册动态区域背景音乐"](____exports["第二章菲利斯攻城区域背景音乐配置"])
end
____exports["启用第二章菲利斯攻城区域背景音乐"] = function()
    if not ____exports["注册第二章菲利斯攻城区域背景音乐"]() then
        return false
    end
    return ____exports["添加动态区域背景音乐"](____exports["第二章菲利斯攻城区域背景音乐配置"]["键"])
end
____exports["停用第二章菲利斯攻城区域背景音乐"] = function()
    return ____exports["移除动态区域背景音乐"](____exports["第二章菲利斯攻城区域背景音乐配置"]["键"])
end
____exports["清理第二章菲利斯攻城区域背景音乐"] = function()
    return ____exports["清理动态区域背景音乐"](____exports["第二章菲利斯攻城区域背景音乐配置"]["键"])
end
____exports["注册第三章亚伦柯斯前导区域背景音乐"] = function()
    if _____7B2C_4E09_7AE0_4E9A_4F26_67EF_65AF_524D_5BFC_533A_57DF_80CC_666F_97F3_4E50_5DF2_6C38_4E45_6E05_7406 then
        return false
    end
    return ____exports["注册动态区域背景音乐"](____exports["第三章亚伦柯斯前导区域背景音乐配置"])
end
____exports["启用第三章亚伦柯斯前导区域背景音乐"] = function()
    if _____7B2C_4E09_7AE0_4E9A_4F26_67EF_65AF_524D_5BFC_533A_57DF_80CC_666F_97F3_4E50_5DF2_6C38_4E45_6E05_7406 then
        return false
    end
    if not ____exports["注册第三章亚伦柯斯前导区域背景音乐"]() then
        return false
    end
    return ____exports["添加动态区域背景音乐"](____exports["第三章亚伦柯斯前导区域背景音乐配置"]["键"])
end
____exports["停用第三章亚伦柯斯前导区域背景音乐"] = function()
    return ____exports["移除动态区域背景音乐"](____exports["第三章亚伦柯斯前导区域背景音乐配置"]["键"])
end
____exports["清理第三章亚伦柯斯前导区域背景音乐"] = function()
    return ____exports["清理动态区域背景音乐"](____exports["第三章亚伦柯斯前导区域背景音乐配置"]["键"])
end
--- 亚伦柯斯战斗启动后永久移除图4旧音效及本段动态音乐。
____exports["清理第三章亚伦柯斯战斗前图4区域背景音乐"] = function()
    local _____52A8_6001_97F3_4E50_5DF2_6E05_7406 = ____exports["清理第三章亚伦柯斯前导区域背景音乐"]()
    local _____56FE4_65E7_97F3_4E50_5DF2_6E05_7406 = _____6E05_7406_56FE4_65E7_80CC_666F_97F3_4E50()
    _____7B2C_4E09_7AE0_4E9A_4F26_67EF_65AF_524D_5BFC_533A_57DF_80CC_666F_97F3_4E50_5DF2_6C38_4E45_6E05_7406 = true
    return _____52A8_6001_97F3_4E50_5DF2_6E05_7406 or _____56FE4_65E7_97F3_4E50_5DF2_6E05_7406
end
--- 会议决定出发后，暂时卸载第二章原有区域音乐并切换到攻城区域音乐。
____exports["开始第二章菲利斯攻城区域音乐"] = function()
    ____exports["清理第二章精灵城背景音乐"]()
    ____exports["清理第二章精灵城王宫背景音乐"]()
    ____exports["清理第二章精灵城区域122背景音乐"]()
    return ____exports["启用第二章菲利斯攻城区域背景音乐"]()
end
--- 菲利斯死亡后清理攻城音乐，并恢复第二章原有区域音乐。
____exports["结束第二章菲利斯攻城区域音乐"] = function()
    ____exports["清理第二章菲利斯攻城区域背景音乐"]()
    local _____57CE_533A_97F3_4E50_5DF2_6062_590D = ____exports["启用第二章精灵城背景音乐"]()
    local _____738B_5BAB_97F3_4E50_5DF2_6062_590D = ____exports["启用第二章精灵城王宫背景音乐"]()
    local _____533A_57DF122_97F3_4E50_5DF2_6062_590D = ____exports["启用第二章精灵城区域122背景音乐"]()
    return _____57CE_533A_97F3_4E50_5DF2_6062_590D and _____738B_5BAB_97F3_4E50_5DF2_6062_590D and _____533A_57DF122_97F3_4E50_5DF2_6062_590D
end
____exports["注册封印核心战后区域音乐"] = function()
    return ____exports["注册封印守卫战区域音乐"]()
end
____exports["启用封印核心战后区域音乐"] = function()
    return ____exports["启用封印守卫战区域音乐"]()
end
____exports["停用封印核心战后区域音乐"] = function()
    return ____exports["停用封印守卫战区域音乐"]()
end
____exports["清理封印核心战后区域音乐"] = function()
    return ____exports["清理封印守卫战区域音乐"]()
end
return ____exports
