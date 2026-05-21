/**
 * 全图通用 UI 辅助（DzAPI / Frame）。
 *
 * **联机与 desync**
 * - 本文件内均为 **本地帧操作**（`DzFrameSetFont` / `DzFrameSetTextAlignment` / `DzFrameSetParent` 等），**不**经网络同步。
 * - 需要注册 **点击/滚轮** 时，**强烈建议都用 `sync=true`**，但必须严格遵守以下规则：
 *   - ✅ **按钮帧必须在所有玩家上创建**（不能在本地玩家判断内创建）
 *   - ✅ **回调必须在所有玩家上注册**（不能在本地玩家判断内注册）
 *   - ✅ **回调必须是全局函数**（不能是匿名闭包，闭包会导致 desync！）
 *   - ✅ **回调内部严格区分操作类型**：
 *     - 全局同步操作（游戏状态修改等）：必须在本地玩家判断之外执行
 *     - 异步操作（UI 操作、音效等）：必须在本地玩家判断之内执行
 *     - ⚠️ 不可以互相混淆！非常严格！
 * - 勿用会走 `ExecuteFunc` 的 `DzFrameSetScript` 同步字符串去驱动 Lua 逻辑。
 * - 若 UI 回调里要 **发同步数据**，应走项目既有 **Sync** 封装，勿在帧回调里直接改游戏状态而不同步。
 *
 * 详细避坑经验见 `.cursor/rules/dzapi/ui-frame-types.mdc`。
 */
const japi = require("jass.japi");
const jass = require("jass.common");
import { createFrame, setButtonText, FrameType } from "../09．表现系统/01．UI工具/index";
import { displayText, displayQuest, isDialogActive, setDialogFinishCallback } from "../09．表现系统/02．对话框系统/00．对话框渲染核心";
import { destroyBubbleEffect, releaseNpcOccupation, removeQuestMarkerAfterNpcTriggered, scheduleBubbleEffectAfterOverheadClear, scheduleGrayQuestMarkerAfterBubbleFade, scheduleYellowQuestMarkerAfterBubbleFade, setDialogNpcUnit, shouldSkipNewBubbleSchedule, tryOccupyNpc, } from "../09．表现系统/02．对话框系统/09．NPC头顶与气泡特效";
/**
 * 通用 NPC 对话框入口。
 * - 若该玩家对话框正在播放（`isDialogActive(p) === true`），直接返回，不重复展开。
 * - 若该玩家对话框空闲（`isDialogActive(p) === false`），按 data 顺序入队播放。
 * - 文本数据由调用方传入，函数本身不硬编码任何内容。
 * - 每个玩家状态独立，互不影响。
 * - 如果NPC已被其他玩家占用，直接返回 false。
 * @returns 成功开始对话返回 true，否则返回 false
 */
export function openNpcDialog(p, data) {
    // 该玩家对话进行中时，禁止开启新对话（必须走完当前完整流程）
    if (isDialogActive(p))
        return false;
    // NPC 占用互斥：同一时刻仅允许一个玩家与同一 NPC 对话
    if (data.npcUnit) {
        if (!tryOccupyNpc(p, data.npcUnit))
            return false;
        setDialogNpcUnit(p, data.npcUnit);
        const removedOverheadMarker = removeQuestMarkerAfterNpcTriggered(data.npcUnit);
        const pid = jass.GetPlayerId(p);
        /** 必须用配置位而非「本地是否拆掉过叹号」：各客户端本地头顶表可能不一致，会导致 qipao 分支不同 → desync */
        const waitQipaoAfterOverheadClear = data.removeOverheadMarkerOnOpen === true;
        if (!shouldSkipNewBubbleSchedule(pid, data.npcUnit)) {
            scheduleBubbleEffectAfterOverheadClear(pid, data.npcUnit, waitQipaoAfterOverheadClear);
        }
        setDialogFinishCallback(p, () => {
            // 对话完整结束后释放占用与气泡
            const pid = jass.GetPlayerId(p);
            releaseNpcOccupation(pid);
            destroyBubbleEffect(pid);
            if (data.applyGrayQuestMarkerAfterDialog === true && data.npcUnit) {
                scheduleGrayQuestMarkerAfterBubbleFade(data.npcUnit);
            }
            if (data.restoreYellowQuestMarkerAfterDialog === true && data.npcUnit) {
                scheduleYellowQuestMarkerAfterBubbleFade(data.npcUnit);
            }
        });
    }
    for (const line of data.lines) {
        displayText(p, line.title, line.text, line.duration);
    }
    if (data.quest) {
        const q = data.quest;
        displayQuest(p, q.title, q.text, q.onAccept, q.onReject, q.acceptText, q.rejectText);
    }
    return true;
}
/** `DzFrameSetTextAlignment`：改对齐前重置，避免叠加 */
export const DZ_TEXT_ALIGN_RESET = -1;
/** 居中 */
export const DZ_TEXT_ALIGN_CENTER = 18;
/** 左对齐 */
export const DZ_TEXT_ALIGN_LEFT = 2;
export const DEFAULT_UI_FONT_FILE = "UI\\uizt.ttf";
export const DEFAULT_UI_FONT_FLAG = 0;
/** 列表/入口等默认字号（`DzFrameSetFont` 第三参） */
export const DEFAULT_UI_FONT_SCALE = 0.016;
/**
 * 设置字体与文本对齐；`fontScale` 省略则用 `DEFAULT_UI_FONT_SCALE`。
 */
export function applyDzTextFontAndAlignment(frame, textAlignment, fontScale, fontFile = DEFAULT_UI_FONT_FILE, fontFlag = DEFAULT_UI_FONT_FLAG) {
    if (!frame || frame === 0)
        return;
    const scale = fontScale !== undefined && fontScale !== null ? fontScale : DEFAULT_UI_FONT_SCALE;
    // DzFrameSetFont 和 DzFrameSetTextAlignment 都会导致多人游戏不同步
    japi.DzFrameSetFont(frame, fontFile, scale, fontFlag);
    japi.DzFrameSetTextAlignment(frame, DZ_TEXT_ALIGN_RESET);
    japi.DzFrameSetTextAlignment(frame, textAlignment);
}
export function applyDzTextFontAndCenterAlignment(frame, fontScale, fontFile = DEFAULT_UI_FONT_FILE, fontFlag = DEFAULT_UI_FONT_FLAG) {
    applyDzTextFontAndAlignment(frame, DZ_TEXT_ALIGN_CENTER, fontScale, fontFile, fontFlag);
}
/**
 * `TEXT` 子帧与 `BACKDROP` 同大（`SetAllPoints(text, backdrop)`），便于对齐相对整块底图。
 */
export function createTextFrameFillBackdrop(backdrop, name, text) {
    if (!backdrop || backdrop === 0)
        return null;
    const tf = createFrame({
        type: FrameType.TEXT,
        name,
        parent: backdrop,
        template: "template",
        visible: true,
    });
    if (!tf || tf === 0)
        return null;
    pcall(() => japi.DzFrameClearAllPoints(tf));
    pcall(() => japi.DzFrameSetAllPoints(tf, backdrop));
    japi.DzFrameSetText(tf, text);
    return tf;
}
/**
 * Tab 标签：`TEXT` 铺满背景 + 居中 + 指定 Tab 字号。
 */
export function createTabLabelTextOnBackdrop(backdrop, name, text, tabLabelFontScale, fontFile = DEFAULT_UI_FONT_FILE, fontFlag = DEFAULT_UI_FONT_FLAG) {
    const tf = createTextFrameFillBackdrop(backdrop, name, text);
    if (!tf)
        return null;
    applyDzTextFontAndAlignment(tf, DZ_TEXT_ALIGN_CENTER, tabLabelFontScale, fontFile, fontFlag);
    return tf;
}
/**
 * `GLUETEXTBUTTON` 作点击层：挂到 `backdrop` 下、`SetAllPoints` 铺满。
 */
export function layoutGlueTextButtonOverBackdrop(backdrop, button) {
    if (!backdrop || backdrop === 0 || !button || button === 0)
        return;
    pcall(() => japi.DzFrameSetParent(button, backdrop));
    pcall(() => japi.DzFrameClearAllPoints(button));
    pcall(() => japi.DzFrameSetAllPoints(button, backdrop));
}
/**
 * 透明命中层：铺满背景后清空按钮字并 `alpha=0`（文案由同背景的 `TEXT` 负责）。
 */
export function setupTransparentGlueHitLayer(backdrop, button) {
    layoutGlueTextButtonOverBackdrop(backdrop, button);
    setButtonText(button, "");
    pcall(() => japi.DzFrameSetAlpha(button, 0));
}
