--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04_FF0E_7FFB_9875_52A8_753B = require("系统.09．表现系统.07．游戏说明手册.04．翻页动画")
local _____521D_59CB_5316_7FFB_9875_52A8_753B = ____04_FF0E_7FFB_9875_52A8_753B["初始化翻页动画"]
local ____05_FF0E_4EA4_4E92_63A7_5236 = require("系统.09．表现系统.07．游戏说明手册.05．交互控制")
local _____521D_59CB_5316_624B_518C_4EA4_4E92 = ____05_FF0E_4EA4_4E92_63A7_5236["初始化手册交互"]
local _____6253_5F00_6E38_620F_8BF4_660E_624B_518C = ____05_FF0E_4EA4_4E92_63A7_5236["打开游戏说明手册"]
local _____5173_95ED_6E38_620F_8BF4_660E_624B_518C = ____05_FF0E_4EA4_4E92_63A7_5236["关闭游戏说明手册"]
local _____5207_6362_6E38_620F_8BF4_660E_624B_518C = ____05_FF0E_4EA4_4E92_63A7_5236["切换游戏说明手册"]
local ____03_FF0E_624B_518CUI_521B_5EFA = require("系统.09．表现系统.07．游戏说明手册.03．手册UI创建")
local _____521B_5EFA_6E38_620F_8BF4_660E_624B_518CUI = ____03_FF0E_624B_518CUI_521B_5EFA["创建游戏说明手册UI"]
local _____8BBE_7F6E_624B_518C_5E27_663E_793A = ____03_FF0E_624B_518CUI_521B_5EFA["设置手册帧显示"]
local _____5DF2_521D_59CB_5316 = false
function ____exports.init()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    local ui = _____521B_5EFA_6E38_620F_8BF4_660E_624B_518CUI()
    _____521D_59CB_5316_7FFB_9875_52A8_753B(ui)
    _____521D_59CB_5316_624B_518C_4EA4_4E92(ui)
    _____8BBE_7F6E_624B_518C_5E27_663E_793A(ui, false)
    _____6253_5F00_6E38_620F_8BF4_660E_624B_518C()
end
____exports["打开游戏说明手册"] = _____6253_5F00_6E38_620F_8BF4_660E_624B_518C
____exports["关闭游戏说明手册"] = _____5173_95ED_6E38_620F_8BF4_660E_624B_518C
____exports["切换游戏说明手册"] = _____5207_6362_6E38_620F_8BF4_660E_624B_518C
return ____exports
