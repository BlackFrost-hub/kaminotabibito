--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 禁锢与寄生虫测试
-- 
-- 输入 "1034"：对大法师施加3秒禁锢（BUFF纠缠根须+周期伤害）
-- 输入 "1035"：对大法师施加3秒寄生虫（BUFF寄生+周期伤害）
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.06．对外接口")
local _____65BD_52A0_7981_9522 = ____require_result_1["施加禁锢"]
local _____65BD_52A0_5BC4_751F = ____require_result_1["施加寄生"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local _____6A21_5757_540D = "禁锢寄生测试"
local _____7981_9522_547D_4EE4 = "1034"
local _____5BC4_751F_547D_4EE4 = "1035"
local function _____83B7_53D6_5927_6CD5_5E08()
    local ____g_gg_unit_Hamg_0002_3 = g.gg_unit_Hamg_0002
    if ____g_gg_unit_Hamg_0002_3 == nil then
        ____g_gg_unit_Hamg_0002_3 = _G.bj_lastCreatedUnit
    end
    return ____g_gg_unit_Hamg_0002_3
end
local function ____on_7981_9522_6D4B_8BD5()
    local _____6765_6E90_5355_4F4D = _____83B7_53D6_5927_6CD5_5E08()
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        debugLogForce(_____6A21_5757_540D, "测试失败：找不到大法师")
        return
    end
    _____65BD_52A0_7981_9522({
        ["来源单位"] = _____6765_6E90_5355_4F4D,
        ["目标单位"] = _____6765_6E90_5355_4F4D,
        ["伤害"] = 25,
        ["伤害间隔"] = 1,
        ["持续时间"] = 3
    })
    debugLogForce(_____6A21_5757_540D, "已对大法师施加3秒禁锢，伤害25/1s")
end
local function ____on_5BC4_751F_6D4B_8BD5()
    local _____6765_6E90_5355_4F4D = _____83B7_53D6_5927_6CD5_5E08()
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        debugLogForce(_____6A21_5757_540D, "测试失败：找不到大法师")
        return
    end
    _____65BD_52A0_5BC4_751F({
        ["来源单位"] = _____6765_6E90_5355_4F4D,
        ["目标单位"] = _____6765_6E90_5355_4F4D,
        ["伤害"] = 18,
        ["伤害间隔"] = 1,
        ["持续时间"] = 3
    })
    debugLogForce(_____6A21_5757_540D, "已对大法师施加3秒寄生虫，伤害18/1s")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____7981_9522_547D_4EE4, ____on_7981_9522_6D4B_8BD5)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____5BC4_751F_547D_4EE4, ____on_5BC4_751F_6D4B_8BD5)
debugLogForce(
    _____6A21_5757_540D,
    "已注册测试：输入",
    _____7981_9522_547D_4EE4,
    "禁锢",
    "",
    _____5BC4_751F_547D_4EE4,
    "寄生虫"
)
return ____exports
