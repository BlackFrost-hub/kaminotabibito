local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.02．蕾米莉亚.00．配置")
local _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["蕾米莉亚单位技能配置"]
local ____03_FF0E_857E_7C73_8389_4E9A = require("系统.05．Buff系统.03．Buff表.02．英雄.03．蕾米莉亚")
local _____857E_7C73_8389_4E9ABuffID = ____03_FF0E_857E_7C73_8389_4E9A["蕾米莉亚BuffID"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_0["注册单位技能壳监听"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_1["创建单位并登记排泄安全"]
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____7ACB_5373_79FB_9664_5355_4F4D_5E76_6CE8_9500_6392_6CC4_76D1_542C = ____require_result_2["立即移除单位并注销排泄监听"]
local ____require_result_3 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_3.SelectUnitForPlayerSingle
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local removeDelayedCallback = ____require_result_4.removeDelayedCallback
local addPeriodicCallback = ____require_result_4.addPeriodicCallback
local removePeriodicCallback = ____require_result_4.removePeriodicCallback
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_5.registerDeathListener
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_6["暂停并设置无敌安全"]
local _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168 = ____require_result_6["解除暂停并取消无敌安全"]
local ____require_result_7 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_7["获取范围敌军"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_7["读取单位攻击力"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_8["单位存活"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____require_result_8["读取单位最大生命"]
local ____require_result_9 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_9["造成批量AOE技能伤害"]
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_9["创建独立技能伤害实例"]
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_9["结束独立技能伤害实例"]
local ____require_result_10 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_10["施加快速减速Buff"]
local ____require_result_11 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_11.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_11["移除单位指定Buff"]
local ____require_result_12 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_12["创建点特效"]
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_12["创建单位坐标跟随特效"]
local _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_12["销毁单位坐标跟随特效"]
local ____require_result_13 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_13.Sound3DII_UnitPlayReuse
local ____require_result_14 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_14.stringToFourCCSafe
local ____E_914D_7F6E = _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.E
local ____stringToFourCCSafe_16 = stringToFourCCSafe
local ____E_914D_7F6E__6280_80FDID_15 = ____E_914D_7F6E["技能ID"]
if ____E_914D_7F6E__6280_80FDID_15 == nil then
    ____E_914D_7F6E__6280_80FDID_15 = "0002"
end
local ____E_6280_80FDID = ____stringToFourCCSafe_16(____E_914D_7F6E__6280_80FDID_15)
local _____5355_4F4D_7C7B_578BID = _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"]
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH
local GetHandleId = jass.GetHandleId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetOwningPlayer = jass.GetOwningPlayer
local UnitAddAbility = jass.UnitAddAbility
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitAnimation = jass.SetUnitAnimation
local ShowUnit = jass.ShowUnit
local GetRandomInt = jass.GetRandomInt
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local ____stringToFourCCSafe_18 = stringToFourCCSafe
local ____E_914D_7F6E__66FF_8EAB_5355_4F4DID_17 = ____E_914D_7F6E["替身单位ID"]
if ____E_914D_7F6E__66FF_8EAB_5355_4F4DID_17 == nil then
    ____E_914D_7F6E__66FF_8EAB_5355_4F4DID_17 = "e08O"
end
local _____66FF_8EAB_5355_4F4D_7C7B_578BID = ____stringToFourCCSafe_18(____E_914D_7F6E__66FF_8EAB_5355_4F4DID_17)
local ____stringToFourCCSafe_20 = stringToFourCCSafe
local ____E_914D_7F6E__66FF_8EAB_6280_80FDID_19 = ____E_914D_7F6E["替身技能ID"]
if ____E_914D_7F6E__66FF_8EAB_6280_80FDID_19 == nil then
    ____E_914D_7F6E__66FF_8EAB_6280_80FDID_19 = "A0LG"
end
local _____66FF_8EAB_6280_80FDID = ____stringToFourCCSafe_20(____E_914D_7F6E__66FF_8EAB_6280_80FDID_19)
local _____4E0A_4E0B_6587_8868 = {}
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    return (unit == nil or unit == 0) and 0 or (GetHandleId(unit) or 0)
end
local _____8840_96FE_66FF_8EAB_672C_4F53_8868 = {}
____exports["获取血雾本体"] = function(unit)
    return _____8840_96FE_66FF_8EAB_672C_4F53_8868[_____53D6_5355_4F4D_53E5_67C4ID(unit)]
end
local function _____83B7_53D6_6216_521B_5EFAE_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if id == 0 then
        return nil
    end
    local old = _____4E0A_4E0B_6587_8868[id]
    if old ~= nil then
        return old
    end
    local created = {
        ["施法者"] = unit,
        ["延迟回调ID"] = 0,
        ["周期回调ID"] = 0,
        ["伤害攻击力快照"] = 0,
        ["周期次数"] = 0,
        ["已启动"] = false,
        ["已暂停"] = false,
        ["目标属性记录"] = {}
    }
    _____4E0A_4E0B_6587_8868[id] = created
    return created
end
local function _____76EE_6807_5141_8BB8E_4F24_5BB3(target)
    return _____5355_4F4D_5B58_6D3B(target) and not IsUnitType(target, UNIT_TYPE_ANCIENT) and not IsUnitType(target, UNIT_TYPE_MECHANICAL) and not IsUnitType(target, UNIT_TYPE_STRUCTURE)
end
local function _____51C6_5907E_6279_91CF_76EE_6807_4F24_5BB3(target, _index, variable)
    local context = variable
    if context == nil or not _____76EE_6807_5141_8BB8E_4F24_5BB3(target) then
        return nil
    end
    local fire = GetRandomInt(1, 2) == 1
    local targetId = GetHandleId(target) or 0
    if targetId ~= 0 then
        context["目标属性记录"][targetId] = fire
    end
    local ____fire_21
    if fire then
        ____fire_21 = ____E_914D_7F6E["表现"]["火属性"]
    else
        ____fire_21 = ____E_914D_7F6E["表现"]["暗属性"]
    end
    local effect = ____fire_21
    if fire then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = effect["特效模型路径"],
            X = GetUnitX(target),
            Y = GetUnitY(target),
            ["持续秒"] = effect["特效持续秒"]
        })
    end
    _____65BD_52A0_5FEB_901F_51CF_901FBuff(
        context["施法者"],
        target,
        0,
        0.3,
        0.6,
        "蕾米莉亚-E-血雾",
        "技能"
    )
    local ____context__4F24_5BB3_653B_51FB_529B_5FEB_7167_23 = context["伤害攻击力快照"]
    local ____E_914D_7F6E__5355_6B21_4F24_5BB3_653B_51FB_529B_500D_7387_22 = ____E_914D_7F6E["单次伤害攻击力倍率"]
    if ____E_914D_7F6E__5355_6B21_4F24_5BB3_653B_51FB_529B_500D_7387_22 == nil then
        ____E_914D_7F6E__5355_6B21_4F24_5BB3_653B_51FB_529B_500D_7387_22 = 0.1
    end
    local ____temp_25 = ____context__4F24_5BB3_653B_51FB_529B_5FEB_7167_23 * ____E_914D_7F6E__5355_6B21_4F24_5BB3_653B_51FB_529B_500D_7387_22
    local ____fire_24
    if fire then
        ____fire_24 = DAMAGE_TYPE_FIRE
    else
        ____fire_24 = DAMAGE_TYPE_SHADOW_STRIKE
    end
    return {
        ["伤害"] = ____temp_25,
        ["伤害类型"] = ____fire_24,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_METAL_HEAVY_BASH
    }
end
local function _____5904_7406E_76EE_6807_7ED3_7B97_540E(target, _index, ______6210_529F, variable)
    local context = variable
    if context == nil then
        return
    end
    local targetId = GetHandleId(target) or 0
    local fire = context["目标属性记录"][targetId]
    if fire == false then
        local effect = ____E_914D_7F6E["表现"]["暗属性"]
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = effect["特效模型路径"],
            X = GetUnitX(target),
            Y = GetUnitY(target),
            ["持续秒"] = effect["特效持续秒"]
        })
    end
    if targetId ~= 0 then
        __TS__Delete(context["目标属性记录"], targetId)
    end
end
local function _____6E05_7406E_4E0A_4E0B_6587(context)
    if context["延迟回调ID"] ~= 0 then
        removeDelayedCallback(context["延迟回调ID"])
        context["延迟回调ID"] = 0
    end
    if context["周期回调ID"] ~= 0 then
        removePeriodicCallback(context["周期回调ID"])
        context["周期回调ID"] = 0
    end
    if context["已启动"] then
        local ____temp_26
        if context["替身"] ~= nil and context["替身"] ~= 0 then
            ____temp_26 = context["替身"]
        else
            ____temp_26 = context["施法者"]
        end
        local buffTarget = ____temp_26
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(buffTarget, _____857E_7C73_8389_4E9ABuffID["血雾形态"])
        ShowUnit(context["施法者"], true)
        local maxLife = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(context["施法者"])
        local life = jass.GetUnitState(context["施法者"], jass.UNIT_STATE_LIFE) or 0
        local endVoice = ____E_914D_7F6E["结束语音"]
        local ____temp_28 = maxLife > 0
        if ____temp_28 then
            local ____E_914D_7F6E__7ED3_675F_751F_547D_6BD4_4F8B_9608_503C_27 = ____E_914D_7F6E["结束生命比例阈值"]
            if ____E_914D_7F6E__7ED3_675F_751F_547D_6BD4_4F8B_9608_503C_27 == nil then
                ____E_914D_7F6E__7ED3_675F_751F_547D_6BD4_4F8B_9608_503C_27 = 0.85
            end
            ____temp_28 = life >= maxLife * ____E_914D_7F6E__7ED3_675F_751F_547D_6BD4_4F8B_9608_503C_27
        end
        local ____temp_28_32 = ____temp_28
        if ____temp_28_32 then
            local ____opt_result_31
            if endVoice ~= nil then
                ____opt_result_31 = endVoice["路径"]
            end
            ____temp_28_32 = ____opt_result_31 ~= nil
        end
        if ____temp_28_32 and endVoice["路径"] ~= "" then
            Sound3DII_UnitPlayReuse(endVoice["路径"], context["施法者"], endVoice["裁断距离"])
        end
        context["已启动"] = false
    end
    if context["替身"] ~= nil and context["替身"] ~= 0 then
        __TS__Delete(
            _____8840_96FE_66FF_8EAB_672C_4F53_8868,
            _____53D6_5355_4F4D_53E5_67C4ID(context["替身"])
        )
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_6CE8_9500_6392_6CC4_76D1_542C(context["替身"])
        context["替身"] = nil
    end
    SelectUnitForPlayerSingle(
        context["施法者"],
        GetOwningPlayer(context["施法者"])
    )
    if context["已暂停"] then
        local ____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168_35 = _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168
        local ____context__65BD_6CD5_8005_34 = context["施法者"]
        local ____E_914D_7F6E__6682_505C_6765_6E90_33 = ____E_914D_7F6E["暂停来源"]
        if ____E_914D_7F6E__6682_505C_6765_6E90_33 == nil then
            ____E_914D_7F6E__6682_505C_6765_6E90_33 = "蕾米莉亚-E-血雾形态"
        end
        ____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168_35(____context__65BD_6CD5_8005_34, ____E_914D_7F6E__6682_505C_6765_6E90_33)
        context["已暂停"] = false
    end
    SetUnitTimeScale(context["施法者"], 1)
    _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
    context["技能实例ID"] = nil
    context["目标属性记录"] = {}
    local id = _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
    if id ~= 0 and _____4E0A_4E0B_6587_8868[id] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, id)
    end
end
local function _____857E_7C73_8389_4E9AE_5468_671FTick(variable)
    local context = variable
    if context == nil or not context["已启动"] then
        return
    end
    local ____temp_38 = not _____5355_4F4D_5B58_6D3B(context["施法者"])
    if not ____temp_38 then
        local ____context__5468_671F_6B21_6570_37 = context["周期次数"]
        local ____E_914D_7F6E__6301_7EED_6B21_6570_36 = ____E_914D_7F6E["持续次数"]
        if ____E_914D_7F6E__6301_7EED_6B21_6570_36 == nil then
            ____E_914D_7F6E__6301_7EED_6B21_6570_36 = 10
        end
        ____temp_38 = ____context__5468_671F_6B21_6570_37 >= ____E_914D_7F6E__6301_7EED_6B21_6570_36
    end
    if ____temp_38 then
        _____6E05_7406E_4E0A_4E0B_6587(context)
        return
    end
    local ____opt_39 = ____E_914D_7F6E["周期语音"]
    if ____opt_39 ~= nil then
        ____opt_39 = ____opt_39["路径"]
    end
    if ____opt_39 ~= nil and ____E_914D_7F6E["周期语音"]["路径"] ~= "" then
        Sound3DII_UnitPlayReuse(____E_914D_7F6E["周期语音"]["路径"], context["施法者"], ____E_914D_7F6E["周期语音"]["裁断距离"])
    end
    local ____temp_41
    if context["替身"] ~= nil and context["替身"] ~= 0 then
        ____temp_41 = context["替身"]
    else
        ____temp_41 = context["施法者"]
    end
    local center = ____temp_41
    SetUnitX(
        context["施法者"],
        GetUnitX(center)
    )
    SetUnitY(
        context["施法者"],
        GetUnitY(center)
    )
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = ____E_914D_7F6E["表现"]["周期爆炸"]["模型路径"],
        X = GetUnitX(center),
        Y = GetUnitY(center),
        ["Z轴角度"] = 270,
        ["缩放"] = ____E_914D_7F6E["表现"]["周期爆炸"]["缩放"],
        ["持续秒"] = ____E_914D_7F6E["表现"]["周期爆炸"]["持续秒"]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = ____E_914D_7F6E["表现"]["周期血雾"]["模型路径"],
        X = GetUnitX(center),
        Y = GetUnitY(center),
        ["Z轴角度"] = 270,
        ["缩放"] = ____E_914D_7F6E["表现"]["周期血雾"]["缩放"],
        ["持续秒"] = ____E_914D_7F6E["表现"]["周期血雾"]["持续秒"]
    })
    context["周期次数"] = context["周期次数"] + 1
    local ____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3_46 = _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3
    local ____context__65BD_6CD5_8005_45 = context["施法者"]
    local ____83B7_53D6_8303_56F4_654C_519B_44 = _____83B7_53D6_8303_56F4_654C_519B
    local ____array_43 = __TS__SparseArrayNew(
        context["施法者"],
        GetUnitX(center),
        GetUnitY(center)
    )
    local ____E_914D_7F6E__4F24_5BB3_8303_56F4_42 = ____E_914D_7F6E["伤害范围"]
    if ____E_914D_7F6E__4F24_5BB3_8303_56F4_42 == nil then
        ____E_914D_7F6E__4F24_5BB3_8303_56F4_42 = 600
    end
    __TS__SparseArrayPush(____array_43, ____E_914D_7F6E__4F24_5BB3_8303_56F4_42)
    ____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3_46({
        ["来源"] = ____context__65BD_6CD5_8005_45,
        ["目标列表"] = ____83B7_53D6_8303_56F4_654C_519B_44(__TS__SparseArraySpread(____array_43)),
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____E_6280_80FDID,
        ["技能实例ID"] = context["技能实例ID"],
        ["伤害形态"] = "AOE",
        ["每目标处理器"] = _____51C6_5907E_6279_91CF_76EE_6807_4F24_5BB3,
        ["每目标结算后处理器"] = _____5904_7406E_76EE_6807_7ED3_7B97_540E,
        ["变量"] = context
    })
end
local function _____857E_7C73_8389_4E9AE_5EF6_8FDF_542F_52A8(variable)
    local context = variable
    if context == nil then
        return
    end
    context["延迟回调ID"] = 0
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____6E05_7406E_4E0A_4E0B_6587(context)
        return
    end
    context["已启动"] = true
    context["替身"] = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        GetOwningPlayer(context["施法者"]),
        _____66FF_8EAB_5355_4F4D_7C7B_578BID,
        GetUnitX(context["施法者"]),
        GetUnitY(context["施法者"]),
        GetUnitFacing(context["施法者"])
    )
    if context["替身"] ~= nil and context["替身"] ~= 0 then
        UnitAddAbility(context["替身"], _____66FF_8EAB_6280_80FDID)
        _____8840_96FE_66FF_8EAB_672C_4F53_8868[_____53D6_5355_4F4D_53E5_67C4ID(context["替身"])] = context["施法者"]
        SelectUnitForPlayerSingle(
            context["替身"],
            GetOwningPlayer(context["施法者"])
        )
    end
    ShowUnit(context["施法者"], false)
    local ____opt_47 = ____E_914D_7F6E["启动语音"]
    if ____opt_47 ~= nil then
        ____opt_47 = ____opt_47["路径"]
    end
    if ____opt_47 ~= nil and ____E_914D_7F6E["启动语音"]["路径"] ~= "" then
        Sound3DII_UnitPlayReuse(____E_914D_7F6E["启动语音"]["路径"], context["施法者"], ____E_914D_7F6E["启动语音"]["裁断距离"])
    end
    local ____temp_49
    if context["替身"] ~= nil and context["替身"] ~= 0 then
        ____temp_49 = context["替身"]
    else
        ____temp_49 = context["施法者"]
    end
    local buffTarget = ____temp_49
    local ____registerManualBuff_53 = registerManualBuff
    local ____857E_7C73_8389_4E9ABuffID__8840_96FE_5F62_6001_52 = _____857E_7C73_8389_4E9ABuffID["血雾形态"]
    local ____E_914D_7F6E__6301_7EED_6B21_6570_50 = ____E_914D_7F6E["持续次数"]
    if ____E_914D_7F6E__6301_7EED_6B21_6570_50 == nil then
        ____E_914D_7F6E__6301_7EED_6B21_6570_50 = 10
    end
    local ____E_914D_7F6E__5468_671F_95F4_9694_6BEB_79D2_51 = ____E_914D_7F6E["周期间隔毫秒"]
    if ____E_914D_7F6E__5468_671F_95F4_9694_6BEB_79D2_51 == nil then
        ____E_914D_7F6E__5468_671F_95F4_9694_6BEB_79D2_51 = 300
    end
    ____registerManualBuff_53(
        buffTarget,
        ____857E_7C73_8389_4E9ABuffID__8840_96FE_5F62_6001_52,
        ____E_914D_7F6E__6301_7EED_6B21_6570_50 * ____E_914D_7F6E__5468_671F_95F4_9694_6BEB_79D2_51 / 1000 + 0.3,
        1,
        {sourceName = "蕾米莉亚-E-血雾形态"}
    )
    local ____addPeriodicCallback_55 = addPeriodicCallback
    local ____E_914D_7F6E__5468_671F_95F4_9694_6BEB_79D2_54 = ____E_914D_7F6E["周期间隔毫秒"]
    if ____E_914D_7F6E__5468_671F_95F4_9694_6BEB_79D2_54 == nil then
        ____E_914D_7F6E__5468_671F_95F4_9694_6BEB_79D2_54 = 300
    end
    context["周期回调ID"] = ____addPeriodicCallback_55(____E_914D_7F6E__5468_671F_95F4_9694_6BEB_79D2_54, _____857E_7C73_8389_4E9AE_5468_671FTick, context)
end
local function _____91CA_653E_857E_7C73_8389_4E9AE(context, caster, _____6280_80FD_5B9E_4F8BID)
    if context["延迟回调ID"] ~= 0 or context["已启动"] then
        return
    end
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID or _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["技能ID"] = ____E_6280_80FDID, ["来源类型"] = "单位技能", ["持续时间秒"] = 4.8})
    local level = GetUnitAbilityLevel(caster, ____E_6280_80FDID) or 1
    local ____context_59 = context
    local ____8BFB_53D6_5355_4F4D_653B_51FB_529B_result_58 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    local ____E_914D_7F6E__653B_51FB_529B_57FA_7840_500D_7387_56 = ____E_914D_7F6E["攻击力基础倍率"]
    if ____E_914D_7F6E__653B_51FB_529B_57FA_7840_500D_7387_56 == nil then
        ____E_914D_7F6E__653B_51FB_529B_57FA_7840_500D_7387_56 = 1.5
    end
    local ____E_914D_7F6E__653B_51FB_529B_6BCF_7EA7_500D_7387_57 = ____E_914D_7F6E["攻击力每级倍率"]
    if ____E_914D_7F6E__653B_51FB_529B_6BCF_7EA7_500D_7387_57 == nil then
        ____E_914D_7F6E__653B_51FB_529B_6BCF_7EA7_500D_7387_57 = 0.2
    end
    ____context_59["伤害攻击力快照"] = ____8BFB_53D6_5355_4F4D_653B_51FB_529B_result_58 * (____E_914D_7F6E__653B_51FB_529B_57FA_7840_500D_7387_56 + ____E_914D_7F6E__653B_51FB_529B_6BCF_7EA7_500D_7387_57 * level)
    local ____context_63 = context
    local ____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168_62 = _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168
    local ____caster_61 = caster
    local ____E_914D_7F6E__6682_505C_6765_6E90_60 = ____E_914D_7F6E["暂停来源"]
    if ____E_914D_7F6E__6682_505C_6765_6E90_60 == nil then
        ____E_914D_7F6E__6682_505C_6765_6E90_60 = "蕾米莉亚-E-血雾形态"
    end
    ____context_63["已暂停"] = ____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168_62(____caster_61, ____E_914D_7F6E__6682_505C_6765_6E90_60)
    local ____caster_65 = caster
    local ____E_914D_7F6E__52A8_4F5C_901F_5EA6_64 = ____E_914D_7F6E["动作速度"]
    if ____E_914D_7F6E__52A8_4F5C_901F_5EA6_64 == nil then
        ____E_914D_7F6E__52A8_4F5C_901F_5EA6_64 = 2
    end
    SetUnitTimeScale(____caster_65, ____E_914D_7F6E__52A8_4F5C_901F_5EA6_64)
    if context["已暂停"] and ____E_914D_7F6E["动作"] ~= nil and ____E_914D_7F6E["动作"] ~= "" then
        SetUnitAnimation(caster, ____E_914D_7F6E["动作"])
    end
    local ____context_68 = context
    local ____addDelayedCallback_67 = addDelayedCallback
    local ____E_914D_7F6E__5EF6_8FDF_542F_52A8_6BEB_79D2_66 = ____E_914D_7F6E["延迟启动毫秒"]
    if ____E_914D_7F6E__5EF6_8FDF_542F_52A8_6BEB_79D2_66 == nil then
        ____E_914D_7F6E__5EF6_8FDF_542F_52A8_6BEB_79D2_66 = 1000
    end
    ____context_68["延迟回调ID"] = ____addDelayedCallback_67(____E_914D_7F6E__5EF6_8FDF_542F_52A8_6BEB_79D2_66, _____857E_7C73_8389_4E9AE_5EF6_8FDF_542F_52A8, context)
end
local function _____857E_7C73_8389_4E9AE_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local context = _____4E0A_4E0B_6587_8868[_____53D6_5355_4F4D_53E5_67C4ID(dyingUnit)]
    if context ~= nil then
        _____6E05_7406E_4E0A_4E0B_6587(context)
    end
end
local function _____83B7_53D6E_4E0A_4E0B_6587(unit)
    return _____83B7_53D6_6216_521B_5EFAE_4E0A_4E0B_6587(unit)
end
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "蕾米莉亚-命运Miserable Fate（E）",
    ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
    ["技能ID"] = ____E_6280_80FDID,
    ["获取或创建上下文"] = _____83B7_53D6E_4E0A_4E0B_6587,
    ["释放技能"] = _____91CA_653E_857E_7C73_8389_4E9AE,
    ["创建独立技能实例"] = true,
    ["独立技能来源类型"] = "单位技能",
    ["技能实例持续时间秒"] = 4.8
})
if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
    _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(_____857E_7C73_8389_4E9AE_5355_4F4D_6B7B_4EA1)
end
return ____exports
