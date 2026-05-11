/** @noSelfInFile */
/**
 * 整数池
 *
 * 用途：保存一组整数及其权重，按权重随机取值；可选择取出后移除。
 * 行为参考 JASS StarIntPool，但用 TS/Lua 本地表实现，不依赖 StarTable。
 */

const jass = require("jass.common") as any;

const GetRandomReal = jass["GetRandomReal"] as (lowBound: number, highBound: number) => number;

interface 整数池数据 {
  id: number;
  values: number[];
  weights: number[];
}

const 整数池映射: Record<number, 整数池数据 | undefined> = {};
let 下一个整数池ID = 0;

function 取整数池(this: void, pool: number): 整数池数据 | undefined {
  if (pool == null || pool <= 0) return undefined;
  return 整数池映射[pool];
}

function 取安全权重(this: void, weight: number | undefined): number {
  return weight == null ? 1 : weight;
}

function 删除下标(this: void, data: 整数池数据, index: number): void {
  const lastIndex = data.values.length - 1;
  if (index < 0 || index > lastIndex) return;

  if (index !== lastIndex) {
    data.values[index] = data.values[lastIndex];
    data.weights[index] = data.weights[lastIndex];
  }
  data.values.pop();
  data.weights.pop();
}

function 随机取下标(this: void, data: 整数池数据): number {
  let totalWeight = 0;
  let i = 0;
  while (i < data.weights.length) {
    const weight = data.weights[i];
    if (weight > 0) {
      totalWeight += weight;
    }
    i += 1;
  }
  if (totalWeight <= 0) return -1;

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

export function 创建整数池(this: void): number {
  下一个整数池ID += 1;
  const id = 下一个整数池ID;
  整数池映射[id] = {
    id,
    values: [],
    weights: [],
  };
  return id;
}

export function 删除整数池(this: void, pool: number): void {
  delete 整数池映射[pool];
}

export function 整数池是否存在(this: void, pool: number): boolean {
  return 取整数池(pool) != null;
}

export function 整数池是否为空(this: void, pool: number): boolean {
  const data = 取整数池(pool);
  return data == null || data.values.length === 0;
}

export function 获取整数池数量(this: void, pool: number): number {
  const data = 取整数池(pool);
  return data == null ? 0 : data.values.length;
}

/**
 * 返回整数所在下标；不存在返回 -1。下标沿用 JASS 版语义，从 0 开始。
 */
export function 整数池查找(this: void, pool: number, value: number): number {
  const data = 取整数池(pool);
  if (data == null) return -1;

  let i = 0;
  while (i < data.values.length) {
    if (data.values[i] === value) return i;
    i += 1;
  }
  return -1;
}

export function 整数池添加(this: void, pool: number, value: number, weight?: number): boolean {
  const data = 取整数池(pool);
  if (data == null) return false;

  data.values.push(value);
  data.weights.push(取安全权重(weight));
  return true;
}

export function 整数池删除整数(this: void, pool: number, value: number): boolean {
  const data = 取整数池(pool);
  if (data == null) return false;

  const index = 整数池查找(pool, value);
  if (index < 0) return false;

  删除下标(data, index);
  return true;
}

export function 整数池随机取整数(this: void, pool: number): number {
  const data = 取整数池(pool);
  if (data == null) return 0;

  const index = 随机取下标(data);
  return index >= 0 ? data.values[index] : 0;
}

export function 整数池随机取出整数(this: void, pool: number): number {
  const data = 取整数池(pool);
  if (data == null) return 0;

  const index = 随机取下标(data);
  if (index < 0) return 0;

  const value = data.values[index];
  删除下标(data, index);
  return value;
}

export const SIP_CreatePool = 创建整数池;
export const SIP_RemovePool = 删除整数池;
export const SIP_IsInPool = 整数池查找;
export const SIP_IsEmpty = 整数池是否为空;
export const SIP_PoolAddInteger = 整数池添加;
export const SIP_PoolRemoveInteger = 整数池删除整数;
export const SIP_PoolGetInteger = 整数池随机取整数;
export const SIP_GetIntAndRemove = 整数池随机取出整数;
