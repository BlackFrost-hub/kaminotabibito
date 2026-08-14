local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
local ____02_FF0E_533A_57DF_4F20_9001_914D_7F6E = require("系统.07．地形系统.02．区域传送配置")
local _____533A_57DF_4F20_9001_914D_7F6E = ____02_FF0E_533A_57DF_4F20_9001_914D_7F6E.default
local _____5267_60C5_52A8_6001_4F20_9001_914D_7F6E_8868 = ____02_FF0E_533A_57DF_4F20_9001_914D_7F6E["剧情动态传送配置表"]
--- 区域传送：
-- - 开局按 `区域传送配置` 批量创建 Region 并注册进入事件
-- - 单位进入 Region 时，根据配置表把单位瞬移到目标点、移动镜头、显示文字
-- - 只对非中立敌对玩家生效，传送后立刻下达 stop 命令防止继续走回去
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.index")
local StarOther_PanCameraToTimedForPlayer = ____require_result_1.StarOther_PanCameraToTimedForPlayer
local ____require_result_2 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____require_result_2.YDUserDataGet
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_4["广播单位提示"]
local regionEventCenter = require("系统.00．核心系统.01．事件中心.02．区域事件中心")
local GetHeroLevel = jass.GetHeroLevel
local CreateUnit = jass.CreateUnit
local GetRandomReal = jass.GetRandomReal
local Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
local regionMap = __TS__New(Map)
local _____533A_57DF_4F20_9001_5DF2_521D_59CB_5316 = false
local _____5355_4F4D_533A_57DF_4F20_9001_51B7_5374 = {}
local _____533A_57DF_4F20_9001_8FDE_89E6_53D1_4FDD_62A4Ms = 500
local _____533A_57DF_4F20_9001_9996_6B21_8FDB_5165_5DF2_5904_7406 = {}
local _____5267_60C5_73A9_5BB6_7EC4_4F20_9001_72B6_6001_8868 = {}
local _____5F53_524D_5267_60C5_73A9_5BB6_7EC4_4F20_9001_72B6_6001
local function dbg(_msg)
end
local function getStoryProgress()
    local raw = YDUserDataGet(
        nil,
        "string",
        "剧情进度",
        "整数",
        "integer"
    )
    local numeric = raw == nil and 0 or __TS__Number(raw)
    return __TS__NumberIsFinite(__TS__Number(numeric)) and numeric or 0
end
local function checkRegionCondition(cond, _unit)
    if not cond or cond == "always" then
        return true
    end
    local text = __TS__StringTrim(cond)
    local alternatives = __TS__StringSplit(text, "||")
    if #alternatives > 1 then
        do
            local i = 0
            while i < #alternatives do
                local alternative = __TS__StringTrim(alternatives[i + 1])
                if alternative ~= "" and checkRegionCondition(alternative, _unit) then
                    return true
                end
                i = i + 1
            end
        end
        return false
    end
    local current = getStoryProgress()
    local function evalByPrefix(prefix, matcher)
        if (string.find(text, prefix, nil, true) or 0) - 1 ~= 0 then
            return nil
        end
        local target = __TS__Number(__TS__StringTrim(__TS__StringSubstring(text, #prefix)))
        if not __TS__NumberIsFinite(__TS__Number(target)) then
            return true
        end
        return matcher(current, target)
    end
    local gte = evalByPrefix(
        "zhuxian≥",
        function(a, b) return a >= b end
    )
    if gte ~= nil then
        return gte
    end
    local lte = evalByPrefix(
        "zhuxian≤",
        function(a, b) return a <= b end
    )
    if lte ~= nil then
        return lte
    end
    local gteAscii = evalByPrefix(
        "zhuxian>=",
        function(a, b) return a >= b end
    )
    if gteAscii ~= nil then
        return gteAscii
    end
    local lteAscii = evalByPrefix(
        "zhuxian<=",
        function(a, b) return a <= b end
    )
    if lteAscii ~= nil then
        return lteAscii
    end
    local gt = evalByPrefix(
        "zhuxian>",
        function(a, b) return a > b end
    )
    if gt ~= nil then
        return gt
    end
    local lt = evalByPrefix(
        "zhuxian<",
        function(a, b) return a < b end
    )
    if lt ~= nil then
        return lt
    end
    local eq = evalByPrefix(
        "zhuxian=",
        function(a, b) return a == b end
    )
    if eq ~= nil then
        return eq
    end
    if (string.find(text, "zhuxian", nil, true) or 0) - 1 == 0 then
        return true
    end
    return true
end
local function runRegionRule(rule, unit, owner)
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
                goto __continue30
            end
            local percentIdx = (string.find(s, "%", nil, true) or 0) - 1
            if percentIdx <= 0 then
                goto __continue30
            end
            local weightStr = __TS__StringTrim(__TS__StringSubstring(s, 0, percentIdx))
            local rest = __TS__StringTrim(__TS__StringSubstring(s, percentIdx + 1))
            local weight = __TS__Number(weightStr)
            if not weight or not __TS__NumberIsFinite(__TS__Number(weight)) or weight <= 0 then
                goto __continue30
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
        ::__continue30::
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
    local function formatText(raw)
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
        local msg = formatText(chosen.text)
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
        local msg = formatText(nil)
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
local function isAliveHero(unit)
    return unit ~= nil and unit ~= 0 and jass.IsUnitType(unit, jass.UNIT_TYPE_HERO) == true and jass.IsUnitType(unit, jass.UNIT_TYPE_DEAD) ~= true
end
local function isRegionTeleportCoolingDown(unit)
    local id = jass.GetHandleId(unit)
    local now = getServerTime()
    local last = _____5355_4F4D_533A_57DF_4F20_9001_51B7_5374[id] or 0
    if last > 0 and now - last < _____533A_57DF_4F20_9001_8FDE_89E6_53D1_4FDD_62A4Ms then
        return true
    end
    _____5355_4F4D_533A_57DF_4F20_9001_51B7_5374[id] = now
    return false
end
local function _____6EE1_8DB3_533A_57DF_4F20_9001_6700_4F4E_7B49_7EA7(cfg, unit)
    local _____6700_4F4E_82F1_96C4_7B49_7EA7 = cfg["最低英雄等级"]
    if _____6700_4F4E_82F1_96C4_7B49_7EA7 == nil or _____6700_4F4E_82F1_96C4_7B49_7EA7 <= 0 then
        return true
    end
    return GetHeroLevel(unit) >= _____6700_4F4E_82F1_96C4_7B49_7EA7
end
local function _____6267_884C_533A_57DF_4F20_9001_9996_6B21_8FDB_5165_521B_5EFA(cfg)
    if _____533A_57DF_4F20_9001_9996_6B21_8FDB_5165_5DF2_5904_7406[cfg.id] == true then
        return
    end
    local _____521B_5EFA_914D_7F6E = cfg["首次进入创建单位"]
    if _____521B_5EFA_914D_7F6E == nil then
        return
    end
    local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____521B_5EFA_914D_7F6E["单位ID"])
    if _____5355_4F4D_7C7B_578BID == 0 then
        return
    end
    if _____521B_5EFA_914D_7F6E["所属玩家"] ~= "中立敌对" then
        return
    end
    _____533A_57DF_4F20_9001_9996_6B21_8FDB_5165_5DF2_5904_7406[cfg.id] = true
    local _____4E2D_7ACB_654C_5BF9 = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
    local _____9762_5411_89D2_5EA6 = _____521B_5EFA_914D_7F6E["随机面向"] and GetRandomReal(0, 360) or 0
    CreateUnit(
        _____4E2D_7ACB_654C_5BF9,
        _____5355_4F4D_7C7B_578BID,
        _____521B_5EFA_914D_7F6E.x,
        _____521B_5EFA_914D_7F6E.y,
        _____9762_5411_89D2_5EA6
    )
end
local function _____6267_884C_533A_57DF_4F20_9001_540E_5E7F_64AD(cfg, unit)
    local _____5E7F_64AD_914D_7F6E = cfg["传送后广播"]
    if _____5E7F_64AD_914D_7F6E == nil or _____5E7F_64AD_914D_7F6E["文本"] == "" then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(unit, _____5E7F_64AD_914D_7F6E["文本"], _____5E7F_64AD_914D_7F6E["持续时间毫秒"])
end
local function onRegionEnter()
    local unit = jass.GetTriggerUnit()
    local region = jass.GetTriggeringRegion()
    if unit == nil or region == nil then
        return
    end
    if not isAliveHero(unit) then
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
    if not _____6EE1_8DB3_533A_57DF_4F20_9001_6700_4F4E_7B49_7EA7(cfg, unit) then
        return
    end
    if isRegionTeleportCoolingDown(unit) then
        return
    end
    local useRule = cfg.teleportX == 0 and cfg.teleportY == 0 and type(cfg.rule) == "string" and #cfg.rule > 0
    if useRule then
        runRegionRule(cfg.rule, unit, owner)
        return
    end
    jass.SetUnitPosition(unit, cfg.teleportX, cfg.teleportY)
    if cfg.teleportFacing ~= nil then
        SetUnitFacing(unit, cfg.teleportFacing)
    end
    jass.IssueImmediateOrder(unit, "stop")
    local player = owner
    if player ~= nil then
        StarOther_PanCameraToTimedForPlayer(player, cfg.teleportX, cfg.teleportY, cfg.cameraTime)
        if cfg.text ~= nil and cfg.text ~= "" then
            jass.DisplayTimedTextToPlayer(
                player,
                0,
                0,
                8,
                cfg.text
            )
        end
    end
    _____6267_884C_533A_57DF_4F20_9001_9996_6B21_8FDB_5165_521B_5EFA(cfg)
    _____6267_884C_533A_57DF_4F20_9001_540E_5E7F_64AD(cfg, unit)
end
local function isValidRegionRect(cfg)
    return cfg.left < cfg.right and cfg.bottom < cfg.top
end
local function initRegionTeleport()
    if _____533A_57DF_4F20_9001_5DF2_521D_59CB_5316 then
        return
    end
    _____533A_57DF_4F20_9001_5DF2_521D_59CB_5316 = true
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
                goto __continue83
            end
            if not isValidRegionRect(cfg) then
                goto __continue83
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
        ::__continue83::
    end
    jass.TriggerAddAction(trig, onRegionEnter)
end
local function onInitRegionTeleportDelayed()
    initRegionTeleport()
end
local function _____5267_60C5_4F20_9001_53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
local function _____5267_60C5_4F20_9001_5355_4F4D_53EF_8FDB_5165(unit)
    if not _____5267_60C5_4F20_9001_53E5_67C4_6709_6548(unit) then
        return false
    end
    if jass.IsUnitType(unit, jass.UNIT_TYPE_HERO) ~= true then
        return false
    end
    if jass.IsUnitType(unit, jass.UNIT_TYPE_DEAD) == true then
        return false
    end
    local owner = jass.GetOwningPlayer(unit)
    local neutralAggressive = jass.Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
    return owner == nil or owner ~= neutralAggressive
end
local function _____7A7A_5267_60C5_4F20_9001_6E05_7406()
end
--- 读取地形系统集中维护的剧情动态传送配置。
____exports["读取剧情传送配置"] = function(_____914D_7F6EID)
    return _____5267_60C5_52A8_6001_4F20_9001_914D_7F6E_8868[_____914D_7F6EID]
end
local function ____on_79FB_52A8_5267_60C5_73A9_5BB6_7EC4()
    local _____72B6_6001 = _____5F53_524D_5267_60C5_73A9_5BB6_7EC4_4F20_9001_72B6_6001
    if _____72B6_6001 == nil then
        return
    end
    local unit = jass.GetEnumUnit()
    if not _____5267_60C5_4F20_9001_5355_4F4D_53EF_8FDB_5165(unit) then
        return
    end
    jass.SetUnitPosition(unit, _____72B6_6001["配置"]["目标X"], _____72B6_6001["配置"]["目标Y"])
    if _____72B6_6001["配置"]["目标面向"] ~= nil then
        jass.SetUnitFacing(unit, _____72B6_6001["配置"]["目标面向"])
    end
    jass.IssueImmediateOrder(unit, "stop")
    local _____955C_5934_5E73_79FB_65F6_957F = _____72B6_6001["配置"]["镜头平移时长"]
    if _____955C_5934_5E73_79FB_65F6_957F ~= nil and _____955C_5934_5E73_79FB_65F6_957F > 0 then
        StarOther_PanCameraToTimedForPlayer(
            jass.GetOwningPlayer(unit),
            _____72B6_6001["配置"]["目标X"],
            _____72B6_6001["配置"]["目标Y"],
            _____955C_5934_5E73_79FB_65F6_957F
        )
    end
end
local function _____6E05_7406_5267_60C5_73A9_5BB6_7EC4_4F20_9001_72B6_6001(_____72B6_6001)
    local triggerId = __TS__Number(jass.GetHandleId(_____72B6_6001["触发器"]))
    if _____72B6_6001["取消监听"] ~= nil then
        _____72B6_6001["取消监听"]()
    end
    if _____5267_60C5_4F20_9001_53E5_67C4_6709_6548(_____72B6_6001["触发器"]) then
        jass.DestroyTrigger(_____72B6_6001["触发器"])
    end
    if _____5267_60C5_4F20_9001_53E5_67C4_6709_6548(_____72B6_6001["矩形"]) then
        jass.RemoveRect(_____72B6_6001["矩形"])
    end
    if _____5267_60C5_4F20_9001_53E5_67C4_6709_6548(_____72B6_6001["区域"]) then
        jass.RemoveRegion(_____72B6_6001["区域"])
    end
    if triggerId > 0 then
        _____5267_60C5_73A9_5BB6_7EC4_4F20_9001_72B6_6001_8868[triggerId] = nil
    end
end
local function ____on_5267_60C5_73A9_5BB6_7EC4_4F20_9001_8FDB_5165()
    local trigger = jass.GetTriggeringTrigger()
    local triggerId = __TS__Number(jass.GetHandleId(trigger))
    local _____72B6_6001 = _____5267_60C5_73A9_5BB6_7EC4_4F20_9001_72B6_6001_8868[triggerId]
    if _____72B6_6001 == nil or _____72B6_6001["已触发"] then
        return
    end
    if not _____72B6_6001["配置"]["条件"]() then
        return
    end
    local enteringUnit = jass.GetTriggerUnit()
    if not _____5267_60C5_4F20_9001_5355_4F4D_53EF_8FDB_5165(enteringUnit) then
        return
    end
    if _____72B6_6001["配置"]["允许进入单位"] ~= nil and not _____72B6_6001["配置"]["允许进入单位"](enteringUnit) then
        return
    end
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____72B6_6001["配置"]["读取玩家英雄组"]()
    if not _____5267_60C5_4F20_9001_53E5_67C4_6709_6548(_____73A9_5BB6_82F1_96C4_7EC4) then
        return
    end
    _____72B6_6001["已触发"] = true
    _____6E05_7406_5267_60C5_73A9_5BB6_7EC4_4F20_9001_72B6_6001(_____72B6_6001)
    _____5F53_524D_5267_60C5_73A9_5BB6_7EC4_4F20_9001_72B6_6001 = _____72B6_6001
    jass.ForGroup(_____73A9_5BB6_82F1_96C4_7EC4, ____on_79FB_52A8_5267_60C5_73A9_5BB6_7EC4)
    _____5F53_524D_5267_60C5_73A9_5BB6_7EC4_4F20_9001_72B6_6001 = nil
    if _____72B6_6001["配置"]["完成"] ~= nil then
        _____72B6_6001["配置"]["完成"](enteringUnit)
    end
end
--- 按剧情动作动态注册一次性玩家英雄组传送。
-- 区域、触发器和监听都由地形系统统一创建与销毁；条件不满足时不会传送。
____exports["注册剧情玩家组传送"] = function(_____914D_7F6E)
    if _____914D_7F6E == nil or _____914D_7F6E["入口半径"] <= 0 or not _____914D_7F6E["条件"] or not _____914D_7F6E["读取玩家英雄组"] then
        return _____7A7A_5267_60C5_4F20_9001_6E05_7406
    end
    local region = jass.CreateRegion()
    local rect = jass.Rect(_____914D_7F6E["入口中心X"] - _____914D_7F6E["入口半径"], _____914D_7F6E["入口中心Y"] - _____914D_7F6E["入口半径"], _____914D_7F6E["入口中心X"] + _____914D_7F6E["入口半径"], _____914D_7F6E["入口中心Y"] + _____914D_7F6E["入口半径"])
    local trigger = jass.CreateTrigger()
    if not _____5267_60C5_4F20_9001_53E5_67C4_6709_6548(region) or not _____5267_60C5_4F20_9001_53E5_67C4_6709_6548(rect) or not _____5267_60C5_4F20_9001_53E5_67C4_6709_6548(trigger) then
        if _____5267_60C5_4F20_9001_53E5_67C4_6709_6548(rect) then
            jass.RemoveRect(rect)
        end
        if _____5267_60C5_4F20_9001_53E5_67C4_6709_6548(region) then
            jass.RemoveRegion(region)
        end
        if _____5267_60C5_4F20_9001_53E5_67C4_6709_6548(trigger) then
            jass.DestroyTrigger(trigger)
        end
        return _____7A7A_5267_60C5_4F20_9001_6E05_7406
    end
    jass.RegionAddRect(region, rect)
    jass.TriggerAddAction(trigger, ____on_5267_60C5_73A9_5BB6_7EC4_4F20_9001_8FDB_5165)
    local _____72B6_6001 = {
        ["配置"] = _____914D_7F6E,
        ["区域"] = region,
        ["矩形"] = rect,
        ["触发器"] = trigger,
        ["取消监听"] = regionEventCenter.registerEnterRegionTrigger(trigger, region, nil),
        ["已触发"] = false
    }
    local triggerId = __TS__Number(jass.GetHandleId(trigger))
    _____5267_60C5_73A9_5BB6_7EC4_4F20_9001_72B6_6001_8868[triggerId] = _____72B6_6001
    return function()
        if not _____72B6_6001["已触发"] then
            _____6E05_7406_5267_60C5_73A9_5BB6_7EC4_4F20_9001_72B6_6001(_____72B6_6001)
        end
    end
end
--- 按地形系统配置表中的 ID 注册剧情玩家组传送。
-- 剧情侧只提供玩家组和生命周期回调，不再重复维护坐标、范围和进度条件。
____exports["注册剧情配置传送"] = function(_____914D_7F6EID, _____8986_76D6)
    local _____914D_7F6E = ____exports["读取剧情传送配置"](_____914D_7F6EID)
    if _____914D_7F6E == nil or not _____914D_7F6E.enabled or _____8986_76D6 == nil or not _____8986_76D6["读取玩家英雄组"] then
        return _____7A7A_5267_60C5_4F20_9001_6E05_7406
    end
    return ____exports["注册剧情玩家组传送"]({
        ["入口中心X"] = _____914D_7F6E["入口中心X"],
        ["入口中心Y"] = _____914D_7F6E["入口中心Y"],
        ["入口半径"] = _____914D_7F6E["入口半径"],
        ["目标X"] = _____914D_7F6E["目标X"],
        ["目标Y"] = _____914D_7F6E["目标Y"],
        ["目标面向"] = _____914D_7F6E["目标面向"],
        ["镜头平移时长"] = _____914D_7F6E["镜头平移时长"],
        ["条件"] = _____8986_76D6["条件"] or (function() return checkRegionCondition(_____914D_7F6E.condition, nil) end),
        ["读取玩家英雄组"] = _____8986_76D6["读取玩家英雄组"],
        ["允许进入单位"] = _____8986_76D6["允许进入单位"],
        ["完成"] = _____8986_76D6["完成"]
    })
end
--- 在游戏初始化时调用（建议用 0.00 秒计时器或地图初始化事件）
____exports["init区域传送"] = function()
    addDelayedCallback(0, onInitRegionTeleportDelayed)
end
return ____exports
