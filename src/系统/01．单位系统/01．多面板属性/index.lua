--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_6838_5FC3_529F_80FD = require("系统.01．单位系统.01．多面板属性.01．核心功能")
local initMultiboardSystem = ____01_FF0E_6838_5FC3_529F_80FD.initMultiboardSystem
do
    local ____export = require("系统.01．单位系统.01．多面板属性.00．常量定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.01．单位系统.01．多面板属性.01．核心功能")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
--- 初始化多面板属性系统
function ____exports.init(self)
    initMultiboardSystem(nil)
end
return ____exports
