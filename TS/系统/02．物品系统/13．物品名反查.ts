/** @noSelfInFile */
import { items } from "./01．装备数据";

function normalizeItemName(this: void, name: string): string {
  let result = "";
  for (let i = 0; i < name.length; i++) {
    const ch = name.charAt(i);
    if (ch === "|") {
      const next = name.charAt(i + 1);
      if (next === "r" || next === "R") {
        i = i + 1;
        continue;
      }
      if (next === "c" || next === "C") {
        i = i + 9;
        continue;
      }
    }
    result += ch;
  }
  return result.trim();
}

export function 按名字反查物品ID(this: void, name: string): string | undefined {
  const normalized = normalizeItemName(name);
  for (const [itemId, data] of Object.entries(items)) {
    if (normalizeItemName(data.name ?? "") === normalized) {
      return itemId;
    }
  }
  return undefined;
}

export { 按名字反查物品ID as resolveItemIdByName };
