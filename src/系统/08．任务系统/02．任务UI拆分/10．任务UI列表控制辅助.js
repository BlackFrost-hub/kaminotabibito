import { QuestType } from "../01．任务数据";
// ========== 虚拟分区：分页/版本/文案构建 ==========
export const ROWS_PER_PAGE = 7;
/** 相邻页在任务列表上错开的行数（原 3，改为 2 则每次翻页少滑一行） */
export const ROWS_PER_SCROLL_STEP = 1;
export const PAGE_VARIANT_COUNT = ROWS_PER_PAGE + 1;
export function questTypes() {
    return [QuestType.MAIN, QuestType.SIDE, QuestType.DAILY];
}
export function createEmptyQuestIdList() {
    const questIds = [];
    for (let i = 0; i < ROWS_PER_PAGE; i++)
        questIds.push("");
    return questIds;
}
export function buildObjectiveText(quest, index) {
    const obj = quest.objectives[index];
    if (!obj)
        return "";
    const mark = obj.completed ? "|cffffcc00鈭�|r" : "|cffffcc00脳|r";
    return mark + " " + obj.description + " (" + obj.current + "/" + obj.required + ")";
}
export function buildRewardText(quest) {
    if (!quest.rewards || quest.rewards.length <= 0)
        return "";
    const descs = [];
    for (const r of quest.rewards) {
        if (r.description && r.description !== "")
            descs.push(r.description);
    }
    if (descs.length === 0)
        return "";
    let rewardDesc = descs[0];
    for (let i = 1; i < descs.length; i++)
        rewardDesc += "、" + descs[i];
    return "|cffff9900任务奖励：|r|cffffcc00" + rewardDesc + "|r";
}
export function buildInfoText(quest) {
    const accepter = quest.accepterName;
    const completer = quest.completerName;
    if (!accepter && !completer)
        return "";
    let text = "";
    if (accepter)
        text += "接受者：|cff00ccff【" + accepter + "】|r";
    if (accepter && completer)
        text += "|";
    if (completer)
        text += "完成者：|cff00ff66【" + completer + "】|r";
    return text;
}
export function chunkQuests(quests) {
    const pages = [];
    if (quests.length <= ROWS_PER_PAGE) {
        if (quests.length > 0)
            pages.push(quests.slice(0, ROWS_PER_PAGE));
        return pages;
    }
    for (let i = 0; i < quests.length; i += ROWS_PER_SCROLL_STEP) {
        const end = i + ROWS_PER_PAGE;
        if (end >= quests.length) {
            const startIndex = quests.length - ROWS_PER_PAGE;
            pages.push(quests.slice(startIndex > 0 ? startIndex : 0, quests.length));
            break;
        }
        pages.push(quests.slice(i, end));
    }
    return pages;
}
export function findExpandedVariantIndex(page, expandedQuestId) {
    if (!expandedQuestId)
        return 0;
    for (let i = 0; i < page.questIds.length; i++) {
        if (page.questIds[i] === expandedQuestId)
            return i + 1;
    }
    return 0;
}
export function hideAllCategoryPages(categoryView, setVisible) {
    setVisible(categoryView.emptyText, false);
    for (const page of categoryView.pages) {
        for (const variant of page.variants) {
            setVisible(variant.root, false);
        }
        setVisible(page.root, false);
    }
}
export function showOnlyPageAndVariant(categoryView, pageIndex, variantIndex, setVisible) {
    for (let i = 0; i < categoryView.pages.length; i++) {
        const page = categoryView.pages[i];
        const isCurrentPage = i === pageIndex;
        setVisible(page.root, isCurrentPage);
        for (let v = 0; v < page.variants.length; v++) {
            setVisible(page.variants[v].root, isCurrentPage && v === variantIndex);
        }
    }
}
