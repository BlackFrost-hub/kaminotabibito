--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____64A4_9500R_654F_6377, ____R_654F_6377_56DE_6536, ModifyHeroStat, bj_HEROSTAT_AGI, bj_MODIFYMETHOD_SUB
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.18．云端.00．配置")
local _____4E91_7AEF_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["云端技能配置"]
local ____18_FF0E_4E91_7AEF = require("系统.05．Buff系统.03．Buff表.02．英雄.18．云端")
local _____4E91_7AEFBuffID = ____18_FF0E_4E91_7AEF["云端BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local _____8DDD_79BBXY = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["距离XY"]
local ____24_FF0E_6574_6570_4E0E_65F6_95F4_6362_7B97 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算")
local _____79D2_8F6C_6BEB_79D2 = ____24_FF0E_6574_6570_4E0E_65F6_95F4_6362_7B97["秒转毫秒"]
function _____64A4_9500R_654F_6377(ctx)
    if ctx["敏捷已撤销"] then
        return
    end
    ctx["敏捷已撤销"] = true
    local caster = ctx["施法者"]
    if caster ~= nil and caster ~= 0 then
        ModifyHeroStat(bj_HEROSTAT_AGI, caster, bj_MODIFYMETHOD_SUB, ctx["敏捷增量"])
    end
end
function ____R_654F_6377_56DE_6536(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    _____64A4_9500R_654F_6377(ctx)
end
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_1["开始冲锋"]
local ____ = _____5F00_59CB_51B2_950B
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.冲锋残影表现")
local _____5F00_59CB_51B2_950B_5E76_9644_5E26_6B8B_5F71_8868_73B0 = ____require_result_2["开始冲锋并附带残影表现"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.03．对外接口")
local _____5F00_59CB_8DF3_8DC3 = ____require_result_3["开始跳跃"]
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_4["造成单体技能伤害"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_5["施加眩晕"]
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_6.registerManualBuff
local ____require_result_7 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local GS_Suspend = ____require_result_7.GS_Suspend
local ____require_result_8 = require("lib.扩展函数.BJ函数.02．单位与英雄")
ModifyHeroStat = ____require_result_8.ModifyHeroStat
local IsUnitAliveBJ = ____require_result_8.IsUnitAliveBJ
local ____require_result_9 = require("lib.扩展函数.BJ函数.07．杂项")
local GetRandomDirectionDeg = ____require_result_9.GetRandomDirectionDeg
local SetCameraTargetControllerNoZForPlayer = ____require_result_9.SetCameraTargetControllerNoZForPlayer
local SetCameraFieldForPlayer = ____require_result_9.SetCameraFieldForPlayer
local ResetToGameCameraForPlayer = ____require_result_9.ResetToGameCameraForPlayer
local ____require_result_10 = require("lib.扩展函数.封装函数.07．镜头函数.01．镜头震动")
local CameraSetEQNoiseForPlayer = ____require_result_10.CameraSetEQNoiseForPlayer
local CameraClearNoiseForPlayer = ____require_result_10.CameraClearNoiseForPlayer
local ____require_result_11 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundOnUnitBJ = ____require_result_11.PlaySoundOnUnitBJ
local ____require_result_12 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_12["创建点特效"]
local ____require_result_13 = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字")
local CreateFloatTextOnUnit = ____require_result_13.CreateFloatTextOnUnit
local ____require_result_14 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_14.registerDeathListener
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitFacing = jass.GetUnitFacing
local GetHeroAgi = jass.GetHeroAgi
local GetOwningPlayer = jass.GetOwningPlayer
local GetLocalPlayer = jass.GetLocalPlayer
local Player = jass.Player
local PauseUnit = jass.PauseUnit
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitAnimation = jass.SetUnitAnimation
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
local bj_DEGTORAD = jass.bj_DEGTORAD
local CAMERA_FIELD_TARGET_DISTANCE = jass.CAMERA_FIELD_TARGET_DISTANCE
local CAMERA_FIELD_FARZ = jass.CAMERA_FIELD_FARZ
local CAMERA_FIELD_ANGLE_OF_ATTACK = jass.CAMERA_FIELD_ANGLE_OF_ATTACK
local CAMERA_FIELD_FIELD_OF_VIEW = jass.CAMERA_FIELD_FIELD_OF_VIEW
local CAMERA_FIELD_ROLL = jass.CAMERA_FIELD_ROLL
local CAMERA_FIELD_ROTATION = jass.CAMERA_FIELD_ROTATION
local CAMERA_FIELD_ZOFFSET = jass.CAMERA_FIELD_ZOFFSET
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH
bj_HEROSTAT_AGI = jass.bj_HEROSTAT_AGI
local bj_MODIFYMETHOD_ADD = jass.bj_MODIFYMETHOD_ADD
bj_MODIFYMETHOD_SUB = jass.bj_MODIFYMETHOD_SUB
local ____require_result_15 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_15.stringToFourCCSafe
local _____914D_7F6E = _____4E91_7AEF_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____R_7C7B_578BID = stringToFourCCSafe(_____914D_7F6E.R["技能ID"])
local _____98DE_884C_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____914D_7F6E.R["飞行技能ID"])
local ____R_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAR_4E0A_4E0B_6587(unit)
    local id = GetHandleId(unit)
    local ctx = ____R_4E0A_4E0B_6587_8868[id]
    if ctx == nil then
        ctx = {
            ["施法者"] = unit,
            ["目标"] = nil,
            ["伤害快照"] = 0,
            ["敏捷增量"] = 0,
            ["敏捷已撤销"] = false,
            ["升空回调ID"] = 0,
            SS = 0,
            ["已清理"] = false
        }
        ____R_4E0A_4E0B_6587_8868[id] = ctx
    end
    return ctx
end
local function ____R_53EF_91CA_653E(context, _caster)
    return context["已清理"] ~= false or context["升空回调ID"] == 0
end
local function _____5168_5458_9707_5C4FR(_____5F3A_5EA6)
    do
        local i = 0
        while i < 10 do
            CameraSetEQNoiseForPlayer(
                Player(i),
                _____5F3A_5EA6
            )
            i = i + 1
        end
    end
end
local function _____5168_5458_6E05_9664_9707_5C4FR(_variable)
    do
        local i = 0
        while i < 10 do
            CameraClearNoiseForPlayer(Player(i))
            i = i + 1
        end
    end
end
local function _____6062_590DR_53CC_65B9_72B6_6001(ctx)
    local caster = ctx["施法者"]
    local target = ctx["目标"]
    if caster ~= nil and caster ~= 0 then
        GS_Suspend(caster, 0)
        SetUnitInvulnerable(caster, false)
        SetUnitTimeScale(caster, 1)
    end
    if target ~= nil and target ~= 0 then
        PauseUnit(target, false)
        SetUnitInvulnerable(target, false)
        SetUnitFlyHeight(target, 0, 0)
    end
end
--- 全阶段统一清理（死亡/目标失效/正常结束共用,计划第 11 节）。
local function _____6E05_7406R_5168_90E8(ctx, _____64A4_9500_654F_6377)
    if ctx["已清理"] then
        return
    end
    ctx["已清理"] = true
    if ctx["升空回调ID"] ~= 0 then
        removePeriodicCallback(ctx["升空回调ID"])
    end
    ctx["升空回调ID"] = 0
    _____6062_590DR_53CC_65B9_72B6_6001(ctx)
    if _____64A4_9500_654F_6377 then
        _____64A4_9500R_654F_6377(ctx)
    end
    local caster = ctx["施法者"]
    if caster ~= nil and caster ~= 0 then
        local owner = GetOwningPlayer(caster)
        if GetLocalPlayer() == owner then
            ResetToGameCameraForPlayer(owner, 0.5)
            SetCameraFieldForPlayer(owner, CAMERA_FIELD_TARGET_DISTANCE, 3600, 0.5)
        end
    end
    _____5168_5458_6E05_9664_9707_5C4FR(nil)
end
local function ____R_7ED3_7B97(variable)
    local ctx = variable
    if ctx == nil or ctx["已清理"] then
        return
    end
    local caster = ctx["施法者"]
    local target = ctx["目标"]
    local _____76EE_6807_6709_6548 = target ~= nil and target ~= 0 and IsUnitAliveBJ(target)
    ctx["已清理"] = true
    if ctx["升空回调ID"] ~= 0 then
        removePeriodicCallback(ctx["升空回调ID"])
    end
    ctx["升空回调ID"] = 0
    _____6062_590DR_53CC_65B9_72B6_6001(ctx)
    if caster ~= nil and caster ~= 0 and IsUnitAliveBJ(caster) and _____76EE_6807_6709_6548 then
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = caster,
            ["目标"] = target,
            ["伤害"] = ctx["伤害快照"],
            ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
            attack = false,
            attackType = ATTACK_TYPE_NORMAL,
            weaponType = WEAPON_TYPE_METAL_HEAVY_BASH,
            ["来源类型"] = "单位技能",
            ["标签"] = "云端-R暗黑制裁",
            ["技能ID"] = ____R_7C7B_578BID,
            ["技能实例ID"] = ctx["技能实例ID"]
        })
        _____65BD_52A0_7729_6655(
            caster,
            target,
            _____914D_7F6E.R["眩晕秒"],
            "云端-暗黑制裁",
            "技能"
        )
        registerManualBuff(target, _____4E91_7AEFBuffID["暗黑制裁眩晕"], _____914D_7F6E.R["眩晕秒"], 0)
    end
    if caster ~= nil and caster ~= 0 then
        local owner = GetOwningPlayer(caster)
        if GetLocalPlayer() == owner then
            ResetToGameCameraForPlayer(owner, 0.5)
            SetCameraFieldForPlayer(owner, CAMERA_FIELD_TARGET_DISTANCE, 3600, 0.5)
        end
    end
    _____5168_5458_6E05_9664_9707_5C4FR(nil)
    addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2(_____914D_7F6E.R["阶段"]["敏捷保留秒"]),
        ____R_654F_6377_56DE_6536,
        ctx
    )
end
local function ____R_5760_843D_8868_73B0(ctx)
    local target = ctx["目标"]
    local tx = GetUnitX(target)
    local ty = GetUnitY(target)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.R["坠落"]["表现模型"],
        X = tx,
        Y = ty,
        Z = _____914D_7F6E.R["坠落"]["表现高度"],
        ["面向角度"] = GetRandomDirectionDeg(),
        ["缩放"] = _____914D_7F6E.R["坠落"]["表现缩放"],
        ["持续秒"] = _____914D_7F6E.R["坠落"]["表现持续秒"]
    })
    _____5F00_59CB_8DF3_8DC3(
        target,
        {
            ["角度"] = GetRandomDirectionDeg(),
            ["距离"] = _____914D_7F6E.R["坠落"]["跳跃"]["距离"],
            ["持续时间"] = _____914D_7F6E.R["坠落"]["跳跃"]["持续时间秒"],
            ["跳跃高度"] = _____914D_7F6E.R["坠落"]["跳跃"]["跳跃高度"]
        }
    )
    _____5168_5458_9707_5C4FR(_____914D_7F6E.R["坠落"]["震屏强度"])
    addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2(_____914D_7F6E.R["阶段"]["结算延迟秒"]),
        ____R_7ED3_7B97,
        ctx
    )
end
local function _____63A8_8FDBR_5347_7A7A(variable)
    local ctx = variable
    if ctx == nil or ctx["已清理"] then
        return
    end
    local caster = ctx["施法者"]
    local target = ctx["目标"]
    if caster == nil or caster == 0 or not IsUnitAliveBJ(caster) then
        _____6E05_7406R_5168_90E8(ctx, true)
        return
    end
    if target == nil or target == 0 or not IsUnitAliveBJ(target) then
        _____6E05_7406R_5168_90E8(ctx, true)
        return
    end
    if ctx.SS >= _____914D_7F6E.R["升空"]["最大Tick数"] then
        if ctx["升空回调ID"] ~= 0 then
            removePeriodicCallback(ctx["升空回调ID"])
        end
        ctx["升空回调ID"] = 0
        ____R_5760_843D_8868_73B0(ctx)
        return
    end
    ctx.SS = ctx.SS + 1
    local tx = GetUnitX(target)
    local ty = GetUnitY(target)
    SetUnitAnimation(target, "Death")
    SetUnitFlyHeight(target, _____914D_7F6E.R["升空"]["每Tick高度"] * ctx.SS, 0)
    local owner = GetOwningPlayer(caster)
    if GetLocalPlayer() == owner then
        SetCameraFieldForPlayer(owner, CAMERA_FIELD_ZOFFSET, _____914D_7F6E.R["升空"]["每Tick高度"] * ctx.SS, 0)
    end
    do
        local i = 0
        while i < #_____914D_7F6E.R["升空"]["特效"] do
            local p = _____914D_7F6E.R["升空"]["特效"][i + 1]
            local z = p["跟随SS"] == true and _____914D_7F6E.R["升空"]["特效基础高度"] * ctx.SS or p["高度"]
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = p["模型"],
                X = tx,
                Y = ty,
                Z = z,
                ["面向角度"] = 270,
                ["缩放"] = p["缩放"],
                ["持续秒"] = p["持续秒"]
            })
            i = i + 1
        end
    end
end
local function ____R_5347_7A7A_51C6_5907(variable)
    local ctx = variable
    if ctx == nil or ctx["已清理"] then
        return
    end
    local caster = ctx["施法者"]
    local target = ctx["目标"]
    if caster == nil or caster == 0 or not IsUnitAliveBJ(caster) then
        _____6E05_7406R_5168_90E8(ctx, true)
        return
    end
    if target == nil or target == 0 or not IsUnitAliveBJ(target) then
        _____6E05_7406R_5168_90E8(ctx, true)
        return
    end
    PauseUnit(target, true)
    SetUnitInvulnerable(target, true)
    SetUnitTimeScale(caster, 1)
    SetUnitAnimation(caster, "Stand Cinematic")
    local owner = GetOwningPlayer(caster)
    if GetLocalPlayer() == owner then
        SetCameraFieldForPlayer(owner, CAMERA_FIELD_TARGET_DISTANCE, 1500, 1)
        SetCameraFieldForPlayer(owner, CAMERA_FIELD_ANGLE_OF_ATTACK, 335, 1)
        SetCameraFieldForPlayer(
            owner,
            CAMERA_FIELD_ROTATION,
            108 * bj_DEGTORAD + GetUnitFacing(caster) * bj_DEGTORAD,
            1
        )
        SetCameraFieldForPlayer(owner, CAMERA_FIELD_FIELD_OF_VIEW, 50, 1)
    end
    UnitAddAbility(target, _____98DE_884C_6280_80FD_7C7B_578BID)
    UnitRemoveAbility(target, _____98DE_884C_6280_80FD_7C7B_578BID)
    _____5168_5458_9707_5C4FR(_____914D_7F6E.R["升空"]["震屏强度"])
    ctx.SS = 0
    ctx["升空回调ID"] = addPeriodicCallback(
        _____79D2_8F6C_6BEB_79D2(_____914D_7F6E.R["升空"]["Tick间隔秒"]),
        _____63A8_8FDBR_5347_7A7A,
        ctx
    )
end
local function ____R_7B2C_4E8C_6BB5_51B2_523A(variable)
    local ctx = variable
    if ctx == nil or ctx["已清理"] then
        return
    end
    local caster = ctx["施法者"]
    local target = ctx["目标"]
    if caster == nil or caster == 0 or not IsUnitAliveBJ(caster) or target == nil or target == 0 or not IsUnitAliveBJ(target) then
        _____6E05_7406R_5168_90E8(ctx, true)
        return
    end
    PauseUnit(target, true)
    SetUnitInvulnerable(target, true)
    local _____5B9E_65F6_8DDD_79BB = _____8DDD_79BBXY(
        GetUnitX(caster),
        GetUnitY(caster),
        GetUnitX(target),
        GetUnitY(target)
    )
    local _____89D2_5EA6 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(caster),
        GetUnitY(caster),
        GetUnitX(target),
        GetUnitY(target)
    )
    _____5F00_59CB_51B2_950B_5E76_9644_5E26_6B8B_5F71_8868_73B0(caster, {
        ["角度"] = _____89D2_5EA6,
        ["距离"] = _____914D_7F6E.R["冲刺"]["第二段"]["基础距离"] + _____5B9E_65F6_8DDD_79BB,
        ["持续时间"] = _____914D_7F6E.R["冲刺"]["第二段"]["持续时间秒"],
        ["检查地形"] = true,
        ["禁用碰撞"] = true
    }, {["残影模型"] = _____914D_7F6E.R["冲刺"]["尾迹模型"], ["动画名"] = _____914D_7F6E.R["冲刺"]["动作名"], ["动画速度"] = _____914D_7F6E.R["冲刺"]["第一段流速"]})
    addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2(_____914D_7F6E.R["阶段"]["升空准备延迟秒"]),
        ____R_5347_7A7A_51C6_5907,
        ctx
    )
end
local function ____R_7B2C_4E00_6BB5_51B2_523A(variable)
    local ctx = variable
    if ctx == nil or ctx["已清理"] then
        return
    end
    local caster = ctx["施法者"]
    local target = ctx["目标"]
    if caster == nil or caster == 0 or not IsUnitAliveBJ(caster) or target == nil or target == 0 or not IsUnitAliveBJ(target) then
        _____6E05_7406R_5168_90E8(ctx, true)
        return
    end
    PauseUnit(target, true)
    SetUnitInvulnerable(target, true)
    local _____89D2_5EA6 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(target),
        GetUnitY(target),
        GetUnitX(caster),
        GetUnitY(caster)
    )
    _____5F00_59CB_51B2_950B_5E76_9644_5E26_6B8B_5F71_8868_73B0(caster, {
        ["角度"] = _____89D2_5EA6,
        ["距离"] = _____914D_7F6E.R["冲刺"]["第一段"]["距离"],
        ["持续时间"] = _____914D_7F6E.R["冲刺"]["第一段"]["持续时间秒"],
        ["检查地形"] = true,
        ["禁用碰撞"] = true
    }, {["残影模型"] = _____914D_7F6E.R["冲刺"]["尾迹模型"], ["动画名"] = _____914D_7F6E.R["冲刺"]["动作名"], ["动画速度"] = _____914D_7F6E.R["冲刺"]["第一段流速"]})
    addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2(_____914D_7F6E.R["阶段"]["第二段延迟秒"]),
        ____R_7B2C_4E8C_6BB5_51B2_523A,
        ctx
    )
end
local function _____91CA_653ER_6697_9ED1_5236_88C1(context, caster, _____6280_80FD_5B9E_4F8BID)
    local target = GetSpellTargetUnit()
    if target == nil or target == 0 then
        return
    end
    local _____7B49_7EA7 = GetUnitAbilityLevel(caster, ____R_7C7B_578BID)
    local _____4F24_5BB3_5FEB_7167 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * (_____914D_7F6E.R["伤害公式"]["基础倍率"] + _____914D_7F6E.R["伤害公式"]["每级加成"] * _____7B49_7EA7)
    local _____654F_6377_589E_91CF = GetHeroAgi(caster, false)
    context["施法者"] = caster
    context["目标"] = target
    context["伤害快照"] = _____4F24_5BB3_5FEB_7167
    context["敏捷增量"] = _____654F_6377_589E_91CF
    context["敏捷已撤销"] = false
    context["升空回调ID"] = 0
    context.SS = 0
    context["已清理"] = false
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    GS_Suspend(caster, _____914D_7F6E.R["硬直秒"])
    SetUnitInvulnerable(caster, true)
    PauseUnit(target, true)
    SetUnitInvulnerable(target, true)
    ModifyHeroStat(bj_HEROSTAT_AGI, caster, bj_MODIFYMETHOD_ADD, _____654F_6377_589E_91CF)
    registerManualBuff(caster, _____4E91_7AEFBuffID["暗黑敏捷翻倍"], _____914D_7F6E.R["硬直秒"] + 1.75 + 1.25 + _____914D_7F6E.R["阶段"]["结算延迟秒"] + _____914D_7F6E.R["阶段"]["敏捷保留秒"], _____654F_6377_589E_91CF)
    SetUnitTimeScale(caster, 1)
    SetUnitAnimation(caster, _____914D_7F6E.R["起手动作名"])
    CreateFloatTextOnUnit(caster, _____914D_7F6E.R["起手漂浮字"]["文本"], {
        size = _____914D_7F6E.R["起手漂浮字"]["尺寸"],
        red = 0,
        green = 0,
        blue = 255,
        alpha = _____914D_7F6E.R["起手漂浮字"]["透明度"],
        duration = _____914D_7F6E.R["起手漂浮字"]["持续秒"],
        speedY = _____914D_7F6E.R["起手漂浮字"]["上浮速度"],
        height = _____914D_7F6E.R["起手漂浮字"]["高度"]
    })
    local owner = GetOwningPlayer(caster)
    if GetLocalPlayer() == owner then
        SetCameraTargetControllerNoZForPlayer(
            owner,
            caster,
            0,
            0,
            false
        )
        SetCameraFieldForPlayer(owner, CAMERA_FIELD_TARGET_DISTANCE, 2000, 1)
        SetCameraFieldForPlayer(owner, CAMERA_FIELD_FARZ, 10000, 0)
        SetCameraFieldForPlayer(owner, CAMERA_FIELD_ANGLE_OF_ATTACK, 345, 1)
        SetCameraFieldForPlayer(owner, CAMERA_FIELD_FIELD_OF_VIEW, 30, 1)
        SetCameraFieldForPlayer(owner, CAMERA_FIELD_ROLL, 0, 0)
        SetCameraFieldForPlayer(
            owner,
            CAMERA_FIELD_ROTATION,
            90 * bj_DEGTORAD + GetUnitFacing(caster) * bj_DEGTORAD,
            1
        )
        SetCameraFieldForPlayer(owner, CAMERA_FIELD_ZOFFSET, 100, 0)
    end
    local ____r_97F3_6548_53E5_67C4 = jglobals[_____914D_7F6E.R["起手音效"]["全局音效键"]]
    if ____r_97F3_6548_53E5_67C4 ~= nil then
        PlaySoundOnUnitBJ(____r_97F3_6548_53E5_67C4, 100, caster)
    end
    addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2(_____914D_7F6E.R["阶段"]["第一段延迟秒"]),
        ____R_7B2C_4E00_6BB5_51B2_523A,
        context
    )
end
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function ____R_5355_4F4D_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    if jass.GetUnitTypeId(dyingUnit) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    local ctx = ____R_4E0A_4E0B_6587_8868[GetHandleId(dyingUnit)]
    if ctx == nil or ctx["已清理"] then
        return
    end
    _____6E05_7406R_5168_90E8(ctx, true)
end
____exports["注册云端R"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "云端-暗黑制裁魔剑（R）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.R["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAR_4E0A_4E0B_6587,
        ["可释放"] = ____R_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653ER_6697_9ED1_5236_88C1,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 12
    })
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____R_5355_4F4D_6B7B_4EA1_6E05_7406)
    end
end
____exports["注册云端R"]()
return ____exports
