local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__Delete = ____lualib.__TS__Delete
local __TS__StringCharCodeAt = ____lualib.__TS__StringCharCodeAt
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local __TS__ArrayFrom = ____lualib.__TS__ArrayFrom
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local ____require_result_1 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_1.QuestMessageBJ
local ____require_result_2 = require("lib.扩展函数.BJ函数.05A．电影函数")
local TransmissionFromUnitWithNameBJ = ____require_result_2.TransmissionFromUnitWithNameBJ
local ____require_result_3 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_3.GetPlayersAll
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.index")
local forEachUnitInGroup = ____require_result_4.forEachUnitInGroup
local ____require_result_5 = require("系统.08．任务系统.00．配置表.06．主线任务配置表")
local MAIN_STORY_QUEST_CONFIGS = ____require_result_5.MAIN_STORY_QUEST_CONFIGS
local ____require_result_6 = require("系统.08．任务系统.01．任务数据")
local questDB = ____require_result_6.questDB
local QuestType = ____require_result_6.QuestType
local QuestStatus = ____require_result_6.QuestStatus
local ____require_result_7 = require("系统.08．任务系统.01．任务管理器.index")
local questManager = ____require_result_7.questManager
local ____require_result_8 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_8.debugLog
local ____G_9 = _G
local addPeriodicCallback = ____G_9.addPeriodicCallback
--- 二分开关：关则本模块 **不执行 init**（不注册 0.3s tick、不 ensureRuntimeQuest、不跑缺失函数统计）。
____exports.ENABLE_MAIN_QUEST_CONFIG_DRIVER = true
local YDGet = _G.YDUserDataGet
local YDSet = _G.YDUserDataSet
local RUNTIME_QUEST_ID = "main_story_runtime"
local running = false
local mainQuestTickRegistered = false
local function getStage()
    if type(YDGet) == "function" then
        return __TS__Number(YDGet("string", "剧情进度", "整数", "integer")) or 0
    end
    return 0
end
local function setStage(v)
    if type(YDSet) == "function" then
        YDSet(
            "string",
            "剧情进度",
            "整数",
            "integer",
            v
        )
    end
end
local function ensureRuntimeQuest()
    if questDB:getQuest(RUNTIME_QUEST_ID) then
        return
    end
    questDB:registerQuest({
        id = RUNTIME_QUEST_ID,
        type = QuestType.MAIN,
        title = "主线任务",
        description = "剧情进行中",
        objectives = {{
            id = "stage",
            description = "推进主线剧情",
            current = 0,
            required = 1,
            completed = false
        }},
        rewards = {},
        status = QuestStatus.UNDISCOVERED,
        icon = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",
        createdAt = os.time(),
        updatedAt = os.time()
    })
    questDB:acceptQuest(0, RUNTIME_QUEST_ID)
end
local function refreshQuestUI(desc, msg)
    local ____opt_12 = questDB.globalData
    if ____opt_12 ~= nil then
        ____opt_12 = ____opt_12.quests
    end
    local ____opt_result_14
    if ____opt_12 ~= nil then
        ____opt_result_14 = ____opt_12:get(RUNTIME_QUEST_ID)
    end
    local q = ____opt_result_14
    if q then
        if type(desc) == "string" and desc ~= "" then
            q.description = desc
        end
        q.updatedAt = os.time()
    end
    local triggerUIRefresh = questManager.triggerUIRefresh
    if type(triggerUIRefresh) == "function" then
        triggerUIRefresh:call(questManager, 0, RUNTIME_QUEST_ID)
    end
    if type(msg) == "string" and msg ~= "" then
        QuestMessageBJ(
            nil,
            GetPlayersAll(nil),
            g.bj_QUESTMESSAGE_UPDATED,
            msg
        )
    end
end
local function parseDialogLines(dialogPreview)
    if not dialogPreview then
        return {}
    end
    local out = {}
    local rows = __TS__StringSplit(dialogPreview, "\n")
    for ____, raw in ipairs(rows) do
        do
            local line = __TS__StringTrim(raw)
            if line == "" then
                goto __continue15
            end
            local dot = (string.find(line, ".", nil, true) or 0) - 1
            if dot <= 0 then
                goto __continue15
            end
            local left = __TS__StringTrim(__TS__StringSubstring(line, 0, dot))
            if left == "" or __TS__Number(left) <= 0 then
                goto __continue15
            end
            local body = __TS__StringTrim(__TS__StringSubstring(line, dot + 1))
            local sep = (string.find(body, "：", nil, true) or 0) - 1
            if sep < 0 then
                sep = (string.find(body, ":", nil, true) or 0) - 1
            end
            if sep <= 0 then
                goto __continue15
            end
            local speaker = __TS__StringTrim(__TS__StringSubstring(body, 0, sep))
            local text = __TS__StringTrim(__TS__StringSubstring(body, sep + 1))
            if speaker == "" or text == "" then
                goto __continue15
            end
            out[#out + 1] = {speaker = speaker, text = text}
        end
        ::__continue15::
    end
    return out
end
local function calcDialogDuration(text)
    local n = #text
    local t = 1 + jass.R2I(n / 10)
    if t < 2 then
        return 2
    end
    if t > 12 then
        return 12
    end
    return t
end
local function playDialog(dialogPreview)
    local lines = parseDialogLines(dialogPreview)
    for ____, line in ipairs(lines) do
        TransmissionFromUnitWithNameBJ(
            nil,
            GetPlayersAll(nil),
            nil,
            line.speaker,
            nil,
            line.text,
            g.bj_TIMETYPE_SET,
            calcDialogDuration(line.text),
            true
        )
    end
end
local function removeInlineBlockComments(s)
    local out = s
    while true do
        local l = (string.find(out, "/*", nil, true) or 0) - 1
        if l < 0 then
            break
        end
        local r = (string.find(
            out,
            "*/",
            math.max(l + 2 + 1, 1),
            true
        ) or 0) - 1
        if r < 0 then
            out = __TS__StringSubstring(out, 0, l)
            break
        end
        out = __TS__StringSubstring(out, 0, l) .. __TS__StringSubstring(out, r + 2)
    end
    return out
end
local function sanitizeActionCode(raw)
    local s = __TS__StringTrim(removeInlineBlockComments(raw))
    if s == "" then
        return ""
    end
    if (string.find(s, "//", nil, true) or 0) - 1 == 0 then
        return ""
    end
    if (string.find(s, "call ", nil, true) or 0) - 1 == 0 then
        s = __TS__StringTrim(__TS__StringSubstring(s, 5))
    end
    if (string.find(s, "set ", nil, true) or 0) - 1 == 0 then
        s = __TS__StringTrim(__TS__StringSubstring(s, 4))
    end
    return s
end
local function parseTimelineEntries(timeline)
    if not timeline then
        return {}
    end
    local out = {}
    local lines = __TS__StringSplit(timeline, "\n")
    for ____, raw in ipairs(lines) do
        do
            local line = __TS__StringTrim(raw)
            if line == "" then
                goto __continue40
            end
            local dot = (string.find(line, ".", nil, true) or 0) - 1
            if dot <= 0 then
                goto __continue40
            end
            local left = __TS__StringTrim(__TS__StringSubstring(line, 0, dot))
            local delay = __TS__Number(left)
            if delay ~= delay then
                goto __continue40
            end
            local code = sanitizeActionCode(__TS__StringSubstring(line, dot + 1))
            if code == "" then
                goto __continue40
            end
            out[#out + 1] = {delay = delay, code = code}
        end
        ::__continue40::
    end
    return out
end
local function createEvalEnv(triggerUnit)
    local gAny = _G
    local cachedLoc = nil
    local function local1GetFallback(ty, key)
        if type(gAny.YDLocal1Get) == "function" then
            return gAny:YDLocal1Get(ty, key)
        end
        if ty == "location" and key == "单位位置" and triggerUnit then
            if not cachedLoc then
                cachedLoc = jass.GetUnitLoc(triggerUnit)
            end
            return cachedLoc
        end
        return nil
    end
    local env = {
        __triggerUnit = triggerUnit,
        string = "string",
        integer = "integer",
        real = "real",
        unit = "unit",
        group = "group",
        player = "player",
        boolean = "boolean",
        GetTriggerUnit = function() return triggerUnit end,
        YDLocal1Get = local1GetFallback
    }
    if type(_G.setmetatable) == "function" then
        _G:setmetatable(env, {__index = _G})
    end
    return env
end
local function normalizeConditionExpr(expr)
    local s = expr
    s = table.concat(
        __TS__StringSplit(s, "\\\""),
        "\""
    )
    s = table.concat(
        __TS__StringSplit(s, "GetTriggerUnit()"),
        "__triggerUnit"
    )
    return s
end
local function evalCondition(expr, triggerUnit)
    local source = ("return (" .. normalizeConditionExpr(expr)) .. ")"
    local loadFn = _G.loadstring
    local setfenvFn = _G.setfenv
    if type(loadFn) ~= "function" or type(setfenvFn) ~= "function" then
        return false
    end
    local fn = loadFn(source)
    if fn == nil then
        return false
    end
    local env = createEvalEnv(triggerUnit)
    setfenvFn(fn, env)
    local ok = pcall(nil, fn)
    if ok[0] ~= true then
        return false
    end
    return ok[1] == true
end
local function executeActionCode(code, triggerUnit)
    local loadFn = _G.loadstring
    local setfenvFn = _G.setfenv
    if type(loadFn) ~= "function" or type(setfenvFn) ~= "function" then
        return
    end
    local chunk = loadFn(code)
    if chunk == nil then
        debugLog(nil, "主线配置驱动", "action编译失败:", code)
        return
    end
    local env = createEvalEnv(triggerUnit)
    setfenvFn(chunk, env)
    local ok = pcall(nil, chunk)
    if ok[0] ~= true then
        debugLog(
            nil,
            "主线配置驱动",
            "action执行失败:",
            code,
            "| err=" .. tostring(ok[1])
        )
    end
end
local storyActionCtxByTimerHid = {}
local function onStoryActionTimerExpire()
    local t = jass.GetExpiredTimer()
    if not t then
        return
    end
    local hid = jass.GetHandleId(t)
    local ctx = storyActionCtxByTimerHid[hid]
    __TS__Delete(storyActionCtxByTimerHid, hid)
    safeDestroyTimer(nil, t)
    if ctx then
        executeActionCode(ctx.code, ctx.triggerUnit)
    end
end
local function runActionTimeline(timeline, triggerUnit)
    local entries = parseTimelineEntries(timeline)
    for ____, e in ipairs(entries) do
        do
            if e.delay <= 0 then
                executeActionCode(e.code, triggerUnit)
                goto __continue66
            end
            local t = jass.CreateTimer()
            if t then
                storyActionCtxByTimerHid[jass.GetHandleId(t)] = {code = e.code, triggerUnit = triggerUnit}
                safeTimerStart(
                    nil,
                    t,
                    e.delay,
                    false,
                    onStoryActionTimerExpire
                )
            end
        end
        ::__continue66::
    end
end
local function getHeroes()
    local ____temp_15
    if type(YDGet) == "function" then
        ____temp_15 = YDGet("string", "玩家英雄", "单位组", "group")
    else
        ____temp_15 = nil
    end
    local group = ____temp_15
    if not group then
        return {}
    end
    local arr = {}
    forEachUnitInGroup(
        nil,
        group,
        function(u)
            if u then
                arr[#arr + 1] = u
            end
        end
    )
    return arr
end
local function hitFromStage(cfg, stage)
    if cfg.fromStage == nil or cfg.fromStage == "*" then
        return true
    end
    return __TS__Number(cfg.fromStage) == stage
end
local function tick()
    if running then
        return
    end
    running = true
    local stage = getStage()
    local heroes = getHeroes()
    for ____, cfg in ipairs(MAIN_STORY_QUEST_CONFIGS) do
        do
            if cfg.enabled == false then
                goto __continue78
            end
            if not cfg.condition or cfg.condition == "" then
                goto __continue78
            end
            if not hitFromStage(cfg, stage) then
                goto __continue78
            end
            local matchedHero = nil
            for ____, hero in ipairs(heroes) do
                if evalCondition(cfg.condition, hero) then
                    matchedHero = hero
                    break
                end
            end
            if not matchedHero then
                goto __continue78
            end
            local triggerUnit = matchedHero
            if type(cfg.toStage) == "number" then
                setStage(cfg.toStage)
            end
            runActionTimeline(cfg.actionTimeline, triggerUnit)
            playDialog(cfg.dialogPreview)
            refreshQuestUI(cfg.questDescText, cfg.questMsgText)
            break
        end
        ::__continue78::
    end
    running = false
end
local function extractFunctionNames(text)
    local names = {}
    local n = #text
    local i = 0
    while i < n do
        do
            local ch = __TS__StringCharCodeAt(text, i)
            local isStart = ch >= 65 and ch <= 90 or ch >= 97 and ch <= 122 or ch == 95
            if not isStart then
                i = i + 1
                goto __continue89
            end
            local start = i
            i = i + 1
            while i < n do
                local c = __TS__StringCharCodeAt(text, i)
                local ok = c >= 65 and c <= 90 or c >= 97 and c <= 122 or c >= 48 and c <= 57 or c == 95
                if not ok then
                    break
                end
                i = i + 1
            end
            local j = i
            while j < n and (__TS__StringCharAt(text, j) == " " or __TS__StringCharAt(text, j) == "\t") do
                j = j + 1
            end
            if j < n and __TS__StringCharAt(text, j) == "(" then
                names[#names + 1] = __TS__StringSubstring(text, start, i)
            end
        end
        ::__continue89::
    end
    return names
end
local function isKnownFunction(name)
    local gAny = _G
    if type(gAny[name]) == "function" then
        return true
    end
    if type(jass[name]) == "function" then
        return true
    end
    return false
end
local function reportMissingFunctions()
    local missCond = __TS__New(Set)
    local missAction = __TS__New(Set)
    for ____, cfg in ipairs(MAIN_STORY_QUEST_CONFIGS) do
        local cond = cfg.condition or ""
        local act = cfg.actionTimeline or ""
        for ____, fn in ipairs(extractFunctionNames(cond)) do
            if not isKnownFunction(fn) then
                missCond:add(fn)
            end
        end
        for ____, fn in ipairs(extractFunctionNames(act)) do
            if not isKnownFunction(fn) then
                missAction:add(fn)
            end
        end
    end
    _G.__mainQuestMissingReport = {
        condition = __TS__ArraySort(__TS__ArrayFrom(missCond)),
        actionTimeline = __TS__ArraySort(__TS__ArrayFrom(missAction))
    }
    debugLog(
        nil,
        "主线配置驱动",
        "缺失函数统计 - condition:",
        tostring(_G.__mainQuestMissingReport.condition.length)
    )
    debugLog(
        nil,
        "主线配置驱动",
        "缺失函数统计 - actionTimeline:",
        tostring(_G.__mainQuestMissingReport.actionTimeline.length)
    )
end
local function init()
    if not ____exports.ENABLE_MAIN_QUEST_CONFIG_DRIVER then
        return
    end
    ensureRuntimeQuest()
    reportMissingFunctions()
    if mainQuestTickRegistered then
        return
    end
    mainQuestTickRegistered = true
    addPeriodicCallback(nil, 300, tick)
end
if ____exports.ENABLE_MAIN_QUEST_CONFIG_DRIVER then
    init()
end
return ____exports
