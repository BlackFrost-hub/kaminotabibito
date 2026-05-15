--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 测试系统统一入口
-- 
-- 通过开关控制是否加载各个测试模块。
local ENABLE_MOVE_SPEED_TEST = true
local ENABLE_STES_EVENT_TEST = false
local ENABLE_YDLOCAL_TEST = false
local ENABLE_QUEST_TEST = false
local ENABLE_TEST_233 = true
local ENABLE_TEST_EVENT = false
local ENABLE_GOLD_BURST_TEST = true
local ENABLE_DZ_CAN_PLACE_TEST = true
local function loadTests(self)
    if ENABLE_MOVE_SPEED_TEST then
        require("系统.12．测试系统.移动速度突破测试")
    end
    if ENABLE_STES_EVENT_TEST then
        require("系统.12．测试系统.STES事件测试")
    end
    if ENABLE_YDLOCAL_TEST then
        require("系统.12．测试系统.YDLocal返回值测试")
    end
    if ENABLE_QUEST_TEST then
        require("系统.12．测试系统.任务测试")
    end
    if ENABLE_TEST_233 then
        require("系统.12．测试系统.02．平台API测试")
    end
    if ENABLE_TEST_EVENT then
        require("系统.12．测试系统.03．伤害事件测试")
    end
    if ENABLE_GOLD_BURST_TEST then
        require("系统.12．测试系统.01．金币爆发测试")
    end
    if ENABLE_DZ_CAN_PLACE_TEST then
        require("系统.12．测试系统.Dz通行判定测试")
    end
end
loadTests(nil)
return ____exports
