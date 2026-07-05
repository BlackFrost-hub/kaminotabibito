local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____5355_4F4D_6709_6548_4E14_5B58_6D3B, _____53D6_5355_4F4DID, _____79FB_9664_72B6_6001ID, _____5C1D_8BD5_505C_6B62_9A71_52A8, _____5355_4F4D_6709_963B_6B62_653B_51FBBuff, _____7EF4_6301_7AD9_6869_72B6_6001, _____53D6_9762_5411_76EE_6807_89D2_5EA6, _____7ACB_5373_9762_5411_76EE_6807, _____64AD_653E_653B_51FB_52A8_4F5C, _____76EE_6807_4ECD_662F_5F85_51FA_624B_76EE_6807, _____53D1_5C04_7AD9_6869_76F4_7EBF_5F39_5E55, _____5F00_59CB_4E00_6B21_6A21_62DF_653B_51FB, _____4E2D_65AD_5F85_51FA_624B, _____66F4_65B0_5355_4E2A_5C04_51FB_72B6_6001, _____6E05_7406_72B6_6001, ____on_7AD9_6869_5F39_5E55_5C04_51FB_5355_4F4DTick, removePeriodicCallback, getServerTime, _____521B_5EFA_539F_751F_5F39_5E55, _____5355_4F4D_662F_5426_786C_76F4_4E2D, _____5355_4F4D_662F_5426_5904_4E8E_65BD_6CD5_786C_76F4_6548_679C, _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6, _____5355_4F4D_662F_5426_62E5_6709_6307_5B9ABuff, X_FixUnitStandingSafe, GetHandleId, GetUnitX, GetUnitY, SetUnitX, SetUnitY, SetUnitFacing, SetUnitAnimation, SetUnitAnimationByIndex, QueueUnitAnimation, SetUnitTimeScale, SetUnitAcquireRange, IsUnitPaused, IsUnitType, Atan2, Cos, Sin, UNIT_TYPE_DEAD, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS, _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3, DzUnitDisableAttack, EXSetUnitFacing, BJ_RADTODEG, BJ_DEGTORAD, _____963B_6B62_653B_51FB_7684_63A7_5236Buff_5217_8868, _____5C04_51FB_72B6_6001_8868, _____5C04_51FB_72B6_6001ID_5217_8868, _____9A71_52A8ID
function _____5355_4F4D_6709_6548_4E14_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
function _____79FB_9664_72B6_6001ID(id)
    do
        local i = 0
        while i < #_____5C04_51FB_72B6_6001ID_5217_8868 do
            if _____5C04_51FB_72B6_6001ID_5217_8868[i + 1] == id then
                __TS__ArraySplice(_____5C04_51FB_72B6_6001ID_5217_8868, i, 1)
                return
            end
            i = i + 1
        end
    end
end
function _____5C1D_8BD5_505C_6B62_9A71_52A8()
    if _____9A71_52A8ID == 0 or #_____5C04_51FB_72B6_6001ID_5217_8868 > 0 then
        return
    end
    removePeriodicCallback(_____9A71_52A8ID)
    _____9A71_52A8ID = 0
end
function _____5355_4F4D_6709_963B_6B62_653B_51FBBuff(unit)
    do
        local i = 0
        while i < #_____963B_6B62_653B_51FB_7684_63A7_5236Buff_5217_8868 do
            if _____5355_4F4D_662F_5426_62E5_6709_6307_5B9ABuff(unit, _____963B_6B62_653B_51FB_7684_63A7_5236Buff_5217_8868[i + 1]) then
                return true
            end
            i = i + 1
        end
    end
    return false
end
____exports["单位是否可以站桩弹幕射击"] = function(unit)
    if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(unit) then
        return false
    end
    if IsUnitPaused(unit) == true then
        return false
    end
    if _____5355_4F4D_662F_5426_786C_76F4_4E2D(unit) then
        return false
    end
    if _____5355_4F4D_662F_5426_5904_4E8E_65BD_6CD5_786C_76F4_6548_679C(unit) then
        return false
    end
    if _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6(unit) then
        return false
    end
    if _____5355_4F4D_6709_963B_6B62_653B_51FBBuff(unit) then
        return false
    end
    return true
end
function _____7EF4_6301_7AD9_6869_72B6_6001(_____72B6_6001)
    local unit = _____72B6_6001["参数"]["射手单位"]
    if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(unit) then
        return
    end
    SetUnitAcquireRange(unit, 0)
    X_FixUnitStandingSafe(unit)
    if DzUnitDisableAttack ~= nil then
        DzUnitDisableAttack(unit, true)
    end
    local dx = GetUnitX(unit) - _____72B6_6001["固定X"]
    local dy = GetUnitY(unit) - _____72B6_6001["固定Y"]
    if dx > 1 or dx < -1 or dy > 1 or dy < -1 then
        SetUnitX(unit, _____72B6_6001["固定X"])
        SetUnitY(unit, _____72B6_6001["固定Y"])
    end
end
function _____53D6_9762_5411_76EE_6807_89D2_5EA6(source, target)
    return Atan2(
        GetUnitY(target) - GetUnitY(source),
        GetUnitX(target) - GetUnitX(source)
    ) * BJ_RADTODEG
end
function _____7ACB_5373_9762_5411_76EE_6807(source, target)
    local angle = _____53D6_9762_5411_76EE_6807_89D2_5EA6(source, target)
    SetUnitFacing(source, angle)
    if EXSetUnitFacing ~= nil then
        EXSetUnitFacing(source, angle * BJ_DEGTORAD)
    end
    return angle
end
function _____64AD_653E_653B_51FB_52A8_4F5C(_____72B6_6001)
    local _____53C2_6570 = _____72B6_6001["参数"]
    local _____5C04_624B = _____53C2_6570["射手单位"]
    SetUnitTimeScale(_____5C04_624B, _____53C2_6570["攻击动画速度"] or 1)
    if _____53C2_6570["攻击动画编号"] ~= nil and _____53C2_6570["攻击动画编号"] >= 0 then
        SetUnitAnimationByIndex(_____5C04_624B, _____53C2_6570["攻击动画编号"])
    else
        SetUnitAnimation(_____5C04_624B, _____53C2_6570["攻击动画名"] or "attack")
    end
    if QueueUnitAnimation ~= nil then
        QueueUnitAnimation(_____5C04_624B, "stand")
    end
end
function _____76EE_6807_4ECD_662F_5F85_51FA_624B_76EE_6807(_____72B6_6001)
    local target = _____72B6_6001["待出手目标"]
    return _____5355_4F4D_6709_6548_4E14_5B58_6D3B(target) and _____53D6_5355_4F4DID(target) == _____72B6_6001["待出手目标ID"]
end
function _____53D1_5C04_7AD9_6869_76F4_7EBF_5F39_5E55(_____72B6_6001)
    local _____53C2_6570 = _____72B6_6001["参数"]
    local _____5C04_624B = _____53C2_6570["射手单位"]
    local target = _____72B6_6001["待出手目标"]
    if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____5C04_624B) or not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____53C2_6570["来源单位"]) or not _____76EE_6807_4ECD_662F_5F85_51FA_624B_76EE_6807(_____72B6_6001) then
        return
    end
    if not ____exports["单位是否可以站桩弹幕射击"](_____5C04_624B) then
        return
    end
    local currentTarget = _____53C2_6570["选择目标"](_____5C04_624B, _____53C2_6570["来源单位"])
    if _____5355_4F4D_6709_6548_4E14_5B58_6D3B(currentTarget) then
        target = currentTarget
    end
    local angle = _____7ACB_5373_9762_5411_76EE_6807(_____5C04_624B, target)
    local angleRad = angle * BJ_DEGTORAD
    local offset = _____53C2_6570["起射偏移"] or 32
    local function _____7AD9_6869_76F4_7EBF_5F39_5E55_547D_4E2D_4F24_5BB3(_____76EE_6807_5355_4F4D)
        if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____53C2_6570["来源单位"]) or not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____76EE_6807_5355_4F4D) or not (_____53C2_6570["伤害值"] > 0) then
            return
        end
        local ____9020_6210_5355_4F53_6280_80FD_4F24_5BB3_11 = _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3
        local ____53C2_6570__6765_6E90_5355_4F4D_8 = _____53C2_6570["来源单位"]
        local ____76EE_6807_5355_4F4D_9 = _____76EE_6807_5355_4F4D
        local ____53C2_6570__4F24_5BB3_503C_10 = _____53C2_6570["伤害值"]
        local ____53C2_6570__4F24_5BB3_7C7B_578B_5 = _____53C2_6570["伤害类型"]
        if ____53C2_6570__4F24_5BB3_7C7B_578B_5 == nil then
            ____53C2_6570__4F24_5BB3_7C7B_578B_5 = DAMAGE_TYPE_NORMAL
        end
        local ____53C2_6570__653B_51FB_7C7B_578B_6 = _____53C2_6570["攻击类型"]
        if ____53C2_6570__653B_51FB_7C7B_578B_6 == nil then
            ____53C2_6570__653B_51FB_7C7B_578B_6 = ATTACK_TYPE_NORMAL
        end
        local ____53C2_6570__6B66_5668_7C7B_578B_7 = _____53C2_6570["武器类型"]
        if ____53C2_6570__6B66_5668_7C7B_578B_7 == nil then
            ____53C2_6570__6B66_5668_7C7B_578B_7 = WEAPON_TYPE_WHOKNOWS
        end
        ____9020_6210_5355_4F53_6280_80FD_4F24_5BB3_11({
            ["来源"] = ____53C2_6570__6765_6E90_5355_4F4D_8,
            ["目标"] = ____76EE_6807_5355_4F4D_9,
            ["伤害"] = ____53C2_6570__4F24_5BB3_503C_10,
            ["伤害类型"] = ____53C2_6570__4F24_5BB3_7C7B_578B_5,
            ranged = false,
            attackType = ____53C2_6570__653B_51FB_7C7B_578B_6,
            weaponType = ____53C2_6570__6B66_5668_7C7B_578B_7,
            ["来源类型"] = _____53C2_6570["来源类型"] or "单位技能",
            ["技能ID"] = _____53C2_6570["技能ID"],
            ["技能实例ID"] = _____53C2_6570["技能实例ID"],
            ["标签"] = _____53C2_6570["技能标签"],
            ["参与技能伤害加成"] = _____53C2_6570["参与技能伤害加成"]
        })
    end
    local ____521B_5EFA_539F_751F_5F39_5E55_24 = _____521B_5EFA_539F_751F_5F39_5E55
    local ____53C2_6570__6765_6E90_5355_4F4D_15 = _____53C2_6570["来源单位"]
    local ____temp_16 = GetUnitX(_____5C04_624B) + Cos(angleRad) * offset
    local ____temp_17 = GetUnitY(_____5C04_624B) + Sin(angleRad) * offset
    local ____53C2_6570__5F39_9053_901F_5EA6_18 = _____53C2_6570["弹道速度"]
    local ____53C2_6570__547D_4E2D_534A_5F84_19 = _____53C2_6570["命中半径"]
    local ____53C2_6570__6700_5927_98DE_884C_8DDD_79BB_20 = _____53C2_6570["最大飞行距离"]
    local ____53C2_6570__5F39_9053_6A21_578B_21 = _____53C2_6570["弹道模型"]
    local ____temp_22 = _____53C2_6570["飞行高度"] or 80
    local ____temp_23 = _____53C2_6570["弹道缩放"] or 1
    local ____53C2_6570__653B_51FB_7C7B_578B_12 = _____53C2_6570["攻击类型"]
    if ____53C2_6570__653B_51FB_7C7B_578B_12 == nil then
        ____53C2_6570__653B_51FB_7C7B_578B_12 = ATTACK_TYPE_NORMAL
    end
    local ____53C2_6570__4F24_5BB3_7C7B_578B_13 = _____53C2_6570["伤害类型"]
    if ____53C2_6570__4F24_5BB3_7C7B_578B_13 == nil then
        ____53C2_6570__4F24_5BB3_7C7B_578B_13 = DAMAGE_TYPE_NORMAL
    end
    local ____53C2_6570__6B66_5668_7C7B_578B_14 = _____53C2_6570["武器类型"]
    if ____53C2_6570__6B66_5668_7C7B_578B_14 == nil then
        ____53C2_6570__6B66_5668_7C7B_578B_14 = WEAPON_TYPE_WHOKNOWS
    end
    ____521B_5EFA_539F_751F_5F39_5E55_24({
        ["所有者"] = ____53C2_6570__6765_6E90_5355_4F4D_15,
        X = ____temp_16,
        Y = ____temp_17,
        ["方向角"] = angle,
        ["轨迹类型"] = "直线",
        ["显式改向后锁定方向"] = true,
        ["速度"] = ____53C2_6570__5F39_9053_901F_5EA6_18,
        ["命中半径"] = ____53C2_6570__547D_4E2D_534A_5F84_19,
        ["最大距离"] = ____53C2_6570__6700_5927_98DE_884C_8DDD_79BB_20,
        ["生命周期"] = 4,
        ["碰撞消失"] = true,
        ["最大总命中次数"] = 1,
        ["每单位最大命中次数"] = 1,
        ["模型"] = ____53C2_6570__5F39_9053_6A21_578B_21,
        ["飞行高度"] = ____temp_22,
        ["缩放"] = ____temp_23,
        ["影响目标"] = "敌方",
        ["伤害值"] = 0,
        ["攻击类型"] = ____53C2_6570__653B_51FB_7C7B_578B_12,
        ["伤害类型"] = ____53C2_6570__4F24_5BB3_7C7B_578B_13,
        ["武器类型"] = ____53C2_6570__6B66_5668_7C7B_578B_14,
        ["on命中单位"] = _____7AD9_6869_76F4_7EBF_5F39_5E55_547D_4E2D_4F24_5BB3
    })
end
function _____5F00_59CB_4E00_6B21_6A21_62DF_653B_51FB(_____72B6_6001, now)
    local _____53C2_6570 = _____72B6_6001["参数"]
    local target = _____53C2_6570["选择目标"](_____53C2_6570["射手单位"], _____53C2_6570["来源单位"])
    if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(target) then
        _____72B6_6001["下次攻击时间"] = now + 250
        return
    end
    _____7ACB_5373_9762_5411_76EE_6807(_____53C2_6570["射手单位"], target)
    _____64AD_653E_653B_51FB_52A8_4F5C(_____72B6_6001)
    _____72B6_6001["待出手目标"] = target
    _____72B6_6001["待出手目标ID"] = _____53D6_5355_4F4DID(target)
    _____72B6_6001["待出手时间"] = now + (_____53C2_6570["出手延迟秒"] or 0.35) * 1000
end
function _____4E2D_65AD_5F85_51FA_624B(_____72B6_6001, now)
    _____72B6_6001["待出手目标"] = nil
    _____72B6_6001["待出手目标ID"] = 0
    _____72B6_6001["待出手时间"] = 0
    _____72B6_6001["下次攻击时间"] = now + 250
    if _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____72B6_6001["参数"]["射手单位"]) then
        SetUnitTimeScale(_____72B6_6001["参数"]["射手单位"], 1)
        SetUnitAnimation(_____72B6_6001["参数"]["射手单位"], "stand")
    end
end
function _____66F4_65B0_5355_4E2A_5C04_51FB_72B6_6001(_____72B6_6001, now)
    local _____53C2_6570 = _____72B6_6001["参数"]
    if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____53C2_6570["射手单位"]) or not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____53C2_6570["来源单位"]) then
        return false
    end
    if _____72B6_6001["到期时间"] > 0 and now >= _____72B6_6001["到期时间"] then
        return false
    end
    _____7EF4_6301_7AD9_6869_72B6_6001(_____72B6_6001)
    if _____72B6_6001["待出手时间"] > 0 then
        if not ____exports["单位是否可以站桩弹幕射击"](_____53C2_6570["射手单位"]) or not _____76EE_6807_4ECD_662F_5F85_51FA_624B_76EE_6807(_____72B6_6001) then
            _____4E2D_65AD_5F85_51FA_624B(_____72B6_6001, now)
            return true
        end
        if now >= _____72B6_6001["待出手时间"] then
            _____53D1_5C04_7AD9_6869_76F4_7EBF_5F39_5E55(_____72B6_6001)
            _____72B6_6001["待出手目标"] = nil
            _____72B6_6001["待出手目标ID"] = 0
            _____72B6_6001["待出手时间"] = 0
            _____72B6_6001["下次攻击时间"] = now + _____53C2_6570["攻击间隔秒"] * 1000
            SetUnitTimeScale(_____53C2_6570["射手单位"], 1)
        end
        return true
    end
    if now < _____72B6_6001["下次攻击时间"] then
        return true
    end
    if not ____exports["单位是否可以站桩弹幕射击"](_____53C2_6570["射手单位"]) then
        _____72B6_6001["下次攻击时间"] = now + 250
        return true
    end
    _____5F00_59CB_4E00_6B21_6A21_62DF_653B_51FB(_____72B6_6001, now)
    return true
end
function _____6E05_7406_72B6_6001(id)
    local _____72B6_6001 = _____5C04_51FB_72B6_6001_8868[id]
    if _____72B6_6001 ~= nil and _____5355_4F4D_6709_6548_4E14_5B58_6D3B(_____72B6_6001["参数"]["射手单位"]) then
        SetUnitTimeScale(_____72B6_6001["参数"]["射手单位"], 1)
    end
    __TS__Delete(_____5C04_51FB_72B6_6001_8868, id)
    _____79FB_9664_72B6_6001ID(id)
end
function ____on_7AD9_6869_5F39_5E55_5C04_51FB_5355_4F4DTick()
    local now = getServerTime()
    local index = 0
    while index < #_____5C04_51FB_72B6_6001ID_5217_8868 do
        local id = _____5C04_51FB_72B6_6001ID_5217_8868[index + 1]
        local _____72B6_6001 = _____5C04_51FB_72B6_6001_8868[id]
        if _____72B6_6001 == nil or not _____66F4_65B0_5355_4E2A_5C04_51FB_72B6_6001(_____72B6_6001, now) then
            _____6E05_7406_72B6_6001(id)
        else
            index = index + 1
        end
    end
    _____5C1D_8BD5_505C_6B62_9A71_52A8()
end
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
_____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_1["创建原生弹幕"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____5355_4F4D_662F_5426_786C_76F4_4E2D = ____require_result_2["单位是否硬直中"]
_____5355_4F4D_662F_5426_5904_4E8E_65BD_6CD5_786C_76F4_6548_679C = ____require_result_2["单位是否处于施法硬直效果"]
_____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6 = ____require_result_2["单位是否处于硬控制效果合集"]
_____5355_4F4D_662F_5426_62E5_6709_6307_5B9ABuff = ____require_result_2["单位是否拥有指定Buff"]
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
X_FixUnitStandingSafe = ____require_result_3.X_FixUnitStandingSafe
GetHandleId = jass.GetHandleId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
SetUnitX = jass.SetUnitX
SetUnitY = jass.SetUnitY
SetUnitFacing = jass.SetUnitFacing
SetUnitAnimation = jass.SetUnitAnimation
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
QueueUnitAnimation = jass.QueueUnitAnimation
SetUnitTimeScale = jass.SetUnitTimeScale
SetUnitAcquireRange = jass.SetUnitAcquireRange
local IssueImmediateOrder = jass.IssueImmediateOrder
IsUnitPaused = jass.IsUnitPaused
IsUnitType = jass.IsUnitType
local ConvertUnitState = jass.ConvertUnitState
Atan2 = jass.Atan2
Cos = jass.Cos
Sin = jass.Sin
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_4["造成单体技能伤害"]
local SetUnitStateJapi = japi.SetUnitState
local DzSetUnitMissileModel = japi.DzSetUnitMissileModel
local DzSetUnitMissileArc = japi.DzSetUnitMissileArc
local DzSetUnitMissileSpeed = japi.DzSetUnitMissileSpeed
DzUnitDisableAttack = japi.DzUnitDisableAttack
EXSetUnitFacing = japi.EXSetUnitFacing
BJ_RADTODEG = 57.29577951308232
BJ_DEGTORAD = 0.017453292519943295
local _____653B_51FB_529B_72B6_6001 = 18
local _____653B_51FB_8303_56F4_72B6_6001 = 22
local _____653B_51FB_95F4_9694_72B6_6001 = 37
local _____9A71_52A8_95F4_9694_6BEB_79D2 = 50
_____963B_6B62_653B_51FB_7684_63A7_5236Buff_5217_8868 = {
    "C001",
    "C002",
    "C004",
    "C006",
    "C008",
    "C009",
    "C010",
    "C016",
    "C018",
    "C037"
}
_____5C04_51FB_72B6_6001_8868 = {}
_____5C04_51FB_72B6_6001ID_5217_8868 = {}
_____9A71_52A8ID = 0
local function _____52A0_5165_72B6_6001ID(id)
    do
        local i = 0
        while i < #_____5C04_51FB_72B6_6001ID_5217_8868 do
            if _____5C04_51FB_72B6_6001ID_5217_8868[i + 1] == id then
                return
            end
            i = i + 1
        end
    end
    _____5C04_51FB_72B6_6001ID_5217_8868[#_____5C04_51FB_72B6_6001ID_5217_8868 + 1] = id
end
local function _____786E_4FDD_9A71_52A8()
    if _____9A71_52A8ID ~= 0 then
        return
    end
    _____9A71_52A8ID = addPeriodicCallback(_____9A71_52A8_95F4_9694_6BEB_79D2, ____on_7AD9_6869_5F39_5E55_5C04_51FB_5355_4F4DTick)
end
____exports["禁用单位原生攻击并固定站桩"] = function(unit)
    if not _____5355_4F4D_6709_6548_4E14_5B58_6D3B(unit) then
        return
    end
    SetUnitAcquireRange(unit, 0)
    X_FixUnitStandingSafe(unit)
    SetUnitStateJapi(
        unit,
        ConvertUnitState(_____653B_51FB_529B_72B6_6001),
        0
    )
    SetUnitStateJapi(
        unit,
        ConvertUnitState(_____653B_51FB_8303_56F4_72B6_6001),
        0
    )
    SetUnitStateJapi(
        unit,
        ConvertUnitState(_____653B_51FB_95F4_9694_72B6_6001),
        99
    )
    if DzSetUnitMissileModel ~= nil then
        DzSetUnitMissileModel(unit, "")
    end
    if DzSetUnitMissileArc ~= nil then
        DzSetUnitMissileArc(unit, 0)
    end
    if DzSetUnitMissileSpeed ~= nil then
        DzSetUnitMissileSpeed(unit, 0)
    end
    if DzUnitDisableAttack ~= nil then
        DzUnitDisableAttack(unit, true)
    end
    IssueImmediateOrder(unit, "stop")
end
____exports["注册站桩弹幕射击单位"] = function(_____53C2_6570)
    local id = _____53D6_5355_4F4DID(_____53C2_6570["射手单位"])
    if id == 0 or _____53C2_6570["选择目标"] == nil or not (_____53C2_6570["攻击间隔秒"] > 0) or not (_____53C2_6570["弹道速度"] > 0) then
        return 0
    end
    _____6E05_7406_72B6_6001(id)
    ____exports["禁用单位原生攻击并固定站桩"](_____53C2_6570["射手单位"])
    local now = getServerTime()
    _____5C04_51FB_72B6_6001_8868[id] = {
        id = id,
        ["参数"] = _____53C2_6570,
        ["到期时间"] = _____53C2_6570["持续秒"] ~= nil and _____53C2_6570["持续秒"] > 0 and now + _____53C2_6570["持续秒"] * 1000 or 0,
        ["下次攻击时间"] = now + 200,
        ["待出手时间"] = 0,
        ["待出手目标"] = nil,
        ["待出手目标ID"] = 0,
        ["固定X"] = GetUnitX(_____53C2_6570["射手单位"]),
        ["固定Y"] = GetUnitY(_____53C2_6570["射手单位"])
    }
    _____52A0_5165_72B6_6001ID(id)
    _____786E_4FDD_9A71_52A8()
    return id
end
____exports["停止站桩弹幕射击单位"] = function(_____5C04_624B_5355_4F4D)
    local id = _____53D6_5355_4F4DID(_____5C04_624B_5355_4F4D)
    if id == 0 then
        return
    end
    _____6E05_7406_72B6_6001(id)
    _____5C1D_8BD5_505C_6B62_9A71_52A8()
end
return ____exports
