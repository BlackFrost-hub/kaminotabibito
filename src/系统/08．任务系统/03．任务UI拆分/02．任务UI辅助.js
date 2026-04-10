import { TASK_UI_TOC_LOAD_KEY, TASK_UI_TOC_PATHS, ENABLE_FDF_A, ENABLE_FDF_B, ENABLE_FDF_SCROLLBAR, ENABLE_FDF_SCROLLBAR_BORDER, ENABLE_FDF_SCROLLBAR_THUMB, } from "./01．任务UI常量";
import { loadTocOnce } from "../../09．表现系统/01．UI工具/index";
import { questManager } from "../02．任务管理器";
import { questDB, QuestType, QuestStatus } from "../01．任务数据";
const jass = require("jass.common");
const japi = require("jass.japi");
export function dzGetLocalPlayer() {
    return typeof jass.GetLocalPlayer === "function" ? jass.GetLocalPlayer() : null;
}
export function dzPlayer(index) {
    return typeof jass.Player === "function" ? jass.Player(index) : null;
}
export function questIdTailInRange01to20(id, prefix) {
    if (id.length !== prefix.length + 3)
        return false;
    if (id.substring(0, prefix.length) !== prefix)
        return false;
    const tail = id.substring(prefix.length);
    if (tail.length !== 3)
        return false;
    return tail >= "001" && tail <= "020";
}
export function isQuestWithRowIconLayout(quest) {
    if (quest.icon && quest.icon !== "")
        return true;
    const id = quest.id;
    if (quest.type === QuestType.MAIN)
        return questIdTailInRange01to20(id, "main_");
    if (quest.type === QuestType.SIDE)
        return questIdTailInRange01to20(id, "side_");
    if (quest.type === QuestType.DAILY)
        return questIdTailInRange01to20(id, "daily_");
    return false;
}
export function isFdfFrameEnabled(frameName) {
    const isA = frameName === "TaskEntryIcon" || frameName === "TaskMainPanel" || frameName === "TaskListContainer";
    const isB = frameName === "TaskTabMain" ||
        frameName === "TaskTabSide" ||
        frameName === "TaskTabDaily" ||
        frameName === "TaskButtonBackdrop" ||
        frameName === "TaskTabMainBg" ||
        frameName === "TaskTabSideBg" ||
        frameName === "TaskTabDailyBg";
    if (frameName === "TaskScrollBar")
        return ENABLE_FDF_SCROLLBAR;
    if (frameName === "TaskScrollBarBorder")
        return ENABLE_FDF_SCROLLBAR_BORDER;
    if (frameName === "TaskScrollThumb")
        return ENABLE_FDF_SCROLLBAR_THUMB;
    if (isA)
        return ENABLE_FDF_A;
    if (isB)
        return ENABLE_FDF_B;
    return false;
}
export function tryCreateFromFdfWithSource(name, parent, fallback) {
    if (!isFdfFrameEnabled(name))
        return { frame: fallback(), fromFdf: false };
    loadTocOnce(TASK_UI_TOC_LOAD_KEY, TASK_UI_TOC_PATHS, "TaskUI");
    if (typeof japi.DzCreateFrame !== "function")
        return { frame: fallback(), fromFdf: false };
    let f = 0;
    const ok = pcall(() => {
        f = japi.DzCreateFrame(name, parent, 0);
    });
    if (ok && f != null && f !== 0)
        return { frame: f, fromFdf: true };
    return { frame: fallback(), fromFdf: false };
}
export function tryCreateFromFdfOnly(name, parent) {
    const res = tryCreateFromFdfWithSource(name, parent, () => null);
    if (res.fromFdf && res.frame && res.frame !== 0)
        return res.frame;
    return null;
}
export function getStatusText(status) {
    const m = {
        [QuestStatus.IN_PROGRESS]: "|cff00ff66进行中|r",
        [QuestStatus.COMPLETED]: "|cffc0c0c0已完成|r",
        [QuestStatus.FAILED]: "|cffff5555已失败|r",
        [QuestStatus.DISCOVERED]: "|cff66ccff已发现|r",
        [QuestStatus.UNDISCOVERED]: "|cff888888未发现|r",
    };
    return m[status] || status;
}
export function getQuestsForUI(playerId, type) {
    const active = questManager.getPlayerQuests(playerId, type).filter(q => !q.uiReserved);
    const completedIds = questDB.getPlayerCompletedQuests(playerId);
    const result = active.slice();
    for (const id of completedIds) {
        const template = questDB.getQuest(id);
        if (!template || template.type !== type || template.uiReserved)
            continue;
        if (active.some(q => q.id === id))
            continue;
        result.push({
            ...template,
            status: QuestStatus.COMPLETED,
            objectives: template.objectives.map(o => ({ ...o, completed: true, current: o.required })),
        });
    }
    return result;
}
export const EMPTY_TEXTS = {
    [QuestType.MAIN]: "暂无主线任务",
    [QuestType.SIDE]: "暂无支线任务",
    [QuestType.DAILY]: "暂无小任务",
};
