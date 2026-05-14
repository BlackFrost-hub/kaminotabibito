--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.08．扩散伤害.index")
local _____6269_6563_4F24_5BB3 = ____index["扩散伤害"]
--- 扩散伤害测试
-- 
-- 输入"1002"后，gg_unit_Hamg_0002 对 gg_unit_hfoo_0021 造成扩散伤害。
-- 这是临时测试文件，后续不用时可直接移除。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local _____6A21_5757_540D = "扩散伤害测试"
local _____6D4B_8BD5_547D_4EE4 = "1002"
local function ____on_804A_59291002_6D4B_8BD5()
    local _____6765_6E90_5355_4F4D = g.gg_unit_Hamg_0002
    local _____4E3B_76EE_6807 = g.gg_unit_hfoo_0021
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    if _____4E3B_76EE_6807 == nil or _____4E3B_76EE_6807 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_hfoo_0021")
        return
    end
    _____6269_6563_4F24_5BB3({
        ["来源单位"] = _____6765_6E90_5355_4F4D,
        ["主目标"] = _____4E3B_76EE_6807,
        ["伤害值"] = 60,
        ["扩散半径"] = 300,
        ["扩散百分比"] = 0.5
    })
    debugLogForce(_____6A21_5757_540D, "已执行扩散伤害，主目标全额500，半径300内敌方扩散250")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291002_6D4B_8BD5)
return ____exports
