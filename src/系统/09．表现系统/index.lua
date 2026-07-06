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
local _____8868_73B0_7CFB_7EDF_5DF2_521D_59CB_5316 = false
function ____exports.init()
    if _____8868_73B0_7CFB_7EDF_5DF2_521D_59CB_5316 then
        return
    end
    _____8868_73B0_7CFB_7EDF_5DF2_521D_59CB_5316 = true
    if type(_____539F_751FUI.initNativeUI) == "function" then
        _____539F_751FUI.initNativeUI()
    end
    ____UI_5C5E_6027_7CFB_7EDF.initUiAttributeSystem()
    _____82F1_96C4_8BED_97F3_7CFB_7EDF.init()
    require("系统.09．表现系统.02．对话框系统.index")
    require("系统.09．表现系统.08．吟唱条.index")
    require("系统.09．表现系统.11．背景框.index")
    _____5355_4F4D_5934_9876_8840_6761.init()
    _____7269_54C1_63D0_793A_6A21_62DF.init()
    _____5E7F_64AD_63D0_793A_6D88_606F_7CFB_7EDF["初始化广播提示消息系统"]()
    _____6E38_620F_8BF4_660E_624B_518C.init()
end
return ____exports
