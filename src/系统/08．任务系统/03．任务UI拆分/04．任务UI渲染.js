import { LIST_ITEM_H, LIST_CONTAINER_W, LIST_CONTENT_LEFT_INSET, QUEST_ROW_ICON_HEIGHT_FACTOR, QUEST_ROW_ICON_PAD_LEFT, QUEST_ROW_TEXT_GAP_AFTER_ICON, QUEST_ROW_ICON_Y_OFFSET, BG_TEX, } from "./01．任务UI常量";
import { DZ_TEXT_ALIGN_CENTER, DZ_TEXT_ALIGN_LEFT } from "../../00．核心系统/06．UI函数";
import { getStatusText, isQuestWithRowIconLayout, tryCreateFromFdfOnly } from "./02．任务UI辅助";
import { getQuestItemHeight } from "./03．任务UI列表与滚动";
export function calcTaskListItemLayout(showMainRowIcon) {
    const rowWidth = LIST_CONTAINER_W * 0.9;
    const rowLeftRel = LIST_CONTENT_LEFT_INSET;
    const collapsedMainRowH = LIST_ITEM_H * 0.4;
    const iconHLayout = showMainRowIcon ? collapsedMainRowH * QUEST_ROW_ICON_HEIGHT_FACTOR : 0;
    const textXRel = showMainRowIcon
        ? rowLeftRel + QUEST_ROW_ICON_PAD_LEFT + iconHLayout + QUEST_ROW_TEXT_GAP_AFTER_ICON
        : rowLeftRel + 0.03;
    const listTextAlign = showMainRowIcon ? DZ_TEXT_ALIGN_LEFT : DZ_TEXT_ALIGN_CENTER;
    const rowTitleRightInset = 0.01;
    const textW = rowWidth - (textXRel - rowLeftRel) - rowTitleRightInset;
    return {
        rowWidth,
        rowLeftRel,
        iconHLayout,
        textXRel,
        listTextAlign,
        textW,
    };
}
export function resolveQuestRowIconPath(icon) {
    if (icon && icon !== "")
        return icon;
    return "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp";
}
// ────────────────────────────────────────────────
// 展开内容渲染
// ────────────────────────────────────────────────
const EXPANDED_OBJECTIVE_START_OFFSET = LIST_ITEM_H * 0.35;
const EXPANDED_OBJECTIVE_ROW_HEIGHT = LIST_ITEM_H * 0.25;
const EXPANDED_FAIL_ROW_HEIGHT = LIST_ITEM_H * 0.2;
const EXPANDED_DETAIL_ROW_HEIGHT = LIST_ITEM_H * 0.22;
const detailFrameByQuestId = new Map();
function getOrCreateDetailFrame(questId, index, listParent, text, textXRel, yRel, textW, FramePoint, createTextLabel, setFramePointRelative, setFrameSize, applyDzTextFontAndAlignment, showFrame, japi, listItemFrames) {
    const key = questId + "|" + index;
    let frames = detailFrameByQuestId.get(questId);
    let fr = 0;
    if (frames && frames.length > index) {
        fr = frames[index] || 0;
    }
    if (fr === 0) {
        fr =
            createTextLabel("TaskDetail_" + key, listParent, text, {
                relativeTo: listParent,
                point: FramePoint.TOPLEFT,
                relativePoint: FramePoint.TOPLEFT,
                x: textXRel,
                y: yRel,
            }, { width: textW, height: EXPANDED_DETAIL_ROW_HEIGHT }) || 0;
        if (fr !== 0) {
            if (!frames) {
                frames = [];
                detailFrameByQuestId.set(questId, frames);
            }
            while (frames.length <= index)
                frames.push(0);
            frames[index] = fr;
        }
    }
    else {
        setFramePointRelative(fr, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, textXRel, yRel);
        setFrameSize(fr, { width: textW, height: EXPANDED_DETAIL_ROW_HEIGHT });
        if (typeof japi.DzFrameSetText === "function")
            japi.DzFrameSetText(fr, text);
    }
    if (fr !== 0) {
        applyDzTextFontAndAlignment(fr, DZ_TEXT_ALIGN_LEFT);
        if (typeof japi.DzFrameSetLevel === "function")
            japi.DzFrameSetLevel(fr, 3);
        showFrame(fr);
        listItemFrames.push(fr);
    }
    return fr;
}
function buildObjectiveText(completed, description, current, required) {
    const mark = completed ? "|cffffcc00√|r" : "|cffffcc00×|r";
    return mark + " " + description + " (" + current + "/" + required + ")";
}
function buildFailText(timeLimit) {
    return "|cffff4444失败:|r 时间限制 " + timeLimit + "秒";
}
export function renderExpandedQuestDetails(opts) {
    const { japi, quest, listParent, rowTopRel, textXRel, textW, listTextAlign, FramePoint, createTextLabel, setFramePointRelative, setFrameSize, applyDzTextFontAndAlignment, showFrame, objFrameByKey, failFrameByQuestId, listItemFrames, } = opts;
    let objYRel = rowTopRel - EXPANDED_OBJECTIVE_START_OFFSET;
    for (const obj of quest.objectives) {
        const txt = buildObjectiveText(obj.completed, obj.description, obj.current, obj.required);
        const objKey = quest.id + "|" + obj.id;
        let objFrame = objFrameByKey.get(objKey) || 0;
        if (objFrame === 0) {
            objFrame =
                createTextLabel("TaskObj_" + quest.id + "_" + obj.id, listParent, txt, {
                    relativeTo: listParent,
                    point: FramePoint.TOPLEFT,
                    relativePoint: FramePoint.TOPLEFT,
                    x: textXRel,
                    y: objYRel,
                }, { width: textW, height: EXPANDED_OBJECTIVE_ROW_HEIGHT }) || 0;
            if (objFrame === 0) {
                objYRel -= EXPANDED_OBJECTIVE_ROW_HEIGHT;
                continue;
            }
            objFrameByKey.set(objKey, objFrame);
        }
        else {
            setFramePointRelative(objFrame, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, textXRel, objYRel);
            setFrameSize(objFrame, { width: textW, height: EXPANDED_OBJECTIVE_ROW_HEIGHT });
            if (typeof japi.DzFrameSetText === "function")
                japi.DzFrameSetText(objFrame, txt);
        }
        applyDzTextFontAndAlignment(objFrame, listTextAlign);
        if (typeof japi.DzFrameSetLevel === "function")
            japi.DzFrameSetLevel(objFrame, 3);
        showFrame(objFrame);
        listItemFrames.push(objFrame);
        objYRel -= EXPANDED_OBJECTIVE_ROW_HEIGHT;
    }
    if (quest.timeLimit && quest.timeLimit > 0) {
        let failFrame = failFrameByQuestId.get(quest.id) || 0;
        const failText = buildFailText(quest.timeLimit);
        if (failFrame === 0) {
            failFrame =
                createTextLabel("TaskFail_" + quest.id, listParent, failText, {
                    relativeTo: listParent,
                    point: FramePoint.TOPLEFT,
                    relativePoint: FramePoint.TOPLEFT,
                    x: textXRel,
                    y: objYRel,
                }, { width: textW, height: EXPANDED_FAIL_ROW_HEIGHT }) || 0;
            if (failFrame === 0)
                return false;
            failFrameByQuestId.set(quest.id, failFrame);
        }
        else {
            setFramePointRelative(failFrame, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, textXRel, objYRel);
            setFrameSize(failFrame, { width: textW, height: EXPANDED_FAIL_ROW_HEIGHT });
            if (typeof japi.DzFrameSetText === "function")
                japi.DzFrameSetText(failFrame, failText);
        }
        applyDzTextFontAndAlignment(failFrame, listTextAlign);
        if (typeof japi.DzFrameSetLevel === "function")
            japi.DzFrameSetLevel(failFrame, 3);
        showFrame(failFrame);
        listItemFrames.push(failFrame);
        objYRel -= EXPANDED_FAIL_ROW_HEIGHT;
    }
    let detailIdx = 0;
    if (quest.description && quest.description !== "") {
        getOrCreateDetailFrame(quest.id, detailIdx, listParent, "|cffcccccc任务详情：|r" + quest.description, textXRel, objYRel, textW, FramePoint, createTextLabel, setFramePointRelative, setFrameSize, applyDzTextFontAndAlignment, showFrame, japi, listItemFrames);
        detailIdx++;
        objYRel -= EXPANDED_DETAIL_ROW_HEIGHT;
    }
    const rewardDesc = quest.rewards && quest.rewards.length > 0
        ? quest.rewards.map(r => r.description).filter(d => d && d !== "").join("、")
        : "";
    if (rewardDesc !== "") {
        getOrCreateDetailFrame(quest.id, detailIdx, listParent, "|cffff9900任务奖励：|r|cffffcc00" + rewardDesc + "|r", textXRel, objYRel, textW, FramePoint, createTextLabel, setFramePointRelative, setFrameSize, applyDzTextFontAndAlignment, showFrame, japi, listItemFrames);
        detailIdx++;
        objYRel -= EXPANDED_DETAIL_ROW_HEIGHT;
    }
    const accepter = quest.accepterName;
    const completer = quest.completerName;
    if (accepter || completer) {
        let infoLine = "";
        if (accepter)
            infoLine += "接受者:|cff00ccff『" + accepter + "』|r";
        if (accepter && completer)
            infoLine += "|";
        if (completer)
            infoLine += "完成者:|cff00ff66『" + completer + "』|r";
        getOrCreateDetailFrame(quest.id, detailIdx, listParent, infoLine, textXRel, objYRel, textW, FramePoint, createTextLabel, setFramePointRelative, setFrameSize, applyDzTextFontAndAlignment, showFrame, japi, listItemFrames);
        detailIdx++;
        objYRel -= EXPANDED_DETAIL_ROW_HEIGHT;
    }
    return true;
}
// ────────────────────────────────────────────────
// 行渲染入口
// ────────────────────────────────────────────────
export function renderQuestRow(opts) {
    const { japi, quest, rowTopRel, expanded, listParent, FrameType, FramePoint, createFrame, createTextLabel, setFrameTexture, setFramePointRelative, setFrameSize, setFrameClickEvent, showFrame, applyDzTextFontAndAlignment, onToggleExpand, onClickSound, rowBackdropByQuestId, titleByQuestId, clickBtnByQuestId, objFrameByKey, failFrameByQuestId, rowIconByQuestId, listItemFrames, } = opts;
    const itemH = getQuestItemHeight(quest, expanded);
    const statusText = getStatusText(quest.status);
    const showMainRowIcon = isQuestWithRowIconLayout(quest);
    const { rowWidth, rowLeftRel, iconHLayout, textXRel, listTextAlign, textW } = calcTaskListItemLayout(showMainRowIcon);
    let rowBackdrop = rowBackdropByQuestId.get(quest.id) || 0;
    if (rowBackdrop === 0) {
        rowBackdrop = tryCreateFromFdfOnly("TaskButtonBackdrop", listParent) || 0;
        if (rowBackdrop === 0) {
            const bgFrame = createFrame({
                type: FrameType.BACKDROP,
                name: "TaskItemBg_" + quest.id,
                parent: listParent,
                template: "template",
                visible: true,
            }) || 0;
            rowBackdrop = bgFrame || 0;
            if (rowBackdrop !== 0)
                setFrameTexture(rowBackdrop, BG_TEX);
        }
        if (rowBackdrop !== 0)
            rowBackdropByQuestId.set(quest.id, rowBackdrop);
    }
    if (rowBackdrop === 0)
        return false;
    setFramePointRelative(rowBackdrop, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, rowLeftRel, rowTopRel);
    setFrameSize(rowBackdrop, { width: rowWidth, height: itemH });
    if (typeof japi.DzFrameSetLevel === "function")
        japi.DzFrameSetLevel(rowBackdrop, 1);
    showFrame(rowBackdrop);
    listItemFrames.push(rowBackdrop);
    const npcName = quest.startNpc || "未知";
    const titleText = "|cffffff00『" + quest.title + "』|r→发布NPC:|cff00ccff『" + npcName + "』|r [" + statusText + "]";
    let titleFrame = titleByQuestId.get(quest.id) || 0;
    if (titleFrame === 0) {
        titleFrame =
            createTextLabel("TaskItem_" + quest.id, listParent, titleText, {
                relativeTo: listParent,
                point: FramePoint.TOPLEFT,
                relativePoint: FramePoint.TOPLEFT,
                x: textXRel,
                y: rowTopRel - 0.005,
            }, { width: textW, height: LIST_ITEM_H * 0.38 }) || 0;
        if (titleFrame === 0)
            return false;
        titleByQuestId.set(quest.id, titleFrame);
    }
    else {
        setFramePointRelative(titleFrame, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, textXRel, rowTopRel - 0.005);
        setFrameSize(titleFrame, { width: textW, height: LIST_ITEM_H * 0.38 });
        if (typeof japi.DzFrameSetText === "function")
            japi.DzFrameSetText(titleFrame, titleText);
    }
    applyDzTextFontAndAlignment(titleFrame, listTextAlign);
    if (typeof japi.DzFrameSetLevel === "function")
        japi.DzFrameSetLevel(titleFrame, 3);
    showFrame(titleFrame);
    listItemFrames.push(titleFrame);
    let clickBtn = clickBtnByQuestId.get(quest.id) || 0;
    if (clickBtn === 0) {
        clickBtn =
            createFrame({
                type: FrameType.GLUETEXTBUTTON,
                name: "TaskItemClick_" + quest.id,
                parent: listParent,
                template: "template",
                visible: true,
                enable: true,
                alpha: 0,
            }) || 0;
        if (clickBtn === 0)
            return false;
        clickBtnByQuestId.set(quest.id, clickBtn);
    }
    setFramePointRelative(clickBtn, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, rowLeftRel, rowTopRel);
    setFrameSize(clickBtn, { width: rowWidth, height: itemH });
    setFrameClickEvent(clickBtn, () => {
        onClickSound();
        onToggleExpand(quest.id);
    }, false);
    if (typeof japi.DzFrameSetLevel === "function")
        japi.DzFrameSetLevel(clickBtn, 4);
    showFrame(clickBtn);
    listItemFrames.push(clickBtn);
    if (showMainRowIcon) {
        const iconPath = resolveQuestRowIconPath(quest.icon);
        let iconFr = rowIconByQuestId.get(quest.id) || 0;
        if (iconFr === 0) {
            iconFr =
                createFrame({
                    type: FrameType.BACKDROP,
                    name: "TaskQuestRowIcon_" + quest.id,
                    parent: listParent,
                    template: "template",
                    visible: true,
                }) || 0;
            if (iconFr !== 0) {
                setFrameTexture(iconFr, iconPath);
                rowIconByQuestId.set(quest.id, iconFr);
            }
        }
        else {
            setFrameTexture(iconFr, iconPath);
        }
        if (iconFr !== 0) {
            const iconH = iconHLayout;
            const iconW = iconH;
            setFramePointRelative(iconFr, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, rowLeftRel + QUEST_ROW_ICON_PAD_LEFT, rowTopRel - QUEST_ROW_ICON_Y_OFFSET);
            setFrameSize(iconFr, { width: iconW, height: iconH });
            if (typeof japi.DzFrameSetLevel === "function")
                japi.DzFrameSetLevel(iconFr, 5);
            showFrame(iconFr);
            listItemFrames.push(iconFr);
        }
    }
    if (expanded) {
        const ok = renderExpandedQuestDetails({
            japi,
            quest,
            listParent,
            rowTopRel,
            textXRel,
            textW,
            listTextAlign,
            FramePoint,
            createTextLabel,
            setFramePointRelative,
            setFrameSize,
            applyDzTextFontAndAlignment,
            showFrame,
            objFrameByKey,
            failFrameByQuestId,
            listItemFrames,
        });
        if (!ok)
            return false;
    }
    return true;
}
