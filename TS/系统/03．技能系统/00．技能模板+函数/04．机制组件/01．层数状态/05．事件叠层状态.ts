/** @noSelfInFile */

import { 创建可配置层数状态, 可配置层数状态配置, 可配置层数状态控制器 } from "./01．可配置层数状态";

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, cb: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

export type 事件叠层触发来源 = "手动" | "普攻命中" | "造成伤害" | "受到伤害" | "释放英雄技能";
export type 事件叠层持续模式 = "无" | "刷新持续时间" | "独立持续时间";

export interface 事件叠层上下文 {
  来源: 事件叠层触发来源;
  单位: any;
  目标单位?: any;
  来源单位?: any;
  伤害值?: number;
  技能ID?: number;
  伤害快照?: any;
  原因?: string;
}

export interface 事件叠层满层事件 extends 事件叠层上下文 {
  当前层数: number;
  是否刚满层: boolean;
}

export interface 事件叠层状态参数 extends 可配置层数状态配置 {
  触发来源: 事件叠层触发来源 | 事件叠层触发来源[];
  每次层数?: number | ((this: void, ctx: 事件叠层上下文) => number);
  内置CD秒?: number;
  持续模式?: 事件叠层持续模式;
  层持续秒?: number;
  过滤事件?: (this: void, ctx: 事件叠层上下文) => boolean;
  on事件触发?: (this: void, ctx: 事件叠层上下文, 新层数: number) => void;
  on满层?: (this: void, event: 事件叠层满层事件) => void;
}

export interface 事件叠层状态控制器 {
  readonly 名称: string;
  手动触发(单位: any, 层数?: number, 原因?: string): number;
  消耗层数(单位: any, 层数?: number, 原因?: string): number;
  消耗全部(单位: any, 原因?: string): number;
  取层数(单位: any): number;
  清空(单位: any, 原因?: string): void;
  停止(): void;
}

interface 独立层记录 {
  层数: number;
  到期毫秒: number;
}

interface 事件叠层单位状态 {
  单位: any;
  下次允许毫秒: number;
  刷新到期毫秒: number;
  独立层: 独立层记录[];
  上次是否满层: boolean;
}

const 事件叠层控制器表: Record<number, 事件叠层状态实现> = {};
let 事件叠层控制器计数 = 0;
let 事件叠层过期TickID = 0;

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

function 取单位ID(this: void, 单位: any): number {
  if (!单位有效(单位)) return 0;
  return GetHandleId(单位) || 0;
}

function 来源匹配(this: void, 配置来源: 事件叠层触发来源 | 事件叠层触发来源[], 来源: 事件叠层触发来源): boolean {
  if (typeof 配置来源 === "string") return 配置来源 === 来源;
  for (let i = 0; i < 配置来源.length; i++) {
    if (配置来源[i] === 来源) return true;
  }
  return false;
}

function 确保事件叠层Tick(this: void): void {
  if (事件叠层过期TickID !== 0) return;
  事件叠层过期TickID = addPeriodicCallback(200, on事件叠层过期Tick);
}

function 尝试停止事件叠层Tick(this: void): void {
  for (const key in 事件叠层控制器表) {
    if (事件叠层控制器表[key] != null) return;
  }
  if (事件叠层过期TickID !== 0) {
    removePeriodicCallback(事件叠层过期TickID);
    事件叠层过期TickID = 0;
  }
}

function on事件叠层过期Tick(this: void): void {
  const now = getServerTime();
  for (const key in 事件叠层控制器表) {
    const 控制器 = 事件叠层控制器表[key];
    if (控制器 != null) 控制器.推进过期(now);
  }
}

class 事件叠层状态实现 implements 事件叠层状态控制器 {
  readonly 名称: string;
  readonly 控制器ID: number;
  private 参数: 事件叠层状态参数;
  private 层数控制器: 可配置层数状态控制器;
  private 单位状态表: Record<number, 事件叠层单位状态> = {};
  private 已停止 = false;

  constructor(名称: string, 参数: 事件叠层状态参数) {
    this.名称 = 名称;
    this.参数 = 参数;
    this.层数控制器 = 创建可配置层数状态(参数);
    this.控制器ID = ++事件叠层控制器计数;
    事件叠层控制器表[this.控制器ID] = this;
    确保事件叠层Tick();
  }

  手动触发(单位: any, 层数?: number, 原因: string = "手动触发"): number {
    return this.处理事件({ 来源: "手动", 单位, 原因 }, 层数);
  }

  处理事件(ctx: 事件叠层上下文, 指定层数?: number): number {
    if (this.已停止) return 0;
    if (!来源匹配(this.参数.触发来源, ctx.来源)) return this.层数控制器.取层数(ctx.单位);
    if (!单位有效(ctx.单位)) return 0;
    if (this.参数.过滤事件 != null && !this.参数.过滤事件(ctx)) return this.层数控制器.取层数(ctx.单位);

    const now = getServerTime();
    const 状态 = this.取或建单位状态(ctx.单位);
    if (now < 状态.下次允许毫秒) return this.层数控制器.取层数(ctx.单位);

    const 增加层数 = 指定层数 != null ? 指定层数 : this.计算增加层数(ctx);
    if (增加层数 <= 0) return this.层数控制器.取层数(ctx.单位);
    const 内置CD秒 = this.参数.内置CD秒 ?? 0;
    if (内置CD秒 > 0) 状态.下次允许毫秒 = now + 内置CD秒 * 1000;

    const 旧层数 = this.层数控制器.取层数(ctx.单位);
    const 新层数 = this.应用层数增加(ctx.单位, 增加层数, ctx.原因 ?? ctx.来源, now);
    if (this.参数.on事件触发 != null) this.参数.on事件触发(ctx, 新层数);
    this.尝试触发满层(ctx, 状态, 旧层数, 新层数);
    return 新层数;
  }

  消耗层数(单位: any, 层数: number = 1, 原因: string = "消耗层数"): number {
    const 当前层数 = this.层数控制器.取层数(单位);
    const 实际消耗 = 层数 > 当前层数 ? 当前层数 : 层数;
    const 新层数 = this.层数控制器.减少(单位, 实际消耗, 原因);
    this.重建持续记录到当前层数(单位, 新层数);
    return 实际消耗;
  }

  消耗全部(单位: any, 原因: string = "消耗全部"): number {
    const 当前层数 = this.层数控制器.取层数(单位);
    this.清空(单位, 原因);
    return 当前层数;
  }

  取层数(单位: any): number {
    return this.层数控制器.取层数(单位);
  }

  清空(单位: any, 原因: string = "清空"): void {
    const id = 取单位ID(单位);
    if (id !== 0) delete this.单位状态表[id];
    this.层数控制器.清空(单位, 原因);
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    this.层数控制器.销毁();
    this.单位状态表 = {};
    delete 事件叠层控制器表[this.控制器ID];
    尝试停止事件叠层Tick();
  }

  推进过期(now: number): void {
    const 持续模式 = this.参数.持续模式 ?? "无";
    if (持续模式 === "无") return;
    for (const key in this.单位状态表) {
      const 状态 = this.单位状态表[key];
      if (状态 == null) continue;
      if (持续模式 === "刷新持续时间") {
        if (状态.刷新到期毫秒 > 0 && now >= 状态.刷新到期毫秒) this.清空ByID(Number(key), "持续时间到期");
        continue;
      }
      this.推进独立层过期(Number(key), 状态, now);
    }
  }

  private 计算增加层数(ctx: 事件叠层上下文): number {
    const 每次层数 = this.参数.每次层数;
    if (typeof 每次层数 === "function") return 每次层数(ctx);
    return 每次层数 ?? 1;
  }

  private 应用层数增加(单位: any, 层数: number, 原因: string, now: number): number {
    const 持续模式 = this.参数.持续模式 ?? "无";
    const 持续秒 = this.参数.层持续秒 ?? 0;
    const 状态 = this.取或建单位状态(单位);
    if (持续模式 === "刷新持续时间" && 持续秒 > 0) 状态.刷新到期毫秒 = now + 持续秒 * 1000;
    if (持续模式 === "独立持续时间" && 持续秒 > 0) {
      状态.独立层.push({ 层数, 到期毫秒: now + 持续秒 * 1000 });
      const 总层数 = this.计算独立层总和(状态);
      return this.层数控制器.设置(单位, 总层数, 原因);
    }
    return this.层数控制器.增加(单位, 层数, 原因);
  }

  private 尝试触发满层(ctx: 事件叠层上下文, 状态: 事件叠层单位状态, 旧层数: number, 新层数: number): void {
    const 已满层 = 新层数 >= this.参数.最大层数;
    const 刚满层 = 旧层数 < this.参数.最大层数 && 已满层;
    if (!已满层) {
      状态.上次是否满层 = false;
      return;
    }
    if (this.参数.on满层 != null && (!状态.上次是否满层 || 刚满层)) {
      this.参数.on满层({
        ...ctx,
        当前层数: 新层数,
        是否刚满层: 刚满层,
      });
    }
    状态.上次是否满层 = true;
  }

  private 取或建单位状态(单位: any): 事件叠层单位状态 {
    const id = 取单位ID(单位);
    let 状态 = this.单位状态表[id];
    if (状态 == null) {
      状态 = {
        单位,
        下次允许毫秒: 0,
        刷新到期毫秒: 0,
        独立层: [],
        上次是否满层: false,
      };
      this.单位状态表[id] = 状态;
    }
    return 状态;
  }

  private 推进独立层过期(id: number, 状态: 事件叠层单位状态, now: number): void {
    let changed = false;
    for (let i = 状态.独立层.length - 1; i >= 0; i--) {
      if (now < 状态.独立层[i].到期毫秒) continue;
      状态.独立层.splice(i, 1);
      changed = true;
    }
    if (!changed) return;
    const 单位 = this.读取单位引用(id);
    if (单位 == null) {
      delete this.单位状态表[id];
      return;
    }
    this.层数控制器.设置(单位, this.计算独立层总和(状态), "独立层到期");
  }

  private 计算独立层总和(状态: 事件叠层单位状态): number {
    let 总数 = 0;
    for (let i = 0; i < 状态.独立层.length; i++) 总数 += 状态.独立层[i].层数;
    return 总数;
  }

  private 重建持续记录到当前层数(单位: any, 当前层数: number): void {
    const id = 取单位ID(单位);
    const 状态 = this.单位状态表[id];
    if (状态 == null) return;
    if (当前层数 <= 0) {
      delete this.单位状态表[id];
      return;
    }
    if ((this.参数.持续模式 ?? "无") === "独立持续时间") {
      状态.独立层 = [{ 层数: 当前层数, 到期毫秒: getServerTime() + (this.参数.层持续秒 ?? 0) * 1000 }];
    }
  }

  private 清空ByID(id: number, 原因: string): void {
    const 单位 = this.读取单位引用(id);
    delete this.单位状态表[id];
    if (单位 != null) this.层数控制器.清空(单位, 原因);
  }

  private 读取单位引用(id: number): any {
    const 状态 = this.单位状态表[id];
    if (状态 == null) return null;
    return 状态.单位;
  }
}

export function 创建事件叠层状态(this: void, 参数: 事件叠层状态参数): 事件叠层状态控制器 {
  return new 事件叠层状态实现(参数.状态ID, 参数);
}

function 分发事件叠层(ctx: 事件叠层上下文): void {
  for (const key in 事件叠层控制器表) {
    const 控制器 = 事件叠层控制器表[key];
    if (控制器 != null) 控制器.处理事件(ctx);
  }
}

function on事件叠层伤害事件(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (applied <= 0) return;
  if (单位有效(attacker)) {
    分发事件叠层({
      来源: snapshot != null && snapshot.isNormalAttack === true ? "普攻命中" : "造成伤害",
      单位: attacker,
      目标单位: target,
      伤害值: applied,
      伤害快照: snapshot,
      原因: "伤害事件",
    });
  }
  if (单位有效(target)) {
    分发事件叠层({
      来源: "受到伤害",
      单位: target,
      来源单位: attacker,
      伤害值: applied,
      伤害快照: snapshot,
      原因: "受到伤害",
    });
  }
}

function on事件叠层施法事件(this: void, castingUnit: any, spellAbilityId: number): void {
  if (!单位有效(castingUnit)) return;
  分发事件叠层({
    来源: "释放英雄技能",
    单位: castingUnit,
    技能ID: spellAbilityId,
    原因: "释放英雄技能",
  });
}

registerAppliedFinalDamageListener(on事件叠层伤害事件);
registerSpellEffectListener(on事件叠层施法事件);
