/** @noSelfInFile */
/**
 * 牵引系统 - 中心计时器驱动与实例管理
 */
const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器");
import { 推进牵引实例, 结束牵引实例 } from "./01．移动与闪电";
import { 活动牵引列表, 牵引映射, } from "./00．共享";
let 已注册到中心计时器 = false;
let tick计数 = 0;
function 注册到中心计时器() {
    if (已注册到中心计时器)
        return;
    已注册到中心计时器 = true;
    onTick10ms(on吸附牵引系统Tick);
}
function 从中心计时器注销() {
    if (!已注册到中心计时器)
        return;
    已注册到中心计时器 = false;
    offTick10ms(on吸附牵引系统Tick);
}
function 尝试收尾中心计时器() {
    if (活动牵引列表.length !== 0)
        return;
    tick计数 = 0;
    从中心计时器注销();
}
export { 注册到中心计时器, 尝试收尾中心计时器 };
function on吸附牵引系统Tick() {
    tick计数 += 1;
    if (tick计数 < 2)
        return;
    tick计数 = 0;
    let i = 0;
    while (i < 活动牵引列表.length) {
        const 实例 = 活动牵引列表[i];
        推进牵引实例(实例);
        if (活动牵引列表[i] === 实例) {
            i += 1;
        }
    }
}
export function 结束牵引ID(牵引ID, 原因) {
    const 实例 = 牵引映射[牵引ID];
    if (!实例)
        return false;
    结束牵引实例(实例, 原因);
    return true;
}
