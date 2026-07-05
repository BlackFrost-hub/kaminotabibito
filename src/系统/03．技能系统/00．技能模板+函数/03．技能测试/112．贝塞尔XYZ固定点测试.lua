--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_4E8C_9636_8D1D_585E_5C14_52A0_901F_5EA6_629B_7269_7EBF_8F68_8FF9 = ____index["创建二阶贝塞尔加速度抛物线轨迹"]
local _____521B_5EFA_539F_751F_5F39_5E55 = ____index["创建原生弹幕"]
--- 贝塞尔 XYZ 固定点测试
-- 
-- 输入 "1012"：
-- - 从 gg_unit_Hamg_0002 前方发射固定终点二阶贝塞尔抛物线弹幕。
-- - 测试 Z 高度采样、到达目标点回调、结束回调。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local Cos = jass.Cos
local Sin = jass.Sin
local _____6A21_5757_540D = "贝塞尔XYZ固定点测试"
local _____6D4B_8BD5_547D_4EE4 = "1012"
local function _____6295_5F71X(x, angle, distance)
    return x + Cos(angle * jass.bj_DEGTORAD) * distance
end
local function _____6295_5F71Y(y, angle, distance)
    return y + Sin(angle * jass.bj_DEGTORAD) * distance
end
local function _____56FA_5B9A_70B9_8D1D_585E_5C14__5230_8FBE(_____5F39_5E55ID, _____539F_56E0)
    debugLogForce(
        _____6A21_5757_540D,
        "到达目标点",
        "弹幕ID=",
        _____5F39_5E55ID,
        "原因=",
        _____539F_56E0
    )
end
local function _____56FA_5B9A_70B9_8D1D_585E_5C14__7ED3_675F(_____539F_56E0, _____5F39_5E55ID)
    debugLogForce(
        _____6A21_5757_540D,
        "结束",
        "弹幕ID=",
        _____5F39_5E55ID,
        "原因=",
        _____539F_56E0
    )
end
local function ____on_804A_59291012_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local face = GetUnitFacing(_____5927_6CD5_5E08)
    local startX = _____6295_5F71X(
        GetUnitX(_____5927_6CD5_5E08),
        face,
        80
    )
    local startY = _____6295_5F71Y(
        GetUnitY(_____5927_6CD5_5E08),
        face,
        80
    )
    local endX = _____6295_5F71X(
        GetUnitX(_____5927_6CD5_5E08),
        face,
        900
    )
    local endY = _____6295_5F71Y(
        GetUnitY(_____5927_6CD5_5E08),
        face,
        900
    )
    local controlX = _____6295_5F71X(
        GetUnitX(_____5927_6CD5_5E08),
        face + 35,
        520
    )
    local controlY = _____6295_5F71Y(
        GetUnitY(_____5927_6CD5_5E08),
        face + 35,
        520
    )
    local _____5B9E_4F8B = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = _____5927_6CD5_5E08,
        X = startX,
        Y = startY,
        ["方向角"] = face,
        ["速度"] = 0,
        ["生命周期"] = 6,
        ["命中半径"] = 96,
        ["伤害值"] = 25,
        ["伤害形态"] = "AOE",
        ["影响目标"] = "敌方",
        ["模型"] = "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl",
        ["轨迹采样器"] = _____521B_5EFA_4E8C_9636_8D1D_585E_5C14_52A0_901F_5EA6_629B_7269_7EBF_8F68_8FF9(
            startX,
            startY,
            60,
            controlX,
            controlY,
            endX,
            endY,
            60,
            360,
            400
        ),
        ["on到达目标点"] = _____56FA_5B9A_70B9_8D1D_585E_5C14__5230_8FBE,
        ["on结束"] = _____56FA_5B9A_70B9_8D1D_585E_5C14__7ED3_675F
    })
    debugLogForce(
        _____6A21_5757_540D,
        "已发射固定点贝塞尔XYZ弹幕",
        "弹幕ID=",
        _____5B9E_4F8B["弹幕ID"],
        "终点=(",
        endX,
        ",",
        endY,
        ")"
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291012_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "发射固定点贝塞尔XYZ弹幕")
return ____exports
