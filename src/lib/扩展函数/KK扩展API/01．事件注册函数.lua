--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local japi = require("jass.japi")
--- 注册鼠标事件触发器
-- 
-- @param trg 触发器
-- @param status 状态（0=按下，1=释放，2=点击）
-- @param btn 鼠标按钮
function ____exports.DzTriggerRegisterMouseEventTrg(self, trg, status, btn)
    if trg == nil then
        return
    end
    if type(japi.DzTriggerRegisterMouseEvent) ~= "function" then
        return
    end
    japi.DzTriggerRegisterMouseEvent(
        trg,
        btn,
        status,
        true,
        nil
    )
end
--- 注册键盘事件触发器
-- 
-- @param trg 触发器
-- @param status 状态（0=按下，1=释放）
-- @param btn 键盘按键（键码或字符）
function ____exports.DzTriggerRegisterKeyEventTrg(self, trg, status, btn)
    if trg == nil then
        return
    end
    if type(japi.DzTriggerRegisterKeyEvent) ~= "function" then
        return
    end
    japi.DzTriggerRegisterKeyEvent(
        trg,
        btn,
        status,
        true,
        nil
    )
end
--- 注册鼠标移动事件触发器
-- 
-- @param trg 触发器
function ____exports.DzTriggerRegisterMouseMoveEventTrg(self, trg)
    if trg == nil then
        return
    end
    if type(japi.DzTriggerRegisterMouseMoveEvent) ~= "function" then
        return
    end
    japi.DzTriggerRegisterMouseMoveEvent(trg, true, nil)
end
--- 注册鼠标滚轮事件触发器
-- 
-- @param trg 触发器
function ____exports.DzTriggerRegisterMouseWheelEventTrg(self, trg)
    if trg == nil then
        return
    end
    if type(japi.DzTriggerRegisterMouseWheelEvent) ~= "function" then
        return
    end
    japi.DzTriggerRegisterMouseWheelEvent(trg, true, nil)
end
--- 注册窗口大小改变事件触发器
-- 
-- @param trg 触发器
function ____exports.DzTriggerRegisterWindowResizeEventTrg(self, trg)
    if trg == nil then
        return
    end
    if type(japi.DzTriggerRegisterWindowResizeEvent) ~= "function" then
        return
    end
    japi.DzTriggerRegisterWindowResizeEvent(trg, true, nil)
end
--- 浮点数转整数（类型转换）
function ____exports.DzF2I(self, i)
    return i
end
--- 整数转浮点数（类型转换）
function ____exports.DzI2F(self, i)
    return i
end
--- 按键码转整数（类型转换）
function ____exports.DzK2I(self, i)
    return i
end
--- 整数转按键码（类型转换）
function ____exports.DzI2K(self, i)
    return i
end
--- 注册商城物品同步数据事件
-- 
-- @param trig 触发器
function ____exports.DzTriggerRegisterMallItemSyncData(self, trig)
    if type(japi.DzTriggerRegisterSyncData) ~= "function" then
        return
    end
    japi.DzTriggerRegisterSyncData(trig, "DZMIA", true)
end
--- 获取触发商城物品的玩家
function ____exports.DzGetTriggerMallItemPlayer(self)
    if type(japi.DzGetTriggerSyncPlayer) ~= "function" then
        return nil
    end
    return japi.DzGetTriggerSyncPlayer()
end
--- 获取触发的商城物品
function ____exports.DzGetTriggerMallItem(self)
    if type(japi.DzGetTriggerSyncData) ~= "function" then
        return ""
    end
    return japi.DzGetTriggerSyncData() or ""
end
return ____exports
