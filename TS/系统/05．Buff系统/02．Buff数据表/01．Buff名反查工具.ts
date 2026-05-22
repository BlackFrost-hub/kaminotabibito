/** @noSelfInFile */

import { Buff数据表 } from "./00．Buff数据表";

export type Buff配置记录 = Record<string, any>;

function normalizeBuffName(this: void, name: string): string {
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

export function 创建Buff名反查器(
  this: void,
  配置表: Record<string, Buff配置记录>,
  名称字段列表: string[] = ["Bufftip", "EditorName"],
): (this: void, name: string) => string | undefined {
  return function 按名字反查BuffID(this: void, name: string): string | undefined {
    const normalized = normalizeBuffName(name);
    for (const [buffId, data] of Object.entries(配置表)) {
      for (let i = 0; i < 名称字段列表.length; i++) {
        const fieldName = 名称字段列表[i];
        const fieldValue = data[fieldName];
        if (typeof fieldValue === "string" && normalizeBuffName(fieldValue) === normalized) {
          return buffId;
        }
      }
      if (typeof data.key === "string" && normalizeBuffName(data.key) === normalized) {
        return buffId;
      }
      if (normalizeBuffName(buffId) === normalized) {
        return buffId;
      }
    }
    return undefined;
  };
}

export const Buff名反查器 = 创建Buff名反查器(Buff数据表);

export function 按名字反查BuffID(this: void, name: string): string | undefined {
  return Buff名反查器(name);
}
