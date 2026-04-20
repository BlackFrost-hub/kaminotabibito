local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local getProgressBarUnitType, angleBetweenPoints, showTextTag, getUnitId, isInteractable, getOpenTime, fireStesEvent, cleanupOpening, startOpening, updateAllOpening, ensureRegisteredToCenterTimer, jass, String2OrderIdBJ, DEFAULT_OPEN_TIME, INTERACT_RANGE, UPDATE_INTERVAL, PROGRESS_BAR_SCALE, PROGRESS_BAR_HEIGHT_OFFSET, EVENT_PLAYER_PREPARE_OPEN_CHEST, EVENT_CHEST_OPENED, YDLOCAL_VAR_OPENER, YDLOCAL_VAR_CHEST, YDLOCAL_VAR_PRE_OPENER, YDLOCAL_VAR_PRE_CHEST, TEXT_OPENING, TEXT_SUCCESS, TEXT_INTERRUPTED, isChestType, getChestConfig, dropItemsFromChest, STES_GetTable, YDLocalExecuteTrigger, saveParentIndex, YDTriggerExecuteTrigger, YDLocal5Set, YDUserDataGet, CreateFloatTextOnUnit, openingMap, movingMap, _progressBarUnitType, _registeredToCenterTimer, _tickCounter, CENTER_TIMER_TICKS
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
    if not unit then
        return 0
    end
    return jass.GetHandleId(unit)
end
function isInteractable(destructableType)
    return isChestType(destructableType)
end
function getOpenTime(destructableType)
    local config = getChestConfig(destructableType)
    return config and config.openTime or DEFAULT_OPEN_TIME
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
                if eventName == EVENT_CHEST_OPENED then
                    YDLocal5Set(nil, "unit", YDLOCAL_VAR_OPENER, opener)
                    YDLocal5Set(nil, "destructable", YDLOCAL_VAR_CHEST, target)
                elseif eventName == EVENT_PLAYER_PREPARE_OPEN_CHEST then
                    YDLocal5Set(nil, "unit", YDLOCAL_VAR_PRE_OPENER, opener)
                    YDLocal5Set(nil, "destructable", YDLOCAL_VAR_PRE_CHEST, target)
                end
                YDLocalExecuteTrigger(nil, trg)
                saveParentIndex(nil, trg)
                YDTriggerExecuteTrigger(nil, trg, false)
            end
            i = i + 1
        end
    end
end
function cleanupOpening(data, interrupted)
    jass.DzUnitDisableAttack(data.unit, false)
    if data.progressBar then
        jass.RemoveUnit(data.progressBar)
    end
    if interrupted then
        local ____getChestConfig_13 = getChestConfig
        local ____opt_10 = jass.GetDestructableTypeId
        if ____opt_10 ~= nil then
            ____opt_10 = ____opt_10(jass, data.target)
        end
        local ____opt_10_12 = ____opt_10
        if ____opt_10_12 == nil then
            ____opt_10_12 = 0
        end
        local cfg = ____getChestConfig_13(____opt_10_12)
        showTextTag(
            data.unit,
            TEXT_INTERRUPTED(cfg and cfg.name or "宝箱"),
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
    local ____opt_16 = jass.IssueImmediateOrder
    if ____opt_16 ~= nil then
        ____opt_16(jass, unit, "stop")
    end
    if openTime <= 0 then
        openTime = 1
    end
    local speed = 1 / openTime
    local ____opt_18 = jass.GetUnitX
    if ____opt_18 ~= nil then
        ____opt_18 = ____opt_18(jass, unit)
    end
    local ____opt_18_20 = ____opt_18
    if ____opt_18_20 == nil then
        ____opt_18_20 = 0
    end
    local unitX = ____opt_18_20
    local ____opt_21 = jass.GetUnitY
    if ____opt_21 ~= nil then
        ____opt_21 = ____opt_21(jass, unit)
    end
    local ____opt_21_23 = ____opt_21
    if ____opt_21_23 == nil then
        ____opt_21_23 = 0
    end
    local unitY = ____opt_21_23
    local progressType = getProgressBarUnitType()
    local ____opt_24 = jass.CreateUnit
    if ____opt_24 ~= nil then
        local ____opt_25 = jass.Player
        if ____opt_25 ~= nil then
            ____opt_25 = ____opt_25(jass, 4)
        end
        ____opt_24 = ____opt_24(
            jass,
            ____opt_25,
            progressType,
            unitX,
            unitY,
            0
        )
    end
    local progressBar = ____opt_24
    if progressBar then
        local ____opt_28 = jass.SetUnitTimeScale
        if ____opt_28 ~= nil then
            ____opt_28(jass, progressBar, speed)
        end
        local ____opt_30 = jass.SetUnitScale
        if ____opt_30 ~= nil then
            ____opt_30(
                jass,
                progressBar,
                PROGRESS_BAR_SCALE,
                PROGRESS_BAR_SCALE,
                PROGRESS_BAR_SCALE
            )
        end
        local ____opt_32 = jass.GetUnitFlyHeight
        if ____opt_32 ~= nil then
            ____opt_32 = ____opt_32(jass, unit)
        end
        local ____opt_32_34 = ____opt_32
        if ____opt_32_34 == nil then
            ____opt_32_34 = 0
        end
        local flyHeight = ____opt_32_34 + PROGRESS_BAR_HEIGHT_OFFSET
        local ____opt_35 = jass.SetUnitFlyHeight
        if ____opt_35 ~= nil then
            ____opt_35(jass, progressBar, flyHeight, 0)
        end
    end
    jass.DzUnitDisableAttack(unit, true)
    local ____opt_37 = jass.GetDestructableX
    if ____opt_37 ~= nil then
        ____opt_37 = ____opt_37(jass, target)
    end
    local ____opt_37_39 = ____opt_37
    if ____opt_37_39 == nil then
        ____opt_37_39 = 0
    end
    local targetX = ____opt_37_39
    local ____opt_40 = jass.GetDestructableY
    if ____opt_40 ~= nil then
        ____opt_40 = ____opt_40(jass, target)
    end
    local ____opt_40_42 = ____opt_40
    if ____opt_40_42 == nil then
        ____opt_40_42 = 0
    end
    local targetY = ____opt_40_42
    local angle = angleBetweenPoints(unitX, unitY, targetX, targetY)
    local ____opt_43 = jass.SetUnitFacing
    if ____opt_43 ~= nil then
        ____opt_43(jass, unit, angle)
    end
    local ____getChestConfig_48 = getChestConfig
    local ____opt_45 = jass.GetDestructableTypeId
    if ____opt_45 ~= nil then
        ____opt_45 = ____opt_45(jass, target)
    end
    local ____opt_45_47 = ____opt_45
    if ____opt_45_47 == nil then
        ____opt_45_47 = 0
    end
    local config = ____getChestConfig_48(____opt_45_47)
    local chestName = config and config.name or "宝箱"
    fireStesEvent(EVENT_PLAYER_PREPARE_OPEN_CHEST, unit, target)
    showTextTag(
        unit,
        TEXT_OPENING(chestName),
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
            local ____opt_51 = jass.GetUnitCurrentOrder
            if ____opt_51 ~= nil then
                ____opt_51 = ____opt_51(jass, data.unit)
            end
            local currentOrder = ____opt_51
            local smartOrder = String2OrderIdBJ(nil, "smart")
            local attackOrder = String2OrderIdBJ(nil, "attack")
            local completed = data.elapsed >= data.openTime
            local interrupted = currentOrder == smartOrder or currentOrder == attackOrder
            if completed or interrupted then
                if completed then
                    local ____getChestConfig_56 = getChestConfig
                    local ____opt_53 = jass.GetDestructableTypeId
                    if ____opt_53 ~= nil then
                        ____opt_53 = ____opt_53(jass, data.target)
                    end
                    local ____opt_53_55 = ____opt_53
                    if ____opt_53_55 == nil then
                        ____opt_53_55 = 0
                    end
                    local cfg = ____getChestConfig_56(____opt_53_55)
                    local chestName = cfg and cfg.name or "宝箱"
                    showTextTag(
                        data.unit,
                        TEXT_SUCCESS(chestName),
                        100,
                        100,
                        0
                    )
                    local targetTypeStr = cfg and cfg.destructableType
                    if targetTypeStr then
                        local ____opt_61 = jass.GetDestructableX
                        if ____opt_61 ~= nil then
                            ____opt_61 = ____opt_61(jass, data.target)
                        end
                        local ____opt_61_63 = ____opt_61
                        if ____opt_61_63 == nil then
                            ____opt_61_63 = 0
                        end
                        local x = ____opt_61_63
                        local ____opt_64 = jass.GetDestructableY
                        if ____opt_64 ~= nil then
                            ____opt_64 = ____opt_64(jass, data.target)
                        end
                        local ____opt_64_66 = ____opt_64
                        if ____opt_64_66 == nil then
                            ____opt_64_66 = 0
                        end
                        local y = ____opt_64_66
                        dropItemsFromChest(nil, targetTypeStr, x, y)
                    end
                    fireStesEvent(EVENT_CHEST_OPENED, data.unit, data.target)
                    if data.target then
                        jass.KillDestructable(data.target)
                    end
                end
                cleanupOpening(data, not completed and interrupted)
                goto __continue27
            end
            data.elapsed = data.elapsed + UPDATE_INTERVAL
            if data.progressBar then
                local ____opt_67 = jass.GetUnitX
                if ____opt_67 ~= nil then
                    ____opt_67 = ____opt_67(jass, data.unit)
                end
                local ____opt_67_69 = ____opt_67
                if ____opt_67_69 == nil then
                    ____opt_67_69 = 0
                end
                local unitX = ____opt_67_69
                local ____opt_70 = jass.GetUnitY
                if ____opt_70 ~= nil then
                    ____opt_70 = ____opt_70(jass, data.unit)
                end
                local ____opt_70_72 = ____opt_70
                if ____opt_70_72 == nil then
                    ____opt_70_72 = 0
                end
                local unitY = ____opt_70_72
                local ____opt_73 = jass.SetUnitX
                if ____opt_73 ~= nil then
                    ____opt_73(jass, data.progressBar, unitX)
                end
                local ____opt_75 = jass.SetUnitY
                if ____opt_75 ~= nil then
                    ____opt_75(jass, data.progressBar, unitY)
                end
            end
        end
        ::__continue27::
    end
    for ____, ____value in __TS__Iterator(movingMap) do
        local unitId = ____value[1]
        local data = ____value[2]
        local ____opt_77 = jass.GetUnitCurrentOrder
        if ____opt_77 ~= nil then
            ____opt_77 = ____opt_77(jass, data.unit)
        end
        local currentOrder = ____opt_77
        local moveOrder = String2OrderIdBJ(nil, "move")
        local ____opt_79 = jass.IsUnitInRangeXY
        if ____opt_79 ~= nil then
            ____opt_79 = ____opt_79(
                jass,
                data.unit,
                data.targetX,
                data.targetY,
                INTERACT_RANGE
            )
        end
        local inRange = ____opt_79
        local orderChanged = currentOrder ~= moveOrder
        if inRange or orderChanged then
            if inRange then
                local ____opt_81 = jass.GetDestructableTypeId
                if ____opt_81 ~= nil then
                    ____opt_81 = ____opt_81(jass, data.target)
                end
                local targetType = ____opt_81
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
    local ____require_result_83 = require("系统.00．核心系统.05．中心计时器")
    local onTick10ms = ____require_result_83.onTick10ms
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
local CHEST_TYPES = ____require_result_1.CHEST_TYPES
DEFAULT_OPEN_TIME = ____require_result_1.DEFAULT_OPEN_TIME
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
isChestType = ____require_result_1.isChestType
getChestConfig = ____require_result_1.getChestConfig
local ____require_result_2 = require("系统.06．经济系统.00．宝箱系统.01．宝箱掉落配置")
dropItemsFromChest = ____require_result_2.dropItemsFromChest
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
STES_GetTable = ____require_result_3.STES_GetTable
local ____require_result_4 = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
YDLocalExecuteTrigger = ____require_result_4.YDLocalExecuteTrigger
saveParentIndex = ____require_result_4.saveParentIndex
YDTriggerExecuteTrigger = ____require_result_4.YDTriggerExecuteTrigger
local ____require_result_5 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
YDLocal5Set = ____require_result_5.YDLocal5Set
local ____require_result_6 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
YDUserDataGet = ____require_result_6.YDUserDataGet
local ____require_result_7 = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字")
CreateFloatTextOnUnit = ____require_result_7.CreateFloatTextOnUnit
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
    local ____opt_84 = jass.GetDestructableTypeId
    if ____opt_84 ~= nil then
        ____opt_84 = ____opt_84(jass, target)
    end
    local targetType = ____opt_84
    if not isInteractable(targetType) then
        return
    end
    local openTime = getOpenTime(targetType)
    local ____opt_86 = jass.GetDestructableX
    if ____opt_86 ~= nil then
        ____opt_86 = ____opt_86(jass, target)
    end
    local ____opt_86_88 = ____opt_86
    if ____opt_86_88 == nil then
        ____opt_86_88 = 0
    end
    local targetX = ____opt_86_88
    local ____opt_89 = jass.GetDestructableY
    if ____opt_89 ~= nil then
        ____opt_89 = ____opt_89(jass, target)
    end
    local ____opt_89_91 = ____opt_89
    if ____opt_89_91 == nil then
        ____opt_89_91 = 0
    end
    local targetY = ____opt_89_91
    local ____opt_92 = jass.IsUnitInRangeXY
    if ____opt_92 ~= nil then
        ____opt_92 = ____opt_92(
            jass,
            unit,
            targetX,
            targetY,
            INTERACT_RANGE
        )
    end
    local inRange = ____opt_92
    if not inRange then
        local ____opt_94 = jass.IssuePointOrder
        if ____opt_94 ~= nil then
            ____opt_94(
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
    local ____temp_96
    if unitId ~= 0 then
        ____temp_96 = openingMap:has(unitId)
    else
        ____temp_96 = false
    end
    return ____temp_96
end
--- 中断单位开启
function ____exports.interruptOpening(unit)
    if not unit then
        return
    end
    local unitId = getUnitId(unit)
    local ____temp_97
    if unitId ~= 0 then
        ____temp_97 = openingMap:get(unitId)
    else
        ____temp_97 = nil
    end
    local data = ____temp_97
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
