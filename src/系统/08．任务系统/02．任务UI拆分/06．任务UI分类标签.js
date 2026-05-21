/**
 * 主面板顶部分类标签（主线 / 支线 / 小任务）
 *
 * 架构：N 槽分类标签；每个 slot 独立创建，sync=true 回调再按触发玩家路由。
 */
const jass = require("jass.common");
const japi = require("jass.japi");
import { QuestType } from "../01．任务数据";
import { TAB_REL_Y, TAB_FRAME_W, TAB_FRAME_H, TAB_CATEGORY_FONT_SCALE } from "./01．任务UI常量";
import { tryCreateFromFdfOnly, pcallDzFrameShow, pcallDzFrameSetAlpha } from "./02．任务UI辅助";
/** 用 Record 固定三类槽位，避免 Map 弱序/迭代习惯 */
// ========== 虚拟分区：三个分类标签（主线/支线/小任务） ==========
const categoryTabClickHandlers = {};
// 当前悬停提示消息（避免匿名闭包）
const tabTooltipByFrameId = {};
function handleCategoryTabClick(category) {
    const handler = categoryTabClickHandlers[category];
    if (!handler)
        return;
    const onSwitchCategory = handler.onSwitchCategory;
    onSwitchCategory(category);
    const triggerPlayer = japi.DzGetTriggerKeyPlayer();
    if (triggerPlayer === jass.GetLocalPlayer()) {
        const onClickSound = handler.onClickSound;
        onClickSound();
    }
}
// 命名函数替代匿名闭包 - 分类标签点击
function onMainTabClick() { handleCategoryTabClick(QuestType.MAIN); }
function onSideTabClick() { handleCategoryTabClick(QuestType.SIDE); }
function onDailyTabClick() { handleCategoryTabClick(QuestType.DAILY); }
// 命名函数替代匿名闭包 - 悬停提示
function onTabHoverShow() {
    let frame = japi.DzGetTriggerUIEventFrame?.() ?? 0;
    if (!frame)
        frame = japi.DzGetMouseFocus?.() ?? 0;
    const entry = frame ? tabTooltipByFrameId[frame] : undefined;
    if (!entry || !entry.handler || entry.msg === "")
        return;
    entry.handler(entry.msg);
}
function onTabHoverHide() { }
const tabClickHandlers = {
    [QuestType.MAIN]: onMainTabClick,
    [QuestType.SIDE]: onSideTabClick,
    [QuestType.DAILY]: onDailyTabClick,
};
function registerCategoryTabClickHandler(category, onSwitchCategory, onClickSound) {
    categoryTabClickHandlers[category] = { onSwitchCategory, onClickSound };
}
function createTaskTab(opts) {
    const { japi, tabParent, bgName, tabName, labelName, x, labelText, category, tooltip, FramePoint, setFramePointRelative, setFrameSize, setFrameHoverEvents, setFrameClickEvent, setButtonText, createTabLabelTextOnBackdrop, setupTransparentGlueHitLayer, onClickSound, onSwitchCategory, onShowTabTooltip, contextId, nameSuffix, } = opts;
    const bg = tryCreateFromFdfOnly(bgName, tabParent, contextId);
    if (bg) {
        japi.DzFrameClearAllPoints(bg);
        setFramePointRelative(bg, FramePoint.TOPLEFT, tabParent, FramePoint.TOPLEFT, x, TAB_REL_Y);
        setFrameSize(bg, { width: TAB_FRAME_W, height: TAB_FRAME_H });
        pcallDzFrameShow(bg, true);
    }
    if (bg) {
        createTabLabelTextOnBackdrop(bg, labelName + nameSuffix, labelText, TAB_CATEGORY_FONT_SCALE);
    }
    const tab = tryCreateFromFdfOnly(tabName, tabParent, contextId);
    if (tab) {
        japi.DzFrameClearAllPoints(tab);
        if (bg) {
            setupTransparentGlueHitLayer(bg, tab);
        }
        else {
            setFramePointRelative(tab, FramePoint.TOPLEFT, tabParent, FramePoint.TOPLEFT, x, TAB_REL_Y);
            setFrameSize(tab, { width: TAB_FRAME_W, height: TAB_FRAME_H });
        }
        pcallDzFrameShow(tab, true);
        if (!bg) {
            setButtonText(tab, "");
            pcallDzFrameSetAlpha(tab, 0);
        }
        registerCategoryTabClickHandler(category, onSwitchCategory, onClickSound);
        tabTooltipByFrameId[tab] = { msg: tooltip, handler: onShowTabTooltip };
        setFrameClickEvent(tab, tabClickHandlers[category], true);
        setFrameHoverEvents(tab, onTabHoverShow, onTabHoverHide, false);
    }
    return { bg, tab };
}
export function buildTaskPanelCategoryTabs(opts) {
    const { japi, tabParent, FramePoint, setFramePointRelative, setFrameSize, setFrameHoverEvents, setFrameClickEvent, setButtonText, createTabLabelTextOnBackdrop, setupTransparentGlueHitLayer, onClickSound, onSwitchCategory, onShowTabTooltip, slotId, contextId, } = opts;
    const nameSuffix = `_s${slotId}`;
    const common = {
        japi,
        tabParent,
        FramePoint,
        setFramePointRelative,
        setFrameSize,
        setFrameHoverEvents,
        setFrameClickEvent,
        setButtonText,
        createTabLabelTextOnBackdrop,
        setupTransparentGlueHitLayer,
        onClickSound,
        onSwitchCategory,
        onShowTabTooltip,
        contextId,
        nameSuffix,
    };
    const mainResult = createTaskTab({
        ...common,
        bgName: "TaskTabMainBg",
        tabName: "TaskTabMain",
        labelName: "TaskTabMainLabel",
        x: 0.02,
        labelText: "|cffffcc00主线(1)|r",
        category: QuestType.MAIN,
        tooltip: "切换到主线任务",
    });
    const sideResult = createTaskTab({
        ...common,
        bgName: "TaskTabSideBg",
        tabName: "TaskTabSide",
        labelName: "TaskTabSideLabel",
        x: 0.135,
        labelText: "|cffffcc00支线(2)|r",
        category: QuestType.SIDE,
        tooltip: "切换到支线任务",
    });
    const dailyResult = createTaskTab({
        ...common,
        bgName: "TaskTabDailyBg",
        tabName: "TaskTabDaily",
        labelName: "TaskTabDailyLabel",
        x: 0.25,
        labelText: "|cffffcc00小任务(3)|r",
        category: QuestType.DAILY,
        tooltip: "切换到小任务",
    });
    return {
        tabMainBg: mainResult.bg,
        tabMain: mainResult.tab,
        tabSideBg: sideResult.bg,
        tabSide: sideResult.tab,
        tabDailyBg: dailyResult.bg,
        tabDaily: dailyResult.tab,
    };
}
