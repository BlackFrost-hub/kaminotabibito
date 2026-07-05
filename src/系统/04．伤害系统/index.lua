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
    require("系统.04．伤害系统.07．持续伤害系统")
    require("系统.04．伤害系统.02．dot伤害")
    require("系统.04．伤害系统.01．DOT定义.index")
    local _____6A21_578B_4F24_5BB3_6570_5B57 = require("系统.09．表现系统.09．伤害数字模型.index")
    local ____Boss_6218_4F24_5BB3_7EDF_8BA1 = require("系统.04．伤害系统.00．伤害计算.07．Boss战伤害统计")
    if type(_____6A21_578B_4F24_5BB3_6570_5B57.initDamageNumberModelDisplay) == "function" then
        _____6A21_578B_4F24_5BB3_6570_5B57.initDamageNumberModelDisplay()
    end
    if type(____Boss_6218_4F24_5BB3_7EDF_8BA1.initBossBattleDamageStats) == "function" then
        ____Boss_6218_4F24_5BB3_7EDF_8BA1.initBossBattleDamageStats()
    end
    require("系统.04．伤害系统.00．伤害计算.05．事件注册")
    require("系统.04．伤害系统.04．命中系统.index")
    require("系统.04．伤害系统.05．闪避系统.index")
    require("系统.04．伤害系统.06．暴击系统.index")
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
