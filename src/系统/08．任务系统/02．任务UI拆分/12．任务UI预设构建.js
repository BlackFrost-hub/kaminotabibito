import { QuestType } from "../01．任务数据";
import { taskRowClickHandlersByIndex, taskRowBindingByFrameId, } from "./08．任务UI列表控制";
import { LIST_VIEW_H, LIST_CONTAINER_W, MAX_PAGES_PER_CATEGORY, BG_TEX, } from "./01．任务UI常量";
import { createHiddenRoot, createHiddenText, createHiddenBackdrop, createPlainHiddenBackdrop, createHiddenButton, } from "./14．任务UI列表帧构建";
import { ROWS_PER_PAGE, PAGE_VARIANT_COUNT, createEmptyQuestIdList, } from "./10．任务UI列表控制辅助";
const PAGE_ROOT_HEIGHT = LIST_VIEW_H;
const LIST_ITEM_H = LIST_VIEW_H * 0.14;
const TITLE_HEIGHT = LIST_ITEM_H * 0.38;
const OBJECTIVE_HEIGHT = LIST_ITEM_H * 0.25;
const FAIL_HEIGHT = LIST_ITEM_H * 0.2;
const DETAIL_HEIGHT = LIST_ITEM_H * 0.22;
// ========== 虚拟分区：分类/页/变体/行槽位预创建 ==========
function createRowSlot(ctx, parent, prefix, rowIndex, onClick) {
    const objectiveFrames = [];
    const detailFrames = [];
    const backdrop = createHiddenBackdrop(ctx, "TaskButtonBackdrop", prefix + "_Backdrop_" + rowIndex, parent, BG_TEX, rowIndex + 1) || 0;
    const icon = createPlainHiddenBackdrop(ctx, prefix + "_Icon_" + rowIndex, parent) || 0;
    const title = createHiddenText(ctx, prefix + "_Title_" + rowIndex, parent, LIST_CONTAINER_W * 0.9, TITLE_HEIGHT) || 0;
    const clickBtn = createHiddenButton(ctx, prefix + "_Click_" + rowIndex, parent, onClick) || 0;
    for (let i = 0; i < 4; i++) {
        objectiveFrames.push(createHiddenText(ctx, prefix + "_Obj" + i, parent, LIST_CONTAINER_W * 0.9, OBJECTIVE_HEIGHT) || 0);
    }
    const failFrame = createHiddenText(ctx, prefix + "_Fail_" + rowIndex, parent, LIST_CONTAINER_W * 0.9, FAIL_HEIGHT) || 0;
    for (let i = 0; i < 6; i++) {
        detailFrames.push(createHiddenText(ctx, prefix + "_Det" + i, parent, LIST_CONTAINER_W * 0.9, DETAIL_HEIGHT) || 0);
    }
    return { backdrop, title, clickBtn, icon, objectiveFrames, failFrame, detailFrames };
}
function createVariant(ctx, page, category, pageIndex, variantIndex) {
    const root = createHiddenRoot(ctx, "TaskVariant_" + category + "_" + pageIndex + "_" + variantIndex, page.root, LIST_CONTAINER_W, PAGE_ROOT_HEIGHT);
    const rowSlots = [];
    const prefix = "TV" + category + "_" + pageIndex + "_" + variantIndex;
    for (let rowIndex = 0; rowIndex < ROWS_PER_PAGE; rowIndex++) {
        const slot = createRowSlot(ctx, root, prefix + "_R" + rowIndex, rowIndex, taskRowClickHandlersByIndex[rowIndex]);
        if (slot.clickBtn)
            taskRowBindingByFrameId[slot.clickBtn] = { page, rowIndex };
        rowSlots.push(slot);
    }
    return { root, rowSlots };
}
function createPage(ctx, categoryRoot, category, pageIndex) {
    const page = {
        root: createHiddenRoot(ctx, "TaskPage_" + category + "_" + pageIndex, categoryRoot),
        questIds: createEmptyQuestIdList(),
        variants: [],
    };
    for (let variantIndex = 0; variantIndex < PAGE_VARIANT_COUNT; variantIndex++) {
        page.variants.push(createVariant(ctx, page, category, pageIndex, variantIndex));
    }
    return page;
}
function createCategory(ctx, category) {
    const root = createHiddenRoot(ctx, "TaskCategory_" + category, ctx.listContainer);
    const emptyText = createHiddenText(ctx, "TaskEmpty_" + category, root, LIST_CONTAINER_W * 0.85, 0.08) || 0;
    if (emptyText !== 0) {
        ctx.applyDzTextFontAndCenterAlignment(emptyText);
    }
    const pages = [];
    for (let pageIndex = 0; pageIndex < MAX_PAGES_PER_CATEGORY; pageIndex++) {
        pages.push(createPage(ctx, root, category, pageIndex));
    }
    return { root, emptyText: emptyText || null, pageCount: 0, pages };
}
export function createTaskUIPrecreatedListPool(ctx) {
    if (!ctx.listContainer)
        return null;
    return {
        categories: {
            [QuestType.MAIN]: createCategory(ctx, QuestType.MAIN),
            [QuestType.SIDE]: createCategory(ctx, QuestType.SIDE),
            [QuestType.DAILY]: createCategory(ctx, QuestType.DAILY),
        },
    };
}
