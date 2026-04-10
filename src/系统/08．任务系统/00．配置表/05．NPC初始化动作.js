import { RemoveItemFromStockBJ } from "../../../lib/扩展函数/BJ函数/03．物品与库存";
import { stringToFourCC } from "../../00．核心系统/01．封装函数";
// ========== 虚拟分区：基础解析 ==========
function readFirstInt(text) {
    let found = false;
    let n = 0;
    for (let i = 0; i < text.length; i++) {
        const c = text.charAt(i);
        if (c >= "0" && c <= "9") {
            found = true;
            n = n * 10 + (c.charCodeAt(0) - 48);
        }
        else if (found) {
            break;
        }
    }
    return n;
}
function parseItemIdList(spec) {
    const trimmed = spec.trim();
    const prefix = "itemId(";
    if (trimmed.indexOf(prefix) !== 0)
        return [];
    let end = -1;
    for (let i = trimmed.length - 1; i >= 0; i--) {
        if (trimmed.charAt(i) === ")") {
            end = i;
            break;
        }
    }
    if (end < prefix.length)
        return [];
    const inner = trimmed.substring(prefix.length, end);
    const parts = inner.split("|");
    const out = [];
    for (const p of parts) {
        const code = p.trim();
        if (code.length === 4)
            out.push(code);
    }
    return out;
}
function pickRandomDistinct(list, count) {
    const out = [];
    if (!list || list.length === 0)
        return out;
    if (count <= 0)
        return out;
    const pool = [...list];
    while (pool.length > 0 && out.length < count) {
        const idx = typeof math !== "undefined" && math.random ? math.random(1, pool.length) : 1;
        const picked = pool[idx];
        out.push(picked);
        pool.splice(idx - 1, 1);
    }
    return out;
}
// ========== 虚拟分区：动作执行 ==========
function execRemoveItemFromStock(whichUnit, arg, modifiers) {
    const items = parseItemIdList(arg);
    if (items.length === 0)
        return;
    let pickCount = 0;
    for (const m of modifiers) {
        const mm = m.trim().toLowerCase();
        if (mm.indexOf("random") === 0) {
            pickCount = readFirstInt(mm);
            break;
        }
    }
    const targets = pickCount > 0 ? pickRandomDistinct(items, pickCount) : items;
    for (const code of targets) {
        const id = stringToFourCC(code);
        if (id !== 0)
            RemoveItemFromStockBJ(id, whichUnit);
    }
}
/**
 * 执行 NPC 配置中的 initAction（用于 NPC 生成后的初始化脚本）。
 *
 * 当前支持：
 * - `RemoveItemFromStockBJ:itemId(I0AG|I0AH|I0AI)`（移除全部）
 * - `RemoveItemFromStockBJ:itemId(I0AG|I0AH|I0AI);random1`（随机移除 1 个）
 */
export function runNpcInitAction(whichUnit, initAction) {
    if (!whichUnit || !initAction)
        return;
    const raw = initAction.trim();
    if (raw === "")
        return;
    const segments = raw.split(";").map(s => s.trim()).filter(s => s !== "");
    if (segments.length === 0)
        return;
    // 第一段：动作本体；后续段：修饰符（如 random1）
    const head = segments[0];
    const modifiers = segments.slice(1);
    const colon = head.indexOf(":");
    const action = colon >= 0 ? head.substring(0, colon).trim() : head.trim();
    const arg = colon >= 0 ? head.substring(colon + 1).trim() : "";
    if (action === "RemoveItemFromStockBJ") {
        execRemoveItemFromStock(whichUnit, arg, modifiers);
        return;
    }
}
