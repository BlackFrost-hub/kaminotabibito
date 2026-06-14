local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local stringToFourCC, _____5355_4F4D_6709_6548, _____64AD_653E_6708_5149_67B7_9501_65BD_6CD5_52A8_4F5C, _____8BA9_5355_4F4D_9762_5411_76EE_6807, _____53D1_5C04_6708_5149_67B7_9501_5F39_5E55, _____64AD_653E_6708_5149_67B7_9501_547D_4E2D_7279_6548, _____7ED3_7B97_6708_5149_67B7_9501Tick_4F24_5BB3, _____521B_5EFA_6708_5149_67B7_9501_7ED1_5B9A_8BB0_5F55, _____6E05_7406_6708_5149_67B7_9501_63A7_5236, _____7ED3_7B97_745F_5170_8FEA_5C14_6708_5149_67B7_9501_547D_4E2D, jass, addDelayedCallback, _____5F00_59CB_786C_76F4, _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761, _____5173_95ED_541F_5531_6761, _____521B_5EFA_539F_751F_5F39_5E55, _____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9, _____65BD_52A0_6269_5C55_63A7_5236, registerManualBuff, _____79FB_9664_5355_4F4D_6307_5B9ABuff, YDWETimerDestroyEffectSafe, GetUnitName, R2I, GetUnitX, GetUnitY, GetUnitFacing, SetUnitFacing, Atan2, GetHandleId, SetUnitAnimationByIndex, SetUnitTimeScale, AddSpecialEffectTarget, UnitRemoveAbility, UnitDamageTarget, BJ_RADTODEG, _____6708_5149_67B7_9501_6839_987BBuffID, _____6708_5149_67B7_9501_539F_751F_6839_987BBuff, _____6708_5149_67B7_9501_7ED1_5B9A_8868
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．瑟兰迪尔.00．配置")
local _____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["瑟兰迪尔单位技能配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．瑟兰迪尔.15．台词播放")
local _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放瑟兰迪尔台词"]
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0
end
function _____64AD_653E_6708_5149_67B7_9501_65BD_6CD5_52A8_4F5C(caster)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    _____5F00_59CB_786C_76F4(caster, config["施法硬直秒"])
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({["总时长"] = config["施法硬直秒"], ["颜色ID"] = config["吟唱条颜色ID"], ["标题文本"] = config["吟唱条标题文本"], ["提示文本"] = config["吟唱条提示文本"]})
    SetUnitTimeScale(caster, 1)
    SetUnitAnimationByIndex(caster, config["动画编号"])
    addDelayedCallback(
        30,
        function()
            if not _____5355_4F4D_6709_6548(caster) then
                return
            end
            SetUnitTimeScale(caster, 1)
            SetUnitAnimationByIndex(caster, config["动画编号"])
        end
    )
end
function _____8BA9_5355_4F4D_9762_5411_76EE_6807(caster, target)
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local angle = Atan2(
        GetUnitY(target) - GetUnitY(caster),
        GetUnitX(target) - GetUnitX(caster)
    ) * BJ_RADTODEG
    SetUnitFacing(caster, angle)
end
function _____53D1_5C04_6708_5149_67B7_9501_5F39_5E55(caster, target)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    local targetId = GetHandleId(target)
    local _____5DF2_547D_4E2D = false
    local function _____6708_5149_67B7_9501_5F39_5E55_76EE_6807_7B5B_9009(_____76EE_6807_5355_4F4D)
        return _____5355_4F4D_6709_6548(_____76EE_6807_5355_4F4D) and GetHandleId(_____76EE_6807_5355_4F4D) == targetId
    end
    local function _____6708_5149_67B7_9501_5F39_5E55_547D_4E2D(_____547D_4E2D_5355_4F4D)
        if _____5DF2_547D_4E2D then
            return
        end
        _____5DF2_547D_4E2D = true
        _____7ED3_7B97_745F_5170_8FEA_5C14_6708_5149_67B7_9501_547D_4E2D(caster, _____547D_4E2D_5355_4F4D)
    end
    local function _____6708_5149_67B7_9501_5F39_5E55_5230_8FBE_76EE_6807_70B9()
        if _____5DF2_547D_4E2D or not _____5355_4F4D_6709_6548(target) then
            return
        end
        _____5DF2_547D_4E2D = true
        _____7ED3_7B97_745F_5170_8FEA_5C14_6708_5149_67B7_9501_547D_4E2D(caster, target)
    end
    _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = caster,
        X = GetUnitX(caster),
        Y = GetUnitY(caster),
        ["方向角"] = GetUnitFacing(caster),
        ["指定目标"] = target,
        ["速度"] = config["飞行速度"],
        ["轨迹采样器"] = _____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9(target, config["命中半径"]),
        ["命中半径"] = config["命中半径"],
        ["生命周期"] = 3,
        ["最大距离"] = config["最大飞行距离"],
        ["碰撞消失"] = true,
        ["最大总命中次数"] = 1,
        ["每单位最大命中次数"] = 1,
        ["模型"] = config["飞行特效"],
        ["附着特效模型"] = config["飞行特效"],
        ["飞行高度"] = 80,
        ["影响目标"] = "全部",
        ["目标筛选"] = _____6708_5149_67B7_9501_5F39_5E55_76EE_6807_7B5B_9009,
        ["on命中"] = _____6708_5149_67B7_9501_5F39_5E55_547D_4E2D,
        ["on命中单位"] = _____6708_5149_67B7_9501_5F39_5E55_547D_4E2D,
        ["on到达目标点"] = _____6708_5149_67B7_9501_5F39_5E55_5230_8FBE_76EE_6807_70B9
    })
end
function _____64AD_653E_6708_5149_67B7_9501_547D_4E2D_7279_6548(target)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    local targetEffect = AddSpecialEffectTarget(config["命中特效"], target, "origin")
    if targetEffect ~= nil and targetEffect ~= 0 then
        YDWETimerDestroyEffectSafe(config["定身秒"], targetEffect)
    end
end
function _____7ED3_7B97_6708_5149_67B7_9501Tick_4F24_5BB3(caster, target, tickIndex)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    local targetId = GetHandleId(target)
    addDelayedCallback(
        R2I(config["Tick间隔秒"] * tickIndex * 1000),
        function()
            if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
                return
            end
            if _____6708_5149_67B7_9501_7ED1_5B9A_8868[targetId] == nil then
                return
            end
            UnitDamageTarget(
                caster,
                target,
                config["Tick伤害"],
                false,
                false,
                jass.ATTACK_TYPE_NORMAL,
                jass.DAMAGE_TYPE_PLANT,
                jass.WEAPON_TYPE_WHOKNOWS
            )
        end
    )
end
function _____521B_5EFA_6708_5149_67B7_9501_7ED1_5B9A_8BB0_5F55(caster, target)
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    _____6708_5149_67B7_9501_7ED1_5B9A_8868[GetHandleId(target)] = {["来源单位"] = caster, ["目标单位"] = target, ["已承受打断伤害"] = 0}
end
function _____6E05_7406_6708_5149_67B7_9501_63A7_5236(target)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, config.BuffID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, _____6708_5149_67B7_9501_6839_987BBuffID)
    UnitRemoveAbility(target, _____6708_5149_67B7_9501_539F_751F_6839_987BBuff)
end
____exports["释放瑟兰迪尔月光枷锁效果"] = function(caster, target)
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD(caster, "月光枷锁")
    _____8BA9_5355_4F4D_9762_5411_76EE_6807(caster, target)
    _____64AD_653E_6708_5149_67B7_9501_65BD_6CD5_52A8_4F5C(caster)
    addDelayedCallback(
        R2I(config["施法硬直秒"] * 1000),
        function()
            _____5173_95ED_541F_5531_6761("常规技能")
            if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
                return
            end
            _____8BA9_5355_4F4D_9762_5411_76EE_6807(caster, target)
            SetUnitTimeScale(caster, 1)
            SetUnitAnimationByIndex(caster, 0)
            _____53D1_5C04_6708_5149_67B7_9501_5F39_5E55(caster, target)
        end
    )
end
function _____7ED3_7B97_745F_5170_8FEA_5C14_6708_5149_67B7_9501_547D_4E2D(caster, target)
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    _____64AD_653E_6708_5149_67B7_9501_547D_4E2D_7279_6548(target)
    _____65BD_52A0_6269_5C55_63A7_5236(caster, target, "roots", {["持续时间"] = config["定身秒"]})
    _____521B_5EFA_6708_5149_67B7_9501_7ED1_5B9A_8BB0_5F55(caster, target)
    registerManualBuff(
        target,
        config.BuffID,
        config["定身秒"],
        0,
        {
            sourceName = GetUnitName(caster),
            iconOverride = "BuffIcon\\Boss\\Thranduil\\yueguangjiasuo.blp",
            effectModelOverride = config["命中特效"]
        }
    )
    do
        local i = 1
        while i <= config["定身秒"] do
            _____7ED3_7B97_6708_5149_67B7_9501Tick_4F24_5BB3(caster, target, i)
            i = i + 1
        end
    end
end
jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____5F00_59CB_786C_76F4 = ____require_result_2["开始硬直"]
local ____require_result_3 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
_____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_3["显示常规技能吟唱条"]
_____5173_95ED_541F_5531_6761 = ____require_result_3["关闭吟唱条"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
_____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_4["创建原生弹幕"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index")
_____521B_5EFA_8FFD_8E2A_63D2_503C_8F68_8FF9 = ____require_result_5["创建追踪插值轨迹"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
_____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_6["施加扩展控制"]
local ____require_result_7 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_7.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_7["移除单位指定Buff"]
local ____require_result_8 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_8.registerAppliedFinalDamageListener
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．瑟兰迪尔.14．月光碎片")
local _____521B_5EFA_745F_5170_8FEA_5C14_6708_5149_788E_7247 = ____require_result_9["创建瑟兰迪尔月光碎片"]
local ____require_result_10 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDWETimerDestroyEffectSafe = ____require_result_10.YDWETimerDestroyEffectSafe
local GetUnitTypeId = jass.GetUnitTypeId
local GetSpellTargetUnit = jass.GetSpellTargetUnit
GetUnitName = jass.GetUnitName
R2I = jass.R2I
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFacing = jass.GetUnitFacing
SetUnitFacing = jass.SetUnitFacing
Atan2 = jass.Atan2
GetHandleId = jass.GetHandleId
SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
SetUnitTimeScale = jass.SetUnitTimeScale
AddSpecialEffectTarget = jass.AddSpecialEffectTarget
UnitRemoveAbility = jass.UnitRemoveAbility
UnitDamageTarget = jass.UnitDamageTarget
local _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID = stringToFourCC(_____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6708_5149_67B7_9501_6280_80FDID = stringToFourCC(_____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]["技能槽位"])
local _____6708_5149_67B7_9501_5DF2_6CE8_518C = false
BJ_RADTODEG = 57.29577951308232
_____6708_5149_67B7_9501_6839_987BBuffID = "C017"
_____6708_5149_67B7_9501_539F_751F_6839_987BBuff = 1111844210
_____6708_5149_67B7_9501_7ED1_5B9A_8868 = {}
local function _____6253_65AD_6708_5149_67B7_9501_5E76_6389_843D_788E_7247(target)
    if not _____5355_4F4D_6709_6548(target) then
        return false
    end
    local targetId = GetHandleId(target)
    local _____8BB0_5F55 = _____6708_5149_67B7_9501_7ED1_5B9A_8868[targetId]
    if _____8BB0_5F55 == nil then
        return false
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    __TS__Delete(_____6708_5149_67B7_9501_7ED1_5B9A_8868, targetId)
    _____6E05_7406_6708_5149_67B7_9501_63A7_5236(target)
    addDelayedCallback(
        0,
        function()
            _____6E05_7406_6708_5149_67B7_9501_63A7_5236(target)
        end
    )
    addDelayedCallback(
        120,
        function()
            _____6E05_7406_6708_5149_67B7_9501_63A7_5236(target)
        end
    )
    _____521B_5EFA_745F_5170_8FEA_5C14_6708_5149_788E_7247(
        GetUnitX(target),
        GetUnitY(target)
    )
    return true
end
local function ____on_6708_5149_67B7_9501_627F_53D7_4F24_5BB3(target, attacker, applied, _snapshot)
    if applied <= 0 or not _____5355_4F4D_6709_6548(target) or not _____5355_4F4D_6709_6548(attacker) then
        return
    end
    local targetId = GetHandleId(target)
    local _____8BB0_5F55 = _____6708_5149_67B7_9501_7ED1_5B9A_8868[targetId]
    if _____8BB0_5F55 == nil then
        return
    end
    if attacker == _____8BB0_5F55["来源单位"] then
        return
    end
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["月光枷锁"]
    _____8BB0_5F55["已承受打断伤害"] = _____8BB0_5F55["已承受打断伤害"] + applied
    if _____8BB0_5F55["已承受打断伤害"] >= config["打断所需伤害"] then
        _____6253_65AD_6708_5149_67B7_9501_5E76_6389_843D_788E_7247(target)
    end
end
____exports["释放瑟兰迪尔月光枷锁"] = function(_context, _target)
    ____exports["释放瑟兰迪尔月光枷锁效果"](_context["Boss单位"], _target)
end
____exports["立即打断瑟兰迪尔月光枷锁"] = function(caster, target)
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return false
    end
    if _____6708_5149_67B7_9501_7ED1_5B9A_8868[GetHandleId(target)] == nil then
        _____7ED3_7B97_745F_5170_8FEA_5C14_6708_5149_67B7_9501_547D_4E2D(caster, target)
    end
    return _____6253_65AD_6708_5149_67B7_9501_5E76_6389_843D_788E_7247(target)
end
local function ____on_745F_5170_8FEA_5C14_6708_5149_67B7_9501_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____6708_5149_67B7_9501_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID then
        return
    end
    local target = GetSpellTargetUnit()
    ____exports["释放瑟兰迪尔月光枷锁效果"](castingUnit, target)
end
____exports["注册瑟兰迪尔月光枷锁"] = function()
    if _____6708_5149_67B7_9501_5DF2_6CE8_518C then
        return
    end
    _____6708_5149_67B7_9501_5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_745F_5170_8FEA_5C14_6708_5149_67B7_9501_751F_6548)
    registerAppliedFinalDamageListener(____on_6708_5149_67B7_9501_627F_53D7_4F24_5BB3)
end
return ____exports
