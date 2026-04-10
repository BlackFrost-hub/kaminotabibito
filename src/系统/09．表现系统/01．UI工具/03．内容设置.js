const japi = require("jass.japi");
import { frameSetScriptByCode } from "../../00．核心系统/04．硬件函数";
import { EventType } from "./00．类型定义";
// ========== 虚拟分区：视觉内容 ==========
export function setFrameTexture(frame, texture) {
    if (frame === 0 || frame == null)
        return false;
    if (texture && typeof japi.DzFrameSetTexture === "function") {
        japi.DzFrameSetTexture(frame, texture, 0);
    }
    return true;
}
// ========== 虚拟分区：交互事件 ==========
export function setFrameClickEvent(frame, callback, sync = true) {
    if (frame === 0 || frame == null)
        return false;
    frameSetScriptByCode(frame, EventType.MOUSE_CLICK, callback, sync);
    return true;
}
export function setFrameHoverEvents(frame, onEnter, onLeave, sync = true) {
    if (frame === 0 || frame == null)
        return false;
    frameSetScriptByCode(frame, EventType.MOUSE_ENTER, onEnter, sync);
    frameSetScriptByCode(frame, EventType.MOUSE_LEAVE, onLeave, sync);
    return true;
}
// ========== 虚拟分区：文本内容 ==========
export function setButtonText(frame, text) {
    if (!frame || typeof japi.DzFrameSetText !== "function")
        return false;
    japi.DzFrameSetText(frame, text);
    return true;
}
