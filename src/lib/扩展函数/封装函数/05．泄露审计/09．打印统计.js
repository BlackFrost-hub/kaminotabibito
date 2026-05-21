/**
 * 泄露审计 - 打印统计
 */
const jass = require("jass.common");
import { alive, types, stats } from "./01．核心统计";
/** 打印当前统计信息；可选 tagFilter 只查看某个来源 */
export function dump(tagFilter) {
    const p0 = jass.Player(0);
    const printLine = (msg) => {
        if (!p0)
            return;
        jass.DisplayTimedTextToPlayer(p0, 0, 0, 15, msg);
    };
    printLine("=== LeakWatcher 记账 (非 jass.debug 句柄表) ===");
    for (const tp of types) {
        const s = stats[tp];
        const aliveCount = s.created - s.destroyed;
        printLine(`${tp}: alive=${aliveCount}, created=${s.created}, destroyed=${s.destroyed}`);
    }
    if (tagFilter) {
        printLine(`--- 详情 tag=${tagFilter} ---`);
        for (const key in alive) {
            const info = alive[key];
            if (info != null && info.tag === tagFilter) {
                printLine(`${info.type}#${info.createdIndex} (${info.tag}) [${info.handleText}]`);
            }
        }
    }
}
