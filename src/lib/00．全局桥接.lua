--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 全局桥接入口
-- - 统一把项目内常用函数挂到 globalThis
-- - 供配置表达式 / 旧JASS风格调用直接使用
-- - 各模块的桥接逻辑已分散到各自文件夹的 index.ts 中
local jass = require("jass.common")
local bjBridge = require("lib.扩展函数.BJ函数.index")
local ydweBridge = require("lib.扩展函数.YDWE函数.index")
local starBridge = require("lib.扩展函数.Star扩展函数.index")
local kkBridge = require("lib.扩展函数.KK扩展API.index")
local function bridgeFromJass(self, name)
    local g = _G
    if type(g[name]) == "function" then
        return
    end
    if jass and type(jass[name]) == "function" then
        g[name] = jass[name]
    end
end
bridgeFromJass(nil, "GetHandleId")
if type(bjBridge.registerBridge) == "function" then
    bjBridge:registerBridge()
end
if type(ydweBridge.registerBridge) == "function" then
    ydweBridge:registerBridge()
end
if type(starBridge.registerBridge) == "function" then
    starBridge:registerBridge()
end
if type(kkBridge.registerBridge) == "function" then
    kkBridge:registerBridge()
end
return ____exports
