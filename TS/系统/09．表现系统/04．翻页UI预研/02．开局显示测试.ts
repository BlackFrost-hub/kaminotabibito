const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const Frame工具 = require("lib.扩展函数.封装函数.04．硬件输入.index") as {
  frameSetScriptByCode: (this: void, frame: number, eventId: number, action: any, sync: boolean, playerId?: number) => void;
};

import {
  PAGE_TEST_CENTER_X,
  PAGE_TEST_CENTER_Y,
  PAGE_TEST_FLIP_DURATION,
  PAGE_TEST_HEIGHT,
  PAGE_TEST_HOTSPOT_HEIGHT,
  PAGE_TEST_HOTSPOT_WIDTH,
  PAGE_TEST_WIDTH,
} from "./00．常量定义";
import { PAGE_TEST_BASE_TEXTURE, PAGE_TEST_FLIP_TEXTURES, PAGE_TEST_INDICATOR_TEXTURE } from "./01．资源定义";

let pageBaseFrame: number | null = null;
let pageFlipFrames: number[] = [];
let pageIndicatorFrame: number | null = null;
let pageHotspotFrame: number | null = null;
let pageHotspotHintTextFrame: number | null = null;
let pageBodyTextFrame: number | null = null;
let pageTestInitDone = false;
let pageFlipTimer: any = null;
let pageFlipAnimating = false;
let pageFlipTargetPlayerId = -1;
let pageFlipFrameIndex = 0;
let pageBodyTextPageIndex = 0;
let pageBodyTextPendingPageIndex = 0;

const PAGE_BASE_PRIORITY = 0;
const PAGE_FLIP_PRIORITY_START = 1000;
const PAGE_INDICATOR_PRIORITY = 2000;
const PAGE_HOTSPOT_PRIORITY = 3000;
const PAGE_HOTSPOT_HINT_COLOR_R = 201;
const PAGE_HOTSPOT_HINT_COLOR_G = 160;
const PAGE_HOTSPOT_HINT_COLOR_B = 103;
const PAGE_HOTSPOT_HINT_COLOR_A = 255;
const PAGE_HOTSPOT_HINT_OFFSET_X = 0;
const PAGE_HOTSPOT_HINT_OFFSET_Y = 0;
const PAGE_HOTSPOT_HINT_TEXT = "点击右下角翻页";
const PAGE_BODY_TEXT_PAGE_1 = "这是第一页的正文测试文本。\n\n用于确认底座正文区域的排版位置是否正确。";
const PAGE_BODY_TEXT_PAGE_2 = "这是第二页的正文测试文本。\n\n翻页动画结束后，正文会切换到这一页的内容。";
const PAGE_BODY_TEXTS = [PAGE_BODY_TEXT_PAGE_1, PAGE_BODY_TEXT_PAGE_2];
const PAGE_BODY_TEXT_PRIORITY = 100;
const PAGE_BODY_TEXT_FONT = "UI\\uizt.ttf";
const PAGE_BODY_TEXT_FONT_SIZE = 0.0126;
// 正文测试层使用“相对底座左上角”定位：
// X 增大表示向右，Y 减小表示向下。
const PAGE_BODY_TEXT_WIDTH = 0.24;
const PAGE_BODY_TEXT_HEIGHT = 0.28;
const PAGE_BODY_TEXT_OFFSET_X = 0.052;
const PAGE_BODY_TEXT_OFFSET_Y = -0.085;
const PAGE_EVENT_MOUSE_CLICK = 1;
const PAGE_EVENT_MOUSE_ENTER = 2;
const PAGE_EVENT_MOUSE_LEAVE = 3;

function isLocalRenderTargetPlayer(): boolean {
  const localPlayer = jass.GetLocalPlayer();
  if (!localPlayer || localPlayer === 0) return false;
  return jass.GetPlayerId(localPlayer) === pageFlipTargetPlayerId;
}

function showFrameLocal(frame: number, visible: boolean): void {
  if (!frame || frame === 0) return;
  if (!isLocalRenderTargetPlayer()) return;
  japi.DzFrameShow(frame, visible);
}

function showIndicatorLocal(visible: boolean): void {
  if (!pageIndicatorFrame || pageIndicatorFrame === 0) return;
  japi.DzFrameShow(pageIndicatorFrame, visible);
}

function hideAllFlipFramesLocal(): void {
  for (let i = 0; i < pageFlipFrames.length; i++) {
    showFrameLocal(pageFlipFrames[i], false);
  }
}

function stopPageFlipTimer(): void {
  if (!pageFlipTimer || pageFlipTimer === 0) return;
  jass.PauseTimer(pageFlipTimer);
}

function getPageBodyText(pageIndex: number): string {
  return PAGE_BODY_TEXTS[pageIndex] || PAGE_BODY_TEXTS[0];
}

function applyCurrentPageBodyTextLocal(): void {
  if (!pageBodyTextFrame || pageBodyTextFrame === 0) return;
  if (!isLocalRenderTargetPlayer()) return;
  japi.DzFrameSetText(pageBodyTextFrame, getPageBodyText(pageBodyTextPageIndex));
}

function onPageFlipTimerTick(): void {
  if (!pageFlipAnimating) {
    stopPageFlipTimer();
    return;
  }

  if (pageFlipFrameIndex >= PAGE_TEST_FLIP_TEXTURES.length) {
    pageFlipAnimating = false;
    pageBodyTextPageIndex = pageBodyTextPendingPageIndex;
    applyCurrentPageBodyTextLocal();
    hideAllFlipFramesLocal();
    stopPageFlipTimer();
    return;
  }

  hideAllFlipFramesLocal();
  showFrameLocal(pageFlipFrames[pageFlipFrameIndex], true);
  pageFlipFrameIndex += 1;
}

function startPageFlipForPlayer(player: any): void {
  if (pageFlipAnimating) return;
  if (!pageBaseFrame || pageBaseFrame === 0) return;
  if (pageFlipFrames.length <= 0) return;
  if (!pageFlipTimer || pageFlipTimer === 0) return;

  pageFlipAnimating = true;
  pageFlipTargetPlayerId = jass.GetPlayerId(player);
  pageBodyTextPendingPageIndex = pageBodyTextPageIndex === 0 ? 1 : 0;
  hideAllFlipFramesLocal();
  showIndicatorLocal(false);
  showFrameLocal(pageFlipFrames[0], true);
  pageFlipFrameIndex = 1;

  const frameCount = PAGE_TEST_FLIP_TEXTURES.length;
  if (frameCount <= 0) {
    pageFlipAnimating = false;
    return;
  }

  jass.TimerStart(pageFlipTimer, PAGE_TEST_FLIP_DURATION / frameCount, true, onPageFlipTimerTick);
}

function ensurePageFlipTimer(): void {
  if (pageFlipTimer && pageFlipTimer !== 0) return;
  pageFlipTimer = jass.CreateTimer();
}

function onPageHotspotEnter(): void {
  const localPlayer = jass.GetLocalPlayer();
  if (localPlayer && localPlayer !== 0) {
    pageFlipTargetPlayerId = jass.GetPlayerId(localPlayer);
  }
  if (!pageFlipAnimating && pageFlipFrames.length > 0) {
    hideAllFlipFramesLocal();
    showFrameLocal(pageFlipFrames[0], true);
  }
  showIndicatorLocal(true);
}

function onPageHotspotLeave(): void {
  const localPlayer = jass.GetLocalPlayer();
  if (localPlayer && localPlayer !== 0) {
    pageFlipTargetPlayerId = jass.GetPlayerId(localPlayer);
  }
  if (!pageFlipAnimating) {
    hideAllFlipFramesLocal();
  }
  showIndicatorLocal(false);
}

function onPageHotspotClick(): void {
  const player = jass.GetLocalPlayer();
  if (!player || player === 0) return;
  startPageFlipForPlayer(player);
}

function createSizedBackdropFrame(name: string, texture: string, priority: number): number | null {
  const parent = japi.DzGetGameUI();
  if (!parent || parent === 0) return null;

  const frame = japi.DzCreateFrameByTagName("BACKDROP", name, parent, "template", 0);
  if (!frame || frame === 0) return null;

  japi.DzFrameSetSize(frame, PAGE_TEST_WIDTH, PAGE_TEST_HEIGHT);
  japi.DzFrameSetAbsolutePoint(frame, 4, PAGE_TEST_CENTER_X, PAGE_TEST_CENTER_Y);
  japi.DzFrameSetTexture(frame, texture, 0);
  japi.DzFrameSetPriority(frame, priority);
  return frame;
}

function createPageBaseFrame(): number | null {
  return createSizedBackdropFrame("PageFlipUiResearchBase", PAGE_TEST_BASE_TEXTURE, PAGE_BASE_PRIORITY);
}

function createPageIndicatorFrame(): number | null {
  const frame = createSizedBackdropFrame("PageFlipUiResearchIndicator", PAGE_TEST_INDICATOR_TEXTURE, PAGE_INDICATOR_PRIORITY);
  if (!frame || frame === 0) return null;
  japi.DzFrameShow(frame, false);
  return frame;
}

function createPageFlipFrames(): number[] {
  const frames: number[] = [];
  for (let i = 0; i < PAGE_TEST_FLIP_TEXTURES.length; i++) {
    const frame = createSizedBackdropFrame(
      `PageFlipUiResearchOverlay${i + 1}`,
      PAGE_TEST_FLIP_TEXTURES[i],
      PAGE_FLIP_PRIORITY_START + i
    );
    if (!frame || frame === 0) continue;
    japi.DzFrameShow(frame, false);
    frames.push(frame);
  }
  return frames;
}

function createPageHotspotFrame(): number | null {
  const parent = japi.DzGetGameUI();
  if (!parent || parent === 0) return null;
  if (!pageBaseFrame || pageBaseFrame === 0) return null;

  const frame = japi.DzCreateFrameByTagName("GLUETEXTBUTTON", "PageFlipUiResearchHotspot", parent, "template", 0);
  if (!frame || frame === 0) return null;

  japi.DzFrameSetSize(frame, PAGE_TEST_HOTSPOT_WIDTH, PAGE_TEST_HOTSPOT_HEIGHT);
  japi.DzFrameSetPoint(frame, 8, pageBaseFrame, 8, 0, 0);
  japi.DzFrameSetText(frame, "");
  japi.DzFrameSetAlpha(frame, 0);
  japi.DzFrameSetPriority(frame, PAGE_HOTSPOT_PRIORITY);
  return frame;
}

function createPageHotspotHintFrame(hotspotFrame: number): number | null {
  const parent = japi.DzGetGameUI();
  if (!parent || parent === 0) return null;

  const hintFrame = japi.DzCreateFrameByTagName("TEXT", "PageFlipUiResearchHotspotHint", parent, "template", 0);
  if (hintFrame && hintFrame !== 0) {
    japi.DzFrameSetSize(hintFrame, PAGE_TEST_HOTSPOT_WIDTH, PAGE_TEST_HOTSPOT_HEIGHT);
    japi.DzFrameSetPoint(hintFrame, 4, hotspotFrame, 4, PAGE_HOTSPOT_HINT_OFFSET_X, PAGE_HOTSPOT_HINT_OFFSET_Y);
    japi.DzFrameSetTextAlignment(hintFrame, -1);
    japi.DzFrameSetTextAlignment(hintFrame, 18);
    japi.DzFrameSetTextColor(
      hintFrame,
      PAGE_HOTSPOT_HINT_COLOR_R,
      PAGE_HOTSPOT_HINT_COLOR_G,
      PAGE_HOTSPOT_HINT_COLOR_B,
      PAGE_HOTSPOT_HINT_COLOR_A
    );
    japi.DzFrameSetPriority(hintFrame, PAGE_HOTSPOT_PRIORITY - 1);
  }
  return hintFrame;
}

function createPageBodyTextFrame(baseFrame: number): number | null {
  const parent = japi.DzGetGameUI();
  if (!parent || parent === 0) return null;

  const textFrame = japi.DzCreateFrameByTagName("TEXT", "PageFlipUiResearchBodyText", parent, "template", 0);
  if (!textFrame || textFrame === 0) return null;

  japi.DzFrameSetSize(textFrame, PAGE_BODY_TEXT_WIDTH, PAGE_BODY_TEXT_HEIGHT);
  japi.DzFrameSetPoint(textFrame, 0, baseFrame, 0, PAGE_BODY_TEXT_OFFSET_X, PAGE_BODY_TEXT_OFFSET_Y);
  japi.DzFrameSetTextAlignment(textFrame, -1);
  japi.DzFrameSetTextAlignment(textFrame, 0);
  japi.DzFrameSetFont(textFrame, PAGE_BODY_TEXT_FONT, PAGE_BODY_TEXT_FONT_SIZE, 0);
  japi.DzFrameSetTextColor(textFrame, 80, 48, 24, 255);
  japi.DzFrameSetPriority(textFrame, PAGE_BODY_TEXT_PRIORITY);
  return textFrame;
}

function bindPageHotspotEvents(frame: number): void {
  const frameSetScriptByCode = Frame工具.frameSetScriptByCode;
  if (typeof frameSetScriptByCode !== "function") return;
  frameSetScriptByCode(frame, PAGE_EVENT_MOUSE_ENTER, onPageHotspotEnter, false);
  frameSetScriptByCode(frame, PAGE_EVENT_MOUSE_LEAVE, onPageHotspotLeave, false);
  frameSetScriptByCode(frame, PAGE_EVENT_MOUSE_CLICK, onPageHotspotClick, false);
}

export function initPageFlipUiResearchTest(): void {
  if (pageTestInitDone) return;
  pageTestInitDone = true;

  ensurePageFlipTimer();
  pageBaseFrame = createPageBaseFrame();
  pageIndicatorFrame = createPageIndicatorFrame();
  pageFlipFrames = createPageFlipFrames();
  pageHotspotFrame = createPageHotspotFrame();
  if (!pageBaseFrame || pageBaseFrame === 0) return;
  pageBodyTextFrame = createPageBodyTextFrame(pageBaseFrame);
  if (pageHotspotFrame && pageHotspotFrame !== 0) {
    pageHotspotHintTextFrame = createPageHotspotHintFrame(pageHotspotFrame);
    bindPageHotspotEvents(pageHotspotFrame);
  }

  const localPlayer = jass.GetLocalPlayer();
  if (localPlayer && localPlayer !== 0) {
    japi.DzFrameShow(pageBaseFrame, false);
    if (pageHotspotFrame && pageHotspotFrame !== 0) {
      japi.DzFrameShow(pageHotspotFrame, false);
    }
    if (pageBodyTextFrame && pageBodyTextFrame !== 0) {
      japi.DzFrameShow(pageBodyTextFrame, false);
    }
    applyCurrentPageBodyTextLocal();
    if (pageHotspotHintTextFrame && pageHotspotHintTextFrame !== 0) {
      japi.DzFrameSetText(pageHotspotHintTextFrame, PAGE_HOTSPOT_HINT_TEXT);
      japi.DzFrameShow(pageHotspotHintTextFrame, false);
    }
  }
}
