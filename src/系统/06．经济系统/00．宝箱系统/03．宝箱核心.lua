local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local getProgressBarUnitType, angleBetweenPoints, showTextTag, getUnitId, isInteractable, getOpenTime, fireStesEvent, cleanupOpening, startOpening, updateAllOpening, onChestCenterTimerTick, ensureRegisteredToCenterTimer, japi, jass, forEachSorted, BJ_RADTODEG, String2OrderIdBJ, DEFAULT_OPEN_TIME, INTERACT_RANGE, UPDATE_INTERVAL, PROGRESS_BAR_SCALE, PROGRESS_BAR_HEIGHT_OFFSET, EVENT_PLAYER_PREPARE_OPEN_CHEST, EVENT_CHEST_OPENED, YDLOCAL_VAR_OPENER, YDLOCAL_VAR_CHEST, YDLOCAL_VAR_PRE_OPENER, YDLOCAL_VAR_PRE_CHEST, TEXT_OPENING, TEXT_SUCCESS, TEXT_INTERRUPTED, isChestType, getChestConfig, dropItemsFromChest, STES_GetTable, YDLocalExecuteTrigger, saveParentIndex, YDTriggerExecuteTrigger, YDLocal5Set, YDUserDataGet, CreateFloatTextOnUnit, openingMap, movingMap, _progressBarUnitType, _registeredToCenterTimer, _tickCounter, CENTER_TIMER_TICKS
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
    return jass:Atan2(y2 - y1, x2 - x1) * BJ_RADTODEG
end
function showTextTag(unit, text, red, green, blue)
    if type(CreateFloatTextOnUnit) == "function" then
        CreateFloatTextOnUnit(unit, text, {
            size = 10,
            red = red,
            green = green,
            blue = blue,
            alpha = 0,
            duration = 1,
            speedY = 0.03
        })
    end
end
function getUnitId(unit)
    if not unit then
        return 0
    end
    return jass:GetHandleId(unit)
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
    local hash = jass:StringHash(eventName)
    local skeyIndex = jass:StringHash("index")
    local count = jass:LoadInteger(ht, hash, skeyIndex)
    do
        local i = 0
        while i < count do
            local trg = jass:LoadTriggerHandle(ht, hash, i)
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
    japi:DzUnitDisableAttack(data.unit, false)
    if data.progressBar then
        jass:RemoveUnit(data.progressBar)
    end
    if interrupted then
        local cfg = getChestConfig(jass:GetDestructableTypeId(data.target))
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
    jass:IssueImmediateOrder(unit, "stop")
    if openTime <= 0 then
        openTime = 1
    end
    local speed = 1 / openTime
    local unitX = jass:GetUnitX(unit)
    local unitY = jass:GetUnitY(unit)
    local progressType = getProgressBarUnitType()
    local progressBar = jass:CreateUnit(
        jass:Player(4),
        progressType,
        unitX,
        unitY,
        0
    )
    if progressBar then
        jass:SetUnitTimeScale(progressBar, speed)
        jass:SetUnitScale(progressBar, PROGRESS_BAR_SCALE, PROGRESS_BAR_SCALE, PROGRESS_BAR_SCALE)
        local flyHeight = jass:GetUnitFlyHeight(unit) + PROGRESS_BAR_HEIGHT_OFFSET
        jass:SetUnitFlyHeight(progressBar, flyHeight, 0)
    end
    japi:DzUnitDisableAttack(unit, true)
    local targetX = jass:GetDestructableX(target)
    local targetY = jass:GetDestructableY(target)
    local angle = angleBetweenPoints(unitX, unitY, targetX, targetY)
    jass:SetUnitFacing(unit, angle)
    local config = getChestConfig(jass:GetDestructableTypeId(target))
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
    forEachSorted(
        openingMap,
        function(unitId, data)
            local currentOrder = jass:GetUnitCurrentOrder(data.unit)
            local smartOrder = String2OrderIdBJ(nil, "smart")
            local attackOrder = String2OrderIdBJ(nil, "attack")
            local completed = data.elapsed >= data.openTime
            local interrupted = currentOrder == smartOrder or currentOrder == attackOrder
            if completed or interrupted then
                if completed then
                    local cfg = getChestConfig(jass:GetDestructableTypeId(data.target))
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
                        local x = jass:GetDestructableX(data.target)
                        local y = jass:GetDestructableY(data.target)
                        dropItemsFromChest(nil, targetTypeStr, x, y)
                    end
                    fireStesEvent(EVENT_CHEST_OPENED, data.unit, data.target)
                    if data.target then
                        jass:KillDestructable(data.target)
                    end
                end
                cleanupOpening(data, not completed and interrupted)
                return
            end
            data.elapsed = data.elapsed + UPDATE_INTERVAL
            if data.progressBar then
                local unitX = jass:GetUnitX(data.unit)
                local unitY = jass:GetUnitY(data.unit)
                jass:SetUnitX(data.progressBar, unitX)
                jass:SetUnitY(data.progressBar, unitY)
            end
        end
    )
    forEachSorted(
        movingMap,
        function(unitId, data)
            local currentOrder = jass:GetUnitCurrentOrder(data.unit)
            local moveOrder = String2OrderIdBJ(nil, "move")
            local inRange = jass:IsUnitInRangeXY(data.unit, data.targetX, data.targetY, INTERACT_RANGE)
            local orderChanged = currentOrder ~= moveOrder
            if inRange or orderChanged then
                if inRange then
                    local targetType = jass:GetDestructableTypeId(data.target)
                    if targetType and isInteractable(targetType) then
                        local openTime = getOpenTime(targetType)
                        startOpening(data.unit, data.target, openTime)
                    end
                end
                movingMap:delete(unitId)
            end
        end
    )
end
function onChestCenterTimerTick()
    if openingMap.size == 0 and movingMap.size == 0 then
        return
    end
    _tickCounter = _tickCounter + 1
    if _tickCounter >= CENTER_TIMER_TICKS then
        _tickCounter = 0
        updateAllOpening()
    end
end
function ensureRegisteredToCenterTimer()
    if _registeredToCenterTimer then
        return
    end
    _registeredToCenterTimer = true
    local ____G_19 = _G
    local onTick10ms = ____G_19.onTick10ms
    onTick10ms(onChestCenterTimerTick)
end
japi = require("jass.japi")
jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local ceil = ____require_result_0.ceil
forEachSorted = ____require_result_0.forEachSorted
local ____jglobals_bj_RADTODEG_1 = jglobals.bj_RADTODEG
if ____jglobals_bj_RADTODEG_1 == nil then
    ____jglobals_bj_RADTODEG_1 = 57.29577951308232
end
BJ_RADTODEG = ____jglobals_bj_RADTODEG_1
local ____require_result_2 = require("lib.扩展函数.BJ函数.07．杂项")
String2OrderIdBJ = ____require_result_2.String2OrderIdBJ
local ____require_result_3 = require("系统.06．经济系统.00．宝箱系统.00．常量定义")
local CHEST_TYPES = ____require_result_3.CHEST_TYPES
DEFAULT_OPEN_TIME = ____require_result_3.DEFAULT_OPEN_TIME
INTERACT_RANGE = ____require_result_3.INTERACT_RANGE
UPDATE_INTERVAL = ____require_result_3.UPDATE_INTERVAL
PROGRESS_BAR_SCALE = ____require_result_3.PROGRESS_BAR_SCALE
PROGRESS_BAR_HEIGHT_OFFSET = ____require_result_3.PROGRESS_BAR_HEIGHT_OFFSET
EVENT_PLAYER_PREPARE_OPEN_CHEST = ____require_result_3.EVENT_PLAYER_PREPARE_OPEN_CHEST
EVENT_CHEST_OPENED = ____require_result_3.EVENT_CHEST_OPENED
YDLOCAL_VAR_OPENER = ____require_result_3.YDLOCAL_VAR_OPENER
YDLOCAL_VAR_CHEST = ____require_result_3.YDLOCAL_VAR_CHEST
YDLOCAL_VAR_PRE_OPENER = ____require_result_3.YDLOCAL_VAR_PRE_OPENER
YDLOCAL_VAR_PRE_CHEST = ____require_result_3.YDLOCAL_VAR_PRE_CHEST
TEXT_OPENING = ____require_result_3.TEXT_OPENING
TEXT_SUCCESS = ____require_result_3.TEXT_SUCCESS
TEXT_INTERRUPTED = ____require_result_3.TEXT_INTERRUPTED
isChestType = ____require_result_3.isChestType
getChestConfig = ____require_result_3.getChestConfig
local ____require_result_4 = require("系统.06．经济系统.00．宝箱系统.01．宝箱掉落配置")
dropItemsFromChest = ____require_result_4.dropItemsFromChest
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
STES_GetTable = ____require_result_5.STES_GetTable
local ____require_result_6 = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
YDLocalExecuteTrigger = ____require_result_6.YDLocalExecuteTrigger
saveParentIndex = ____require_result_6.saveParentIndex
YDTriggerExecuteTrigger = ____require_result_6.YDTriggerExecuteTrigger
local ____require_result_7 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
YDLocal5Set = ____require_result_7.YDLocal5Set
local ____require_result_8 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
YDUserDataGet = ____require_result_8.YDUserDataGet
local _____6F02_6D6E_6587_5B57_6A21_5757 = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字")
CreateFloatTextOnUnit = _____6F02_6D6E_6587_5B57_6A21_5757.CreateFloatTextOnUnit
openingMap = __TS__New(Map)
movingMap = __TS__New(Map)
_progressBarUnitType = 0
_registeredToCenterTimer = false
_tickCounter = 0
CENTER_TIMER_TICKS = ceil(UPDATE_INTERVAL / 0.01)
--- 处理单位对可交互目标的命令
-- 
-- @param unit 触发单位
-- @param target 目标可破坏物
function ____exports.onUnitTargetInteractable(unit, target)
    if not unit or not target then
        return
    end
    local targetType = jass:GetDestructableTypeId(target)
    if not isInteractable(targetType) then
        return
    end
    local openTime = getOpenTime(targetType)
    local targetX = jass:GetDestructableX(target)
    local targetY = jass:GetDestructableY(target)
    local inRange = jass:IsUnitInRangeXY(unit, targetX, targetY, INTERACT_RANGE)
    if not inRange then
        jass:IssuePointOrder(unit, "move", targetX, targetY)
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
    local ____temp_20
    if unitId ~= 0 then
        ____temp_20 = openingMap:has(unitId)
    else
        ____temp_20 = false
    end
    return ____temp_20
end
--- 中断单位开启
function ____exports.interruptOpening(unit)
    if not unit then
        return
    end
    local unitId = getUnitId(unit)
    local ____temp_21
    if unitId ~= 0 then
        ____temp_21 = openingMap:get(unitId)
    else
        ____temp_21 = nil
    end
    local data = ____temp_21
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
