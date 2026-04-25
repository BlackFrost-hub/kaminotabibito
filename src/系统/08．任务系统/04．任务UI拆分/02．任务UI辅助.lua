local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
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
function ____exports.dzGetLocalPlayer(self)
    return jass.GetLocalPlayer()
end
function ____exports.dzPlayer(self, index)
    return jass.Player(index)
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
    local f = 0
    local ok = pcall(function ()
            f = japi.DzCreateFrame(name, parent, contextId)
        end
    )
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
        function() return nil end,
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
                goto __continue29
            end
            if __TS__ArraySome(
                active,
                function(____, q) return q.id == id end
            ) then
                goto __continue29
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
        ::__continue29::
    end
    return result
end
____exports.EMPTY_TEXTS = {[QuestType.MAIN] = "暂无主线任务", [QuestType.SIDE] = "暂无支线任务", [QuestType.DAILY] = "暂无小任务"}
return ____exports
