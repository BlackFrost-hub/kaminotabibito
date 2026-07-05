/** @noSelfInFile */

const jass = require("jass.common") as any;
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const {
  技能伤害实例存在,
  标记技能伤害实例首次命中,
} = require("系统.04．伤害系统.08．技能伤害系统") as {
  技能伤害实例存在: (this: void, id: number | undefined) => boolean;
  标记技能伤害实例首次命中: (this: void, id: number | undefined) => boolean;
};

const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (unit: any, player: any) => boolean;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

export type 技能首次命中来源过滤 = "任意非装备技能" | "单位技能" | "Boss技能" | "召唤物技能";

export interface 技能首次伤害命中事件 {
  施法者: any;
  目标: any;
  本次伤害: number;
  技能实例ID: number;
  技能ID?: number;
  来源类型?: string;
  标签?: string;
  伤害快照: any;
  配置: 技能首次伤害命中参数;
}

export interface 技能首次伤害命中参数 {
  名称?: string;
  来源过滤?: 技能首次命中来源过滤;
  技能ID?: number;
  标签?: string;
  自定义过滤?: (this: void, event: 技能首次伤害命中事件) => boolean;
  on首次命中: (this: void, event: 技能首次伤害命中事件) => void;
}

export interface 技能首次伤害命中控制器 {
  id: number;
  名称: string;
  停止(this: void): void;
}

interface 技能首次伤害命中记录 extends 技能首次伤害命中控制器 {
  配置: 技能首次伤害命中参数;
}

const 技能首次伤害命中记录表: Record<number, 技能首次伤害命中记录 | undefined> = {};
let 技能首次伤害命中自增ID = 0;

function 单位有效存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 是敌方命中(this: void, attacker: any, target: any): boolean {
  if (!单位有效存活(attacker) || !单位有效存活(target)) return false;
  return IsUnitEnemy(target, GetOwningPlayer(attacker));
}

function 通过来源过滤(this: void, snapshot: any, 来源过滤: 技能首次命中来源过滤 | undefined): boolean {
  if (snapshot == null || snapshot.isWrappedSkillDamage !== true) return false;
  if (snapshot.isEquipmentSkillDamage === true) return false;
  const sourceKind = snapshot.skillDamageSourceKind;
  const filter = 来源过滤 ?? "任意非装备技能";
  if (filter === "任意非装备技能") return sourceKind === "单位技能" || sourceKind === "Boss技能" || sourceKind === "召唤物技能";
  return sourceKind === filter;
}

function 创建事件(this: void, target: any, attacker: any, applied: number, snapshot: any, record: 技能首次伤害命中记录): 技能首次伤害命中事件 {
  return {
    施法者: attacker,
    目标: target,
    本次伤害: applied,
    技能实例ID: snapshot.skillInstanceId,
    技能ID: snapshot.abilityId,
    来源类型: snapshot.skillDamageSourceKind,
    标签: snapshot.skillDamageTag,
    伤害快照: snapshot,
    配置: record.配置,
  };
}

function 尝试触发技能首次伤害命中(this: void, target: any, attacker: any, applied: number, snapshot: any, record: 技能首次伤害命中记录): void {
  if (!(applied > 0)) return;
  if (!是敌方命中(attacker, target)) return;
  const config = record.配置;
  if (!通过来源过滤(snapshot, config.来源过滤)) return;
  const instanceId = snapshot?.skillInstanceId;
  if (instanceId == null || instanceId <= 0 || !技能伤害实例存在(instanceId)) return;
  if (config.技能ID != null && snapshot.abilityId !== config.技能ID) return;
  if (config.标签 != null && snapshot.skillDamageTag !== config.标签) return;

  const event = 创建事件(target, attacker, applied, snapshot, record);
  if (config.自定义过滤 != null && !config.自定义过滤(event)) return;
  if (!标记技能伤害实例首次命中(instanceId)) return;
  config.on首次命中(event);
}

function on技能首次伤害命中最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  for (const key in 技能首次伤害命中记录表) {
    const record = 技能首次伤害命中记录表[Number(key) || 0];
    if (record != null) 尝试触发技能首次伤害命中(target, attacker, applied, snapshot, record);
  }
}

registerAppliedFinalDamageListener(on技能首次伤害命中最终伤害);

export function 注册技能首次伤害命中模板(this: void, 配置: 技能首次伤害命中参数): 技能首次伤害命中控制器 {
  const id = ++技能首次伤害命中自增ID;
  const record: 技能首次伤害命中记录 = {
    id,
    名称: 配置.名称 ?? ("技能首次伤害命中#" + String(id)),
    配置,
    停止: function 停止技能首次伤害命中模板(this: void): void {
      delete 技能首次伤害命中记录表[id];
    },
  };
  技能首次伤害命中记录表[id] = record;
  return record;
}

export {};
