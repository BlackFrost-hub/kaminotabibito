/** @noSelfInFile */
/**
 * 跳跃系统 - 对外接口
 *
 * 包含所有对外暴露的公共函数。
 */
import { 活动跳跃列表, 跳跃映射, 单位当前跳跃, 取句柄ID, 快照单位组, } from "./00．共享";
import { 创建跳跃实例, 解析跳跃角度, 结束跳跃ID, 停止单位跳跃 } from "./02．驱动与实例";
export function 开始跳跃(单位, 参数) {
    const 角度 = 解析跳跃角度(单位, 参数);
    if (角度 == null)
        return 0;
    return 创建跳跃实例(单位, 角度, 参数);
}
export function 开始定向跳跃(单位, 参数) {
    return 开始跳跃(单位, 参数);
}
export function 开始单位组跳跃(单位组, 参数) {
    const 单位列表 = 快照单位组(单位组);
    const 结果 = [];
    for (const 单位 of 单位列表) {
        const 跳跃ID = 开始跳跃(单位, 参数);
        if (跳跃ID > 0) {
            结果.push(跳跃ID);
        }
    }
    return 结果;
}
export function 开始单位组定向跳跃(单位组, 参数) {
    const 单位列表 = 快照单位组(单位组);
    const 结果 = [];
    for (const 单位 of 单位列表) {
        const 跳跃ID = 开始定向跳跃(单位, 参数);
        if (跳跃ID > 0) {
            结果.push(跳跃ID);
        }
    }
    return 结果;
}
export function 停止跳跃(跳跃ID, 原因 = "中断") {
    return 结束跳跃ID(跳跃ID, 原因);
}
export { 停止单位跳跃 };
export function 单位是否正在跳跃(单位) {
    const 跳跃ID = 单位当前跳跃[取句柄ID(单位)];
    return 跳跃ID != null && 跳跃映射[跳跃ID] != null;
}
export function 获取单位当前跳跃ID(单位) {
    return 单位当前跳跃[取句柄ID(单位)] ?? 0;
}
export function 获取活跃跳跃数量() {
    return 活动跳跃列表.length;
}
