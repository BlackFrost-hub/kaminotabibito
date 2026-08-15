--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8BA1_7B97_4E24_70B9_89D2_5EA6, _____5728_524D_65B9_534A_5706, _____8FC7_6EE4Q_5288_780D_76EE_6807, _____8BA1_7B97_5200_5149_70B9, _____64AD_653E_5200_5149, _____6062_590DQ_76EE_6807_8868_73B0, _____5E94_7528Q_76EE_6807_547D_4E2D_8868_73B0, _____7ED3_7B97Q_524D_65B9_5288_780D, ____Q_521D_6BB5_7A97_53E3_590D_4F4D, _____6CBF_9762_5411_77AC_6B65, ____Q2_8FC7_6E21, ____Q2_7B2C_4E8C_6BB5_5288_780D, ____Q_8FDE_51FB2_7A97_53E3_590D_4F4D, _____63A8_8FDBQ3_4E0B_964D, ____Q3_8FC7_6E21, ____Q3_7B2C_4E8C_6BB5_5288_780D, ____Q3_590D_4F4D, jass, addDelayedCallback, addPeriodicCallback, removePeriodicCallback, _____5F00_59CB_51FB_9000, _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3, _____83B7_53D6_8303_56F4_654C_519B, _____65BD_52A0_7729_6655, registerManualBuff, _____79FB_9664_5355_4F4D_6682_505C, _____521B_5EFA_70B9_7279_6548, createTimedUnitEffect, GetUnitX, GetUnitY, GetUnitFacing, GetUnitFlyHeight, GetOwningPlayer, SetUnitTimeScale, SetUnitAnimationByIndex, SetUnitAnimation, ResetUnitAnimation, SetUnitTurnSpeed, SetUnitFlyHeight, SetPlayerAbilityAvailable, UnitAddAbility, UnitRemoveAbility, IsUnitType, IsUnitVisible, Atan2, Cos, Sin, bj_RADTODEG, bj_DEGTORAD, UNIT_TYPE_ANCIENT, UNIT_TYPE_MECHANICAL, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_METAL_HEAVY_BASH, EXSetUnitMoveType, _____914D_7F6E, ____Q_521D_6BB5ID, ____Q_8FDE_51FB2ID, ____Q_8FDE_51FB3ID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.17．Saber.00．配置")
local ____Saber_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["Saber技能配置"]
local ____08_FF0ESaber = require("系统.05．Buff系统.03．Buff表.02．英雄.08．Saber")
local SaberBuffID = ____08_FF0ESaber.SaberBuffID
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.17．Saber.01．状态表")
local _____83B7_53D6_6216_521B_5EFASaber_72B6_6001 = ____01_FF0E_72B6_6001_8868["获取或创建Saber状态"]
local _____83B7_53D6Saber_72B6_6001 = ____01_FF0E_72B6_6001_8868["获取Saber状态"]
local ____SaberQ_547D_4E2D_53BB_91CD_6DFB_52A0 = ____01_FF0E_72B6_6001_8868["SaberQ命中去重添加"]
local ____SaberQ_547D_4E2D_53BB_91CD_5305_542B = ____01_FF0E_72B6_6001_8868["SaberQ命中去重包含"]
local ____Saber_6E05_7A7AQ_547D_4E2D_7EC4 = ____01_FF0E_72B6_6001_8868["Saber清空Q命中组"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
function _____8BA1_7B97_4E24_70B9_89D2_5EA6(x1, y1, x2, y2)
    return Atan2(y2 - y1, x2 - x1) * bj_RADTODEG
end
function _____5728_524D_65B9_534A_5706(caster, target)
    local _____9762_5411 = GetUnitFacing(caster)
    local _____76EE_6807_89D2 = _____8BA1_7B97_4E24_70B9_89D2_5EA6(
        GetUnitX(caster),
        GetUnitY(caster),
        GetUnitX(target),
        GetUnitY(target)
    )
    local _____5DEE_503C = (_____76EE_6807_89D2 - _____9762_5411) % 360
    if _____5DEE_503C < 0 then
        _____5DEE_503C = _____5DEE_503C + 360
    end
    return _____5DEE_503C <= 90 or _____5DEE_503C >= 270
end
function _____8FC7_6EE4Q_5288_780D_76EE_6807(caster, _____654C_519B_5217_8868)
    local owner = GetOwningPlayer(caster)
    local _____7ED3_679C = {}
    for ____, target in ipairs(_____654C_519B_5217_8868) do
        do
            if target == nil or target == 0 then
                goto __continue6
            end
            if not _____5355_4F4D_5B58_6D3B(target) then
                goto __continue6
            end
            if IsUnitType(target, UNIT_TYPE_ANCIENT) then
                goto __continue6
            end
            if IsUnitType(target, UNIT_TYPE_MECHANICAL) then
                goto __continue6
            end
            if not IsUnitVisible(target, owner) then
                goto __continue6
            end
            if ____SaberQ_547D_4E2D_53BB_91CD_5305_542B(caster, target) then
                goto __continue6
            end
            if not _____5728_524D_65B9_534A_5706(caster, target) then
                goto __continue6
            end
            _____7ED3_679C[#_____7ED3_679C + 1] = target
        end
        ::__continue6::
    end
    return _____7ED3_679C
end
function _____8BA1_7B97_5200_5149_70B9(caster)
    local _____9762_5411 = GetUnitFacing(caster)
    local _____5F27_5EA6_4FA7 = (_____9762_5411 + 90) * bj_DEGTORAD
    local _____4E2DX = GetUnitX(caster) + _____914D_7F6E.Q["初段"]["刀光"]["侧向偏移"] * Cos(_____5F27_5EA6_4FA7)
    local _____4E2DY = GetUnitY(caster) + _____914D_7F6E.Q["初段"]["刀光"]["侧向偏移"] * Sin(_____5F27_5EA6_4FA7)
    local _____5F27_5EA6_524D = _____9762_5411 * bj_DEGTORAD
    return {
        X = _____4E2DX + _____914D_7F6E.Q["初段"]["刀光"]["前向偏移"] * Cos(_____5F27_5EA6_524D),
        Y = _____4E2DY + _____914D_7F6E.Q["初段"]["刀光"]["前向偏移"] * Sin(_____5F27_5EA6_524D)
    }
end
function _____64AD_653E_5200_5149(caster, _____6301_7EED_79D2)
    local _____70B9 = _____8BA1_7B97_5200_5149_70B9(caster)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.Q["初段"]["刀光"]["模型路径"],
        X = _____70B9.X,
        Y = _____70B9.Y,
        Z = _____914D_7F6E.Q["初段"]["刀光"]["高度增量"] + GetUnitFlyHeight(caster),
        ["X轴角度"] = 90,
        ["Z轴角度"] = GetUnitFacing(caster),
        ["动画速度"] = _____914D_7F6E.Q["初段"]["刀光"]["动画速度"],
        ["持续秒"] = _____6301_7EED_79D2
    })
end
function _____6062_590DQ_76EE_6807_8868_73B0(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local target = ctx.target
    if target == nil or target == 0 or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    ResetUnitAnimation(target)
    SetUnitTimeScale(target, 1)
end
function _____5E94_7528Q_76EE_6807_547D_4E2D_8868_73B0(caster, target, _____89D2_5EA6, _____51FB_9000_914D_7F6E)
    SetUnitAnimation(target, "Death")
    SetUnitTimeScale(target, _____914D_7F6E.Q["初段"]["劈砍"]["目标动作时间流速"])
    _____5F00_59CB_51FB_9000(target, {
        ["角度"] = _____89D2_5EA6,
        ["距离"] = _____51FB_9000_914D_7F6E["每次距离"] * _____51FB_9000_914D_7F6E["次数"],
        ["持续时间"] = _____51FB_9000_914D_7F6E["间隔秒"] * _____51FB_9000_914D_7F6E["次数"],
        ["检查地形"] = true,
        ["暂停单位"] = false,
        ["禁用碰撞"] = true,
        ["主单位死亡时中断"] = false
    })
    addDelayedCallback(
        math.floor((_____51FB_9000_914D_7F6E["间隔秒"] * _____51FB_9000_914D_7F6E["次数"] + 0.05) * 1000 + 0.5),
        _____6062_590DQ_76EE_6807_8868_73B0,
        {target = target}
    )
end
function _____7ED3_7B97Q_524D_65B9_5288_780D(caster, _____53C2_6570)
    if not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    local _____76EE_6807_5217_8868 = _____8FC7_6EE4Q_5288_780D_76EE_6807(
        caster,
        _____83B7_53D6_8303_56F4_654C_519B(caster, x, y, _____914D_7F6E.Q["初段"]["劈砍"]["半径"])
    )
    local _____65B9_5411 = GetUnitFacing(caster)
    for ____, target in ipairs(_____76EE_6807_5217_8868) do
        ____SaberQ_547D_4E2D_53BB_91CD_6DFB_52A0(caster, target)
        _____65BD_52A0_7729_6655(
            caster,
            target,
            _____53C2_6570["控制秒"],
            SaberBuffID["风王硬直"],
            "技能"
        )
        registerManualBuff(
            target,
            SaberBuffID["风王硬直"],
            _____53C2_6570["控制秒"],
            0,
            {["来源"] = caster, ["标签"] = _____53C2_6570["标签"]}
        )
        createTimedUnitEffect(target, _____914D_7F6E.Q["初段"]["劈砍"]["命中特效"]["挂点"], _____914D_7F6E.Q["初段"]["劈砍"]["命中特效"]["模型路径"], _____53C2_6570["命中特效持续秒"])
        if _____53C2_6570["伤害"] > 0 then
            _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                ["来源"] = caster,
                ["目标"] = target,
                ["伤害"] = _____53C2_6570["伤害"],
                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                attackType = ATTACK_TYPE_NORMAL,
                weaponType = WEAPON_TYPE_METAL_HEAVY_BASH,
                ["来源类型"] = "单位技能",
                ["标签"] = _____53C2_6570["标签"],
                ["技能ID"] = _____53C2_6570["技能类型ID"],
                ["技能实例ID"] = _____53C2_6570["技能实例ID"]
            })
        end
        _____5E94_7528Q_76EE_6807_547D_4E2D_8868_73B0(caster, target, _____65B9_5411, _____53C2_6570["击退配置"])
    end
end
function ____Q_521D_6BB5_7A97_53E3_590D_4F4D(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 then
        return
    end
    local record = _____83B7_53D6Saber_72B6_6001(caster)
    if record == nil or record["Q连击"] ~= 1 then
        return
    end
    record["Q连击"] = 0
    SetUnitTurnSpeed(caster, 1)
    SetPlayerAbilityAvailable(
        GetOwningPlayer(caster),
        ____Q_521D_6BB5ID,
        true
    )
    UnitRemoveAbility(caster, ____Q_8FDE_51FB2ID)
end
function _____6CBF_9762_5411_77AC_6B65(caster, _____8DDD_79BB)
    local _____5F27_5EA6 = GetUnitFacing(caster) * bj_DEGTORAD
    jass.SetUnitX(
        caster,
        GetUnitX(caster) + _____8DDD_79BB * Cos(_____5F27_5EA6)
    )
    jass.SetUnitY(
        caster,
        GetUnitY(caster) + _____8DDD_79BB * Sin(_____5F27_5EA6)
    )
end
function ____Q2_8FC7_6E21(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    SetUnitTimeScale(caster, 1)
    SetUnitAnimationByIndex(caster, _____914D_7F6E.Q["连击2"]["过渡"]["动作索引"])
    _____6CBF_9762_5411_77AC_6B65(caster, _____914D_7F6E.Q["连击2"]["过渡"]["前移距离"])
    addDelayedCallback(
        math.floor(_____914D_7F6E.Q["连击2"]["第二段"]["延迟秒"] * 1000 + 0.5),
        ____Q2_7B2C_4E8C_6BB5_5288_780D,
        ctx
    )
end
function ____Q2_7B2C_4E8C_6BB5_5288_780D(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    local _____76EE_6807_5217_8868 = _____8FC7_6EE4Q_5288_780D_76EE_6807(
        caster,
        _____83B7_53D6_8303_56F4_654C_519B(caster, x, y, _____914D_7F6E.Q["连击2"]["第二段"]["半径"])
    )
    local _____65B9_5411 = GetUnitFacing(caster)
    for ____, target in ipairs(_____76EE_6807_5217_8868) do
        ____SaberQ_547D_4E2D_53BB_91CD_6DFB_52A0(caster, target)
        local _____5F27_5EA6 = _____8BA1_7B97_4E24_70B9_89D2_5EA6(
            GetUnitX(caster),
            GetUnitY(caster),
            GetUnitX(target),
            GetUnitY(target)
        ) * bj_DEGTORAD
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____914D_7F6E.Q["连击2"]["第二段"]["表现特效"]["模型路径"],
            X = GetUnitX(target) + _____914D_7F6E.Q["连击2"]["第二段"]["表现特效"]["目标前方偏移"] * Cos(_____5F27_5EA6),
            Y = GetUnitY(target) + _____914D_7F6E.Q["连击2"]["第二段"]["表现特效"]["目标前方偏移"] * Sin(_____5F27_5EA6),
            ["面向角度"] = _____65B9_5411 + 90,
            ["X轴角度"] = -90,
            ["缩放"] = _____914D_7F6E.Q["连击2"]["第二段"]["表现特效"]["缩放"],
            ["持续秒"] = _____914D_7F6E.Q["连击2"]["第二段"]["表现特效"]["持续秒"]
        })
        _____65BD_52A0_7729_6655(
            caster,
            target,
            _____914D_7F6E.Q["连击2"]["第二段"]["控制秒"],
            SaberBuffID["风王硬直"],
            "技能"
        )
        registerManualBuff(
            target,
            SaberBuffID["风王硬直"],
            _____914D_7F6E.Q["连击2"]["第二段"]["控制秒"],
            0,
            {["来源"] = caster, ["标签"] = "Saber-Q-连击2第二段"}
        )
        createTimedUnitEffect(target, _____914D_7F6E.Q["连击2"]["第二段"]["命中特效"]["挂点"], _____914D_7F6E.Q["连击2"]["第二段"]["命中特效"]["模型路径"], _____914D_7F6E.Q["连击2"]["第二段"]["命中特效"]["持续秒"])
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = caster,
            ["目标"] = target,
            ["伤害"] = ctx["伤害快照"] * _____914D_7F6E.Q["连击2"]["第二段"]["伤害倍率"],
            ["伤害类型"] = DAMAGE_TYPE_NORMAL,
            attackType = ATTACK_TYPE_NORMAL,
            weaponType = WEAPON_TYPE_METAL_HEAVY_BASH,
            ["来源类型"] = "单位技能",
            ["标签"] = "Saber-Q-连击2第二段",
            ["技能ID"] = ____Q_8FDE_51FB2ID,
            ["技能实例ID"] = ctx["技能实例ID"]
        })
        _____5E94_7528Q_76EE_6807_547D_4E2D_8868_73B0(caster, target, _____65B9_5411, _____914D_7F6E.Q["连击2"]["第二段"]["目标击退"])
    end
    SetUnitTimeScale(caster, 1)
    UnitAddAbility(caster, ____Q_8FDE_51FB3ID)
    _____79FB_9664_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["Q连击2"])
    addDelayedCallback(
        math.floor(_____914D_7F6E.Q["连击2"]["连击窗口秒"] * 1000 + 0.5),
        ____Q_8FDE_51FB2_7A97_53E3_590D_4F4D,
        ctx
    )
    ctx["已启动"] = false
end
function ____Q_8FDE_51FB2_7A97_53E3_590D_4F4D(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 then
        return
    end
    local record = _____83B7_53D6Saber_72B6_6001(caster)
    if record == nil or record["Q连击"] ~= 2 then
        return
    end
    record["Q连击"] = 0
    SetUnitTurnSpeed(caster, 1)
    SetPlayerAbilityAvailable(
        GetOwningPlayer(caster),
        ____Q_521D_6BB5ID,
        true
    )
    UnitRemoveAbility(caster, ____Q_8FDE_51FB3ID)
end
function _____63A8_8FDBQ3_4E0B_964D(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    if ctx["下降次数"] >= _____914D_7F6E.Q["连击3"]["下降"]["次数"] then
        if ctx["下降回调ID"] ~= 0 then
            removePeriodicCallback(ctx["下降回调ID"])
        end
        ctx["下降回调ID"] = 0
        return
    end
    local caster = ctx["施法者"]
    if not _____5355_4F4D_5B58_6D3B(caster) then
        if ctx["下降回调ID"] ~= 0 then
            removePeriodicCallback(ctx["下降回调ID"])
        end
        ctx["下降回调ID"] = 0
        return
    end
    ctx["下降次数"] = ctx["下降次数"] + 1
    SetUnitFlyHeight(
        caster,
        GetUnitFlyHeight(caster) + _____914D_7F6E.Q["连击3"]["下降"]["每次高度"],
        0
    )
end
function ____Q3_8FC7_6E21(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    _____6CBF_9762_5411_77AC_6B65(caster, _____914D_7F6E.Q["连击3"]["过渡"]["前移距离"])
    SetUnitAnimationByIndex(caster, _____914D_7F6E.Q["连击3"]["过渡"]["动作索引"])
    ctx["下降次数"] = 0
    ctx["下降回调ID"] = addPeriodicCallback(
        math.floor(_____914D_7F6E.Q["连击3"]["下降"]["间隔秒"] * 1000 + 0.5),
        _____63A8_8FDBQ3_4E0B_964D,
        ctx
    )
    addDelayedCallback(
        math.floor(_____914D_7F6E.Q["连击3"]["第二段"]["延迟秒"] * 1000 + 0.5),
        ____Q3_7B2C_4E8C_6BB5_5288_780D,
        ctx
    )
end
function ____Q3_7B2C_4E8C_6BB5_5288_780D(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    _____64AD_653E_5200_5149(caster, _____914D_7F6E.Q["连击3"]["第二段"]["刀光持续秒"])
    _____7ED3_7B97Q_524D_65B9_5288_780D(caster, {
        ["控制秒"] = _____914D_7F6E.Q["连击3"]["第二段"]["控制秒"],
        ["伤害"] = ctx["伤害快照"] * _____914D_7F6E.Q["连击3"]["第二段"]["伤害倍率"],
        ["命中特效持续秒"] = _____914D_7F6E.Q["连击3"]["第二段"]["命中特效"]["持续秒"],
        ["击退配置"] = _____914D_7F6E.Q["连击3"]["第二段"]["目标击退"],
        ["标签"] = "Saber-Q-连击3第二段",
        ["技能类型ID"] = ____Q_8FDE_51FB3ID,
        ["技能实例ID"] = ctx["技能实例ID"]
    })
    SetUnitTimeScale(caster, 1)
    _____79FB_9664_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["Q连击3"])
    EXSetUnitMoveType(caster, 1)
    SetUnitFlyHeight(caster, 0, 0)
    addDelayedCallback(
        math.floor(_____914D_7F6E.Q["连击3"]["复位延迟秒"] * 1000 + 0.5),
        ____Q3_590D_4F4D,
        ctx
    )
    ctx["已启动"] = false
end
function ____Q3_590D_4F4D(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 then
        return
    end
    local record = _____83B7_53D6Saber_72B6_6001(caster)
    if record == nil then
        return
    end
    record["Q连击"] = 0
    SetUnitTurnSpeed(caster, 1)
    SetPlayerAbilityAvailable(
        GetOwningPlayer(caster),
        ____Q_521D_6BB5ID,
        true
    )
    UnitRemoveAbility(caster, ____Q_8FDE_51FB3ID)
    ____Saber_6E05_7A7AQ_547D_4E2D_7EC4(caster)
end
jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_0.addDelayedCallback
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_1["开始冲锋"]
_____5F00_59CB_51FB_9000 = ____require_result_1["开始击退"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_2["造成单体技能伤害"]
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____83B7_53D6_8303_56F4_654C_519B = ____require_result_3["获取范围敌军"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
_____65BD_52A0_7729_6655 = ____require_result_4["施加眩晕"]
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_5.registerManualBuff
local ____require_result_6 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_6["添加单位暂停"]
_____79FB_9664_5355_4F4D_6682_505C = ____require_result_6["移除单位暂停"]
local ____require_result_7 = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算")
local getCooldownReduction = ____require_result_7.getCooldownReduction
local ____require_result_8 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_8["技能_设置技能冷却时间"]
local ____require_result_9 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_9.Sound3DII_UnitPlayReuse
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_10["创建点特效"]
createTimedUnitEffect = ____require_result_10.createTimedUnitEffect
local ____require_result_11 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_11.registerDeathListener
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFacing = jass.GetUnitFacing
GetUnitFlyHeight = jass.GetUnitFlyHeight
GetOwningPlayer = jass.GetOwningPlayer
local GetHandleId = jass.GetHandleId
SetUnitTimeScale = jass.SetUnitTimeScale
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
SetUnitAnimation = jass.SetUnitAnimation
ResetUnitAnimation = jass.ResetUnitAnimation
SetUnitTurnSpeed = jass.SetUnitTurnSpeed
SetUnitFlyHeight = jass.SetUnitFlyHeight
SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
UnitAddAbility = jass.UnitAddAbility
UnitRemoveAbility = jass.UnitRemoveAbility
IsUnitType = jass.IsUnitType
IsUnitVisible = jass.IsUnitVisible
Atan2 = jass.Atan2
Cos = jass.Cos
Sin = jass.Sin
bj_RADTODEG = jass.bj_RADTODEG
bj_DEGTORAD = jass.bj_DEGTORAD
UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH
EXSetUnitMoveType = japi.EXSetUnitMoveType
local ____require_result_12 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_12.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
_____914D_7F6E = ____Saber_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
____Q_521D_6BB5ID = stringToFourCC(_____914D_7F6E.Q["初段"]["技能ID"])
____Q_8FDE_51FB2ID = stringToFourCC(_____914D_7F6E.Q["连击2"]["技能ID"])
____Q_8FDE_51FB3ID = stringToFourCC(_____914D_7F6E.Q["连击3"]["技能ID"])
local ____Q_521D_6BB5_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAQ_521D_6BB5_4E0A_4E0B_6587(caster)
    local id = GetHandleId(caster)
    local record = ____Q_521D_6BB5_4E0A_4E0B_6587_8868[id]
    if record == nil then
        record = {
            ["施法者"] = caster,
            ["已启动"] = false,
            ["伤害快照"] = 0,
            ["方向角度"] = 0,
            ["目标点X"] = 0,
            ["目标点Y"] = 0
        }
        ____Q_521D_6BB5_4E0A_4E0B_6587_8868[id] = record
    end
    return record
end
local function ____Q_521D_6BB5_53EF_91CA_653E(_context, caster)
    local record = _____83B7_53D6Saber_72B6_6001(caster)
    if record ~= nil and record["Q连击"] ~= 0 then
        return false
    end
    local ctx = _____83B7_53D6_6216_521B_5EFAQ_521D_6BB5_4E0A_4E0B_6587(caster)
    return not ctx["已启动"]
end
local function ____Q1_51B2_950B_547D_4E2D_56DE_8C03(_____79FB_52A8_5355_4F4D, _____76EE_6807_5355_4F4D, ______4F4D_79FBID)
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 or not _____5355_4F4D_5B58_6D3B(_____76EE_6807_5355_4F4D) then
        return
    end
    _____5F00_59CB_51FB_9000(
        _____76EE_6807_5355_4F4D,
        {
            ["角度"] = GetUnitFacing(_____79FB_52A8_5355_4F4D),
            ["距离"] = 40,
            ["持续时间"] = 0.1,
            ["检查地形"] = true,
            ["暂停单位"] = false,
            ["禁用碰撞"] = false
        }
    )
end
local function ____Q1_547D_4E2D_540E_5288_780D(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    _____64AD_653E_5200_5149(caster, _____914D_7F6E.Q["初段"]["刀光"]["持续秒"])
    _____7ED3_7B97Q_524D_65B9_5288_780D(caster, {
        ["控制秒"] = _____914D_7F6E.Q["初段"]["劈砍"]["控制秒"],
        ["伤害"] = ctx["伤害快照"] * _____914D_7F6E.Q["初段"]["劈砍"]["伤害倍率"],
        ["命中特效持续秒"] = _____914D_7F6E.Q["初段"]["劈砍"]["命中特效"]["持续秒"],
        ["击退配置"] = _____914D_7F6E.Q["初段"]["劈砍"]["目标击退"],
        ["标签"] = "Saber-Q-初段劈砍",
        ["技能类型ID"] = ____Q_521D_6BB5ID,
        ["技能实例ID"] = ctx["技能实例ID"]
    })
    _____79FB_9664_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["Q初段"])
    SetPlayerAbilityAvailable(
        GetOwningPlayer(caster),
        ____Q_521D_6BB5ID,
        false
    )
    UnitAddAbility(caster, ____Q_8FDE_51FB2ID)
    SetUnitTimeScale(caster, 1)
    addDelayedCallback(
        math.floor(_____914D_7F6E.Q["初段"]["连击窗口秒"] * 1000 + 0.5),
        ____Q_521D_6BB5_7A97_53E3_590D_4F4D,
        ctx
    )
    ctx["已启动"] = false
end
local function ____Q1_672A_547D_4E2D_6536_5C3E(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    ctx["已启动"] = false
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    local record = _____83B7_53D6Saber_72B6_6001(caster)
    if record ~= nil then
        record["Q连击"] = 0
    end
    SetUnitTimeScale(caster, 1)
    local _____7F29_51CF = getCooldownReduction(caster)
    if _____7F29_51CF > _____914D_7F6E.Q["初段"]["未命中冷却"]["冷却缩减上限"] then
        _____7F29_51CF = _____914D_7F6E.Q["初段"]["未命中冷却"]["冷却缩减上限"]
    end
    local _____76EE_6807_51B7_5374 = _____914D_7F6E.Q["初段"]["未命中冷却"]["基础冷却秒"] - _____914D_7F6E.Q["初段"]["未命中冷却"]["基础冷却秒"] * _____7F29_51CF
    _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(caster, ____Q_521D_6BB5ID, _____76EE_6807_51B7_5374, _____914D_7F6E.Q["初段"]["物编冷却秒"])
end
local function ____Q1_51B2_950B_7ED3_675F(_____79FB_52A8_5355_4F4D, _____539F_56E0, ______4F4D_79FBID, _____547D_4E2D_76EE_6807)
    local record = _____83B7_53D6_6216_521B_5EFAQ_521D_6BB5_4E0A_4E0B_6587(_____79FB_52A8_5355_4F4D)
    if _____539F_56E0 == "死亡" or _____539F_56E0 == "主单位死亡" then
        record["已启动"] = false
        return
    end
    if _____539F_56E0 == "命中" or _____547D_4E2D_76EE_6807 ~= nil and _____547D_4E2D_76EE_6807 ~= 0 then
        _____6DFB_52A0_5355_4F4D_6682_505C(_____79FB_52A8_5355_4F4D, _____914D_7F6E["暂停来源"]["Q初段"])
        SetUnitAnimationByIndex(_____79FB_52A8_5355_4F4D, _____914D_7F6E.Q["初段"]["命中后"]["动作索引"])
        SetUnitTimeScale(_____79FB_52A8_5355_4F4D, _____914D_7F6E.Q["初段"]["命中后"]["时间流速"])
        addDelayedCallback(
            math.floor(_____914D_7F6E.Q["初段"]["命中后"]["硬直延迟秒"] * 1000 + 0.5),
            ____Q1_547D_4E2D_540E_5288_780D,
            record
        )
    else
        ____Q1_672A_547D_4E2D_6536_5C3E(record)
    end
end
local function ____Q1_542F_52A8_51B2_950B(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        ctx["已启动"] = false
        return
    end
    ctx["方向角度"] = _____8BA1_7B97_4E24_70B9_89D2_5EA6(
        GetUnitX(caster),
        GetUnitY(caster),
        ctx["目标点X"],
        ctx["目标点Y"]
    )
    Sound3DII_UnitPlayReuse(_____914D_7F6E.Q["初段"]["音效"]["路径"], caster, _____914D_7F6E.Q["初段"]["音效"]["裁断距离"])
    SetUnitTimeScale(caster, _____914D_7F6E.Q["初段"]["时间流速"])
    SetUnitAnimationByIndex(caster, _____914D_7F6E.Q["初段"]["动作索引"])
    _____5F00_59CB_51B2_950B(caster, {
        ["角度"] = ctx["方向角度"],
        ["距离"] = _____914D_7F6E.Q["初段"]["冲锋"]["最大距离"],
        ["持续时间"] = _____914D_7F6E.Q["初段"]["冲锋"]["推进间隔秒"] * _____914D_7F6E.Q["初段"]["冲锋"]["最大推进次数"],
        ["检查地形"] = true,
        ["朝向跟随位移"] = true,
        ["动画序号"] = _____914D_7F6E.Q["初段"]["动作索引"],
        ["命中半径"] = _____914D_7F6E.Q["初段"]["冲锋"]["命中半径"],
        ["只命中敌人"] = true,
        ["命中后结束"] = true,
        ["命中回调"] = ____Q1_51B2_950B_547D_4E2D_56DE_8C03,
        ["结束回调"] = ____Q1_51B2_950B_7ED3_675F
    })
end
local function _____91CA_653EQ_521D_6BB5(context, caster, _____6280_80FD_5B9E_4F8BID)
    if context["已启动"] then
        return
    end
    context["已启动"] = true
    context["施法者"] = caster
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["伤害快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E.Q["初段"]["伤害攻击力倍率"]
    context["目标点X"] = GetSpellTargetX()
    context["目标点Y"] = GetSpellTargetY()
    local record = _____83B7_53D6_6216_521B_5EFASaber_72B6_6001(caster)
    record["Q连击"] = 1
    addDelayedCallback(
        math.floor(_____914D_7F6E.Q["初段"]["起手延迟秒"] * 1000 + 0.5),
        ____Q1_542F_52A8_51B2_950B,
        context
    )
end
local ____Q_8FDE_51FB2_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAQ_8FDE_51FB2_4E0A_4E0B_6587(caster)
    local id = GetHandleId(caster)
    local record = ____Q_8FDE_51FB2_4E0A_4E0B_6587_8868[id]
    if record == nil then
        record = {["施法者"] = caster, ["已启动"] = false, ["伤害快照"] = 0}
        ____Q_8FDE_51FB2_4E0A_4E0B_6587_8868[id] = record
    end
    return record
end
local function ____Q_8FDE_51FB2_53EF_91CA_653E(_context, caster)
    local record = _____83B7_53D6Saber_72B6_6001(caster)
    return record ~= nil and record["Q连击"] == 1
end
local function ____Q2_7B2C_4E00_6BB5_5288_780D(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    _____64AD_653E_5200_5149(caster, _____914D_7F6E.Q["连击2"]["第一段"]["刀光持续秒"])
    _____7ED3_7B97Q_524D_65B9_5288_780D(caster, {
        ["控制秒"] = _____914D_7F6E.Q["连击2"]["第一段"]["控制秒"],
        ["伤害"] = ctx["伤害快照"] * _____914D_7F6E.Q["连击2"]["第一段"]["伤害倍率"],
        ["命中特效持续秒"] = _____914D_7F6E.Q["连击2"]["第一段"]["命中特效"]["持续秒"],
        ["击退配置"] = _____914D_7F6E.Q["连击2"]["第一段"]["目标击退"],
        ["标签"] = "Saber-Q-连击2第一段",
        ["技能类型ID"] = ____Q_8FDE_51FB2ID,
        ["技能实例ID"] = ctx["技能实例ID"]
    })
    addDelayedCallback(
        math.floor(_____914D_7F6E.Q["连击2"]["过渡"]["延迟秒"] * 1000 + 0.5),
        ____Q2_8FC7_6E21,
        ctx
    )
end
local function _____91CA_653EQ_8FDE_51FB2(context, caster, _____6280_80FD_5B9E_4F8BID)
    if context["已启动"] then
        return
    end
    local record = _____83B7_53D6_6216_521B_5EFASaber_72B6_6001(caster)
    if record["Q连击"] ~= 1 then
        return
    end
    record["Q连击"] = 2
    context["已启动"] = true
    context["施法者"] = caster
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["伤害快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E.Q["连击2"]["伤害攻击力倍率"]
    SetUnitTurnSpeed(caster, 0)
    Sound3DII_UnitPlayReuse(_____914D_7F6E.Q["连击2"]["音效"]["路径"], caster, _____914D_7F6E.Q["连击2"]["音效"]["裁断距离"])
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["Q连击2"])
    SetUnitTimeScale(caster, _____914D_7F6E.Q["连击2"]["时间流速"])
    UnitRemoveAbility(caster, ____Q_8FDE_51FB2ID)
    SetUnitAnimationByIndex(caster, _____914D_7F6E.Q["连击2"]["动作索引"])
    _____6CBF_9762_5411_77AC_6B65(caster, _____914D_7F6E.Q["连击2"]["前移距离"])
    addDelayedCallback(
        math.floor(_____914D_7F6E.Q["连击2"]["第一段"]["延迟秒"] * 1000 + 0.5),
        ____Q2_7B2C_4E00_6BB5_5288_780D,
        context
    )
end
local ____Q_8FDE_51FB3_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAQ_8FDE_51FB3_4E0A_4E0B_6587(caster)
    local id = GetHandleId(caster)
    local record = ____Q_8FDE_51FB3_4E0A_4E0B_6587_8868[id]
    if record == nil then
        record = {
            ["施法者"] = caster,
            ["已启动"] = false,
            ["伤害快照"] = 0,
            ["上升回调ID"] = 0,
            ["上升次数"] = 0,
            ["下降回调ID"] = 0,
            ["下降次数"] = 0
        }
        ____Q_8FDE_51FB3_4E0A_4E0B_6587_8868[id] = record
    end
    return record
end
local function ____Q_8FDE_51FB3_53EF_91CA_653E(_context, caster)
    local record = _____83B7_53D6Saber_72B6_6001(caster)
    return record ~= nil and record["Q连击"] == 2
end
local function _____63A8_8FDBQ3_4E0A_5347(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    if ctx["上升次数"] >= _____914D_7F6E.Q["连击3"]["上升"]["次数"] then
        if ctx["上升回调ID"] ~= 0 then
            removePeriodicCallback(ctx["上升回调ID"])
        end
        ctx["上升回调ID"] = 0
        return
    end
    local caster = ctx["施法者"]
    if not _____5355_4F4D_5B58_6D3B(caster) then
        if ctx["上升回调ID"] ~= 0 then
            removePeriodicCallback(ctx["上升回调ID"])
        end
        ctx["上升回调ID"] = 0
        return
    end
    ctx["上升次数"] = ctx["上升次数"] + 1
    SetUnitFlyHeight(
        caster,
        GetUnitFlyHeight(caster) + _____914D_7F6E.Q["连击3"]["上升"]["每次高度"],
        0
    )
end
local function ____Q3_7B2C_4E00_6BB5_5288_780D(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    _____7ED3_7B97Q_524D_65B9_5288_780D(caster, {
        ["控制秒"] = _____914D_7F6E.Q["连击3"]["第一段"]["控制秒"],
        ["伤害"] = ctx["伤害快照"] * _____914D_7F6E.Q["连击3"]["第一段"]["伤害倍率"],
        ["命中特效持续秒"] = _____914D_7F6E.Q["连击3"]["第一段"]["命中特效"]["持续秒"],
        ["击退配置"] = _____914D_7F6E.Q["连击3"]["第一段"]["目标击退"],
        ["标签"] = "Saber-Q-连击3第一段",
        ["技能类型ID"] = ____Q_8FDE_51FB3ID,
        ["技能实例ID"] = ctx["技能实例ID"]
    })
    addDelayedCallback(
        math.floor(_____914D_7F6E.Q["连击3"]["过渡"]["延迟秒"] * 1000 + 0.5),
        ____Q3_8FC7_6E21,
        ctx
    )
end
local function _____91CA_653EQ_8FDE_51FB3(context, caster, _____6280_80FD_5B9E_4F8BID)
    if context["已启动"] then
        return
    end
    local record = _____83B7_53D6_6216_521B_5EFASaber_72B6_6001(caster)
    if record["Q连击"] ~= 2 then
        return
    end
    record["Q连击"] = 3
    context["已启动"] = true
    context["施法者"] = caster
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["伤害快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E.Q["连击3"]["伤害攻击力倍率"]
    context["上升次数"] = 0
    context["下降次数"] = 0
    SetUnitTurnSpeed(caster, 1)
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, _____914D_7F6E["暂停来源"]["Q连击3"])
    Sound3DII_UnitPlayReuse(_____914D_7F6E.Q["连击3"]["音效"]["路径"], caster, _____914D_7F6E.Q["连击3"]["音效"]["裁断距离"])
    UnitRemoveAbility(caster, ____Q_8FDE_51FB3ID)
    SetPlayerAbilityAvailable(
        GetOwningPlayer(caster),
        ____Q_521D_6BB5ID,
        true
    )
    EXSetUnitMoveType(caster, 2)
    SetUnitTimeScale(caster, _____914D_7F6E.Q["连击3"]["时间流速"])
    SetUnitAnimationByIndex(caster, _____914D_7F6E.Q["连击3"]["动作索引"])
    _____6CBF_9762_5411_77AC_6B65(caster, _____914D_7F6E.Q["连击3"]["前移距离"])
    context["上升回调ID"] = addPeriodicCallback(
        math.floor(_____914D_7F6E.Q["连击3"]["上升"]["间隔秒"] * 1000 + 0.5),
        _____63A8_8FDBQ3_4E0A_5347,
        context
    )
    addDelayedCallback(
        math.floor(_____914D_7F6E.Q["连击3"]["第一段"]["延迟秒"] * 1000 + 0.5),
        ____Q3_7B2C_4E00_6BB5_5288_780D,
        context
    )
end
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function ____Q_5355_4F4D_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    if jass.GetUnitTypeId(dyingUnit) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    local record = _____83B7_53D6Saber_72B6_6001(dyingUnit)
    if record == nil or record["Q连击"] == 0 then
        return
    end
    record["Q连击"] = 0
    ____Saber_6E05_7A7AQ_547D_4E2D_7EC4(dyingUnit)
    _____79FB_9664_5355_4F4D_6682_505C(dyingUnit, _____914D_7F6E["暂停来源"]["Q初段"])
    _____79FB_9664_5355_4F4D_6682_505C(dyingUnit, _____914D_7F6E["暂停来源"]["Q连击2"])
    _____79FB_9664_5355_4F4D_6682_505C(dyingUnit, _____914D_7F6E["暂停来源"]["Q连击3"])
    SetPlayerAbilityAvailable(
        GetOwningPlayer(dyingUnit),
        ____Q_521D_6BB5ID,
        true
    )
    UnitRemoveAbility(dyingUnit, ____Q_8FDE_51FB2ID)
    UnitRemoveAbility(dyingUnit, ____Q_8FDE_51FB3ID)
    local ctx1 = ____Q_521D_6BB5_4E0A_4E0B_6587_8868[GetHandleId(dyingUnit)]
    if ctx1 ~= nil then
        ctx1["已启动"] = false
    end
    local ctx2 = ____Q_8FDE_51FB2_4E0A_4E0B_6587_8868[GetHandleId(dyingUnit)]
    if ctx2 ~= nil then
        ctx2["已启动"] = false
    end
    local ctx3 = ____Q_8FDE_51FB3_4E0A_4E0B_6587_8868[GetHandleId(dyingUnit)]
    if ctx3 ~= nil then
        ctx3["已启动"] = false
        if ctx3["上升回调ID"] ~= 0 then
            removePeriodicCallback(ctx3["上升回调ID"])
        end
        if ctx3["下降回调ID"] ~= 0 then
            removePeriodicCallback(ctx3["下降回调ID"])
        end
        ctx3["上升回调ID"] = 0
        ctx3["下降回调ID"] = 0
    end
end
____exports["注册SaberQ"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "Saber-风王结界初段（Q）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.Q["初段"]["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAQ_521D_6BB5_4E0A_4E0B_6587,
        ["可释放"] = ____Q_521D_6BB5_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653EQ_521D_6BB5,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 8
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "Saber-风王结界连击2（Q）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.Q["连击2"]["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAQ_8FDE_51FB2_4E0A_4E0B_6587,
        ["可释放"] = ____Q_8FDE_51FB2_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653EQ_8FDE_51FB2,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 5
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "Saber-风王结界连击3（Q）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.Q["连击3"]["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAQ_8FDE_51FB3_4E0A_4E0B_6587,
        ["可释放"] = ____Q_8FDE_51FB3_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653EQ_8FDE_51FB3,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 5
    })
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____Q_5355_4F4D_6B7B_4EA1_6E05_7406)
    end
end
____exports["注册SaberQ"]()
return ____exports
