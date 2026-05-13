--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.00．类型定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.01．升级配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.02．升级额外属性")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.03．英雄领悟技能")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.04．提升等级学习技能")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local heroLevelEventCenter = require("系统.00．核心系统.01．事件中心.06．英雄升级事件中心")
local ____require_result_0 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.02．升级额外属性")
local _____5E94_7528_5347_7EA7_989D_5916_5C5E_6027 = ____require_result_0["应用升级额外属性"]
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.03．英雄领悟技能")
local _____5E94_7528_82F1_96C4_9886_609F_6280_80FD = ____require_result_1["应用英雄领悟技能"]
local ____require_result_2 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.04．提升等级学习技能")
local _____5E94_7528_63D0_5347_7B49_7EA7_5B66_4E60_6280_80FD = ____require_result_2["应用提升等级学习技能"]
local _____5DF2_521D_59CB_5316 = false
local function ____on_82F1_96C4_5347_7EA7(whichHero)
    if not whichHero or whichHero == 0 then
        return
    end
    _____5E94_7528_5347_7EA7_989D_5916_5C5E_6027(whichHero)
    _____5E94_7528_82F1_96C4_9886_609F_6280_80FD(whichHero)
    _____5E94_7528_63D0_5347_7B49_7EA7_5B66_4E60_6280_80FD(whichHero)
end
function ____exports.init()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    heroLevelEventCenter.registerHeroLevelListener(____on_82F1_96C4_5347_7EA7)
end
____exports.init()
return ____exports
