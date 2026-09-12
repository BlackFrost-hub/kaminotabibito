--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 表现系统 - main 初始化入口
-- 
-- main 只依赖 init。这里不做 export * 聚合，避免加载期把 UI 工具、
-- 对话框、仇恨面板、广播提示、手册等模块卷进同一条导出链。
local _____539F_751FUI = require("系统.09．表现系统.00．初始化UI")
local ____UI_5C5E_6027_7CFB_7EDF = require("系统.09．表现系统.03．UI属性系统.03．系统入口")
local _____5E7F_64AD_63D0_793A_6D88_606F_7CFB_7EDF = require("系统.09．表现系统.06．广播提示消息.index")
local _____6E38_620F_8BF4_660E_624B_518C = require("系统.09．表现系统.07．游戏说明手册.index")
local _____82F1_96C4_8BED_97F3_7CFB_7EDF = require("系统.09．表现系统.10．英雄语音.index")
local _____7269_54C1_63D0_793A_6A21_62DF = require("系统.09．表现系统.12．物品提示模拟.index")
local _____5355_4F4D_5934_9876_8840_6761 = require("系统.09．表现系统.13．单位头顶血条.index")
local _____955C_5934_9AD8_5EA6_63A7_5236 = require("系统.09．表现系统.14．镜头高度控制.index")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local _____8868_73B0_7CFB_7EDF_5DF2_521D_59CB_5316 = false
local UI_STARTUP_LOG_MODULE = "表现系统/UI错峰初始化"
local function _____521D_59CB_5316_539F_751FUI()
    debugLogForce(UI_STARTUP_LOG_MODULE, "启动原生UI", "delayMs=", 750)
    _____539F_751FUI.initNativeUI()
end
local function _____521D_59CB_5316_5355_4F4D_5934_9876_8840_6761()
    debugLogForce(UI_STARTUP_LOG_MODULE, "启动单位头顶血条", "delayMs=", 1250)
    _____5355_4F4D_5934_9876_8840_6761.init()
end
local function _____521D_59CB_5316_6E38_620F_8BF4_660E_624B_518C()
    debugLogForce(UI_STARTUP_LOG_MODULE, "启动游戏说明手册", "delayMs=", 2000)
    _____6E38_620F_8BF4_660E_624B_518C.init()
end
local function _____521D_59CB_5316_7269_54C1_63D0_793A_6A21_62DF()
    debugLogForce(UI_STARTUP_LOG_MODULE, "启动物品提示模拟", "delayMs=", 2250)
    _____7269_54C1_63D0_793A_6A21_62DF.init()
end
function ____exports.init()
    if _____8868_73B0_7CFB_7EDF_5DF2_521D_59CB_5316 then
        return
    end
    _____8868_73B0_7CFB_7EDF_5DF2_521D_59CB_5316 = true
    ____UI_5C5E_6027_7CFB_7EDF.initUiAttributeSystem()
    _____82F1_96C4_8BED_97F3_7CFB_7EDF.init()
    debugLogForce(UI_STARTUP_LOG_MODULE, "准备加载对话框系统")
    require("系统.09．表现系统.02．对话框系统.index")
    debugLogForce(UI_STARTUP_LOG_MODULE, "对话框系统加载完成")
    debugLogForce(UI_STARTUP_LOG_MODULE, "准备加载吟唱条系统")
    require("系统.09．表现系统.08．吟唱条.index")
    debugLogForce(UI_STARTUP_LOG_MODULE, "吟唱条系统加载完成")
    debugLogForce(UI_STARTUP_LOG_MODULE, "准备加载背景框系统")
    require("系统.09．表现系统.11．背景框.index")
    debugLogForce(UI_STARTUP_LOG_MODULE, "背景框系统加载完成")
    debugLogForce(UI_STARTUP_LOG_MODULE, "准备初始化镜头高度控制")
    _____955C_5934_9AD8_5EA6_63A7_5236.init()
    debugLogForce(UI_STARTUP_LOG_MODULE, "镜头高度控制初始化完成")
    debugLogForce(UI_STARTUP_LOG_MODULE, "准备初始化广播提示消息系统")
    _____5E7F_64AD_63D0_793A_6D88_606F_7CFB_7EDF["初始化广播提示消息系统"]()
    debugLogForce(UI_STARTUP_LOG_MODULE, "广播提示消息系统初始化完成")
    debugLogForce(UI_STARTUP_LOG_MODULE, "已安排UI错峰初始化")
    if type(_____539F_751FUI.initNativeUI) == "function" then
        debugLogForce(UI_STARTUP_LOG_MODULE, "准备注册原生UI延迟任务")
        addDelayedCallback(750, _____521D_59CB_5316_539F_751FUI)
        debugLogForce(UI_STARTUP_LOG_MODULE, "原生UI延迟任务注册完成")
    end
    debugLogForce(UI_STARTUP_LOG_MODULE, "准备注册血条延迟任务")
    addDelayedCallback(1250, _____521D_59CB_5316_5355_4F4D_5934_9876_8840_6761)
    debugLogForce(UI_STARTUP_LOG_MODULE, "血条延迟任务注册完成")
    debugLogForce(UI_STARTUP_LOG_MODULE, "准备注册手册延迟任务")
    addDelayedCallback(2000, _____521D_59CB_5316_6E38_620F_8BF4_660E_624B_518C)
    debugLogForce(UI_STARTUP_LOG_MODULE, "手册延迟任务注册完成")
    debugLogForce(UI_STARTUP_LOG_MODULE, "准备注册物品提示延迟任务")
    addDelayedCallback(2250, _____521D_59CB_5316_7269_54C1_63D0_793A_6A21_62DF)
    debugLogForce(UI_STARTUP_LOG_MODULE, "物品提示延迟任务注册完成")
end
return ____exports
