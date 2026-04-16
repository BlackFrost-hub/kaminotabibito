--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 是否启用移动速度突破测试
local ENABLE_MOVE_SPEED_TEST = true
--- 是否启用Dz函数测试
local ENABLE_DZ_FUNCTION_TEST = false
--- 是否启用STES事件测试
local ENABLE_STES_EVENT_TEST = false
--- 是否启用YDLocal返回值测试
local ENABLE_YDLOCAL_TEST = false
--- 是否启用任务测试
local ENABLE_QUEST_TEST = false
--- 是否启用模拟商店测试
local ENABLE_SHOP_TEST = false
--- 是否启用测试233注册
local ENABLE_TEST_233 = false
--- 是否启用测试事件
local ENABLE_TEST_EVENT = false
--- 是否启用测试事件2
local ENABLE_TEST_EVENT_2 = false
--- 加载测试模块
local function loadTests(self)
    if ENABLE_MOVE_SPEED_TEST then
        require("系统.12．测试系统.移动速度突破测试")
    end
    if ENABLE_DZ_FUNCTION_TEST then
        require("系统.12．测试系统.dz函数测试")
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
    if ENABLE_SHOP_TEST then
        require("系统.12．测试系统.模拟商店")
    end
    if ENABLE_TEST_233 then
        require("系统.12．测试系统.测试233注册")
    end
    if ENABLE_TEST_EVENT then
        require("系统.12．测试系统.测试事件")
    end
    if ENABLE_TEST_EVENT_2 then
        require("系统.12．测试系统.测试事件2")
    end
end
loadTests(nil)
return ____exports
