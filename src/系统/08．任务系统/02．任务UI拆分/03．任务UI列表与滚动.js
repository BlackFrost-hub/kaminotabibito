const { clampMin, clampRange } = require("lib.扩展函数.封装函数.01．通用工具.index");
import { LIST_ITEM_H, LIST_VIEW_H, LIST_CONTENT_TOP_INSET, } from "./01．任务UI常量";
import { pcallDzFrameShow } from "./02．任务UI辅助";
// ========== 虚拟分区：行高计算与总高度 ==========
export function getQuestItemHeight(quest, expanded) {
    if (!expanded)
        return LIST_ITEM_H * 0.4;
    let h = LIST_ITEM_H + quest.objectives.length * 0.03 + (quest.timeLimit && quest.timeLimit > 0 ? 0.02 : 0);
    if (quest.description && quest.description !== "")
        h += 0.025;
    let rewardDesc = "";
    if (quest.rewards && quest.rewards.length > 0) {
        const descs = [];
        for (const r of quest.rewards) {
            if (r.description && r.description !== "")
                descs.push(r.description);
        }
        if (descs.length > 0) {
            rewardDesc = descs[0];
            for (let i = 1; i < descs.length; i++)
                rewardDesc += "、" + descs[i];
        }
    }
    if (rewardDesc !== "")
        h += 0.025;
    if (quest.accepterName || quest.completerName)
        h += 0.025;
    return h;
}
export function calcTotalContentHeight(quests, isExpanded) {
    let totalH = 0;
    for (let i = 0; i < quests.length; i++) {
        const q = quests[i];
        if (!q)
            continue;
        totalH += getQuestItemHeight(q, isExpanded(q.id)) + 0.01;
    }
    return totalH;
}
export function getMaxScroll(totalContentHeight) {
    return clampMin(totalContentHeight - LIST_VIEW_H, 0);
}
export function clampScrollOffset(scrollOffset, maxScroll) {
    return clampRange(scrollOffset, 0, maxScroll);
}
// ========== 虚拟分区：可视裁剪 ==========
export function isQuestRowFullyInsideView(rowTopRel, itemHeight, visibleTopRel, visibleBottomRel, eps) {
    const itemTopRel = rowTopRel;
    const itemBottomRel = rowTopRel - itemHeight;
    return itemTopRel <= visibleTopRel + eps && itemBottomRel >= visibleBottomRel - eps;
}
// ========== 虚拟分区：父链判定 ==========
export function isDescendantOf(japi, frame, ancestor) {
    if (!frame || frame === 0 || !ancestor || ancestor === 0)
        return false;
    let cur = frame;
    for (let i = 0; i < 64; i++) {
        if (cur === ancestor)
            return true;
        const p = japi.DzFrameGetParent(cur);
        if (!p || p === 0)
            return false;
        cur = p;
    }
    return false;
}
// ========== 虚拟分区：滚轮目标判定 ==========
export function isWheelTargetForTaskList(japi, getMouseFocus, listContainer, scrollBarFrame, scrollThumbFrame, scrollThumbHitBtn) {
    const f = typeof getMouseFocus === "function" ? getMouseFocus() : 0;
    if (!f || f === 0)
        return false;
    if (listContainer && (f === listContainer || isDescendantOf(japi, f, listContainer)))
        return true;
    if (scrollBarFrame && (f === scrollBarFrame || isDescendantOf(japi, f, scrollBarFrame)))
        return true;
    if (scrollThumbFrame && (f === scrollThumbFrame || isDescendantOf(japi, f, scrollThumbFrame)))
        return true;
    if (scrollThumbHitBtn && (f === scrollThumbHitBtn || isDescendantOf(japi, f, scrollThumbHitBtn)))
        return true;
    return false;
}
/** 分页滑块 thumb / 透明命中键（及子帧）：供全局鼠标拖拽判定（不含整条轨道） */
export function isTaskScrollThumbDragHit(japi, getMouseFocus, scrollThumbFrame, scrollThumbHitBtn) {
    const f = typeof getMouseFocus === "function" ? getMouseFocus() : 0;
    if (!f || f === 0)
        return false;
    if (scrollThumbHitBtn && (f === scrollThumbHitBtn || isDescendantOf(japi, f, scrollThumbHitBtn)))
        return true;
    if (scrollThumbFrame && (f === scrollThumbFrame || isDescendantOf(japi, f, scrollThumbFrame)))
        return true;
    return false;
}
export function isTaskScrollBarTrackHit(japi, getMouseFocus, scrollBarFrame, scrollThumbFrame, scrollThumbHitBtn) {
    const f = typeof getMouseFocus === "function" ? getMouseFocus() : 0;
    if (!f || f === 0)
        return false;
    if (!scrollBarFrame || scrollBarFrame === 0)
        return false;
    if (!(f === scrollBarFrame || isDescendantOf(japi, f, scrollBarFrame)))
        return false;
    if (scrollThumbHitBtn && (f === scrollThumbHitBtn || isDescendantOf(japi, f, scrollThumbHitBtn)))
        return false;
    if (scrollThumbFrame && (f === scrollThumbFrame || isDescendantOf(japi, f, scrollThumbFrame)))
        return false;
    return true;
}
// ========== 虚拟分区：滚动条显隐 ==========
/**
 * 滚动条显隐：内容不足一屏时 maxScroll 为 0，但仍应显示轨道与滑块（滑块贴顶/不可用），否则用户以为滚动条坏了。
 * 仅当当前分类下没有任何任务行（空列表占位）时隐藏。
 */
export function updateScrollBarVisibility(japi, maxScroll, frames, hasQuestRows) {
    const vis = hasQuestRows;
    for (const f of frames) {
        if (f && f !== 0)
            pcallDzFrameShow(f, vis);
    }
}
export function calcVisibleQuestRows(quests, scrollOffset, isExpanded) {
    const visibleRows = [];
    const visibleTopRel = LIST_CONTENT_TOP_INSET;
    const visibleBottomRel = LIST_CONTENT_TOP_INSET - LIST_VIEW_H;
    const EPS = 0.002;
    let rowTopRel = LIST_CONTENT_TOP_INSET + scrollOffset;
    for (let i = 0; i < quests.length; i++) {
        const q = quests[i];
        if (!q)
            continue;
        const expanded = isExpanded(q.id);
        const itemHeight = getQuestItemHeight(q, expanded);
        const fullyInside = isQuestRowFullyInsideView(rowTopRel, itemHeight, visibleTopRel, visibleBottomRel, EPS);
        if (fullyInside) {
            visibleRows.push({
                quest: q,
                expanded,
                rowTopRel,
                itemHeight,
            });
        }
        rowTopRel -= itemHeight + 0.01;
    }
    return visibleRows;
}
