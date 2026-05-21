/** @noSelfInFile */
// ========== 虚拟分区：Frame常量 ==========
/**
 * Frame类型常量（DzAPI 支持的类型）
 */
export const FrameType = {
    BACKDROP: "BACKDROP",
    TEXT: "TEXT",
    TEXTAREA: "TEXTAREA",
    GLUETEXTBUTTON: "GLUETEXTBUTTON",
    GLUECHECKBOX: "GLUECHECKBOX",
    POPUPMENU: "POPUPMENU",
    SCROLLBAR: "SCROLLBAR",
    SPRITE: "SPRITE",
    SLIDER: "SLIDER",
    BUTTON: "BUTTON",
    EDITBOX: "EDITBOX",
    HIGHLIGHT: "HIGHLIGHT",
    MENU: "MENU",
    DIALOG: "DIALOG",
    SIMPLEFRAME: "SIMPLEFRAME",
    SIMPLESTATUSBAR: "SIMPLESTATUSBAR",
    SIMPLECHECKBOX: "SIMPLECHECKBOX",
};
// ========== 虚拟分区：渲染层 ==========
export const FrameLayer = {
    ARTWORK: "ARTWORK",
};
// ========== 虚拟分区：锚点常量 ==========
export const FramePoint = {
    TOPLEFT: 0,
    TOP: 1,
    TOPRIGHT: 2,
    LEFT: 3,
    CENTER: 4,
    RIGHT: 5,
    BOTTOMLEFT: 6,
    BOTTOM: 7,
    BOTTOMRIGHT: 8,
};
// ========== 虚拟分区：事件常量 ==========
export const EventType = {
    MOUSE_CLICK: 1,
    MOUSE_ENTER: 2,
    MOUSE_LEAVE: 3,
    MOUSE_UP: 4,
    MOUSE_DOWN: 5,
    MOUSE_WHEEL: 6,
    MOUSE_DOUBLE_CLICK: 12,
    SLIDER_VALUE_CHANGED: 11,
};
