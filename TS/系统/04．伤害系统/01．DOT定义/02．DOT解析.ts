// ========== 虚拟分区：字符串切分 ==========
/** 装备 `Buff` 可多段，用 `+` 连接，例如：`Buff:dmg:...;timeN+Buff:dmg:...;timeN` */
export function splitItemBuffSegments(buff: string): string[] {
  if (!buff || typeof buff !== "string") return [];
  const parts = buff.split("+");
  const out: string[] = [];
  for (let i = 0; i < parts.length; i++) {
    const t = parts[i].trim();
    if (t !== "") out.push(t);
  }
  return out;
}

// ========== 虚拟分区：数字读取 ==========
/** 从字符串中读取从 startIdx 开始的连续数字 */
export function readNumberFromString(s: string, startIdx: number): number {
  let numEnd = startIdx;
  while (numEnd < s.length) {
    const c = s.charAt(numEnd);
    if (c >= "0" && c <= "9") numEnd++;
    else break;
  }
  return numEnd > startIdx ? parseInt(s.substring(startIdx, numEnd), 10) || 0 : 0;
}

// ========== 虚拟分区：标准 DOT 解析器 ==========
/** 通用的标准 DOT Buff 解析（适用于 AntiHeal、Burn、Poison） */
export function parseStandardDotBuff<T>(
  buffStr: string,
  keyword: string,
  createResult: (value: number, duration: number, attackOnly: boolean) => T,
  requireValuePositive: boolean = true
): T | null {
  if (!buffStr || typeof buffStr !== "string") return null;
  const s = buffStr.trim();
  let attackOnly = false;
  if (s.indexOf("Buff:attack:") === 0) {
    attackOnly = true;
  } else if (s.indexOf("Buff:dmg:") !== 0) {
    return null;
  }
  const rest = s.substring(attackOnly ? 12 : 9);
  const keywordIdx = rest.indexOf(keyword);
  if (keywordIdx < 0) return null;
  const valueStartIdx = keywordIdx + keyword.length;
  const value = readNumberFromString(rest, valueStartIdx);
  const timeIdx = rest.indexOf("time");
  if (timeIdx < 0) return null;
  const duration = readNumberFromString(rest, timeIdx + 4);
  if (duration <= 0) return null;
  if (requireValuePositive && value <= 0) return null;
  return createResult(value, duration, attackOnly);
}
