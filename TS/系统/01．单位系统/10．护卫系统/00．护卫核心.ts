/** @noSelfInFile */

const jass = require("jass.common") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { addDelayedCallback, addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { IsUnitPausedBJ } = require("lib.扩展函数.BJ函数.08．单位BJ扩展") as {
  IsUnitPausedBJ: (this: void, unit: any) => boolean;
};
const { isValidCombatEnemyUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isValidCombatEnemyUnit: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { 获取应攻击目标 } = require("系统.01．单位系统.06．仇恨系统.02．目标选择") as {
  获取应攻击目标: (this: void, enemy: any, filter?: (entry: { targetHid: number; targetRef: any; threat: number }) => boolean) => { targetHid: number; targetRef: any; threat: number } | null;
};

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UnitAddType = jass.UnitAddType as (unit: any, unitType: any) => boolean;
const KillUnit = jass.KillUnit as (unit: any) => void;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitCurrentOrder = jass.GetUnitCurrentOrder as (unit: any) => number;
const IsPlayerInForce = jass.IsPlayerInForce as (player: any, whichForce: any) => boolean;
const CreateGroup = jass.CreateGroup as () => any;
const DestroyGroup = jass.DestroyGroup as (group: any) => void;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (group: any, x: number, y: number, radius: number, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (group: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (group: any, unit: any) => void;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;
const IssuePointOrder = jass.IssuePointOrder as (unit: any, order: string, x: number, y: number) => boolean;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const OrderId = jass.OrderId as (order: string) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_TYPE_SUMMONED = jass.UNIT_TYPE_SUMMONED as any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;

const 护卫驱动间隔毫秒 = 250;
const 护卫保护Boss范围 = 1500;
const 护卫返回Boss距离 = 300;
const 护卫返回点到达距离平方 = 80 * 80;
const 护卫返回点Boss移动刷新距离平方 = 100 * 100;
const 角度转弧度 = 0.017453292519943295;
const 攻击命令ID = OrderId("attack");
const 攻击一次命令ID = OrderId("attackonce");
const 移动命令ID = OrderId("move");
const 停止命令ID = OrderId("stop");
const 保持命令ID = OrderId("holdposition");

export interface 护卫登记参数 {
  主Boss单位: any;
  护卫类型: string;
  标记为召唤单位?: boolean;
  护卫血条优先级?: number;
  Boss结束处理?: Boss结束护卫处理;
  on死亡?: (this: void, 护卫单位: any, 击杀单位: any, 记录: 护卫记录) => void;
}

export type Boss结束护卫处理 = "击杀" | "移除" | "注销";

export interface 护卫创建参数 extends 护卫登记参数 {
  单位类型: string | number;
  所属玩家?: any;
  X: number;
  Y: number;
  面向?: number;
}

export interface 护卫记录 {
  护卫单位: any;
  主Boss单位: any;
  护卫类型: string;
  是否召唤单位: boolean;
  护卫血条优先级: number;
  Boss结束处理: Boss结束护卫处理;
  on死亡?: (this: void, 护卫单位: any, 击杀单位: any, 记录: 护卫记录) => void;
  登记顺序: number;
}

export type 自定义护卫创建器 = (this: void) => any;

const 按护卫句柄索引的记录表: Record<number, 护卫记录 | undefined> = {};
const 按Boss句柄索引的护卫句柄表: Record<number, number[] | undefined> = {};
let 护卫登记顺序计数 = 0;
let 护卫驱动回调ID = 0;

interface 护卫驱动状态 {
  模式: "无" | "攻击" | "回位";
  攻击目标ID: number;
  返回角度: number;
  返回目标X: number;
  返回目标Y: number;
  返回锚点BossX: number;
  返回锚点BossY: number;
}

const 按护卫句柄索引的驱动状态表: Record<number, 护卫驱动状态 | undefined> = {};

function 获取句柄ID(this: void, handle: any): number {
  if (handle == null || handle === 0) return 0;
  return GetHandleId(handle) || 0;
}

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 创建空驱动状态(this: void): 护卫驱动状态 {
  return {
    模式: "无",
    攻击目标ID: 0,
    返回角度: 0,
    返回目标X: 0,
    返回目标Y: 0,
    返回锚点BossX: 0,
    返回锚点BossY: 0,
  };
}

function 当前命令允许护卫驱动(this: void, guard: any): boolean {
  if (IsUnitPausedBJ(guard)) return false;
  const orderId = GetUnitCurrentOrder(guard) || 0;
  return orderId === 0
    || orderId === 攻击命令ID
    || orderId === 攻击一次命令ID
    || orderId === 移动命令ID
    || orderId === 停止命令ID
    || orderId === 保持命令ID;
}

function 单位可作为仇恨目标(this: void, entry: { targetRef: any }): boolean {
  return 单位存活(entry.targetRef);
}

function 获取护卫仇恨目标(this: void, guard: any): any {
  const entry = 获取应攻击目标(guard, 单位可作为仇恨目标);
  return entry == null ? null : entry.targetRef;
}

function 当前正在执行攻击命令(this: void, guard: any): boolean {
  const orderId = GetUnitCurrentOrder(guard) || 0;
  return orderId === 攻击命令ID || orderId === 攻击一次命令ID;
}

function 选择Boss附近战斗目标(this: void, boss: any, 玩家组: any): any {
  const group = CreateGroup();
  if (group == null || group === 0) return null;

  const bossX = GetUnitX(boss);
  const bossY = GetUnitY(boss);
  let result: any = null;
  let resultIsYDPlayer = false;
  let resultIsHero = false;
  let bestDistanceSq = 0;
  let bestHandleId = 0;

  GroupEnumUnitsInRange(group, bossX, bossY, 护卫保护Boss范围, null);
  while (true) {
    const candidate = FirstOfGroup(group);
    if (candidate == null || candidate === 0) break;
    GroupRemoveUnit(group, candidate);
    if (!isValidCombatEnemyUnit(candidate, boss)) continue;

    const owner = GetOwningPlayer(candidate);
    const candidateIsYDPlayer = 玩家组 != null
      && 玩家组 !== 0
      && owner != null
      && owner !== 0
      && IsPlayerInForce(owner, 玩家组);
    const candidateIsHero = IsUnitType(candidate, UNIT_TYPE_HERO) === true;
    const dx = GetUnitX(candidate) - bossX;
    const dy = GetUnitY(candidate) - bossY;
    const distanceSq = dx * dx + dy * dy;
    const handleId = 获取句柄ID(candidate);
    if (
      result == null
      || (candidateIsYDPlayer && !resultIsYDPlayer)
      || (candidateIsYDPlayer === resultIsYDPlayer && candidateIsHero && !resultIsHero)
      || (
        candidateIsYDPlayer === resultIsYDPlayer
        && candidateIsHero === resultIsHero
        && (distanceSq < bestDistanceSq || (distanceSq === bestDistanceSq && handleId < bestHandleId))
      )
    ) {
      result = candidate;
      resultIsYDPlayer = candidateIsYDPlayer;
      resultIsHero = candidateIsHero;
      bestDistanceSq = distanceSq;
      bestHandleId = handleId;
    }
  }

  DestroyGroup(group);
  return result;
}

function 驱动护卫攻击(this: void, guard: any, target: any, state: 护卫驱动状态): void {
  const targetId = 获取句柄ID(target);
  const currentOrderId = GetUnitCurrentOrder(guard) || 0;
  const 已在攻击相同目标 = state.模式 === "攻击"
    && state.攻击目标ID === targetId
    && (currentOrderId === 攻击命令ID || currentOrderId === 攻击一次命令ID);
  if (已在攻击相同目标 || !当前命令允许护卫驱动(guard)) return;

  if (IssueTargetOrder(guard, "attack", target)) {
    state.模式 = "攻击";
    state.攻击目标ID = targetId;
  }
}

function 刷新护卫返回点(this: void, boss: any, state: 护卫驱动状态): void {
  const bossX = GetUnitX(boss);
  const bossY = GetUnitY(boss);
  state.返回角度 = GetRandomReal(0, 360);
  state.返回目标X = bossX + Cos(state.返回角度 * 角度转弧度) * 护卫返回Boss距离;
  state.返回目标Y = bossY + Sin(state.返回角度 * 角度转弧度) * 护卫返回Boss距离;
  state.返回锚点BossX = bossX;
  state.返回锚点BossY = bossY;
}

function 驱动护卫回位(this: void, guard: any, boss: any, state: 护卫驱动状态): void {
  const bossDx = GetUnitX(boss) - state.返回锚点BossX;
  const bossDy = GetUnitY(boss) - state.返回锚点BossY;
  const boss已明显移动 = bossDx * bossDx + bossDy * bossDy >= 护卫返回点Boss移动刷新距离平方;
  if (state.模式 !== "回位" || boss已明显移动) 刷新护卫返回点(boss, state);

  const dx = GetUnitX(guard) - state.返回目标X;
  const dy = GetUnitY(guard) - state.返回目标Y;
  if (dx * dx + dy * dy <= 护卫返回点到达距离平方) {
    state.模式 = "回位";
    state.攻击目标ID = 0;
    return;
  }
  if (!当前命令允许护卫驱动(guard)) return;

  const currentOrderId = GetUnitCurrentOrder(guard) || 0;
  if (state.模式 === "回位" && currentOrderId === 移动命令ID && !boss已明显移动) return;
  if (IssuePointOrder(guard, "move", state.返回目标X, state.返回目标Y)) {
    state.模式 = "回位";
    state.攻击目标ID = 0;
  }
}

function on护卫驱动Tick(this: void): void {
  const 玩家组 = YDUserDataGetSafe("string", "玩家", "玩家组", "force");
  for (const bossKey in 按Boss句柄索引的护卫句柄表) {
    const bossHandleId = parseInt(bossKey, 10);
    if (isNaN(bossHandleId)) continue;
    const list = 按Boss句柄索引的护卫句柄表[bossHandleId];
    if (list == null || list.length === 0) continue;

    let boss: any = null;
    for (let i = 0; i < list.length; i++) {
      const record = 按护卫句柄索引的记录表[list[i]];
      if (record != null && 获取句柄ID(record.主Boss单位) === bossHandleId) {
        boss = record.主Boss单位;
        break;
      }
    }
    if (!单位存活(boss)) continue;

    const fallbackTarget = 选择Boss附近战斗目标(boss, 玩家组);
    for (let i = 0; i < list.length; i++) {
      const guardHandleId = list[i];
      const record = 按护卫句柄索引的记录表[guardHandleId];
      if (record == null || record.主Boss单位 !== boss || !单位存活(record.护卫单位)) continue;

      let state = 按护卫句柄索引的驱动状态表[guardHandleId];
      if (state == null) {
        state = 创建空驱动状态();
        按护卫句柄索引的驱动状态表[guardHandleId] = state;
      }
      const threatTarget = 获取护卫仇恨目标(record.护卫单位);
      if (threatTarget != null && threatTarget !== 0) {
        驱动护卫攻击(record.护卫单位, threatTarget, state);
        continue;
      }
      if (fallbackTarget != null && fallbackTarget !== 0) {
        驱动护卫攻击(record.护卫单位, fallbackTarget, state);
        continue;
      }
      if (当前正在执行攻击命令(record.护卫单位)) continue;
      驱动护卫回位(record.护卫单位, boss, state);
    }
  }
}

function 确保护卫驱动已启动(this: void): void {
  if (护卫驱动回调ID !== 0) return;
  护卫驱动回调ID = addPeriodicCallback(护卫驱动间隔毫秒, on护卫驱动Tick);
}

function 从Boss索引移除(this: void, bossHandleId: number, guardHandleId: number): void {
  const list = 按Boss句柄索引的护卫句柄表[bossHandleId];
  if (list == null) return;
  for (let i = list.length - 1; i >= 0; i--) {
    if (list[i] === guardHandleId) list.splice(i, 1);
  }
  if (list.length === 0) delete 按Boss句柄索引的护卫句柄表[bossHandleId];
}

function 解析单位类型ID(this: void, unitType: string | number): number {
  if (typeof unitType === "number") return unitType;
  return stringToFourCCSafe(unitType);
}

export function 登记护卫单位(this: void, guard: any, 参数: 护卫登记参数): any {
  const guardHandleId = 获取句柄ID(guard);
  const bossHandleId = 获取句柄ID(参数.主Boss单位);
  if (guardHandleId === 0 || bossHandleId === 0) return guard;

  const oldRecord = 按护卫句柄索引的记录表[guardHandleId];
  if (oldRecord != null && oldRecord.护卫单位 === guard) {
    const oldBossHandleId = 获取句柄ID(oldRecord.主Boss单位);
    if (oldBossHandleId !== bossHandleId) 从Boss索引移除(oldBossHandleId, guardHandleId);
  } else if (oldRecord != null) {
    从Boss索引移除(获取句柄ID(oldRecord.主Boss单位), guardHandleId);
  }

  const 是否原记录 = oldRecord != null && oldRecord.护卫单位 === guard;
  if (!是否原记录) 护卫登记顺序计数 += 1;
  if (参数.标记为召唤单位 === true) UnitAddType(guard, UNIT_TYPE_SUMMONED);
  按护卫句柄索引的记录表[guardHandleId] = {
    护卫单位: guard,
    主Boss单位: 参数.主Boss单位,
    护卫类型: 参数.护卫类型,
    是否召唤单位: 参数.标记为召唤单位 === true,
    护卫血条优先级: 参数.护卫血条优先级 ?? (是否原记录 ? oldRecord!.护卫血条优先级 : 0),
    Boss结束处理: 参数.Boss结束处理 ?? (是否原记录 ? oldRecord!.Boss结束处理 : "注销"),
    on死亡: 参数.on死亡 ?? (是否原记录 ? oldRecord!.on死亡 : undefined),
    登记顺序: 是否原记录 ? oldRecord!.登记顺序 : 护卫登记顺序计数,
  };

  let list = 按Boss句柄索引的护卫句柄表[bossHandleId];
  if (list == null) {
    list = [];
    按Boss句柄索引的护卫句柄表[bossHandleId] = list;
  }
  let exists = false;
  for (let i = 0; i < list.length; i++) {
    if (list[i] === guardHandleId) {
      exists = true;
      break;
    }
  }
  if (!exists) list.push(guardHandleId);
  if (!是否原记录 || 获取句柄ID(oldRecord?.主Boss单位) !== bossHandleId) {
    按护卫句柄索引的驱动状态表[guardHandleId] = 创建空驱动状态();
  }
  确保护卫驱动已启动();
  return guard;
}

export function 创建护卫单位(this: void, 参数: 护卫创建参数): any {
  const unitTypeId = 解析单位类型ID(参数.单位类型);
  if (unitTypeId === 0) return null;
  const owner = 参数.所属玩家 ?? GetOwningPlayer(参数.主Boss单位);
  if (owner == null || owner === 0) return null;
  const guard = CreateUnit(owner, unitTypeId, 参数.X, 参数.Y, 参数.面向 ?? 270);
  if (guard == null || guard === 0) return null;
  return 登记护卫单位(guard, 参数);
}

export function 创建自定义护卫单位(this: void, 参数: 护卫登记参数, 创建器: 自定义护卫创建器): any {
  if (创建器 == null) return null;
  const guard = 创建器();
  if (guard == null || guard === 0) return null;
  return 登记护卫单位(guard, 参数);
}

export function 注销护卫单位(this: void, guard: any): boolean {
  const guardHandleId = 获取句柄ID(guard);
  if (guardHandleId === 0) return false;
  const record = 按护卫句柄索引的记录表[guardHandleId];
  if (record == null || record.护卫单位 !== guard) return false;
  从Boss索引移除(获取句柄ID(record.主Boss单位), guardHandleId);
  delete 按护卫句柄索引的记录表[guardHandleId];
  delete 按护卫句柄索引的驱动状态表[guardHandleId];
  return true;
}

export function 是否护卫单位(this: void, unit: any): boolean {
  const handleId = 获取句柄ID(unit);
  if (handleId === 0) return false;
  const record = 按护卫句柄索引的记录表[handleId];
  return record != null && record.护卫单位 === unit;
}

export function 获取护卫记录(this: void, unit: any): 护卫记录 | undefined {
  const handleId = 获取句柄ID(unit);
  if (handleId === 0) return undefined;
  const record = 按护卫句柄索引的记录表[handleId];
  return record != null && record.护卫单位 === unit ? record : undefined;
}

export function 获取护卫所属Boss(this: void, unit: any): any {
  return 获取护卫记录(unit)?.主Boss单位;
}

export function 获取护卫类型(this: void, unit: any): string | undefined {
  return 获取护卫记录(unit)?.护卫类型;
}

export function 是否指定Boss护卫(this: void, unit: any, boss: any): boolean {
  const record = 获取护卫记录(unit);
  return record != null && record.主Boss单位 === boss;
}

export function 获取Boss护卫列表(this: void, boss: any, 只返回存活: boolean = true): any[] {
  const result: any[] = [];
  const bossHandleId = 获取句柄ID(boss);
  if (bossHandleId === 0) return result;
  const list = 按Boss句柄索引的护卫句柄表[bossHandleId];
  if (list == null) return result;
  for (let i = 0; i < list.length; i++) {
    const record = 按护卫句柄索引的记录表[list[i]];
    if (record == null || record.主Boss单位 !== boss) continue;
    if (只返回存活 && !单位存活(record.护卫单位)) continue;
    result.push(record.护卫单位);
  }
  return result;
}

export function 注销Boss全部护卫(this: void, boss: any): void {
  const list = 获取Boss护卫列表(boss, false);
  for (let i = 0; i < list.length; i++) 注销护卫单位(list[i]);
}

export function 处理Boss结束全部护卫(this: void, boss: any): void {
  const list = 获取Boss护卫列表(boss, false);
  for (let i = 0; i < list.length; i++) {
    const guard = list[i];
    const record = 获取护卫记录(guard);
    if (record == null || record.主Boss单位 !== boss) continue;
    const 结束处理 = record.Boss结束处理;
    注销护卫单位(guard);
    if (结束处理 === "移除") RemoveUnit(guard);
    else if (结束处理 === "击杀" && 单位存活(guard)) KillUnit(guard);
  }
}

function on单位死亡(this: void, dyingUnit: any, killingUnit: any): void {
  处理Boss结束全部护卫(dyingUnit);
  const record = 获取护卫记录(dyingUnit);
  if (record == null) return;
  if (record.on死亡 != null) record.on死亡(dyingUnit, killingUnit, record);
  // 有血条优先级的长期护卫保留登记，复活后可重新进入显示队列。
  if (record.护卫血条优先级 > 0) return;
  addDelayedCallback(10, function 延迟注销死亡护卫(this: void): void {
    注销护卫单位(dyingUnit);
  });
}

registerDeathListener(on单位死亡);
