/** @noSelfInFile */
// 云端运行时状态表：W 光暗交替状态机、E 被动触发冷却。
// 源 YDUserData(unit, 云端, "MJ"/"无双剑法") 全局表迁移为单位级状态记录，句柄ID 索引。
// 计划第 6.2.7 节：W 的本次分支必须在施法入口锁存，禁止延迟回调读共享状态。

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;

export interface 云端状态 {
  英雄句柄ID: number;
  施法者: any;
  // W：光暗交替。true = 下一发为光剑（源 MJ 默认 false 首发走光剑分支，按介绍口径首发为光剑）
  W下一发为光剑: boolean;
  // E：无双剑法 8 秒触发冷却
  E冷却中: boolean;
  E冷却回调ID: number;
}

const 状态表: Record<number, 云端状态> = {};

export function 获取或创建云端状态(this: void, 单位: any): 云端状态 {
  const id = GetHandleId(单位);
  let record = 状态表[id];
  if (record == null) {
    record = {
      英雄句柄ID: id,
      施法者: 单位,
      W下一发为光剑: true,
      E冷却中: false,
      E冷却回调ID: 0,
    };
    状态表[id] = record;
  }
  return record;
}

export function 获取云端状态(this: void, 单位: any): 云端状态 | undefined {
  if (单位 == null || 单位 === 0) return undefined;
  return 状态表[GetHandleId(单位)];
}

/** W 施法入口调用：取走本次光/暗分支并切换下一发状态（同步入口一次确定）。 */
export function 消耗云端W模式(this: void, 单位: any): "光剑" | "暗剑" {
  const record = 获取或创建云端状态(单位);
  const 本次 = record.W下一发为光剑 ? "光剑" : "暗剑";
  record.W下一发为光剑 = !record.W下一发为光剑;
  return 本次;
}

export function 云端E是否冷却中(this: void, 单位: any): boolean {
  const record = 获取云端状态(单位);
  return record != null && record.E冷却中 === true;
}

export function 设置云端E冷却(this: void, 单位: any, 冷却中: boolean): void {
  获取或创建云端状态(单位).E冷却中 = 冷却中;
}

export {};
