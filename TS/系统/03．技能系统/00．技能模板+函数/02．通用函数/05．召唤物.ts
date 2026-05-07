/** @noSelfInFile */
/**
 * 通用函数 - 召唤物快捷模板
 *
 * 说明：
 * - 配套底层 JASS 源文件：
 *   `JASS/jass复制粘贴/召唤物.j`
 * - 本文件不重写 JASS 召唤逻辑，而是按旧模板要求写入 YDLocal 参数后触发 STES 事件 `OnSummonEvent`
 * - 适合技能侧快速创建/配置召唤物，并继续复用 JASS 端现有字段语义
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const STES_Fire_Global = (globalThis as any).STES_Fire as ((self: any, name: string) => void) | undefined;

function 字符串哈希(name: string): number {
  return (jass.StringHash(name) as number) || 0;
}

function 写局部(type: "unit" | "integer" | "real" | "string", name: string, value: any): void {
  const ydloc = 获取YDLOC();
  if (!ydloc) return;
  const page = 取GSIndex();
  const key = 字符串哈希(name);
  switch (type) {
    case "unit":
      jass.SaveUnitHandle(ydloc, page, key, value);
      return;
    case "integer":
      jass.SaveInteger(ydloc, page, key, value);
      return;
    case "real":
      jass.SaveReal(ydloc, page, key, value);
      return;
    case "string":
      jass.SaveStr(ydloc, page, key, value);
      return;
  }
}

function 读局部(type: "unit" | "integer" | "real" | "string", name: string): any {
  const ydloc = 获取YDLOC();
  if (!ydloc) return null;
  const page = 取GLIndex();
  const key = 字符串哈希(name);
  switch (type) {
    case "unit":
      return jass.LoadUnitHandle(ydloc, page, key);
    case "integer":
      return jass.LoadInteger(ydloc, page, key);
    case "real":
      return jass.LoadReal(ydloc, page, key);
    case "string":
      return jass.LoadStr(ydloc, page, key);
  }
}

function 获取YDLOC(): any {
  const g = globalThis as any;
  return g.YDLOC
    ?? jglobals.YDLOC
    ?? g.YDHASH_HANDLE
    ?? jglobals.YDHASH_HANDLE
    ?? g.YDHT
    ?? jglobals.YDHT
    ?? g.udg_YDHASH_HANDLE
    ?? jglobals.udg_YDHASH_HANDLE
    ?? g.udg_YDHT
    ?? jglobals.udg_YDHT
    ?? null;
}

function 取GSIndex(): number {
  const g = globalThis as any;
  const value = g.G_SIndex ?? jglobals.G_SIndex;
  return typeof value === "number" ? value : 0;
}

function 设GSIndex(v: number): void {
  (globalThis as any).G_SIndex = v;
  (jglobals as any).G_SIndex = v;
}

function 取GLIndex(): number {
  const g = globalThis as any;
  const value = g.G_LIndex ?? jglobals.G_LIndex;
  return typeof value === "number" ? value : 0;
}

function 设GLIndex(v: number): void {
  (globalThis as any).G_LIndex = v;
  (jglobals as any).G_LIndex = v;
}

function 触发STES事件(name: string): void {
  if (typeof STES_Fire_Global !== "function") return;
  STES_Fire_Global(null, name);
}

function 四位码(raw: string): number {
  return (
    raw.charCodeAt(0) * 16777216
    + raw.charCodeAt(1) * 65536
    + raw.charCodeAt(2) * 256
    + raw.charCodeAt(3)
  );
}

type VoidCallback = () => void;

export interface 召唤物参数 {
  主人单位: any;
  单位类型?: string | number;
  召唤物单位?: any;

  X: number;
  Y: number;
  朝向?: number;
  持续时间?: number;

  模型文件?: string;
  飞行高度?: number;
  生命值?: number;
  生命回复?: number;
  攻击力?: number;
  攻击间隔?: number;
  护甲?: number;
  缩放?: number;
}

const SUMMON_STES_EVENT = "OnSummonEvent";
const LOCAL_PAGE_BASE = 0x53000000;
let nextLocalPageSeed = 0;

function 归一化单位类型(unitType: string | number | undefined): number {
  if (typeof unitType === "number") return unitType;
  if (typeof unitType === "string" && unitType.length === 4) {
    return 四位码(unitType);
  }
  return 0;
}

function 分配临时父页(): number {
  nextLocalPageSeed += 1;
  if (nextLocalPageSeed >= 0x00ffffff) {
    nextLocalPageSeed = 1;
  }
  return LOCAL_PAGE_BASE + nextLocalPageSeed;
}

function 写入召唤参数(参数: 召唤物参数): void {
  写局部("unit", "Master", 参数.主人单位);

  if (参数.召唤物单位 != null && 参数.召唤物单位 !== 0) {
    写局部("unit", "Summon", 参数.召唤物单位);
  }

  const 单位类型 = 归一化单位类型(参数.单位类型);
  if (单位类型 !== 0) {
    写局部("integer", "unitType", 单位类型);
  }

  写局部("real", "x", 参数.X);
  写局部("real", "y", 参数.Y);
  写局部("real", "facing", 参数.朝向 ?? 0.0);
  写局部("real", "time", 参数.持续时间 ?? 0.0);
  写局部("string", "ModelFileID", 参数.模型文件 ?? "");

  if (参数.飞行高度 != null) {
    写局部("real", "moveHeight", 参数.飞行高度);
  }
  if (参数.生命值 != null) {
    写局部("real", "HP", 参数.生命值);
  }
  if (参数.生命回复 != null) {
    写局部("real", "regenHP", 参数.生命回复);
  }
  if (参数.攻击力 != null) {
    写局部("real", "AttackPower", 参数.攻击力);
  }
  if (参数.攻击间隔 != null) {
    // 旧 JASS 模板这里存在 `MoveHeight` / `atkCd` 的大小写/命名混用，统一双写兼容。
    写局部("real", "MoveHeight", 参数.攻击间隔);
    写局部("real", "atkCd", 参数.攻击间隔);
  }
  if (参数.护甲 != null) {
    写局部("real", "def", 参数.护甲);
  }
  if (参数.缩放 != null) {
    写局部("real", "size", 参数.缩放);
  }
}

export function 创建召唤物并套用JASS模板(参数: 召唤物参数): any {
  if (参数.主人单位 == null || 参数.主人单位 === 0) return null;
  if ((参数.召唤物单位 == null || 参数.召唤物单位 === 0) && 归一化单位类型(参数.单位类型) === 0) {
    return null;
  }

  const YDLOC = 获取YDLOC();
  if (!YDLOC) return null;

  const prevSIndex = 取GSIndex();
  const prevLIndex = 取GLIndex();
  const parentPage = 分配临时父页();

  设GSIndex(parentPage);
  设GLIndex(parentPage);
  写入召唤参数(参数);
  触发STES事件(SUMMON_STES_EVENT);

  const 召唤物 = 读局部("unit", "Summon");

  jass.FlushChildHashtable(YDLOC, parentPage);
  设GSIndex(prevSIndex);
  设GLIndex(prevLIndex);

  return 召唤物 != null && 召唤物 !== 0 ? 召唤物 : null;
}

export function 快捷创建召唤物(
  主人单位: any,
  单位类型: string | number,
  X: number,
  Y: number,
  持续时间: number,
  额外参数?: Omit<召唤物参数, "主人单位" | "单位类型" | "X" | "Y" | "持续时间">
): any {
  return 创建召唤物并套用JASS模板({
    主人单位,
    单位类型,
    X,
    Y,
    持续时间,
    ...额外参数,
  });
}

export {};
