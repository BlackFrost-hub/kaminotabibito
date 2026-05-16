--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 伤害系统 - 初始化入口
-- 
-- main 只需要 init，不在这里做 export * 聚合，避免把 DOT / 治疗 / 重伤 / 测试
-- 在加载期卷成一条导出链，触发 critical dependency。
local _____4F24_5BB3_7CFB_7EDF_5DF2_521D_59CB_5316 = false
function ____exports.init()
    if _____4F24_5BB3_7CFB_7EDF_5DF2_521D_59CB_5316 then
        return
    end
    _____4F24_5BB3_7CFB_7EDF_5DF2_521D_59CB_5316 = true
    require("系统.04．伤害系统.01．伤害事件")
    require("系统.04．伤害系统.02．dot伤害")
    require("系统.04．伤害系统.01．DOT定义.index")
    require("系统.04．伤害系统.03．伤害测试")
    require("系统.04．伤害系统.00．伤害计算.05．事件注册")
    local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.index")
    local initHealSystem = ____require_result_0.init
    local ____require_result_1 = require("系统.04．伤害系统.03．重伤系统.index")
    local initWoundSystem = ____require_result_1.init
    if type(initHealSystem) == "function" then
        initHealSystem()
    end
    if type(initWoundSystem) == "function" then
        initWoundSystem()
    end
end
return ____exports
