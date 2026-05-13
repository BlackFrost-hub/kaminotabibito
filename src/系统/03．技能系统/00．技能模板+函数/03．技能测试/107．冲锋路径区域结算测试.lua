--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.index")
local _____5F00_59CB_51B2_950B_5E76_5728_7ED3_675F_65F6_7ED3_7B97_8DEF_5F84_533A_57DF = ____index["开始冲锋并在结束时结算路径区域"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.01．多阶段技能编排.index")
local _____5F00_59CB_6280_80FD_524D_6447 = ____index["开始技能前摇"]
local _____521B_5EFA_51B2_950B_8DEF_5F84_524D_6447_63D0_793A = ____index["创建冲锋路径前摇提示"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
--- 冲锋路径区域结算测试
-- 
-- 输入"1007"后，`gg_unit_Hamg_0002` 会先播放 `attack` 动作并硬直 1 秒，
-- 之后沿当前面向冲锋 800 码，持续 0.4 秒。
-- 冲锋结束后，对整条 800 码路径上“半径 200”的敌方单位造成 200 伤害。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local CreateTrigger = jass.CreateTrigger
local TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent
local TriggerAddAction = jass.TriggerAddAction
local Player = jass.Player
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local _____6A21_5757_540D = "冲锋路径区域结算测试"
local _____6D4B_8BD5_547D_4EE4 = "1007"
local _____51B2_950B_8DDD_79BB = 800
local _____8DEF_5F84_534A_5F84 = 200
local _____8DEF_5F84_5BBD_5EA6 = _____8DEF_5F84_534A_5F84 * 2
local _____524D_6447_65F6_95F4 = 1
local _____51B2_950B_8DEF_5F84_524D_6447_63D0_793A = _____521B_5EFA_51B2_950B_8DEF_5F84_524D_6447_63D0_793A(_____51B2_950B_8DDD_79BB, _____8DEF_5F84_5BBD_5EA6, _____524D_6447_65F6_95F4)
local _____5DF2_6CE8_518C = false
local function _____53D6_671D_5411_7EC8_70B9X(x, _____671D_5411_89D2, _____8DDD_79BB)
    return x + jass.Cos(_____671D_5411_89D2 * jass.bj_DEGTORAD) * _____8DDD_79BB
end
local function _____53D6_671D_5411_7EC8_70B9Y(y, _____671D_5411_89D2, _____8DDD_79BB)
    return y + jass.Sin(_____671D_5411_89D2 * jass.bj_DEGTORAD) * _____8DDD_79BB
end
local function _____51B2_950B_8DEF_5F84_533A_57DF__7ED3_675F_65E5_5FD7(_____5355_4F4D, _____539F_56E0, _____4F4D_79FBID)
    debugLogForce(
        _____6A21_5757_540D,
        "冲锋结束，原因=",
        _____539F_56E0,
        "位移ID=",
        _____4F4D_79FBID,
        "终点=(",
        GetUnitX(_____5355_4F4D),
        ",",
        GetUnitY(_____5355_4F4D),
        ")"
    )
end
local function _____51B2_950B_8DEF_5F84_533A_57DF__547D_4E2D_65E5_5FD7(______79FB_52A8_5355_4F4D, _____76EE_6807_5355_4F4D, _____4F4D_79FBID, _____539F_56E0)
    debugLogForce(
        _____6A21_5757_540D,
        "路径命中：位移ID=",
        _____4F4D_79FBID,
        "原因=",
        _____539F_56E0,
        "目标=(",
        GetUnitX(_____76EE_6807_5355_4F4D),
        ",",
        GetUnitY(_____76EE_6807_5355_4F4D),
        ")"
    )
end
local function _____6267_884C_51B2_950B_8DEF_5F84_65A9_6740(_____5927_6CD5_5E08)
    local _____8D77_70B9X = GetUnitX(_____5927_6CD5_5E08)
    local _____8D77_70B9Y = GetUnitY(_____5927_6CD5_5E08)
    local _____671D_5411_89D2 = GetUnitFacing(_____5927_6CD5_5E08)
    local _____76EE_6807X = _____53D6_671D_5411_7EC8_70B9X(_____8D77_70B9X, _____671D_5411_89D2, _____51B2_950B_8DDD_79BB)
    local _____76EE_6807Y = _____53D6_671D_5411_7EC8_70B9Y(_____8D77_70B9Y, _____671D_5411_89D2, _____51B2_950B_8DDD_79BB)
    local _____4F4D_79FBID = _____5F00_59CB_51B2_950B_5E76_5728_7ED3_675F_65F6_7ED3_7B97_8DEF_5F84_533A_57DF(_____5927_6CD5_5E08, {
        ["目标X"] = _____76EE_6807X,
        ["目标Y"] = _____76EE_6807Y,
        ["距离"] = _____51B2_950B_8DDD_79BB,
        ["持续时间"] = 0.4,
        ["检查地形"] = true,
        ["朝向跟随位移"] = true,
        ["禁用碰撞"] = true,
        ["结束回调"] = _____51B2_950B_8DEF_5F84_533A_57DF__7ED3_675F_65E5_5FD7
    }, {
        ["区域形状"] = "胶囊",
        ["宽度"] = _____8DEF_5F84_5BBD_5EA6,
        ["伤害值"] = 200,
        ["影响目标"] = "敌方",
        ["仅完成时结算"] = true,
        ["命中回调"] = _____51B2_950B_8DEF_5F84_533A_57DF__547D_4E2D_65E5_5FD7
    })
    if _____4F4D_79FBID <= 0 then
        debugLogForce(_____6A21_5757_540D, "冲锋启动失败：无法解析冲锋目标")
        return
    end
    debugLogForce(
        _____6A21_5757_540D,
        "已启动测试：位移ID=",
        _____4F4D_79FBID,
        "起点=(",
        _____8D77_70B9X,
        ",",
        _____8D77_70B9Y,
        ") 斩杀终点=(",
        _____76EE_6807X,
        ",",
        _____76EE_6807Y,
        ") 路径长度=",
        _____51B2_950B_8DDD_79BB,
        " 路径半径=",
        _____8DEF_5F84_534A_5F84,
        " 伤害=200"
    )
end
local function _____524D_6447_5F00_59CB__64AD_653E_65BD_6CD5_52A8_4F5C(_____5355_4F4D, _____524D_6447ID)
    _____5F00_59CB_786C_76F4(_____5355_4F4D, _____524D_6447_65F6_95F4)
    debugLogForce(
        _____6A21_5757_540D,
        "前摇开始：前摇ID=",
        _____524D_6447ID,
        "先硬直，再由前摇模块零秒后播放动作=attack 硬直=",
        _____524D_6447_65F6_95F4
    )
end
local function _____524D_6447_7ED3_675F__6062_590D_5F85_673A_52A8_4F5C(_____5355_4F4D, _____539F_56E0, _____524D_6447ID)
    if type(SetUnitAnimationByIndex) == "function" then
        SetUnitAnimationByIndex(_____5355_4F4D, 0)
    end
    debugLogForce(
        _____6A21_5757_540D,
        "前摇结束：前摇ID=",
        _____524D_6447ID,
        "原因=",
        _____539F_56E0
    )
end
local function ____on_804A_59291007_6D4B_8BD5()
    local _____5927_6CD5_5E08 = g.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 then
        debugLogForce(_____6A21_5757_540D, "错误：未找到 gg_unit_Hamg_0002")
        return
    end
    local _____524D_6447ID = _____5F00_59CB_6280_80FD_524D_6447(_____5927_6CD5_5E08, {
        ["持续时间"] = _____524D_6447_65F6_95F4,
        ["施法动作名"] = "attack",
        ["创建提示特效"] = _____51B2_950B_8DEF_5F84_524D_6447_63D0_793A["创建提示特效"],
        ["销毁提示特效"] = _____51B2_950B_8DEF_5F84_524D_6447_63D0_793A["销毁提示特效"],
        ["开始回调"] = _____524D_6447_5F00_59CB__64AD_653E_65BD_6CD5_52A8_4F5C,
        ["完成后执行"] = _____6267_884C_51B2_950B_8DEF_5F84_65A9_6740,
        ["结束回调"] = _____524D_6447_7ED3_675F__6062_590D_5F85_673A_52A8_4F5C
    })
    if _____524D_6447ID <= 0 then
        debugLogForce(_____6A21_5757_540D, "前摇启动失败")
        return
    end
    debugLogForce(_____6A21_5757_540D, "已启动测试：前摇ID=", _____524D_6447ID, "attack 1秒后执行冲锋路径斩杀")
end
local function _____6CE8_518C_804A_5929_6D4B_8BD5()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    local trig = CreateTrigger()
    TriggerRegisterPlayerChatEvent(
        trig,
        Player(0),
        _____6D4B_8BD5_547D_4EE4,
        true
    )
    TriggerAddAction(trig, ____on_804A_59291007_6D4B_8BD5)
    debugLogForce(_____6A21_5757_540D, "已注册测试：输入", _____6D4B_8BD5_547D_4EE4, "触发 attack前摇1秒 + 冲锋路径斩杀")
end
_____6CE8_518C_804A_5929_6D4B_8BD5()
return ____exports
