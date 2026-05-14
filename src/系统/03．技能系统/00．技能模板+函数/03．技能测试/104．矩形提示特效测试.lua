--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____09_FF0E_63D0_793A_7279_6548 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效")
local _____521B_5EFA_77E9_5F62_63D0_793A_5708 = ____09_FF0E_63D0_793A_7279_6548["创建矩形提示圈"]
--- 矩形提示特效测试
-- 
-- 输入"1004"后，在 gg_unit_Hamg_0002 面前创建矩形提示特效。
-- 这是临时测试文件，后续不用时可直接移除。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local _____6A21_5757_540D = "矩形提示特效测试"
local _____6D4B_8BD5_547D_4EE4 = "1004"
local function ____on_804A_59291004_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local x = GetUnitX(_____5927_6CD5_5E08)
    local y = GetUnitY(_____5927_6CD5_5E08)
    local fac = GetUnitFacing(_____5927_6CD5_5E08)
    _____521B_5EFA_77E9_5F62_63D0_793A_5708(
        x,
        y,
        200,
        600,
        fac,
        2
    )
    debugLogForce(
        _____6A21_5757_540D,
        "已创建矩形提示特效 x=",
        x,
        "y=",
        y,
        "宽=200 长=600"
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291004_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "在大法师面前创建矩形提示圈")
return ____exports
