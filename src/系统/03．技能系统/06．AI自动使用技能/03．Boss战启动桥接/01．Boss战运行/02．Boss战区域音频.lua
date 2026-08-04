--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.00．常量定义")
local ____Boss_6218_5019_9009_97F3_9891_53D8_91CF_540D_5217_8868 = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战候选音频变量名列表"]
local ____Boss_6218_8FD0_884C_6A21_5757_540D = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战运行模块名"]
local ____Boss_6218_80DC_5229_97F3_4E50_4FDD_7559_6BEB_79D2 = ____00_FF0E_5E38_91CF_5B9A_4E49["Boss战胜利音乐保留毫秒"]
local ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文")
local _____8BFB_53D6_77E9_5F62_5F53_524DBoss_6218_4E0A_4E0B_6587 = ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587["读取矩形当前Boss战上下文"]
local _____8BBE_7F6E_77E9_5F62_5F53_524DBoss_6218_4E0A_4E0B_6587 = ____01_FF0EBoss_6218_8FD0_884C_4E0A_4E0B_6587["设置矩形当前Boss战上下文"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.07．地形系统.07．区域背景音乐.04．区域背景音乐运行时")
local _____6302_8F7D_533A_57DF_80CC_666F_97F3_4E50_53E5_67C4 = ____require_result_0["挂载区域背景音乐句柄"]
local _____5378_8F7D_533A_57DF_80CC_666F_97F3_4E50_53E5_67C4 = ____require_result_0["卸载区域背景音乐句柄"]
local _____79FB_9664_533A_57DF_80CC_666F_97F3_4E50_77E9_5F62 = ____require_result_0["移除区域背景音乐矩形"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local GetHandleId = jass.GetHandleId
local function _____83B7_53D6_53E5_67C4ID(handle)
    if handle == nil or handle == 0 then
        return 0
    end
    return GetHandleId(handle) or 0
end
local function _____77E9_5F62_6DFB_52A0_97F3_9891(rectHandle, soundHandle)
    if rectHandle == nil or rectHandle == 0 then
        return
    end
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    _____6302_8F7D_533A_57DF_80CC_666F_97F3_4E50_53E5_67C4(true, soundHandle, rectHandle)
end
local function _____77E9_5F62_79FB_9664_97F3_9891(rectHandle, soundHandle)
    if rectHandle == nil or rectHandle == 0 then
        return
    end
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    _____5378_8F7D_533A_57DF_80CC_666F_97F3_4E50_53E5_67C4(soundHandle, rectHandle)
end
local function _____79FB_9664_4E0A_4E0B_6587_533A_57DF_97F3_9891(context)
    if context == nil then
        return
    end
    if context["地点矩形"] == nil or context["地点矩形"] == 0 then
        return
    end
    _____77E9_5F62_79FB_9664_97F3_9891(context["地点矩形"], context["战斗音乐"])
    _____77E9_5F62_79FB_9664_97F3_9891(context["地点矩形"], context["胜利音乐"])
end
local function _____6E05_7406_52A8_6001_5730_70B9_77E9_5F62(context)
    if not context["地点矩形是否动态"] then
        return
    end
    if context["地点矩形"] == nil or context["地点矩形"] == 0 then
        return
    end
    local rectHandle = context["地点矩形"]
    context["地点矩形"] = nil
    context["地点句柄ID"] = 0
    _____79FB_9664_533A_57DF_80CC_666F_97F3_4E50_77E9_5F62(rectHandle)
end
____exports["清理矩形Boss战候选音频"] = function(rectHandle)
    if rectHandle == nil or rectHandle == 0 then
        return
    end
    local _____5DF2_5904_7406_97F3_9891_8868 = {}
    do
        local i = 0
        while i < #____Boss_6218_5019_9009_97F3_9891_53D8_91CF_540D_5217_8868 do
            do
                local _____53D8_91CF_540D = ____Boss_6218_5019_9009_97F3_9891_53D8_91CF_540D_5217_8868[i + 1]
                local _____97F3_9891_53E5_67C4 = jglobals[_____53D8_91CF_540D]
                local _____97F3_9891_53E5_67C4ID = _____83B7_53D6_53E5_67C4ID(_____97F3_9891_53E5_67C4)
                if _____97F3_9891_53E5_67C4ID == 0 or _____5DF2_5904_7406_97F3_9891_8868[_____97F3_9891_53E5_67C4ID] then
                    goto __continue19
                end
                _____5DF2_5904_7406_97F3_9891_8868[_____97F3_9891_53E5_67C4ID] = true
                _____77E9_5F62_79FB_9664_97F3_9891(rectHandle, _____97F3_9891_53E5_67C4)
            end
            ::__continue19::
            i = i + 1
        end
    end
end
____exports["接管Boss战区域音频"] = function(context)
    if context["地点句柄ID"] == 0 or context["地点矩形"] == nil or context["地点矩形"] == 0 then
        return
    end
    local _____65E7_4E0A_4E0B_6587 = _____8BFB_53D6_77E9_5F62_5F53_524DBoss_6218_4E0A_4E0B_6587(context["地点句柄ID"])
    if _____65E7_4E0A_4E0B_6587 ~= nil and _____65E7_4E0A_4E0B_6587["运行代次"] ~= context["运行代次"] then
        _____65E7_4E0A_4E0B_6587["胜利音乐移除时间"] = 0
        _____79FB_9664_4E0A_4E0B_6587_533A_57DF_97F3_9891(_____65E7_4E0A_4E0B_6587)
    end
    ____exports["清理矩形Boss战候选音频"](context["地点矩形"])
    _____77E9_5F62_6DFB_52A0_97F3_9891(context["地点矩形"], context["战斗音乐"])
    _____8BBE_7F6E_77E9_5F62_5F53_524DBoss_6218_4E0A_4E0B_6587(context["地点句柄ID"], context)
    debugLogForce(
        ____Boss_6218_8FD0_884C_6A21_5757_540D,
        "接管区域音频",
        "rect=",
        context["地点句柄ID"],
        "generation=",
        context["运行代次"]
    )
end
____exports["结束Boss战区域音频"] = function(context, nowMs)
    if context["地点句柄ID"] == 0 or context["地点矩形"] == nil or context["地点矩形"] == 0 then
        return
    end
    local _____5F53_524D_77E9_5F62_4E0A_4E0B_6587 = _____8BFB_53D6_77E9_5F62_5F53_524DBoss_6218_4E0A_4E0B_6587(context["地点句柄ID"])
    if _____5F53_524D_77E9_5F62_4E0A_4E0B_6587 ~= nil and _____5F53_524D_77E9_5F62_4E0A_4E0B_6587["运行代次"] ~= context["运行代次"] then
        return
    end
    _____77E9_5F62_79FB_9664_97F3_9891(context["地点矩形"], context["战斗音乐"])
    _____77E9_5F62_6DFB_52A0_97F3_9891(context["地点矩形"], context["胜利音乐"])
    context["胜利音乐移除时间"] = nowMs + ____Boss_6218_80DC_5229_97F3_4E50_4FDD_7559_6BEB_79D2
    _____8BBE_7F6E_77E9_5F62_5F53_524DBoss_6218_4E0A_4E0B_6587(context["地点句柄ID"], context)
    debugLogForce(
        ____Boss_6218_8FD0_884C_6A21_5757_540D,
        "切换胜利音频",
        "rect=",
        context["地点句柄ID"],
        "generation=",
        context["运行代次"],
        "removeAt=",
        context["胜利音乐移除时间"]
    )
end
____exports["尝试移除过期胜利音频"] = function(context, nowMs)
    if not context["是否已结束"] then
        return false
    end
    if context["胜利音乐移除时间"] <= 0 or nowMs < context["胜利音乐移除时间"] then
        return false
    end
    if context["地点句柄ID"] == 0 or context["地点矩形"] == nil or context["地点矩形"] == 0 then
        return false
    end
    local _____5F53_524D_77E9_5F62_4E0A_4E0B_6587 = _____8BFB_53D6_77E9_5F62_5F53_524DBoss_6218_4E0A_4E0B_6587(context["地点句柄ID"])
    if _____5F53_524D_77E9_5F62_4E0A_4E0B_6587 == nil or _____5F53_524D_77E9_5F62_4E0A_4E0B_6587["运行代次"] ~= context["运行代次"] then
        context["胜利音乐移除时间"] = 0
        _____6E05_7406_52A8_6001_5730_70B9_77E9_5F62(context)
        return true
    end
    _____77E9_5F62_79FB_9664_97F3_9891(context["地点矩形"], context["胜利音乐"])
    context["胜利音乐移除时间"] = 0
    _____8BBE_7F6E_77E9_5F62_5F53_524DBoss_6218_4E0A_4E0B_6587(context["地点句柄ID"], nil)
    _____6E05_7406_52A8_6001_5730_70B9_77E9_5F62(context)
    debugLogForce(
        ____Boss_6218_8FD0_884C_6A21_5757_540D,
        "移除过期胜利音频",
        "rect=",
        context["地点句柄ID"],
        "generation=",
        context["运行代次"]
    )
    return true
end
return ____exports
