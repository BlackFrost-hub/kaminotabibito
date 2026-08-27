local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.05．一方通行.00．配置")
local _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["一方通行单位技能配置"]
local ____07_FF0E_4E00_65B9_901A_884C = require("系统.05．Buff系统.03．Buff表.02．英雄.07．一方通行")
local _____4E00_65B9_901A_884CBuffID = ____07_FF0E_4E00_65B9_901A_884C["一方通行BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心")
local registerPointOrderListener = ____require_result_1.registerPointOrderListener
local registerTargetOrderListener = ____require_result_1.registerTargetOrderListener
local registerImmediateOrderListener = ____require_result_1.registerImmediateOrderListener
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_3["减少魔法值"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local ____require_result_5 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_5.Sound3DII_UnitPlayReuse
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.11．地形步进")
local _____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321 = ____require_result_6["沿角度步进直到地形阻挡"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____53D6_5355_4F4DID = ____require_result_8["取单位ID"]
local _____5355_4F4D_5B58_6D3B = ____require_result_8["单位存活"]
local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local ____Q_6280_80FDID = stringToFourCCSafe(_____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["Q技能ID"])
local ____Q_5173_95ED_6280_80FDID = stringToFourCCSafe(_____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["Q关闭技能ID"])
local ____Q_72B6_6001_6280_80FDID = stringToFourCCSafe(_____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["Q状态技能ID"])
local _____914D_7F6E = _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E.Q
local ____Q_8FD0_884C_65F6_8868 = {}
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetUnitMoveSpeed = jass.GetUnitMoveSpeed
local GetUnitState = jass.GetUnitState
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitFacing = jass.SetUnitFacing
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitAnimation = jass.SetUnitAnimation
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
local SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
local GetOwningPlayer = jass.GetOwningPlayer
local IsTerrainPathable = jass.IsTerrainPathable
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local PATHING_TYPE_FLOATABILITY = jass.PATHING_TYPE_FLOATABILITY
local EXSetUnitMoveType = japi.EXSetUnitMoveType
local function _____83B7_53D6Q_8FD0_884C_65F6(unit)
    return ____Q_8FD0_884C_65F6_8868[_____53D6_5355_4F4DID(unit)]
end
local function _____505C_6B62Q_5F53_524D_79FB_52A8(unit)
    local id = _____53D6_5355_4F4DID(unit)
    local runtime = ____Q_8FD0_884C_65F6_8868[id]
    if runtime == nil then
        return
    end
    if runtime.tickId ~= 0 then
        removePeriodicCallback(runtime.tickId)
        runtime.tickId = 0
    end
    SetUnitAnimation(unit, "stand")
    EXSetUnitMoveType(unit, 2)
end
local function _____505C_6B62_77E2_91CF_79FB_52A8(unit)
    local id = _____53D6_5355_4F4DID(unit)
    local runtime = ____Q_8FD0_884C_65F6_8868[id]
    if runtime == nil or not runtime.active then
        return
    end
    _____505C_6B62Q_5F53_524D_79FB_52A8(unit)
    runtime.active = false
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____4E00_65B9_901A_884CBuffID["矢量移动"])
    UnitRemoveAbility(unit, ____Q_5173_95ED_6280_80FDID)
    UnitRemoveAbility(unit, ____Q_72B6_6001_6280_80FDID)
    SetPlayerAbilityAvailable(
        GetOwningPlayer(unit),
        ____Q_6280_80FDID,
        true
    )
    __TS__Delete(____Q_8FD0_884C_65F6_8868, id)
end
local function _____77E2_91CF_79FB_52A8Tick(variable)
    local runtime = variable
    if runtime == nil or not runtime.active or not _____5355_4F4D_5B58_6D3B(runtime.unit) then
        if runtime ~= nil then
            _____505C_6B62_77E2_91CF_79FB_52A8(runtime.unit)
        end
        return
    end
    local caster = runtime.unit
    local maxMana = GetUnitState(caster, UNIT_STATE_MAX_MANA) or 0
    local currentMana = GetUnitState(caster, UNIT_STATE_MANA) or 0
    if maxMana <= 0 or currentMana / maxMana < _____914D_7F6E["强制关闭魔法比例"] then
        _____505C_6B62_77E2_91CF_79FB_52A8(caster)
        return
    end
    local currentX = GetUnitX(caster)
    local currentY = GetUnitY(caster)
    local dx = runtime.targetX - currentX
    local dy = runtime.targetY - currentY
    local distance = jass:SquareRoot(dx * dx + dy * dy)
    if distance <= _____914D_7F6E["到达距离"] then
        _____505C_6B62Q_5F53_524D_79FB_52A8(caster)
        return
    end
    local angle = jass:Atan2(dy, dx) * jass.bj_RADTODEG
    local speedPerTick = ((GetUnitMoveSpeed(caster) or 0) + _____914D_7F6E["额外移动速度"]) * _____914D_7F6E["移动周期毫秒"] / 1000
    local ____temp_9
    if distance < speedPerTick then
        ____temp_9 = distance
    else
        ____temp_9 = speedPerTick
    end
    local step = ____temp_9
    local next = _____6CBF_89D2_5EA6_6B65_8FDB_76F4_5230_5730_5F62_963B_6321({
        ["起点X"] = currentX,
        ["起点Y"] = currentY,
        ["角度度"] = angle,
        ["单步距离"] = step,
        ["步数"] = 1
    })
    local manaCost = (_____914D_7F6E["持续固定魔耗每秒"] + maxMana * _____914D_7F6E["持续魔耗比例每秒"]) * _____914D_7F6E["移动周期毫秒"] / 1000
    _____51CF_5C11_9B54_6CD5_503C(caster, manaCost, false, false)
    local trailModel = IsTerrainPathable(currentX, currentY, PATHING_TYPE_FLOATABILITY) == false and _____914D_7F6E["浮空尾迹模型"] or _____914D_7F6E["地面尾迹模型"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = trailModel,
        X = currentX,
        Y = currentY,
        Z = GetUnitFlyHeight(caster),
        ["持续秒"] = _____914D_7F6E["尾迹持续秒"]
    })
    if next["实际步数"] <= 0 then
        _____505C_6B62Q_5F53_524D_79FB_52A8(caster)
        return
    end
    SetUnitX(caster, next["最终X"])
    SetUnitY(caster, next["最终Y"])
    SetUnitFacing(caster, angle)
    SetUnitAnimationByIndex(caster, 9)
end
local function _____5F00_59CB_5411_76EE_6807_79FB_52A8(unit, x, y)
    local runtime = _____83B7_53D6Q_8FD0_884C_65F6(unit)
    if runtime == nil or not runtime.active then
        return
    end
    runtime.targetX = x
    runtime.targetY = y
    Sound3DII_UnitPlayReuse(_____914D_7F6E["施法音效路径"], unit, _____914D_7F6E["施法音效裁断距离"])
    if runtime.tickId == 0 then
        EXSetUnitMoveType(unit, 1)
        runtime.tickId = addPeriodicCallback(_____914D_7F6E["移动周期毫秒"], _____77E2_91CF_79FB_52A8Tick, runtime)
    end
end
local function ____on_4E00_65B9_901A_884CQ_70B9_6307_4EE4(unit, _orderId, x, y)
    if GetUnitTypeId(unit) ~= _____5355_4F4D_7C7B_578BID then
        return
    end
    _____5F00_59CB_5411_76EE_6807_79FB_52A8(unit, x, y)
end
local function ____on_4E00_65B9_901A_884CQ_76EE_6807_6307_4EE4(unit, _orderId, target)
    if GetUnitTypeId(unit) ~= _____5355_4F4D_7C7B_578BID or target == nil or target == 0 then
        return
    end
    _____5F00_59CB_5411_76EE_6807_79FB_52A8(
        unit,
        GetUnitX(target),
        GetUnitY(target)
    )
end
local function ____on_4E00_65B9_901A_884CQ_7ACB_5373_6307_4EE4(unit, _orderId)
    if GetUnitTypeId(unit) ~= _____5355_4F4D_7C7B_578BID then
        return
    end
    local runtime = _____83B7_53D6Q_8FD0_884C_65F6(unit)
    if runtime ~= nil and runtime.active then
        _____505C_6B62_77E2_91CF_79FB_52A8(unit)
    end
end
local function _____91CA_653E_77E2_91CF_79FB_52A8(_context, caster)
    if GetUnitTypeId(caster) ~= _____5355_4F4D_7C7B_578BID or not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    local ____opt_10 = _____83B7_53D6Q_8FD0_884C_65F6(caster)
    if (____opt_10 and ____opt_10.active) == true then
        return
    end
    local maxMana = GetUnitState(caster, UNIT_STATE_MAX_MANA) or 0
    local cost = maxMana * _____914D_7F6E["启动魔耗比例"]
    if maxMana <= 0 or (GetUnitState(caster, UNIT_STATE_MANA) or 0) < cost then
        return
    end
    _____51CF_5C11_9B54_6CD5_503C(caster, cost, false, false)
    local runtime = {
        unit = caster,
        active = true,
        targetX = GetUnitX(caster),
        targetY = GetUnitY(caster),
        tickId = 0
    }
    ____Q_8FD0_884C_65F6_8868[_____53D6_5355_4F4DID(caster)] = runtime
    UnitAddAbility(caster, ____Q_5173_95ED_6280_80FDID)
    UnitAddAbility(caster, ____Q_72B6_6001_6280_80FDID)
    SetPlayerAbilityAvailable(
        GetOwningPlayer(caster),
        ____Q_6280_80FDID,
        false
    )
    registerManualBuff(
        caster,
        _____4E00_65B9_901A_884CBuffID["矢量移动"],
        3600,
        _____914D_7F6E["额外移动速度"],
        {sourceUnit = caster, effectSourceName = "一方通行-矢量移动", effectSourceType = "技能"}
    )
    Sound3DII_UnitPlayReuse(_____914D_7F6E["施法音效路径"], caster, _____914D_7F6E["施法音效裁断距离"])
end
local function _____91CA_653E_5173_95ED_77E2_91CF_79FB_52A8(_context, caster)
    if GetUnitTypeId(caster) == _____5355_4F4D_7C7B_578BID then
        _____505C_6B62_77E2_91CF_79FB_52A8(caster)
    end
end
local function _____83B7_53D6Q_76D1_542C_4E0A_4E0B_6587(unit)
    return {unit = unit}
end
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "一方通行-矢量移动",
    ["单位类型ID"] = _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"],
    ["技能ID"] = _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["Q技能ID"],
    ["获取或创建上下文"] = _____83B7_53D6Q_76D1_542C_4E0A_4E0B_6587,
    ["释放技能"] = _____91CA_653E_77E2_91CF_79FB_52A8,
    ["创建独立技能实例"] = false
})
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "一方通行-关闭矢量移动",
    ["单位类型ID"] = _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"],
    ["技能ID"] = _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["Q关闭技能ID"],
    ["获取或创建上下文"] = _____83B7_53D6Q_76D1_542C_4E0A_4E0B_6587,
    ["释放技能"] = _____91CA_653E_5173_95ED_77E2_91CF_79FB_52A8,
    ["创建独立技能实例"] = false
})
registerPointOrderListener(____on_4E00_65B9_901A_884CQ_70B9_6307_4EE4)
registerTargetOrderListener(____on_4E00_65B9_901A_884CQ_76EE_6807_6307_4EE4)
registerImmediateOrderListener(____on_4E00_65B9_901A_884CQ_7ACB_5373_6307_4EE4)
return ____exports
