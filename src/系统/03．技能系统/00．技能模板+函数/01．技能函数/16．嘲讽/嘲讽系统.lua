local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- 嘲讽 + 反伤系统
-- 
-- 类似Dota斧王的嘲讽：施加嘲讽时立刻发 attack 命令，后续通过指令事件拦截维持。
-- 通过中心计时器管理持续时间，到期自动解除。
-- 可选反伤：被嘲讽单位普攻嘲讽来源时，按配置倍率反弹伤害。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.07．杂项")
local String2OrderIdBJ = ____require_result_0.String2OrderIdBJ
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.05．Buff系统.01．控制抗性.index")
local calcReducedControlDuration = ____require_result_2.calcReducedControlDuration
local isExcludedFromControlResist = ____require_result_2.isExcludedFromControlResist
local buffPool = require("系统.05．Buff系统.00．Buff系统")
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local removeDelayedCallback = ____require_result_3.removeDelayedCallback
local addPeriodicCallback = ____require_result_3.addPeriodicCallback
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心")
local registerTargetOrderListener = ____require_result_4.registerTargetOrderListener
local registerPointOrderListener = ____require_result_4.registerPointOrderListener
local registerImmediateOrderListener = ____require_result_4.registerImmediateOrderListener
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_5.getEnemyUnitsInRange
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_6.debugLogForce
local _____4F24_5BB3_51FD_6570 = require("lib.扩展函数.封装函数.06．伤害函数.index")
local isNormalAttack = _____4F24_5BB3_51FD_6570.isNormalAttack
local GetHandleId = jass.GetHandleId
local GetUnitName = jass.GetUnitName
local IssueTargetOrder = jass.IssueTargetOrder
local GetUnitCurrentOrder = jass.GetUnitCurrentOrder
local IsUnitType = jass.IsUnitType
local UnitDamageTarget = jass.UnitDamageTarget
local _____6A21_5757_540D = "嘲讽系统"
local _____5632_8BBDBuffID = "C020"
local registerManualBuff = buffPool.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = buffPool["移除单位指定Buff"]
local _____5632_8BBD_6620_5C04_8868 = {}
local _____5DF2_521D_59CB_5316 = false
local _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
local _____5F85_6267_884C_53CD_4F24_961F_5217 = {}
local _____53CD_4F24_7ED3_7B97_5DF2_6392_961F = false
local _____81EA_52A8_7EED_653B_56DE_8C03ID = 0
local _____653B_51FB_547D_4EE4ID = 0
local function _____53D6_5355_4F4DID(u)
    if u == nil or u == 0 then
        return 0
    end
    return GetHandleId(u) or 0
end
local function _____5185_90E8_6E05_9664_5632_8BBD(_____76EE_6807ID)
    local _____8BB0_5F55 = _____5632_8BBD_6620_5C04_8868[_____76EE_6807ID]
    if _____8BB0_5F55 == nil then
        return
    end
    if _____8BB0_5F55["延迟回调ID"] ~= 0 then
        removeDelayedCallback(_____8BB0_5F55["延迟回调ID"])
    end
    if _____8BB0_5F55["目标单位引用"] ~= nil and _____8BB0_5F55["目标单位引用"] ~= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____8BB0_5F55["目标单位引用"], _____5632_8BBDBuffID)
    end
    __TS__Delete(_____5632_8BBD_6620_5C04_8868, _____76EE_6807ID)
    debugLogForce(_____6A21_5757_540D, "嘲讽到期 目标ID=", _____76EE_6807ID)
end
local function _____81EA_52A8_7EED_653BTick()
    if _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 then
        return
    end
    if _____653B_51FB_547D_4EE4ID == 0 then
        _____653B_51FB_547D_4EE4ID = String2OrderIdBJ("attack")
    end
    for key in pairs(_____5632_8BBD_6620_5C04_8868) do
        do
            local _____8BB0_5F55 = _____5632_8BBD_6620_5C04_8868[key]
            if _____8BB0_5F55 == nil then
                goto __continue11
            end
            local _____76EE_6807_5355_4F4D = _____8BB0_5F55["目标单位引用"]
            local _____6765_6E90_5355_4F4D = _____8BB0_5F55["来源单位引用"]
            if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
                goto __continue11
            end
            if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
                goto __continue11
            end
            if IsUnitType(_____76EE_6807_5355_4F4D, jass.UNIT_TYPE_DEAD) then
                goto __continue11
            end
            if IsUnitType(_____6765_6E90_5355_4F4D, jass.UNIT_TYPE_DEAD) then
                goto __continue11
            end
            local _____5F53_524D_547D_4EE4 = GetUnitCurrentOrder(_____76EE_6807_5355_4F4D) or 0
            if _____5F53_524D_547D_4EE4 == _____653B_51FB_547D_4EE4ID then
                goto __continue11
            end
            _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = true
            IssueTargetOrder(_____76EE_6807_5355_4F4D, "attack", _____6765_6E90_5355_4F4D)
            _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
        end
        ::__continue11::
    end
end
local function ____on_76EE_6807_6307_4EE4(unit, orderId, targetUnit, _targetItem, _targetDestructable)
    if _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 then
        return
    end
    if _____653B_51FB_547D_4EE4ID == 0 then
        _____653B_51FB_547D_4EE4ID = String2OrderIdBJ("attack")
    end
    local _____5355_4F4DID = _____53D6_5355_4F4DID(unit)
    local _____8BB0_5F55 = _____5632_8BBD_6620_5C04_8868[_____5355_4F4DID]
    if _____8BB0_5F55 == nil then
        return
    end
    local _____6765_6E90 = _____8BB0_5F55["来源单位引用"]
    if _____6765_6E90 == nil or _____6765_6E90 == 0 then
        return
    end
    if orderId == _____653B_51FB_547D_4EE4ID and _____53D6_5355_4F4DID(targetUnit) == _____8BB0_5F55["来源单位ID"] then
        return
    end
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = true
    IssueTargetOrder(unit, "attack", _____6765_6E90)
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
end
local function ____on_70B9_6307_4EE4(unit, orderId, _x, _y)
    if _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 then
        return
    end
    if _____653B_51FB_547D_4EE4ID == 0 then
        _____653B_51FB_547D_4EE4ID = String2OrderIdBJ("attack")
    end
    if orderId == _____653B_51FB_547D_4EE4ID then
        return
    end
    local _____5355_4F4DID = _____53D6_5355_4F4DID(unit)
    local _____8BB0_5F55 = _____5632_8BBD_6620_5C04_8868[_____5355_4F4DID]
    if _____8BB0_5F55 == nil then
        return
    end
    local _____6765_6E90 = _____8BB0_5F55["来源单位引用"]
    if _____6765_6E90 == nil or _____6765_6E90 == 0 then
        return
    end
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = true
    IssueTargetOrder(unit, "attack", _____6765_6E90)
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
end
local function ____on_7ACB_5373_6307_4EE4(unit, orderId)
    if _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 then
        return
    end
    if _____653B_51FB_547D_4EE4ID == 0 then
        _____653B_51FB_547D_4EE4ID = String2OrderIdBJ("attack")
    end
    if orderId == _____653B_51FB_547D_4EE4ID then
        return
    end
    local _____5355_4F4DID = _____53D6_5355_4F4DID(unit)
    local _____8BB0_5F55 = _____5632_8BBD_6620_5C04_8868[_____5355_4F4DID]
    if _____8BB0_5F55 == nil then
        return
    end
    local _____6765_6E90 = _____8BB0_5F55["来源单位引用"]
    if _____6765_6E90 == nil or _____6765_6E90 == 0 then
        return
    end
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = true
    IssueTargetOrder(unit, "attack", _____6765_6E90)
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
end
local function ____flush_53CD_4F24_961F_5217()
    _____53CD_4F24_7ED3_7B97_5DF2_6392_961F = false
    while #_____5F85_6267_884C_53CD_4F24_961F_5217 > 0 do
        do
            local _____8BB0_5F55 = table.remove(_____5F85_6267_884C_53CD_4F24_961F_5217, 1)
            if _____8BB0_5F55 == nil then
                goto __continue38
            end
            local _____653B_51FB_8005 = _____8BB0_5F55["攻击者"]
            local _____4F24_5BB3 = _____8BB0_5F55["伤害"]
            if _____653B_51FB_8005 == nil or _____653B_51FB_8005 == 0 then
                goto __continue38
            end
            if _____4F24_5BB3 <= 0 then
                goto __continue38
            end
            UnitDamageTarget(
                _____653B_51FB_8005,
                _____653B_51FB_8005,
                _____4F24_5BB3,
                false,
                false,
                jass.ATTACK_TYPE_CHAOS,
                jass.DAMAGE_TYPE_UNIVERSAL,
                nil
            )
        end
        ::__continue38::
    end
end
local function ____schedule_53CD_4F24(attacker, damage)
    if attacker == nil or attacker == 0 then
        return
    end
    if damage <= 0 then
        return
    end
    _____5F85_6267_884C_53CD_4F24_961F_5217[#_____5F85_6267_884C_53CD_4F24_961F_5217 + 1] = {["攻击者"] = attacker, ["伤害"] = damage}
    if _____53CD_4F24_7ED3_7B97_5DF2_6392_961F then
        return
    end
    _____53CD_4F24_7ED3_7B97_5DF2_6392_961F = true
    addDelayedCallback(0, ____flush_53CD_4F24_961F_5217)
end
local function ____on_53CD_4F24_6700_7EC8_4F24_5BB3(target, attacker, applied)
    if applied <= 0 then
        return
    end
    if attacker == nil or attacker == 0 then
        return
    end
    if isNormalAttack() ~= true then
        return
    end
    local _____653B_51FB_8005ID = _____53D6_5355_4F4DID(attacker)
    local _____8BB0_5F55 = _____5632_8BBD_6620_5C04_8868[_____653B_51FB_8005ID]
    if _____8BB0_5F55 == nil then
        return
    end
    if _____8BB0_5F55["反伤倍率"] <= 0 then
        return
    end
    if target == nil or target == 0 then
        return
    end
    if _____53D6_5355_4F4DID(target) ~= _____8BB0_5F55["来源单位ID"] then
        return
    end
    local _____53CD_4F24_4F24_5BB3 = applied * _____8BB0_5F55["反伤倍率"]
    debugLogForce(
        _____6A21_5757_540D,
        "反伤 被嘲讽者=",
        _____653B_51FB_8005ID,
        "伤害=",
        _____53CD_4F24_4F24_5BB3
    )
    ____schedule_53CD_4F24(attacker, _____53CD_4F24_4F24_5BB3)
end
local function _____786E_4FDD_521D_59CB_5316()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    registerTargetOrderListener(____on_76EE_6807_6307_4EE4)
    registerPointOrderListener(____on_70B9_6307_4EE4)
    registerImmediateOrderListener(____on_7ACB_5373_6307_4EE4)
    registerAppliedFinalDamageListener(____on_53CD_4F24_6700_7EC8_4F24_5BB3)
    _____81EA_52A8_7EED_653B_56DE_8C03ID = addPeriodicCallback(250, _____81EA_52A8_7EED_653BTick)
end
____exports["施加嘲讽"] = function(_____6765_6E90_5355_4F4D_6216Self, _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D, _____53C2_6570_6216_76EE_6807_5355_4F4D, _____517C_5BB9_53C2_6570)
    local _____6765_6E90_5355_4F4D = _____6765_6E90_5355_4F4D_6216Self
    local _____76EE_6807_5355_4F4D = _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D
    local _____53C2_6570 = _____53C2_6570_6216_76EE_6807_5355_4F4D
    if _____517C_5BB9_53C2_6570 ~= nil then
        _____6765_6E90_5355_4F4D = _____76EE_6807_5355_4F4D_6216_6765_6E90_5355_4F4D
        _____76EE_6807_5355_4F4D = _____53C2_6570_6216_76EE_6807_5355_4F4D
        _____53C2_6570 = _____517C_5BB9_53C2_6570
    end
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        return 0
    end
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return 0
    end
    if _____53C2_6570["持续时间"] == nil or _____53C2_6570["持续时间"] <= 0 then
        return 0
    end
    _____786E_4FDD_521D_59CB_5316()
    local _____5B9E_9645_6301_7EED_65F6_95F4 = _____53C2_6570["持续时间"]
    if not isExcludedFromControlResist(_____76EE_6807_5355_4F4D) then
        _____5B9E_9645_6301_7EED_65F6_95F4 = calcReducedControlDuration(_____76EE_6807_5355_4F4D, _____53C2_6570["持续时间"])
    end
    if _____5B9E_9645_6301_7EED_65F6_95F4 <= 0 then
        return 0
    end
    local _____76EE_6807ID = _____53D6_5355_4F4DID(_____76EE_6807_5355_4F4D)
    if _____76EE_6807ID == 0 then
        return 0
    end
    if _____5632_8BBD_6620_5C04_8868[_____76EE_6807ID] ~= nil then
        _____5185_90E8_6E05_9664_5632_8BBD(_____76EE_6807ID)
    end
    local _____5EF6_8FDF_56DE_8C03ID = addDelayedCallback(
        _____5B9E_9645_6301_7EED_65F6_95F4 * 1000,
        function()
            _____5185_90E8_6E05_9664_5632_8BBD(_____76EE_6807ID)
        end
    )
    _____5632_8BBD_6620_5C04_8868[_____76EE_6807ID] = {
        ["来源单位ID"] = _____53D6_5355_4F4DID(_____6765_6E90_5355_4F4D),
        ["反伤倍率"] = _____53C2_6570["反伤倍率"] or 0,
        ["延迟回调ID"] = _____5EF6_8FDF_56DE_8C03ID,
        ["来源单位引用"] = _____6765_6E90_5355_4F4D,
        ["目标单位引用"] = _____76EE_6807_5355_4F4D
    }
    registerManualBuff(
        _____76EE_6807_5355_4F4D,
        _____5632_8BBDBuffID,
        _____5B9E_9645_6301_7EED_65F6_95F4,
        0,
        {sourceName = GetUnitName(_____6765_6E90_5355_4F4D)}
    )
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = true
    local _____547D_4EE4_7ED3_679C = IssueTargetOrder(_____76EE_6807_5355_4F4D, "attack", _____6765_6E90_5355_4F4D)
    debugLogForce(_____6A21_5757_540D, "施加嘲讽 首发attack结果=", _____547D_4EE4_7ED3_679C)
    _____6B63_5728_53D1_5E03_8986_76D6_547D_4EE4 = false
    debugLogForce(
        _____6A21_5757_540D,
        "施加嘲讽 来源=",
        _____53D6_5355_4F4DID(_____6765_6E90_5355_4F4D),
        "目标=",
        _____76EE_6807ID,
        "持续=",
        _____5B9E_9645_6301_7EED_65F6_95F4,
        "秒 反伤倍率=",
        _____53C2_6570["反伤倍率"] or 0
    )
    return _____76EE_6807ID
end
____exports["AOE施加嘲讽"] = function(_____6765_6E90_5355_4F4D_6216Self, _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D, _____4E2D_5FC3Y_6216_4E2D_5FC3X, _____534A_5F84_6216_4E2D_5FC3Y, _____53C2_6570_6216_534A_5F84, _____517C_5BB9_53C2_6570)
    local _____6765_6E90_5355_4F4D = _____6765_6E90_5355_4F4D_6216Self
    local _____4E2D_5FC3X = _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D
    local _____4E2D_5FC3Y = _____4E2D_5FC3Y_6216_4E2D_5FC3X
    local _____534A_5F84 = _____534A_5F84_6216_4E2D_5FC3Y
    local _____53C2_6570 = _____53C2_6570_6216_534A_5F84
    if _____517C_5BB9_53C2_6570 ~= nil then
        _____6765_6E90_5355_4F4D = _____4E2D_5FC3X_6216_6765_6E90_5355_4F4D
        _____4E2D_5FC3X = _____4E2D_5FC3Y_6216_4E2D_5FC3X
        _____4E2D_5FC3Y = _____534A_5F84_6216_4E2D_5FC3Y
        _____534A_5F84 = _____53C2_6570_6216_534A_5F84
        _____53C2_6570 = _____517C_5BB9_53C2_6570
    end
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        return {}
    end
    local _____76EE_6807_5217_8868 = getEnemyUnitsInRange(_____6765_6E90_5355_4F4D, _____4E2D_5FC3X, _____4E2D_5FC3Y, _____534A_5F84)
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            do
                local _____76EE_6807 = _____76EE_6807_5217_8868[i + 1]
                if _____76EE_6807 == nil or _____76EE_6807 == 0 then
                    goto __continue70
                end
                local id = ____exports["施加嘲讽"](_____6765_6E90_5355_4F4D, _____76EE_6807, _____53C2_6570)
                if id ~= 0 then
                    _____7ED3_679C[#_____7ED3_679C + 1] = id
                end
            end
            ::__continue70::
            i = i + 1
        end
    end
    debugLogForce(
        _____6A21_5757_540D,
        "AOE施加嘲讽 范围=",
        _____534A_5F84,
        "命中=",
        #_____7ED3_679C,
        "个单位"
    )
    return _____7ED3_679C
end
____exports["移除嘲讽"] = function(_____76EE_6807_5355_4F4D_6216Self, _____517C_5BB9_76EE_6807_5355_4F4D)
    local ____517C_5BB9_76EE_6807_5355_4F4D_7 = _____517C_5BB9_76EE_6807_5355_4F4D
    if ____517C_5BB9_76EE_6807_5355_4F4D_7 == nil then
        ____517C_5BB9_76EE_6807_5355_4F4D_7 = _____76EE_6807_5355_4F4D_6216Self
    end
    local _____76EE_6807_5355_4F4D = ____517C_5BB9_76EE_6807_5355_4F4D_7
    local _____76EE_6807ID = _____53D6_5355_4F4DID(_____76EE_6807_5355_4F4D)
    if _____76EE_6807ID == 0 then
        return false
    end
    if _____5632_8BBD_6620_5C04_8868[_____76EE_6807ID] == nil then
        return false
    end
    _____5185_90E8_6E05_9664_5632_8BBD(_____76EE_6807ID)
    return true
end
____exports["单位是否被嘲讽"] = function(_____76EE_6807_5355_4F4D_6216Self, _____517C_5BB9_76EE_6807_5355_4F4D)
    local ____517C_5BB9_76EE_6807_5355_4F4D_8 = _____517C_5BB9_76EE_6807_5355_4F4D
    if ____517C_5BB9_76EE_6807_5355_4F4D_8 == nil then
        ____517C_5BB9_76EE_6807_5355_4F4D_8 = _____76EE_6807_5355_4F4D_6216Self
    end
    local _____76EE_6807_5355_4F4D = ____517C_5BB9_76EE_6807_5355_4F4D_8
    local _____76EE_6807ID = _____53D6_5355_4F4DID(_____76EE_6807_5355_4F4D)
    if _____76EE_6807ID == 0 then
        return false
    end
    return _____5632_8BBD_6620_5C04_8868[_____76EE_6807ID] ~= nil
end
____exports["获取嘲讽来源单位"] = function(_____76EE_6807_5355_4F4D_6216Self, _____517C_5BB9_76EE_6807_5355_4F4D)
    local ____517C_5BB9_76EE_6807_5355_4F4D_9 = _____517C_5BB9_76EE_6807_5355_4F4D
    if ____517C_5BB9_76EE_6807_5355_4F4D_9 == nil then
        ____517C_5BB9_76EE_6807_5355_4F4D_9 = _____76EE_6807_5355_4F4D_6216Self
    end
    local _____76EE_6807_5355_4F4D = ____517C_5BB9_76EE_6807_5355_4F4D_9
    local _____76EE_6807ID = _____53D6_5355_4F4DID(_____76EE_6807_5355_4F4D)
    if _____76EE_6807ID == 0 then
        return nil
    end
    local _____8BB0_5F55 = _____5632_8BBD_6620_5C04_8868[_____76EE_6807ID]
    if _____8BB0_5F55 == nil then
        return nil
    end
    return _____8BB0_5F55["来源单位引用"]
end
return ____exports
