--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 测试系统统一入口
-- 
-- 通过开关控制是否加载各个测试模块。
local ENABLE_STES_EVENT_TEST = false
local ENABLE_YDLOCAL_TEST = false
local ENABLE_TEST_EVENT = false
local ENABLE_GOLD_BURST_TEST = true
local ENABLE_BROADCAST_HINT_TEST = true
local ENABLE_BOSS_REWARD_SELECTION_TEST = true
local ENABLE_THRANDUIL_BOSS_SKILL_TEST = true
local function loadTests(self)
    if ENABLE_STES_EVENT_TEST then
        require("系统.12．测试系统.STES事件测试")
    end
    if ENABLE_YDLOCAL_TEST then
        require("系统.12．测试系统.YDLocal返回值测试")
    end
    if ENABLE_TEST_EVENT then
        require("系统.12．测试系统.03．伤害事件测试")
    end
    if ENABLE_GOLD_BURST_TEST then
        require("系统.12．测试系统.01．金币爆发测试")
    end
    if ENABLE_BROADCAST_HINT_TEST then
        require("系统.12．测试系统.04．广播提示消息测试")
    end
    if ENABLE_BOSS_REWARD_SELECTION_TEST then
        require("系统.12．测试系统.05．首领奖励选择测试")
    end
    if ENABLE_THRANDUIL_BOSS_SKILL_TEST then
        require("系统.12．测试系统.06．瑟兰迪尔Boss技能测试")
    end
end
loadTests(nil)
return ____exports
