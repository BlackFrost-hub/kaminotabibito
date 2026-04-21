--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.07．技能吟唱条.00．常量定义")
local CAST_BAR_ENABLED = ____require_result_0.CAST_BAR_ENABLED
local DEFAULT_COLOR_ID = ____require_result_0.DEFAULT_COLOR_ID
local ____require_result_1 = require("系统.03．技能系统.07．技能吟唱条.02．渲染")
local startCastBar = ____require_result_1.startCastBar
local ____require_result_2 = require("系统.03．技能系统.07．技能吟唱条.03．输入")
local tryRegisterCastBarStes = ____require_result_2.tryRegisterCastBarStes
local _initialized = false
--- 初始化技能吟唱条系统（幂等）
function ____exports.init()
    if _initialized then
        return
    end
    if not CAST_BAR_ENABLED then
        return
    end
    _initialized = true
    tryRegisterCastBarStes(nil)
end
--- 手动触发吟唱条（供 Lua / TS 直接调用）
-- 
-- @param colorId 颜色ID (1-7)
-- @param totalTime 吟唱总时间（秒）
-- @param customString 自定义提示文本（可选）
function ____exports.showCastBar(colorId, totalTime, customString)
    if not CAST_BAR_ENABLED then
        return
    end
    startCastBar(nil, colorId or DEFAULT_COLOR_ID, totalTime, customString or "")
end
return ____exports
