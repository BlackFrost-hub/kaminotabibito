const japi = require("jass.japi");
import { getGameUI } from "../../00．核心系统/04．硬件函数";
// ========== 虚拟分区：销毁 ==========
export function destroyFrame(frame) {
    if (!frame || typeof japi.DzDestroyFrame !== "function")
        return false;
    japi.DzDestroyFrame(frame);
    return true;
}
// ========== 虚拟分区：显示隐藏 ==========
export function hideFrame(frame) {
    if (!frame || typeof japi.DzFrameShow !== "function")
        return false;
    japi.DzFrameShow(frame, false);
    return true;
}
export function showFrame(frame) {
    if (!frame || typeof japi.DzFrameShow !== "function")
        return false;
    japi.DzFrameShow(frame, true);
    return true;
}
// ========== 虚拟分区：根节点 ==========
export function getGameUIFrame() {
    return getGameUI();
}
