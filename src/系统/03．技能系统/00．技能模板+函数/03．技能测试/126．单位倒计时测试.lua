--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 单位倒计时系统测试
-- 
-- 输入 1029：普通倒计时
-- 输入 1030：强化2倒计时
-- 输入 1031：暂停倒计时测试
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.17．单位倒计时.04．对外接口")
local _____542F_52A8_5355_4F4D_5012_8BA1_65F6 = ____require_result_1["启动单位倒计时"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____8BBE_7F6E_5355_4F4D_6682_505C_65F6_95F4 = ____require_result_3["设置单位暂停时间"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____6A21_5757_540D = "单位倒计时测试"
local _____666E_901A_5012_8BA1_65F6_547D_4EE4 = "1029"
local _____5F3A_5316_5012_8BA1_65F6_547D_4EE4 = "1030"
local _____6682_505C_5012_8BA1_65F6_547D_4EE4 = "1031"
local _____6682_505C_6D4B_8BD5_6765_6E90 = "单位倒计时测试:暂停推进"
local function _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    local ____g_gg_unit_Hamg_0002_4 = g.gg_unit_Hamg_0002
    if ____g_gg_unit_Hamg_0002_4 == nil then
        ____g_gg_unit_Hamg_0002_4 = _G.bj_lastCreatedUnit
    end
    return ____g_gg_unit_Hamg_0002_4
end
local function _____542F_52A8_666E_901A_5012_8BA1_65F6_6D4B_8BD5()
    local unit = _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    if unit == nil or unit == 0 then
        debugLogForce(_____6A21_5757_540D, "普通测试失败：找不到测试单位")
        return
    end
    local id = _____542F_52A8_5355_4F4D_5012_8BA1_65F6({
        ["单位"] = unit,
        ["持续时间"] = 3,
        X = GetUnitX(unit),
        Y = GetUnitY(unit),
        ["到期效果ID"] = 0
    })
    debugLogForce(
        _____6A21_5757_540D,
        "普通倒计时启动",
        "id=",
        id,
        "unit=",
        unit
    )
end
local function _____542F_52A8_5F3A_5316_5012_8BA1_65F6_6D4B_8BD5()
    local unit = _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    if unit == nil or unit == 0 then
        debugLogForce(_____6A21_5757_540D, "强化测试失败：找不到测试单位")
        return
    end
    local id = _____542F_52A8_5355_4F4D_5012_8BA1_65F6({
        ["单位"] = unit,
        ["持续时间"] = 3,
        X = GetUnitX(unit),
        Y = GetUnitY(unit),
        ["到期效果ID"] = 2,
        ["强化持续时间"] = 8,
        ["强化生命值"] = 300,
        ["强化模型"] = "",
        ["强化单位类型"] = "hfoo"
    })
    debugLogForce(
        _____6A21_5757_540D,
        "强化2倒计时启动",
        "id=",
        id,
        "unit=",
        unit
    )
end
local function _____542F_52A8_6682_505C_5012_8BA1_65F6_6D4B_8BD5()
    local unit = _____83B7_53D6_6D4B_8BD5_5355_4F4D()
    if unit == nil or unit == 0 then
        debugLogForce(_____6A21_5757_540D, "暂停测试失败：找不到测试单位")
        return
    end
    _____8BBE_7F6E_5355_4F4D_6682_505C_65F6_95F4(unit, _____6682_505C_6D4B_8BD5_6765_6E90, 2)
    local id = _____542F_52A8_5355_4F4D_5012_8BA1_65F6({
        ["单位"] = unit,
        ["持续时间"] = 2,
        X = GetUnitX(unit),
        Y = GetUnitY(unit),
        ["到期效果ID"] = 0
    })
    debugLogForce(_____6A21_5757_540D, "暂停倒计时启动：单位暂停2秒，倒计时应暂停推进", "id=", id)
end
local function ____on_666E_901A_5012_8BA1_65F6_804A_5929_547D_4EE4()
    _____542F_52A8_666E_901A_5012_8BA1_65F6_6D4B_8BD5()
end
local function ____on_5F3A_5316_5012_8BA1_65F6_804A_5929_547D_4EE4()
    _____542F_52A8_5F3A_5316_5012_8BA1_65F6_6D4B_8BD5()
end
local function ____on_6682_505C_5012_8BA1_65F6_804A_5929_547D_4EE4()
    _____542F_52A8_6682_505C_5012_8BA1_65F6_6D4B_8BD5()
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____666E_901A_5012_8BA1_65F6_547D_4EE4, ____on_666E_901A_5012_8BA1_65F6_804A_5929_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____5F3A_5316_5012_8BA1_65F6_547D_4EE4, ____on_5F3A_5316_5012_8BA1_65F6_804A_5929_547D_4EE4)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6682_505C_5012_8BA1_65F6_547D_4EE4, ____on_6682_505C_5012_8BA1_65F6_804A_5929_547D_4EE4)
debugLogForce(_____6A21_5757_540D, "已注册：1029普通倒计时，1030强化2倒计时，1031暂停倒计时")
return ____exports
