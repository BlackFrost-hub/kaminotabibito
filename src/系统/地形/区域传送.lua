local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local ____exports = {}
local _____533A_57DF_4F20_9001_914D_7F6E = require("系统.地形.区域传送配置")
local _____533A_57DF_4F20_9001_914D_7F6E = _____533A_57DF_4F20_9001_914D_7F6E.default
local _____955C_5934_7CFB_7EDF = require("系统.地形.镜头系统")
local panCameraToTimedForPlayer = _____955C_5934_7CFB_7EDF.panCameraToTimedForPlayer
--- 区域传送：
-- - 开局按 `区域传送配置` 批量创建 Region 并注册进入事件
-- - 单位进入 Region 时，根据配置表把单位瞬移到目标点、移动镜头、显示文字
-- - 只对非中立敌对玩家生效，传送后立刻下达 stop 命令防止继续走回去
local jass = require("jass.common")
local regionMap = __TS__New(Map)
local function dbg(self, msg)
    if type(jass.Player) ~= "function" or type(jass.DisplayTimedTextToPlayer) ~= "function" then
        return
    end
    local p0 = jass.Player(0)
    jass.DisplayTimedTextToPlayer(
        p0,
        0,
        0,
        15,
        msg
    )
end
local function checkRegionCondition(self, cond, _unit)
    if not cond or cond == "always" then
        return true
    end
    return true
end
local function runRegionRule(self, rule, unit, owner)
    if not rule then
        return
    end
    local parts = __TS__StringSplit(rule, ";")
    local items = {}
    local totalWeight = 0
    for ____, raw in ipairs(parts) do
        do
            local __continue8
            repeat
                local s = __TS__StringTrim(raw)
                if not s then
                    __continue8 = true
                    break
                end
                local percentIdx = (string.find(s, "%", nil, true) or 0) - 1
                if percentIdx <= 0 then
                    __continue8 = true
                    break
                end
                local weightStr = __TS__StringTrim(__TS__StringSubstring(s, 0, percentIdx))
                local rest = __TS__StringTrim(__TS__StringSubstring(s, percentIdx + 1))
                local weight = __TS__Number(weightStr)
                if not weight or not __TS__NumberIsFinite(__TS__Number(weight)) or weight <= 0 then
                    __continue8 = true
                    break
                end
                local colonIdx = (string.find(rest, ":", nil, true) or 0) - 1
                local actionName = __TS__StringTrim(colonIdx >= 0 and __TS__StringSubstring(rest, 0, colonIdx) or rest)
                local param = colonIdx >= 0 and __TS__StringTrim(__TS__StringSubstring(rest, colonIdx + 1)) or ""
                if actionName == "KillUnit" then
                    items[#items + 1] = {weight = weight, action = "KillUnit", text = param}
                    totalWeight = totalWeight + weight
                elseif actionName == "传送" or string.lower(actionName) == "teleport" then
                    local coords = __TS__StringSplit(param, ",")
                    if #coords >= 2 then
                        local x = __TS__Number(coords[1])
                        local y = __TS__Number(coords[2])
                        if __TS__NumberIsFinite(__TS__Number(x)) and __TS__NumberIsFinite(__TS__Number(y)) then
                            items[#items + 1] = {weight = weight, action = "Teleport", x = x, y = y}
                            totalWeight = totalWeight + weight
                        end
                    end
                end
                __continue8 = true
            until true
            if not __continue8 then
                break
            end
        end
    end
    if #items == 0 or totalWeight <= 0 then
        return
    end
    local r
    if type(jass.GetRandomInt) == "function" then
        r = jass.GetRandomInt(1, totalWeight)
    else
        local m = math
        local ____temp_0
        if type(m.random) == "function" then
            ____temp_0 = m:random(1, totalWeight)
        else
            ____temp_0 = 1
        end
        r = ____temp_0
    end
    local chosen
    for ____, it in ipairs(items) do
        if r <= it.weight then
            chosen = it
            break
        end
        r = r - it.weight
    end
    if not chosen then
        chosen = items[#items]
    end
    local unitName = "单位"
    if type(jass.GetUnitName) == "function" then
        local n = jass.GetUnitName(unit)
        if n ~= nil then
            unitName = tostring(n)
        end
    end
    local function formatText(____, raw)
        if not raw then
            return nil
        end
        return table.concat(
            __TS__StringSplit(raw, "{unit}"),
            unitName or ","
        )
    end
    if chosen.action == "KillUnit" then
        if type(jass.KillUnit) == "function" then
            jass.KillUnit(unit)
        end
        local msg = formatText(nil, chosen.text)
        if msg and owner ~= nil and type(jass.DisplayTimedTextToPlayer) == "function" then
            jass.DisplayTimedTextToPlayer(
                owner,
                0,
                0,
                8,
                msg
            )
        end
    elseif chosen.action == "Teleport" then
        if type(jass.SetUnitPosition) == "function" and chosen.x ~= nil and chosen.y ~= nil then
            jass.SetUnitPosition(unit, chosen.x, chosen.y)
        end
        local msg = formatText(nil, nil)
        if msg and owner ~= nil and type(jass.DisplayTimedTextToPlayer) == "function" then
            jass.DisplayTimedTextToPlayer(
                owner,
                0,
                0,
                8,
                msg
            )
        end
    end
end
local function initRegionTeleport(self)
    if type(jass.CreateTrigger) ~= "function" then
        return
    end
    local trig = jass.CreateTrigger()
    local total = 0
    local enabledCount = 0
    for k in pairs(_____533A_57DF_4F20_9001_914D_7F6E) do
        total = total + 1
        local cfg = _____533A_57DF_4F20_9001_914D_7F6E[k]
        local enabled = cfg ~= nil and cfg.enabled
        if enabled then
            enabledCount = enabledCount + 1
        end
        dbg(nil, (((("配置[" .. k) .. "] 区域ID=") .. (cfg ~= nil and cfg.id or "?")) .. " 是否启用=") .. (enabled and "true" or "false"))
    end
    dbg(
        nil,
        ((("【区域传送】共 " .. tostring(total)) .. " 个配置，启用 ") .. tostring(enabledCount)) .. " 个"
    )
    for k in pairs(_____533A_57DF_4F20_9001_914D_7F6E) do
        do
            local __continue39
            repeat
                local cfg = _____533A_57DF_4F20_9001_914D_7F6E[k]
                if cfg == nil or not cfg.enabled then
                    __continue39 = true
                    break
                end
                if type(jass.CreateRegion) ~= "function" then
                    __continue39 = true
                    break
                end
                local region = jass.CreateRegion()
                dbg(nil, "已创建区域: " .. cfg.id)
                if type(jass.Rect) ~= "function" then
                    __continue39 = true
                    break
                end
                local rect = jass.Rect(cfg.left, cfg.bottom, cfg.right, cfg.top)
                if type(jass.RegionAddRect) == "function" then
                    jass.RegionAddRect(region, rect)
                end
                if type(jass.TriggerRegisterEnterRegion) == "function" then
                    jass.TriggerRegisterEnterRegion(trig, region, nil)
                end
                dbg(nil, "已注册区域: " .. cfg.id)
                regionMap:set(region, cfg)
                __continue39 = true
            until true
            if not __continue39 then
                break
            end
        end
    end
    local function onEnter()
        local ____temp_1
        if type(jass.GetTriggerUnit) == "function" then
            ____temp_1 = jass.GetTriggerUnit()
        else
            ____temp_1 = nil
        end
        local unit = ____temp_1
        local ____temp_2
        if type(jass.GetTriggeringRegion) == "function" then
            ____temp_2 = jass.GetTriggeringRegion()
        else
            ____temp_2 = nil
        end
        local region = ____temp_2
        local regionId = region ~= nil and "(handle)" or "null"
        dbg(nil, "单位进入区域，region=" .. regionId)
        if unit == nil or region == nil then
            return
        end
        local ____temp_3
        if type(jass.GetOwningPlayer) == "function" then
            ____temp_3 = jass.GetOwningPlayer(unit)
        else
            ____temp_3 = nil
        end
        local owner = ____temp_3
        if owner ~= nil and type(jass.Player) == "function" and jass.PLAYER_NEUTRAL_AGGRESSIVE ~= nil then
            local neutralAgg = jass.Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
            if owner == neutralAgg then
                return
            end
        end
        local cfg = regionMap:get(region)
        dbg(nil, "从 Map 读取配置: " .. (cfg ~= nil and "成功 区域ID=" .. cfg.id or "失败"))
        if cfg == nil then
            return
        end
        if not checkRegionCondition(nil, cfg.condition, unit) then
            return
        end
        local useRule = cfg.teleportX == 0 and cfg.teleportY == 0 and type(cfg.rule) == "string" and #cfg.rule > 0
        if useRule then
            runRegionRule(nil, cfg.rule, unit, owner)
            return
        end
        dbg(
            nil,
            (("准备传送至: " .. tostring(cfg.teleportX)) .. ",") .. tostring(cfg.teleportY)
        )
        if type(jass.SetUnitPosition) == "function" then
            jass.SetUnitPosition(unit, cfg.teleportX, cfg.teleportY)
        end
        if type(jass.IssueImmediateOrder) == "function" then
            jass.IssueImmediateOrder(unit, "stop")
        end
        dbg(nil, "传送完成")
        local player = owner
        if player ~= nil then
            panCameraToTimedForPlayer(
                nil,
                player,
                cfg.teleportX,
                cfg.teleportY,
                cfg.cameraTime
            )
            if type(jass.DisplayTimedTextToPlayer) == "function" then
                jass.DisplayTimedTextToPlayer(
                    player,
                    0,
                    0,
                    8,
                    cfg.text
                )
            end
        end
    end
    if type(jass.TriggerAddAction) == "function" then
        jass.TriggerAddAction(trig, onEnter)
    end
end
--- 在游戏初始化时调用（建议用 0.00 秒计时器或地图初始化事件）
____exports["init区域传送"] = function(self)
    dbg(nil, "【区域传送】初始化开始")
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
                initRegionTeleport(nil)
            end
        )
    else
        initRegionTeleport(nil)
    end
end
return ____exports
