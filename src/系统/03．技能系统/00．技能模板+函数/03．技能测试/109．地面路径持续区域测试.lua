--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.index")
local _____521B_5EFA_706B_7130_8DEF_5F84_6301_7EED_533A_57DF = ____index["创建火焰路径持续区域"]
--- 地面路径持续区域测试
-- 
-- 输入"1009"后，以 `gg_unit_Hamg_0002` 当前面向为方向，
-- 在前方 800 码、半径 100 的路径上逐段铺设火焰特效，
-- 但伤害统一按前方 800、半径 200 的整体矩形区域持续结算 10 秒。
local jass = require("jass.common")
local g = require("jass.globals")
local CreateTrigger = jass.CreateTrigger
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerAddAction = jass.TriggerAddAction
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local _____6A21_5757_540D = "地面路径持续区域测试"
local _____6D4B_8BD5_547D_4EE4 = "1009"
local _____8DEF_5F84_957F_5EA6 = 800
local _____8DEF_5F84_534A_5F84 = 100
local _____6574_4F53_4F24_5BB3_534A_5F84 = 200
local _____8DEF_5F84_6301_7EED_65F6_95F4 = 10
local _____5468_671F_4F24_5BB3 = 30
local _____68C0_6D4B_95F4_9694 = 1
local _____94FA_8BBE_95F4_9694 = 0.05
local _____6BB5_95F4_8DDD = 100
local function _____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_6D4B_8BD5__5355_6BB5_521B_5EFA(_____6BB5_5E8F_53F7, X, Y)
    debugLogForce(
        _____6A21_5757_540D,
        "已铺设火焰段：序号=",
        _____6BB5_5E8F_53F7,
        " 坐标=(",
        X,
        ",",
        Y,
        ")"
    )
end
local function _____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_6D4B_8BD5__5168_90E8_94FA_8BBE_5B8C_6210(_____5B9E_4F8BID)
    debugLogForce(_____6A21_5757_540D, "火焰路径铺设完成：实例ID=", _____5B9E_4F8BID)
end
local function _____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_6D4B_8BD5__9500_6BC1(_____5B9E_4F8BID)
    debugLogForce(_____6A21_5757_540D, "火焰路径已销毁：实例ID=", _____5B9E_4F8BID)
end
local function ____on_804A_59291009_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local _____8D77_70B9X = GetUnitX(_____5927_6CD5_5E08)
    local _____8D77_70B9Y = GetUnitY(_____5927_6CD5_5E08)
    local _____65B9_5411_89D2 = GetUnitFacing(_____5927_6CD5_5E08)
    local _____5B9E_4F8B = _____521B_5EFA_706B_7130_8DEF_5F84_6301_7EED_533A_57DF({
        ["起点X"] = _____8D77_70B9X,
        ["起点Y"] = _____8D77_70B9Y,
        ["方向角"] = _____65B9_5411_89D2,
        ["路径长度"] = _____8DEF_5F84_957F_5EA6,
        ["路径半径"] = _____8DEF_5F84_534A_5F84,
        ["区域持续时间"] = _____8DEF_5F84_6301_7EED_65F6_95F4,
        ["伤害模式"] = "整体矩形",
        ["段间距"] = _____6BB5_95F4_8DDD,
        ["铺设间隔"] = _____94FA_8BBE_95F4_9694,
        ["检测间隔"] = _____68C0_6D4B_95F4_9694,
        ["周期伤害"] = _____5468_671F_4F24_5BB3,
        ["整体伤害长度"] = _____8DEF_5F84_957F_5EA6,
        ["整体伤害半径"] = _____6574_4F53_4F24_5BB3_534A_5F84,
        ["影响目标"] = "敌方",
        ["所有者"] = _____5927_6CD5_5E08,
        ["显示提示圈"] = false,
        ["on单段创建"] = _____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_6D4B_8BD5__5355_6BB5_521B_5EFA,
        ["on全部铺设完成"] = _____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_6D4B_8BD5__5168_90E8_94FA_8BBE_5B8C_6210,
        ["on销毁"] = _____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_6D4B_8BD5__9500_6BC1
    })
    debugLogForce(
        _____6A21_5757_540D,
        "已启动火焰路径测试：实例ID=",
        _____5B9E_4F8B["实例ID"],
        " 起点=(",
        _____8D77_70B9X,
        ",",
        _____8D77_70B9Y,
        ") 方向角=",
        _____65B9_5411_89D2,
        " 长度=",
        _____8DEF_5F84_957F_5EA6,
        " 火焰半径=",
        _____8DEF_5F84_534A_5F84,
        " 整体伤害半径=",
        _____6574_4F53_4F24_5BB3_534A_5F84,
        " 持续时间=",
        _____8DEF_5F84_6301_7EED_65F6_95F4,
        " 周期伤害=",
        _____5468_671F_4F24_5BB3
    )
end
local function _____6CE8_518C_804A_5929_6D4B_8BD5()
    local trig = CreateTrigger()
    TriggerRegisterPlayerChatEvent(
        trig,
        Player(0),
        _____6D4B_8BD5_547D_4EE4,
        true
    )
    TriggerAddAction(trig, ____on_804A_59291009_6D4B_8BD5)
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "触发火焰路径持续区域")
end
_____6CE8_518C_804A_5929_6D4B_8BD5()
return ____exports
