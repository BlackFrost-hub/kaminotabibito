--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_6838_5FC3_529F_80FD = require("系统.03．技能系统.06．AI自动使用技能.01．核心功能")
local initAISkillSystem = ____01_FF0E_6838_5FC3_529F_80FD.initAISkillSystem
local isSystemEnabled = ____01_FF0E_6838_5FC3_529F_80FD.isSystemEnabled
do
    local ____export = require("系统.03．技能系统.06．AI自动使用技能.00．常量定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.06．AI自动使用技能.01．核心功能")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
--- 初始化AI自动使用技能系统
function ____exports.init(self)
    initAISkillSystem(nil)
end
--- 检查系统是否启用
function ____exports.isEnabled(self)
    return isSystemEnabled(nil)
end
return ____exports
