--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local japi = require("jass.japi")
--- 发送一条低频同步数据。
function ____exports.DzSyncDataSafe(prefix, data)
    if prefix == nil or prefix == "" then
        return
    end
    japi.DzSyncData(prefix, data == nil and "" or data)
end
--- 为触发器注册同步数据事件。
function ____exports.DzTriggerRegisterSyncDataSafe(trig, prefix, server)
    if trig == nil or trig == 0 or prefix == nil or prefix == "" then
        return
    end
    japi.DzTriggerRegisterSyncData(trig, prefix, server)
end
--- 获取当前同步消息的发送玩家。
function ____exports.DzGetTriggerSyncPlayerSafe()
    return japi.DzGetTriggerSyncPlayer()
end
--- 获取当前同步消息的数据。
function ____exports.DzGetTriggerSyncDataSafe()
    return japi.DzGetTriggerSyncData() or ""
end
return ____exports
