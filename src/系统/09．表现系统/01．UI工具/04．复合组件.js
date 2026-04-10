const japi = require("jass.japi");
import { FrameType, } from "./00．类型定义";
import { createFrame } from "./01．帧创建";
import { setFramePosition, setFramePointRelative, setFrameSize } from "./02．位置尺寸";
import { setButtonText, setFrameClickEvent, setFrameTexture } from "./03．内容设置";
import { destroyFrame } from "./05．帧控制";
// ========== 虚拟分区：可点击图标 ==========
export function createClickableIcon(name, parent, texture, position, size, onClick) {
    const backdrop = createFrame({
        type: FrameType.BACKDROP,
        name: `${name}_Backdrop`,
        parent,
        template: "template",
        visible: true,
    });
    if (!backdrop)
        return null;
    setFramePosition(backdrop, position);
    setFrameSize(backdrop, size);
    setFrameTexture(backdrop, texture);
    const button = createFrame({
        type: FrameType.GLUETEXTBUTTON,
        name: `${name}_Button`,
        parent: backdrop,
        template: "template",
        visible: true,
        enable: true,
        alpha: 0,
    });
    if (!button)
        return null;
    if (typeof japi.DzFrameSetAllPoints === "function") {
        japi.DzFrameSetAllPoints(button, backdrop);
    }
    else {
        setFramePosition(button, position);
        setFrameSize(button, size);
    }
    setFrameClickEvent(button, onClick);
    return { backdrop, button };
}
// ========== 虚拟分区：文本按钮 ==========
export function createTextButton(name, parent, text, position, size, onClick) {
    const frame = createFrame({
        type: FrameType.GLUETEXTBUTTON,
        name,
        parent,
        template: "template",
        visible: true,
        enable: true,
    });
    if (!frame)
        return null;
    setFramePosition(frame, position);
    setFrameSize(frame, size);
    setButtonText(frame, text);
    if (onClick)
        setFrameClickEvent(frame, onClick);
    return frame;
}
// ========== 虚拟分区：文本标签 ==========
export function createTextLabel(name, parent, text, position, size) {
    const isRelative = "relativeTo" in position;
    const setPos = (f) => {
        if (isRelative) {
            const r = position;
            setFramePointRelative(f, r.point, r.relativeTo, r.relativePoint, r.x, r.y);
        }
        else {
            setFramePosition(f, position);
        }
    };
    const frame = createFrame({
        type: FrameType.TEXT,
        name,
        parent,
        template: "template",
        visible: true,
    });
    if (frame) {
        setPos(frame);
        setFrameSize(frame, size);
        if (typeof japi.DzFrameSetText === "function")
            japi.DzFrameSetText(frame, text);
        return frame;
    }
    const fallback = createFrame({
        type: FrameType.GLUETEXTBUTTON,
        name,
        parent,
        template: "template",
        visible: true,
    });
    if (!fallback)
        return null;
    setPos(fallback);
    setFrameSize(fallback, size);
    setButtonText(fallback, text);
    return fallback;
}
// ========== 虚拟分区：文本区域 ==========
export function createTextArea(name, parent, text, position, size, backgroundTexture) {
    const backdrop = createFrame({
        type: FrameType.BACKDROP,
        name: `${name}_Backdrop`,
        parent,
        template: "template",
        visible: true,
    });
    if (backdrop) {
        setFramePosition(backdrop, position);
        setFrameSize(backdrop, size);
        if (backgroundTexture && typeof japi.DzFrameSetTexture === "function") {
            japi.DzFrameSetTexture(backdrop, backgroundTexture, 0);
        }
    }
    const frame = createFrame({
        type: FrameType.TEXTAREA,
        name,
        parent: backdrop || parent,
        template: "template",
        visible: true,
    });
    if (frame) {
        if (backdrop && typeof japi.DzFrameSetAllPoints === "function") {
            japi.DzFrameSetAllPoints(frame, backdrop);
        }
        else {
            setFramePosition(frame, position);
            setFrameSize(frame, size);
        }
        if (typeof japi.DzFrameSetText === "function")
            japi.DzFrameSetText(frame, text);
        return frame;
    }
    return createTextLabel(name, parent, text, position, size);
}
// ========== 虚拟分区：文本框 ==========
export function createTextBox(name, parent, text, position, size, backgroundTexture) {
    const backdrop = createFrame({
        type: FrameType.BACKDROP,
        name: `${name}_Backdrop`,
        parent,
        template: "template",
        visible: true,
    });
    if (!backdrop)
        return null;
    setFramePosition(backdrop, position);
    setFrameSize(backdrop, size);
    setFrameTexture(backdrop, backgroundTexture);
    const textFrame = createFrame({
        type: FrameType.TEXT,
        name: `${name}_Text`,
        parent: backdrop,
        template: "template",
        visible: true,
    });
    if (!textFrame) {
        destroyFrame(backdrop);
        return null;
    }
    const innerPos = {
        point: position.point,
        x: position.x + 0.005,
        y: position.y - 0.005,
    };
    const innerSize = {
        width: size.width - 0.01,
        height: size.height - 0.01,
    };
    setFramePosition(textFrame, innerPos);
    setFrameSize(textFrame, innerSize);
    if (typeof japi.DzFrameSetText === "function")
        japi.DzFrameSetText(textFrame, text);
    return { backdrop, text: textFrame };
}
