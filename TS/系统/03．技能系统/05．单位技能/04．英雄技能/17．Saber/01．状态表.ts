/** @noSelfInFile */
// Saber 专用同步状态表：Q 连击段数、Q 连击命中去重组、E 魔力放出状态、D 阿瓦隆状态。
// 所有读写都在同步游戏逻辑中进行；禁止在本地分支读取状态决定玩法。
// 源 JASS 中这些状态分别存放在 YDUserData "Q连击"/"风王结界单位组"/"B01A"/"阿瓦隆"。

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;

export interface Saber状态 {
  英雄句柄ID: number;
  施法者: any;
  Q连击: number; // 0=初始 1=初段已命中 2=连击2已施放 3=连击3已施放
  Q命中组: Record<number, boolean>; // 整套 Q 连击共用的命中去重（源：风王结界单位组）
  E开启: boolean;
  E攻击加成值: number; // E 开启时加上的攻击力加成，结束时按原值撤销
  阿瓦隆: boolean;
}

const 状态表: Record<number, Saber状态> = {};

export function 获取或创建Saber状态(this: void, caster: any): Saber状态 {
  const id = GetHandleId(caster);
  let record = 状态表[id];
  if (record == null) {
    record = {
      英雄句柄ID: id,
      施法者: caster,
      Q连击: 0,
      Q命中组: {},
      E开启: false,
      E攻击加成值: 0,
      阿瓦隆: false,
    };
    状态表[id] = record;
  }
  return record;
}

export function 获取Saber状态(this: void, caster: any): Saber状态 | undefined {
  if (caster == null || caster === 0) return undefined;
  return 状态表[GetHandleId(caster)];
}

export function Saber开启E(this: void, caster: any, 攻击加成值: number): void {
  const record = 获取或创建Saber状态(caster);
  record.E开启 = true;
  record.E攻击加成值 = 攻击加成值;
}

/** 结束 E 状态（正常到期 / 被 W 地面联动消耗）。撤销攻击力由 E 技能文件按 record.E攻击加成值 处理。 */
export function Saber关闭E(this: void, caster: any): void {
  const record = 获取Saber状态(caster);
  if (record == null) return;
  record.E开启 = false;
}

export function Saber是否E开启(this: void, caster: any): boolean {
  const record = 获取Saber状态(caster);
  return record != null && record.E开启;
}

export function 读取SaberE攻击加成值(this: void, caster: any): number {
  const record = 获取Saber状态(caster);
  return record != null ? record.E攻击加成值 : 0;
}

export function Saber设置阿瓦隆(this: void, caster: any, flag: boolean): void {
  const record = 获取或创建Saber状态(caster);
  record.阿瓦隆 = flag;
}

export function Saber是否阿瓦隆(this: void, caster: any): boolean {
  const record = 获取Saber状态(caster);
  return record != null && record.阿瓦隆;
}

export function SaberQ命中去重添加(this: void, caster: any, target: any): void {
  if (target == null || target === 0) return;
  const record = 获取或创建Saber状态(caster);
  record.Q命中组[GetHandleId(target)] = true;
}

export function SaberQ命中去重包含(this: void, caster: any, target: any): boolean {
  if (target == null || target === 0) return false;
  const record = 获取Saber状态(caster);
  return record != null && record.Q命中组[GetHandleId(target)] === true;
}

export function Saber清空Q命中组(this: void, caster: any): void {
  const record = 获取Saber状态(caster);
  if (record == null) return;
  record.Q命中组 = {};
}

/** 死亡/英雄替换时清理全部临时状态（各技能文件自身的计时器由各自清理）。 */
export function 清理Saber状态(this: void, caster: any): void {
  if (caster == null || caster === 0) return;
  delete 状态表[GetHandleId(caster)];
}

export {};
