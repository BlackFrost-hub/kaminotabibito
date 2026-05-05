/** @noSelfInFile */
/**
 * 联机安全 Map 遍历工具
 * Lua pairs 遍历顺序不确定，跨客户端可能不一致导致 desync。
 * 安全做法：收集 keys → 排序 → 按序遍历。
 */

export function forEachSorted<K extends number | string, V>(
  map: Map<K, V>,
  callback: (key: K, value: V) => void
): void {
  const keys: K[] = [];
  for (const k of map.keys()) {
    keys.push(k);
  }
  keys.sort((a, b) => {
    if (typeof a === "number" && typeof b === "number") return a - b;
    const sa = String(a);
    const sb = String(b);
    if (sa < sb) return -1;
    if (sa > sb) return 1;
    return 0;
  });
  for (let i = 0; i < keys.length; i++) {
    const key = keys[i];
    const value = map.get(key);
    if (value !== undefined) {
      callback(key, value);
    }
  }
}
