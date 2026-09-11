--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_4E3B_7EBF_5267_60C5_5165_53E3_521D_59CB_5316 = require("系统.11．剧情系统.01．主线任务.01．主线剧情入口.02．主线剧情入口初始化")
local _____521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3 = ____02_FF0E_4E3B_7EBF_5267_60C5_5165_53E3_521D_59CB_5316["初始化主线剧情入口"]
local ____03_FF0E_4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6_521D_59CB_5316 = require("系统.11．剧情系统.01．主线任务.01．主线剧情入口.03．主线剧情物品事件初始化")
local _____521D_59CB_5316_4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6 = ____03_FF0E_4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6_521D_59CB_5316["初始化主线剧情物品事件"]
local ____04_FF0E_4E3B_7EBF_5267_60C5_7279_6B8A_4E8B_4EF6_521D_59CB_5316 = require("系统.11．剧情系统.01．主线任务.01．主线剧情入口.04．主线剧情特殊事件初始化")
local _____521D_59CB_5316_4E3B_7EBF_5267_60C5_7279_6B8A_4E8B_4EF6 = ____04_FF0E_4E3B_7EBF_5267_60C5_7279_6B8A_4E8B_4EF6_521D_59CB_5316["初始化主线剧情特殊事件"]
local ____02_FF0E_5267_60C5_6B65_9AA4_64AD_653E_5668 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
local _____521D_59CB_5316_5267_60C5_6B65_9AA4_64AD_653E_5668 = ____02_FF0E_5267_60C5_6B65_9AA4_64AD_653E_5668["初始化剧情步骤播放器"]
local ____03_FF0E_4E3B_7EBF_5F15_5BFCUI = require("系统.11．剧情系统.01．主线任务.03．主线引导UI.index")
local _____521D_59CB_5316_4E3B_7EBF_5F15_5BFCUI = ____03_FF0E_4E3B_7EBF_5F15_5BFCUI["初始化主线引导UI"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local MAINLINE_UI_INIT_LOG_MODULE = "主线任务/UI初始化"
local MAINLINE_UI_INIT_DELAY_MS = 8000
local function _____5EF6_8FDF_521D_59CB_5316_4E3B_7EBF_5F15_5BFCUI()
    debugLogForce(MAINLINE_UI_INIT_LOG_MODULE, "开始延迟初始化", "delayMs=", MAINLINE_UI_INIT_DELAY_MS)
    _____521D_59CB_5316_4E3B_7EBF_5F15_5BFCUI()
    debugLogForce(MAINLINE_UI_INIT_LOG_MODULE, "延迟初始化完成")
end
function ____exports.init()
    _____521D_59CB_5316_5267_60C5_6B65_9AA4_64AD_653E_5668()
    _____521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3()
    _____521D_59CB_5316_4E3B_7EBF_5267_60C5_7269_54C1_4E8B_4EF6()
    _____521D_59CB_5316_4E3B_7EBF_5267_60C5_7279_6B8A_4E8B_4EF6()
    debugLogForce(MAINLINE_UI_INIT_LOG_MODULE, "主线引导 UI 已禁用")
end
return ____exports
