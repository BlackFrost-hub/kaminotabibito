local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
local ____04_FF0E_6FC0_6D3B_4F20_9001_70B9_914D_7F6E = require("系统.07．地形系统.04．激活传送点配置")
local _____6FC0_6D3B_4F20_9001_70B9_914D_7F6E = ____04_FF0E_6FC0_6D3B_4F20_9001_70B9_914D_7F6E.default
--- 激活传送点系统（按《激活传送点配置》）：
-- - **enabled: false**：该条不启用，不创建单位、不注册任何触发器（与配置中其它字段无关）。
-- - **有 teleportX + teleportY + UnitID（四位 rawcode）**：进入游戏后在坐标处 CreateUnit，再对该单位注册接近检测；
-- - **仅有 UnitID 且为地图已创建的 gg_unit_***：依次尝试 jass.globals → jass.common → globalThis 上的同名键，注册接近检测；
-- - 首次有**任意单位**进入范围：将传送点单位交给玩家 7、若有 reveal 则 **SetFogStateRect(Player(0), FOG_OF_WAR_VISIBLE, rect, true)**（单份矩形雾，不创建多份修饰器）、**仅玩家 1～4** 显示提示文本；**DestroyTrigger** 排泄事件，不保留检测。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_0.stringToFourCC
local withTimer = ____require_result_0.withTimer
local ____require_result_1 = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_Mp3Play = ____require_result_1.Sound3DII_Mp3Play
local unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local ACTIVATION_SOUND = "Sound\\Interface\\SecretFound.wav"
--- 设为 true：开局 0s / 1s 各打一行，对比 g / jass.common / globalThis 上 `gg_unit_htow_0030`。
-- 若三处长期全 nil/0：先在编辑器保存地图（生成 war3map 里 gg_unit_*），再打包/runmap；否则 Lua 读不到预置单位。
local DEBUG_GG_UNIT_HTOW_0030 = false
local DEBUG_GG_UNIT_HTOW_KEY = "gg_unit_htow_0030"
--- 接近传送点多少距离算激活（与地图尺度一致）
local ACTIVATION_RANGE = 300
--- 有坐标时 CreateUnit 的所属玩家：中立被动（common.j 的 PLAYER_NEUTRAL_PASSIVE，一般为 15）
local function neutralPassivePlayer(self)
    local ____temp_2
    if jass.PLAYER_NEUTRAL_PASSIVE ~= nil then
        ____temp_2 = jass.PLAYER_NEUTRAL_PASSIVE
    else
        ____temp_2 = 15
    end
    local pid = ____temp_2
    return jass.Player(pid)
end
local function dbg(self, _msg)
end
--- 预置 gg_unit_*：与 JASS 全局对齐时可能在 globals、common 或 Lua _G（globalThis）之一
local function resolveGgUnitByKey(self, unitKey)
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
local function formatGgUnitProbe(self, u)
    if u == nil or u == 0 then
        return "nil/0"
    end
    local tail = ""
    tail = " typeId=" .. tostring(jass.GetUnitTypeId(u))
    if jass.UNIT_STATE_LIFE ~= nil then
        tail = (tail .. " life=") .. tostring(jass.GetUnitState(u, jass.UNIT_STATE_LIFE))
    end
    return "ok" .. tail
end
--- 开局 0s、1s 各一行：对比三处来源（用于排查间歇 nil）
local function scheduleDebugGgUnitHtow0030(self)
    if not DEBUG_GG_UNIT_HTOW_0030 then
        return
    end
    local key = DEBUG_GG_UNIT_HTOW_KEY
    local function runSnapshot(____, label)
        local gg = g
        local jc = jass
        local G = _G
        local vg = gg[key]
        local vj = jc[key]
        local vG = G[key]
        local msg = (((((((("[激活传送点调试] " .. label) .. " ") .. key) .. " | g=") .. formatGgUnitProbe(nil, vg)) .. " | jass.common=") .. formatGgUnitProbe(nil, vj)) .. " | globalThis=") .. formatGgUnitProbe(nil, vG)
        do
            local pi = 0
            while pi < 4 do
                jass.DisplayTimedTextToPlayer(
                    jass.Player(pi),
                    0,
                    0,
                    14,
                    msg
                )
                pi = pi + 1
            end
        end
        local pr = _G.print
        pr(msg)
    end
    withTimer(
        nil,
        0,
        function()
            runSnapshot(nil, "0s")
        end
    )
    withTimer(
        nil,
        1,
        function()
            runSnapshot(nil, "1s")
        end
    )
end
local function parseCoord(self, v)
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
--- 解析要监视的「传送点实体」单位：有坐标则新建；否则用 gg_unit_*（多源解析）。
local function resolveWatchUnit(self, cfg)
    local tx = parseCoord(nil, cfg.teleportX)
    local ty = parseCoord(nil, cfg.teleportY)
    local hasXY = tx ~= nil and ty ~= nil
    if hasXY and cfg.UnitID ~= nil and #cfg.UnitID >= 4 then
        local four = stringToFourCC(
            nil,
            __TS__StringSubstring(cfg.UnitID, 0, 4)
        )
        if four == 0 then
            return nil
        end
        local passive = neutralPassivePlayer(nil)
        if passive == nil then
            return nil
        end
        local ____temp_3
        if type(jass.bj_UNIT_FACING) == "number" then
            ____temp_3 = jass.bj_UNIT_FACING
        else
            ____temp_3 = 270
        end
        local face = ____temp_3
        local u = jass.CreateUnit(
            passive,
            four,
            tx,
            ty,
            face
        )
        local ____temp_4
        if u ~= nil and u ~= 0 then
            ____temp_4 = u
        else
            ____temp_4 = nil
        end
        return ____temp_4
    end
    if cfg.UnitID ~= nil and (string.find(cfg.UnitID, "gg_", nil, true) or 0) - 1 == 0 then
        return resolveGgUnitByKey(nil, cfg.UnitID)
    end
    return nil
end
local function runActivationEffects(self, cfg, watchUnit)
    local gg = g
    if cfg.UnitID ~= nil and watchUnit ~= nil and watchUnit ~= 0 then
        local p6 = jass.Player(6)
        if p6 then
            jass.SetUnitOwner(watchUnit, p6, true)
        end
    end
    if cfg.reveal ~= nil then
        local revealRect = gg[cfg.reveal]
        if revealRect then
            local mode = jass.FOG_OF_WAR_VISIBLE
            jass.SetFogStateRect(
                jass.Player(0),
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
                jass.DisplayTimedTextToPlayer(
                    jass.Player(i),
                    0,
                    0,
                    8,
                    cfg.text
                )
                i = i + 1
            end
        end
    end
    local localPlayer = jass.GetLocalPlayer()
    do
        local i = 0
        while i < 4 do
            if localPlayer == jass.Player(i) then
                Sound3DII_Mp3Play(nil, ACTIVATION_SOUND)
                break
            end
            i = i + 1
        end
    end
end
local function registerOnePoint(self, cfg, key)
    local watchUnit = resolveWatchUnit(nil, cfg)
    if watchUnit == nil or watchUnit == 0 then
        dbg(nil, "跳过：无有效监视单位 " .. key)
        return
    end
    local trig = jass.CreateTrigger()
    local unregister = unitSpecificEventCenter.registerUnitInRangeTrigger(
        trig,
        watchUnit,
        ACTIVATION_RANGE,
        nil,
        true
    )
    local fired = false
    jass.TriggerAddAction(
        trig,
        function()
            if fired then
                return
            end
            local enterer = jass.GetTriggerUnit()
            if enterer == nil or enterer == 0 then
                return
            end
            fired = true
            runActivationEffects(nil, cfg, watchUnit)
            unregister(nil)
            jass.DestroyTrigger(trig)
        end
    )
end
local function initActivationPointsInternal(self)
    local count = 0
    for key in pairs(_____6FC0_6D3B_4F20_9001_70B9_914D_7F6E) do
        do
            local cfg = _____6FC0_6D3B_4F20_9001_70B9_914D_7F6E[key]
            if not cfg or cfg.enabled == false then
                goto __continue44
            end
            registerOnePoint(nil, cfg, key)
            count = count + 1
        end
        ::__continue44::
    end
    dbg(
        nil,
        "已注册激活传送点(接近检测): " .. tostring(count)
    )
end
--- 在地图初始化时调用（建议用 0.00 秒计时器）
____exports["init激活传送点"] = function(self)
    scheduleDebugGgUnitHtow0030(nil)
    withTimer(
        nil,
        0,
        function()
            initActivationPointsInternal(nil)
        end
    )
end
return ____exports
