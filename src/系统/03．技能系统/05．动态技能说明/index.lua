--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_6838_5FC3_529F_80FD = require("系统.03．技能系统.05．动态技能说明.01．核心功能")
local initDynamicSkillTipSystem = ____01_FF0E_6838_5FC3_529F_80FD.initDynamicSkillTipSystem
local ____03_FF0E_82F1_96C4_6280_80FD_9884_6CE8_518C = require("系统.03．技能系统.05．动态技能说明.03．英雄技能预注册")
local initHeroSkillPreregistration = ____03_FF0E_82F1_96C4_6280_80FD_9884_6CE8_518C.initHeroSkillPreregistration
do
    local ____export = require("系统.03．技能系统.05．动态技能说明.00．常量定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.05．动态技能说明.02．公式解析器")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.05．动态技能说明.01．核心功能")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.05．动态技能说明.03．英雄技能预注册")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
--- 初始化动态技能说明系统
function ____exports.init(self)
    initDynamicSkillTipSystem(nil)
    initHeroSkillPreregistration(nil)
end
return ____exports
