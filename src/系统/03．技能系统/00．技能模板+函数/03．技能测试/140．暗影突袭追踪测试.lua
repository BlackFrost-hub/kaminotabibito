--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 暗影突袭追踪测试
-- 
-- 输入 "1042"
-- - 直接调用 创建暗影突袭追踪
-- - source: gg_unit_Hamg_0002
-- - target: gg_unit_ogru_0019
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.01．暗影突袭")
local _____521B_5EFA_6697_5F71_7A81_88AD_8FFD_8E2A = ____require_result_2["创建暗影突袭追踪"]
local _____6A21_5757_540D = "暗影突袭追踪测试"
local _____6D4B_8BD5_547D_4EE4 = "1042"
local function _____6267_884C1042_6697_5F71_7A81_88AD_8FFD_8E2A_6D4B_8BD5()
    local source = g.gg_unit_Hamg_0002
    local target = g.gg_unit_ogru_0019
    if source == nil or source == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    if target == nil or target == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_ogru_0019")
        return
    end
    debugLogForce(
        _____6A21_5757_540D,
        "直接调用 创建暗影突袭追踪",
        "source:",
        source,
        "target:",
        target
    )
    _____521B_5EFA_6697_5F71_7A81_88AD_8FFD_8E2A(source, target, {["减益"] = {duration = 2, damagePerSecond = 500}})
end
local function ____on_804A_59291042()
    _____6267_884C1042_6697_5F71_7A81_88AD_8FFD_8E2A_6D4B_8BD5()
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291042)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "直接测试暗影突袭追踪封装")
return ____exports
