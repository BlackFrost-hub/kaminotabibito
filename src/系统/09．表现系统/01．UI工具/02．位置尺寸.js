const japi = require("jass.japi");
// ========== 虚拟分区：绝对布局 ==========
export function setFramePosition(frame, position) {
    if (frame === 0 || frame == null) {
        return false;
    }
    japi.DzFrameSetAbsolutePoint(frame, position.point, position.x, position.y);
    return true;
}
// ========== 虚拟分区：相对布局 ==========
export function setFramePointRelative(frame, point, relativeFrame, relativePoint, x, y) {
    if (frame === 0 ||
        frame == null ||
        relativeFrame === 0 ||
        relativeFrame == null) {
        return false;
    }
    japi.DzFrameSetPoint(frame, point, relativeFrame, relativePoint, x, y);
    return true;
}
// ========== 虚拟分区：尺寸 ==========
export function setFrameSize(frame, size) {
    if (frame === 0 || frame == null) {
        return false;
    }
    japi.DzFrameSetSize(frame, size.width, size.height);
    return true;
}
