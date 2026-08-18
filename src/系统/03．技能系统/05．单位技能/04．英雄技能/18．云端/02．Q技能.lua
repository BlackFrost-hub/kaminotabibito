--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local CosDeg, SinDeg, ____Q_94FA_62D6_5C3E, _____521B_5EFA_70B9_7279_6548, Cos, Sin, bj_DEGTORAD
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.18．云端.00．配置")
local _____4E91_7AEF_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["云端技能配置"]
local ____18_FF0E_4E91_7AEF = require("系统.05．Buff系统.03．Buff表.02．英雄.18．云端")
local _____4E91_7AEFBuffID = ____18_FF0E_4E91_7AEF["云端BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
function CosDeg(_____89D2_5EA6)
    return Cos(_____89D2_5EA6 * bj_DEGTORAD)
end
function SinDeg(_____89D2_5EA6)
    return Sin(_____89D2_5EA6 * bj_DEGTORAD)
end
function ____Q_94FA_62D6_5C3E(variable)
    local p = variable
    if p == nil then
        return
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = p["模型"],
        X = p.X,
        Y = p.Y,
        Z = p["高度"],
        ["面向角度"] = 270,
        ["缩放"] = p["缩放"],
        ["持续秒"] = p["持续秒"]
    })
end
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_2["开始冲锋"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.03．对外接口")
local _____5F00_59CB_8DF3_8DC3 = ____require_result_3["开始跳跃"]
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_4["造成单体技能伤害"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_51CF_901F = ____require_result_5["施加减速"]
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_6.registerManualBuff
local ____require_result_7 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local GS_Suspend = ____require_result_7.GS_Suspend
local ____require_result_8 = require("lib.扩展函数.封装函数.07．镜头函数.01．镜头震动")
local CameraSetEQNoiseForPlayer = ____require_result_8.CameraSetEQNoiseForPlayer
local CameraClearNoiseForPlayer = ____require_result_8.CameraClearNoiseForPlayer
local ____require_result_9 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundOnUnitBJ = ____require_result_9.PlaySoundOnUnitBJ
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_10["创建点特效"]
local ____require_result_11 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedUnitEffect = ____require_result_11.createTimedUnitEffect
local ____require_result_12 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_12.IsUnitAliveBJ
local ____require_result_13 = require("lib.扩展函数.BJ函数.07．杂项")
local GetRandomDirectionDeg = ____require_result_13.GetRandomDirectionDeg
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetRandomInt = jass.GetRandomInt
local GetOwningPlayer = jass.GetOwningPlayer
local GetLocalPlayer = jass.GetLocalPlayer
local Player = jass.Player
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local SetUnitAnimation = jass.SetUnitAnimation
local SquareRoot = jass.SquareRoot
local Atan2 = jass.Atan2
local bj_RADTODEG = jass.bj_RADTODEG
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
local WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH
local ____require_result_14 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_14.stringToFourCCSafe
local _____914D_7F6E = _____4E91_7AEF_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____Q_7C7B_578BID = stringToFourCCSafe(_____914D_7F6E.Q["技能ID"])
local ____Q_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAQ_4E0A_4E0B_6587(unit)
    local id = GetHandleId(unit)
    local ctx = ____Q_4E0A_4E0B_6587_8868[id]
    if ctx == nil then
        ctx = {
            ["施法者"] = unit,
            ["目标"] = nil,
            ["分支"] = "火",
            ["伤害快照"] = 0,
            ["灼烧回调ID"] = 0,
            ["灼烧次数"] = 0,
            ["已启动"] = false
        }
        ____Q_4E0A_4E0B_6587_8868[id] = ctx
    end
    return ctx
end
local function ____Q_53EF_91CA_653E(context, _caster)
    return context["已启动"] ~= true
end
local function _____5168_5458_9707_5C4F(_____5F3A_5EA6)
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
local function _____5168_5458_6E05_9664_9707_5C4F(_variable)
    do
        local i = 0
        while i < 10 do
            CameraClearNoiseForPlayer(Player(i))
            i = i + 1
        end
    end
end
local function _____63A8_8FDBQ_707C_70E7(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    ctx["灼烧次数"] = ctx["灼烧次数"] + 1
    local caster = ctx["施法者"]
    local target = ctx["目标"]
    if ctx["灼烧次数"] > _____914D_7F6E.Q["火"]["灼烧"]["次数"] then
        if ctx["灼烧回调ID"] ~= 0 then
            removePeriodicCallback(ctx["灼烧回调ID"])
        end
        ctx["灼烧回调ID"] = 0
        debugLogForce(
            "云端Q",
            "灼烧-结束",
            "施法者",
            GetHandleId(caster),
            "次数",
            ctx["灼烧次数"],
            "技能实例ID",
            ctx["技能实例ID"]
        )
        return
    end
    if caster == nil or caster == 0 or not IsUnitAliveBJ(caster) then
        return
    end
    if target == nil or target == 0 or not IsUnitAliveBJ(target) then
        return
    end
    debugLogForce(
        "云端Q",
        "灼烧-结算",
        "施法者",
        GetHandleId(caster),
        "目标",
        GetHandleId(target),
        "次数",
        ctx["灼烧次数"],
        "伤害",
        ctx["伤害快照"] * _____914D_7F6E.Q["火"]["灼烧"]["单次比例"],
        "技能实例ID",
        ctx["技能实例ID"]
    )
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标"] = target,
        ["伤害"] = ctx["伤害快照"] * _____914D_7F6E.Q["火"]["灼烧"]["单次比例"],
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        attack = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_METAL_HEAVY_BASH,
        ["来源类型"] = "单位技能",
        ["标签"] = "云端-Q火剑灼烧",
        ["技能ID"] = ____Q_7C7B_578BID,
        ["技能实例ID"] = ctx["技能实例ID"]
    })
end
local function _____7ED3_7B97Q_547D_4E2D(ctx)
    debugLogForce(
        "云端Q",
        "命中结算",
        "施法者",
        GetHandleId(ctx["施法者"]),
        "分支",
        ctx["分支"],
        "技能实例ID",
        ctx["技能实例ID"]
    )
    local caster = ctx["施法者"]
    local target = ctx["目标"]
    GS_Suspend(caster, 0)
    SetUnitInvulnerable(caster, false)
    if target == nil or target == 0 or not IsUnitAliveBJ(target) then
        ctx["已启动"] = false
        debugLogForce(
            "云端Q",
            "命中结算-目标失效不结算",
            "目标",
            GetHandleId(target),
            "技能实例ID",
            ctx["技能实例ID"]
        )
        return
    end
    local tx = GetUnitX(target)
    local ty = GetUnitY(target)
    debugLogForce(
        "云端Q",
        "命中结算-目标有效",
        "目标",
        GetHandleId(target),
        "X",
        tx,
        "Y",
        ty,
        "伤害快照",
        ctx["伤害快照"],
        "技能实例ID",
        ctx["技能实例ID"]
    )
    if ctx["分支"] == "火" then
        local _____706B_97F3_6548_53E5_67C4 = jglobals[_____914D_7F6E.Q["火"]["音效"]["全局音效键"]]
        if _____706B_97F3_6548_53E5_67C4 ~= nil then
            PlaySoundOnUnitBJ(_____706B_97F3_6548_53E5_67C4, 100, caster)
        end
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____914D_7F6E.Q["火"]["命中特效"]["模型"],
            X = tx,
            Y = ty,
            Z = _____914D_7F6E.Q["火"]["命中特效"]["高度"],
            ["面向角度"] = 270,
            ["缩放"] = _____914D_7F6E.Q["火"]["命中特效"]["缩放"],
            ["持续秒"] = _____914D_7F6E.Q["火"]["命中特效"]["持续秒"]
        })
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = caster,
            ["目标"] = target,
            ["伤害"] = ctx["伤害快照"],
            ["伤害类型"] = DAMAGE_TYPE_FIRE,
            attack = false,
            attackType = ATTACK_TYPE_NORMAL,
            weaponType = WEAPON_TYPE_METAL_HEAVY_BASH,
            ["来源类型"] = "单位技能",
            ["标签"] = "云端-Q火剑",
            ["技能ID"] = ____Q_7C7B_578BID,
            ["技能实例ID"] = ctx["技能实例ID"]
        })
        _____5F00_59CB_8DF3_8DC3(
            target,
            {
                ["角度"] = GetRandomDirectionDeg(),
                ["距离"] = _____914D_7F6E.Q["目标跳跃"]["距离"],
                ["持续时间"] = _____914D_7F6E.Q["目标跳跃"]["持续时间秒"],
                ["跳跃高度"] = _____914D_7F6E.Q["目标跳跃"]["跳跃高度"]
            }
        )
        createTimedUnitEffect(target, "origin", _____914D_7F6E.Q["火"]["灼烧挂点模型"], _____914D_7F6E.Q["火"]["灼烧挂点持续秒"])
        registerManualBuff(target, _____4E91_7AEFBuffID["火剑灼烧"], _____914D_7F6E.Q["火"]["灼烧挂点持续秒"], 0)
        ctx["灼烧次数"] = 0
        ctx["灼烧回调ID"] = addPeriodicCallback(
            math.floor(_____914D_7F6E.Q["火"]["灼烧"]["间隔秒"] * 1000 + 0.5),
            _____63A8_8FDBQ_707C_70E7,
            ctx
        )
    else
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____914D_7F6E.Q["冰"]["命中特效"]["模型"],
            X = tx,
            Y = ty,
            Z = _____914D_7F6E.Q["冰"]["命中特效"]["高度"],
            ["面向角度"] = 270,
            ["缩放"] = _____914D_7F6E.Q["冰"]["命中特效"]["缩放"],
            ["持续秒"] = _____914D_7F6E.Q["冰"]["命中特效"]["持续秒"]
        })
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = caster,
            ["目标"] = target,
            ["伤害"] = ctx["伤害快照"],
            ["伤害类型"] = DAMAGE_TYPE_COLD,
            attack = false,
            attackType = ATTACK_TYPE_NORMAL,
            weaponType = WEAPON_TYPE_METAL_HEAVY_BASH,
            ["来源类型"] = "单位技能",
            ["标签"] = "云端-Q冰剑",
            ["技能ID"] = ____Q_7C7B_578BID,
            ["技能实例ID"] = ctx["技能实例ID"]
        })
        _____5F00_59CB_8DF3_8DC3(
            target,
            {
                ["角度"] = GetRandomDirectionDeg(),
                ["距离"] = _____914D_7F6E.Q["目标跳跃"]["距离"],
                ["持续时间"] = _____914D_7F6E.Q["目标跳跃"]["持续时间秒"],
                ["跳跃高度"] = _____914D_7F6E.Q["目标跳跃"]["跳跃高度"]
            }
        )
        _____65BD_52A0_51CF_901F(
            caster,
            target,
            _____914D_7F6E.Q["冰"]["减速比例"],
            _____914D_7F6E.Q["冰"]["减速持续秒"],
            "云端-冰剑",
            "技能"
        )
        registerManualBuff(target, _____4E91_7AEFBuffID["冰剑减速"], _____914D_7F6E.Q["冰"]["减速持续秒"], 0)
    end
    _____5168_5458_9707_5C4F(_____914D_7F6E.Q["摄像机震动强度"])
    addDelayedCallback(
        math.floor(_____914D_7F6E.Q["震动清除延迟秒"] * 1000 + 0.5),
        _____5168_5458_6E05_9664_9707_5C4F,
        nil
    )
    ctx["已启动"] = false
end
local function ____Q_51B2_950B_7ED3_675F(_____79FB_52A8_5355_4F4D, ______539F_56E0, ______4F4D_79FBID)
    local ctx = ____Q_4E0A_4E0B_6587_8868[GetHandleId(_____79FB_52A8_5355_4F4D)]
    if ctx == nil or ctx["已启动"] ~= true then
        return
    end
    _____7ED3_7B97Q_547D_4E2D(ctx)
end
local function _____91CA_653EQ_51B0_706B_9B54_5251(context, caster, _____6280_80FD_5B9E_4F8BID)
    debugLogForce(
        "云端Q",
        "入口-释放",
        "施法者",
        GetHandleId(caster),
        "技能ID",
        _____914D_7F6E.Q["技能ID"],
        "技能实例ID",
        _____6280_80FD_5B9E_4F8BID
    )
    local target = GetSpellTargetUnit()
    if target == nil or target == 0 then
        debugLogForce(
            "云端Q",
            "入口-目标无效返回",
            "施法者",
            GetHandleId(caster),
            "技能实例ID",
            _____6280_80FD_5B9E_4F8BID
        )
        return
    end
    local _____5206_652F = GetRandomInt(1, 2) == 1 and "火" or "冰"
    local _____7B49_7EA7 = GetUnitAbilityLevel(caster, ____Q_7C7B_578BID)
    local _____4F24_5BB3_5FEB_7167 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * (_____914D_7F6E.Q["伤害公式"]["基础倍率"] + _____914D_7F6E.Q["伤害公式"]["每级加成"] * _____7B49_7EA7)
    debugLogForce(
        "云端Q",
        "入口-锁存",
        "目标",
        GetHandleId(target),
        "分支",
        _____5206_652F,
        "等级",
        _____7B49_7EA7,
        "伤害快照",
        _____4F24_5BB3_5FEB_7167,
        "技能实例ID",
        _____6280_80FD_5B9E_4F8BID
    )
    context["施法者"] = caster
    context["目标"] = target
    context["分支"] = _____5206_652F
    context["伤害快照"] = _____4F24_5BB3_5FEB_7167
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["灼烧次数"] = 0
    context["已启动"] = true
    GS_Suspend(caster, _____914D_7F6E.Q["硬直秒"])
    SetUnitInvulnerable(caster, true)
    SetUnitAnimation(caster, _____914D_7F6E.Q["动作名"])
    local sx = GetUnitX(caster)
    local sy = GetUnitY(caster)
    local _____89D2_5EA6 = Atan2(
        GetUnitY(target) - sy,
        GetUnitX(target) - sx
    ) * bj_RADTODEG
    local _____989C_8272 = _____5206_652F == "火" and _____914D_7F6E.Q["火"]["颜色"] or _____914D_7F6E.Q["冰"]["颜色"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.Q["护场特效"]["模型"],
        X = sx,
        Y = sy,
        Z = 0,
        ["面向角度"] = _____89D2_5EA6,
        ["缩放"] = _____914D_7F6E.Q["护场特效"]["缩放"],
        ["持续秒"] = _____914D_7F6E.Q["护场特效"]["持续秒"],
        ["红"] = _____989C_8272["红"],
        ["绿"] = _____989C_8272["绿"],
        ["蓝"] = _____989C_8272["蓝"],
        ["透明度"] = _____989C_8272["透明度"]
    })
    local dx = GetUnitX(target) - sx
    local dy = GetUnitY(target) - sy
    local _____8DDD_79BB = SquareRoot(dx * dx + dy * dy) - _____914D_7F6E.Q["冲锋"]["命中距离码"]
    if _____8DDD_79BB <= 0 then
        _____7ED3_7B97Q_547D_4E2D(context)
        return
    end
    local _____901F_5EA6 = _____914D_7F6E.Q["冲锋"]["每Tick距离"] / _____914D_7F6E.Q["冲锋"]["Tick间隔秒"]
    local _____79FB_52A8_97F3_6548_53E5_67C4 = jglobals[_____914D_7F6E.Q["冲锋"]["移动音效"]["全局音效键"]]
    if _____79FB_52A8_97F3_6548_53E5_67C4 ~= nil then
        PlaySoundOnUnitBJ(_____79FB_52A8_97F3_6548_53E5_67C4, 100, caster)
    end
    _____5F00_59CB_51B2_950B(caster, {
        ["角度"] = _____89D2_5EA6,
        ["距离"] = _____8DDD_79BB,
        ["持续时间"] = _____8DDD_79BB / _____901F_5EA6,
        ["检查地形"] = true,
        ["禁用碰撞"] = true,
        ["动画序号"] = _____914D_7F6E.Q["冲锋"]["动作索引"],
        ["结束回调"] = ____Q_51B2_950B_7ED3_675F
    })
    local _____62D6_5C3E_53C2_6570 = _____5206_652F == "火" and _____914D_7F6E.Q["火"]["移动特效"] or _____914D_7F6E.Q["冰"]["移动特效"]
    local _____62D6_5C3E_6B21_6570 = math.floor(_____8DDD_79BB / _____914D_7F6E.Q["冲锋"]["每Tick距离"])
    do
        local i = 1
        while i <= _____62D6_5C3E_6B21_6570 do
            local px = sx + CosDeg(_____89D2_5EA6) * (i * _____914D_7F6E.Q["冲锋"]["每Tick距离"])
            local py = sy + SinDeg(_____89D2_5EA6) * (i * _____914D_7F6E.Q["冲锋"]["每Tick距离"])
            addDelayedCallback(
                math.floor(i * _____914D_7F6E.Q["冲锋"]["Tick间隔秒"] * 1000 + 0.5),
                ____Q_94FA_62D6_5C3E,
                {
                    ["模型"] = _____62D6_5C3E_53C2_6570["模型"],
                    X = px,
                    Y = py,
                    ["高度"] = _____62D6_5C3E_53C2_6570["高度"],
                    ["缩放"] = _____62D6_5C3E_53C2_6570["缩放"],
                    ["持续秒"] = _____62D6_5C3E_53C2_6570["持续秒"]
                }
            )
            i = i + 1
        end
    end
end
Cos = jass.Cos
Sin = jass.Sin
bj_DEGTORAD = jass.bj_DEGTORAD
____exports["注册云端Q"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "云端-冰火魔剑（Q）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.Q["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAQ_4E0A_4E0B_6587,
        ["可释放"] = ____Q_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653EQ_51B0_706B_9B54_5251,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 6
    })
end
____exports["注册云端Q"]()
return ____exports
