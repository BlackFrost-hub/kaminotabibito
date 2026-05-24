/** @noSelfInFile */

import { 技能数据表 } from "./00．技能数据表";

function normalizeSkillName(this: void, name: string): string {
  let result = "";
  for (let i = 0; i < name.length; i++) {
    const ch = name.charAt(i);
    if (ch === "\r" || ch === "\n") {
      continue;
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

export function 创建技能名反查器(
  this: void,
  数据表: Record<string, Record<string, any>>,
  字段列表: string[] = ["Name", "Untip", "Researchtip"],
): (this: void, name: string) => string | undefined {
  return function 按名字反查技能ID(this: void, name: string): string | undefined {
    const normalized = normalizeSkillName(name);
    for (const [abilityId, data] of Object.entries(数据表)) {
      if (normalizeSkillName(abilityId) === normalized) return abilityId;
      if (normalizeSkillName(String(data.ability ?? "")) === normalized) return abilityId;
      for (let i = 0; i < 字段列表.length; i++) {
        const fieldName = 字段列表[i];
        const fieldValue = data[fieldName];
        if (typeof fieldValue === "string" && normalizeSkillName(fieldValue) === normalized) {
          return abilityId;
        }
      }
    }
    return undefined;
  };
}

export const 技能名反查器 = 创建技能名反查器(技能数据表);

export function 按名字反查技能ID(this: void, name: string): string | undefined {
  return 技能名反查器(name);
}

