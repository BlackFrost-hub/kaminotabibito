--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.03．技能系统.06．AI自动使用技能.00．常量定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.06．AI自动使用技能.01．AI配置类型")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.06．AI自动使用技能.02．AI配置工具")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.06．AI自动使用技能.03．BossAI配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.06．AI自动使用技能.04．杂鱼AI配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.06．AI自动使用技能.05．精英AI配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.06．AI自动使用技能.06．英雄AI配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.06．AI自动使用技能.07．异界BossAI配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.06．AI自动使用技能.08．全部AI配置索引")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
--- 保留给技能系统总入口调用的占位初始化函数。
-- 运行时自动施法系统正式接入后，再在这里挂真实初始化。
function ____exports.init()
    local _____53D7_51FB_53CD_5E94_65BD_6CD5_6A21_5757 = require("系统.03．技能系统.06．AI自动使用技能.01．受击反应施法.index")
    local ____Boss_6218_542F_52A8_6865_63A5_6A21_5757 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.index")
    local ____opt_0 = _____53D7_51FB_53CD_5E94_65BD_6CD5_6A21_5757["init受击反应施法"]
    if ____opt_0 ~= nil then
        ____opt_0()
    end
    local ____opt_2 = ____Boss_6218_542F_52A8_6865_63A5_6A21_5757["注册Boss战启动Stes桥接"]
    if ____opt_2 ~= nil then
        ____opt_2()
    end
end
return ____exports
