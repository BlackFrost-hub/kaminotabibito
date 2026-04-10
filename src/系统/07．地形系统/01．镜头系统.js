/**
 * 镜头系统：仅对指定玩家移动镜头（TS 重写 StarOther_PanCameraToTimedForPlayer 逻辑）。
 * 通过 GetLocalPlayer() 判断本地玩家，仅在该玩家等于 whichPlayer 时调用 PanCameraToTimed，避免多玩家不同步。
 *
 * 使用：import { panCameraToTimedForPlayer } from './镜头系统'
 */
const jass = require("jass.common");
/**
 * 对指定玩家在指定时间内平移镜头到 (x, y)。
 * 仅在被移动镜头的玩家本地执行 PanCameraToTimed，其他玩家不受影响。
 * @param whichPlayer 要移动镜头的玩家（jhandle_t）
 * @param x 目标 X 坐标
 * @param y 目标 Y 坐标
 * @param duration 平移耗时（秒）
 */
export function panCameraToTimedForPlayer(whichPlayer, x, y, duration) {
    if (typeof jass.GetLocalPlayer !== "function")
        return;
    const localPlayer = jass.GetLocalPlayer();
    if (localPlayer !== whichPlayer)
        return;
    if (typeof jass.PanCameraToTimed !== "function")
        return;
    jass.PanCameraToTimed(x, y, duration);
}
