local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local getProgressBarUnitType, angleBetweenPoints, showTextTag, getUnitId, isInteractable, getOpenTime, fireStesEvent, cleanupOpening, startOpening, updateAllOpening, ensureRegisteredToCenterTimer, jass, String2OrderIdBJ, INTERACT_RANGE, UPDATE_INTERVAL, PROGRESS_BAR_SCALE, PROGRESS_BAR_HEIGHT_OFFSET, EVENT_PLAYER_PREPARE_OPEN_CHEST, EVENT_CHEST_OPENED, YDLOCAL_VAR_OPENER, YDLOCAL_VAR_CHEST, YDLOCAL_VAR_PRE_OPENER, YDLOCAL_VAR_PRE_CHEST, TEXT_OPENING, TEXT_SUCCESS, TEXT_INTERRUPTED, isInteractableType, getInteractableOpenTime, STES_GetTable, YDLocalExecuteTrigger, saveParentIndex, YDTriggerExecuteTrigger, YDLocal5Set, YDUserDataGet, CreateFloatTextOnUnit, openingMap, movingMap, _progressBarUnitType, _registeredToCenterTimer, _tickCounter, CENTER_TIMER_TICKS
function getProgressBarUnitType()
    if _progressBarUnitType ~= 0 then
        return _progressBarUnitType
    end
    local code = YDUserDataGet(
        nil,
        "string",
        "施法进度条",
        "单位类型",
        "unitcode"
    )
    if type(code) == "number" and code ~= 0 then
        _progressBarUnitType = code
    end
    return _progressBarUnitType
end
function angleBetweenPoints(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1) * 180 / math.pi
end
function showTextTag(unit, text, red, green, blue)
    CreateFloatTextOnUnit(nil, unit, text, {
        size = 10,
        red = red,
        green = green,
        blue = blue,
        alpha = 0,
        duration = 1,
        speedY = 0.03
    })
end
function getUnitId(unit)
    if not unit or type(jass.GetHandleId) ~= "function" then
        return 0
    end
    return jass.GetHandleId(unit)
end
function isInteractable(destructableType)
    return isInteractableType(destructableType)
end
function getOpenTime(destructableType)
    return getInteractableOpenTime(destructableType)
end
function fireStesEvent(eventName, opener, target)
    local ht = STES_GetTable(nil, nil)
    if not ht then
        return
    end
    local hash = jass.StringHash(eventName)
    local skeyIndex = jass.StringHash("index")
    local count = jass.LoadInteger(ht, hash, skeyIndex)
    do
        local i = 0
        while i < count do
            local trg = jass.LoadTriggerHandle(ht, hash, i)
            if trg then
                YDLocalExecuteTrigger(nil, trg)
                saveParentIndex(nil, trg)
                if eventName == EVENT_CHEST_OPENED then
                    YDLocal5Set(nil, "unit", YDLOCAL_VAR_OPENER, opener)
                    YDLocal5Set(nil, "destructable", YDLOCAL_VAR_CHEST, target)
                elseif eventName == EVENT_PLAYER_PREPARE_OPEN_CHEST then
                    YDLocal5Set(nil, "unit", YDLOCAL_VAR_PRE_OPENER, opener)
                    YDLocal5Set(nil, "destructable", YDLOCAL_VAR_PRE_CHEST, target)
                end
                YDTriggerExecuteTrigger(nil, trg, false)
            end
            i = i + 1
        end
    end
end
function cleanupOpening(data, interrupted)
    if type(jass.DzUnitDisableAttack) == "function" then
        jass.DzUnitDisableAttack(data.unit, false)
    end
    if data.progressBar and type(jass.RemoveUnit) == "function" then
        jass.RemoveUnit(data.progressBar)
    end
    if interrupted then
        showTextTag(
            data.unit,
            TEXT_INTERRUPTED,
            85,
            10,
            10
        )
    end
    local unitId = getUnitId(data.unit)
    if unitId ~= 0 then
        openingMap:delete(unitId)
    end
end
function startOpening(unit, target, openTime)
    local ____opt_7 = jass.IssueImmediateOrder
    if ____opt_7 ~= nil then
        ____opt_7(jass, unit, "stop")
    end
    if openTime <= 0 then
        openTime = 1
    end
    local speed = 1 / openTime
    local ____opt_9 = jass.GetUnitX
    if ____opt_9 ~= nil then
        ____opt_9 = ____opt_9(jass, unit)
    end
    local ____opt_9_11 = ____opt_9
    if ____opt_9_11 == nil then
        ____opt_9_11 = 0
    end
    local unitX = ____opt_9_11
    local ____opt_12 = jass.GetUnitY
    if ____opt_12 ~= nil then
        ____opt_12 = ____opt_12(jass, unit)
    end
    local ____opt_12_14 = ____opt_12
    if ____opt_12_14 == nil then
        ____opt_12_14 = 0
    end
    local unitY = ____opt_12_14
    local progressType = getProgressBarUnitType()
    local ____opt_15 = jass.CreateUnit
    if ____opt_15 ~= nil then
        local ____opt_16 = jass.Player
        if ____opt_16 ~= nil then
            ____opt_16 = ____opt_16(jass, 4)
        end
        ____opt_15 = ____opt_15(
            jass,
            ____opt_16,
            progressType,
            unitX,
            unitY,
            0
        )
    end
    local progressBar = ____opt_15
    if progressBar then
        local ____opt_19 = jass.SetUnitTimeScale
        if ____opt_19 ~= nil then
            ____opt_19(jass, progressBar, speed)
        end
        local ____opt_21 = jass.SetUnitScale
        if ____opt_21 ~= nil then
            ____opt_21(
                jass,
                progressBar,
                PROGRESS_BAR_SCALE,
                PROGRESS_BAR_SCALE,
                PROGRESS_BAR_SCALE
            )
        end
        local ____opt_23 = jass.GetUnitFlyHeight
        if ____opt_23 ~= nil then
            ____opt_23 = ____opt_23(jass, unit)
        end
        local ____opt_23_25 = ____opt_23
        if ____opt_23_25 == nil then
            ____opt_23_25 = 0
        end
        local flyHeight = ____opt_23_25 + PROGRESS_BAR_HEIGHT_OFFSET
        local ____opt_26 = jass.SetUnitFlyHeight
        if ____opt_26 ~= nil then
            ____opt_26(jass, progressBar, flyHeight, 0)
        end
    end
    if type(jass.DzUnitDisableAttack) == "function" then
        jass.DzUnitDisableAttack(unit, true)
    end
    local ____opt_28 = jass.GetDestructableX
    if ____opt_28 ~= nil then
        ____opt_28 = ____opt_28(jass, target)
    end
    local ____opt_28_30 = ____opt_28
    if ____opt_28_30 == nil then
        ____opt_28_30 = 0
    end
    local targetX = ____opt_28_30
    local ____opt_31 = jass.GetDestructableY
    if ____opt_31 ~= nil then
        ____opt_31 = ____opt_31(jass, target)
    end
    local ____opt_31_33 = ____opt_31
    if ____opt_31_33 == nil then
        ____opt_31_33 = 0
    end
    local targetY = ____opt_31_33
    local angle = angleBetweenPoints(unitX, unitY, targetX, targetY)
    local ____opt_34 = jass.SetUnitFacing
    if ____opt_34 ~= nil then
        ____opt_34(jass, unit, angle)
    end
    fireStesEvent(EVENT_PLAYER_PREPARE_OPEN_CHEST, unit, target)
    showTextTag(
        unit,
        TEXT_OPENING,
        100,
        100,
        0
    )
    local data = {
        unit = unit,
        target = target,
        progressBar = progressBar,
        openTime = openTime,
        elapsed = 0
    }
    local unitId = getUnitId(unit)
    if unitId ~= 0 then
        openingMap:set(unitId, data)
    end
    ensureRegisteredToCenterTimer()
end
function updateAllOpening()
    for ____, ____value in __TS__Iterator(openingMap) do
        local unitId = ____value[1]
        local data = ____value[2]
        do
            local ____opt_36 = jass.GetUnitCurrentOrder
            if ____opt_36 ~= nil then
                ____opt_36 = ____opt_36(jass, data.unit)
            end
            local currentOrder = ____opt_36
            local smartOrder = String2OrderIdBJ(nil, "smart")
            local attackOrder = String2OrderIdBJ(nil, "attack")
            local completed = data.elapsed >= data.openTime
            local interrupted = currentOrder == smartOrder or currentOrder == attackOrder
            if completed or interrupted then
                if completed then
                    showTextTag(
                        data.unit,
                        TEXT_SUCCESS,
                        100,
                        100,
                        0
                    )
                    fireStesEvent(EVENT_CHEST_OPENED, data.unit, data.target)
                end
                cleanupOpening(data, not completed and interrupted)
                goto __continue29
            end
            data.elapsed = data.elapsed + UPDATE_INTERVAL
            if data.progressBar then
                local ____opt_38 = jass.GetUnitX
                if ____opt_38 ~= nil then
                    ____opt_38 = ____opt_38(jass, data.unit)
                end
                local ____opt_38_40 = ____opt_38
                if ____opt_38_40 == nil then
                    ____opt_38_40 = 0
                end
                local unitX = ____opt_38_40
                local ____opt_41 = jass.GetUnitY
                if ____opt_41 ~= nil then
                    ____opt_41 = ____opt_41(jass, data.unit)
                end
                local ____opt_41_43 = ____opt_41
                if ____opt_41_43 == nil then
                    ____opt_41_43 = 0
                end
                local unitY = ____opt_41_43
                local ____opt_44 = jass.SetUnitX
                if ____opt_44 ~= nil then
                    ____opt_44(jass, data.progressBar, unitX)
                end
                local ____opt_46 = jass.SetUnitY
                if ____opt_46 ~= nil then
                    ____opt_46(jass, data.progressBar, unitY)
                end
            end
        end
        ::__continue29::
    end
    for ____, ____value in __TS__Iterator(movingMap) do
        local unitId = ____value[1]
        local data = ____value[2]
        local ____opt_48 = jass.GetUnitCurrentOrder
        if ____opt_48 ~= nil then
            ____opt_48 = ____opt_48(jass, data.unit)
        end
        local currentOrder = ____opt_48
        local moveOrder = String2OrderIdBJ(nil, "move")
        local ____opt_50 = jass.IsUnitInRangeXY
        if ____opt_50 ~= nil then
            ____opt_50 = ____opt_50(
                jass,
                data.unit,
                data.targetX,
                data.targetY,
                INTERACT_RANGE
            )
        end
        local inRange = ____opt_50
        local orderChanged = currentOrder ~= moveOrder
        if inRange or orderChanged then
            if inRange then
                local ____opt_52 = jass.GetDestructableTypeId
                if ____opt_52 ~= nil then
                    ____opt_52 = ____opt_52(jass, data.target)
                end
                local targetType = ____opt_52
                if targetType and isInteractable(targetType) then
                    local openTime = getOpenTime(targetType)
                    startOpening(data.unit, data.target, openTime)
                end
            end
            movingMap:delete(unitId)
        end
    end
end
function ensureRegisteredToCenterTimer()
    if _registeredToCenterTimer then
        return
    end
    _registeredToCenterTimer = true
    local ____require_result_54 = require("系统.00．核心系统.05．中心计时器")
    local onTick10ms = ____require_result_54.onTick10ms
    onTick10ms(
        nil,
        function()
            if openingMap.size == 0 and movingMap.size == 0 then
                return
            end
            _tickCounter = _tickCounter + 1
            if _tickCounter >= CENTER_TIMER_TICKS then
                _tickCounter = 0
                updateAllOpening()
            end
        end
    )
end
jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.07．杂项")
String2OrderIdBJ = ____require_result_0.String2OrderIdBJ
local ____require_result_1 = require("系统.06．经济系统.00．宝箱系统.00．常量定义")
local INTERACTABLE_TYPES = ____require_result_1.INTERACTABLE_TYPES
local DEFAULT_OPEN_TIME = ____require_result_1.DEFAULT_OPEN_TIME
INTERACT_RANGE = ____require_result_1.INTERACT_RANGE
UPDATE_INTERVAL = ____require_result_1.UPDATE_INTERVAL
PROGRESS_BAR_SCALE = ____require_result_1.PROGRESS_BAR_SCALE
PROGRESS_BAR_HEIGHT_OFFSET = ____require_result_1.PROGRESS_BAR_HEIGHT_OFFSET
EVENT_PLAYER_PREPARE_OPEN_CHEST = ____require_result_1.EVENT_PLAYER_PREPARE_OPEN_CHEST
EVENT_CHEST_OPENED = ____require_result_1.EVENT_CHEST_OPENED
YDLOCAL_VAR_OPENER = ____require_result_1.YDLOCAL_VAR_OPENER
YDLOCAL_VAR_CHEST = ____require_result_1.YDLOCAL_VAR_CHEST
YDLOCAL_VAR_PRE_OPENER = ____require_result_1.YDLOCAL_VAR_PRE_OPENER
YDLOCAL_VAR_PRE_CHEST = ____require_result_1.YDLOCAL_VAR_PRE_CHEST
TEXT_OPENING = ____require_result_1.TEXT_OPENING
TEXT_SUCCESS = ____require_result_1.TEXT_SUCCESS
TEXT_INTERRUPTED = ____require_result_1.TEXT_INTERRUPTED
isInteractableType = ____require_result_1.isInteractableType
getInteractableOpenTime = ____require_result_1.getInteractableOpenTime
local getInteractableName = ____require_result_1.getInteractableName
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
STES_GetTable = ____require_result_2.STES_GetTable
local ____require_result_3 = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
YDLocalExecuteTrigger = ____require_result_3.YDLocalExecuteTrigger
saveParentIndex = ____require_result_3.saveParentIndex
YDTriggerExecuteTrigger = ____require_result_3.YDTriggerExecuteTrigger
local ____require_result_4 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
YDLocal5Set = ____require_result_4.YDLocal5Set
local ____require_result_5 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
YDUserDataGet = ____require_result_5.YDUserDataGet
local ____require_result_6 = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字")
CreateFloatTextOnUnit = ____require_result_6.CreateFloatTextOnUnit
openingMap = __TS__New(Map)
movingMap = __TS__New(Map)
_progressBarUnitType = 0
_registeredToCenterTimer = false
_tickCounter = 0
CENTER_TIMER_TICKS = math.ceil(UPDATE_INTERVAL / 0.01)
--- 处理单位对可交互目标的命令
-- 
-- @param unit 触发单位
-- @param target 目标可破坏物
function ____exports.onUnitTargetInteractable(unit, target)
    if not unit or not target then
        return
    end
    local ____opt_55 = jass.GetDestructableTypeId
    if ____opt_55 ~= nil then
        ____opt_55 = ____opt_55(jass, target)
    end
    local targetType = ____opt_55
    if not isInteractable(targetType) then
        return
    end
    local openTime = getOpenTime(targetType)
    local ____opt_57 = jass.GetDestructableX
    if ____opt_57 ~= nil then
        ____opt_57 = ____opt_57(jass, target)
    end
    local ____opt_57_59 = ____opt_57
    if ____opt_57_59 == nil then
        ____opt_57_59 = 0
    end
    local targetX = ____opt_57_59
    local ____opt_60 = jass.GetDestructableY
    if ____opt_60 ~= nil then
        ____opt_60 = ____opt_60(jass, target)
    end
    local ____opt_60_62 = ____opt_60
    if ____opt_60_62 == nil then
        ____opt_60_62 = 0
    end
    local targetY = ____opt_60_62
    local ____opt_63 = jass.IsUnitInRangeXY
    if ____opt_63 ~= nil then
        ____opt_63 = ____opt_63(
            jass,
            unit,
            targetX,
            targetY,
            INTERACT_RANGE
        )
    end
    local inRange = ____opt_63
    if not inRange then
        local ____opt_65 = jass.IssuePointOrder
        if ____opt_65 ~= nil then
            ____opt_65(
                jass,
                unit,
                "move",
                targetX,
                targetY
            )
        end
        local data = {unit = unit, target = target, targetX = targetX, targetY = targetY}
        local unitId = getUnitId(unit)
        if unitId ~= 0 then
            movingMap:set(unitId, data)
        end
        ensureRegisteredToCenterTimer()
    else
        startOpening(unit, target, openTime)
    end
end
--- 检查单位是否正在开启
function ____exports.isUnitOpening(unit)
    if not unit then
        return false
    end
    local unitId = getUnitId(unit)
    local ____temp_67
    if unitId ~= 0 then
        ____temp_67 = openingMap:has(unitId)
    else
        ____temp_67 = false
    end
    return ____temp_67
end
--- 中断单位开启
function ____exports.interruptOpening(unit)
    if not unit then
        return
    end
    local unitId = getUnitId(unit)
    local ____temp_68
    if unitId ~= 0 then
        ____temp_68 = openingMap:get(unitId)
    else
        ____temp_68 = nil
    end
    local data = ____temp_68
    if data ~= nil then
        cleanupOpening(data, true)
    end
end
____exports.onUnitTargetChest = ____exports.onUnitTargetInteractable
____exports.isUnitOpeningChest = ____exports.isUnitOpening
____exports.interruptChestOpening = ____exports.interruptOpening
____exports.STES_EVENT_PREPARE = EVENT_PLAYER_PREPARE_OPEN_CHEST
____exports.STES_EVENT_OPENED = EVENT_CHEST_OPENED
____exports.YDLOCAL_VAR_OPENER = YDLOCAL_VAR_OPENER
____exports.YDLOCAL_VAR_CHEST = YDLOCAL_VAR_CHEST
____exports.YDLOCAL_VAR_PRE_OPENER = YDLOCAL_VAR_PRE_OPENER
____exports.YDLOCAL_VAR_PRE_CHEST = YDLOCAL_VAR_PRE_CHEST
____exports.isInteractable = isInteractable
____exports.getOpenTime = getOpenTime
return ____exports
