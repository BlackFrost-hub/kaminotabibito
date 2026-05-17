local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local angleBetweenPoints, showTextTag, getUnitId, isInteractable, getOpenTime, cleanupOpening, startOpening, updateAllOpening, onChestCenterTimerTick, ensureRegisteredToCenterTimer, jass, DzUnitDisableAttack, GetRandomInt, forEachSorted, BJ_RADTODEG, DEFAULT_OPEN_TIME, INTERACT_RANGE, UPDATE_INTERVAL, PROGRESS_BAR_HEIGHT_OFFSET, isChestType, getChestConfig, _____89E6_53D1_5B9D_7BB1_51C6_5907_5F00_542F_56DE_8C03, _____89E6_53D1_5B9D_7BB1_5F00_542F_4E2D_56DE_8C03, _____89E6_53D1_5B9D_7BB1_5F00_542F_5B8C_6210_56DE_8C03, _____521B_5EFA_8FDB_5EA6_6761_7279_6548, _____9500_6BC1_8FDB_5EA6_6761_7279_6548, dropItemsFromChestConfig, _____67E5_627E_5B9D_7BB1_4E3B_4EBA, debugLogForce, CreateFloatTextOnUnit, _____8C03_8BD5_6A21_5757, ORDER_MOVE, ORDER_SMART, ORDER_ATTACK, ORDER_STOP, ORDER_HOLD_POSITION, openingMap, movingMap, _registeredToCenterTimer, _tickCounter, CENTER_TIMER_TICKS
function angleBetweenPoints(x1, y1, x2, y2)
    return jass.Atan2(y2 - y1, x2 - x1) * BJ_RADTODEG
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
    return jass.GetHandleId(unit)
end
function isInteractable(destructableType)
    return isChestType(destructableType)
end
function getOpenTime(destructableType)
    local config = getChestConfig(destructableType)
    return config and config.openTime or DEFAULT_OPEN_TIME
end
function cleanupOpening(data, interrupted)
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "结束开启",
        "unit=",
        getUnitId(data.unit),
        "target=",
        jass.GetHandleId(data.target),
        "interrupted=",
        interrupted,
        "elapsed=",
        data.elapsed,
        "openTime=",
        data.openTime
    )
    DzUnitDisableAttack(data.unit, false)
    if data.progressBar then
        _____9500_6BC1_8FDB_5EA6_6761_7279_6548(data.progressBar)
    end
    if interrupted then
        local cfg = getChestConfig(jass.GetDestructableTypeId(data.target))
        showTextTag(
            data.unit,
            "宝箱打开失败...",
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
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "开始开启",
        "unit=",
        getUnitId(unit),
        "target=",
        jass.GetHandleId(target),
        "type=",
        jass.GetDestructableTypeId(target),
        "openTime=",
        openTime
    )
    jass.IssueImmediateOrder(unit, "stop")
    if openTime <= 0 then
        openTime = 1
    end
    local speed = 1 / openTime
    local unitX = jass.GetUnitX(unit)
    local unitY = jass.GetUnitY(unit)
    local progressBar = _____521B_5EFA_8FDB_5EA6_6761_7279_6548(unit, {["高度偏移"] = PROGRESS_BAR_HEIGHT_OFFSET, ["动画序号"] = 0, ["动画速度"] = speed})
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "进度条创建后",
        "unit=",
        getUnitId(unit),
        "progressBar=",
        jass.GetHandleId(progressBar)
    )
    DzUnitDisableAttack(unit, true)
    debugLogForce(_____8C03_8BD5_6A21_5757, "开启瞬间禁攻已恢复")
    local targetX = jass.GetDestructableX(target)
    local targetY = jass.GetDestructableY(target)
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "读取目标坐标",
        "targetX=",
        targetX,
        "targetY=",
        targetY
    )
    local angle = angleBetweenPoints(unitX, unitY, targetX, targetY)
    debugLogForce(_____8C03_8BD5_6A21_5757, "准备设置朝向", "angle=", angle)
    jass.SetUnitFacing(unit, angle)
    debugLogForce(_____8C03_8BD5_6A21_5757, "设置朝向完成")
    local config = getChestConfig(jass.GetDestructableTypeId(target))
    debugLogForce(_____8C03_8BD5_6A21_5757, "读取配置完成", "hasConfig=", config ~= nil)
    local highRoll = config and config["高级掉落"] and GetRandomInt(1, 100) or nil
    if config ~= nil and highRoll ~= nil then
        debugLogForce(
            _____8C03_8BD5_6A21_5757,
            "预掷高级掉落",
            "type=",
            config.destructableType,
            "roll=",
            highRoll
        )
    end
    local ____config_17
    if config then
        ____config_17 = _____67E5_627E_5B9D_7BB1_4E3B_4EBA(config, target, "准备开启")
    else
        ____config_17 = nil
    end
    local ownerUnit = ____config_17
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "准备开启主人",
        "owner=",
        ownerUnit and getUnitId(ownerUnit) or 0
    )
    local chestName = config and config.name or "宝箱"
    debugLogForce(_____8C03_8BD5_6A21_5757, "准备漂浮文字", "chestName=", chestName)
    showTextTag(
        unit,
        "开启宝箱中...",
        100,
        100,
        0
    )
    debugLogForce(_____8C03_8BD5_6A21_5757, "漂浮文字完成")
    local data = {
        unit = unit,
        target = target,
        progressBar = progressBar,
        openTime = openTime,
        elapsed = 0,
        chestConfig = config,
        ownerUnit = ownerUnit,
        highRoll = highRoll
    }
    local unitId = getUnitId(unit)
    if unitId ~= 0 then
        openingMap:set(unitId, data)
        debugLogForce(
            _____8C03_8BD5_6A21_5757,
            "写入 openingMap",
            "unit=",
            unitId,
            "openingSize=",
            openingMap.size,
            "movingSize=",
            movingMap.size
        )
    end
    _____89E6_53D1_5B9D_7BB1_51C6_5907_5F00_542F_56DE_8C03(
        unit,
        target,
        progressBar,
        openTime,
        config,
        ownerUnit
    )
    ensureRegisteredToCenterTimer()
end
function updateAllOpening()
    forEachSorted(
        openingMap,
        function(unitId, data)
            local currentOrder = jass.GetUnitCurrentOrder(data.unit)
            local completed = data.elapsed >= data.openTime
            local interrupted = currentOrder == ORDER_SMART or currentOrder == ORDER_ATTACK or currentOrder == ORDER_STOP or currentOrder == ORDER_HOLD_POSITION
            if not completed and not interrupted then
                _____89E6_53D1_5B9D_7BB1_5F00_542F_4E2D_56DE_8C03(
                    data.unit,
                    data.target,
                    data.progressBar,
                    data.openTime,
                    data.elapsed,
                    data.chestConfig,
                    data.ownerUnit
                )
            end
            if completed or interrupted then
                if completed then
                    local ____data_chestConfig_20 = data.chestConfig
                    if ____data_chestConfig_20 == nil then
                        ____data_chestConfig_20 = getChestConfig(jass.GetDestructableTypeId(data.target))
                    end
                    local cfg = ____data_chestConfig_20
                    local ____cfg_21
                    if cfg then
                        ____cfg_21 = _____67E5_627E_5B9D_7BB1_4E3B_4EBA(cfg, data.target, "开启完成")
                    else
                        ____cfg_21 = nil
                    end
                    local ownerUnit = ____cfg_21
                    local ____opt_result_24
                    if cfg ~= nil then
                        ____opt_result_24 = cfg.name
                    end
                    local ____opt_result_24_25 = ____opt_result_24
                    if ____opt_result_24_25 == nil then
                        ____opt_result_24_25 = "宝箱"
                    end
                    local chestName = ____opt_result_24_25
                    showTextTag(
                        data.unit,
                        "宝箱被打开了...",
                        100,
                        100,
                        0
                    )
                    local ____debugLogForce_32 = debugLogForce
                    local ____unitId_30 = unitId
                    local ____temp_31 = jass.GetHandleId(data.target)
                    local ____opt_result_28
                    if cfg ~= nil then
                        ____opt_result_28 = cfg.destructableType
                    end
                    local ____opt_result_28_29 = ____opt_result_28
                    if ____opt_result_28_29 == nil then
                        ____opt_result_28_29 = "unknown"
                    end
                    ____debugLogForce_32(
                        _____8C03_8BD5_6A21_5757,
                        "开启完成",
                        "unit=",
                        ____unitId_30,
                        "target=",
                        ____temp_31,
                        "destructableType=",
                        ____opt_result_28_29
                    )
                    debugLogForce(
                        _____8C03_8BD5_6A21_5757,
                        "开启完成主人",
                        "owner=",
                        ownerUnit and getUnitId(ownerUnit) or 0
                    )
                    cleanupOpening(data, false)
                    debugLogForce(_____8C03_8BD5_6A21_5757, "完成回调前")
                    _____89E6_53D1_5B9D_7BB1_5F00_542F_5B8C_6210_56DE_8C03(
                        data.unit,
                        data.target,
                        data.progressBar,
                        data.openTime,
                        cfg,
                        ownerUnit
                    )
                    debugLogForce(_____8C03_8BD5_6A21_5757, "完成回调后")
                    if cfg then
                        local dropX = jass.GetDestructableX(data.target)
                        local dropY = jass.GetDestructableY(data.target)
                        debugLogForce(
                            _____8C03_8BD5_6A21_5757,
                            "掉落前",
                            "type=",
                            cfg.destructableType,
                            "x=",
                            dropX,
                            "y=",
                            dropY,
                            "preRoll=",
                            data.highRoll or "nil"
                        )
                        dropItemsFromChestConfig(
                            cfg,
                            dropX,
                            dropY,
                            data.unit,
                            ownerUnit,
                            data.highRoll
                        )
                        debugLogForce(_____8C03_8BD5_6A21_5757, "掉落后")
                    end
                    if data.target then
                        debugLogForce(_____8C03_8BD5_6A21_5757, "KillDestructable前")
                        jass.KillDestructable(data.target)
                        debugLogForce(_____8C03_8BD5_6A21_5757, "KillDestructable后")
                    end
                end
                if not completed then
                    cleanupOpening(data, true)
                end
                return
            end
            data.elapsed = data.elapsed + UPDATE_INTERVAL
        end
    )
    forEachSorted(
        movingMap,
        function(unitId, data)
            local currentOrder = jass.GetUnitCurrentOrder(data.unit)
            local inRange = jass.IsUnitInRangeXY(data.unit, data.targetX, data.targetY, INTERACT_RANGE)
            local orderChanged = currentOrder ~= ORDER_MOVE and currentOrder ~= ORDER_SMART
            if inRange then
                local targetType = jass.GetDestructableTypeId(data.target)
                if targetType and isInteractable(targetType) then
                    local openTime = getOpenTime(targetType)
                    debugLogForce(
                        _____8C03_8BD5_6A21_5757,
                        "移动到范围内，转入开启",
                        "unit=",
                        unitId,
                        "target=",
                        jass.GetHandleId(data.target),
                        "targetType=",
                        targetType,
                        "openTime=",
                        openTime
                    )
                    startOpening(data.unit, data.target, openTime)
                end
                movingMap:delete(unitId)
                debugLogForce(
                    _____8C03_8BD5_6A21_5757,
                    "移除 movingMap",
                    "unit=",
                    unitId,
                    "openingSize=",
                    openingMap.size,
                    "movingSize=",
                    movingMap.size
                )
            elseif orderChanged then
                movingMap:delete(unitId)
                debugLogForce(
                    _____8C03_8BD5_6A21_5757,
                    "移动状态结束但未进范围",
                    "unit=",
                    unitId,
                    "target=",
                    jass.GetHandleId(data.target),
                    "currentOrder=",
                    currentOrder,
                    "moveOrder=",
                    ORDER_MOVE,
                    "smartOrder=",
                    ORDER_SMART,
                    "openingSize=",
                    openingMap.size,
                    "movingSize=",
                    movingMap.size
                )
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
    local ____G_33 = _G
    local onTick10ms = ____G_33.onTick10ms
    onTick10ms(onChestCenterTimerTick)
end
--- 中断单位开启
function ____exports.interruptOpening(unit)
    if not unit then
        return
    end
    local unitId = getUnitId(unit)
    local ____temp_35
    if unitId ~= 0 then
        ____temp_35 = openingMap:get(unitId)
    else
        ____temp_35 = nil
    end
    local data = ____temp_35
    if data ~= nil then
        cleanupOpening(data, true)
    end
end
--- 宝箱系统 - 核心功能
-- 
-- 功能：
-- 1. 玩家右键点击可交互目标，自动移动到范围内开始开启
-- 2. 显示进度条和提示文字
-- 3. 开启成功触发STES事件
-- 4. 移动/攻击/施法会中断开启
-- 
-- 支持任意可交互目标类型（通过INTERACTABLE_TYPES配置）
local japi = require("jass.japi")
jass = require("jass.common")
local jglobals = require("jass.globals")
DzUnitDisableAttack = japi.DzUnitDisableAttack
GetRandomInt = jass.GetRandomInt
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local ceil = ____require_result_0.ceil
forEachSorted = ____require_result_0.forEachSorted
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_1.stringToFourCC
local ____jglobals_bj_RADTODEG_2 = jglobals.bj_RADTODEG
if ____jglobals_bj_RADTODEG_2 == nil then
    ____jglobals_bj_RADTODEG_2 = 57.29577951308232
end
BJ_RADTODEG = ____jglobals_bj_RADTODEG_2
local ____require_result_3 = require("系统.06．经济系统.00．宝箱系统.00．常量定义")
local CHEST_TYPES = ____require_result_3.CHEST_TYPES
DEFAULT_OPEN_TIME = ____require_result_3.DEFAULT_OPEN_TIME
INTERACT_RANGE = ____require_result_3.INTERACT_RANGE
UPDATE_INTERVAL = ____require_result_3.UPDATE_INTERVAL
PROGRESS_BAR_HEIGHT_OFFSET = ____require_result_3.PROGRESS_BAR_HEIGHT_OFFSET
local YDLOCAL_VAR_OPENER = ____require_result_3.YDLOCAL_VAR_OPENER
local YDLOCAL_VAR_CHEST = ____require_result_3.YDLOCAL_VAR_CHEST
local YDLOCAL_VAR_PRE_OPENER = ____require_result_3.YDLOCAL_VAR_PRE_OPENER
local YDLOCAL_VAR_PRE_CHEST = ____require_result_3.YDLOCAL_VAR_PRE_CHEST
isChestType = ____require_result_3.isChestType
getChestConfig = ____require_result_3.getChestConfig
local ____require_result_4 = require("系统.06．经济系统.00．宝箱系统.04．准备开启回调")
_____89E6_53D1_5B9D_7BB1_51C6_5907_5F00_542F_56DE_8C03 = ____require_result_4["触发宝箱准备开启回调"]
local ____require_result_5 = require("系统.06．经济系统.00．宝箱系统.05．开启中回调")
_____89E6_53D1_5B9D_7BB1_5F00_542F_4E2D_56DE_8C03 = ____require_result_5["触发宝箱开启中回调"]
local ____require_result_6 = require("系统.06．经济系统.00．宝箱系统.06．开启完成回调")
_____89E6_53D1_5B9D_7BB1_5F00_542F_5B8C_6210_56DE_8C03 = ____require_result_6["触发宝箱开启完成回调"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.进度条特效")
_____521B_5EFA_8FDB_5EA6_6761_7279_6548 = ____require_result_7["创建进度条特效"]
_____9500_6BC1_8FDB_5EA6_6761_7279_6548 = ____require_result_7["销毁进度条特效"]
local ____require_result_8 = require("系统.06．经济系统.00．宝箱系统.07．主人广播")
local _____5E7F_64AD_5355_4F4D_7C7B_578B_63D0_793A = ____require_result_8["广播单位类型提示"]
local ____require_result_9 = require("系统.06．经济系统.00．宝箱系统.01．宝箱掉落配置")
local dropItemsFromChest = ____require_result_9.dropItemsFromChest
local ____require_result_10 = require("系统.06．经济系统.00．宝箱系统.01．宝箱掉落配置")
dropItemsFromChestConfig = ____require_result_10.dropItemsFromChestConfig
local ____require_result_11 = require("系统.06．经济系统.00．宝箱系统.08．宝箱主人")
_____67E5_627E_5B9D_7BB1_4E3B_4EBA = ____require_result_11["查找宝箱主人"]
local ____require_result_12 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_12.debugLogForce
local _____6F02_6D6E_6587_5B57_6A21_5757 = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字")
CreateFloatTextOnUnit = _____6F02_6D6E_6587_5B57_6A21_5757.CreateFloatTextOnUnit
_____8C03_8BD5_6A21_5757 = "宝箱系统-核心"
ORDER_MOVE = 851971
ORDER_SMART = 851986
ORDER_ATTACK = 851983
ORDER_STOP = 851972
ORDER_HOLD_POSITION = 851993
openingMap = __TS__New(Map)
movingMap = __TS__New(Map)
local function isSamePoint(ax, ay, bx, by)
    return ax <= bx + 1 and ax >= bx - 1 and ay <= by + 1 and ay >= by - 1
end
function ____exports.onUnitTargetChestPointOrder(unit, x, y)
    if not unit then
        return
    end
    local unitId = getUnitId(unit)
    if unitId == 0 then
        return
    end
    local movingData = movingMap:get(unitId)
    if movingData ~= nil then
        if isSamePoint(x, y, movingData.targetX, movingData.targetY) then
            return
        end
        debugLogForce(
            _____8C03_8BD5_6A21_5757,
            "外部点地改写移动",
            "unit=",
            unitId,
            "target=",
            jass.GetHandleId(movingData.target),
            "pointX=",
            x,
            "pointY=",
            y,
            "moveX=",
            movingData.targetX,
            "moveY=",
            movingData.targetY
        )
        movingMap:delete(unitId)
        return
    end
    local openingData = openingMap:get(unitId)
    if openingData ~= nil then
        debugLogForce(
            _____8C03_8BD5_6A21_5757,
            "外部点地打断开启",
            "unit=",
            unitId,
            "target=",
            jass.GetHandleId(openingData.target),
            "pointX=",
            x,
            "pointY=",
            y
        )
        ____exports.interruptOpening(unit)
    end
end
function ____exports.onUnitTargetChestImmediateOrder(unit, orderId)
    if not unit then
        return
    end
    if orderId ~= ORDER_STOP and orderId ~= ORDER_HOLD_POSITION then
        return
    end
    local unitId = getUnitId(unit)
    if unitId == 0 then
        return
    end
    local movingData = movingMap:get(unitId)
    if movingData ~= nil then
        debugLogForce(
            _____8C03_8BD5_6A21_5757,
            "外部即时命令打断移动",
            "unit=",
            unitId,
            "target=",
            jass.GetHandleId(movingData.target),
            "orderId=",
            orderId
        )
        movingMap:delete(unitId)
    end
    local openingData = openingMap:get(unitId)
    if openingData ~= nil then
        debugLogForce(
            _____8C03_8BD5_6A21_5757,
            "外部即时命令打断开启",
            "unit=",
            unitId,
            "target=",
            jass.GetHandleId(openingData.target),
            "orderId=",
            orderId
        )
        ____exports.interruptOpening(unit)
    end
end
local function fireStesEvent(_eventName, _opener, _target)
end
_registeredToCenterTimer = false
_tickCounter = 0
CENTER_TIMER_TICKS = ceil(UPDATE_INTERVAL / 0.01)
--- 处理单位对可交互目标的命令
-- 
-- @param unit 触发单位
-- @param target 目标可破坏物
function ____exports.onUnitTargetInteractable(unit, target)
    if not unit or not target then
        debugLogForce(_____8C03_8BD5_6A21_5757, "进入交互失败: unit 或 target 为空")
        return
    end
    local targetType = jass.GetDestructableTypeId(target)
    if not isInteractable(targetType) then
        debugLogForce(
            _____8C03_8BD5_6A21_5757,
            "进入交互失败: 目标不是宝箱/木桶",
            "unit=",
            getUnitId(unit),
            "target=",
            jass.GetHandleId(target),
            "targetType=",
            targetType
        )
        return
    end
    local openTime = getOpenTime(targetType)
    local targetX = jass.GetDestructableX(target)
    local targetY = jass.GetDestructableY(target)
    local inRange = jass.IsUnitInRangeXY(unit, targetX, targetY, INTERACT_RANGE)
    debugLogForce(
        _____8C03_8BD5_6A21_5757,
        "进入交互",
        "unit=",
        getUnitId(unit),
        "target=",
        jass.GetHandleId(target),
        "targetType=",
        targetType,
        "inRange=",
        inRange,
        "openTime=",
        openTime,
        "targetX=",
        targetX,
        "targetY=",
        targetY,
        "currentOrder=",
        jass.GetUnitCurrentOrder(unit)
    )
    if not inRange then
        jass.IssuePointOrder(unit, "move", targetX, targetY)
        local data = {unit = unit, target = target, targetX = targetX, targetY = targetY}
        local unitId = getUnitId(unit)
        if unitId ~= 0 then
            movingMap:set(unitId, data)
            debugLogForce(
                _____8C03_8BD5_6A21_5757,
                "写入 movingMap",
                "unit=",
                unitId,
                "target=",
                jass.GetHandleId(target),
                "openingSize=",
                openingMap.size,
                "movingSize=",
                movingMap.size
            )
        end
        ensureRegisteredToCenterTimer()
    else
        debugLogForce(
            _____8C03_8BD5_6A21_5757,
            "已在范围内，直接开启",
            "unit=",
            getUnitId(unit),
            "target=",
            jass.GetHandleId(target)
        )
        startOpening(unit, target, openTime)
    end
end
--- 检查单位是否正在开启
function ____exports.isUnitOpening(unit)
    if not unit then
        return false
    end
    local unitId = getUnitId(unit)
    local ____temp_34
    if unitId ~= 0 then
        ____temp_34 = openingMap:has(unitId)
    else
        ____temp_34 = false
    end
    return ____temp_34
end
____exports.onUnitTargetChest = ____exports.onUnitTargetInteractable
____exports.isUnitOpeningChest = ____exports.isUnitOpening
____exports.interruptChestOpening = ____exports.interruptOpening
____exports.YDLOCAL_VAR_OPENER = YDLOCAL_VAR_OPENER
____exports.YDLOCAL_VAR_CHEST = YDLOCAL_VAR_CHEST
____exports.YDLOCAL_VAR_PRE_OPENER = YDLOCAL_VAR_PRE_OPENER
____exports.YDLOCAL_VAR_PRE_CHEST = YDLOCAL_VAR_PRE_CHEST
____exports.isInteractable = isInteractable
____exports.getOpenTime = getOpenTime
return ____exports
