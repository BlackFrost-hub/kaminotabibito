/** @noSelfInFile */
const jass = require("jass.common");
const { getGameTime } = require("系统.00．核心系统.05．中心计时器");
const GetHandleId = jass.GetHandleId;
const 冷却记录 = {};
const 执行中记录 = {};
function 获取句柄ID(单位) {
    if (单位 == null || 单位 === 0)
        return 0;
    return GetHandleId(单位) || 0;
}
function 生成状态键(名称, 单位) {
    const id = 获取句柄ID(单位);
    if (id <= 0)
        return "";
    return `${名称}:${id}`;
}
function 取当前时间() {
    return getGameTime();
}
export function 攻击效果是否在冷却中(名称, 单位, 冷却毫秒) {
    if (!名称 || 冷却毫秒 <= 0)
        return false;
    const 键 = 生成状态键(名称, 单位);
    if (键 === "")
        return false;
    const 上次触发 = 冷却记录[键];
    if (上次触发 == null)
        return false;
    return 取当前时间() - 上次触发 < 冷却毫秒;
}
export function 攻击效果进入冷却(名称, 单位) {
    const 键 = 生成状态键(名称, 单位);
    if (键 === "")
        return;
    冷却记录[键] = 取当前时间();
}
export function 攻击效果清除冷却(名称, 单位) {
    const 键 = 生成状态键(名称, 单位);
    if (键 === "")
        return;
    delete 冷却记录[键];
}
export function 攻击效果是否正在执行(名称, 单位) {
    const 键 = 生成状态键(名称, 单位);
    if (键 === "")
        return false;
    return 执行中记录[键] === true;
}
export function 攻击效果开始执行(名称, 单位) {
    const 键 = 生成状态键(名称, 单位);
    if (键 === "")
        return false;
    if (执行中记录[键] === true)
        return false;
    执行中记录[键] = true;
    return true;
}
export function 攻击效果结束执行(名称, 单位) {
    const 键 = 生成状态键(名称, 单位);
    if (键 === "")
        return;
    delete 执行中记录[键];
}
