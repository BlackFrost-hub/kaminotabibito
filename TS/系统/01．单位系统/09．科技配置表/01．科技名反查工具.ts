/** @noSelfInFile */

import { 科技配置表 } from "./00．科技配置表";

export type 科技配置记录 = Record<string, any>;

function normalizeTechName(this: void, name: string): string {
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

export function 创建科技名反查器(
  this: void,
  配置表: Record<string, 科技配置记录>,
  名称字段列表: string[] = ["Name", "EditorName"],
): (this: void, name: string) => string | undefined {
  return function 按名字反查科技ID(this: void, name: string): string | undefined {
    const normalized = normalizeTechName(name);
    for (const [techId, data] of Object.entries(配置表)) {
      for (let i = 0; i < 名称字段列表.length; i++) {
        const fieldName = 名称字段列表[i];
        const fieldValue = data[fieldName];
        if (typeof fieldValue === "string" && normalizeTechName(fieldValue) === normalized) {
          return techId;
        }
      }
      if (typeof data.key === "string" && normalizeTechName(data.key) === normalized) {
        return techId;
      }
      if (normalizeTechName(techId) === normalized) {
        return techId;
      }
    }
    return undefined;
  };
}

export const 科技名反查器 = 创建科技名反查器(科技配置表);

export function 按名字反查科技ID(this: void, name: string): string | undefined {
  return 科技名反查器(name);
}
