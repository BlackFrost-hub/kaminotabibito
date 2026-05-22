/** @noSelfInFile */

export type 单位配置记录 = Record<string, any>;

function normalizeUnitName(this: void, name: string): string {
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

export function 创建单位名反查器(
  this: void,
  配置表: Record<string, 单位配置记录>,
  名称字段列表: string[] = ["Name", "Propernames"],
): (this: void, name: string) => string | undefined {
  return function 按名字反查单位ID(this: void, name: string): string | undefined {
    const normalized = normalizeUnitName(name);
    for (const [unitId, data] of Object.entries(配置表)) {
      for (let i = 0; i < 名称字段列表.length; i++) {
        const fieldName = 名称字段列表[i];
        const fieldValue = data[fieldName];
        if (typeof fieldValue === "string" && normalizeUnitName(fieldValue) === normalized) {
          return unitId;
        }
      }
      if (typeof data.unit === "string" && normalizeUnitName(data.unit) === normalized) {
        return unitId;
      }
      if (normalizeUnitName(unitId) === normalized) {
        return unitId;
      }
    }
    return undefined;
  };
}

