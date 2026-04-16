--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.01．单位系统.03．单位死亡事件.01．核心功能")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local deathMod = require("系统.01．单位系统.03．单位死亡事件.01．核心功能")
if type(deathMod.init) == "function" then
    deathMod:init()
end
return ____exports
