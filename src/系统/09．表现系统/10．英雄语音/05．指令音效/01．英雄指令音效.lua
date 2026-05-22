local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local _____53D6_6CE8_518C_82F1_96C4, _____662F_6CE8_518C_73A9_5BB6_82F1_96C4_5355_4F4D, _____53D6_82F1_96C4_6307_4EE4_97F3_6548_914D_7F6E, _____53D6_968F_673A_97F3_6548, _____53D6_5F53_524D_4E8B_4EF6_97F3_6548, _____672C_5730_64AD_653E, _____51B7_5374_7ED3_675F, _____8BB0_5F55_5E76_5F00_59CB_51B7_5374, _____53D6_4E8B_4EF6_51B7_5374, _____53D6_4E8B_4EF6_51B7_5374_5B57_6BB5, _____5904_7406_6307_5B9A_4E8B_4EF6_6307_4EE4_97F3_6548, jass, _____5355_4F4D_662F_5426_5339_914D_73A9_5BB6_82F1_96C4_540D_79F0, YDUserDataGetSafe, YDUserDataSetSafe, safeTimerStart, safeDestroyTimer, PlaySoundBJ, GetTriggerPlayer, GetExpiredTimer, GetOwningPlayer, GetRandomInt, IsUnitType, CreateTimer, EventUnitSelected, EventUnitIssuedPointOrder, EventUnitTargetInRange, _____53D6_6CE8_518C_82F1_96C4_7F13_5B58
local ____00_FF0E_914D_7F6E = require("系统.09．表现系统.10．英雄语音.05．指令音效.00．配置")
local _____82F1_96C4_6307_4EE4_97F3_6548_914D_7F6E_5217_8868 = ____00_FF0E_914D_7F6E["英雄指令音效配置列表"]
local _____82F1_96C4_6307_4EE4_97F3_6548_653B_51FB_51B7_5374 = ____00_FF0E_914D_7F6E["英雄指令音效攻击冷却"]
local _____82F1_96C4_6307_4EE4_97F3_6548_79FB_52A8_51B7_5374 = ____00_FF0E_914D_7F6E["英雄指令音效移动冷却"]
local _____82F1_96C4_6307_4EE4_97F3_6548_9009_4E2D_51B7_5374 = ____00_FF0E_914D_7F6E["英雄指令音效选中冷却"]
local _____82F1_96C4_6307_4EE4_97F3_6548_6B63_5728_51B7_5374 = ____00_FF0E_914D_7F6E["英雄指令音效正在冷却"]
local _____82F1_96C4_6307_4EE4_97F3_6548_5355_4F4D_5B57_6BB5 = ____00_FF0E_914D_7F6E["英雄指令音效单位字段"]
local _____82F1_96C4_76EE_6807_70B9_6307_4EE4_97F3_6548_5355_4F4D_5B57_6BB5 = ____00_FF0E_914D_7F6E["英雄目标点指令音效单位字段"]
local _____82F1_96C4_88AB_9009_62E9_97F3_6548_5355_4F4D_5B57_6BB5 = ____00_FF0E_914D_7F6E["英雄被选择音效单位字段"]
local _____82F1_96C4_6B63_5728_8BED_97F3_5355_4F4D_5B57_6BB5 = ____00_FF0E_914D_7F6E["英雄正在语音单位字段"]
local _____82F1_96C4_6307_4EE4_97F3_6548_5B9A_65F6_5668_5B57_6BB5 = ____00_FF0E_914D_7F6E["英雄指令音效定时器字段"]
local _____82F1_96C4_6307_4EE4_97F3_6548_5B9A_65F6_5668_952E_5B57_6BB5 = ____00_FF0E_914D_7F6E["英雄指令音效定时器键字段"]
function _____53D6_6CE8_518C_82F1_96C4(whichPlayer)
    if _____53D6_6CE8_518C_82F1_96C4_7F13_5B58 == nil then
        local bridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
        if type(bridge.getRegisteredPlayerHero) == "function" then
            _____53D6_6CE8_518C_82F1_96C4_7F13_5B58 = bridge.getRegisteredPlayerHero
        end
    end
    if type(_____53D6_6CE8_518C_82F1_96C4_7F13_5B58) ~= "function" then
        return nil
    end
    return _____53D6_6CE8_518C_82F1_96C4_7F13_5B58(whichPlayer)
end
function _____662F_6CE8_518C_73A9_5BB6_82F1_96C4_5355_4F4D(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if IsUnitType(unit, jass.UNIT_TYPE_DEAD) then
        return false
    end
    if IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return false
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    return _____53D6_6CE8_518C_82F1_96C4(owner) == unit
end
function _____53D6_82F1_96C4_6307_4EE4_97F3_6548_914D_7F6E(unit)
    do
        local i = 0
        while i < #_____82F1_96C4_6307_4EE4_97F3_6548_914D_7F6E_5217_8868 do
            local config = _____82F1_96C4_6307_4EE4_97F3_6548_914D_7F6E_5217_8868[i + 1]
            if _____5355_4F4D_662F_5426_5339_914D_73A9_5BB6_82F1_96C4_540D_79F0(unit, config["英雄名"]) then
                return config
            end
            i = i + 1
        end
    end
    return nil
end
function _____53D6_968F_673A_97F3_6548(soundList)
    if #soundList <= 0 then
        return nil
    end
    if #soundList == 1 then
        return soundList[1]
    end
    local index = GetRandomInt(1, #soundList) - 1
    local ____soundList_index_7 = soundList[index + 1]
    if ____soundList_index_7 == nil then
        ____soundList_index_7 = nil
    end
    return ____soundList_index_7
end
function _____53D6_5F53_524D_4E8B_4EF6_97F3_6548(unit, eventId)
    local config = _____53D6_82F1_96C4_6307_4EE4_97F3_6548_914D_7F6E(unit)
    if config == nil then
        return nil
    end
    if eventId == EventUnitTargetInRange then
        return _____53D6_968F_673A_97F3_6548(config["攻击音效列表"])
    end
    if eventId == EventUnitIssuedPointOrder then
        return _____53D6_968F_673A_97F3_6548(config["移动音效列表"])
    end
    if eventId == EventUnitSelected then
        return _____53D6_968F_673A_97F3_6548(config["选中音效列表"])
    end
    return nil
end
function _____672C_5730_64AD_653E(soundHandle)
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    local triggerPlayer = GetTriggerPlayer()
    if triggerPlayer == nil or triggerPlayer == 0 then
        return
    end
    if jass.GetLocalPlayer() ~= triggerPlayer then
        return
    end
    PlaySoundBJ(soundHandle)
end
function _____51B7_5374_7ED3_675F()
    local timer = GetExpiredTimer()
    if timer == nil or timer == 0 then
        return
    end
    local unit = YDUserDataGetSafe("timer", timer, _____82F1_96C4_6307_4EE4_97F3_6548_5B9A_65F6_5668_5B57_6BB5, "unit")
    local key = YDUserDataGetSafe("timer", timer, _____82F1_96C4_6307_4EE4_97F3_6548_5B9A_65F6_5668_952E_5B57_6BB5, "string")
    if unit ~= nil and unit ~= 0 and key ~= "" then
        YDUserDataSetSafe(
            "unit",
            unit,
            tostring(key),
            "boolean",
            false
        )
    end
    safeDestroyTimer(timer)
end
function _____8BB0_5F55_5E76_5F00_59CB_51B7_5374(unit, key, timeout)
    YDUserDataSetSafe(
        "unit",
        unit,
        key,
        "boolean",
        true
    )
    local timer = CreateTimer()
    YDUserDataSetSafe(
        "timer",
        timer,
        _____82F1_96C4_6307_4EE4_97F3_6548_5B9A_65F6_5668_5B57_6BB5,
        "unit",
        unit
    )
    YDUserDataSetSafe(
        "timer",
        timer,
        _____82F1_96C4_6307_4EE4_97F3_6548_5B9A_65F6_5668_952E_5B57_6BB5,
        "string",
        key
    )
    safeTimerStart(timer, timeout, false, _____51B7_5374_7ED3_675F)
end
function _____53D6_4E8B_4EF6_51B7_5374(eventId)
    if eventId == EventUnitTargetInRange then
        return _____82F1_96C4_6307_4EE4_97F3_6548_653B_51FB_51B7_5374
    end
    if eventId == EventUnitIssuedPointOrder then
        return _____82F1_96C4_6307_4EE4_97F3_6548_79FB_52A8_51B7_5374
    end
    return _____82F1_96C4_6307_4EE4_97F3_6548_9009_4E2D_51B7_5374
end
function _____53D6_4E8B_4EF6_51B7_5374_5B57_6BB5(eventId)
    if eventId == EventUnitTargetInRange then
        return _____82F1_96C4_6307_4EE4_97F3_6548_5355_4F4D_5B57_6BB5
    end
    if eventId == EventUnitIssuedPointOrder then
        return _____82F1_96C4_76EE_6807_70B9_6307_4EE4_97F3_6548_5355_4F4D_5B57_6BB5
    end
    if eventId == EventUnitSelected then
        return _____82F1_96C4_88AB_9009_62E9_97F3_6548_5355_4F4D_5B57_6BB5
    end
    return ""
end
function _____5904_7406_6307_5B9A_4E8B_4EF6_6307_4EE4_97F3_6548(unit, eventId)
    if not _____662F_6CE8_518C_73A9_5BB6_82F1_96C4_5355_4F4D(unit) then
        return
    end
    local cooldownKey = _____53D6_4E8B_4EF6_51B7_5374_5B57_6BB5(eventId)
    if cooldownKey == "" then
        return
    end
    if YDUserDataGetSafe("unit", unit, _____82F1_96C4_6B63_5728_8BED_97F3_5355_4F4D_5B57_6BB5, "boolean") == true then
        return
    end
    if YDUserDataGetSafe("unit", unit, cooldownKey, "boolean") == true then
        return
    end
    local soundHandle = _____53D6_5F53_524D_4E8B_4EF6_97F3_6548(unit, eventId)
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    _____672C_5730_64AD_653E(soundHandle)
    _____8BB0_5F55_5E76_5F00_59CB_51B7_5374(
        unit,
        cooldownKey,
        _____53D6_4E8B_4EF6_51B7_5374(eventId)
    )
    _____8BB0_5F55_5E76_5F00_59CB_51B7_5374(unit, _____82F1_96C4_6B63_5728_8BED_97F3_5355_4F4D_5B57_6BB5, _____82F1_96C4_6307_4EE4_97F3_6548_6B63_5728_51B7_5374)
end
jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerUnitEventTrigger = ____require_result_0.registerUnitEventTrigger
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local addSelectionListener = ____require_result_1.addSelectionListener
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心")
local registerPointOrderListener = ____require_result_2.registerPointOrderListener
local ____require_result_3 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名")
_____5355_4F4D_662F_5426_5339_914D_73A9_5BB6_82F1_96C4_540D_79F0 = ____require_result_3["单位是否匹配玩家英雄名称"]
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataGetSafe = ____require_result_4.YDUserDataGetSafe
YDUserDataSetSafe = ____require_result_4.YDUserDataSetSafe
local ____require_result_5 = require("系统.00．核心系统.07．联机安全工具")
safeTimerStart = ____require_result_5.safeTimerStart
safeDestroyTimer = ____require_result_5.safeDestroyTimer
local ____require_result_6 = require("lib.扩展函数.BJ函数.14．音效函数")
PlaySoundBJ = ____require_result_6.PlaySoundBJ
local GetTriggerUnit = jass.GetTriggerUnit
GetTriggerPlayer = jass.GetTriggerPlayer
GetExpiredTimer = jass.GetExpiredTimer
GetOwningPlayer = jass.GetOwningPlayer
GetRandomInt = jass.GetRandomInt
IsUnitType = jass.IsUnitType
CreateTimer = jass.CreateTimer
EventUnitSelected = jass.EVENT_UNIT_SELECTED
EventUnitIssuedPointOrder = jass.EVENT_UNIT_ISSUED_POINT_ORDER
EventUnitTargetInRange = jass.EVENT_UNIT_TARGET_IN_RANGE
local _____82F1_96C4_6307_4EE4_97F3_6548_7CFB_7EDF_5DF2_521D_59CB_5316 = false
_____53D6_6CE8_518C_82F1_96C4_7F13_5B58 = nil
local _____5DF2_6CE8_518C_82F1_96C4_5355_4F4DID = __TS__New(Set)
local function _____83B7_53D6_5355_4F4D_54C8_5E0C(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return jass.GetHandleId(unit) or 0
end
local function _____6307_5B9A_5217_8868_6709_97F3_6548(list)
    return list ~= nil and #list > 0
end
local function _____5904_7406_6307_4EE4_97F3_6548()
    local unit = GetTriggerUnit()
    _____5904_7406_6307_5B9A_4E8B_4EF6_6307_4EE4_97F3_6548(unit, EventUnitTargetInRange)
end
local function _____73A9_5BB6_9009_4E2D_4E8B_4EF6_56DE_8C03(_player, _playerId, unit, isSelected)
    if isSelected ~= true then
        return
    end
    _____5904_7406_6307_5B9A_4E8B_4EF6_6307_4EE4_97F3_6548(unit, EventUnitSelected)
end
local function _____73A9_5BB6_70B9_547D_4EE4_4E8B_4EF6_56DE_8C03(unit, _orderId, _x, _y)
    _____5904_7406_6307_5B9A_4E8B_4EF6_6307_4EE4_97F3_6548(unit, EventUnitIssuedPointOrder)
end
local function _____6CE8_518C_82F1_96C4_6307_4EE4_4E8B_4EF6(whichHero)
    if not _____662F_6CE8_518C_73A9_5BB6_82F1_96C4_5355_4F4D(whichHero) then
        return
    end
    local config = _____53D6_82F1_96C4_6307_4EE4_97F3_6548_914D_7F6E(whichHero)
    if config == nil or not _____6307_5B9A_5217_8868_6709_97F3_6548(config["攻击音效列表"]) then
        return
    end
    local heroId = _____83B7_53D6_5355_4F4D_54C8_5E0C(whichHero)
    if heroId == 0 or _____5DF2_6CE8_518C_82F1_96C4_5355_4F4DID:has(heroId) then
        return
    end
    local trigger = jass.CreateTrigger()
    jass.TriggerAddAction(trigger, _____5904_7406_6307_4EE4_97F3_6548)
    registerUnitEventTrigger(trigger, whichHero, EventUnitTargetInRange)
    _____5DF2_6CE8_518C_82F1_96C4_5355_4F4DID:add(heroId)
end
local function _____626B_63CF_5DF2_6CE8_518C_82F1_96C4()
    do
        local i = 0
        while i <= 15 do
            do
                local player = jass.Player(i)
                if player == nil or player == 0 then
                    goto __continue57
                end
                local hero = _____53D6_6CE8_518C_82F1_96C4(player)
                if hero == nil or hero == 0 then
                    goto __continue57
                end
                _____6CE8_518C_82F1_96C4_6307_4EE4_4E8B_4EF6(hero)
            end
            ::__continue57::
            i = i + 1
        end
    end
end
function ____exports.onPlayerHeroRegistered(_whichPlayer, whichHero)
    _____6CE8_518C_82F1_96C4_6307_4EE4_4E8B_4EF6(whichHero)
end
____exports["init英雄指令音效系统"] = function()
    if _____82F1_96C4_6307_4EE4_97F3_6548_7CFB_7EDF_5DF2_521D_59CB_5316 then
        return
    end
    _____82F1_96C4_6307_4EE4_97F3_6548_7CFB_7EDF_5DF2_521D_59CB_5316 = true
    addSelectionListener(_____73A9_5BB6_9009_4E2D_4E8B_4EF6_56DE_8C03)
    registerPointOrderListener(_____73A9_5BB6_70B9_547D_4EE4_4E8B_4EF6_56DE_8C03)
    _____626B_63CF_5DF2_6CE8_518C_82F1_96C4()
end
return ____exports
