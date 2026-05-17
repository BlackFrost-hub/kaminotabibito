--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 吟唱条系统测试
-- 
-- 输入 131：显示默认紫色吟唱条
-- 输入 132：显示指定颜色ID的吟唱条
-- 输入 133：显示自定义提示文本
-- 输入 134：测试连续两次启动覆盖
-- 输入 135：测试到时自动关闭
-- 输入 136：测试手动关闭
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_541F_5531_6761 = ____require_result_1["显示吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_1["关闭吟唱条"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_3.debugLogForce
local _____6A21_5757_540D = "吟唱条测试"
local _____9ED8_8BA4_6D4B_8BD5_547D_4EE4 = "131"
local _____6307_5B9A_989C_8272_547D_4EE4 = "132"
local _____81EA_5B9A_4E49_6587_672C_547D_4EE4 = "133"
local _____8FDE_7EED_8986_76D6_547D_4EE4 = "134"
local _____5230_65F6_5173_95ED_547D_4EE4 = "135"
local _____624B_52A8_5173_95ED_547D_4EE4 = "136"
local _____6D4B_8BD5_542F_52A8_65F6_95F4 = 0
local function _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    local ____g_gg_unit_Hamg_0002_4 = g.gg_unit_Hamg_0002
    if ____g_gg_unit_Hamg_0002_4 == nil then
        ____g_gg_unit_Hamg_0002_4 = _G.bj_lastCreatedUnit
    end
    return ____g_gg_unit_Hamg_0002_4
end
local function _____6D4B_8BD5_663E_793A_9ED8_8BA4_541F_5531_6761()
    _____663E_793A_541F_5531_6761({["总时长"] = 5})
    _____6D4B_8BD5_542F_52A8_65F6_95F4 = os.time()
    debugLogForce(_____6A21_5757_540D, "显示默认吟唱条", "总时长=5秒")
end
local function _____6D4B_8BD5_6307_5B9A_989C_8272()
    _____663E_793A_541F_5531_6761({["总时长"] = 4, ["颜色ID"] = 1})
    _____6D4B_8BD5_542F_52A8_65F6_95F4 = os.time()
    debugLogForce(_____6A21_5757_540D, "显示颜色1吟唱条", "总时长=4秒", "颜色ID=1")
end
local function _____6D4B_8BD5_81EA_5B9A_4E49_63D0_793A_6587_672C()
    _____663E_793A_541F_5531_6761({["总时长"] = 3, ["颜色ID"] = 3, ["提示文本"] = "自定义提示：准备施法！"})
    _____6D4B_8BD5_542F_52A8_65F6_95F4 = os.time()
    debugLogForce(_____6A21_5757_540D, "显示自定义提示吟唱条", "总时长=3秒", "颜色ID=3")
end
local function _____6D4B_8BD5_8FDE_7EED_8986_76D6()
    _____663E_793A_541F_5531_6761({["总时长"] = 10, ["颜色ID"] = 5})
    _____6D4B_8BD5_542F_52A8_65F6_95F4 = os.time()
    addDelayedCallback(
        1500,
        function()
            _____663E_793A_541F_5531_6761({["总时长"] = 2, ["颜色ID"] = 7, ["提示文本"] = "覆盖后的吟唱条"})
            debugLogForce(_____6A21_5757_540D, "覆盖启动", "新总时长=2秒", "新颜色ID=7")
        end
    )
end
local function _____6D4B_8BD5_5230_65F6_81EA_52A8_5173_95ED()
    _____663E_793A_541F_5531_6761({["总时长"] = 2, ["颜色ID"] = 4, ["提示文本"] = "2秒后自动关闭"})
    _____6D4B_8BD5_542F_52A8_65F6_95F4 = os.time()
    debugLogForce(_____6A21_5757_540D, "显示吟唱条", "等待2秒后自动关闭")
end
local function _____6D4B_8BD5_624B_52A8_5173_95ED()
    _____663E_793A_541F_5531_6761({["总时长"] = 10, ["颜色ID"] = 2, ["提示文本"] = "手动关闭测试"})
    _____6D4B_8BD5_542F_52A8_65F6_95F4 = os.time()
    addDelayedCallback(
        1500,
        function()
            _____5173_95ED_541F_5531_6761()
            debugLogForce(_____6A21_5757_540D, "手动关闭吟唱条")
        end
    )
end
local function ____on_804A_5929_547D_4EE4_56DE_8C03(player, command)
    if command == _____9ED8_8BA4_6D4B_8BD5_547D_4EE4 then
        _____6D4B_8BD5_663E_793A_9ED8_8BA4_541F_5531_6761()
    elseif command == _____6307_5B9A_989C_8272_547D_4EE4 then
        _____6D4B_8BD5_6307_5B9A_989C_8272()
    elseif command == _____81EA_5B9A_4E49_6587_672C_547D_4EE4 then
        _____6D4B_8BD5_81EA_5B9A_4E49_63D0_793A_6587_672C()
    elseif command == _____8FDE_7EED_8986_76D6_547D_4EE4 then
        _____6D4B_8BD5_8FDE_7EED_8986_76D6()
    elseif command == _____5230_65F6_5173_95ED_547D_4EE4 then
        _____6D4B_8BD5_5230_65F6_81EA_52A8_5173_95ED()
    elseif command == _____624B_52A8_5173_95ED_547D_4EE4 then
        _____6D4B_8BD5_624B_52A8_5173_95ED()
    else
        debugLogForce(_____6A21_5757_540D, "未知命令", command)
    end
end
____exports["初始化吟唱条测试"] = function()
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____9ED8_8BA4_6D4B_8BD5_547D_4EE4, ____on_804A_5929_547D_4EE4_56DE_8C03)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6307_5B9A_989C_8272_547D_4EE4, ____on_804A_5929_547D_4EE4_56DE_8C03)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____81EA_5B9A_4E49_6587_672C_547D_4EE4, ____on_804A_5929_547D_4EE4_56DE_8C03)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____8FDE_7EED_8986_76D6_547D_4EE4, ____on_804A_5929_547D_4EE4_56DE_8C03)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____5230_65F6_5173_95ED_547D_4EE4, ____on_804A_5929_547D_4EE4_56DE_8C03)
    _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____624B_52A8_5173_95ED_547D_4EE4, ____on_804A_5929_547D_4EE4_56DE_8C03)
    debugLogForce(_____6A21_5757_540D, "初始化完成", "输入 131-136 测试")
end
____exports["初始化吟唱条测试"]()
return ____exports
