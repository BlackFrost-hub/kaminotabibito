/** @noSelfInFile */
/**
 * 字符串池
 *
 * 用途：保存一组字符串及其权重，按权重随机取值。
 * - 随机取字符串：只读取，不移除，适合台词、提示、日志文案。
 * - 随机取出字符串：读取后移除，适合不重复文案、随机阶段名、一次性事件。
 */
const jass = require("jass.common");
const GetRandomReal = jass["GetRandomReal"];
const 字符串池映射 = {};
let 下一个字符串池ID = 0;
function 取字符串池(pool) {
    if (pool == null || pool <= 0)
        return undefined;
    return 字符串池映射[pool];
}
function 取安全权重(weight) {
    return weight == null ? 1 : weight;
}
function 删除下标(data, index) {
    const lastIndex = data.values.length - 1;
    if (index < 0 || index > lastIndex)
        return;
    if (index !== lastIndex) {
        data.values[index] = data.values[lastIndex];
        data.weights[index] = data.weights[lastIndex];
    }
    data.values.pop();
    data.weights.pop();
}
function 随机取下标(data) {
    let totalWeight = 0;
    let i = 0;
    while (i < data.weights.length) {
        const weight = data.weights[i];
        if (weight > 0) {
            totalWeight += weight;
        }
        i += 1;
    }
    if (totalWeight <= 0)
        return -1;
    const roll = GetRandomReal(0, totalWeight);
    let currentWeight = 0;
    let lastPositiveIndex = -1;
    i = 0;
    while (i < data.values.length) {
        const weight = data.weights[i];
        if (weight > 0) {
            currentWeight += weight;
            lastPositiveIndex = i;
            if (roll <= currentWeight) {
                return i;
            }
        }
        i += 1;
    }
    return lastPositiveIndex;
}
export function 创建字符串池() {
    下一个字符串池ID += 1;
    const id = 下一个字符串池ID;
    字符串池映射[id] = {
        id,
        values: [],
        weights: [],
    };
    return id;
}
export function 删除字符串池(pool) {
    delete 字符串池映射[pool];
}
export function 字符串池是否存在(pool) {
    return 取字符串池(pool) != null;
}
export function 字符串池是否为空(pool) {
    const data = 取字符串池(pool);
    return data == null || data.values.length === 0;
}
export function 获取字符串池数量(pool) {
    const data = 取字符串池(pool);
    return data == null ? 0 : data.values.length;
}
/**
 * 返回字符串所在下标；不存在返回 -1。下标沿用 JASS 版语义，从 0 开始。
 */
export function 字符串池查找(pool, value) {
    const data = 取字符串池(pool);
    if (data == null)
        return -1;
    let i = 0;
    while (i < data.values.length) {
        if (data.values[i] === value)
            return i;
        i += 1;
    }
    return -1;
}
export function 字符串池添加(pool, value, weight) {
    const data = 取字符串池(pool);
    if (data == null)
        return false;
    data.values.push(value);
    data.weights.push(取安全权重(weight));
    return true;
}
export function 字符串池删除字符串(pool, value) {
    const data = 取字符串池(pool);
    if (data == null)
        return false;
    const index = 字符串池查找(pool, value);
    if (index < 0)
        return false;
    删除下标(data, index);
    return true;
}
export function 字符串池随机取字符串(pool) {
    const data = 取字符串池(pool);
    if (data == null)
        return "";
    const index = 随机取下标(data);
    return index >= 0 ? data.values[index] : "";
}
export function 字符串池随机取出字符串(pool) {
    const data = 取字符串池(pool);
    if (data == null)
        return "";
    const index = 随机取下标(data);
    if (index < 0)
        return "";
    const value = data.values[index];
    删除下标(data, index);
    return value;
}
export const SSRP_CreatePool = 创建字符串池;
export const SSRP_RemovePool = 删除字符串池;
export const SSRP_IsInPool = 字符串池查找;
export const SSRP_PoolAddString = 字符串池添加;
export const SSRP_PoolRemoveString = 字符串池删除字符串;
export const SSRP_PoolGetString = 字符串池随机取出字符串;
