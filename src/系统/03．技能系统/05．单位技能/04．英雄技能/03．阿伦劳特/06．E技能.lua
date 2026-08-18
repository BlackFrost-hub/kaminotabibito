local ____lualib = require("lualib_bundle")
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____8BFB_53D6_5355_4F4D_653B_51FB_8303_56F4, _____53D6_56DB_820D_4E94_5165_6574_6570, _____53D6_8F83_5C0F_503C, _____5355_4F4D_5F53_524D_98DE_884C_9AD8_5EA6, _____64AD_653ELifeDrain_97F3_6548, _____9020_6210W_4F24_5BB3, _____5149_51B2_950B_7ED3_7B97_56DE_8C03, _____5149_51B2_950B_5468_671F, _____5149_51B2_950B_7ED3_7B97, _____5149_7ED3_7B97_4F24_5BB3, _____7ED3_675F_5149_51B2_950B, _____9500_6BC1_6697_5F62_6001_6C72_53D6_95EA_7535, _____6697_5438_5F15_5468_671F, _____6697_5438_5F15_5355_5355_4F4D, removePeriodicCallback, addDelayedCallback, removeDelayedCallback, _____9020_6210_6280_80FD_4F24_5BB3, _____65BD_52A0_51CF_901F, _____65BD_52A0_7729_6655, _____5F00_59CB_51FB_9000, getUnitsInRange, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____5355_4F4D_5B58_6D3B, getObjectPropertyRealSafe, _____521B_5EFA_70B9_7279_6548, createTimedUnitEffect, SOS_GetUnitSpeed, SOS_SetUnitSpeed, PlaySoundOnUnitBJ, gg_snd_LifeDrain, GetUnitTypeId, GetOwningPlayer, GetUnitX, GetUnitY, GetUnitFacing, GetUnitFlyHeight, SetUnitFlyHeight, GetUnitDefaultFlyHeight, SetUnitPosition, SetUnitPathing, PauseUnit, SetUnitTimeScale, SetUnitAnimationByIndex, SetUnitVertexColor, CreateUnit, UnitApplyTimedLife, IsUnitEnemy, GetUnitState, SetUnitState, AddLightning, DestroyLightning, DAMAGE_TYPE_MAGIC, DAMAGE_TYPE_SHADOW_STRIKE, ATTACK_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS, YDWE_OBJECT_TYPE_UNIT, UNIT_STATE_LIFE, Cos, Sin, R2I, ____E_6280_80FDID, _____6B8B_5F71_5355_4F4DID, _____9650_65F6_751F_547DBuffID, _____89D2_5EA6_8F6C_5F27_5EA6
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.03．阿伦劳特.00．配置")
local _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["阿伦劳特单位技能配置"]
local ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406 = require("系统.03．技能系统.05．单位技能.04．英雄技能.03．阿伦劳特.00B．形态与状态管理")
local _____662F_963F_4F26_52B3_7279_82F1_96C4 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["是阿伦劳特英雄"]
local _____662F_5149_5F62_6001 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["是光形态"]
local _____662F_6697_5F62_6001 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["是暗形态"]
local _____662F_6709_6548_76EE_6807 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["是有效目标"]
local _____62E5_6709_5929_5802_547C_5524 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["拥有天堂呼唤"]
local _____4E24_70B9_89D2_5EA6 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["两点角度"]
local _____4E24_70B9_8DDD_79BB = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["两点距离"]
function _____8BFB_53D6_5355_4F4D_653B_51FB_8303_56F4(unit)
    local _____8303_56F4 = getObjectPropertyRealSafe(
        YDWE_OBJECT_TYPE_UNIT,
        GetUnitTypeId(unit),
        "rangeN1"
    )
    return _____8303_56F4 > 0 and _____8303_56F4 or 128
end
function _____53D6_56DB_820D_4E94_5165_6574_6570(value)
    return R2I(value + 0.5)
end
function _____53D6_8F83_5C0F_503C(a, b)
    return a < b and a or b
end
function _____5355_4F4D_5F53_524D_98DE_884C_9AD8_5EA6(unit)
    local h = GetUnitFlyHeight(unit)
    return h > 0 and h or 0
end
function _____64AD_653ELifeDrain_97F3_6548(_____5355_4F4D)
    if gg_snd_LifeDrain == nil or gg_snd_LifeDrain == 0 or _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    PlaySoundOnUnitBJ(gg_snd_LifeDrain, 100, _____5355_4F4D)
end
function _____9020_6210W_4F24_5BB3(_____65BD_6CD5_8005, _____76EE_6807, _____500D_7387, _____4F24_5BB3_7C7B_578B, _____662F_5426_653B_51FB_6548_679C)
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005)
    if _____653B_51FB_529B <= 0 then
        return
    end
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = _____65BD_6CD5_8005,
        ["目标"] = _____76EE_6807,
        ["伤害"] = _____653B_51FB_529B * _____500D_7387,
        ["伤害类型"] = _____4F24_5BB3_7C7B_578B,
        attack = _____662F_5426_653B_51FB_6548_679C,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____E_6280_80FDID,
        ["标签"] = "阿伦劳特-E",
        ["参与技能伤害加成"] = true
    })
end
function _____5149_51B2_950B_7ED3_7B97_56DE_8C03(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    ctx["结算延迟ID"] = 0
    if ctx["已结束"] then
        return
    end
    _____5149_7ED3_7B97_4F24_5BB3(ctx)
    _____7ED3_675F_5149_51B2_950B(ctx)
end
function _____5149_51B2_950B_5468_671F(ctx)
    if ctx["已结束"] then
        return
    end
    local ____E_914D_7F6E = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.E
    local _____65BD_6CD5_8005 = ctx["施法者"]
    local _____76EE_6807 = ctx["目标"]
    if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) or not _____5355_4F4D_5B58_6D3B(_____76EE_6807) then
        _____7ED3_675F_5149_51B2_950B(ctx)
        return
    end
    local _____653B_51FB_8303_56F4 = _____8BFB_53D6_5355_4F4D_653B_51FB_8303_56F4(_____65BD_6CD5_8005)
    local _____5230_8FBE = _____4E24_70B9_8DDD_79BB(
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        GetUnitX(_____76EE_6807),
        GetUnitY(_____76EE_6807)
    ) <= _____653B_51FB_8303_56F4 * ____E_914D_7F6E["光到达范围倍数"] or ctx["循环实数"] >= ____E_914D_7F6E["光冲锋次数上限"]
    if _____5230_8FBE then
        SetUnitFlyHeight(
            _____65BD_6CD5_8005,
            GetUnitDefaultFlyHeight(_____65BD_6CD5_8005),
            0
        )
        _____5149_51B2_950B_7ED3_7B97(ctx)
        return
    end
    ctx["循环实数"] = ctx["循环实数"] + 1
    local _____89D2_5EA6 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        GetUnitX(_____76EE_6807),
        GetUnitY(_____76EE_6807)
    )
    local _____5206_8EAB = CreateUnit(
        GetOwningPlayer(_____65BD_6CD5_8005),
        _____6B8B_5F71_5355_4F4DID,
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        GetUnitFacing(_____65BD_6CD5_8005)
    )
    UnitApplyTimedLife(_____5206_8EAB, _____9650_65F6_751F_547DBuffID, ____E_914D_7F6E["残影持续秒"])
    SetUnitVertexColor(
        _____5206_8EAB,
        ____E_914D_7F6E["残影红"],
        ____E_914D_7F6E["残影绿"],
        ____E_914D_7F6E["残影蓝"],
        ____E_914D_7F6E["残影透明"]
    )
    SetUnitTimeScale(_____5206_8EAB, 1 + ctx["循环实数"] * ctx["倍数"])
    if not ctx["天堂审判开启"] then
        SetUnitAnimationByIndex(_____5206_8EAB, 6)
        SetUnitFlyHeight(
            _____5206_8EAB,
            _____5355_4F4D_5F53_524D_98DE_884C_9AD8_5EA6(_____65BD_6CD5_8005),
            0
        )
    else
        SetUnitAnimationByIndex(_____5206_8EAB, 3)
        local _____8DF3_8DC3_9AD8 = ctx["循环实数"] >= ctx["次数"] * 0.5 and -40 or 40
        SetUnitFlyHeight(
            _____65BD_6CD5_8005,
            _____5355_4F4D_5F53_524D_98DE_884C_9AD8_5EA6(_____65BD_6CD5_8005) + _____8DF3_8DC3_9AD8,
            0
        )
        SetUnitFlyHeight(
            _____5206_8EAB,
            _____5355_4F4D_5F53_524D_98DE_884C_9AD8_5EA6(_____65BD_6CD5_8005),
            0
        )
    end
    local nx = GetUnitX(_____65BD_6CD5_8005) + Cos(_____89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6) * ____E_914D_7F6E["冲锋每tick距离"]
    local ny = GetUnitY(_____65BD_6CD5_8005) + Sin(_____89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6) * ____E_914D_7F6E["冲锋每tick距离"]
    SetUnitPosition(_____65BD_6CD5_8005, nx, ny)
end
function _____5149_51B2_950B_7ED3_7B97(ctx)
    if ctx["已结束"] or ctx["结算中"] then
        return
    end
    ctx["结算中"] = true
    if ctx["周期ID"] ~= 0 then
        removePeriodicCallback(ctx["周期ID"])
        ctx["周期ID"] = 0
    end
    local ____E_914D_7F6E = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.E
    local _____65BD_6CD5_8005 = ctx["施法者"]
    local _____76EE_6807 = ctx["目标"]
    local _____5EF6_8FDF = ctx["天堂审判开启"] and 0 or ____E_914D_7F6E["光结算延迟秒"]
    SetUnitAnimationByIndex(_____65BD_6CD5_8005, 3)
    SetUnitTimeScale(_____65BD_6CD5_8005, 1)
    ctx["结算延迟ID"] = addDelayedCallback(
        _____53D6_56DB_820D_4E94_5165_6574_6570(_____5EF6_8FDF * 1000),
        _____5149_51B2_950B_7ED3_7B97_56DE_8C03,
        ctx
    )
end
function _____5149_7ED3_7B97_4F24_5BB3(ctx)
    local ____E_914D_7F6E = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.E
    local _____65BD_6CD5_8005 = ctx["施法者"]
    local _____76EE_6807 = ctx["目标"]
    if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) or not _____5355_4F4D_5B58_6D3B(_____76EE_6807) then
        return
    end
    local tx = GetUnitX(_____76EE_6807)
    local ty = GetUnitY(_____76EE_6807)
    local _____76EE_6807_98DE_884C_9AD8_5EA6 = _____5355_4F4D_5F53_524D_98DE_884C_9AD8_5EA6(_____76EE_6807)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = ____E_914D_7F6E["光结算特效"],
        X = tx,
        Y = ty,
        Z = _____76EE_6807_98DE_884C_9AD8_5EA6 + ____E_914D_7F6E["光结算特效Z偏移"],
        ["缩放"] = ____E_914D_7F6E["光结算特效缩放"],
        ["持续秒"] = ____E_914D_7F6E["光结算特效持续秒"]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = ____E_914D_7F6E["光雷击特效"],
        X = tx,
        Y = ty,
        Z = _____76EE_6807_98DE_884C_9AD8_5EA6,
        ["持续秒"] = ____E_914D_7F6E["光雷击特效持续秒"]
    })
    local _____6E85_5C04_76EE_6807 = getUnitsInRange(tx, ty, 300)
    if ctx["天堂审判开启"] then
        _____9020_6210W_4F24_5BB3(
            _____65BD_6CD5_8005,
            _____76EE_6807,
            ____E_914D_7F6E["光天堂审判主目标倍率"],
            DAMAGE_TYPE_MAGIC,
            true
        )
        do
            local i = 0
            while i < #_____6E85_5C04_76EE_6807 do
                do
                    local t = _____6E85_5C04_76EE_6807[i + 1]
                    if t == _____76EE_6807 then
                        goto __continue33
                    end
                    if not _____662F_6709_6548_76EE_6807(t) then
                        goto __continue33
                    end
                    if not IsUnitEnemy(
                        t,
                        GetOwningPlayer(_____65BD_6CD5_8005)
                    ) then
                        goto __continue33
                    end
                    _____9020_6210W_4F24_5BB3(
                        _____65BD_6CD5_8005,
                        t,
                        ____E_914D_7F6E["光天堂审判溅射倍率"],
                        DAMAGE_TYPE_MAGIC,
                        true
                    )
                    createTimedUnitEffect(t, "chest", ____E_914D_7F6E["光溅射命中特效"], ____E_914D_7F6E["光溅射命中特效持续秒"])
                    _____5F00_59CB_51FB_9000(t, {
                        ["来源单位"] = _____65BD_6CD5_8005,
                        ["距离"] = ____E_914D_7F6E["光天堂审判溅射击退距离"],
                        ["持续时间"] = 0.3,
                        ["检查地形"] = true,
                        ["暂停单位"] = false,
                        ["禁用碰撞"] = true,
                        ["主单位死亡时中断"] = false
                    })
                    _____65BD_52A0_7729_6655(
                        _____65BD_6CD5_8005,
                        t,
                        ____E_914D_7F6E["光天堂审判溅射眩晕秒"],
                        "阿伦劳特-E-裁决审判",
                        "技能"
                    )
                end
                ::__continue33::
                i = i + 1
            end
        end
    else
        _____9020_6210W_4F24_5BB3(
            _____65BD_6CD5_8005,
            _____76EE_6807,
            ____E_914D_7F6E["光主目标倍率"],
            DAMAGE_TYPE_MAGIC,
            false
        )
        do
            local i = 0
            while i < #_____6E85_5C04_76EE_6807 do
                do
                    local t = _____6E85_5C04_76EE_6807[i + 1]
                    if t == _____76EE_6807 then
                        goto __continue39
                    end
                    if not _____662F_6709_6548_76EE_6807(t) then
                        goto __continue39
                    end
                    if not IsUnitEnemy(
                        t,
                        GetOwningPlayer(_____65BD_6CD5_8005)
                    ) then
                        goto __continue39
                    end
                    _____9020_6210W_4F24_5BB3(
                        _____65BD_6CD5_8005,
                        t,
                        ____E_914D_7F6E["光溅射倍率"],
                        DAMAGE_TYPE_MAGIC,
                        false
                    )
                    createTimedUnitEffect(t, "chest", ____E_914D_7F6E["光溅射命中特效"], ____E_914D_7F6E["光溅射命中特效持续秒"])
                end
                ::__continue39::
                i = i + 1
            end
        end
    end
end
function _____7ED3_675F_5149_51B2_950B(ctx)
    if ctx["已结束"] then
        return
    end
    ctx["已结束"] = true
    if ctx["周期ID"] ~= 0 then
        removePeriodicCallback(ctx["周期ID"])
    end
    if ctx["结算延迟ID"] ~= 0 then
        removeDelayedCallback(ctx["结算延迟ID"])
    end
    local _____65BD_6CD5_8005 = ctx["施法者"]
    if _____65BD_6CD5_8005 ~= nil and _____65BD_6CD5_8005 ~= 0 then
        SetUnitPathing(_____65BD_6CD5_8005, true)
        SetUnitTimeScale(_____65BD_6CD5_8005, 1)
        PauseUnit(_____65BD_6CD5_8005, false)
    end
end
function _____9500_6BC1_6697_5F62_6001_6C72_53D6_95EA_7535(variable)
    local lightning = variable
    if lightning ~= nil and lightning ~= 0 then
        DestroyLightning(lightning)
    end
end
function _____6697_5438_5F15_5468_671F(ctx)
    if ctx["已结束"] then
        return
    end
    local ____E_914D_7F6E = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.E
    ctx["循环实数"] = ctx["循环实数"] + 1
    if ctx["循环实数"] >= ____E_914D_7F6E["暗最大tick"] then
        do
            local i = 0
            while i < #ctx["吸引组"] do
                local u = ctx["吸引组"][i + 1]
                if u ~= nil and u ~= 0 then
                    SetUnitPathing(u, true)
                end
                i = i + 1
            end
        end
        ctx["已结束"] = true
        removePeriodicCallback(ctx["周期ID"])
        return
    end
    do
        local i = #ctx["吸引组"] - 1
        while i >= 0 do
            do
                local _____5355_4F4D = ctx["吸引组"][i + 1]
                if _____5355_4F4D == nil or _____5355_4F4D == 0 then
                    __TS__ArraySplice(ctx["吸引组"], i, 1)
                    goto __continue64
                end
                if not _____5355_4F4D_5B58_6D3B(_____5355_4F4D) then
                    SetUnitPathing(_____5355_4F4D, true)
                    __TS__ArraySplice(ctx["吸引组"], i, 1)
                    goto __continue64
                end
                _____6697_5438_5F15_5355_5355_4F4D(ctx, _____5355_4F4D, i)
            end
            ::__continue64::
            i = i - 1
        end
    end
end
function _____6697_5438_5F15_5355_5355_4F4D(ctx, _____5355_4F4D, _____7D22_5F15)
    local ____E_914D_7F6E = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.E
    local _____65BD_6CD5_8005 = ctx["施法者"]
    local _____662F_654C_4EBA = IsUnitEnemy(
        _____5355_4F4D,
        GetOwningPlayer(_____65BD_6CD5_8005)
    )
    _____64AD_653ELifeDrain_97F3_6548(_____5355_4F4D)
    SetUnitPathing(_____5355_4F4D, false)
    local _____6C72_53D6_95EA_7535 = AddLightning(
        ____E_914D_7F6E["暗汲取闪电代码"],
        false,
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D),
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005)
    )
    if _____6C72_53D6_95EA_7535 ~= nil and _____6C72_53D6_95EA_7535 ~= 0 then
        local _____8BE5_95EA_7535 = _____6C72_53D6_95EA_7535
        addDelayedCallback(
            _____53D6_56DB_820D_4E94_5165_6574_6570(____E_914D_7F6E["暗汲取闪电持续秒"] * 1000),
            _____9500_6BC1_6697_5F62_6001_6C72_53D6_95EA_7535,
            _____8BE5_95EA_7535
        )
    end
    local _____89D2_5EA6 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D),
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005)
    )
    local _____79FB_52A8_8DDD_79BB = _____662F_654C_4EBA and ____E_914D_7F6E["暗敌人靠近距离"] or ____E_914D_7F6E["暗友军靠近距离"]
    local nx = GetUnitX(_____5355_4F4D) + Cos(_____89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6) * _____79FB_52A8_8DDD_79BB
    local ny = GetUnitY(_____5355_4F4D) + Sin(_____89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6) * _____79FB_52A8_8DDD_79BB
    SetUnitPosition(_____5355_4F4D, nx, ny)
    if _____662F_654C_4EBA and ctx["每秒吸取值"] > 0 then
        local _____5438_53D6 = ctx["每秒吸取值"] * ____E_914D_7F6E["暗吸取tick比例"]
        local _____5F53_524D_751F_547D = GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE)
        local _____5B9E_9645_5438_53D6 = _____53D6_8F83_5C0F_503C(_____5F53_524D_751F_547D, _____5438_53D6)
        if _____5B9E_9645_5438_53D6 > 0 then
            SetUnitState(_____5355_4F4D, UNIT_STATE_LIFE, _____5F53_524D_751F_547D - _____5B9E_9645_5438_53D6)
            SetUnitState(
                _____65BD_6CD5_8005,
                UNIT_STATE_LIFE,
                GetUnitState(_____65BD_6CD5_8005, UNIT_STATE_LIFE) + _____5B9E_9645_5438_53D6
            )
        end
    end
    local _____653B_51FB_8303_56F4 = _____8BFB_53D6_5355_4F4D_653B_51FB_8303_56F4(_____65BD_6CD5_8005)
    if _____4E24_70B9_8DDD_79BB(
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D)
    ) <= _____653B_51FB_8303_56F4 then
        __TS__ArraySplice(ctx["吸引组"], _____7D22_5F15, 1)
        SetUnitPathing(_____5355_4F4D, true)
        if _____662F_654C_4EBA then
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = ____E_914D_7F6E["暗敌人命中特效"],
                X = GetUnitX(_____5355_4F4D),
                Y = GetUnitY(_____5355_4F4D),
                Z = _____5355_4F4D_5F53_524D_98DE_884C_9AD8_5EA6(_____5355_4F4D),
                ["缩放"] = getObjectPropertyRealSafe(
                    YDWE_OBJECT_TYPE_UNIT,
                    GetUnitTypeId(_____5355_4F4D),
                    "modelScale"
                ) or 1,
                ["持续秒"] = ____E_914D_7F6E["暗敌人命中特效持续秒"]
            })
            _____9020_6210W_4F24_5BB3(
                _____65BD_6CD5_8005,
                _____5355_4F4D,
                ____E_914D_7F6E["暗敌人伤害倍率"],
                DAMAGE_TYPE_SHADOW_STRIKE,
                false
            )
            local _____5F53_524D_751F_547D2 = GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE)
            if _____5F53_524D_751F_547D2 > 0 then
                _____9020_6210_6280_80FD_4F24_5BB3({
                    ["来源"] = _____65BD_6CD5_8005,
                    ["目标"] = _____5355_4F4D,
                    ["伤害"] = _____5F53_524D_751F_547D2 * ____E_914D_7F6E["暗敌人当前生命比例"],
                    ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = ____E_6280_80FDID,
                    ["标签"] = "阿伦劳特-E-裁决吸引",
                    ["参与技能伤害加成"] = true
                })
            end
            _____65BD_52A0_51CF_901F(
                _____65BD_6CD5_8005,
                _____5355_4F4D,
                ____E_914D_7F6E["暗减速比例"],
                ____E_914D_7F6E["暗减速持续秒"],
                "阿伦劳特-E-裁决吸引",
                "技能"
            )
        else
            local _____5F53_524D_901F_5EA6 = SOS_GetUnitSpeed(_____5355_4F4D)
            if _____5F53_524D_901F_5EA6 > 0 then
                SOS_SetUnitSpeed(_____5355_4F4D, _____5F53_524D_901F_5EA6 * (1 + ____E_914D_7F6E["暗加速比例"]), ____E_914D_7F6E["暗加速持续秒"])
            end
        end
    end
end
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
removePeriodicCallback = ____require_result_2.removePeriodicCallback
addDelayedCallback = ____require_result_2.addDelayedCallback
removeDelayedCallback = ____require_result_2.removeDelayedCallback
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_3["造成技能伤害"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
_____65BD_52A0_51CF_901F = ____require_result_4["施加减速"]
_____65BD_52A0_7729_6655 = ____require_result_4["施加眩晕"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
_____5F00_59CB_51FB_9000 = ____require_result_5["开始击退"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
getUnitsInRange = ____require_result_6.getUnitsInRange
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_7["读取单位攻击力"]
_____5355_4F4D_5B58_6D3B = ____require_result_7["单位存活"]
local ____require_result_8 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_8.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_8.YDUserDataSetSafe
getObjectPropertyRealSafe = ____require_result_8.getObjectPropertyRealSafe
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_9["创建点特效"]
createTimedUnitEffect = ____require_result_9.createTimedUnitEffect
local ____require_result_10 = require("lib.扩展函数.Star扩展函数.Star扩展库.05．移动速度突破系统")
SOS_GetUnitSpeed = ____require_result_10.SOS_GetUnitSpeed
SOS_SetUnitSpeed = ____require_result_10.SOS_SetUnitSpeed
local SOS_UnSetUnitSpeed = ____require_result_10.SOS_UnSetUnitSpeed
local jass = require("jass.common")
local jassGlobals = require("jass.globals")
local ____require_result_11 = require("lib.扩展函数.BJ函数.14．音效函数")
PlaySoundOnUnitBJ = ____require_result_11.PlaySoundOnUnitBJ
gg_snd_LifeDrain = jassGlobals.gg_snd_LifeDrain
local GetHandleId = jass.GetHandleId
GetUnitTypeId = jass.GetUnitTypeId
GetOwningPlayer = jass.GetOwningPlayer
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFacing = jass.GetUnitFacing
GetUnitFlyHeight = jass.GetUnitFlyHeight
SetUnitFlyHeight = jass.SetUnitFlyHeight
GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight
SetUnitPosition = jass.SetUnitPosition
SetUnitPathing = jass.SetUnitPathing
PauseUnit = jass.PauseUnit
SetUnitTimeScale = jass.SetUnitTimeScale
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
SetUnitVertexColor = jass.SetUnitVertexColor
CreateUnit = jass.CreateUnit
local RemoveUnit = jass.RemoveUnit
UnitApplyTimedLife = jass.UnitApplyTimedLife
IsUnitEnemy = jass.IsUnitEnemy
GetUnitState = jass.GetUnitState
SetUnitState = jass.SetUnitState
AddLightning = jass.AddLightning
DestroyLightning = jass.DestroyLightning
DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
YDWE_OBJECT_TYPE_UNIT = 2
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_ATTACK = jass.ConvertUnitState(21)
Cos = jass.Cos
Sin = jass.Sin
R2I = jass.R2I
____E_6280_80FDID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["E技能ID"])
_____6B8B_5F71_5355_4F4DID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.E["残影单位ID"])
_____9650_65F6_751F_547DBuffID = stringToFourCCSafe("BHwe")
local function _____53D6_8F83_5927_503C(a, b)
    return a > b and a or b
end
_____89D2_5EA6_8F6C_5F27_5EA6 = 0.017453292519943295
local function _____5149_51B2_950B_5468_671F_56DE_8C03(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    _____5149_51B2_950B_5468_671F(ctx)
end
--- 光形态：开始冲锋
local function _____5149_5F62_6001_65BD_653E(_____65BD_6CD5_8005, _____76EE_6807)
    local ____E_914D_7F6E = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.E
    local ctx = {
        ["施法者"] = _____65BD_6CD5_8005,
        ["目标"] = _____76EE_6807,
        ["循环实数"] = 0,
        ["次数"] = 1,
        ["倍数"] = 1,
        ["天堂审判开启"] = false,
        ["周期ID"] = 0,
        ["结算延迟ID"] = 0,
        ["结算中"] = false,
        ["已结束"] = false
    }
    local _____8DDD_79BB = _____4E24_70B9_8DDD_79BB(
        GetUnitX(_____65BD_6CD5_8005),
        GetUnitY(_____65BD_6CD5_8005),
        GetUnitX(_____76EE_6807),
        GetUnitY(_____76EE_6807)
    )
    ctx["次数"] = _____53D6_8F83_5927_503C(1, _____8DDD_79BB / ____E_914D_7F6E["冲锋每tick距离"])
    ctx["倍数"] = 1 / ctx["次数"]
    if _____8DDD_79BB < _____8BFB_53D6_5355_4F4D_653B_51FB_8303_56F4(_____65BD_6CD5_8005) then
        ctx["循环实数"] = ____E_914D_7F6E["光冲锋次数上限"]
    end
    PauseUnit(_____65BD_6CD5_8005, true)
    SetUnitPathing(_____65BD_6CD5_8005, false)
    ctx["天堂审判开启"] = _____62E5_6709_5929_5802_547C_5524(_____65BD_6CD5_8005)
    if not ctx["天堂审判开启"] then
        SetUnitAnimationByIndex(_____65BD_6CD5_8005, 6)
        SetUnitTimeScale(_____65BD_6CD5_8005, 2.1)
    else
        SetUnitAnimationByIndex(_____65BD_6CD5_8005, 3)
        SetUnitTimeScale(_____65BD_6CD5_8005, 1)
    end
    ctx["周期ID"] = addPeriodicCallback(
        _____53D6_56DB_820D_4E94_5165_6574_6570(____E_914D_7F6E["冲锋周期秒"] * 1000),
        _____5149_51B2_950B_5468_671F_56DE_8C03,
        ctx
    )
end
local function _____6697_5438_5F15_5468_671F_56DE_8C03(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    _____6697_5438_5F15_5468_671F(ctx)
end
--- 暗形态：开始吸引
local function _____6697_5F62_6001_65BD_653E(_____65BD_6CD5_8005, _____76EE_6807)
    local ____E_914D_7F6E = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.E
    local _____5438_5F15_7EC4 = __TS__ArrayFilter(
        getUnitsInRange(
            GetUnitX(_____76EE_6807),
            GetUnitY(_____76EE_6807),
            ____E_914D_7F6E["暗收集范围"]
        ),
        function(____, u)
            if not _____662F_6709_6548_76EE_6807(u) then
                return false
            end
            if u == _____65BD_6CD5_8005 then
                return false
            end
            return true
        end
    )
    if #_____5438_5F15_7EC4 == 0 then
        return
    end
    local _____73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_8005)
    local _____6BCF_79D2_5438_53D6_503C = YDUserDataGetSafe("player", _____73A9_5BB6, "总生命恢复", "real") or 0
    local ctx = {
        ["施法者"] = _____65BD_6CD5_8005,
        ["目标"] = _____76EE_6807,
        ["吸引组"] = _____5438_5F15_7EC4,
        ["每秒吸取值"] = _____6BCF_79D2_5438_53D6_503C,
        ["循环实数"] = 0,
        ["周期ID"] = 0,
        ["已结束"] = false
    }
    ctx["周期ID"] = addPeriodicCallback(
        _____53D6_56DB_820D_4E94_5165_6574_6570(____E_914D_7F6E["暗周期秒"] * 1000),
        _____6697_5438_5F15_5468_671F_56DE_8C03,
        ctx
    )
end
--- 入口：A0D4 施放触发（物编 E 键 = 光之裁决/裁决吸引）
____exports["on阿伦劳特E"] = function(_____65BD_6CD5_5355_4F4D, abilityId)
    if abilityId ~= ____E_6280_80FDID then
        return
    end
    if not _____662F_963F_4F26_52B3_7279_82F1_96C4(_____65BD_6CD5_5355_4F4D) then
        return
    end
    local _____76EE_6807_5355_4F4D = jass.GetSpellTargetUnit()
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 or not _____5355_4F4D_5B58_6D3B(_____76EE_6807_5355_4F4D) then
        return
    end
    if _____662F_5149_5F62_6001(_____65BD_6CD5_5355_4F4D) then
        if IsUnitEnemy(
            _____76EE_6807_5355_4F4D,
            GetOwningPlayer(_____65BD_6CD5_5355_4F4D)
        ) then
            _____5149_5F62_6001_65BD_653E(_____65BD_6CD5_5355_4F4D, _____76EE_6807_5355_4F4D)
        end
        return
    end
    if _____662F_6697_5F62_6001(_____65BD_6CD5_5355_4F4D) then
        _____6697_5F62_6001_65BD_653E(_____65BD_6CD5_5355_4F4D, _____76EE_6807_5355_4F4D)
    end
end
registerSpellEffectListener(____exports["on阿伦劳特E"])
return ____exports
