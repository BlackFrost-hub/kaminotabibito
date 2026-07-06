--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.index")
local _____5F00_59CB_62A4_76FE = ____index["开始护盾"]
local _____79FB_9664_5355_4F4D_6807_7B7E_62A4_76FE = ____index["移除单位标签护盾"]
local _____67E5_8BE2_5355_4F4D_603B_62A4_76FE_503C = ____index["查询单位总护盾值"]
local _____67E5_8BE2_5355_4F4D_53EF_663E_793A_62A4_76FE_503C = ____index["查询单位可显示护盾值"]
local _____62A4_76FE_7C7B_578B = ____index["护盾类型"]
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local _____6A21_5757_540D = "护盾测试"
local _____6D4B_8BD5_547D_4EE4 = "1001"
local _____706B_62A4_76FE_6807_7B7E = "test_fire_shield"
local _____6697_62A4_76FE_6807_7B7E = "test_dark_shield"
local GetHandleId = jass.GetHandleId
local ____require_result_2 = require("系统.09．表现系统.13．单位头顶血条.index")
local _____6CE8_518C_5355_4F4D_5934_9876_8840_6761 = ____require_result_2["注册单位头顶血条"]
local function ____on_804A_59291001_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    debugLogForce(
        _____6A21_5757_540D,
        "1001开始：调用注册单位头顶血条",
        "unit",
        GetHandleId(_____5927_6CD5_5E08)
    )
    _____6CE8_518C_5355_4F4D_5934_9876_8840_6761(_____5927_6CD5_5E08)
    debugLogForce(
        _____6A21_5757_540D,
        "1001已调用注册单位头顶血条",
        "unit",
        GetHandleId(_____5927_6CD5_5E08)
    )
    _____79FB_9664_5355_4F4D_6807_7B7E_62A4_76FE(_____5927_6CD5_5E08, _____706B_62A4_76FE_6807_7B7E)
    _____79FB_9664_5355_4F4D_6807_7B7E_62A4_76FE(_____5927_6CD5_5E08, _____6697_62A4_76FE_6807_7B7E)
    _____5F00_59CB_62A4_76FE(_____5927_6CD5_5E08, {
        ["类型"] = _____62A4_76FE_7C7B_578B["火"],
        ["数值"] = 120,
        ["持续时间"] = 30,
        ["显示护盾条"] = true,
        ["标签"] = _____706B_62A4_76FE_6807_7B7E
    })
    _____5F00_59CB_62A4_76FE(_____5927_6CD5_5E08, {
        ["类型"] = _____62A4_76FE_7C7B_578B["暗"],
        ["数值"] = 160,
        ["持续时间"] = 30,
        ["显示护盾条"] = true,
        ["标签"] = _____6697_62A4_76FE_6807_7B7E
    })
    local _____603B_62A4_76FE = _____67E5_8BE2_5355_4F4D_603B_62A4_76FE_503C(_____5927_6CD5_5E08)
    local _____53EF_663E_793A_62A4_76FE = _____67E5_8BE2_5355_4F4D_53EF_663E_793A_62A4_76FE_503C(_____5927_6CD5_5E08)
    debugLogForce(
        _____6A21_5757_540D,
        "当前护盾值:",
        "总护盾",
        _____603B_62A4_76FE,
        "可显示护盾",
        _____53EF_663E_793A_62A4_76FE
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291001_6D4B_8BD5)
return ____exports
