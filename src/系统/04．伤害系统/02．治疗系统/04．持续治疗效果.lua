local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local unregisterCenterTimerIfNeeded, YDUserDataClearSafe, offSecond, ATTR_COUNTDOWN, ATTR_TICK_HP, ATTR_TICK_MP, ATTR_SOURCE, ATTR_BUFF_ID, hotUnits, registeredToCenterTimer, hotTickCallback
function unregisterCenterTimerIfNeeded()
    if not registeredToCenterTimer then
        return
    end
    if hotUnits.size > 0 then
        return
    end
    if hotTickCallback then
        offSecond(hotTickCallback)
        hotTickCallback = nil
    end
    registeredToCenterTimer = false
end
--- 停止持续治疗效果
function ____exports.stopHot(target)
    if target == nil then
        return
    end
    hotUnits:delete(target)
    YDUserDataClearSafe("unit", target, ATTR_COUNTDOWN, "real")
    YDUserDataClearSafe("unit", target, ATTR_TICK_HP, "real")
    YDUserDataClearSafe("unit", target, ATTR_TICK_MP, "real")
    YDUserDataClearSafe("unit", target, ATTR_SOURCE, "unit")
    YDUserDataClearSafe("unit", target, ATTR_BUFF_ID, "string")
    unregisterCenterTimerIfNeeded()
end
--- 持续治疗效果（HOT）系统
-- 
-- 功能：通过中心计时器实现每秒恢复生命和魔法
-- 
-- 优化：使用中心计时器的 onSecond 回调，避免为每个单位创建独立计时器
-- 
-- 后续接手者注意：
-- 1. 直接调用 doHeal 执行治疗，不需要通过STES事件
-- 2. Buff ID列表可根据需要扩展
local jass = require("jass.common")
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local getBuffRuntime = ____require_result_0.getBuffRuntime
local ____require_result_1 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local UnitHasBuffBJ = ____require_result_1.UnitHasBuffBJ
local IsUnitDeadBJ = ____require_result_1.IsUnitDeadBJ
local ____require_result_2 = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
local IsUnitPausedBJ = ____require_result_2.IsUnitPausedBJ
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_3.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
YDUserDataClearSafe = ____require_result_3.YDUserDataClearSafe
local ____G_4 = _G
local onSecond = ____G_4.onSecond
offSecond = ____G_4.offSecond
local ____require_result_5 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_5.doHeal
--- 持续恢复相关Buff ID（没有这些Buff时效果结束）
local HOT_BUFF_IDS = {1112109677, 1112109671, 1112109676, 1114793322}
local HOT_BUFF_POOL_IDS = {"C027"}
ATTR_COUNTDOWN = "持续恢复倒计时"
ATTR_TICK_HP = "hotTickHP"
ATTR_TICK_MP = "hotTickMP"
ATTR_SOURCE = "hotSource"
ATTR_BUFF_ID = "hotBuffID"
--- 系统开关
local HOT_SYSTEM_ENABLED = true
--- 检查单位是否有任意一个持续恢复Buff
local function hasAnyHotBuff(unit)
    local _____6307_5B9ABuffID = YDUserDataGetSafe("unit", unit, ATTR_BUFF_ID, "string")
    if _____6307_5B9ABuffID ~= nil and _____6307_5B9ABuffID ~= "" then
        return getBuffRuntime(unit, _____6307_5B9ABuffID) ~= nil
    end
    for ____, buffID in ipairs(HOT_BUFF_POOL_IDS) do
        if getBuffRuntime(unit, buffID) ~= nil then
            return true
        end
    end
    for ____, buffId in ipairs(HOT_BUFF_IDS) do
        if UnitHasBuffBJ(unit, buffId) then
            return true
        end
    end
    return false
end
hotUnits = __TS__New(Set)
registeredToCenterTimer = false
hotTickCallback = nil
--- 中心计时器每秒回调
-- 遍历所有HOT单位，执行恢复逻辑
local function onHotTick()
    local toRemove = {}
    for ____, target in __TS__Iterator(hotUnits) do
        do
            if IsUnitPausedBJ(target) then
                goto __continue11
            end
            local countdown = YDUserDataGetSafe("unit", target, ATTR_COUNTDOWN, "real") - 1
            YDUserDataSetSafe(
                "unit",
                target,
                ATTR_COUNTDOWN,
                "real",
                countdown
            )
            local tickHP = YDUserDataGetSafe("unit", target, ATTR_TICK_HP, "real")
            local tickMP = YDUserDataGetSafe("unit", target, ATTR_TICK_MP, "real")
            local source = YDUserDataGetSafe("unit", target, ATTR_SOURCE, "unit")
            if tickHP > 0 or tickMP > 0 then
                local ____doHeal_8 = doHeal
                local ____temp_6
                if tickHP > 0 then
                    ____temp_6 = tickHP
                else
                    ____temp_6 = 0
                end
                local ____temp_7
                if tickMP > 0 then
                    ____temp_7 = tickMP
                else
                    ____temp_7 = 0
                end
                ____doHeal_8({
                    HealSource = source,
                    HealTarget = target,
                    HealAmount = ____temp_6,
                    HealManaAmount = ____temp_7,
                    ItemHeal = true,
                    HealEffect = false,
                    HealShowText = false,
                    ManaEffect = false,
                    ManaShowText = false
                })
            end
            local buffAlive = hasAnyHotBuff(target)
            local dead = IsUnitDeadBJ(target)
            local shouldEnd = not buffAlive or countdown <= 0 or dead
            if shouldEnd then
                toRemove[#toRemove + 1] = target
            end
        end
        ::__continue11::
    end
    for ____, target in ipairs(toRemove) do
        ____exports.stopHot(target)
    end
end
--- 注册中心计时器回调（延迟注册，只在有HOT单位时才运行）
local function ensureCenterTimerRegistered()
    if registeredToCenterTimer then
        return
    end
    hotTickCallback = onHotTick
    onSecond(hotTickCallback)
    registeredToCenterTimer = true
end
--- 启动持续治疗效果
-- 
-- @param target 目标单位
-- @param source 来源单位
-- @param tickHP 每秒恢复生命量
-- @param tickMP 每秒恢复魔法量
-- @param duration 持续时间（秒）
function ____exports.startHot(target, source, tickHP, tickMP, duration, _intervalOrOptions, extraOptions)
    if not HOT_SYSTEM_ENABLED then
        return
    end
    if target == nil then
        return
    end
    if duration <= 0 then
        return
    end
    YDUserDataSetSafe(
        "unit",
        target,
        ATTR_COUNTDOWN,
        "real",
        duration
    )
    YDUserDataSetSafe(
        "unit",
        target,
        ATTR_TICK_HP,
        "real",
        tickHP
    )
    YDUserDataSetSafe(
        "unit",
        target,
        ATTR_TICK_MP,
        "real",
        tickMP
    )
    YDUserDataSetSafe(
        "unit",
        target,
        ATTR_SOURCE,
        "unit",
        source
    )
    local ____temp_10
    if extraOptions ~= nil then
        ____temp_10 = extraOptions
    else
        local ____temp_9
        if type(_intervalOrOptions) == "number" then
            ____temp_9 = nil
        else
            ____temp_9 = _intervalOrOptions
        end
        ____temp_10 = ____temp_9
    end
    local options = ____temp_10
    if options ~= nil and options.BuffID ~= nil and options.BuffID ~= "" then
        YDUserDataSetSafe(
            "unit",
            target,
            ATTR_BUFF_ID,
            "string",
            options.BuffID
        )
    else
        YDUserDataClearSafe("unit", target, ATTR_BUFF_ID, "string")
    end
    local isNew = not hotUnits:has(target)
    hotUnits:add(target)
    if isNew then
        ensureCenterTimerRegistered()
    end
end
--- 检查单位是否正在受HOT效果影响
function ____exports.isHotActive(target)
    return hotUnits:has(target)
end
--- 获取当前HOT单位数量
function ____exports.getHotUnitCount()
    return hotUnits.size
end
local ____require_result_11 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_FireWithParams = ____require_result_11.STES_FireWithParams
--- STES事件名称
____exports.HOT_EVENT_NAME = "持续治疗效果"
--- 触发"持续治疗效果"事件
-- 供Lua端/JASS端调用，启动持续恢复效果
-- 
-- @param target 目标单位
-- @param source 来源单位
-- @param tickHP 每秒恢复生命量
-- @param tickMP 每秒恢复魔法量
-- @param duration 持续时间（秒，可选，默认从YDUserData读取或使用tickHP）
function ____exports.fireHotEvent(target, source, tickHP, tickMP, duration)
    if duration ~= nil then
        YDUserDataSetSafe(
            "unit",
            target,
            ATTR_COUNTDOWN,
            "real",
            duration
        )
    end
    STES_FireWithParams(____exports.HOT_EVENT_NAME, {{type = "unit", name = "HealTarget", value = target}, {type = "unit", name = "HealSource", value = source}, {type = "real", name = "hotTickHP", value = tickHP}, {type = "real", name = "hotTickMP", value = tickMP}})
end
--- 触发器实例
local hotTrigger = nil
--- STES事件处理函数
-- 接收参数：HealTarget, HealSource, hotTickHP, hotTickMP
local function onHotEvent()
    local ____require_result_12 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
    local YDLocal1Get = ____require_result_12.YDLocal1Get
    local target = YDLocal1Get(nil, "unit", "HealTarget")
    local source = YDLocal1Get(nil, "unit", "HealSource")
    local tickHP = YDLocal1Get(nil, "real", "hotTickHP")
    local tickMP = YDLocal1Get(nil, "real", "hotTickMP")
    local duration = YDUserDataGetSafe("unit", target, ATTR_COUNTDOWN, "real")
    if duration <= 0 then
        local ____temp_13
        if tickHP > 0 then
            ____temp_13 = tickHP
        else
            ____temp_13 = 10
        end
        duration = ____temp_13
    end
    ____exports.startHot(
        target,
        source,
        tickHP,
        tickMP,
        duration
    )
end
--- 初始化持续治疗效果系统
function ____exports.initHotSystem()
    if not HOT_SYSTEM_ENABLED then
        return
    end
    if hotTrigger ~= nil then
        return
    end
    local ____require_result_14 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
    local registerStesListener = ____require_result_14.registerStesListener
    hotTrigger = registerStesListener(nil, ____exports.HOT_EVENT_NAME, onHotEvent)
end
--- 检查系统是否已初始化
function ____exports.isHotSystemInitialized()
    return hotTrigger ~= nil
end
return ____exports
