/**
 * Star扩展库 - 特效组系统
 *
 * 来源于 EG.j，管理特效（effect）的分组集合。
 * 原版使用 hashtable 存储，现改用 Lua table 实现，性能更优。
 *
 * 公开接口：
 *   EG_CreateEffectGroup()                - 创建特效组，返回组ID
 *   EG_RemoveGroup(id)                    - 移除特效组
 *   EG_ClearGroup(id)                     - 清空特效组内所有特效
 *   EG_GroupAddEffect(e, id)              - 添加特效到组（不允许重复）
 *   EG_GroupAddEffectEx(e, id)            - 添加特效到组（允许重复）
 *   EG_RemoveEffectOfGroup(e, id)         - 从组中移除特效
 *   EG_ForGroup(id, callback)             - 遍历特效组，对每个特效调用回调
 *   EG_GetFirstOfGroup(id)                - 获取组中第一个特效
 *   EG_GetRandomOfGroup(id)               - 获取组中随机一个特效
 *   EG_IsEffectOnGroup(e, id)             - 特效是否在组中，返回索引或-1
 *   EG_IsGroupHaveEffect(e, id)           - 特效是否在组中，返回布尔
 *   EG_IsGroupEmpty(id)                   - 特效组是否为空
 *   EG_GetCount(id)                       - 获取特效组中特效数量
 *   EG_GetAt(id, i)                       - 获取组中第i个特效
 *   EG_GroupAddGroup(srcId, destId)       - 将destId组内所有特效添加到srcId组
 *   EG_I2EG(id)                           - 整数转特效组ID（恒等）
 *   EG_EG2I(eg)                           - 特效组ID转整数（恒等）
 */
const jass = require("jass.common");
let nextGroupId = 5000001;
const groups = {};
/**
 * 创建一个特效组
 * @returns 特效组ID
 */
export function EG_CreateEffectGroup() {
    const id = nextGroupId;
    nextGroupId += 1;
    groups[id] = [];
    return id;
}
/**
 * 移除特效组
 * @param id 特效组ID
 */
export function EG_RemoveGroup(id) {
    delete groups[id];
}
/**
 * 清空特效组内所有特效
 * @param id 特效组ID
 */
export function EG_ClearGroup(id) {
    const g = groups[id];
    if (g == null)
        return;
    g.length = 0;
}
/**
 * 添加特效到组（不允许重复）
 * @param e 特效句柄
 * @param id 特效组ID
 * @returns 是否添加成功
 */
export function EG_GroupAddEffect(e, id) {
    const g = groups[id];
    if (g == null)
        return false;
    for (let i = 0; i < g.length; i++) {
        if (g[i] === e)
            return false;
    }
    g.push(e);
    return true;
}
/**
 * 添加特效到组（允许重复）
 * @param e 特效句柄
 * @param id 特效组ID
 * @returns 是否添加成功
 */
export function EG_GroupAddEffectEx(e, id) {
    const g = groups[id];
    if (g == null)
        return false;
    g.push(e);
    return true;
}
/**
 * 从组中移除特效（swap-with-last法，O(1)移除）
 * @param e 特效句柄
 * @param id 特效组ID
 * @returns 是否移除成功
 */
export function EG_RemoveEffectOfGroup(e, id) {
    const g = groups[id];
    if (g == null)
        return false;
    const max = g.length - 1;
    if (max < 0)
        return false;
    for (let i = 0; i <= max; i++) {
        if (g[i] === e) {
            if (i !== max) {
                g[i] = g[max];
            }
            g.pop();
            return true;
        }
    }
    return false;
}
/**
 * 遍历特效组，对每个特效调用回调
 * 回调中可安全调用 EG_RemoveEffectOfGroup 移除当前特效
 * @param id 特效组ID
 * @param callback 回调函数，参数为当前遍历到的特效
 */
export function EG_ForGroup(id, callback) {
    const g = groups[id];
    if (g == null)
        return;
    let i = 0;
    while (i < g.length) {
        const e = g[i];
        const lenBefore = g.length;
        callback(e);
        if (g.length < lenBefore) {
            // 当前元素已被移除（swap-with-last后pop），不递增i
        }
        else {
            i += 1;
        }
    }
}
/**
 * 获取组中第一个特效
 * @param id 特效组ID
 * @returns 第一个特效，组为空时返回null
 */
export function EG_GetFirstOfGroup(id) {
    const g = groups[id];
    if (g == null || g.length === 0)
        return null;
    return g[0];
}
/**
 * 获取组中随机一个特效
 * @param id 特效组ID
 * @returns 随机特效，组为空时返回null
 */
export function EG_GetRandomOfGroup(id) {
    const g = groups[id];
    if (g == null || g.length === 0)
        return null;
    const max = g.length - 1;
    if (max < 0)
        return null;
    const idx = jass.GetRandomInt(0, max);
    return g[idx];
}
/**
 * 特效是否在指定特效组中
 * @param e 特效句柄
 * @param id 特效组ID
 * @returns 索引位置，不存在返回-1
 */
export function EG_IsEffectOnGroup(e, id) {
    const g = groups[id];
    if (g == null)
        return -1;
    for (let i = 0; i < g.length; i++) {
        if (g[i] === e)
            return i;
    }
    return -1;
}
/**
 * 特效是否在指定特效组中
 * @param e 特效句柄
 * @param id 特效组ID
 * @returns 是否存在
 */
export function EG_IsGroupHaveEffect(e, id) {
    return EG_IsEffectOnGroup(e, id) !== -1;
}
/**
 * 特效组是否为空
 * @param id 特效组ID
 * @returns 是否为空
 */
export function EG_IsGroupEmpty(id) {
    const g = groups[id];
    if (g == null)
        return true;
    return g.length === 0;
}
/**
 * 获取特效组中特效数量
 * @param id 特效组ID
 * @returns 特效数量
 */
export function EG_GetCount(id) {
    const g = groups[id];
    if (g == null)
        return 0;
    return g.length;
}
/**
 * 获取特效组中第i个特效
 * @param id 特效组ID
 * @param i 索引（0-based）
 * @returns 特效句柄，越界返回null
 */
export function EG_GetAt(idOrI, iMaybe) {
    let id = idOrI;
    let i = iMaybe;
    // 兼容被全局桥接后由 JASS 直接调用时的 self 参数错位：EG_GetAt(id, i)
    if (i == null && typeof this === "number" && typeof idOrI === "number") {
        id = this;
        i = idOrI;
    }
    if (typeof id !== "number" || typeof i !== "number")
        return null;
    const g = groups[id];
    if (g == null)
        return null;
    if (i < 0 || i >= g.length)
        return null;
    return g[i];
}
/**
 * 将destId组内所有特效添加到srcId组（不允许重复添加）
 * @param srcId 目标特效组ID
 * @param destId 源特效组ID
 */
export function EG_GroupAddGroup(srcId, destId) {
    const src = groups[srcId];
    const dest = groups[destId];
    if (src == null || dest == null)
        return;
    for (let i = 0; i < dest.length; i++) {
        EG_GroupAddEffect(dest[i], srcId);
    }
}
/**
 * 整数转特效组ID（恒等转换）
 */
export function EG_I2EG(id) {
    return id;
}
/**
 * 特效组ID转整数（恒等转换）
 */
export function EG_EG2I(eg) {
    return eg;
}
