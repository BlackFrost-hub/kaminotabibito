local ____lualib = require("lualib_bundle")
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
local registerPlayerUnitEventForPlayerIds = ____require_result_2.registerPlayerUnitEventForPlayerIds
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local addPeriodicCallback = ____require_result_3.addPeriodicCallback
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_4.YDUserDataGetSafe
local ____require_result_5 = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
local IsUnitPausedBJ = ____require_result_5.IsUnitPausedBJ
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isValidCombatEnemyUnit = ____require_result_6.isValidCombatEnemyUnit
local ____require_result_7 = require("系统.01．单位系统.06．仇恨系统.02．目标选择")
local _____83B7_53D6_6700_9AD8_4EC7_6068_653B_51FB_76EE_6807 = ____require_result_7["获取最高仇恨攻击目标"]
local CreateUnit = jass.CreateUnit
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitType = jass.IsUnitType
local UnitAddType = jass.UnitAddType
local KillUnit = jass.KillUnit
local RemoveUnit = jass.RemoveUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitCurrentOrder = jass.GetUnitCurrentOrder
local IsPlayerInForce = jass.IsPlayerInForce
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local IssueTargetOrder = jass.IssueTargetOrder
local IssuePointOrder = jass.IssuePointOrder
local GetRandomReal = jass.GetRandomReal
local Cos = jass.Cos
local Sin = jass.Sin
local OrderId = jass.OrderId
local GetAttacker = jass.GetAttacker
local GetTriggerUnit = jass.GetTriggerUnit
local CreateTrigger = jass.CreateTrigger
local TriggerAddAction = jass.TriggerAddAction
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_TYPE_SUMMONED = jass.UNIT_TYPE_SUMMONED
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local EVENT_PLAYER_UNIT_ATTACKED = jass.EVENT_PLAYER_UNIT_ATTACKED
local _____62A4_536B_9A71_52A8_95F4_9694_6BEB_79D2 = 250
local _____62A4_536B_4FDD_62A4Boss_8303_56F4 = 1500
local _____62A4_536B_8FD4_56DEBoss_8DDD_79BB = 300
local _____62A4_536B_8FD4_56DE_70B9_5230_8FBE_8DDD_79BB_5E73_65B9 = 80 * 80
local _____62A4_536B_8FD4_56DE_70B9Boss_79FB_52A8_5237_65B0_8DDD_79BB_5E73_65B9 = 100 * 100
local _____89D2_5EA6_8F6C_5F27_5EA6 = 0.017453292519943295
local _____653B_51FB_547D_4EE4ID = OrderId("attack")
local _____653B_51FB_4E00_6B21_547D_4EE4ID = OrderId("attackonce")
local _____79FB_52A8_547D_4EE4ID = OrderId("move")
local _____505C_6B62_547D_4EE4ID = OrderId("stop")
local _____4FDD_6301_547D_4EE4ID = OrderId("holdposition")
local _____62A4_536B_653B_51FB_4E8B_4EF6_73A9_5BB6ID = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15
}
local _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_8BB0_5F55_8868 = {}
local _____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_53E5_67C4_8868 = {}
local _____62A4_536B_767B_8BB0_987A_5E8F_8BA1_6570 = 0
local _____62A4_536B_9A71_52A8_56DE_8C03ID = 0
local _____62A4_536B_653B_51FB_7EA0_504F_4E8B_4EF6_5DF2_6CE8_518C = false
local _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_9A71_52A8_72B6_6001_8868 = {}
local function _____83B7_53D6_53E5_67C4ID(handle)
    if handle == nil or handle == 0 then
        return 0
    end
    return GetHandleId(handle) or 0
end
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____521B_5EFA_7A7A_9A71_52A8_72B6_6001()
    return {
        ["模式"] = "无",
        ["攻击目标ID"] = 0,
        ["返回角度"] = 0,
        ["返回目标X"] = 0,
        ["返回目标Y"] = 0,
        ["返回锚点BossX"] = 0,
        ["返回锚点BossY"] = 0
    }
end
local function _____5F53_524D_547D_4EE4_5141_8BB8_62A4_536B_9A71_52A8(guard)
    if IsUnitPausedBJ(guard) then
        return false
    end
    local orderId = GetUnitCurrentOrder(guard) or 0
    return orderId == 0 or orderId == _____653B_51FB_547D_4EE4ID or orderId == _____653B_51FB_4E00_6B21_547D_4EE4ID or orderId == _____79FB_52A8_547D_4EE4ID or orderId == _____505C_6B62_547D_4EE4ID or orderId == _____4FDD_6301_547D_4EE4ID
end
local function _____5355_4F4D_53EF_4F5C_4E3A_4EC7_6068_76EE_6807(entry)
    return _____5355_4F4D_5B58_6D3B(entry.targetRef)
end
local function _____83B7_53D6_62A4_536B_4EC7_6068_76EE_6807(guard)
    local entry = _____83B7_53D6_6700_9AD8_4EC7_6068_653B_51FB_76EE_6807(guard, _____5355_4F4D_53EF_4F5C_4E3A_4EC7_6068_76EE_6807)
    local ____temp_8
    if entry == nil then
        ____temp_8 = nil
    else
        ____temp_8 = entry.targetRef
    end
    return ____temp_8
end
local function _____5F53_524D_6B63_5728_6267_884C_653B_51FB_547D_4EE4(guard)
    local orderId = GetUnitCurrentOrder(guard) or 0
    return orderId == _____653B_51FB_547D_4EE4ID or orderId == _____653B_51FB_4E00_6B21_547D_4EE4ID
end
local function _____9009_62E9Boss_9644_8FD1_6218_6597_76EE_6807(boss, _____73A9_5BB6_7EC4)
    local group = CreateGroup()
    if group == nil or group == 0 then
        return nil
    end
    local bossX = GetUnitX(boss)
    local bossY = GetUnitY(boss)
    local result = nil
    local resultIsYDPlayer = false
    local resultIsHero = false
    local bestDistanceSq = 0
    local bestHandleId = 0
    GroupEnumUnitsInRange(
        group,
        bossX,
        bossY,
        _____62A4_536B_4FDD_62A4Boss_8303_56F4,
        nil
    )
    while true do
        do
            local candidate = FirstOfGroup(group)
            if candidate == nil or candidate == 0 then
                break
            end
            GroupRemoveUnit(group, candidate)
            if not isValidCombatEnemyUnit(candidate, boss) then
                goto __continue13
            end
            local owner = GetOwningPlayer(candidate)
            local candidateIsYDPlayer = _____73A9_5BB6_7EC4 ~= nil and _____73A9_5BB6_7EC4 ~= 0 and owner ~= nil and owner ~= 0 and IsPlayerInForce(owner, _____73A9_5BB6_7EC4)
            local candidateIsHero = IsUnitType(candidate, UNIT_TYPE_HERO) == true
            local dx = GetUnitX(candidate) - bossX
            local dy = GetUnitY(candidate) - bossY
            local distanceSq = dx * dx + dy * dy
            local handleId = _____83B7_53D6_53E5_67C4ID(candidate)
            if result == nil or candidateIsYDPlayer and not resultIsYDPlayer or candidateIsYDPlayer == resultIsYDPlayer and candidateIsHero and not resultIsHero or candidateIsYDPlayer == resultIsYDPlayer and candidateIsHero == resultIsHero and (distanceSq < bestDistanceSq or distanceSq == bestDistanceSq and handleId < bestHandleId) then
                result = candidate
                resultIsYDPlayer = candidateIsYDPlayer
                resultIsHero = candidateIsHero
                bestDistanceSq = distanceSq
                bestHandleId = handleId
            end
        end
        ::__continue13::
    end
    DestroyGroup(group)
    return result
end
local function _____9A71_52A8_62A4_536B_653B_51FB(guard, target, state)
    local targetId = _____83B7_53D6_53E5_67C4ID(target)
    local currentOrderId = GetUnitCurrentOrder(guard) or 0
    local _____5DF2_5728_653B_51FB_76F8_540C_76EE_6807 = state["模式"] == "攻击" and state["攻击目标ID"] == targetId and (currentOrderId == _____653B_51FB_547D_4EE4ID or currentOrderId == _____653B_51FB_4E00_6B21_547D_4EE4ID)
    if _____5DF2_5728_653B_51FB_76F8_540C_76EE_6807 or not _____5F53_524D_547D_4EE4_5141_8BB8_62A4_536B_9A71_52A8(guard) then
        return
    end
    if IssueTargetOrder(guard, "attack", target) then
        state["模式"] = "攻击"
        state["攻击目标ID"] = targetId
    end
end
local function ____on_62A4_536B_5F00_59CB_653B_51FB()
    local guard = GetAttacker()
    local guardHandleId = _____83B7_53D6_53E5_67C4ID(guard)
    if guardHandleId == 0 then
        return
    end
    local record = _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_8BB0_5F55_8868[guardHandleId]
    if record == nil or record["护卫单位"] ~= guard or not _____5355_4F4D_5B58_6D3B(record["主Boss单位"]) then
        return
    end
    local _____73A9_5BB6_7EC4 = YDUserDataGetSafe("string", "玩家", "玩家组", "force")
    local target = _____83B7_53D6_62A4_536B_4EC7_6068_76EE_6807(guard)
    if target == nil or target == 0 then
        target = _____9009_62E9Boss_9644_8FD1_6218_6597_76EE_6807(record["主Boss单位"], _____73A9_5BB6_7EC4)
    end
    if target == nil or target == 0 then
        return
    end
    local state = _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_9A71_52A8_72B6_6001_8868[guardHandleId]
    if state == nil then
        state = _____521B_5EFA_7A7A_9A71_52A8_72B6_6001()
        _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_9A71_52A8_72B6_6001_8868[guardHandleId] = state
    end
    local actualTargetId = _____83B7_53D6_53E5_67C4ID(GetTriggerUnit())
    local expectedTargetId = _____83B7_53D6_53E5_67C4ID(target)
    if actualTargetId == expectedTargetId then
        state["模式"] = "攻击"
        state["攻击目标ID"] = expectedTargetId
        return
    end
    state["模式"] = "攻击"
    state["攻击目标ID"] = actualTargetId
    _____9A71_52A8_62A4_536B_653B_51FB(guard, target, state)
end
local function _____6CE8_518C_62A4_536B_653B_51FB_7EA0_504F_4E8B_4EF6()
    if _____62A4_536B_653B_51FB_7EA0_504F_4E8B_4EF6_5DF2_6CE8_518C then
        return
    end
    _____62A4_536B_653B_51FB_7EA0_504F_4E8B_4EF6_5DF2_6CE8_518C = true
    local trig = CreateTrigger()
    registerPlayerUnitEventForPlayerIds(trig, _____62A4_536B_653B_51FB_4E8B_4EF6_73A9_5BB6ID, EVENT_PLAYER_UNIT_ATTACKED)
    TriggerAddAction(trig, ____on_62A4_536B_5F00_59CB_653B_51FB)
end
local function _____5237_65B0_62A4_536B_8FD4_56DE_70B9(boss, state)
    local bossX = GetUnitX(boss)
    local bossY = GetUnitY(boss)
    state["返回角度"] = GetRandomReal(0, 360)
    state["返回目标X"] = bossX + Cos(state["返回角度"] * _____89D2_5EA6_8F6C_5F27_5EA6) * _____62A4_536B_8FD4_56DEBoss_8DDD_79BB
    state["返回目标Y"] = bossY + Sin(state["返回角度"] * _____89D2_5EA6_8F6C_5F27_5EA6) * _____62A4_536B_8FD4_56DEBoss_8DDD_79BB
    state["返回锚点BossX"] = bossX
    state["返回锚点BossY"] = bossY
end
local function _____9A71_52A8_62A4_536B_56DE_4F4D(guard, boss, state)
    local bossDx = GetUnitX(boss) - state["返回锚点BossX"]
    local bossDy = GetUnitY(boss) - state["返回锚点BossY"]
    local ____boss_5DF2_660E_663E_79FB_52A8 = bossDx * bossDx + bossDy * bossDy >= _____62A4_536B_8FD4_56DE_70B9Boss_79FB_52A8_5237_65B0_8DDD_79BB_5E73_65B9
    if state["模式"] ~= "回位" or ____boss_5DF2_660E_663E_79FB_52A8 then
        _____5237_65B0_62A4_536B_8FD4_56DE_70B9(boss, state)
    end
    local dx = GetUnitX(guard) - state["返回目标X"]
    local dy = GetUnitY(guard) - state["返回目标Y"]
    if dx * dx + dy * dy <= _____62A4_536B_8FD4_56DE_70B9_5230_8FBE_8DDD_79BB_5E73_65B9 then
        state["模式"] = "回位"
        state["攻击目标ID"] = 0
        return
    end
    if not _____5F53_524D_547D_4EE4_5141_8BB8_62A4_536B_9A71_52A8(guard) then
        return
    end
    local currentOrderId = GetUnitCurrentOrder(guard) or 0
    if state["模式"] == "回位" and currentOrderId == _____79FB_52A8_547D_4EE4ID and not ____boss_5DF2_660E_663E_79FB_52A8 then
        return
    end
    if IssuePointOrder(guard, "move", state["返回目标X"], state["返回目标Y"]) then
        state["模式"] = "回位"
        state["攻击目标ID"] = 0
    end
end
local function ____on_62A4_536B_9A71_52A8Tick()
    local _____73A9_5BB6_7EC4 = YDUserDataGetSafe("string", "玩家", "玩家组", "force")
    for bossKey in pairs(_____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_53E5_67C4_8868) do
        do
            local bossHandleId = __TS__ParseInt(bossKey, 10)
            if __TS__NumberIsNaN(__TS__Number(bossHandleId)) then
                goto __continue37
            end
            local list = _____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_53E5_67C4_8868[bossHandleId]
            if list == nil or #list == 0 then
                goto __continue37
            end
            local boss = nil
            do
                local i = 0
                while i < #list do
                    local record = _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_8BB0_5F55_8868[list[i + 1]]
                    if record ~= nil and _____83B7_53D6_53E5_67C4ID(record["主Boss单位"]) == bossHandleId then
                        boss = record["主Boss单位"]
                        break
                    end
                    i = i + 1
                end
            end
            if not _____5355_4F4D_5B58_6D3B(boss) then
                goto __continue37
            end
            local fallbackTarget = _____9009_62E9Boss_9644_8FD1_6218_6597_76EE_6807(boss, _____73A9_5BB6_7EC4)
            do
                local i = 0
                while i < #list do
                    do
                        local guardHandleId = list[i + 1]
                        local record = _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_8BB0_5F55_8868[guardHandleId]
                        if record == nil or record["主Boss单位"] ~= boss or not _____5355_4F4D_5B58_6D3B(record["护卫单位"]) then
                            goto __continue45
                        end
                        local state = _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_9A71_52A8_72B6_6001_8868[guardHandleId]
                        if state == nil then
                            state = _____521B_5EFA_7A7A_9A71_52A8_72B6_6001()
                            _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_9A71_52A8_72B6_6001_8868[guardHandleId] = state
                        end
                        local threatTarget = _____83B7_53D6_62A4_536B_4EC7_6068_76EE_6807(record["护卫单位"])
                        if threatTarget ~= nil and threatTarget ~= 0 then
                            _____9A71_52A8_62A4_536B_653B_51FB(record["护卫单位"], threatTarget, state)
                            goto __continue45
                        end
                        if fallbackTarget ~= nil and fallbackTarget ~= 0 then
                            _____9A71_52A8_62A4_536B_653B_51FB(record["护卫单位"], fallbackTarget, state)
                            goto __continue45
                        end
                        if _____5F53_524D_6B63_5728_6267_884C_653B_51FB_547D_4EE4(record["护卫单位"]) then
                            goto __continue45
                        end
                        _____9A71_52A8_62A4_536B_56DE_4F4D(record["护卫单位"], boss, state)
                    end
                    ::__continue45::
                    i = i + 1
                end
            end
        end
        ::__continue37::
    end
end
local function _____786E_4FDD_62A4_536B_9A71_52A8_5DF2_542F_52A8()
    if _____62A4_536B_9A71_52A8_56DE_8C03ID ~= 0 then
        return
    end
    _____6CE8_518C_62A4_536B_653B_51FB_7EA0_504F_4E8B_4EF6()
    _____62A4_536B_9A71_52A8_56DE_8C03ID = addPeriodicCallback(_____62A4_536B_9A71_52A8_95F4_9694_6BEB_79D2, ____on_62A4_536B_9A71_52A8Tick)
end
local function _____4ECEBoss_7D22_5F15_79FB_9664(bossHandleId, guardHandleId)
    local list = _____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_53E5_67C4_8868[bossHandleId]
    if list == nil then
        return
    end
    do
        local i = #list - 1
        while i >= 0 do
            if list[i + 1] == guardHandleId then
                __TS__ArraySplice(list, i, 1)
            end
            i = i - 1
        end
    end
    if #list == 0 then
        __TS__Delete(_____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_53E5_67C4_8868, bossHandleId)
    end
end
local function _____89E3_6790_5355_4F4D_7C7B_578BID(unitType)
    if type(unitType) == "number" then
        return unitType
    end
    return stringToFourCCSafe(unitType)
end
____exports["登记护卫单位"] = function(guard, _____53C2_6570)
    local guardHandleId = _____83B7_53D6_53E5_67C4ID(guard)
    local bossHandleId = _____83B7_53D6_53E5_67C4ID(_____53C2_6570["主Boss单位"])
    if guardHandleId == 0 or bossHandleId == 0 then
        return guard
    end
    local oldRecord = _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_8BB0_5F55_8868[guardHandleId]
    if oldRecord ~= nil and oldRecord["护卫单位"] == guard then
        local oldBossHandleId = _____83B7_53D6_53E5_67C4ID(oldRecord["主Boss单位"])
        if oldBossHandleId ~= bossHandleId then
            _____4ECEBoss_7D22_5F15_79FB_9664(oldBossHandleId, guardHandleId)
        end
    elseif oldRecord ~= nil then
        _____4ECEBoss_7D22_5F15_79FB_9664(
            _____83B7_53D6_53E5_67C4ID(oldRecord["主Boss单位"]),
            guardHandleId
        )
    end
    local _____662F_5426_539F_8BB0_5F55 = oldRecord ~= nil and oldRecord["护卫单位"] == guard
    if not _____662F_5426_539F_8BB0_5F55 then
        _____62A4_536B_767B_8BB0_987A_5E8F_8BA1_6570 = _____62A4_536B_767B_8BB0_987A_5E8F_8BA1_6570 + 1
    end
    if _____53C2_6570["标记为召唤单位"] == true then
        UnitAddType(guard, UNIT_TYPE_SUMMONED)
    end
    local ____guard_11 = guard
    local ____53C2_6570__4E3BBoss_5355_4F4D_12 = _____53C2_6570["主Boss单位"]
    local ____53C2_6570__62A4_536B_7C7B_578B_13 = _____53C2_6570["护卫类型"]
    local ____temp_14 = _____53C2_6570["标记为召唤单位"] == true
    local ____temp_15 = _____53C2_6570["护卫血条优先级"] or (_____662F_5426_539F_8BB0_5F55 and oldRecord["护卫血条优先级"] or 0)
    local ____temp_16 = _____53C2_6570["Boss结束处理"] or (_____662F_5426_539F_8BB0_5F55 and oldRecord["Boss结束处理"] or "注销")
    local ____53C2_6570_on_6B7B_4EA1_10 = _____53C2_6570["on死亡"]
    if ____53C2_6570_on_6B7B_4EA1_10 == nil then
        local _____662F_5426_539F_8BB0_5F55_9
        if _____662F_5426_539F_8BB0_5F55 then
            _____662F_5426_539F_8BB0_5F55_9 = oldRecord["on死亡"]
        else
            _____662F_5426_539F_8BB0_5F55_9 = nil
        end
        ____53C2_6570_on_6B7B_4EA1_10 = _____662F_5426_539F_8BB0_5F55_9
    end
    _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_8BB0_5F55_8868[guardHandleId] = {
        ["护卫单位"] = ____guard_11,
        ["主Boss单位"] = ____53C2_6570__4E3BBoss_5355_4F4D_12,
        ["护卫类型"] = ____53C2_6570__62A4_536B_7C7B_578B_13,
        ["是否召唤单位"] = ____temp_14,
        ["护卫血条优先级"] = ____temp_15,
        ["Boss结束处理"] = ____temp_16,
        ["on死亡"] = ____53C2_6570_on_6B7B_4EA1_10,
        ["登记顺序"] = _____662F_5426_539F_8BB0_5F55 and oldRecord["登记顺序"] or _____62A4_536B_767B_8BB0_987A_5E8F_8BA1_6570
    }
    local list = _____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_53E5_67C4_8868[bossHandleId]
    if list == nil then
        list = {}
        _____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_53E5_67C4_8868[bossHandleId] = list
    end
    local exists = false
    do
        local i = 0
        while i < #list do
            if list[i + 1] == guardHandleId then
                exists = true
                break
            end
            i = i + 1
        end
    end
    if not exists then
        list[#list + 1] = guardHandleId
    end
    if not _____662F_5426_539F_8BB0_5F55 or _____83B7_53D6_53E5_67C4ID(oldRecord and oldRecord["主Boss单位"]) ~= bossHandleId then
        _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_9A71_52A8_72B6_6001_8868[guardHandleId] = _____521B_5EFA_7A7A_9A71_52A8_72B6_6001()
    end
    _____786E_4FDD_62A4_536B_9A71_52A8_5DF2_542F_52A8()
    return guard
end
____exports["创建护卫单位"] = function(_____53C2_6570)
    local unitTypeId = _____89E3_6790_5355_4F4D_7C7B_578BID(_____53C2_6570["单位类型"])
    if unitTypeId == 0 then
        return nil
    end
    local ____53C2_6570__6240_5C5E_73A9_5BB6_19 = _____53C2_6570["所属玩家"]
    if ____53C2_6570__6240_5C5E_73A9_5BB6_19 == nil then
        ____53C2_6570__6240_5C5E_73A9_5BB6_19 = GetOwningPlayer(_____53C2_6570["主Boss单位"])
    end
    local owner = ____53C2_6570__6240_5C5E_73A9_5BB6_19
    if owner == nil or owner == 0 then
        return nil
    end
    local guard = CreateUnit(
        owner,
        unitTypeId,
        _____53C2_6570.X,
        _____53C2_6570.Y,
        _____53C2_6570["面向"] or 270
    )
    if guard == nil or guard == 0 then
        return nil
    end
    return ____exports["登记护卫单位"](guard, _____53C2_6570)
end
____exports["创建自定义护卫单位"] = function(_____53C2_6570, _____521B_5EFA_5668)
    if _____521B_5EFA_5668 == nil then
        return nil
    end
    local guard = _____521B_5EFA_5668()
    if guard == nil or guard == 0 then
        return nil
    end
    return ____exports["登记护卫单位"](guard, _____53C2_6570)
end
____exports["注销护卫单位"] = function(guard)
    local guardHandleId = _____83B7_53D6_53E5_67C4ID(guard)
    if guardHandleId == 0 then
        return false
    end
    local record = _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_8BB0_5F55_8868[guardHandleId]
    if record == nil or record["护卫单位"] ~= guard then
        return false
    end
    _____4ECEBoss_7D22_5F15_79FB_9664(
        _____83B7_53D6_53E5_67C4ID(record["主Boss单位"]),
        guardHandleId
    )
    __TS__Delete(_____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_8BB0_5F55_8868, guardHandleId)
    __TS__Delete(_____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_9A71_52A8_72B6_6001_8868, guardHandleId)
    return true
end
____exports["是否护卫单位"] = function(unit)
    local handleId = _____83B7_53D6_53E5_67C4ID(unit)
    if handleId == 0 then
        return false
    end
    local record = _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_8BB0_5F55_8868[handleId]
    return record ~= nil and record["护卫单位"] == unit
end
____exports["获取护卫记录"] = function(unit)
    local handleId = _____83B7_53D6_53E5_67C4ID(unit)
    if handleId == 0 then
        return nil
    end
    local record = _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_8BB0_5F55_8868[handleId]
    return record ~= nil and record["护卫单位"] == unit and record or nil
end
____exports["获取护卫所属Boss"] = function(unit)
    local ____opt_20 = ____exports["获取护卫记录"](unit)
    return ____opt_20 and ____opt_20["主Boss单位"]
end
____exports["获取护卫类型"] = function(unit)
    local ____opt_22 = ____exports["获取护卫记录"](unit)
    return ____opt_22 and ____opt_22["护卫类型"]
end
____exports["是否指定Boss护卫"] = function(unit, boss)
    local record = ____exports["获取护卫记录"](unit)
    return record ~= nil and record["主Boss单位"] == boss
end
____exports["获取Boss护卫列表"] = function(boss, _____53EA_8FD4_56DE_5B58_6D3B)
    if _____53EA_8FD4_56DE_5B58_6D3B == nil then
        _____53EA_8FD4_56DE_5B58_6D3B = true
    end
    local result = {}
    local bossHandleId = _____83B7_53D6_53E5_67C4ID(boss)
    if bossHandleId == 0 then
        return result
    end
    local list = _____6309Boss_53E5_67C4_7D22_5F15_7684_62A4_536B_53E5_67C4_8868[bossHandleId]
    if list == nil then
        return result
    end
    do
        local i = 0
        while i < #list do
            do
                local record = _____6309_62A4_536B_53E5_67C4_7D22_5F15_7684_8BB0_5F55_8868[list[i + 1]]
                if record == nil or record["主Boss单位"] ~= boss then
                    goto __continue96
                end
                if _____53EA_8FD4_56DE_5B58_6D3B and not _____5355_4F4D_5B58_6D3B(record["护卫单位"]) then
                    goto __continue96
                end
                result[#result + 1] = record["护卫单位"]
            end
            ::__continue96::
            i = i + 1
        end
    end
    return result
end
____exports["注销Boss全部护卫"] = function(boss)
    local list = ____exports["获取Boss护卫列表"](boss, false)
    do
        local i = 0
        while i < #list do
            ____exports["注销护卫单位"](list[i + 1])
            i = i + 1
        end
    end
end
____exports["处理Boss结束全部护卫"] = function(boss)
    local list = ____exports["获取Boss护卫列表"](boss, false)
    do
        local i = 0
        while i < #list do
            do
                local guard = list[i + 1]
                local record = ____exports["获取护卫记录"](guard)
                if record == nil or record["主Boss单位"] ~= boss then
                    goto __continue104
                end
                local _____7ED3_675F_5904_7406 = record["Boss结束处理"]
                ____exports["注销护卫单位"](guard)
                if _____7ED3_675F_5904_7406 == "移除" then
                    RemoveUnit(guard)
                elseif _____7ED3_675F_5904_7406 == "击杀" and _____5355_4F4D_5B58_6D3B(guard) then
                    KillUnit(guard)
                end
            end
            ::__continue104::
            i = i + 1
        end
    end
end
local function ____on_5355_4F4D_6B7B_4EA1(dyingUnit, killingUnit)
    ____exports["处理Boss结束全部护卫"](dyingUnit)
    local record = ____exports["获取护卫记录"](dyingUnit)
    if record == nil then
        return
    end
    if record["on死亡"] ~= nil then
        record["on死亡"](dyingUnit, killingUnit, record)
    end
    if record["护卫血条优先级"] > 0 then
        return
    end
    addDelayedCallback(
        10,
        function()
            ____exports["注销护卫单位"](dyingUnit)
        end
    )
end
registerDeathListener(____on_5355_4F4D_6B7B_4EA1)
return ____exports
