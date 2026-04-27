local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringCharCodeAt = ____lualib.__TS__StringCharCodeAt
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local TASK_UI_TOC_LOAD_KEY = ____01_FF0E_4EFB_52A1UI_5E38_91CF.TASK_UI_TOC_LOAD_KEY
local TASK_UI_TOC_PATHS = ____01_FF0E_4EFB_52A1UI_5E38_91CF.TASK_UI_TOC_PATHS
local ENABLE_FDF_A = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_FDF_A
local ENABLE_FDF_B = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_FDF_B
local ENABLE_FDF_SCROLLBAR = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_FDF_SCROLLBAR
local ENABLE_FDF_SCROLLBAR_BORDER = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_FDF_SCROLLBAR_BORDER
local ENABLE_FDF_SCROLLBAR_THUMB = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_FDF_SCROLLBAR_THUMB
local ____index = require("系统.09．表现系统.01．UI工具.index")
local loadTocOnce = ____index.loadTocOnce
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local QuestStatus = ____01_FF0E_4EFB_52A1_6570_636E.QuestStatus
local jass = require("jass.common")
local japi = require("jass.japi")
local __dzPcallShowJapi = nil
local __dzPcallShowFrame = 0
local __dzPcallShowVis = false
local function __dzPcallFrameShowBody(self)
    __dzPcallShowJapi:DzFrameShow(__dzPcallShowFrame, __dzPcallShowVis)
end
function ____exports.pcallDzFrameShow(self, japiAny, frame, visible)
    if type(japiAny.DzFrameShow) ~= "function" then
        return
    end
    __dzPcallShowJapi = japiAny
    __dzPcallShowFrame = frame
    __dzPcallShowVis = visible
    pcall(__dzPcallFrameShowBody)
    __dzPcallShowJapi = nil
end
local __dzPcallAlphaVal = 0
local function __dzPcallFrameSetAlphaBody(self)
    __dzPcallShowJapi:DzFrameSetAlpha(__dzPcallShowFrame, __dzPcallAlphaVal)
end
function ____exports.pcallDzFrameSetAlpha(self, japiAny, frame, alpha)
    if type(japiAny.DzFrameSetAlpha) ~= "function" then
        return
    end
    __dzPcallShowJapi = japiAny
    __dzPcallShowFrame = frame
    __dzPcallAlphaVal = alpha
    pcall(__dzPcallFrameSetAlphaBody)
    __dzPcallShowJapi = nil
end
function ____exports.dzGetLocalPlayer(self)
    return jass:GetLocalPlayer()
end
function ____exports.dzPlayer(self, index)
    return jass:Player(index)
end
function ____exports.questIdTailInRange01to20(self, id, prefix)
    if #id ~= #prefix + 3 then
        return false
    end
    if __TS__StringSubstring(id, 0, #prefix) ~= prefix then
        return false
    end
    local tail = __TS__StringSubstring(id, #prefix)
    if #tail ~= 3 then
        return false
    end
    return tail >= "001" and tail <= "020"
end
function ____exports.isQuestWithRowIconLayout(self, quest)
    if quest.icon and quest.icon ~= "" then
        return true
    end
    local id = quest.id
    if quest.type == QuestType.MAIN then
        return ____exports.questIdTailInRange01to20(nil, id, "main_")
    end
    if quest.type == QuestType.SIDE then
        return ____exports.questIdTailInRange01to20(nil, id, "side_")
    end
    if quest.type == QuestType.DAILY then
        return ____exports.questIdTailInRange01to20(nil, id, "daily_")
    end
    return true
end
function ____exports.isFdfFrameEnabled(self, frameName)
    local isA = frameName == "TaskEntryIcon" or frameName == "TaskMainPanel" or frameName == "TaskListContainer"
    local isB = frameName == "TaskTabMain" or frameName == "TaskTabSide" or frameName == "TaskTabDaily" or frameName == "TaskButtonBackdrop" or frameName == "TaskTabMainBg" or frameName == "TaskTabSideBg" or frameName == "TaskTabDailyBg"
    if frameName == "TaskScrollBar" then
        return ENABLE_FDF_SCROLLBAR
    end
    if frameName == "TaskScrollBarBorder" then
        return ENABLE_FDF_SCROLLBAR_BORDER
    end
    if frameName == "TaskScrollThumb" then
        return ENABLE_FDF_SCROLLBAR_THUMB
    end
    if isA then
        return ENABLE_FDF_A
    end
    if isB then
        return ENABLE_FDF_B
    end
    return false
end
local function tryCreateFromFdfOnlyNullFallback(self)
    return nil
end
local __dzCreateName = ""
local __dzCreateParent = 0
local __dzCreateContextId = 0
local __dzCreateResultFrame = 0
local function __dzCreateFramePcallBody(self)
    __dzCreateResultFrame = japi:DzCreateFrame(__dzCreateName, __dzCreateParent, __dzCreateContextId)
end
function ____exports.tryCreateFromFdfWithSource(self, name, parent, fallback, contextId)
    if contextId == nil then
        contextId = 0
    end
    if not ____exports.isFdfFrameEnabled(nil, name) then
        return {
            frame = fallback(nil),
            fromFdf = false
        }
    end
    loadTocOnce(nil, TASK_UI_TOC_LOAD_KEY, TASK_UI_TOC_PATHS, "TaskUI")
    __dzCreateName = name
    __dzCreateParent = parent
    __dzCreateContextId = contextId
    local ok = pcall(__dzCreateFramePcallBody)
    local f = __dzCreateResultFrame
    if ok and f ~= nil and f ~= 0 then
        return {frame = f, fromFdf = true}
    end
    return {
        frame = fallback(nil),
        fromFdf = false
    }
end
function ____exports.tryCreateFromFdfOnly(self, name, parent, contextId)
    if contextId == nil then
        contextId = 0
    end
    local res = ____exports.tryCreateFromFdfWithSource(
        nil,
        name,
        parent,
        tryCreateFromFdfOnlyNullFallback,
        contextId
    )
    if res.fromFdf and res.frame and res.frame ~= 0 then
        return res.frame
    end
    return nil
end
function ____exports.getStatusText(self, status)
    local m = {
        [QuestStatus.IN_PROGRESS] = "|cff00ff66进行中|r",
        [QuestStatus.COMPLETED] = "|cffc0c0c0已完成|r",
        [QuestStatus.FAILED] = "|cffff5555已失败|r",
        [QuestStatus.DISCOVERED] = "|cff66ccff已发现|r",
        [QuestStatus.UNDISCOVERED] = "|cff888888未发现|r"
    }
    return m[status] or status
end
local function questIdTailIsAllDigits(self, s)
    if #s == 0 then
        return false
    end
    do
        local i = 0
        while i < #s do
            local c = __TS__StringCharCodeAt(s, i)
            if c < 48 or c > 57 then
                return false
            end
            i = i + 1
        end
    end
    return true
end
--- TSTL 无 `lastIndexOf`，手写从右找 `_`
local function lastUnderscoreIndex(self, s)
    do
        local i = #s - 1
        while i >= 0 do
            if __TS__StringCharAt(s, i) == "_" then
                return i
            end
            i = i - 1
        end
    end
    return -1
end
--- `foo_2` 与 `foo_10` 字典序会乱；同一「末段 `_` 前」前缀且尾为纯数字时按数值比，否则字典序
local function compareQuestIdForListOrder(self, aId, bId)
    local ua = lastUnderscoreIndex(nil, aId)
    local ub = lastUnderscoreIndex(nil, bId)
    if ua > 0 and ub > 0 then
        local preA = __TS__StringSubstring(aId, 0, ua + 1)
        local preB = __TS__StringSubstring(bId, 0, ub + 1)
        if preA == preB then
            local tailA = __TS__StringSubstring(aId, ua + 1)
            local tailB = __TS__StringSubstring(bId, ub + 1)
            if questIdTailIsAllDigits(nil, tailA) and questIdTailIsAllDigits(nil, tailB) then
                local na = __TS__ParseInt(tailA, 10)
                local nb = __TS__ParseInt(tailB, 10)
                if na ~= nb then
                    return na - nb
                end
            end
        end
    end
    if aId < bId then
        return -1
    end
    if aId > bId then
        return 1
    end
    return 0
end
function ____exports.getQuestsForUI(self, playerId, ____type)
    local active = __TS__ArrayFilter(
        questDB:getPlayerActiveQuests(playerId),
        function(____, q) return q.type == ____type and not q.uiReserved end
    )
    local completedIds = questDB:getPlayerCompletedQuests(playerId)
    local result = __TS__ArraySlice(active)
    for ____, id in ipairs(completedIds) do
        do
            local template = questDB:getQuest(id)
            if not template or template.type ~= ____type or template.uiReserved then
                goto __continue51
            end
            if __TS__ArraySome(
                active,
                function(____, q) return q.id == id end
            ) then
                goto __continue51
            end
            result[#result + 1] = __TS__ObjectAssign(
                {},
                template,
                {
                    status = QuestStatus.COMPLETED,
                    objectives = __TS__ArrayMap(
                        template.objectives,
                        function(____, o) return __TS__ObjectAssign({}, o, {completed = true, current = o.required}) end
                    )
                }
            )
        end
        ::__continue51::
    end
    __TS__ArraySort(
        result,
        function(____, a, b) return compareQuestIdForListOrder(nil, a.id, b.id) end
    )
    return result
end
____exports.EMPTY_TEXTS = {[QuestType.MAIN] = "暂无主线任务", [QuestType.SIDE] = "暂无支线任务", [QuestType.DAILY] = "暂无小任务"}
return ____exports
