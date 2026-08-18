--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.00．配置")
local _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["黑崎一护技能配置"]
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.01．状态表")
local _____662F_5426_77AC_6B65_8FDE_643A_4E2D = ____01_FF0E_72B6_6001_8868["是否瞬步连携中"]
local _____5173_95ED_77AC_6B65_8FDE_643A = ____01_FF0E_72B6_6001_8868["关闭瞬步连携"]
local _____9ED1_5D0E_4E00_62A4_662F_5426_534D_89E3 = ____01_FF0E_72B6_6001_8868["黑崎一护是否卍解"]
local ____09_FF0E_9ED1_5D0E_4E00_62A4 = require("系统.05．Buff系统.03．Buff表.02．英雄.09．黑崎一护")
local _____9ED1_5D0E_4E00_62A4BuffID = ____09_FF0E_9ED1_5D0E_4E00_62A4["黑崎一护BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_1["造成单体技能伤害"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_2["获取范围敌军"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_3["施加眩晕"]
local _____65BD_52A0_51CF_901F = ____require_result_3["施加减速"]
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local ____require_result_5 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayPool4MultiInstanceRare = ____require_result_5.Sound3DII_CooPlayPool4MultiInstanceRare
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_6["创建点特效"]
local _____9500_6BC1_70B9_7279_6548 = ____require_result_6["销毁点特效"]
local ____require_result_7 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_7.registerDeathListener
local ____require_result_8 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_8.IsUnitAliveBJ
local SelectUnitForPlayerSingle = ____require_result_8.SelectUnitForPlayerSingle
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local GetRandomInt = jass.GetRandomInt
local GetRandomReal = jass.GetRandomReal
local GetOwningPlayer = jass.GetOwningPlayer
local CreateUnit = jass.CreateUnit
local UnitApplyTimedLife = jass.UnitApplyTimedLife
local ShowUnit = jass.ShowUnit
local SquareRoot = jass.SquareRoot
local Cos = jass.Cos
local Sin = jass.Sin
local Atan2 = jass.Atan2
local R2S = jass.R2S
local SetUnitState = jass.SetUnitState
local DzSetEffectVertexAlpha = japi.DzSetEffectVertexAlpha
local DzSetEffectAnimation = japi.DzSetEffectAnimation
local bj_RADTODEG = jass.bj_RADTODEG
local bj_DEGTORAD = jass.bj_DEGTORAD
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local ATTACK_TYPE_HERO = jass.ATTACK_TYPE_HERO
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_9.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
local _____914D_7F6E = _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____E_7C7B_578BID = stringToFourCC(_____914D_7F6E.E["技能ID"])
local _____89C6_91CE_9A6C_7532_7C7B_578BID = stringToFourCC("e007")
local _____5B9A_65F6_751F_547DBuffID = stringToFourCC("BHwe")
local ____E_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAE_4E0A_4E0B_6587(unit)
    local id = GetHandleId(unit)
    local ctx = ____E_4E0A_4E0B_6587_8868[id]
    if ctx == nil then
        ctx = {
            ["施法者"] = unit,
            ["已启动"] = false,
            ["视野马甲"] = nil,
            ["普通回调ID"] = 0,
            ["普通Tick数"] = 0,
            ["目标"] = nil,
            ["幻影列表"] = {},
            ["冲锋回调ID"] = 0,
            ["冲锋Tick数"] = 0,
            ["攻击力快照"] = 0
        }
        ____E_4E0A_4E0B_6587_8868[id] = ctx
    end
    return ctx
end
local function ____E_53EF_91CA_653E(context, _caster)
    return context["已启动"] ~= true
end
local function _____6062_590DE_65BD_6CD5_8005_663E_793A(ctx)
    local caster = ctx["施法者"]
    if caster ~= nil and caster ~= 0 then
        ShowUnit(caster, true)
        SelectUnitForPlayerSingle(
            caster,
            GetOwningPlayer(caster)
        )
    end
    if ctx["视野马甲"] ~= nil and ctx["视野马甲"] ~= 0 then
        jass.RemoveUnit(ctx["视野马甲"])
        ctx["视野马甲"] = nil
    end
end
local function _____6E05_7406E_5E7B_5F71(ctx)
    do
        local i = 0
        while i < #ctx["幻影列表"] do
            local phantom = ctx["幻影列表"][i + 1]
            if phantom["特效"] ~= nil and phantom["特效"] ~= 0 then
                DzSetEffectVertexAlpha(phantom["特效"], 0)
                _____9500_6BC1_70B9_7279_6548(phantom["特效"])
                phantom["特效"] = nil
            end
            i = i + 1
        end
    end
    ctx["幻影列表"] = {}
end
local function _____7ED3_675FE_666E_901A_5206_652F(ctx, _____662F_5426_7ED3_7B97_7EC8_7ED3)
    if ctx["普通回调ID"] ~= 0 then
        removePeriodicCallback(ctx["普通回调ID"])
    end
    ctx["普通回调ID"] = 0
    ctx["已启动"] = false
    if _____662F_5426_7ED3_7B97_7EC8_7ED3 then
        local caster = ctx["施法者"]
        local x = GetUnitX(caster)
        local y = GetUnitY(caster)
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____914D_7F6E.E["普通"]["结束"]["特效模型"],
            X = x,
            Y = y,
            Z = 0,
            ["面向角度"] = GetRandomReal(1, 360),
            ["缩放"] = _____914D_7F6E.E["普通"]["结束"]["特效缩放"],
            ["持续秒"] = _____914D_7F6E.E["普通"]["结束"]["特效持续秒"]
        })
        local _____654C_519B = _____83B7_53D6_8303_56F4_654C_519B(caster, x, y, _____914D_7F6E.E["普通"]["斩击半径"])
        if _____654C_519B ~= nil then
            local _____7EC8_7ED3_4F24_5BB3 = ctx["攻击力快照"] * _____914D_7F6E.E["普通"]["结束"]["伤害攻击力倍率"]
            do
                local i = 0
                while i < #_____654C_519B do
                    do
                        local target = _____654C_519B[i + 1]
                        if target == nil or target == 0 then
                            goto __continue17
                        end
                        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                            ["来源"] = caster,
                            ["目标"] = target,
                            ["伤害"] = _____7EC8_7ED3_4F24_5BB3,
                            ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                            attack = false,
                            attackType = ATTACK_TYPE_NORMAL,
                            weaponType = WEAPON_TYPE_WHOKNOWS,
                            ["来源类型"] = "单位技能",
                            ["标签"] = "黑崎一护-E瞬步斩终结",
                            ["技能ID"] = ____E_7C7B_578BID,
                            ["技能实例ID"] = ctx["技能实例ID"]
                        })
                        _____65BD_52A0_7729_6655(
                            caster,
                            target,
                            _____914D_7F6E.E["普通"]["结束"]["眩晕秒"],
                            "黑崎一护-瞬步斩",
                            "技能"
                        )
                        registerManualBuff(target, _____9ED1_5D0E_4E00_62A4BuffID["瞬步斩眩晕"], _____914D_7F6E.E["普通"]["结束"]["眩晕秒"], 0)
                    end
                    ::__continue17::
                    i = i + 1
                end
            end
        end
        Sound3DII_CooPlayPool4MultiInstanceRare(
            _____914D_7F6E.E["普通"]["结束"]["音效"]["路径"],
            x,
            y,
            0,
            _____914D_7F6E.E["普通"]["结束"]["音效"]["裁断距离"]
        )
    end
    _____6062_590DE_65BD_6CD5_8005_663E_793A(ctx)
end
local function _____63A8_8FDBE_666E_901A_65A9_51FB(variable)
    local ctx = variable
    if ctx == nil or ctx["已启动"] ~= true then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not IsUnitAliveBJ(caster) then
        _____7ED3_675FE_666E_901A_5206_652F(ctx, false)
        return
    end
    if ctx["普通Tick数"] >= _____914D_7F6E.E["普通"]["斩击次数"] then
        _____7ED3_675FE_666E_901A_5206_652F(ctx, true)
        return
    end
    ctx["普通Tick数"] = ctx["普通Tick数"] + 1
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.E["普通"]["斩击特效"]["模型"],
        X = x,
        Y = y,
        Z = 0,
        ["面向角度"] = GetRandomReal(1, 360),
        ["缩放"] = _____914D_7F6E.E["普通"]["斩击特效"]["缩放"],
        ["持续秒"] = _____914D_7F6E.E["普通"]["斩击特效"]["持续秒"]
    })
    Sound3DII_CooPlayPool4MultiInstanceRare(
        _____914D_7F6E.E["普通"]["斩击音效"]["路径"],
        x,
        y,
        0,
        _____914D_7F6E.E["普通"]["斩击音效"]["裁断距离"]
    )
    local _____654C_519B = _____83B7_53D6_8303_56F4_654C_519B(caster, x, y, _____914D_7F6E.E["普通"]["斩击半径"])
    if _____654C_519B == nil or #_____654C_519B == 0 then
        return
    end
    local _____5355_6B21_4F24_5BB3 = ctx["攻击力快照"] * _____914D_7F6E.E["普通"]["单次伤害攻击力倍率"]
    do
        local i = 0
        while i < #_____654C_519B do
            do
                local target = _____654C_519B[i + 1]
                if target == nil or target == 0 then
                    goto __continue25
                end
                local _____89E6_53D1_653B_51FB_6548_679C = GetRandomInt(1, 2) == 1
                _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                    ["来源"] = caster,
                    ["目标"] = target,
                    ["伤害"] = _____5355_6B21_4F24_5BB3,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    attack = _____89E6_53D1_653B_51FB_6548_679C,
                    attackType = ATTACK_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["标签"] = "黑崎一护-E瞬步斩斩击",
                    ["技能ID"] = ____E_7C7B_578BID,
                    ["技能实例ID"] = ctx["技能实例ID"]
                })
                _____65BD_52A0_51CF_901F(
                    caster,
                    target,
                    _____914D_7F6E.E["普通"]["减速比例"],
                    _____914D_7F6E.E["普通"]["减速持续秒"],
                    "黑崎一护-瞬步斩",
                    "技能"
                )
            end
            ::__continue25::
            i = i + 1
        end
    end
end
local function _____7ED3_7B97E_5E7B_5F71_547D_4E2D(ctx, phantom)
    phantom["已命中"] = true
    local caster = ctx["施法者"]
    local target = ctx["目标"]
    if target == nil or target == 0 or not IsUnitAliveBJ(target) then
        return
    end
    local _____5F53_524D_9B54_6CD5 = GetUnitState(caster, UNIT_STATE_MANA)
    local _____6700_5927_9B54_6CD5 = GetUnitState(caster, UNIT_STATE_MAX_MANA)
    local _____9B54_6CD5_52A0_6210 = _____6700_5927_9B54_6CD5 > 0 and _____5F53_524D_9B54_6CD5 / _____6700_5927_9B54_6CD5 or 0
    local _____4F24_5BB3 = ctx["攻击力快照"] * _____914D_7F6E.E["连携"]["单次伤害攻击力倍率"] * (1 + _____9B54_6CD5_52A0_6210)
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标"] = target,
        ["伤害"] = _____4F24_5BB3,
        ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
        attack = true,
        attackType = ATTACK_TYPE_HERO,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["标签"] = "黑崎一护-E瞬步斩幻影",
        ["技能ID"] = ____E_7C7B_578BID,
        ["技能实例ID"] = ctx["技能实例ID"]
    })
    local tx = GetUnitX(target)
    local ty = GetUnitY(target)
    local _____547D_4E2D_7279_6548 = _____9ED1_5D0E_4E00_62A4_662F_5426_534D_89E3(caster) and _____914D_7F6E.E["连携"]["命中特效解放后"] or _____914D_7F6E.E["连携"]["命中特效解放前"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____547D_4E2D_7279_6548["模型"],
        X = tx,
        Y = ty,
        Z = _____547D_4E2D_7279_6548["高度"],
        ["面向角度"] = 270,
        ["缩放"] = _____547D_4E2D_7279_6548["缩放"],
        ["持续秒"] = _____547D_4E2D_7279_6548["持续秒"]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.E["普通"]["斩击特效"]["模型"],
        X = tx,
        Y = ty,
        Z = 0,
        ["面向角度"] = GetRandomReal(1, 360),
        ["缩放"] = _____914D_7F6E.E["普通"]["斩击特效"]["缩放"],
        ["持续秒"] = _____914D_7F6E.E["普通"]["斩击特效"]["持续秒"]
    })
    Sound3DII_CooPlayPool4MultiInstanceRare(
        _____914D_7F6E.E["普通"]["斩击音效"]["路径"],
        tx,
        ty,
        0,
        _____914D_7F6E.E["普通"]["斩击音效"]["裁断距离"]
    )
    local _____5207_8089_97F3 = GetRandomInt(1, 3)
    Sound3DII_CooPlayPool4MultiInstanceRare(
        ("Sound\\Units\\Combat\\MetalHeavySliceFlesh" .. R2S(_____5207_8089_97F3)) .. ".wav",
        tx,
        ty,
        0,
        1500
    )
end
local function SetUnitManaDirect(unit, value)
    SetUnitState(unit, UNIT_STATE_MANA, value < 0 and 0 or value)
end
local function _____7ED3_675FE_8FDE_643A_5206_652F(ctx)
    if ctx["冲锋回调ID"] ~= 0 then
        removePeriodicCallback(ctx["冲锋回调ID"])
    end
    ctx["冲锋回调ID"] = 0
    ctx["已启动"] = false
    local caster = ctx["施法者"]
    if caster ~= nil and caster ~= 0 and IsUnitAliveBJ(caster) then
        local _____6700_5927_9B54_6CD5 = GetUnitState(caster, UNIT_STATE_MAX_MANA)
        SetUnitManaDirect(
            caster,
            GetUnitState(caster, UNIT_STATE_MANA) - _____6700_5927_9B54_6CD5 * _____914D_7F6E.E["连携"]["结束"]["魔法扣除最大比例"]
        )
    end
    local target = ctx["目标"]
    if target ~= nil and target ~= 0 then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____914D_7F6E.E["连携"]["结束"]["鲜血爆炸模型"],
            X = GetUnitX(target),
            Y = GetUnitY(target),
            Z = 0,
            ["持续秒"] = _____914D_7F6E.E["连携"]["结束"]["鲜血爆炸持续秒"]
        })
    end
    _____6E05_7406E_5E7B_5F71(ctx)
    ctx["目标"] = nil
    _____6062_590DE_65BD_6CD5_8005_663E_793A(ctx)
end
local function _____63A8_8FDBE_5E7B_5F71_51B2_950B(variable)
    local ctx = variable
    if ctx == nil or ctx["已启动"] ~= true then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not IsUnitAliveBJ(caster) then
        _____7ED3_675FE_8FDE_643A_5206_652F(ctx)
        return
    end
    if ctx["冲锋Tick数"] >= _____914D_7F6E.E["连携"]["最大推进次数"] then
        _____7ED3_675FE_8FDE_643A_5206_652F(ctx)
        return
    end
    ctx["冲锋Tick数"] = ctx["冲锋Tick数"] + 1
    local target = ctx["目标"]
    local _____76EE_6807_5B58_6D3B = target ~= nil and target ~= 0 and IsUnitAliveBJ(target)
    local tx = _____76EE_6807_5B58_6D3B and GetUnitX(target) or 0
    local ty = _____76EE_6807_5B58_6D3B and GetUnitY(target) or 0
    do
        local i = 0
        while i < #ctx["幻影列表"] do
            local phantom = ctx["幻影列表"][i + 1]
            local rad = phantom["面向角度"] * bj_DEGTORAD
            phantom.X = phantom.X + Cos(rad) * _____914D_7F6E.E["连携"]["每Tick距离"]
            phantom.Y = phantom.Y + Sin(rad) * _____914D_7F6E.E["连携"]["每Tick距离"]
            if phantom["特效"] ~= nil and phantom["特效"] ~= 0 then
                japi.DzSetEffectPos(phantom["特效"], phantom.X, phantom.Y, _____914D_7F6E.E["连携"]["幻影高度"])
            end
            if not phantom["已命中"] and _____76EE_6807_5B58_6D3B then
                local dx = phantom.X - tx
                local dy = phantom.Y - ty
                if SquareRoot(dx * dx + dy * dy) <= _____914D_7F6E.E["连携"]["命中判定半径"] then
                    _____7ED3_7B97E_5E7B_5F71_547D_4E2D(ctx, phantom)
                end
            end
            i = i + 1
        end
    end
end
local function ____E_8FDE_643A_8D77_624B_51B2_950B(variable)
    local ctx = variable
    if ctx == nil or ctx["已启动"] ~= true then
        return
    end
    do
        local i = 0
        while i < #ctx["幻影列表"] do
            local phantom = ctx["幻影列表"][i + 1]
            if phantom["特效"] ~= nil and phantom["特效"] ~= 0 then
                DzSetEffectAnimation(phantom["特效"], _____914D_7F6E.E["连携"]["幻影施法动画索引"], 0)
            end
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = _____914D_7F6E.E["连携"]["起手特效"]["模型"],
                X = phantom.X,
                Y = phantom.Y,
                Z = 0,
                ["面向角度"] = 270,
                ["缩放"] = _____914D_7F6E.E["连携"]["起手特效"]["缩放"],
                ["持续秒"] = _____914D_7F6E.E["连携"]["起手特效"]["持续秒"]
            })
            i = i + 1
        end
    end
    ctx["冲锋Tick数"] = 0
    ctx["冲锋回调ID"] = addPeriodicCallback(
        math.floor(_____914D_7F6E.E["连携"]["推进间隔秒"] * 1000 + 0.5),
        _____63A8_8FDBE_5E7B_5F71_51B2_950B,
        ctx
    )
end
local function _____9009_53D6E_8FDE_643A_76EE_6807(caster, x, y)
    local _____654C_519B = _____83B7_53D6_8303_56F4_654C_519B(caster, x, y, _____914D_7F6E.E["连携"]["目标选取半径"])
    local target = nil
    local _____6700_8FD1_8DDD_79BB = -1
    if _____654C_519B ~= nil then
        do
            local i = 0
            while i < #_____654C_519B do
                do
                    local u = _____654C_519B[i + 1]
                    if u == nil or u == 0 then
                        goto __continue51
                    end
                    local dx = GetUnitX(u) - x
                    local dy = GetUnitY(u) - y
                    local dist = dx * dx + dy * dy
                    if _____6700_8FD1_8DDD_79BB < 0 or dist < _____6700_8FD1_8DDD_79BB then
                        _____6700_8FD1_8DDD_79BB = dist
                        target = u
                    end
                end
                ::__continue51::
                i = i + 1
            end
        end
    end
    return target
end
local function _____91CA_653E_77AC_6B65_65A9(context, caster, _____6280_80FD_5B9E_4F8BID)
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    Sound3DII_CooPlayPool4MultiInstanceRare(
        _____914D_7F6E.E["音效"]["路径"],
        x,
        y,
        0,
        _____914D_7F6E.E["音效"]["裁断距离"]
    )
    Sound3DII_CooPlayPool4MultiInstanceRare(
        _____914D_7F6E.E["金属音效"]["路径"],
        x,
        y,
        0,
        _____914D_7F6E.E["金属音效"]["裁断距离"]
    )
    context["施法者"] = caster
    context["已启动"] = true
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["攻击力快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    context["普通Tick数"] = 0
    context["冲锋Tick数"] = 0
    context["幻影列表"] = {}
    context["目标"] = nil
    local _____8FDE_643A_76EE_6807 = nil
    if _____662F_5426_77AC_6B65_8FDE_643A_4E2D(caster) then
        _____5173_95ED_77AC_6B65_8FDE_643A(caster)
        _____8FDE_643A_76EE_6807 = _____9009_53D6E_8FDE_643A_76EE_6807(caster, x, y)
    end
    ShowUnit(caster, false)
    context["视野马甲"] = CreateUnit(
        GetOwningPlayer(caster),
        _____89C6_91CE_9A6C_7532_7C7B_578BID,
        x,
        y,
        0
    )
    UnitApplyTimedLife(context["视野马甲"], _____5B9A_65F6_751F_547DBuffID, 2.5)
    if _____8FDE_643A_76EE_6807 ~= nil and _____8FDE_643A_76EE_6807 ~= 0 then
        local target = _____8FDE_643A_76EE_6807
        context["目标"] = target
        _____65BD_52A0_7729_6655(
            caster,
            target,
            _____914D_7F6E.E["连携"]["起手眩晕秒"],
            "黑崎一护-瞬步斩",
            "技能"
        )
        registerManualBuff(target, _____9ED1_5D0E_4E00_62A4BuffID["瞬步斩眩晕"], _____914D_7F6E.E["连携"]["起手眩晕秒"], 0)
        local _____76EE_6807X = GetUnitX(target)
        local _____76EE_6807Y = GetUnitY(target)
        do
            local i = 1
            while i <= _____914D_7F6E.E["连携"]["幻影数量"] do
                local deg = 60 * i
                local rad = deg * bj_DEGTORAD
                local px = x + Cos(rad) * _____914D_7F6E.E["连携"]["幻影半径"]
                local py = y + Sin(rad) * _____914D_7F6E.E["连携"]["幻影半径"]
                local faceDeg = Atan2(_____76EE_6807Y - py, _____76EE_6807X - px) * bj_RADTODEG
                local effect = _____521B_5EFA_70B9_7279_6548({
                    ["模型路径"] = _____914D_7F6E.E["连携"]["幻影模型"],
                    X = px,
                    Y = py,
                    Z = _____914D_7F6E.E["连携"]["幻影高度"],
                    ["面向角度"] = faceDeg,
                    ["缩放"] = _____914D_7F6E.E["连携"]["幻影缩放"],
                    ["透明度"] = _____914D_7F6E.E["连携"]["幻影透明度"]
                })
                local ____context__5E7B_5F71_5217_8868_10 = context["幻影列表"]
                ____context__5E7B_5F71_5217_8868_10[#____context__5E7B_5F71_5217_8868_10 + 1] = {
                    X = px,
                    Y = py,
                    ["面向角度"] = faceDeg,
                    ["特效"] = effect,
                    ["已命中"] = false
                }
                i = i + 1
            end
        end
        addDelayedCallback(
            math.floor(_____914D_7F6E.E["连携"]["冲锋延迟秒"] * 1000 + 0.5),
            ____E_8FDE_643A_8D77_624B_51B2_950B,
            context
        )
    else
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = "war3mapImported\\dustwaveanimate.mdl",
            X = x,
            Y = y,
            Z = 0,
            ["面向角度"] = GetRandomReal(1, 360),
            ["缩放"] = 2,
            ["动画速度"] = 2.5,
            ["持续秒"] = 1.2
        })
        context["普通回调ID"] = addPeriodicCallback(
            math.floor(_____914D_7F6E.E["普通"]["斩击间隔秒"] * 1000 + 0.5),
            _____63A8_8FDBE_666E_901A_65A9_51FB,
            context
        )
    end
end
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function ____E_5355_4F4D_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    if jass.GetUnitTypeId(dyingUnit) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    local ctx = ____E_4E0A_4E0B_6587_8868[GetHandleId(dyingUnit)]
    if ctx == nil or ctx["已启动"] ~= true then
        return
    end
    if ctx["普通回调ID"] ~= 0 then
        removePeriodicCallback(ctx["普通回调ID"])
    end
    if ctx["冲锋回调ID"] ~= 0 then
        removePeriodicCallback(ctx["冲锋回调ID"])
    end
    ctx["普通回调ID"] = 0
    ctx["冲锋回调ID"] = 0
    ctx["已启动"] = false
    _____6E05_7406E_5E7B_5F71(ctx)
    if ctx["视野马甲"] ~= nil and ctx["视野马甲"] ~= 0 then
        jass.RemoveUnit(ctx["视野马甲"])
        ctx["视野马甲"] = nil
    end
end
____exports["注册黑崎一护E"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "黑崎一护-瞬步斩（E）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.E["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAE_4E0A_4E0B_6587,
        ["可释放"] = ____E_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653E_77AC_6B65_65A9,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 4
    })
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____E_5355_4F4D_6B7B_4EA1_6E05_7406)
    end
end
____exports["注册黑崎一护E"]()
return ____exports
