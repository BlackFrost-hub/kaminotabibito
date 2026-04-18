--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.00．核心系统.00．玩家系统.00．常量")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.00．核心系统.00．玩家系统.01．玩家单位管理器")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local manager = require("系统.00．核心系统.00．玩家系统.01．玩家单位管理器")
____exports.initPlayerSystem = manager.initPlayerUnitManager
____exports.initPlayerUnitManager = manager.initPlayerUnitManager
if type(____exports.initPlayerSystem) == "function" then
    ____exports.initPlayerSystem(nil)
end
return ____exports
