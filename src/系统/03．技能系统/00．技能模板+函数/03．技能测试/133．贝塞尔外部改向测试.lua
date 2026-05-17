--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_4E8C_9636_8D1D_585E_5C14_52A0_901F_5EA6_629B_7269_7EBF_8F68_8FF9 = ____index["创建二阶贝塞尔加速度抛物线轨迹"]
local _____521B_5EFA_539F_751F_5F39_5E55 = ____index["创建原生弹幕"]
local _____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C = ____index["设置原生弹幕指定角度飞行"]
--- 贝塞尔显式改向测试
-- 
-- 输入 "1193"：
-- - 发射一枚明显弯曲的贝塞尔弹幕。
-- 
-- 输入 "1194"：
-- - 把当前弹幕切成直线，并在上一次测试目标角基础上继续 +135 度。
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
local _____6A21_5757_540D = "贝塞尔显式改向测试"
local _____53D1_5C04_547D_4EE4 = "133"
local _____6539_5411_547D_4EE4 = "134"
local _____6700_8FD1_5F39_5E55ID = 0
local _____6700_8FD1_6D4B_8BD5_76EE_6807_9762_5411 = 0
local function _____6295_5F71X(x, angle, distance)
    return x + Cos(angle * jass.bj_DEGTORAD) * distance
end
local function _____6295_5F71Y(y, angle, distance)
    return y + Sin(angle * jass.bj_DEGTORAD) * distance
end
local function ____on_7ED3_675F(_____539F_56E0, _____5F39_5E55ID)
    debugLogForce(
        _____6A21_5757_540D,
        "结束",
        "弹幕ID=",
        _____5F39_5E55ID,
        "原因=",
        _____539F_56E0
    )
    if _____5F39_5E55ID == _____6700_8FD1_5F39_5E55ID then
        _____6700_8FD1_5F39_5E55ID = 0
        _____6700_8FD1_6D4B_8BD5_76EE_6807_9762_5411 = 0
    end
end
local function ____on_804A_5929_53D1_5C04()
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
        1000
    )
    local endY = _____6295_5F71Y(
        GetUnitY(_____5927_6CD5_5E08),
        face,
        1000
    )
    local controlX = _____6295_5F71X(
        GetUnitX(_____5927_6CD5_5E08),
        face + 90,
        520
    )
    local controlY = _____6295_5F71Y(
        GetUnitY(_____5927_6CD5_5E08),
        face + 90,
        520
    )
    local _____5B9E_4F8B = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = _____5927_6CD5_5E08,
        X = startX,
        Y = startY,
        ["方向角"] = face,
        ["速度"] = 0,
        ["生命周期"] = 10,
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
            240,
            320
        ),
        ["on结束"] = ____on_7ED3_675F
    })
    _____6700_8FD1_5F39_5E55ID = _____5B9E_4F8B["弹幕ID"]
    _____6700_8FD1_6D4B_8BD5_76EE_6807_9762_5411 = face
    debugLogForce(
        _____6A21_5757_540D,
        "已发射",
        "弹幕ID=",
        _____6700_8FD1_5F39_5E55ID,
        "输入",
        _____6539_5411_547D_4EE4,
        "可改向"
    )
end
local function ____on_804A_5929_6539_5411()
    if _____6700_8FD1_5F39_5E55ID <= 0 then
        debugLogForce(_____6A21_5757_540D, "当前无可改向弹幕，请先输入", _____53D1_5C04_547D_4EE4)
        return
    end
    _____6700_8FD1_6D4B_8BD5_76EE_6807_9762_5411 = _____6700_8FD1_6D4B_8BD5_76EE_6807_9762_5411 + 135
    local _____65B0_9762_5411 = _____6700_8FD1_6D4B_8BD5_76EE_6807_9762_5411
    local ok = _____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C(_____6700_8FD1_5F39_5E55ID, _____65B0_9762_5411, 220)
    debugLogForce(
        _____6A21_5757_540D,
        "已显式改向",
        "弹幕ID=",
        _____6700_8FD1_5F39_5E55ID,
        "新面向=",
        _____65B0_9762_5411,
        "成功=",
        ok
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____53D1_5C04_547D_4EE4, ____on_804A_5929_53D1_5C04)
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6539_5411_547D_4EE4, ____on_804A_5929_6539_5411)
debugLogForce(
    _____6A21_5757_540D,
    "已注册测试：",
    _____53D1_5C04_547D_4EE4,
    "发射；",
    _____6539_5411_547D_4EE4,
    "改向"
)
return ____exports
