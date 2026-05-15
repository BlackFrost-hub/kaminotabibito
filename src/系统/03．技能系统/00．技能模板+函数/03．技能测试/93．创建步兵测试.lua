--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 召唤物系统 测试
-- 
-- 输入 "1093"：
-- - 测试 `创建召唤物`
-- - 测试 `快捷创建召唤物`
-- - 测试 `SUO_CreateUnit_Loc`
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.index")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_2["创建召唤物"]
local _____5FEB_6377_521B_5EFA_53EC_5524_7269 = ____require_result_2["快捷创建召唤物"]
local SUO_CreateUnit_Loc = ____require_result_2.SUO_CreateUnit_Loc
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local Location = jass.Location
local _____6A21_5757_540D = "召唤物测试"
local _____6D4B_8BD5_547D_4EE4 = "1093"
local function _____6253_5370_7ED3_679C(_____6807_7B7E, _____53EC_5524_7269)
    if _____53EC_5524_7269 ~= nil and _____53EC_5524_7269 ~= 0 then
        debugLogForce(_____6A21_5757_540D, "[PASS]", _____6807_7B7E, "创建成功")
        return
    end
    debugLogForce(_____6A21_5757_540D, "[FAIL]", _____6807_7B7E, "创建失败")
end
local function ____on_804A_5929_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local x = GetUnitX(_____5927_6CD5_5E08)
    local y = GetUnitY(_____5927_6CD5_5E08)
    local _____6240_5C5E_73A9_5BB6 = GetOwningPlayer(_____5927_6CD5_5E08)
    debugLogForce(_____6A21_5757_540D, "===== 开始测试 =====")
    local _____76F4_63A5_521B_5EFA = _____521B_5EFA_53EC_5524_7269({
        ["主人单位"] = _____5927_6CD5_5E08,
        ["单位类型"] = "hfoo",
        X = x + 200,
        Y = y,
        ["持续时间"] = 10,
        ["飞行高度"] = 50,
        ["生命值"] = 300,
        ["攻击力"] = 25,
        ["护甲"] = 5,
        ["缩放"] = 1.2
    })
    _____6253_5370_7ED3_679C("创建召唤物", _____76F4_63A5_521B_5EFA)
    local _____5FEB_6377_521B_5EFA = _____5FEB_6377_521B_5EFA_53EC_5524_7269(
        _____5927_6CD5_5E08,
        "hrif",
        x + 300,
        y,
        10,
        {["飞行高度"] = 50, ["攻击力"] = 40, ["攻击间隔"] = 1.5, ["缩放"] = 1.1}
    )
    _____6253_5370_7ED3_679C("快捷创建召唤物", _____5FEB_6377_521B_5EFA)
    local loc = Location(x + 400, y)
    local ____SUO_521B_5EFA = SUO_CreateUnit_Loc(
        _____6240_5C5E_73A9_5BB6,
        "hmpr",
        loc,
        50,
        270,
        255,
        255,
        255,
        255,
        10,
        true
    )
    _____6253_5370_7ED3_679C("SUO_CreateUnit_Loc", ____SUO_521B_5EFA)
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_5929_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "测试召唤物统一入口")
return ____exports
