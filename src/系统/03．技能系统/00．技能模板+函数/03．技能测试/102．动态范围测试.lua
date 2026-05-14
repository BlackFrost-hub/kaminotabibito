--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____52A8_6001_8303_56F4_6D4B_8BD5__5468_671F, _____52A8_6001_8303_56F4_6D4B_8BD5__9500_6BC1, debugLogForce, _____6A21_5757_540D
local _____52A8_6001_8303_56F4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.04．区域效果.动态范围")
local _____521B_5EFA_52A8_6001_8303_56F4 = _____52A8_6001_8303_56F4["创建动态范围"]
function _____52A8_6001_8303_56F4_6D4B_8BD5__5468_671F(_____5355_4F4D_5217_8868, _____5F53_524D_534A_5F84)
    debugLogForce(
        _____6A21_5757_540D,
        ((("周期触发：当前半径=" .. tostring(_____5F53_524D_534A_5F84)) .. "，命中=") .. tostring(#_____5355_4F4D_5217_8868)) .. "个单位"
    )
end
function _____52A8_6001_8303_56F4_6D4B_8BD5__9500_6BC1()
    debugLogForce(_____6A21_5757_540D, "动态范围效果已结束")
end
--- 动态范围测试
-- 
-- 输入"dt"后，以 gg_unit_Hamg_0002 位置为中心，从 100→1000 扩散，伤害 100。
local jass = require("jass.common")
local g = require("jass.globals")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
_____6A21_5757_540D = "动态范围测试"
local _____6D4B_8BD5_547D_4EE4 = "dt"
local function ____on_804A_5929dt_6D4B_8BD5()
    local _____6765_6E90_5355_4F4D = g.gg_unit_Hamg_0002
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    _____521B_5EFA_52A8_6001_8303_56F4({
        X = GetUnitX(_____6765_6E90_5355_4F4D),
        Y = GetUnitY(_____6765_6E90_5355_4F4D),
        ["起始半径"] = 100,
        ["结束半径"] = 1000,
        ["变化时间"] = 3,
        ["检测间隔"] = 0.5,
        ["影响目标"] = "敌方",
        ["所有者"] = _____6765_6E90_5355_4F4D,
        ["伤害值"] = 100,
        ["on周期"] = _____52A8_6001_8303_56F4_6D4B_8BD5__5468_671F,
        ["on销毁"] = _____52A8_6001_8303_56F4_6D4B_8BD5__9500_6BC1
    })
    debugLogForce(_____6A21_5757_540D, "已创建动态范围：100→1000，3秒扩散，每0.5秒伤害100")
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_5929dt_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "触发动态范围扩散")
return ____exports
