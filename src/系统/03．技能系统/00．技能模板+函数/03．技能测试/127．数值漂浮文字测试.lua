--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 数值漂浮文字测试
-- 
-- 输入 1032：在大法师身上和附近坐标一次性显示多种数值漂浮文字。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("lib.扩展函数.封装函数.03．漂浮文字.05．数值漂浮文字")
local _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57 = ____require_result_1["显示单位数值漂浮文字"]
local _____663E_793A_5750_6807_6570_503C_6F02_6D6E_6587_5B57 = ____require_result_1["显示坐标数值漂浮文字"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_FireWithParams = ____require_result_2.STES_FireWithParams
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_3.debugLogForce
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____6A21_5757_540D = "数值漂浮文字测试"
local _____6D4B_8BD5_547D_4EE4 = "1032"
local function _____83B7_53D6_6D4B_8BD5_5927_6CD5_5E08()
    local ____g_gg_unit_Hamg_0002_4 = g.gg_unit_Hamg_0002
    if ____g_gg_unit_Hamg_0002_4 == nil then
        ____g_gg_unit_Hamg_0002_4 = _G.bj_lastCreatedUnit
    end
    return ____g_gg_unit_Hamg_0002_4
end
local function _____6267_884C_6570_503C_6F02_6D6E_6587_5B57_6D4B_8BD5()
    local unit = _____83B7_53D6_6D4B_8BD5_5927_6CD5_5E08()
    if unit == nil or unit == 0 then
        debugLogForce(_____6A21_5757_540D, "测试失败：找不到大法师 gg_unit_Hamg_0002")
        return
    end
    local x = GetUnitX(unit)
    local y = GetUnitY(unit)
    _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57(unit, 1234, {
        ["后缀"] = "金币",
        ["红"] = 255,
        ["绿"] = 215,
        ["蓝"] = 0,
        ["大小"] = 12
    })
    _____663E_793A_5750_6807_6570_503C_6F02_6D6E_6587_5B57(x + 90, y, -88, {["后缀"] = "伤害", ["红"] = 255, ["绿"] = 60, ["蓝"] = 60})
    _____663E_793A_5750_6807_6570_503C_6F02_6D6E_6587_5B57(x - 90, y, 12.345, {
        ["后缀"] = "s",
        ["小数位数"] = 2,
        ["红"] = 80,
        ["绿"] = 180,
        ["蓝"] = 255
    })
    _____663E_793A_5750_6807_6570_503C_6F02_6D6E_6587_5B57(x, y + 90, 66, {
        ["后缀"] = "无正号",
        ["显示正号"] = false,
        ["红"] = 180,
        ["绿"] = 255,
        ["蓝"] = 180
    })
    _____663E_793A_5750_6807_6570_503C_6F02_6D6E_6587_5B57(x, y - 90, 0, {
        ["后缀"] = "显示0",
        ["零值隐藏"] = false,
        ["红"] = 255,
        ["绿"] = 255,
        ["蓝"] = 255
    })
    _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57(unit, 0, {["后缀"] = "隐藏0", ["零值隐藏"] = true})
    STES_FireWithParams("数值显示", {
        {type = "unit", name = "单位", value = unit},
        {type = "real", name = "数值", value = 77},
        {type = "string", name = "后缀", value = "STES中文参数"},
        {type = "real", name = "红", value = 255},
        {type = "real", name = "绿", value = 180},
        {type = "real", name = "蓝", value = 40},
        {type = "real", name = "大小", value = 11},
        {type = "real", name = "小数位数", value = 0},
        {type = "boolean", name = "显示正号", value = true}
    })
    debugLogForce(_____6A21_5757_540D, "已执行：正数、负数、小数、无正号、零值显示/隐藏、中文 STES")
end
local function ____on_6570_503C_6F02_6D6E_6587_5B57_6D4B_8BD5_547D_4EE4()
    _____6267_884C_6570_503C_6F02_6D6E_6587_5B57_6D4B_8BD5()
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_6570_503C_6F02_6D6E_6587_5B57_6D4B_8BD5_547D_4EE4)
debugLogForce(_____6A21_5757_540D, ("已注册：" .. _____6D4B_8BD5_547D_4EE4) .. " 数值漂浮文字测试")
return ____exports
