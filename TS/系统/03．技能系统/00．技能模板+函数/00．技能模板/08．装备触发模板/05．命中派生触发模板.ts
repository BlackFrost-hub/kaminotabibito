/** @noSelfInFile */

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const jass = require("jass.common") as any;
const {
  单位持有装备,
  取装备冷却键,
  装备冷却中,
  取装备冷却剩余毫秒,
  设置装备冷却,
  进入装备冷却并显示,
  显示单位装备冷却,
  获取单位装备物品,
  取装备显示冷却剩余,
  装备概率通过,
} = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.08．装备识别与冷却") as {
  单位持有装备: (this: void, unit: any, 装备名: string) => boolean;
  取装备冷却键: (this: void, unit: any, tag: string, 前缀?: string) => string;
  装备冷却中: (this: void, key: string) => boolean;
  取装备冷却剩余毫秒: (this: void, key: string) => number;
  设置装备冷却: (this: void, key: string, 秒数: number) => void;
  进入装备冷却并显示: (this: void, key: string, 秒数: number, unit: any, 装备名: string) => void;
  显示单位装备冷却: (this: void, unit: any, 装备名: string, 冷却键: string, 类型?: "独有" | "公共" | "其他" | "主动") => void;
  获取单位装备物品: (this: void, unit: any, 装备名: string) => any | null;
  取装备显示冷却剩余: (this: void, hero: any, item: any, 冷却键: string) => number;
  装备概率通过: (this: void, unit: any, chance: number) => boolean;
};
const { 单位存活, 是技能伤害, 是纯普攻, 是敌对单位 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.09．装备战斗判断") as {
  单位存活: (this: void, unit: any) => boolean;
  是技能伤害: (this: void, snapshot: any) => boolean;
  是纯普攻: (this: void, snapshot: any) => boolean;
  是敌对单位: (this: void, source: any, target: any) => boolean;
};
const { 造成装备伤害, 取范围敌人 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行") as {
  造成装备伤害: (this: void, source: any, target: any, amount: number, damageType: any, ranged?: boolean, weaponType?: any, 选项?: any) => void;
  取范围敌人: (this: void, source: any, target: any, radius: number) => any[];
};
const { 设置物品栏物品冷却 } = require("系统.09．表现系统.01．UI工具.07．物品栏冷却显示") as {
  设置物品栏物品冷却: (this: void, hero: any, item: any, durationMs: number) => void;
};
const { 创建窗口事件计数器 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.15．单位窗口累计值") as {
  创建窗口事件计数器: (this: void, 名称: string) => 窗口事件计数器控制器;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;

export type 命中派生持有者 = "攻击者" | "受击者";
export type 命中派生过滤 =
  | "任意"
  | "技能"
  | "主动技能"
  | "装备技能"
  | "装备主动"
  | "纯普攻"
  | "技能或纯普攻"
  | "主动技能或纯普攻"
  | "装备主动或纯普攻";
export type 命中计数作用域 = "持有者" | "持有者目标";

export interface 命中派生触发事件 {
  目标: any;
  攻击者: any;
  持有者: any;
  本次伤害: number;
  伤害快照: any;
  当前次数: number;
  冷却键: string;
  配置: 命中派生触发参数;
}

export interface 命中派生触发参数 {
  名称?: string;
  装备名: string;
  持有者?: 命中派生持有者;
  命中过滤?: 命中派生过滤;
  概率?: number;
  冷却秒数?: number;
  冷却标签?: string;
  冷却前缀?: string;
  命中减冷却秒数?: number;
  窗口秒数?: number;
  次数阈值?: number;
  计数作用域?: 命中计数作用域;
  触发后清空次数?: boolean;
  要求双方存活?: boolean;
  要求敌对?: boolean;
  自定义过滤?: (this: void, event: 命中派生触发事件) => boolean;
  on触发: (this: void, event: 命中派生触发事件) => void;
}

export interface 命中派生触发控制器 {
  readonly 名称: string;
  读取次数(this: void, 持有者: any, 目标?: any): number;
  清空(this: void, 持有者?: any, 目标?: any): void;
  停止(this: void): void;
}

interface 窗口事件计数器控制器 {
  readonly 名称: string;
  增加(key: string, 窗口秒: number, 触发后清空?: boolean, 触发阈值?: number): number;
  读取(key: string, 窗口秒?: number): number;
  清空(key?: string): void;
}

interface 命中派生触发记录 extends 命中派生触发控制器 {
  ID: number;
  配置: 命中派生触发参数;
  计数器: 窗口事件计数器控制器;
  已停止: boolean;
}

export type 命中伤害数值 = number | ((this: void, event: 命中派生触发事件) => number);

export interface 主动命中额外伤害参数 extends Omit<命中派生触发参数, "on触发"> {
  伤害: 命中伤害数值;
  伤害类型: any;
  伤害标签?: string;
  ranged?: boolean;
  weaponType?: any;
}

export interface 主动命中AOE伤害参数 extends 主动命中额外伤害参数 {
  范围: number;
}

const 命中派生触发记录表: Record<number, 命中派生触发记录 | undefined> = {};
let 命中派生触发计数 = 0;

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取持有者(this: void, target: any, attacker: any, config: 命中派生触发参数): any {
  return (config.持有者 ?? "攻击者") === "受击者" ? target : attacker;
}

function 是装备技能命中(this: void, snapshot: any): boolean {
  return snapshot != null && snapshot.isEquipmentSkillDamage === true;
}

function 是装备主动命中(this: void, snapshot: any): boolean {
  if (!是装备技能命中(snapshot)) return false;
  const kind = snapshot.equipmentSkillDamageKind ?? snapshot.skillDamageSourceKind;
  return kind === "装备主动" || kind === "物品技能";
}

function 是装备技能来源标记(this: void, kind: string | undefined): boolean {
  return kind === "装备技能"
    || kind === "装备主动"
    || kind === "装备被动"
    || kind === "物品技能"
    || kind === "装备持续伤害";
}

function 是主动技能命中(this: void, snapshot: any): boolean {
  if (!是技能伤害(snapshot)) return false;
  if (snapshot.isEquipmentSkillDamage === true) return false;
  if (是装备技能来源标记(snapshot.equipmentSkillDamageKind)) return false;
  if (是装备技能来源标记(snapshot.skillDamageSourceKind)) return false;
  return true;
}

function 通过命中过滤(this: void, snapshot: any, config: 命中派生触发参数): boolean {
  const filter = config.命中过滤 ?? "任意";
  if (filter === "技能") return 是技能伤害(snapshot);
  if (filter === "主动技能") return 是主动技能命中(snapshot);
  if (filter === "装备技能") return 是装备技能命中(snapshot);
  if (filter === "装备主动") return 是装备主动命中(snapshot);
  if (filter === "纯普攻") return 是纯普攻(snapshot);
  if (filter === "技能或纯普攻") return 是技能伤害(snapshot) || 是纯普攻(snapshot);
  if (filter === "主动技能或纯普攻") return 是主动技能命中(snapshot) || 是纯普攻(snapshot);
  if (filter === "装备主动或纯普攻") return 是装备主动命中(snapshot) || 是纯普攻(snapshot);
  return true;
}

function 取冷却键(this: void, holder: any, record: 命中派生触发记录): string {
  const tag = record.配置.冷却标签 ?? record.配置.名称 ?? record.配置.装备名;
  return 取装备冷却键(holder, tag, record.配置.冷却前缀 ?? "装备命中派生触发");
}

function 同步冷却显示(this: void, holder: any, 装备名: string, key: string): void {
  if (key === "") return;
  显示单位装备冷却(holder, 装备名, key, "独有");
  const item = 获取单位装备物品(holder, 装备名);
  if (item == null || item === 0) return;
  设置物品栏物品冷却(holder, item, 取装备显示冷却剩余(holder, item, key));
}

function 命中减少冷却(this: void, holder: any, record: 命中派生触发记录, key: string): void {
  const reduceSec = record.配置.命中减冷却秒数 ?? 0;
  if (!(reduceSec > 0) || key === "") return;
  const remaining = 取装备冷却剩余毫秒(key);
  if (!(remaining > 0)) return;
  const next = remaining - reduceSec * 1000;
  设置装备冷却(key, next > 0 ? next / 1000 : 0);
  同步冷却显示(holder, record.配置.装备名, key);
}

function 冷却允许(this: void, key: string, record: 命中派生触发记录): boolean {
  const cd = record.配置.冷却秒数 ?? 0;
  if (!(cd > 0)) return true;
  return !装备冷却中(key);
}

function 记录冷却(this: void, holder: any, record: 命中派生触发记录, key: string): void {
  const cd = record.配置.冷却秒数 ?? 0;
  if (!(cd > 0)) return;
  进入装备冷却并显示(key, cd, holder, record.配置.装备名);
}

function 取计数键(this: void, holder: any, target: any, record: 命中派生触发记录): string {
  const holderId = 取单位ID(holder);
  if (holderId === 0) return "";
  if ((record.配置.计数作用域 ?? "持有者") !== "持有者目标") return String(holderId);
  const targetId = 取单位ID(target);
  if (targetId === 0) return "";
  return String(holderId) + ":" + String(targetId);
}

function 读取计数状态次数(this: void, record: 命中派生触发记录, key: string): number {
  if (key === "") return 0;
  return record.计数器.读取(key, record.配置.窗口秒数 ?? 0);
}

function 通过次数并记录(this: void, holder: any, target: any, record: 命中派生触发记录): number {
  const threshold = record.配置.次数阈值 ?? 1;
  if (!(threshold > 1)) return 1;
  const key = 取计数键(holder, target, record);
  if (key === "") return 0;
  return record.计数器.增加(key, record.配置.窗口秒数 ?? 0, record.配置.触发后清空次数 !== false, threshold);
}

function 尝试执行命中派生触发(this: void, target: any, attacker: any, applied: number, snapshot: any, record: 命中派生触发记录): void {
  if (record.已停止 || !(applied > 0)) return;
  const config = record.配置;
  const holder = 取持有者(target, attacker, config);
  if (holder == null || holder === 0) return;
  if (config.要求双方存活 !== false && (!单位存活(holder) || !单位存活((config.持有者 ?? "攻击者") === "受击者" ? attacker : target))) return;
  if (config.要求敌对 !== false && !是敌对单位(attacker, target)) return;
  if (!单位持有装备(holder, config.装备名)) return;
  if (!通过命中过滤(snapshot, config)) return;

  const key = 取冷却键(holder, record);
  命中减少冷却(holder, record, key);

  const event: 命中派生触发事件 = { 目标: target, 攻击者: attacker, 持有者: holder, 本次伤害: applied, 伤害快照: snapshot, 当前次数: 0, 冷却键: key, 配置: config };
  if (config.自定义过滤 != null && !config.自定义过滤(event)) return;
  if (!冷却允许(key, record)) return;

  const current = 通过次数并记录(holder, target, record);
  if (current <= 0) return;
  event.当前次数 = current;
  if (current < (config.次数阈值 ?? 1)) return;
  const chance = config.概率 ?? 1;
  if (!装备概率通过(holder, chance)) return;
  记录冷却(holder, record, key);
  config.on触发(event);
}

function on命中派生触发模板(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  for (const key in 命中派生触发记录表) {
    const record = 命中派生触发记录表[Number(key) || 0];
    if (record != null) 尝试执行命中派生触发(target, attacker, applied, snapshot, record);
  }
}

registerAppliedFinalDamageListener(on命中派生触发模板);

export function 注册命中派生触发模板(this: void, 配置: 命中派生触发参数): 命中派生触发控制器 {
  const id = ++命中派生触发计数;
  const record: 命中派生触发记录 = {
    ID: id,
    名称: 配置.名称 ?? ("命中派生触发#" + String(id)),
    配置,
    计数器: 创建窗口事件计数器(配置.名称 ?? ("命中派生触发#" + String(id))),
    已停止: false,
    读取次数: function 读取命中派生触发次数(this: void, 持有者: any, 目标?: any): number {
      return 读取计数状态次数(record, 取计数键(持有者, 目标, record));
    },
    清空: function 清空命中派生触发次数(this: void, 持有者?: any, 目标?: any): void {
      if (持有者 == null) {
        record.计数器.清空();
        return;
      }
      const key = 取计数键(持有者, 目标, record);
      if (key !== "") record.计数器.清空(key);
    },
    停止: function 停止命中派生触发(this: void): void {
      record.已停止 = true;
      record.计数器.清空();
      delete 命中派生触发记录表[id];
    },
  };
  命中派生触发记录表[id] = record;
  return record;
}

function 计算命中伤害(this: void, value: 命中伤害数值, event: 命中派生触发事件): number {
  if (typeof value === "number") return value;
  return value(event);
}

export function 注册主动命中额外伤害(this: void, 配置: 主动命中额外伤害参数): 命中派生触发控制器 {
  return 注册命中派生触发模板({
    ...配置,
    命中过滤: 配置.命中过滤 ?? "主动技能",
    on触发: function on主动命中额外伤害(this: void, event: 命中派生触发事件): void {
      const amount = 计算命中伤害(配置.伤害, event);
      造成装备伤害(event.持有者, event.目标, amount, 配置.伤害类型, 配置.ranged === true, 配置.weaponType, {
        装备技能类型: "装备被动",
        标签: 配置.伤害标签 ?? 配置.名称 ?? 配置.装备名,
        伤害形态: "单体",
      });
    },
  });
}

export function 注册主动命中AOE伤害(this: void, 配置: 主动命中AOE伤害参数): 命中派生触发控制器 {
  return 注册命中派生触发模板({
    ...配置,
    命中过滤: 配置.命中过滤 ?? "主动技能",
    on触发: function on主动命中AOE伤害(this: void, event: 命中派生触发事件): void {
      const amount = 计算命中伤害(配置.伤害, event);
      const enemies = 取范围敌人(event.持有者, event.目标, 配置.范围);
      for (let i = 0; i < enemies.length; i++) {
        造成装备伤害(event.持有者, enemies[i], amount, 配置.伤害类型, 配置.ranged === true, 配置.weaponType, {
          装备技能类型: "装备被动",
          标签: 配置.伤害标签 ?? 配置.名称 ?? 配置.装备名,
          伤害形态: "AOE",
        });
      }
    },
  });
}

export {};
