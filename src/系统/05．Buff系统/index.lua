--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.05．Buff系统.00．Buff系统")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.01．Buff表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.02．BuffUI")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．BuffJASS桥接")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local buffPoolCore = require("系统.05．Buff系统.00．Buff系统")
if type(buffPoolCore.initBuffSystem) == "function" then
    buffPoolCore:initBuffSystem()
end
require("系统.05．Buff系统.01．Buff表")
local buffUIMod = require("系统.05．Buff系统.02．BuffUI")
if type(buffUIMod.init) == "function" then
    buffUIMod:init()
end
require("系统.05．Buff系统.03．BuffJASS桥接")
--- 初始化Buff系统
function ____exports.init(self)
    local p = _G.print
    if type(p) == "function" then
        p(nil, "[Buff系统] 初始化完成")
    end
end
return ____exports
