--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.04．伤害系统.03．重伤系统.00．常量定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.03．重伤系统.01．核心功能")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
--- 初始化重伤系统
function ____exports.init(self)
    local ____require_result_0 = require("系统.04．伤害系统.03．重伤系统.01．核心功能")
    local initWoundSystem = ____require_result_0.initWoundSystem
    initWoundSystem(nil)
end
return ____exports
