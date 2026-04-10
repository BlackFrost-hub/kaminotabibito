local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringCharCodeAt = ____lualib.__TS__StringCharCodeAt
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local __TS__ArrayFrom = ____lualib.__TS__ArrayFrom
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.08．任务系统.00．配置表.06．主线任务配置表")
local MAIN_STORY_QUEST_CONFIGS = ____require_result_0.MAIN_STORY_QUEST_CONFIGS
local ____require_result_1 = require("系统.08．任务系统.01．任务数据")
local questDB = ____require_result_1.questDB
local QuestType = ____require_result_1.QuestType
local QuestStatus = ____require_result_1.QuestStatus
local ____require_result_2 = require("系统.08．任务系统.02．任务管理器")
local questManager = ____require_result_2.questManager
local YDGet = _G.YDUserDataGet
local YDSet = _G.YDUserDataSet
local RUNTIME_QUEST_ID = "main_story_runtime"
local running = false
local function getStage(self)
    if type(YDGet) == "function" then
        return __TS__Number(YDGet(
            nil,
            "string",
            "剧情进度",
            "整数",
            "integer"
        )) or 0
    end
    return 0
end
local function setStage(self, v)
    if type(YDSet) == "function" then
        YDSet(
            nil,
            "string",
            "剧情进度",
            "整数",
            "integer",
            v
        )
    end
end
local function ensureRuntimeQuest(self)
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
local function refreshQuestUI(self, desc, msg)
    local ____opt_5 = questDB.globalData
    if ____opt_5 ~= nil then
        ____opt_5 = ____opt_5.quests
    end
    local ____opt_result_7
    if ____opt_5 ~= nil then
        ____opt_result_7 = ____opt_5:get(RUNTIME_QUEST_ID)
    end
    local q = ____opt_result_7
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
    if type(msg) == "string" and msg ~= "" and type(jass.QuestMessageBJ) == "function" and type(jass.GetPlayersAll) == "function" then
        jass.QuestMessageBJ(
            jass.GetPlayersAll(),
            jass.bj_QUESTMESSAGE_UPDATED,
            msg
        )
    end
end
local function parseDialogLines(self, dialogPreview)
    if not dialogPreview then
        return {}
    end
    local out = {}
    local rows = __TS__StringSplit(dialogPreview, "\n")
    for ____, raw in ipairs(rows) do
        do
            local __continue15
            repeat
                local line = __TS__StringTrim(raw)
                if line == "" then
                    __continue15 = true
                    break
                end
                local dot = (string.find(line, ".", nil, true) or 0) - 1
                if dot <= 0 then
                    __continue15 = true
                    break
                end
                local left = __TS__StringTrim(__TS__StringSubstring(line, 0, dot))
                if left == "" or __TS__Number(left) <= 0 then
                    __continue15 = true
                    break
                end
                local body = __TS__StringTrim(__TS__StringSubstring(line, dot + 1))
                local sep = (string.find(body, "：", nil, true) or 0) - 1
                if sep < 0 then
                    sep = (string.find(body, ":", nil, true) or 0) - 1
                end
                if sep <= 0 then
                    __continue15 = true
                    break
                end
                local speaker = __TS__StringTrim(__TS__StringSubstring(body, 0, sep))
                local text = __TS__StringTrim(__TS__StringSubstring(body, sep + 1))
                if speaker == "" or text == "" then
                    __continue15 = true
                    break
                end
                out[#out + 1] = {speaker = speaker, text = text}
                __continue15 = true
            until true
            if not __continue15 then
                break
            end
        end
    end
    return out
end
local function calcDialogDuration(self, text)
    local n = #text
    local t = 1 + math.floor(n / 6)
    if t < 2 then
        return 2
    end
    if t > 12 then
        return 12
    end
    return t
end
local function playDialog(self, dialogPreview)
    if type(jass.TransmissionFromUnitWithNameBJ) ~= "function" or type(jass.GetPlayersAll) ~= "function" then
        return
    end
    local lines = parseDialogLines(nil, dialogPreview)
    for ____, line in ipairs(lines) do
        jass.TransmissionFromUnitWithNameBJ(
            jass.GetPlayersAll(),
            nil,
            line.speaker,
            nil,
            line.text,
            jass.bj_TIMETYPE_SET,
            calcDialogDuration(nil, line.text),
            true
        )
    end
end
local function removeInlineBlockComments(self, s)
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
local function sanitizeActionCode(self, raw)
    local s = __TS__StringTrim(removeInlineBlockComments(nil, raw))
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
local function parseTimelineEntries(self, timeline)
    if not timeline then
        return {}
    end
    local out = {}
    local lines = __TS__StringSplit(timeline, "\n")
    for ____, raw in ipairs(lines) do
        do
            local __continue41
            repeat
                local line = __TS__StringTrim(raw)
                if line == "" then
                    __continue41 = true
                    break
                end
                local dot = (string.find(line, ".", nil, true) or 0) - 1
                if dot <= 0 then
                    __continue41 = true
                    break
                end
                local left = __TS__StringTrim(__TS__StringSubstring(line, 0, dot))
                local delay = __TS__Number(left)
                if delay ~= delay then
                    __continue41 = true
                    break
                end
                local code = sanitizeActionCode(
                    nil,
                    __TS__StringSubstring(line, dot + 1)
                )
                if code == "" then
                    __continue41 = true
                    break
                end
                out[#out + 1] = {delay = delay, code = code}
                __continue41 = true
            until true
            if not __continue41 then
                break
            end
        end
    end
    return out
end
local function createEvalEnv(self, triggerUnit)
    local gAny = _G
    local function local1GetFallback(____, ty, key)
        if type(gAny.YDLocal1Get) == "function" then
            return gAny:YDLocal1Get(ty, key)
        end
        if ty == "location" and key == "单位位置" and triggerUnit and type(jass.GetUnitLoc) == "function" then
            return jass.GetUnitLoc(triggerUnit)
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
local function normalizeConditionExpr(self, expr)
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
local function evalCondition(self, expr, triggerUnit)
    local source = ("return (" .. normalizeConditionExpr(nil, expr)) .. ")"
    local loadFn = _G.loadstring
    local setfenvFn = _G.setfenv
    if type(loadFn) ~= "function" or type(setfenvFn) ~= "function" then
        return false
    end
    local fn = loadFn(nil, source)
    if fn == nil then
        return false
    end
    local env = createEvalEnv(nil, triggerUnit)
    setfenvFn(nil, fn, env)
    local ok = pcall(nil, fn)
    if ok[0] ~= true then
        return false
    end
    return ok[1] == true
end
local function executeActionCode(self, code, triggerUnit)
    local loadFn = _G.loadstring
    local setfenvFn = _G.setfenv
    if type(loadFn) ~= "function" or type(setfenvFn) ~= "function" then
        return
    end
    local chunk = loadFn(nil, code)
    if chunk == nil then
        local p = _G.print
        if type(p) == "function" then
            p(nil, "[主线配置驱动] action编译失败: " .. code)
        end
        return
    end
    local env = createEvalEnv(nil, triggerUnit)
    setfenvFn(nil, chunk, env)
    local ok = pcall(nil, chunk)
    if ok[0] ~= true then
        local p = _G.print
        if type(p) == "function" then
            p(
                nil,
                (("[主线配置驱动] action执行失败: " .. code) .. " | err=") .. tostring(ok[1])
            )
        end
    end
end
local function runActionTimeline(self, timeline, triggerUnit)
    local entries = parseTimelineEntries(nil, timeline)
    for ____, e in ipairs(entries) do
        do
            local __continue65
            repeat
                if e.delay <= 0 or type(jass.CreateTimer) ~= "function" or type(jass.TimerStart) ~= "function" then
                    executeActionCode(nil, e.code, triggerUnit)
                    __continue65 = true
                    break
                end
                local t = jass.CreateTimer()
                jass.TimerStart(
                    t,
                    e.delay,
                    false,
                    function()
                        executeActionCode(nil, e.code, triggerUnit)
                        if type(jass.DestroyTimer) == "function" then
                            jass.DestroyTimer(t)
                        end
                    end
                )
                __continue65 = true
            until true
            if not __continue65 then
                break
            end
        end
    end
end
local function getHeroes(self)
    local ____temp_8
    if type(YDGet) == "function" then
        ____temp_8 = YDGet(
            nil,
            "string",
            "玩家英雄",
            "单位组",
            "group"
        )
    else
        ____temp_8 = nil
    end
    local group = ____temp_8
    if not group or type(jass.FirstOfGroup) ~= "function" or type(jass.GroupRemoveUnit) ~= "function" or type(jass.GroupAddUnit) ~= "function" then
        return {}
    end
    local arr = {}
    local temp = {}
    while true do
        local u = jass.FirstOfGroup(group)
        if not u then
            break
        end
        arr[#arr + 1] = u
        temp[#temp + 1] = u
        jass.GroupRemoveUnit(group, u)
    end
    for ____, u in ipairs(temp) do
        jass.GroupAddUnit(group, u)
    end
    return arr
end
local function hitFromStage(self, cfg, stage)
    if cfg.fromStage == nil or cfg.fromStage == "*" then
        return true
    end
    return __TS__Number(cfg.fromStage) == stage
end
local function tick(self)
    if running then
        return
    end
    running = true
    local stage = getStage(nil)
    local heroes = getHeroes(nil)
    for ____, cfg in ipairs(MAIN_STORY_QUEST_CONFIGS) do
        do
            local __continue80
            repeat
                if cfg.enabled == false then
                    __continue80 = true
                    break
                end
                if not cfg.condition or cfg.condition == "" then
                    __continue80 = true
                    break
                end
                if not hitFromStage(nil, cfg, stage) then
                    __continue80 = true
                    break
                end
                local matched = false
                for ____, hero in ipairs(heroes) do
                    if evalCondition(nil, cfg.condition, hero) then
                        matched = true
                        break
                    end
                end
                if not matched then
                    __continue80 = true
                    break
                end
                local ____temp_9
                if #heroes > 0 then
                    ____temp_9 = heroes[1]
                else
                    ____temp_9 = nil
                end
                local triggerUnit = ____temp_9
                if type(cfg.toStage) == "number" then
                    setStage(nil, cfg.toStage)
                end
                runActionTimeline(nil, cfg.actionTimeline, triggerUnit)
                playDialog(nil, cfg.dialogPreview)
                refreshQuestUI(nil, cfg.questDescText, cfg.questMsgText)
                break
            until true
            if not __continue80 then
                break
            end
        end
    end
    running = false
end
local function extractFunctionNames(self, text)
    local names = {}
    local n = #text
    local i = 0
    while i < n do
        do
            local __continue91
            repeat
                local ch = __TS__StringCharCodeAt(text, i)
                local isStart = ch >= 65 and ch <= 90 or ch >= 97 and ch <= 122 or ch == 95
                if not isStart then
                    i = i + 1
                    __continue91 = true
                    break
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
                __continue91 = true
            until true
            if not __continue91 then
                break
            end
        end
    end
    return names
end
local function isKnownFunction(self, name)
    local gAny = _G
    if type(gAny[name]) == "function" then
        return true
    end
    if type(jass[name]) == "function" then
        return true
    end
    return false
end
local function reportMissingFunctions(self)
    local missCond = __TS__New(Set)
    local missAction = __TS__New(Set)
    for ____, cfg in ipairs(MAIN_STORY_QUEST_CONFIGS) do
        local cond = cfg.condition or ""
        local act = cfg.actionTimeline or ""
        for ____, fn in ipairs(extractFunctionNames(nil, cond)) do
            if not isKnownFunction(nil, fn) then
                missCond:add(fn)
            end
        end
        for ____, fn in ipairs(extractFunctionNames(nil, act)) do
            if not isKnownFunction(nil, fn) then
                missAction:add(fn)
            end
        end
    end
    _G.__mainQuestMissingReport = {
        condition = __TS__ArraySort(__TS__ArrayFrom(missCond)),
        actionTimeline = __TS__ArraySort(__TS__ArrayFrom(missAction))
    }
    local p = _G.print
    if type(p) == "function" then
        p(
            nil,
            "[主线配置驱动] 缺失函数统计 - condition: " .. tostring(_G.__mainQuestMissingReport.condition.length)
        )
        p(
            nil,
            "[主线配置驱动] 缺失函数统计 - actionTimeline: " .. tostring(_G.__mainQuestMissingReport.actionTimeline.length)
        )
    end
end
local function init(self)
    ensureRuntimeQuest(nil)
    reportMissingFunctions(nil)
    if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" then
        local t = jass.CreateTimer()
        jass.TimerStart(t, 0.3, true, tick)
    end
end
init(nil)
return ____exports
