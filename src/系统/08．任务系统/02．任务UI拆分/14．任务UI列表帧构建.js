import { LIST_CONTAINER_W, LIST_VIEW_H } from "./01．任务UI常量";
import { tryCreateFromFdfOnly } from "./02．任务UI辅助";
import { createEmptyQuestIdList } from "./10．任务UI列表控制辅助";
const japi = require("jass.japi");
const PAGE_ROOT_HEIGHT = LIST_VIEW_H;
// ========== 虚拟分区：帧工厂（隐藏根/文本/背景/按钮）+ 清理 ==========
export function createHiddenRoot(ctx, name, parent, width = LIST_CONTAINER_W, height = PAGE_ROOT_HEIGHT) {
    const frame = ctx.createFrame({
        type: "FRAME",
        name,
        parent,
        template: "template",
        visible: false,
        id: ctx.contextId,
    }) || 0;
    if (!frame)
        return null;
    ctx.setFramePointRelative(frame, ctx.FramePoint.TOPLEFT, parent, ctx.FramePoint.TOPLEFT, 0, 0);
    ctx.setFrameSize(frame, { width, height });
    return frame;
}
export function createHiddenText(ctx, name, parent, width, height) {
    const frame = ctx.createTextLabel(name, parent, "", {
        relativeTo: parent,
        point: ctx.FramePoint.TOPLEFT,
        relativePoint: ctx.FramePoint.TOPLEFT,
        x: 0,
        y: 0,
    }, { width, height }) || 0;
    if (!frame)
        return null;
    japi.DzFrameShow(frame, false);
    return frame;
}
export function createHiddenBackdrop(ctx, templateName, frameName, parent, texture, contextId) {
    let frame = tryCreateFromFdfOnly(templateName, parent, contextId ?? ctx.contextId) || 0;
    if (!frame) {
        frame =
            ctx.createFrame({
                type: ctx.FrameType.BACKDROP,
                name: frameName,
                parent,
                template: "template",
                visible: false,
                id: ctx.contextId,
            }) || 0;
        if (frame && texture) {
            ctx.setFrameTexture(frame, texture);
        }
    }
    return frame || null;
}
export function createPlainHiddenBackdrop(ctx, name, parent) {
    const frame = ctx.createFrame({
        type: ctx.FrameType.BACKDROP,
        name,
        parent,
        template: "template",
        visible: false,
        id: ctx.contextId,
    }) || 0;
    return frame || null;
}
export function createHiddenButton(ctx, name, parent, onClick) {
    const frame = ctx.createFrame({
        type: ctx.FrameType.GLUETEXTBUTTON,
        name,
        parent,
        template: "template",
        visible: false,
        enable: true,
        alpha: 0,
        id: ctx.contextId,
    }) || 0;
    if (!frame)
        return null;
    ctx.setFrameClickEvent(frame, onClick, true);
    return frame;
}
function hideFrames(frames, setVisible) {
    for (const frame of frames)
        setVisible(frame, false);
}
export function hideRowSlot(slot, setVisible) {
    hideFrames([slot.backdrop, slot.title, slot.clickBtn, slot.icon, slot.failFrame], setVisible);
    hideFrames(slot.objectiveFrames, setVisible);
    hideFrames(slot.detailFrames, setVisible);
}
export function clearVariant(variant, setVisible) {
    for (const slot of variant.rowSlots)
        hideRowSlot(slot, setVisible);
}
export function clearPage(page, setVisible) {
    page.questIds = createEmptyQuestIdList();
    for (const variant of page.variants) {
        clearVariant(variant, setVisible);
        setVisible(variant.root, false);
    }
    setVisible(page.root, false);
}
