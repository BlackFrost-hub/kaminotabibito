/** @noSelfInFile */

import { 创建不同技能序列状态, type 不同技能序列作用域, type 不同技能序列重复策略 } from "../../04．机制组件/10．复杂战斗通用机制/21．不同技能序列状态";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 单位持有装备, 是技能伤害 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助") as {
  单位持有装备: (this: void, unit: any, 装备名: string) => boolean;
  是技能伤害: (this: void, snapshot: any) => boolean;
};

export type 不同技能伤害序列触发时机 = "达成时" | "下一次技能伤害";

export interface 不同技能伤害序列事件 {
  攻击者: any;
  目标: any;
  本次伤害: number;
  伤害快照: any;
  技能键: string;
}

export interface 不同技能伤害序列触发参数 {
  名称: string;
  装备名: string;
  需要不同技能数: number;
  时间窗毫秒: number;
  作用域?: 不同技能序列作用域;
  重复策略?: 不同技能序列重复策略;
  触发时机?: 不同技能伤害序列触发时机;
  过滤事件?: (this: void, event: 不同技能伤害序列事件) => boolean;
  取技能键?: (this: void, event: 不同技能伤害序列事件) => string;
  on触发: (this: void, event: 不同技能伤害序列事件) => void;
}

export interface 不同技能伤害序列触发控制器 {
  readonly 名称: string;
  清空(this: void): void;
  停止(this: void): void;
}

interface 不同技能伤害序列记录 {
  ID: number;
  参数: 不同技能伤害序列触发参数;
  状态: ReturnType<typeof 创建不同技能序列状态<any, any>>;
  已停止: boolean;
}

const 记录表: Record<number, 不同技能伤害序列记录 | undefined> = {};
let 下一个ID = 0;

function 默认取技能键(this: void, event: 不同技能伤害序列事件): string {
  const snapshot = event.伤害快照;
  return String(snapshot?.abilityId ?? snapshot?.skillInstanceId ?? snapshot?.tag ?? "");
}

function 尝试触发记录(this: void, record: 不同技能伤害序列记录, target: any, attacker: any, applied: number, snapshot: any): void {
  if (record.已停止 || !(applied > 0) || !单位持有装备(attacker, record.参数.装备名) || !是技能伤害(snapshot)) return;
  const event: 不同技能伤害序列事件 = { 攻击者: attacker, 目标: target, 本次伤害: applied, 伤害快照: snapshot, 技能键: "" };
  event.技能键 = record.参数.取技能键 == null ? 默认取技能键(event) : record.参数.取技能键(event);
  if (event.技能键 === "" || (record.参数.过滤事件 != null && !record.参数.过滤事件(event))) return;
  const scopeTarget = (record.参数.作用域 ?? "主体") === "主体与目标" ? target : undefined;
  if ((record.参数.触发时机 ?? "达成时") === "下一次技能伤害") {
    const ready = record.状态.读取(attacker, scopeTarget);
    if (ready?.已就绪 === true) {
      record.状态.消耗(attacker, scopeTarget);
      record.参数.on触发(event);
      return;
    }
  }
  const result = record.状态.记录(attacker, event.技能键, scopeTarget);
  if ((record.参数.触发时机 ?? "达成时") === "达成时" && result?.刚刚就绪 === true) {
    record.状态.消耗(attacker, scopeTarget);
    record.参数.on触发(event);
  }
}

function on不同技能伤害序列(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  for (const key in 记录表) {
    const record = 记录表[Number(key) || 0];
    if (record != null) 尝试触发记录(record, target, attacker, applied, snapshot);
  }
}

registerAppliedFinalDamageListener(on不同技能伤害序列);

export function 注册不同技能伤害序列触发模板(this: void, 参数: 不同技能伤害序列触发参数): 不同技能伤害序列触发控制器 {
  const id = ++下一个ID;
  const record: 不同技能伤害序列记录 = {
    ID: id,
    参数,
    状态: 创建不同技能序列状态<any, any>({
      名称: 参数.名称,
      需要不同技能数: 参数.需要不同技能数,
      时间窗毫秒: 参数.时间窗毫秒,
      作用域: 参数.作用域,
      重复策略: 参数.重复策略,
    }),
    已停止: false,
  };
  记录表[id] = record;
  return {
    名称: 参数.名称,
    清空: function 清空(this: void): void { record.状态.清空全部(); },
    停止: function 停止(this: void): void { if (!record.已停止) { record.已停止 = true; record.状态.销毁(); delete 记录表[id]; } },
  };
}

export {};
