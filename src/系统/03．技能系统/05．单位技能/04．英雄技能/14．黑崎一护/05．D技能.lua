--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local MathCos, MathSin, Cos, Sin, bj_DEGTORAD
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.00．配置")
local _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["黑崎一护技能配置"]
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.01．状态表")
local _____83B7_53D6_6216_521B_5EFA_9ED1_5D0E_4E00_62A4_72B6_6001 = ____01_FF0E_72B6_6001_8868["获取或创建黑崎一护状态"]
local _____5F00_542F_77AC_6B65_8FDE_643A = ____01_FF0E_72B6_6001_8868["开启瞬步连携"]
local _____5173_95ED_77AC_6B65_8FDE_643A = ____01_FF0E_72B6_6001_8868["关闭瞬步连携"]
local _____6708_7259_662F_5426_98DE_884C_4E2D = ____01_FF0E_72B6_6001_8868["月牙是否飞行中"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function MathCos(_____89D2_5EA6)
    return Cos(_____89D2_5EA6 * bj_DEGTORAD)
end
function MathSin(_____89D2_5EA6)
    return Sin(_____89D2_5EA6 * bj_DEGTORAD)
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_1["开始冲锋"]
local ____require_result_2 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_2.Sound3DII_CooPlayReuse
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitState = jass.GetUnitState
local GetHandleId = jass.GetHandleId
local Atan2 = jass.Atan2
local SquareRoot = jass.SquareRoot
local bj_RADTODEG = jass.bj_RADTODEG
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
local _____914D_7F6E = _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____D_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAD_4E0A_4E0B_6587(unit)
    local id = GetHandleId(unit)
    local ctx = ____D_4E0A_4E0B_6587_8868[id]
    if ctx == nil then
        ctx = {["连携窗口回调ID"] = 0}
        ____D_4E0A_4E0B_6587_8868[id] = ctx
    end
    return ctx
end
local function _____5173_95ED_77AC_6B65_8FDE_643A_7A97_53E3(variable)
    local unit = variable
    if unit == nil or unit == 0 then
        return
    end
    _____5173_95ED_77AC_6B65_8FDE_643A(unit)
    local ctx = ____D_4E0A_4E0B_6587_8868[GetHandleId(unit)]
    if ctx ~= nil then
        ctx["连携窗口回调ID"] = 0
    end
end
local function _____91CA_653E_77AC_6B65(context, caster, ______6280_80FD_5B9E_4F8BID)
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    Sound3DII_CooPlayReuse(
        _____914D_7F6E.D["音效"]["路径"],
        x,
        y,
        0,
        _____914D_7F6E.D["音效"]["裁断距离"]
    )
    local _____6700_5927_9B54_6CD5 = GetUnitState(caster, UNIT_STATE_MAX_MANA)
    local _____77AC_6B65_8DDD_79BB = _____914D_7F6E.D["基础距离"] + _____6700_5927_9B54_6CD5 / 1000 * _____914D_7F6E.D["每千魔法加成距离"]
    local _____76EE_6807X
    local _____76EE_6807Y
    local record = _____83B7_53D6_6216_521B_5EFA_9ED1_5D0E_4E00_62A4_72B6_6001(caster)
    if _____6708_7259_662F_5426_98DE_884C_4E2D(caster) then
        _____76EE_6807X = record["月牙X"]
        _____76EE_6807Y = record["月牙Y"]
    else
        local tx = GetSpellTargetX()
        local ty = GetSpellTargetY()
        local dx = tx - x
        local dy = ty - y
        local _____89D2_5EA6 = Atan2(dy, dx) * bj_RADTODEG
        _____76EE_6807X = x + MathCos(_____89D2_5EA6) * _____77AC_6B65_8DDD_79BB
        _____76EE_6807Y = y + MathSin(_____89D2_5EA6) * _____77AC_6B65_8DDD_79BB
    end
    local _____4F4D_79FBX = _____76EE_6807X - x
    local _____4F4D_79FBY = _____76EE_6807Y - y
    local _____5B9E_9645_4F4D_79FB_8DDD_79BB = SquareRoot(_____4F4D_79FBX * _____4F4D_79FBX + _____4F4D_79FBY * _____4F4D_79FBY)
    _____5F00_59CB_51B2_950B(caster, {
        ["目标X"] = _____76EE_6807X,
        ["目标Y"] = _____76EE_6807Y,
        ["距离"] = _____5B9E_9645_4F4D_79FB_8DDD_79BB,
        ["持续时间"] = _____914D_7F6E.D["冲锋持续时间秒"],
        ["检查地形"] = true,
        ["禁用碰撞"] = true
    })
    _____5F00_542F_77AC_6B65_8FDE_643A(caster)
    if context["连携窗口回调ID"] ~= 0 then
        removeDelayedCallback(context["连携窗口回调ID"])
    end
    context["连携窗口回调ID"] = addDelayedCallback(
        math.floor(_____914D_7F6E.D["连携窗口秒"] * 1000 + 0.5),
        _____5173_95ED_77AC_6B65_8FDE_643A_7A97_53E3,
        caster
    )
end
Cos = jass.Cos
Sin = jass.Sin
bj_DEGTORAD = jass.bj_DEGTORAD
____exports["注册黑崎一护D"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "黑崎一护-瞬步（D）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.D["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAD_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_77AC_6B65,
        ["创建独立技能实例"] = false
    })
end
____exports["注册黑崎一护D"]()
return ____exports
