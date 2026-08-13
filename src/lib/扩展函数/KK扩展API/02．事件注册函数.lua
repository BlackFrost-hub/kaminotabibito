--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- KK扩展API - 事件注册函数
-- 
-- 这些是对底层 DzAPI 的封装，简化事件注册流程
local japi = require("jass.japi")
--- 注册鼠标事件触发器
-- 
-- @param trg 触发器
-- @param status 状态（0=按下，1=释放，2=点击）
-- @param btn 鼠标按钮
function ____exports.DzTriggerRegisterMouseEventTrg(trg, status, btn)
    if trg == nil then
        return
    end
    japi:DzTriggerRegisterMouseEvent(
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
function ____exports.DzTriggerRegisterKeyEventTrg(trg, status, btn)
    if trg == nil then
        return
    end
    japi:DzTriggerRegisterKeyEvent(
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
function ____exports.DzTriggerRegisterMouseMoveEventTrg(trg)
    if trg == nil then
        return
    end
    japi:DzTriggerRegisterMouseMoveEvent(trg, true, nil)
end
--- 注册鼠标滚轮事件触发器
-- 
-- @param trg 触发器
function ____exports.DzTriggerRegisterMouseWheelEventTrg(trg)
    if trg == nil then
        return
    end
    japi:DzTriggerRegisterMouseWheelEvent(trg, true, nil)
end
--- 注册窗口大小改变事件触发器
-- 
-- @param trg 触发器
function ____exports.DzTriggerRegisterWindowResizeEventTrg(trg)
    if trg == nil then
        return
    end
    japi:DzTriggerRegisterWindowResizeEvent(trg, true, nil)
end
--- 浮点数转整数（类型转换）
function ____exports.DzF2I(i)
    return i
end
--- 整数转浮点数（类型转换）
function ____exports.DzI2F(i)
    return i
end
--- 按键码转整数（类型转换）
function ____exports.DzK2I(i)
    return i
end
--- 整数转按键码（类型转换）
function ____exports.DzI2K(i)
    return i
end
--- 注册商城物品同步数据事件
-- 
-- @param trig 触发器
function ____exports.DzTriggerRegisterMallItemSyncData(trig)
    japi:DzTriggerRegisterSyncData(trig, "DZMIA", true)
end
--- 获取触发商城物品的玩家
function ____exports.DzGetTriggerMallItemPlayer()
    return japi:DzGetTriggerSyncPlayer()
end
--- 获取触发的商城物品
function ____exports.DzGetTriggerMallItem()
    return japi:DzGetTriggerSyncData() or ""
end
--- 发送同步数据
-- 
-- @param prefix 同步前缀
-- @param data 同步内容
function ____exports.DzSyncData(prefix, data)
    japi:DzSyncData(prefix, data)
end
--- 立即发送同步数据
-- 
-- @param prefix 同步前缀
-- @param data 同步内容
function ____exports.DzSyncDataImmediately(prefix, data)
    japi:DzSyncDataImmediately(prefix, data)
end
--- 发送缓冲同步数据
-- 
-- @param prefix 同步前缀
-- @param data 同步内容
-- @param dataLen 数据长度
function ____exports.DzSyncBuffer(prefix, data, dataLen)
    japi:DzSyncBuffer(prefix, data, dataLen)
end
local DIALOG_ENTRY_SYNC_PREFIX = "DZDLG"
--- 注册 NPC 对话入口同步数据事件
-- 
-- @param trig 触发器
function ____exports.DzTriggerRegisterDialogEntrySyncData(trig)
    japi:DzTriggerRegisterSyncData(trig, DIALOG_ENTRY_SYNC_PREFIX, true)
end
--- 通用同步数据事件注册
-- 
-- @param trig 触发器
-- @param prefix 同步前缀
-- @param server 是否服务端同步
function ____exports.DzTriggerRegisterSyncDataTrg(trig, prefix, server)
    if trig == nil or prefix == nil or prefix == "" then
        return
    end
    japi:DzTriggerRegisterSyncData(trig, prefix, server)
end
--- 获取触发同步的玩家
function ____exports.DzGetTriggerSyncPlayer()
    return japi:DzGetTriggerSyncPlayer()
end
--- 获取触发同步的数据
function ____exports.DzGetTriggerSyncData()
    return japi:DzGetTriggerSyncData() or ""
end
--- 发送 NPC 对话入口同步数据
-- 
-- @param data 同步数据
function ____exports.DzSyncDialogEntryData(data)
    japi:DzSyncData(DIALOG_ENTRY_SYNC_PREFIX, data)
end
--- 获取触发 NPC 对话入口同步的玩家
function ____exports.DzGetTriggerDialogEntryPlayer()
    return japi:DzGetTriggerSyncPlayer()
end
--- 获取触发的 NPC 对话入口同步数据
function ____exports.DzGetTriggerDialogEntryData()
    return japi:DzGetTriggerSyncData() or ""
end
return ____exports
