--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.06．经济系统.01．杀敌金币平分.00．常量定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____01_FF0E_6838_5FC3_529F_80FD = require("系统.06．经济系统.01．杀敌金币平分.01．核心功能")
    ____exports.initGoldShareSystem = ____01_FF0E_6838_5FC3_529F_80FD.initGoldShareSystem
    ____exports.registerGoldGainCallback = ____01_FF0E_6838_5FC3_529F_80FD.registerGoldGainCallback
end
return ____exports
