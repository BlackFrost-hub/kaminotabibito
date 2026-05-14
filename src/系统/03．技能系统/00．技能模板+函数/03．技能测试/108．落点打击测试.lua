--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.14．落点打击.index")
local _____521B_5EFA_843D_70B9_6253_51FB = ____index["创建落点打击"]
--- 落点打击测试
-- 
-- 输入"1008"后，以 `gg_unit_Hamg_0002` 前方矩形区域为范围，
-- 1.5秒后触发 3 段落雷，在前方 800、半宽 150 的矩形内随机，
-- 对 250 半径敌人造成 30 伤害，同一个单位最多命中 1 次。
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
local _____6A21_5757_540D = "落点打击测试"
local _____6D4B_8BD5_547D_4EE4 = "1008"
local _____77E9_5F62_524D_65B9_957F_5EA6 = 800
local _____77E9_5F62_534A_5BBD = 150
local _____5EF6_8FDF_65F6_95F4 = 1.5
local _____843D_70B9_6570_91CF = 3
local _____843D_70B9_95F4_9694 = 0.3
local _____4F24_5BB3_534A_5F84 = 250
local _____4F24_5BB3_503C = 30
local function _____53D6_524D_65B9_76EE_6807_70B9X(_____5355_4F4D, _____8DDD_79BB)
    local _____671D_5411 = GetUnitFacing(_____5355_4F4D) * jass.bj_DEGTORAD
    return GetUnitX(_____5355_4F4D) + Cos(_____671D_5411) * _____8DDD_79BB
end
local function _____53D6_524D_65B9_76EE_6807_70B9Y(_____5355_4F4D, _____8DDD_79BB)
    local _____671D_5411 = GetUnitFacing(_____5355_4F4D) * jass.bj_DEGTORAD
    return GetUnitY(_____5355_4F4D) + Sin(_____671D_5411) * _____8DDD_79BB
end
local function _____843D_70B9_6253_51FB_6D4B_8BD5__5355_6B21_751F_6548(X, Y, _____843D_70B9_5E8F_53F7, _____5B9E_4F8BID)
    debugLogForce(
        _____6A21_5757_540D,
        "落点生效：实例ID=",
        _____5B9E_4F8BID,
        "序号=",
        _____843D_70B9_5E8F_53F7,
        "坐标=(",
        X,
        ",",
        Y,
        ")"
    )
end
local function _____843D_70B9_6253_51FB_6D4B_8BD5__547D_4E2D(_____5355_4F4D, _____843D_70B9_5E8F_53F7, _____5B9E_4F8BID)
    debugLogForce(
        _____6A21_5757_540D,
        "命中单位：实例ID=",
        _____5B9E_4F8BID,
        "序号=",
        _____843D_70B9_5E8F_53F7,
        "目标坐标=(",
        GetUnitX(_____5355_4F4D),
        ",",
        GetUnitY(_____5355_4F4D),
        ")"
    )
end
local function _____843D_70B9_6253_51FB_6D4B_8BD5__5168_90E8_5B8C_6210(_____5B9E_4F8BID)
    debugLogForce(_____6A21_5757_540D, "落点打击结束：实例ID=", _____5B9E_4F8BID)
end
local function ____on_804A_59291008_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local _____671D_5411_89D2 = GetUnitFacing(_____5927_6CD5_5E08)
    local _____77E9_5F62_4E2D_5FC3X = _____53D6_524D_65B9_76EE_6807_70B9X(_____5927_6CD5_5E08, _____77E9_5F62_524D_65B9_957F_5EA6 * 0.5)
    local _____77E9_5F62_4E2D_5FC3Y = _____53D6_524D_65B9_76EE_6807_70B9Y(_____5927_6CD5_5E08, _____77E9_5F62_524D_65B9_957F_5EA6 * 0.5)
    local _____5B9E_4F8BID = _____521B_5EFA_843D_70B9_6253_51FB({
        X = _____77E9_5F62_4E2D_5FC3X,
        Y = _____77E9_5F62_4E2D_5FC3Y,
        ["延迟时间"] = _____5EF6_8FDF_65F6_95F4,
        ["伤害半径"] = _____4F24_5BB3_534A_5F84,
        ["提示半径"] = _____4F24_5BB3_534A_5F84,
        ["伤害值"] = _____4F24_5BB3_503C,
        ["所有者"] = _____5927_6CD5_5E08,
        ["影响目标"] = "敌方",
        ["落点数量"] = _____843D_70B9_6570_91CF,
        ["落点间隔"] = _____843D_70B9_95F4_9694,
        ["随机区域形状"] = "矩形",
        ["随机矩形长度"] = _____77E9_5F62_524D_65B9_957F_5EA6,
        ["随机矩形宽度"] = _____77E9_5F62_534A_5BBD * 2,
        ["随机区域方向角"] = _____671D_5411_89D2,
        ["最小落点间距"] = 150,
        ["每单位最大命中次数"] = 1,
        ["on单次生效"] = _____843D_70B9_6253_51FB_6D4B_8BD5__5355_6B21_751F_6548,
        ["on单次命中"] = _____843D_70B9_6253_51FB_6D4B_8BD5__547D_4E2D,
        ["on全部完成"] = _____843D_70B9_6253_51FB_6D4B_8BD5__5168_90E8_5B8C_6210
    })
    if _____5B9E_4F8BID <= 0 then
        debugLogForce(_____6A21_5757_540D, "落点打击创建失败")
        return
    end
    debugLogForce(
        _____6A21_5757_540D,
        "已启动测试：实例ID=",
        _____5B9E_4F8BID,
        "矩形中心=(",
        _____77E9_5F62_4E2D_5FC3X,
        ",",
        _____77E9_5F62_4E2D_5FC3Y,
        ") 延迟=",
        _____5EF6_8FDF_65F6_95F4,
        " 数量=",
        _____843D_70B9_6570_91CF,
        " 间隔=",
        _____843D_70B9_95F4_9694,
        " 前方长度=",
        _____77E9_5F62_524D_65B9_957F_5EA6,
        " 半宽=",
        _____77E9_5F62_534A_5BBD,
        " 伤害半径=",
        _____4F24_5BB3_534A_5F84,
        " 伤害=",
        _____4F24_5BB3_503C
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_804A_59291008_6D4B_8BD5)
debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "触发延迟落雷打击")
return ____exports
