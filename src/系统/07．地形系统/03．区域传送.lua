local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local ____exports = {}
local ____02_FF0E_533A_57DF_4F20_9001_914D_7F6E = require("系统.07．地形系统.02．区域传送配置")
local _____533A_57DF_4F20_9001_914D_7F6E = ____02_FF0E_533A_57DF_4F20_9001_914D_7F6E.default
--- 区域传送：
-- - 开局按 `区域传送配置` 批量创建 Region 并注册进入事件
-- - 单位进入 Region 时，根据配置表把单位瞬移到目标点、移动镜头、显示文字
-- - 只对非中立敌对玩家生效，传送后立刻下达 stop 命令防止继续走回去
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local withTimer = ____require_result_0.withTimer
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.index")
local StarOther_PanCameraToTimedForPlayer = ____require_result_1.StarOther_PanCameraToTimedForPlayer
local regionEventCenter = require("系统.00．核心系统.01．事件中心.02．区域事件中心")
local regionMap = __TS__New(Map)
local function dbg(self, _msg)
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
            local s = __TS__StringTrim(raw)
            if not s then
                goto __continue7
            end
            local percentIdx = (string.find(s, "%", nil, true) or 0) - 1
            if percentIdx <= 0 then
                goto __continue7
            end
            local weightStr = __TS__StringTrim(__TS__StringSubstring(s, 0, percentIdx))
            local rest = __TS__StringTrim(__TS__StringSubstring(s, percentIdx + 1))
            local weight = __TS__Number(weightStr)
            if not weight or not __TS__NumberIsFinite(__TS__Number(weight)) or weight <= 0 then
                goto __continue7
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
        end
        ::__continue7::
    end
    if #items == 0 or totalWeight <= 0 then
        return
    end
    local r = jass.GetRandomInt(1, totalWeight)
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
    local n = jass.GetUnitName(unit)
    if n ~= nil then
        unitName = tostring(n)
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
        jass.KillUnit(unit)
        local msg = formatText(nil, chosen.text)
        if msg and owner ~= nil then
            jass.DisplayTimedTextToPlayer(
                owner,
                0,
                0,
                8,
                msg
            )
        end
    elseif chosen.action == "Teleport" then
        if chosen.x ~= nil and chosen.y ~= nil then
            jass.SetUnitPosition(unit, chosen.x, chosen.y)
        end
        local msg = formatText(nil, nil)
        if msg and owner ~= nil then
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
    end
    for k in pairs(_____533A_57DF_4F20_9001_914D_7F6E) do
        do
            local cfg = _____533A_57DF_4F20_9001_914D_7F6E[k]
            if cfg == nil or not cfg.enabled then
                goto __continue33
            end
            local region = jass.CreateRegion()
            local rect = jass.Rect(cfg.left, cfg.bottom, cfg.right, cfg.top)
            jass.RegionAddRect(region, rect)
            jass.RemoveRect(rect)
            regionEventCenter.registerEnterRegionTrigger(trig, region, nil)
            regionMap:set(
                jass.GetHandleId(region),
                cfg
            )
        end
        ::__continue33::
    end
    local function onEnter()
        local unit = jass.GetTriggerUnit()
        local region = jass.GetTriggeringRegion()
        if unit == nil or region == nil then
            return
        end
        local owner = jass.GetOwningPlayer(unit)
        if owner ~= nil and jass.PLAYER_NEUTRAL_AGGRESSIVE ~= nil then
            local neutralAgg = jass.Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
            if owner == neutralAgg then
                return
            end
        end
        local cfg = regionMap:get(jass.GetHandleId(region))
        if cfg == nil then
            return
        end
        if not checkRegionCondition(cfg.condition, unit) then
            return
        end
        local useRule = cfg.teleportX == 0 and cfg.teleportY == 0 and type(cfg.rule) == "string" and #cfg.rule > 0
        if useRule then
            runRegionRule(nil, cfg.rule, unit, owner)
            return
        end
        jass.SetUnitPosition(unit, cfg.teleportX, cfg.teleportY)
        jass.IssueImmediateOrder(unit, "stop")
        local player = owner
        if player ~= nil then
            StarOther_PanCameraToTimedForPlayer(
                nil,
                player,
                cfg.teleportX,
                cfg.teleportY,
                cfg.cameraTime
            )
            jass.DisplayTimedTextToPlayer(
                player,
                0,
                0,
                8,
                cfg.text
            )
        end
    end
    jass.TriggerAddAction(trig, onEnter)
end
--- 在游戏初始化时调用（建议用 0.00 秒计时器或地图初始化事件）
____exports["init区域传送"] = function(self)
    withTimer(
        nil,
        0,
        function()
            initRegionTeleport(nil)
        end
    )
end
return ____exports
