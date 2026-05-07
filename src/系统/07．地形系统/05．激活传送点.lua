local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local neutralPassivePlayer, dbg, resolveGgUnitByKey, parseCoord, resolveWatchUnit, runActivationEffects, onActivationPointEnter, registerOnePoint, initActivationPointsInternal, jass, g, stringToFourCC, Sound3DII_Mp3Play, unitSpecificEventCenter, ACTIVATION_SOUND, activationPointTriggerKeyByHid, activationPointTriggerFiredByKey, activationPointTriggerWatchUnitByKey, activationPointTriggerHandleByKey, activationPointTriggerUnregisterByKey, ACTIVATION_RANGE
local ____04_FF0E_6FC0_6D3B_4F20_9001_70B9_914D_7F6E = require("系统.07．地形系统.04．激活传送点配置")
local _____6FC0_6D3B_4F20_9001_70B9_914D_7F6E = ____04_FF0E_6FC0_6D3B_4F20_9001_70B9_914D_7F6E.default
function neutralPassivePlayer()
    local ____temp_4
    if jass.PLAYER_NEUTRAL_PASSIVE ~= nil then
        ____temp_4 = jass.PLAYER_NEUTRAL_PASSIVE
    else
        ____temp_4 = 15
    end
    local pid = ____temp_4
    return jass:Player(pid)
end
function dbg(_msg)
end
function resolveGgUnitByKey(unitKey)
    local gg = g
    local jc = jass
    local G = _G
    local a = gg[unitKey]
    if a ~= nil and a ~= 0 then
        return a
    end
    local b = jc[unitKey]
    if b ~= nil and b ~= 0 then
        return b
    end
    local c = G[unitKey]
    if c ~= nil and c ~= 0 then
        return c
    end
    return nil
end
function parseCoord(v)
    if v == nil or v == nil then
        return nil
    end
    if type(v) == "number" and __TS__NumberIsFinite(__TS__Number(v)) then
        return v
    end
    if type(v) == "string" then
        local n = __TS__ParseFloat(v)
        return __TS__NumberIsFinite(__TS__Number(n)) and n or nil
    end
    return nil
end
function resolveWatchUnit(cfg)
    local tx = parseCoord(cfg.teleportX)
    local ty = parseCoord(cfg.teleportY)
    local hasXY = tx ~= nil and ty ~= nil
    if hasXY and cfg.UnitID ~= nil and #cfg.UnitID >= 4 then
        local four = stringToFourCC(
            nil,
            __TS__StringSubstring(cfg.UnitID, 0, 4)
        )
        if four == 0 then
            return nil
        end
        local passive = neutralPassivePlayer()
        if passive == nil then
            return nil
        end
        local ____temp_5
        if type(jass.bj_UNIT_FACING) == "number" then
            ____temp_5 = jass.bj_UNIT_FACING
        else
            ____temp_5 = 270
        end
        local face = ____temp_5
        local u = jass:CreateUnit(
            passive,
            four,
            tx,
            ty,
            face
        )
        local ____temp_6
        if u ~= nil and u ~= 0 then
            ____temp_6 = u
        else
            ____temp_6 = nil
        end
        return ____temp_6
    end
    if cfg.UnitID ~= nil and (string.find(cfg.UnitID, "gg_", nil, true) or 0) - 1 == 0 then
        return resolveGgUnitByKey(cfg.UnitID)
    end
    return nil
end
function runActivationEffects(cfg, watchUnit)
    local gg = g
    if cfg.UnitID ~= nil and watchUnit ~= nil and watchUnit ~= 0 then
        local p6 = jass:Player(6)
        if p6 then
            jass:SetUnitOwner(watchUnit, p6, true)
        end
    end
    if cfg.reveal ~= nil then
        local revealRect = gg[cfg.reveal]
        if revealRect then
            local mode = jass.FOG_OF_WAR_VISIBLE
            jass:SetFogStateRect(
                jass:Player(0),
                mode,
                revealRect,
                true
            )
        end
    end
    if cfg.text ~= nil and true then
        do
            local i = 0
            while i < 4 do
                jass:DisplayTimedTextToPlayer(
                    jass:Player(i),
                    0,
                    0,
                    8,
                    cfg.text
                )
                i = i + 1
            end
        end
    end
    local localPlayer = jass:GetLocalPlayer()
    do
        local i = 0
        while i < 4 do
            if localPlayer == jass:Player(i) then
                Sound3DII_Mp3Play(nil, ACTIVATION_SOUND)
                break
            end
            i = i + 1
        end
    end
end
function onActivationPointEnter()
    local trig = jass:GetTriggeringTrigger()
    if trig == nil or trig == 0 then
        return
    end
    local trigHid = jass:GetHandleId(trig)
    local key = activationPointTriggerKeyByHid[trigHid]
    if not key then
        return
    end
    if activationPointTriggerFiredByKey[key] == true then
        return
    end
    local enterer = jass:GetTriggerUnit()
    if enterer == nil or enterer == 0 then
        return
    end
    local cfg = _____6FC0_6D3B_4F20_9001_70B9_914D_7F6E[key]
    local watchUnit = activationPointTriggerWatchUnitByKey[key]
    if not cfg or watchUnit == nil or watchUnit == 0 then
        return
    end
    activationPointTriggerFiredByKey[key] = true
    runActivationEffects(cfg, watchUnit)
    local unregister = activationPointTriggerUnregisterByKey[key]
    if type(unregister) == "function" then
        unregister()
    end
    local handle = activationPointTriggerHandleByKey[key]
    if handle ~= nil and handle ~= 0 then
        __TS__Delete(
            activationPointTriggerKeyByHid,
            jass:GetHandleId(handle)
        )
        jass:DestroyTrigger(handle)
    end
    __TS__Delete(activationPointTriggerHandleByKey, key)
    __TS__Delete(activationPointTriggerWatchUnitByKey, key)
    __TS__Delete(activationPointTriggerUnregisterByKey, key)
end
function registerOnePoint(cfg, key)
    local watchUnit = resolveWatchUnit(cfg)
    if watchUnit == nil or watchUnit == 0 then
        dbg("跳过：无有效监视单位 " .. key)
        return
    end
    local trig = jass:CreateTrigger()
    local unregister = unitSpecificEventCenter.registerUnitInRangeTrigger(
        trig,
        watchUnit,
        ACTIVATION_RANGE,
        nil,
        true
    )
    activationPointTriggerKeyByHid[jass:GetHandleId(trig)] = key
    activationPointTriggerFiredByKey[key] = false
    activationPointTriggerWatchUnitByKey[key] = watchUnit
    activationPointTriggerHandleByKey[key] = trig
    activationPointTriggerUnregisterByKey[key] = unregister
    jass:TriggerAddAction(trig, onActivationPointEnter)
end
function initActivationPointsInternal()
    local count = 0
    for key in pairs(_____6FC0_6D3B_4F20_9001_70B9_914D_7F6E) do
        do
            local cfg = _____6FC0_6D3B_4F20_9001_70B9_914D_7F6E[key]
            if not cfg or cfg.enabled == false then
                goto __continue53
            end
            registerOnePoint(cfg, key)
            count = count + 1
        end
        ::__continue53::
    end
    dbg("已注册激活传送点(接近检测): " .. tostring(count))
end
jass = require("jass.common")
g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
stringToFourCC = ____require_result_0.stringToFourCC
local ____require_result_1 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_1.safeTimerStart
local safeDestroyTimer = ____require_result_1.safeDestroyTimer
local ____require_result_2 = require("lib.扩展函数.封装函数.02．音效系统.index")
Sound3DII_Mp3Play = ____require_result_2.Sound3DII_Mp3Play
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_3.debugLog
local setDebug = ____require_result_3.setDebug
unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
ACTIVATION_SOUND = "Sound\\Interface\\SecretFound.wav"
activationPointTriggerKeyByHid = {}
activationPointTriggerFiredByKey = {}
activationPointTriggerWatchUnitByKey = {}
activationPointTriggerHandleByKey = {}
activationPointTriggerUnregisterByKey = {}
--- 设为 true：开局 0s / 1s 各打一行，对比 g / jass.common / globalThis 上 `gg_unit_htow_0030`。
-- 若三处长期全 nil/0：先在编辑器保存地图（生成 war3map 里 gg_unit_*），再打包/runmap；否则 Lua 读不到预置单位。
local DEBUG_GG_UNIT_HTOW_0030 = false
setDebug(nil, "激活传送点", DEBUG_GG_UNIT_HTOW_0030)
local DEBUG_GG_UNIT_HTOW_KEY = "gg_unit_htow_0030"
ACTIVATION_RANGE = 300
local function formatGgUnitProbe(u)
    if u == nil or u == 0 then
        return "nil/0"
    end
    local tail = ""
    tail = " typeId=" .. tostring(jass:GetUnitTypeId(u))
    if jass.UNIT_STATE_LIFE ~= nil then
        tail = (tail .. " life=") .. tostring(jass:GetUnitState(u, jass.UNIT_STATE_LIFE))
    end
    return "ok" .. tail
end
local function onDebugSnapshot0sTimerExpire()
    local t = jass:GetExpiredTimer()
    local gAny = g
    local jc = jass
    local G = _G
    local key = DEBUG_GG_UNIT_HTOW_KEY
    local vg = gAny[key]
    local vj = jc[key]
    local vG = G[key]
    local msg = (((((((("[激活传送点调试] " .. "0s") .. " ") .. key) .. " | g=") .. formatGgUnitProbe(vg)) .. " | jass.common=") .. formatGgUnitProbe(vj)) .. " | globalThis=") .. formatGgUnitProbe(vG)
    do
        local pi = 0
        while pi < 4 do
            jass:DisplayTimedTextToPlayer(
                jass:Player(pi),
                0,
                0,
                14,
                msg
            )
            pi = pi + 1
        end
    end
    debugLog(nil, "激活传送点", msg)
    safeDestroyTimer(nil, t)
end
local function onDebugSnapshot1sTimerExpire()
    local t = jass:GetExpiredTimer()
    local gAny = g
    local jc = jass
    local G = _G
    local key = DEBUG_GG_UNIT_HTOW_KEY
    local vg = gAny[key]
    local vj = jc[key]
    local vG = G[key]
    local msg = (((((((("[激活传送点调试] " .. "1s") .. " ") .. key) .. " | g=") .. formatGgUnitProbe(vg)) .. " | jass.common=") .. formatGgUnitProbe(vj)) .. " | globalThis=") .. formatGgUnitProbe(vG)
    do
        local pi = 0
        while pi < 4 do
            jass:DisplayTimedTextToPlayer(
                jass:Player(pi),
                0,
                0,
                14,
                msg
            )
            pi = pi + 1
        end
    end
    debugLog(nil, "激活传送点", msg)
    safeDestroyTimer(nil, t)
end
local function onInitActivationPointsTimerExpire()
    local t = jass:GetExpiredTimer()
    initActivationPointsInternal()
    safeDestroyTimer(nil, t)
end
--- 开局 0s、1s 各一行：对比三处来源（用于排查间歇 nil）
local function scheduleDebugGgUnitHtow0030()
    if not DEBUG_GG_UNIT_HTOW_0030 then
        return
    end
    local t0 = jass:CreateTimer()
    if t0 then
        safeTimerStart(
            nil,
            t0,
            0,
            false,
            onDebugSnapshot0sTimerExpire
        )
    end
    local t1 = jass:CreateTimer()
    if t1 then
        safeTimerStart(
            nil,
            t1,
            1,
            false,
            onDebugSnapshot1sTimerExpire
        )
    end
end
--- 在地图初始化时调用（建议用 0.00 秒计时器）
____exports["init激活传送点"] = function()
    scheduleDebugGgUnitHtow0030()
    local t = jass:CreateTimer()
    if t then
        safeTimerStart(
            nil,
            t,
            0,
            false,
            onInitActivationPointsTimerExpire
        )
    end
end
return ____exports
