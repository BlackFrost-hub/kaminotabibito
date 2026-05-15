--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.index")
local _____5F00_59CB_8DF3_8DC3 = ____index["开始跳跃"]
--- Jump system test.
-- 
-- 输入 "1098"：让大法师朝向跳跃1000距离，3秒持续，300高度
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local GetUnitFacing = jass.GetUnitFacing
local _____6A21_5757_540D = "跳跃测试"
local _____6D4B_8BD5_547D_4EE4 = "1098"
local function ____on_804A_5929_6D4B_8BD5()
    local testUnit = g.gg_unit_Hamg_0002
    if testUnit == nil or testUnit == 0 then
        debugLogForce(nil, _____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local angle = GetUnitFacing(testUnit)
    debugLogForce(
        nil,
        _____6A21_5757_540D,
        "开始跳跃",
        "角度=" .. tostring(angle)
    )
    _____5F00_59CB_8DF3_8DC3(testUnit, {
        ["角度"] = angle,
        ["距离"] = 1000,
        ["持续时间"] = 3,
        ["跳跃高度"] = 300,
        ["朝向跟随跳跃"] = false
    })
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_5929_6D4B_8BD5)
debugLogForce(
    nil,
    _____6A21_5757_540D,
    "已注册测试：输入",
    _____6D4B_8BD5_547D_4EE4,
    "让大法师跳跃1000距离"
)
return ____exports
