--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.00．配置")
local _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["黑崎一护技能配置"]
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.01．状态表")
local _____9ED1_5D0E_4E00_62A4_662F_5426_534D_89E3 = ____01_FF0E_72B6_6001_8868["黑崎一护是否卍解"]
local _____8BB0_5F55_6708_7259_4F4D_7F6E = ____01_FF0E_72B6_6001_8868["记录月牙位置"]
local _____6E05_9664_6708_7259_4F4D_7F6E = ____01_FF0E_72B6_6001_8868["清除月牙位置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_1["造成单体技能伤害"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_2["获取范围敌军"]
local ____require_result_3 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_3["技能_设置技能冷却时间"]
local ____require_result_4 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_4.Sound3DII_CooPlayReuse
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_5["创建点特效"]
local _____9500_6BC1_70B9_7279_6548 = ____require_result_5["销毁点特效"]
local ____require_result_6 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_6.YDUserDataSetSafe
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local GetHandleId = jass.GetHandleId
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local bj_RADTODEG = jass.bj_RADTODEG
local bj_DEGTORAD = jass.bj_DEGTORAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local DzSetEffectPos = japi.DzSetEffectPos
local _____914D_7F6E = _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____Q_7C7B_578BID = stringToFourCCSafe(_____914D_7F6E.Q["技能ID"])
local ____D_7C7B_578BID = stringToFourCCSafe(_____914D_7F6E.D["技能ID"])
local function _____8BA1_7B97_4E24_70B9_89D2_5EA6(x1, y1, x2, y2)
    return Atan2(y2 - y1, x2 - x1) * bj_RADTODEG
end
local ____Q_5F39_9053_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAQ_4E0A_4E0B_6587(unit)
    local id = GetHandleId(unit)
    local ctx = ____Q_5F39_9053_4E0A_4E0B_6587_8868[id]
    if ctx == nil then
        ctx = {
            ["施法者"] = unit,
            X = 0,
            Y = 0,
            ["角度"] = 0,
            ["Tick数"] = 0,
            ["已命中组"] = {},
            ["主特效"] = nil,
            ["虚影特效"] = nil,
            ["卍解"] = false,
            ["攻击力快照"] = 0,
            ["回调ID"] = 0,
            ["已启动"] = false
        }
        ____Q_5F39_9053_4E0A_4E0B_6587_8868[id] = ctx
    end
    return ctx
end
local function _____7ED3_675FQ_5F39_9053(ctx)
    if ctx["回调ID"] ~= 0 then
        removePeriodicCallback(ctx["回调ID"])
    end
    ctx["回调ID"] = 0
    if ctx["主特效"] ~= nil and ctx["主特效"] ~= 0 then
        _____9500_6BC1_70B9_7279_6548(ctx["主特效"])
    end
    if ctx["虚影特效"] ~= nil and ctx["虚影特效"] ~= 0 then
        _____9500_6BC1_70B9_7279_6548(ctx["虚影特效"])
    end
    ctx["主特效"] = nil
    ctx["虚影特效"] = nil
    ctx["已命中组"] = {}
    ctx["已启动"] = false
    _____6E05_9664_6708_7259_4F4D_7F6E(ctx["施法者"])
end
local function _____7ED3_7B97Q_6708_7259_78B0_649E(ctx)
    local caster = ctx["施法者"]
    local _____654C_519B = _____83B7_53D6_8303_56F4_654C_519B(caster, ctx.X, ctx.Y, _____914D_7F6E.Q["碰撞半径"])
    if _____654C_519B == nil or #_____654C_519B == 0 then
        return
    end
    local _____53C2_6570 = ctx["卍解"] and _____914D_7F6E.Q["解放后"] or _____914D_7F6E.Q["未解放"]
    local _____4F24_5BB3 = ctx["攻击力快照"] * _____53C2_6570["伤害攻击力倍率"]
    if ctx["卍解"] then
        YDUserDataSetSafe(
            "player",
            GetOwningPlayer(caster),
            "无视护甲",
            "boolean",
            true
        )
    end
    do
        local i = 0
        while i < #_____654C_519B do
            do
                local target = _____654C_519B[i + 1]
                if target == nil or target == 0 then
                    goto __continue13
                end
                local tid = GetHandleId(target)
                if ctx["已命中组"][tid] == true then
                    goto __continue13
                end
                ctx["已命中组"][tid] = true
                _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                    ["来源"] = caster,
                    ["目标"] = target,
                    ["伤害"] = _____4F24_5BB3,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    attack = true,
                    ranged = true,
                    attackType = ATTACK_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["标签"] = "黑崎一护-Q月牙天冲",
                    ["技能ID"] = ____Q_7C7B_578BID,
                    ["技能实例ID"] = ctx["技能实例ID"]
                })
            end
            ::__continue13::
            i = i + 1
        end
    end
    if ctx["卍解"] then
        YDUserDataSetSafe(
            "player",
            GetOwningPlayer(caster),
            "无视护甲",
            "boolean",
            false
        )
    end
end
local function _____63A8_8FDBQ_6708_7259(variable)
    local ctx = variable
    if ctx == nil or ctx["已启动"] ~= true then
        return
    end
    ctx["Tick数"] = ctx["Tick数"] + 1
    if ctx["Tick数"] >= _____914D_7F6E.Q["最大推进次数"] then
        _____7ED3_675FQ_5F39_9053(ctx)
        return
    end
    local rad = ctx["角度"] * bj_DEGTORAD
    ctx.X = ctx.X + Cos(rad) * _____914D_7F6E.Q["每Tick距离"]
    ctx.Y = ctx.Y + Sin(rad) * _____914D_7F6E.Q["每Tick距离"]
    local _____53C2_6570 = ctx["卍解"] and _____914D_7F6E.Q["解放后"] or _____914D_7F6E.Q["未解放"]
    if ctx["主特效"] ~= nil and ctx["主特效"] ~= 0 then
        DzSetEffectPos(ctx["主特效"], ctx.X, ctx.Y, _____53C2_6570["弹道高度"])
    end
    if ctx["虚影特效"] ~= nil and ctx["虚影特效"] ~= 0 then
        DzSetEffectPos(ctx["虚影特效"], ctx.X, ctx.Y, _____914D_7F6E.Q["解放后"]["虚影高度"])
    end
    _____8BB0_5F55_6708_7259_4F4D_7F6E(ctx["施法者"], ctx.X, ctx.Y)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____53C2_6570["拖尾模型"],
        X = ctx.X,
        Y = ctx.Y,
        Z = _____53C2_6570["拖尾高度"],
        ["缩放"] = _____53C2_6570["拖尾缩放"],
        ["持续秒"] = _____53C2_6570["拖尾持续秒"]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____53C2_6570["拖尾副模型"],
        X = ctx.X,
        Y = ctx.Y,
        Z = _____53C2_6570["拖尾高度"],
        ["缩放"] = ctx["卍解"] and _____914D_7F6E.Q["解放后"]["拖尾副缩放"] or 1,
        ["持续秒"] = _____53C2_6570["拖尾副持续秒"]
    })
    _____7ED3_7B97Q_6708_7259_78B0_649E(ctx)
end
local function ____Q_53EF_91CA_653E(context, _caster)
    return context["已启动"] ~= true
end
local function _____91CA_653EQ_6708_7259_5929_51B2(context, caster, _____6280_80FD_5B9E_4F8BID)
    _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(caster, ____D_7C7B_578BID, 0, _____914D_7F6E.D["物编冷却秒"])
    local tx = GetSpellTargetX()
    local ty = GetSpellTargetY()
    local sx = GetUnitX(caster)
    local sy = GetUnitY(caster)
    local _____89D2_5EA6 = _____8BA1_7B97_4E24_70B9_89D2_5EA6(sx, sy, tx, ty)
    local _____534D_89E3 = _____9ED1_5D0E_4E00_62A4_662F_5426_534D_89E3(caster)
    local _____53C2_6570 = _____534D_89E3 and _____914D_7F6E.Q["解放后"] or _____914D_7F6E.Q["未解放"]
    Sound3DII_CooPlayReuse(
        _____53C2_6570["音效"]["路径"],
        sx,
        sy,
        0,
        _____53C2_6570["音效"]["裁断距离"]
    )
    context["施法者"] = caster
    context.X = sx
    context.Y = sy
    context["角度"] = _____89D2_5EA6
    context["Tick数"] = 0
    context["已命中组"] = {}
    context["卍解"] = _____534D_89E3
    context["攻击力快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["已启动"] = true
    context["主特效"] = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____53C2_6570["弹道模型"],
        X = sx,
        Y = sy,
        Z = _____53C2_6570["弹道高度"],
        ["面向角度"] = _____89D2_5EA6,
        ["X轴角度"] = _____53C2_6570["弹道X轴角度"],
        ["缩放"] = _____53C2_6570["弹道缩放"],
        ["持续秒"] = 1.5
    })
    if _____534D_89E3 then
        context["虚影特效"] = _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____914D_7F6E.Q["解放后"]["虚影模型"],
            X = sx,
            Y = sy,
            Z = _____914D_7F6E.Q["解放后"]["虚影高度"],
            ["面向角度"] = _____89D2_5EA6,
            ["缩放"] = _____914D_7F6E.Q["解放后"]["虚影缩放"],
            ["持续秒"] = 1.5
        })
    else
        context["虚影特效"] = nil
    end
    _____8BB0_5F55_6708_7259_4F4D_7F6E(caster, sx, sy)
    context["回调ID"] = addPeriodicCallback(
        math.floor(_____914D_7F6E.Q["推进间隔秒"] * 1000 + 0.5),
        _____63A8_8FDBQ_6708_7259,
        context
    )
end
____exports["注册黑崎一护Q"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "黑崎一护-月牙天冲（Q）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.Q["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAQ_4E0A_4E0B_6587,
        ["可释放"] = ____Q_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653EQ_6708_7259_5929_51B2,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 3
    })
end
____exports["注册黑崎一护Q"]()
return ____exports
