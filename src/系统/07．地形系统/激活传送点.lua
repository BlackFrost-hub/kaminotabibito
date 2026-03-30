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
-- - **仅有 UnitID 且为地图已创建的 gg_unit_***：直接取 jass.globals 上的单位引用，注册接近检测；
-- - 首次有**任意单位**进入范围：将传送点单位交给玩家 7、若有 reveal 则 **SetFogStateRect(Player(0), FOG_OF_WAR_VISIBLE, rect, true)**（单份矩形雾，不创建多份修饰器）、**仅玩家 1～4** 显示提示文本；**DestroyTrigger** 排泄事件，不保留检测。
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.音效函数")
local Sound3DII_Mp3Play = ____require_result_0.Sound3DII_Mp3Play
local ACTIVATION_SOUND = "Sound\\Interface\\SecretFound.wav"
--- 设为 false 可关闭：开局 1 秒后检测 `jass.globals.gg_unit_htow_0030` 是否存在（验证是否被 KillUnit / 未预置）
local DEBUG_GG_UNIT_HTOW_0030 = true
local DEBUG_GG_UNIT_HTOW_KEY = "gg_unit_htow_0030"
--- 接近传送点多少距离算激活（与地图尺度一致）
local ACTIVATION_RANGE = 300
--- 有坐标时 CreateUnit 的所属玩家：中立被动（common.j 的 PLAYER_NEUTRAL_PASSIVE，一般为 15）
local function neutralPassivePlayer(self)
    if type(jass.Player) ~= "function" then
        return nil
    end
    local ____temp_1
    if jass.PLAYER_NEUTRAL_PASSIVE ~= nil then
        ____temp_1 = jass.PLAYER_NEUTRAL_PASSIVE
    else
        ____temp_1 = 15
    end
    local pid = ____temp_1
    return jass.Player(pid)
end
local function dbg(self, _msg)
end
--- 游戏 1 秒后向玩家 0～3 各打一行字，检查 globals 上该 gg_unit 句柄
local function scheduleDebugGgUnitHtow0030(self)
    if not DEBUG_GG_UNIT_HTOW_0030 then
        return
    end
    if type(jass.CreateTimer) ~= "function" or type(jass.TimerStart) ~= "function" then
        return
    end
    local tm = jass.CreateTimer()
    jass.TimerStart(
        tm,
        1,
        false,
        function()
            if type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(tm)
            end
            local gg = g
            local u = gg[DEBUG_GG_UNIT_HTOW_KEY]
            local msg
            if u == nil or u == 0 then
                msg = ("[激活传送点调试] 1s时 " .. DEBUG_GG_UNIT_HTOW_KEY) .. " = nil/0（未预置或已移除；若地图里有 call KillUnit 则此处必为无效）"
            else
                local tail = ""
                if type(jass.GetUnitTypeId) == "function" then
                    tail = " typeId=" .. tostring(jass.GetUnitTypeId(u))
                end
                if type(jass.GetUnitState) == "function" and jass.UNIT_STATE_LIFE ~= nil then
                    tail = (tail .. " life=") .. tostring(jass.GetUnitState(u, jass.UNIT_STATE_LIFE))
                end
                msg = (("[激活传送点调试] 1s时 " .. DEBUG_GG_UNIT_HTOW_KEY) .. " 句柄有效") .. tail
            end
            if type(jass.DisplayTimedTextToPlayer) == "function" and type(jass.Player) == "function" then
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
            end
            local pr = _G.print
            if type(pr) == "function" then
                pr(msg)
            end
        end
    )
end
local function stringToFourCC(self, s)
    if s == nil or #s < 4 then
        return 0
    end
    local b1 = string.byte(s, 1) or 0 / 0
    local b2 = string.byte(s, 2) or 0 / 0
    local b3 = string.byte(s, 3) or 0 / 0
    local b4 = string.byte(s, 4) or 0 / 0
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
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
--- 解析要监视的「传送点实体」单位：有坐标则新建；否则用 globals 里已存在的 gg_unit。
local function resolveWatchUnit(self, cfg)
    local gg = g
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
        if passive == nil or type(jass.CreateUnit) ~= "function" then
            return nil
        end
        local ____temp_2
        if type(jass.bj_UNIT_FACING) == "number" then
            ____temp_2 = jass.bj_UNIT_FACING
        else
            ____temp_2 = 270
        end
        local face = ____temp_2
        local u = jass.CreateUnit(
            passive,
            four,
            tx,
            ty,
            face
        )
        local ____temp_3
        if u ~= nil and u ~= 0 then
            ____temp_3 = u
        else
            ____temp_3 = nil
        end
        return ____temp_3
    end
    if cfg.UnitID ~= nil and (string.find(cfg.UnitID, "gg_", nil, true) or 0) - 1 == 0 then
        local u = gg[cfg.UnitID]
        local ____temp_4
        if u ~= nil and u ~= 0 then
            ____temp_4 = u
        else
            ____temp_4 = nil
        end
        return ____temp_4
    end
    return nil
end
local function runActivationEffects(self, cfg, watchUnit)
    local gg = g
    if cfg.UnitID ~= nil and type(jass.SetUnitOwner) == "function" and type(jass.Player) == "function" and watchUnit ~= nil and watchUnit ~= 0 then
        local p6 = jass.Player(6)
        if p6 then
            jass.SetUnitOwner(watchUnit, p6, true)
        end
    end
    if cfg.reveal ~= nil and type(jass.SetFogStateRect) == "function" and type(jass.Player) == "function" then
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
    if cfg.text ~= nil and type(jass.DisplayTimedTextToPlayer) == "function" and type(jass.Player) == "function" then
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
    if type(jass.GetLocalPlayer) == "function" and type(jass.Player) == "function" then
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
end
local function registerOnePoint(self, cfg, key)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" then
        return
    end
    if type(jass.TriggerRegisterUnitInRange) ~= "function" then
        dbg(nil, "缺少 TriggerRegisterUnitInRange")
        return
    end
    local watchUnit = resolveWatchUnit(nil, cfg)
    if watchUnit == nil or watchUnit == 0 then
        dbg(nil, "跳过：无有效监视单位 " .. key)
        return
    end
    local trig = jass.CreateTrigger()
    jass.TriggerRegisterUnitInRange(trig, watchUnit, ACTIVATION_RANGE, nil)
    local fired = false
    jass.TriggerAddAction(
        trig,
        function()
            if fired then
                return
            end
            local ____temp_5
            if type(jass.GetTriggerUnit) == "function" then
                ____temp_5 = jass.GetTriggerUnit()
            else
                ____temp_5 = nil
            end
            local enterer = ____temp_5
            if enterer == nil or enterer == 0 then
                return
            end
            fired = true
            runActivationEffects(nil, cfg, watchUnit)
            if type(jass.DestroyTrigger) == "function" then
                jass.DestroyTrigger(trig)
            end
        end
    )
end
local function initActivationPointsInternal(self)
    local count = 0
    for key in pairs(_____6FC0_6D3B_4F20_9001_70B9_914D_7F6E) do
        do
            local __continue50
            repeat
                local cfg = _____6FC0_6D3B_4F20_9001_70B9_914D_7F6E[key]
                if not cfg or cfg.enabled == false then
                    __continue50 = true
                    break
                end
                registerOnePoint(nil, cfg, key)
                count = count + 1
                __continue50 = true
            until true
            if not __continue50 then
                break
            end
        end
    end
    dbg(
        nil,
        "已注册激活传送点(接近检测): " .. tostring(count)
    )
end
--- 在地图初始化时调用（建议用 0.00 秒计时器）
____exports["init激活传送点"] = function(self)
    scheduleDebugGgUnitHtow0030(nil)
    if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" then
        local t = jass.CreateTimer()
        jass.TimerStart(
            t,
            0,
            false,
            function()
                if type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(t)
                end
                initActivationPointsInternal(nil)
            end
        )
    else
        initActivationPointsInternal(nil)
    end
end
return ____exports
