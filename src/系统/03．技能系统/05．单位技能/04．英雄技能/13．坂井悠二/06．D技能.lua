local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____6E05_9664_5355_4E2A_9F13_821E, _____6E05_7406D_4E0A_4E0B_6587, _____6E05_7406D_5230_671F, _____79FB_9664_5355_4F4D_6307_5B9ABuff, YDWESetUnitAbilityStateSafe, _____4E34_65F6_8C03_6574_653B_51FB, _____8C03_6574_73A9_5BB6_5C5E_6027, removeDelayedCallback, removePeriodicCallback, RemoveUnit, UnitRemoveAbility, SetUnitFlyHeight, DestroyEffect, stringToFourCC, GetUnitMoveSpeed, SetUnitMoveSpeed, _____914D_7F6E, ____E_6280_80FD_7C7B_578BID, ____D_65E5_5FD7_6A21_5757, _____4E0A_4E0B_6587_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.13．坂井悠二.00．配置")
local _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["坂井悠二技能配置"]
local ____05_FF0E_5742_4E95_60A0_4E8C = require("系统.05．Buff系统.03．Buff表.02．英雄.05．坂井悠二")
local _____5742_4E95_60A0_4E8CBuffID = ____05_FF0E_5742_4E95_60A0_4E8C["坂井悠二BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local ____02_FF0E_5355_4F4D_4E0E_8303_56F4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local _____83B7_53D6_5750_6807_8303_56F4_5355_4F4D_6309_7B5B_9009 = ____02_FF0E_5355_4F4D_4E0E_8303_56F4["获取坐标范围单位按筛选"]
local ____24_FF0E_6574_6570_4E0E_65F6_95F4_6362_7B97 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算")
local _____5411_4E0B_53D6_6574_6574_6570 = ____24_FF0E_6574_6570_4E0E_65F6_95F4_6362_7B97["向下取整整数"]
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享")
local _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6 = ____00_FF0E_5171_4EAB["确保单位可设置飞行高度"]
local ____04_FF0E_8C03_8BD5_8F93_51FA = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.04．调试输出")
local _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA = ____04_FF0E_8C03_8BD5_8F93_51FA["技能强制调试输出"]
function _____6E05_9664_5355_4E2A_9F13_821E(context, hid)
    local record = context["已鼓舞友军"][hid]
    if record == nil then
        return
    end
    __TS__Delete(context["已鼓舞友军"], hid)
    local unit = record["单位"]
    if unit == nil or unit == 0 then
        return
    end
    _____4E34_65F6_8C03_6574_653B_51FB(unit, -record["攻击加成"])
    SetUnitMoveSpeed(
        unit,
        GetUnitMoveSpeed(unit) - _____914D_7F6E["鼓舞"]["移动速度加值"]
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____5742_4E95_60A0_4E8CBuffID["D鼓舞"])
end
function _____6E05_7406D_4E0A_4E0B_6587(context)
    local caster = context["施法者"]
    if context["鼓舞回调ID"] ~= 0 then
        removePeriodicCallback(context["鼓舞回调ID"])
        context["鼓舞回调ID"] = 0
    end
    if context["马甲更新回调ID"] ~= 0 then
        removePeriodicCallback(context["马甲更新回调ID"])
        context["马甲更新回调ID"] = 0
    end
    if context["特效附加回调ID"] ~= 0 then
        removeDelayedCallback(context["特效附加回调ID"])
        context["特效附加回调ID"] = 0
    end
    if context["清理回调ID"] ~= 0 then
        removeDelayedCallback(context["清理回调ID"])
        context["清理回调ID"] = 0
    end
    if caster ~= nil and caster ~= 0 then
        if _____5355_4F4D_5B58_6D3B(caster) then
            SetUnitFlyHeight(caster, context["施法前英雄飞行高度"], 0)
            YDWESetUnitAbilityStateSafe(caster, ____E_6280_80FD_7C7B_578BID, 1, _____914D_7F6E["结束恢复E冷却秒"])
        end
        if context["暗属性伤害已应用"] then
            _____8C03_6574_73A9_5BB6_5C5E_6027(caster, "暗属性伤害", -_____914D_7F6E["期间"]["暗属性伤害"])
            context["暗属性伤害已应用"] = false
        end
        if context["移速最大化技能由D添加"] then
            UnitRemoveAbility(
                caster,
                stringToFourCC(_____914D_7F6E["期间"]["移速最大化技能ID"])
            )
            context["移速最大化技能由D添加"] = false
        end
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(caster, _____5742_4E95_60A0_4E8CBuffID["D暗属性加成"])
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(caster, _____5742_4E95_60A0_4E8CBuffID["D期间状态"])
    end
    for hidStr in pairs(context["已鼓舞友军"]) do
        _____6E05_9664_5355_4E2A_9F13_821E(
            context,
            __TS__Number(hidStr)
        )
    end
    if context["马甲一特效"] ~= nil and context["马甲一特效"] ~= 0 then
        DestroyEffect(context["马甲一特效"])
        context["马甲一特效"] = nil
    end
    if context["马甲一"] ~= nil and context["马甲一"] ~= 0 then
        RemoveUnit(context["马甲一"])
        context["马甲一"] = nil
    end
    do
        local i = 0
        while i < #context["马甲二参数"] do
            local _____53C2_6570 = context["马甲二参数"][i + 1]
            if _____53C2_6570["蛇身特效"] ~= nil and _____53C2_6570["蛇身特效"] ~= 0 then
                DestroyEffect(_____53C2_6570["蛇身特效"])
            end
            if _____53C2_6570["光束特效"] ~= nil and _____53C2_6570["光束特效"] ~= 0 then
                DestroyEffect(_____53C2_6570["光束特效"])
            end
            local _____9A6C_7532 = _____53C2_6570["马甲"]
            if _____9A6C_7532 ~= nil and _____9A6C_7532 ~= 0 then
                RemoveUnit(_____9A6C_7532)
            end
            i = i + 1
        end
    end
    context["马甲二参数"] = {}
    context["已鼓舞友军"] = {}
    _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(____D_65E5_5FD7_6A21_5757, "清理D上下文完成")
    context["已启动"] = false
    local id = _____53D6_5355_4F4DID(caster)
    if id ~= 0 and _____4E0A_4E0B_6587_8868[id] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, id)
    end
end
function _____6E05_7406D_5230_671F(context)
    local ctx = context
    if ctx ~= nil then
        _____6E05_7406D_4E0A_4E0B_6587(ctx)
    end
end
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDWESetUnitAbilityStateSafe = ____require_result_1.YDWESetUnitAbilityStateSafe
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
_____4E34_65F6_8C03_6574_653B_51FB = ____require_result_2["临时调整攻击"]
_____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_2["调整玩家属性"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
removeDelayedCallback = ____require_result_3.removeDelayedCallback
local addPeriodicCallback = ____require_result_3.addPeriodicCallback
removePeriodicCallback = ____require_result_3.removePeriodicCallback
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_4.registerDeathListener
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetOwningPlayer = jass.GetOwningPlayer
local GetHeroLevel = jass.GetHeroLevel
local GetHeroStr = jass.GetHeroStr
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local CreateUnit = jass.CreateUnit
RemoveUnit = jass.RemoveUnit
local UnitAddAbility = jass.UnitAddAbility
UnitRemoveAbility = jass.UnitRemoveAbility
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
SetUnitFlyHeight = jass.SetUnitFlyHeight
local ____jass_GetUnitFlyHeight_5 = jass.GetUnitFlyHeight
if ____jass_GetUnitFlyHeight_5 == nil then
    ____jass_GetUnitFlyHeight_5 = function(_u) return 0 end
end
local GetUnitFlyHeight = ____jass_GetUnitFlyHeight_5
local SetUnitScale = jass.SetUnitScale
local ____require_result_6 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitVertexColorBJ = ____require_result_6.SetUnitVertexColorBJ
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
DestroyEffect = jass.DestroyEffect
local DzSetUnitModel = japi.DzSetUnitModel
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
stringToFourCC = stringToFourCCSafe
local GetRandomReal = jass.GetRandomReal
local IsUnitType = jass.IsUnitType
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
GetUnitMoveSpeed = jass.GetUnitMoveSpeed
SetUnitMoveSpeed = jass.SetUnitMoveSpeed
local ConvertUnitState = jass.ConvertUnitState
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local GetUnitStateJapi = japi.GetUnitState
local UNIT_STATE_ATTACK1_BASE = ConvertUnitState(18)
_____914D_7F6E = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E.D
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E["单位类型ID"]
local ____D_6280_80FDID_5B57_7B26_4E32 = _____914D_7F6E["技能ID"]
____E_6280_80FD_7C7B_578BID = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E.E["技能类型ID"]
____D_65E5_5FD7_6A21_5757 = "坂井悠二D排查"
_____4E0A_4E0B_6587_8868 = {}
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____83B7_53D6D_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return nil
    end
    return _____4E0A_4E0B_6587_8868[id]
end
local function _____83B7_53D6_6216_521B_5EFAD_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return nil
    end
    local current = _____4E0A_4E0B_6587_8868[id]
    if current ~= nil then
        return current
    end
    local created = {
        ["施法者"] = unit,
        ["已启动"] = false,
        ["鼓舞回调ID"] = 0,
        ["马甲更新回调ID"] = 0,
        ["特效附加回调ID"] = 0,
        ["清理回调ID"] = 0,
        ["施法前英雄飞行高度"] = 0,
        ["马甲一"] = nil,
        ["马甲一特效"] = nil,
        ["马甲二参数"] = {},
        ["已鼓舞友军"] = {},
        ["暗属性伤害已应用"] = false,
        ["移速最大化技能由D添加"] = false,
        ["主周期计数"] = 0
    }
    _____4E0A_4E0B_6587_8868[id] = created
    return created
end
local function _____6267_884C_9F13_821E(context)
    local ctx = context
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6E05_7406D_4E0A_4E0B_6587(ctx)
        return
    end
    local _____8303_56F4 = _____914D_7F6E["鼓舞"]["范围"]
    for hidStr in pairs(ctx["已鼓舞友军"]) do
        local hid = __TS__Number(hidStr)
        local record = ctx["已鼓舞友军"][hid]
        if record ~= nil and not _____5355_4F4D_5B58_6D3B(record["单位"]) then
            _____6E05_9664_5355_4E2A_9F13_821E(ctx, hid)
        end
    end
    local _____53CB_519B_5217_8868 = _____83B7_53D6_5750_6807_8303_56F4_5355_4F4D_6309_7B5B_9009(
        GetUnitX(caster),
        GetUnitY(caster),
        _____8303_56F4,
        caster,
        {
            ["要求有效单位"] = true,
            ["允许建筑"] = false,
            ["允许机械"] = true,
            ["允许古树"] = true,
            ["允许无敌"] = true,
            ["排除自身"] = true,
            ["仅友军"] = true
        }
    )
    do
        local i = 0
        while i < #_____53CB_519B_5217_8868 do
            do
                local u = _____53CB_519B_5217_8868[i + 1]
                if u == nil or u == 0 then
                    goto __continue37
                end
                if not _____5355_4F4D_5B58_6D3B(u) then
                    goto __continue37
                end
                local hid = _____53D6_5355_4F4DID(u)
                if hid == 0 or ctx["已鼓舞友军"][hid] ~= nil then
                    goto __continue37
                end
                local _____653B_51FB_52A0_6210 = _____5411_4E0B_53D6_6574_6574_6570((__TS__Number(GetUnitStateJapi(u, UNIT_STATE_ATTACK1_BASE)) or 0) * _____914D_7F6E["鼓舞"]["攻击力基础倍率"])
                _____4E34_65F6_8C03_6574_653B_51FB(u, _____653B_51FB_52A0_6210)
                SetUnitMoveSpeed(
                    u,
                    GetUnitMoveSpeed(u) + _____914D_7F6E["鼓舞"]["移动速度加值"]
                )
                registerManualBuff(
                    u,
                    _____5742_4E95_60A0_4E8CBuffID["D鼓舞"],
                    _____914D_7F6E["持续秒"],
                    _____914D_7F6E["鼓舞"]["攻击力基础倍率"],
                    {["来源"] = caster, ["来源类型"] = "技能", ["标签"] = "坂井悠二-D-鼓舞"}
                )
                ctx["已鼓舞友军"][hid] = {["单位"] = u, ["攻击加成"] = _____653B_51FB_52A0_6210}
            end
            ::__continue37::
            i = i + 1
        end
    end
end
local function _____66F4_65B0D_9A6C_7532_7FA4(context)
    local ctx = context
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(____D_65E5_5FD7_6A21_5757, "主周期终止：施法者无效/死亡")
        _____6E05_7406D_4E0A_4E0B_6587(ctx)
        return
    end
    SetUnitFlyHeight(caster, ctx["施法前英雄飞行高度"] + _____914D_7F6E["英雄飞行高度增量"], 0)
    local _____9A6C_7532_4E00 = ctx["马甲一"]
    if _____9A6C_7532_4E00 ~= nil and _____9A6C_7532_4E00 ~= 0 then
        SetUnitX(
            _____9A6C_7532_4E00,
            GetUnitX(caster)
        )
        SetUnitY(
            _____9A6C_7532_4E00,
            GetUnitY(caster)
        )
        SetUnitFacing(
            _____9A6C_7532_4E00,
            GetUnitFacing(caster)
        )
    end
    if _____9A6C_7532_4E00 ~= nil and _____9A6C_7532_4E00 ~= 0 then
        local _____4E00X = GetUnitX(_____9A6C_7532_4E00)
        local _____4E00Y = GetUnitY(_____9A6C_7532_4E00)
        local _____4E00_9762_5411 = GetUnitFacing(_____9A6C_7532_4E00)
        do
            local i = 0
            while i < #ctx["马甲二参数"] do
                do
                    local _____53C2 = ctx["马甲二参数"][i + 1]
                    if _____53C2["马甲"] == nil or _____53C2["马甲"] == 0 then
                        goto __continue47
                    end
                    local _____89D2_5EA63 = _____4E00_9762_5411 + 180 + _____53C2["角度符号"] * _____53C2["角度"]
                    SetUnitX(
                        _____53C2["马甲"],
                        _____6781_5750_6807X(_____4E00X, _____89D2_5EA63, _____53C2["距离"])
                    )
                    SetUnitY(
                        _____53C2["马甲"],
                        _____6781_5750_6807Y(_____4E00Y, _____89D2_5EA63, _____53C2["距离"])
                    )
                    SetUnitFacing(_____53C2["马甲"], _____4E00_9762_5411 + _____53C2["面向角度"])
                end
                ::__continue47::
                i = i + 1
            end
        end
    end
    ctx["主周期计数"] = ctx["主周期计数"] + 1
    if ctx["主周期计数"] % 20 == 1 then
        local _____9A6C_7532_4E8C_5B58_6D3B_6570 = 0
        do
            local i = 0
            while i < #ctx["马甲二参数"] do
                if ctx["马甲二参数"][i + 1]["马甲"] ~= nil and ctx["马甲二参数"][i + 1]["马甲"] ~= 0 and _____5355_4F4D_5B58_6D3B(ctx["马甲二参数"][i + 1]["马甲"]) then
                    _____9A6C_7532_4E8C_5B58_6D3B_6570 = _____9A6C_7532_4E8C_5B58_6D3B_6570 + 1
                end
                i = i + 1
            end
        end
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
            ____D_65E5_5FD7_6A21_5757,
            "主周期",
            "计数",
            ctx["主周期计数"],
            "英雄高度",
            GetUnitFlyHeight(caster),
            "马甲一存活",
            ctx["马甲一"] ~= nil and ctx["马甲一"] ~= 0 and _____5355_4F4D_5B58_6D3B(ctx["马甲一"]),
            "马甲二存活",
            _____9A6C_7532_4E8C_5B58_6D3B_6570
        )
    end
end
local function _____5EF6_8FDF_9644_52A0D_9A6C_7532_7279_6548(context)
    local ctx = context
    if ctx == nil then
        return
    end
    ctx["特效附加回调ID"] = 0
    if not ctx["已启动"] or ctx["施法者"] == nil or ctx["施法者"] == 0 or not _____5355_4F4D_5B58_6D3B(ctx["施法者"]) then
        return
    end
    local _____9A6C_7532_4E00 = ctx["马甲一"]
    if _____9A6C_7532_4E00 ~= nil and _____9A6C_7532_4E00 ~= 0 and _____5355_4F4D_5B58_6D3B(_____9A6C_7532_4E00) then
        ctx["马甲一特效"] = AddSpecialEffectTarget(_____914D_7F6E["马甲一"]["特效"]["模型路径"], _____9A6C_7532_4E00, _____914D_7F6E["马甲一"]["特效"]["挂点"])
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
            ____D_65E5_5FD7_6A21_5757,
            "延迟附加马甲一特效",
            "模型",
            _____914D_7F6E["马甲一"]["特效"]["模型路径"],
            "特效句柄",
            ctx["马甲一特效"]
        )
    end
    local _____6210_529F_9A6C_7532_6570 = 0
    do
        local i = 0
        while i < #ctx["马甲二参数"] do
            do
                local _____9A6C_7532 = ctx["马甲二参数"][i + 1]["马甲"]
                if _____9A6C_7532 == nil or _____9A6C_7532 == 0 or not _____5355_4F4D_5B58_6D3B(_____9A6C_7532) then
                    goto __continue58
                end
                do
                    local j = 0
                    while j < #_____914D_7F6E["马甲二"]["特效"] do
                        local _____7279_6548_914D_7F6E = _____914D_7F6E["马甲二"]["特效"][j + 1]
                        local _____7279_6548_53E5_67C4 = AddSpecialEffectTarget(_____7279_6548_914D_7F6E["模型路径"], _____9A6C_7532, _____7279_6548_914D_7F6E["挂点"])
                        if j == 0 then
                            ctx["马甲二参数"][i + 1]["蛇身特效"] = _____7279_6548_53E5_67C4
                        elseif j == 1 then
                            ctx["马甲二参数"][i + 1]["光束特效"] = _____7279_6548_53E5_67C4
                        end
                        if i == 0 then
                            _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
                                ____D_65E5_5FD7_6A21_5757,
                                "延迟附加马甲二特效",
                                "模型",
                                _____7279_6548_914D_7F6E["模型路径"],
                                "特效句柄",
                                _____7279_6548_53E5_67C4
                            )
                        end
                        j = j + 1
                    end
                end
                _____6210_529F_9A6C_7532_6570 = _____6210_529F_9A6C_7532_6570 + 1
            end
            ::__continue58::
            i = i + 1
        end
    end
    _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
        ____D_65E5_5FD7_6A21_5757,
        "D马甲特效延迟附加完成",
        "等待秒",
        _____914D_7F6E["马甲模型刷新等待秒"],
        "蛇身马甲数",
        _____6210_529F_9A6C_7532_6570
    )
end
local function _____521B_5EFA_9A6C_7532(context)
    local caster = context["施法者"]
    local owner = GetOwningPlayer(caster)
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    local _____65BD_6CD5_8005_9762_5411 = GetUnitFacing(caster)
    local _____65BD_6CD5_524D_9AD8_5EA6 = context["施法前英雄飞行高度"]
    local _____4E00_56DBCC = stringToFourCC(_____914D_7F6E["马甲一"]["单位类型ID"])
    local _____9A6C_7532_4E00 = CreateUnit(
        owner,
        _____4E00_56DBCC,
        x,
        y,
        _____65BD_6CD5_8005_9762_5411
    )
    context["马甲一"] = _____9A6C_7532_4E00
    _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
        ____D_65E5_5FD7_6A21_5757,
        "创建马甲一",
        "四CC",
        _____4E00_56DBCC,
        "ID字符串",
        _____914D_7F6E["马甲一"]["单位类型ID"],
        "结果",
        _____9A6C_7532_4E00
    )
    if _____9A6C_7532_4E00 ~= nil and _____9A6C_7532_4E00 ~= 0 then
        DzSetUnitModel(_____9A6C_7532_4E00, _____914D_7F6E["马甲载体模型路径"])
        SetUnitState(_____9A6C_7532_4E00, UNIT_STATE_MAX_LIFE, _____914D_7F6E["马甲一"]["HP保障值"])
        SetUnitState(_____9A6C_7532_4E00, UNIT_STATE_LIFE, _____914D_7F6E["马甲一"]["HP保障值"])
        SetUnitAnimationByIndex(_____9A6C_7532_4E00, _____914D_7F6E["马甲一"]["动画编号"])
        SetUnitTimeScale(_____9A6C_7532_4E00, _____914D_7F6E["马甲一"]["时间缩放"])
        SetUnitScale(_____9A6C_7532_4E00, _____914D_7F6E["马甲一"]["缩放"], _____914D_7F6E["马甲一"]["缩放"], _____914D_7F6E["马甲一"]["缩放"])
        SetUnitVertexColorBJ(
            _____9A6C_7532_4E00,
            _____914D_7F6E["马甲一"]["颜色"]["红"],
            _____914D_7F6E["马甲一"]["颜色"]["绿"],
            _____914D_7F6E["马甲一"]["颜色"]["蓝"],
            _____914D_7F6E["马甲一"]["颜色"]["透明度"]
        )
        SetUnitFlyHeight(_____9A6C_7532_4E00, _____914D_7F6E["马甲一"]["飞行高度增量"] + _____65BD_6CD5_524D_9AD8_5EA6, 0)
        UnitAddAbility(
            _____9A6C_7532_4E00,
            stringToFourCC(_____914D_7F6E["马甲一"]["绑定技能1"])
        )
    end
    local _____4E8C_56DBCC = stringToFourCC(_____914D_7F6E["马甲二"]["单位类型ID"])
    do
        local i = 0
        while i < _____914D_7F6E["马甲二"]["数量"] do
            local _____521D_59CB = _____914D_7F6E["马甲二"]["初始"][i + 1]
            local _____8DDD_79BB
            local _____89D2_5EA6
            local _____9762_5411_89D2_5EA6
            if _____521D_59CB["距离"] ~= nil then
                _____8DDD_79BB = _____521D_59CB["距离"]
                local ____521D_59CB__89D2_5EA6_8 = _____521D_59CB["角度"]
                if ____521D_59CB__89D2_5EA6_8 == nil then
                    ____521D_59CB__89D2_5EA6_8 = 0
                end
                _____89D2_5EA6 = ____521D_59CB__89D2_5EA6_8
                local ____521D_59CB__9762_5411_89D2_5EA6_9 = _____521D_59CB["面向角度"]
                if ____521D_59CB__9762_5411_89D2_5EA6_9 == nil then
                    ____521D_59CB__9762_5411_89D2_5EA6_9 = 0
                end
                _____9762_5411_89D2_5EA6 = ____521D_59CB__9762_5411_89D2_5EA6_9
            else
                _____8DDD_79BB = 400 + GetRandomReal(200, 600)
                _____89D2_5EA6 = GetRandomReal(1, 60)
                local ____temp_10
                if _____521D_59CB["面向角度"] ~= nil then
                    ____temp_10 = _____521D_59CB["面向角度"]
                else
                    ____temp_10 = GetRandomReal(-90, 90)
                end
                _____9762_5411_89D2_5EA6 = ____temp_10
            end
            local _____89D2_5EA6_7B26_53F7 = _____89D2_5EA6 < 31 and 1 or -1
            local _____89D2_5EA63 = _____65BD_6CD5_8005_9762_5411 + 180 + _____89D2_5EA6_7B26_53F7 * _____89D2_5EA6
            local _____521D_59CBX = _____6781_5750_6807X(x, _____89D2_5EA63, _____8DDD_79BB)
            local _____521D_59CBY = _____6781_5750_6807Y(y, _____89D2_5EA63, _____8DDD_79BB)
            local _____9A6C_7532 = CreateUnit(
                owner,
                _____4E8C_56DBCC,
                _____521D_59CBX,
                _____521D_59CBY,
                _____65BD_6CD5_8005_9762_5411 + _____9762_5411_89D2_5EA6
            )
            local ____context__9A6C_7532_4E8C_53C2_6570_11 = context["马甲二参数"]
            ____context__9A6C_7532_4E8C_53C2_6570_11[#____context__9A6C_7532_4E8C_53C2_6570_11 + 1] = {
                ["马甲"] = _____9A6C_7532,
                ["距离"] = _____8DDD_79BB,
                ["角度"] = _____89D2_5EA6,
                ["角度符号"] = _____89D2_5EA6_7B26_53F7,
                ["面向角度"] = _____9762_5411_89D2_5EA6,
                ["蛇身特效"] = nil,
                ["光束特效"] = nil
            }
            _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
                ____D_65E5_5FD7_6A21_5757,
                "创建马甲二",
                "序号",
                i + 1,
                "结果",
                _____9A6C_7532,
                "距离",
                _____8DDD_79BB,
                "角度",
                _____89D2_5EA6,
                "符号",
                _____89D2_5EA6_7B26_53F7
            )
            if _____9A6C_7532 ~= nil and _____9A6C_7532 ~= 0 then
                DzSetUnitModel(_____9A6C_7532, _____914D_7F6E["马甲载体模型路径"])
                SetUnitState(_____9A6C_7532, UNIT_STATE_MAX_LIFE, _____914D_7F6E["马甲一"]["HP保障值"])
                SetUnitState(_____9A6C_7532, UNIT_STATE_LIFE, _____914D_7F6E["马甲一"]["HP保障值"])
                SetUnitAnimationByIndex(_____9A6C_7532, _____914D_7F6E["马甲二"]["动画编号"])
                SetUnitTimeScale(_____9A6C_7532, _____914D_7F6E["马甲二"]["时间缩放"])
                SetUnitScale(_____9A6C_7532, _____914D_7F6E["马甲二"]["缩放"], _____914D_7F6E["马甲二"]["缩放"], _____914D_7F6E["马甲二"]["缩放"])
                SetUnitVertexColorBJ(
                    _____9A6C_7532,
                    _____914D_7F6E["马甲二"]["颜色"]["红"],
                    _____914D_7F6E["马甲二"]["颜色"]["绿"],
                    _____914D_7F6E["马甲二"]["颜色"]["蓝"],
                    _____914D_7F6E["马甲二"]["颜色"]["透明度"]
                )
                SetUnitFlyHeight(_____9A6C_7532, _____914D_7F6E["马甲二"]["飞行高度增量"] + _____65BD_6CD5_524D_9AD8_5EA6, 0)
            end
            i = i + 1
        end
    end
    context["特效附加回调ID"] = addDelayedCallback(_____914D_7F6E["马甲模型刷新等待秒"] * 1000, _____5EF6_8FDF_9644_52A0D_9A6C_7532_7279_6548, context)
end
local function _____91CA_653ED_6280_80FD(context, caster, _____6280_80FD_5B9E_4F8BID)
    _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
        ____D_65E5_5FD7_6A21_5757,
        "释放D入口",
        "施法者",
        caster,
        "实例ID",
        _____6280_80FD_5B9E_4F8BID,
        "已启动",
        context["已启动"]
    )
    if context["已启动"] then
        return
    end
    local _____7B49_7EA7 = GetHeroLevel(caster)
    local _____529B_91CF = GetHeroStr(caster, true)
    if _____7B49_7EA7 < _____914D_7F6E["条件"]["最低英雄等级"] or _____529B_91CF <= _____914D_7F6E["条件"]["最低力量"] then
        _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
            ____D_65E5_5FD7_6A21_5757,
            "条件不满足被拒",
            "等级",
            _____7B49_7EA7,
            "需要",
            _____914D_7F6E["条件"]["最低英雄等级"],
            "力量",
            _____529B_91CF,
            "需要大于",
            _____914D_7F6E["条件"]["最低力量"]
        )
        return
    end
    context["已启动"] = true
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["施法前英雄飞行高度"] = GetUnitFlyHeight(caster)
    _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(caster)
    SetUnitFlyHeight(caster, context["施法前英雄飞行高度"] + _____914D_7F6E["英雄飞行高度增量"], 0)
    _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
        ____D_65E5_5FD7_6A21_5757,
        "飞行启用",
        "施法前高度",
        context["施法前英雄飞行高度"],
        "目标高度",
        context["施法前英雄飞行高度"] + _____914D_7F6E["英雄飞行高度增量"],
        "当前高度",
        GetUnitFlyHeight(caster)
    )
    registerManualBuff(
        caster,
        _____5742_4E95_60A0_4E8CBuffID["D期间状态"],
        _____914D_7F6E["持续秒"],
        1,
        {["来源"] = caster, ["来源类型"] = "技能", ["标签"] = "坂井悠二-D-状态"}
    )
    _____8C03_6574_73A9_5BB6_5C5E_6027(caster, "暗属性伤害", _____914D_7F6E["期间"]["暗属性伤害"])
    context["暗属性伤害已应用"] = true
    registerManualBuff(
        caster,
        _____5742_4E95_60A0_4E8CBuffID["D暗属性加成"],
        _____914D_7F6E["持续秒"],
        _____914D_7F6E["期间"]["暗属性伤害"],
        {["来源"] = caster, ["来源类型"] = "技能", ["标签"] = "坂井悠二-D-暗属性"}
    )
    YDWESetUnitAbilityStateSafe(caster, ____E_6280_80FD_7C7B_578BID, 1, 0)
    local _____79FB_901F_6700_5927_5316_6280_80FDID = stringToFourCC(_____914D_7F6E["期间"]["移速最大化技能ID"])
    if GetUnitAbilityLevel(caster, _____79FB_901F_6700_5927_5316_6280_80FDID) <= 0 then
        context["移速最大化技能由D添加"] = UnitAddAbility(caster, _____79FB_901F_6700_5927_5316_6280_80FDID)
    end
    _____521B_5EFA_9A6C_7532(context)
    context["鼓舞回调ID"] = addPeriodicCallback(_____914D_7F6E["鼓舞"]["更新周期秒"] * 1000, _____6267_884C_9F13_821E, context)
    _____6267_884C_9F13_821E(context)
    context["马甲更新回调ID"] = addPeriodicCallback(_____914D_7F6E["马甲二"]["更新周期秒"] * 1000, _____66F4_65B0D_9A6C_7532_7FA4, context)
    context["清理回调ID"] = addDelayedCallback(_____914D_7F6E["持续秒"] * 1000, _____6E05_7406D_5230_671F, context)
    _____6280_80FD_5F3A_5236_8C03_8BD5_8F93_51FA(
        ____D_65E5_5FD7_6A21_5757,
        "启动完成",
        "鼓舞回调ID",
        context["鼓舞回调ID"],
        "主周期回调ID",
        context["马甲更新回调ID"],
        "清理回调ID",
        context["清理回调ID"]
    )
end
local function ____D_53EF_91CA_653E(context)
    return not context["已启动"] and context["鼓舞回调ID"] == 0
end
local function ____D_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local context = _____83B7_53D6D_4E0A_4E0B_6587(dyingUnit)
    if context ~= nil then
        _____6E05_7406D_4E0A_4E0B_6587(context)
    end
end
____exports["注册坂井悠二D"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "坂井悠二-祭礼之蛇（D）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = ____D_6280_80FDID_5B57_7B26_4E32,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAD_4E0A_4E0B_6587,
        ["可释放"] = ____D_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653ED_6280_80FD,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____914D_7F6E["持续秒"] + 1
    })
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____D_5355_4F4D_6B7B_4EA1)
    end
end
____exports["注册坂井悠二D"]()
____exports["坂井悠二D技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["伤害形态"] = "无直接伤害，提供 10秒强化状态 + 友军鼓舞",
    ["期间效果"] = "暗属性+30%、E冷却固定2.5秒、飞行启用+高度500（主周期保持）、骑蛇表现（马甲一头+马甲二×5蛇身跟随）、每1秒鼓舞800范围友军",
    ["前置条件"] = "等级≥40、力量>300"
}
return ____exports
