/** @noSelfInFile */

import { 可破坏物数据 } from "./00．可破坏物数据";

export type 可破坏物配置记录 = Record<string, any>;

function normalizeDestructibleName(this: void, name: string): string {
  let result = "";
  for (let i = 0; i < name.length; i++) {
    const ch = name.charAt(i);
    if (ch === "\r" || ch === "\n") {
      continue;
    }
    if (ch === "\\") {
      const next = name.charAt(i + 1);
      if (next === "n" || next === "r") {
        i = i + 1;
        continue;
      }
    }
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

export function 创建可破坏物名反查器(
  this: void,
  配置表: Record<string, 可破坏物配置记录>,
  名称字段列表: string[] = ["Name", "EditorName"],
): (this: void, name: string) => string | undefined {
  return function 按名字反查可破坏物ID(this: void, name: string): string | undefined {
    const normalized = normalizeDestructibleName(name);
    for (const [destructibleId, data] of Object.entries(配置表)) {
      for (let i = 0; i < 名称字段列表.length; i++) {
        const fieldName = 名称字段列表[i];
        const fieldValue = data[fieldName];
        if (typeof fieldValue === "string" && normalizeDestructibleName(fieldValue) === normalized) {
          return destructibleId;
        }
      }
      if (typeof data.key === "string" && normalizeDestructibleName(data.key) === normalized) {
        return destructibleId;
      }
      if (normalizeDestructibleName(destructibleId) === normalized) {
        return destructibleId;
      }
    }
    return undefined;
  };
}

export const 可破坏物名反查器 = 创建可破坏物名反查器(可破坏物数据);

export function 按名字反查可破坏物ID(this: void, name: string): string | undefined {
  return 可破坏物名反查器(name);
}
