--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_5185_90E8_5DE5_5177 = require("lib.扩展函数.封装函数.04．硬件输入.02．内部工具")
local runFalseLocalRegistration = ____02_FF0E_5185_90E8_5DE5_5177.runFalseLocalRegistration
local ____06_FF0E_7A97_53E3_51FD_6570 = require("lib.扩展函数.封装函数.04．硬件输入.06．窗口函数")
local getClientHeight = ____06_FF0E_7A97_53E3_51FD_6570.getClientHeight
local getWindowHeight = ____06_FF0E_7A97_53E3_51FD_6570.getWindowHeight
--- 硬件输入 - 鼠标函数
-- 
-- 禁止 japiFn 取出再调：TSTL 会编成 f(nil, ...) 导致参数错位。
-- `sync=false` 的全局鼠标注册与滚轮一致，须经 `runFalseLocalRegistration`（见 `05．滚轮函数.ts`）。
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.BJ函数.12．数学函数")
local RMaxBJ = ____require_result_0.RMaxBJ
function ____exports.getMouseTerrainX(self)
    return japi.DzGetMouseTerrainX()
end
function ____exports.getMouseTerrainY(self)
    return japi.DzGetMouseTerrainY()
end
function ____exports.getMouseTerrainZ(self)
    return japi.DzGetMouseTerrainZ()
end
function ____exports.isMouseOverUI(self)
    return not not japi.DzIsMouseOverUI()
end
function ____exports.getMouseX(self)
    return japi.DzGetMouseX()
end
function ____exports.getMouseY(self)
    return japi.DzGetMouseY()
end
function ____exports.getMouseXRelative(self)
    return japi.DzGetMouseXRelative()
end
function ____exports.getMouseYRelative(self)
    return japi.DzGetMouseYRelative()
end
function ____exports.setMousePos(self, x, y)
    japi.DzSetMousePos(x, y)
end
--- 纵向 UI 归一化行程（如 LIST_VIEW_H - thumb）→ 与 Dz 纵向 0..0.6 对应的像素行程（任务分页滑块拖拽等）
function ____exports.getScrollbarTrackThumbTravelPx(self, travelNorm)
    local ch = getClientHeight(nil)
    local clientH = ch > 0 and ch or (getWindowHeight(nil) or 600)
    return RMaxBJ(1, clientH * travelNorm / 0.6)
end
--- 全局鼠标键 ByCode 注册；与 `registerMouseWheel` 同一套 sync / 本地玩家契约。
-- 
-- @param sync `true` 直接注册；`false` 必须经 `runFalseLocalRegistration`（禁止业务裸调 `DzTriggerRegisterMouseEventByCode`）
function ____exports.registerMouseButtonEventByCode(self, trig, btn, status, sync, action, playerId)
    if not trig then
        return
    end
    if sync then
        japi.DzTriggerRegisterMouseEventByCode(
            trig,
            btn,
            status,
            true,
            action
        )
    else
        runFalseLocalRegistration(
            nil,
            function()
                japi.DzTriggerRegisterMouseEventByCode(
                    trig,
                    btn,
                    status,
                    false,
                    action
                )
            end,
            playerId
        )
    end
end
--- 全局鼠标移动 ByCode；契约同 `registerMouseWheel` / `registerMouseButtonEventByCode`。
function ____exports.registerMouseMoveEventByCode(self, trig, sync, action, playerId)
    if not trig then
        return
    end
    if sync then
        japi.DzTriggerRegisterMouseMoveEventByCode(trig, true, action)
    else
        runFalseLocalRegistration(
            nil,
            function()
                japi.DzTriggerRegisterMouseMoveEventByCode(trig, false, action)
            end,
            playerId
        )
    end
end
return ____exports
