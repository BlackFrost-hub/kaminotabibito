--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_0["注册聊天命令监听"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_79FB_901F_63D0_5347Buff = ____require_result_3["施加移速提升Buff"]
local _____6E05_9664_5355_4F4D_79FB_901F_63D0_5347Buff = ____require_result_3["清除单位移速提升Buff"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.03．移动速度")
local _____83B7_53D6_5355_4F4D_7A81_7834_79FB_901F = ____require_result_4["获取单位突破移速"]
local GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed
local GetUnitMoveSpeed = jass.GetUnitMoveSpeed
local _____6A21_5757_540D = "移速提升Buff测试"
local _____6D4B_8BD5_547D_4EE4 = "1044"
local _____6E05_9664_547D_4EE4 = "1045"
local _____6D4B_8BD5_6301_7EED_79D2 = 5
local _____6700_8FD1_6D4B_8BD5_5355_4F4D = nil
local _____6D4B_8BD5_524D_5F53_524D_79FB_901F = 0
local _____6D4B_8BD5_524D_7A81_7834_79FB_901F = 0
local function _____7EDD_5BF9_503C(value)
    return value < 0 and -value or value
end
local function _____8BB0_5F55_5355_4F4D_79FB_901F(_____6807_7B7E, _____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        debugLogForce(_____6A21_5757_540D, _____6807_7B7E, "单位无效")
        return
    end
    debugLogForce(
        _____6A21_5757_540D,
        _____6807_7B7E,
        "基础=",
        GetUnitDefaultMoveSpeed(_____5355_4F4D),
        "当前=",
        GetUnitMoveSpeed(_____5355_4F4D),
        "突破=",
        _____83B7_53D6_5355_4F4D_7A81_7834_79FB_901F(_____5355_4F4D)
    )
end
local function ____on_79FB_901F_63D0_5347Buff_5230_671F_68C0_67E5()
    local _____5355_4F4D = _____6700_8FD1_6D4B_8BD5_5355_4F4D
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local _____5F53_524D_79FB_901F = GetUnitMoveSpeed(_____5355_4F4D)
    local _____7A81_7834_79FB_901F = _____83B7_53D6_5355_4F4D_7A81_7834_79FB_901F(_____5355_4F4D)
    _____8BB0_5F55_5355_4F4D_79FB_901F("到期后", _____5355_4F4D)
    if _____7EDD_5BF9_503C(_____5F53_524D_79FB_901F - _____6D4B_8BD5_524D_5F53_524D_79FB_901F) <= 1 and _____7EDD_5BF9_503C(_____7A81_7834_79FB_901F - _____6D4B_8BD5_524D_7A81_7834_79FB_901F) <= 1 then
        debugLogForce(
            _____6A21_5757_540D,
            "[PASS] 移速已回落",
            "当前=",
            _____5F53_524D_79FB_901F,
            "突破=",
            _____7A81_7834_79FB_901F
        )
    else
        debugLogForce(
            _____6A21_5757_540D,
            "[CHECK] 移速未回到测试前值，可能有其他移速效果",
            "测试前当前=",
            _____6D4B_8BD5_524D_5F53_524D_79FB_901F,
            "测试前突破=",
            _____6D4B_8BD5_524D_7A81_7834_79FB_901F
        )
    end
end
local function ____on_804A_59291044_79FB_901F_63D0_5347_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到 gg_unit_Hamg_0002")
        return
    end
    _____6700_8FD1_6D4B_8BD5_5355_4F4D = _____5927_6CD5_5E08
    _____6D4B_8BD5_524D_5F53_524D_79FB_901F = GetUnitMoveSpeed(_____5927_6CD5_5E08)
    _____6D4B_8BD5_524D_7A81_7834_79FB_901F = _____83B7_53D6_5355_4F4D_7A81_7834_79FB_901F(_____5927_6CD5_5E08)
    _____8BB0_5F55_5355_4F4D_79FB_901F("施加前", _____5927_6CD5_5E08)
    local ok = _____65BD_52A0_79FB_901F_63D0_5347Buff(_____5927_6CD5_5E08, _____5927_6CD5_5E08, {["持续时间"] = _____6D4B_8BD5_6301_7EED_79D2, ["固定移速"] = 100, ["基础移速百分比"] = 0.5, ["当前移速百分比"] = 0.5})
    debugLogForce(
        _____6A21_5757_540D,
        "施加结果=",
        ok,
        "持续秒=",
        _____6D4B_8BD5_6301_7EED_79D2,
        "固定=100 基础%=0.5 当前%=0.5"
    )
    _____8BB0_5F55_5355_4F4D_79FB_901F("施加后", _____5927_6CD5_5E08)
    addDelayedCallback(_____6D4B_8BD5_6301_7EED_79D2 * 1000 + 500, ____on_79FB_901F_63D0_5347Buff_5230_671F_68C0_67E5)
end
local function ____on_804A_59291045_6E05_9664_79FB_901F_63D0_5347()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "未找到 gg_unit_Hamg_0002")
        return
    end
    local ok = _____6E05_9664_5355_4F4D_79FB_901F_63D0_5347Buff(_____5927_6CD5_5E08)
    debugLogForce(_____6A21_5757_540D, "手动清除结果=", ok)
    _____8BB0_5F55_5355_4F4D_79FB_901F("手动清除后", _____5927_6CD5_5E08)
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291044_79FB_901F_63D0_5347_6D4B_8BD5)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6E05_9664_547D_4EE4, ____on_804A_59291045_6E05_9664_79FB_901F_63D0_5347)
debugLogForce(
    _____6A21_5757_540D,
    "已注册测试：输入",
    _____6D4B_8BD5_547D_4EE4,
    "施加5秒移速提升，输入",
    _____6E05_9664_547D_4EE4,
    "手动清除"
)
return ____exports
