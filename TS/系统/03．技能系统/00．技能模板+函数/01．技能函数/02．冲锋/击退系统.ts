/** @noSelfInFile */
/**
 * 冲锋/击退系统
 *
 * 参考来源：
 * `JASS/jass复制粘贴/击退系统参考.j`
 *
 * 说明：
 * 1. 这是 TS 侧统一位移管理器，只参考旧 JASS 设计思路，不直接依赖该 JASS 运行时。
 * 2. 系统使用中心计时器统一驱动，所有冲锋/击退共用一套循环。
 * 3. 系统内部只复用一个枚举组，不为每个实例额外常驻创建周期 timer。
 * 4. 同一个单位同一时刻只保留一个本系统位移；新位移会覆盖旧位移。
 *
 * 后续 AI / 调用者常用示例：
 * - 冲锋到目标点：`开始冲锋(单位, { 目标X, 目标Y, 距离, 持续时间 })`
 * - 从来源点击退：`开始击退(单位, { 来源X, 来源Y, 距离, 持续时间 })`
 * - 命中半径检测：加 `命中半径`
 * - 只打敌人：加 `只命中敌人: true`
 * - 命中造成固定伤害：加 `命中伤害`，可选 `伤害来源`
 * - 撞墙结束：默认开启 `检查地形`
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
let japi: any = null;
try {
  japi = require("jass.japi") as any;
} catch (_e) {
  japi = null;
}
const { X_GAFC, X_IsTerrainWalkable, X_GetAbleX, X_GetAbleY } = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数") as {
  X_GAFC: (x1: number, y1: number, x2: number, y2: number) => number;
  X_IsTerrainWalkable: (x: number, y: number) => boolean;
  X_GetAbleX: () => number;
  X_GetAbleY: () => number;
};

const { onTick10ms, offTick10ms } = globalThis as unknown as {
  onTick10ms: (this: void, callback: () => void) => void;
  offTick10ms: (this: void, callback: () => void) => void;
};
const ForGroup = jass["ForGroup"] as (whichGroup: any, callback: () => void) => void;
const GetEnumUnit = jass["GetEnumUnit"] as () => any;

const BJ_DEGTORAD = jglobals.bj_DEGTORAD ?? 0.017453292519943295;
const TICK_INTERVAL = 0.02;
const CENTER_TIMER_TICKS = 2;
const MAX_SUB_STEP = 31.0;
const WALKABLE_TOLERANCE = 8.0;
const UNIT_ALIVE_LIFE = 0.405;
const DEFAULT_MOVE_EFFECT_MODEL = "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl";
const DEFAULT_ATTACK_TYPE = jass.ATTACK_TYPE_NORMAL;
const DEFAULT_DAMAGE_TYPE = jass.DAMAGE_TYPE_NORMAL;
const DEFAULT_WEAPON_TYPE = jass.WEAPON_TYPE_WHOKNOWS;

export type 位移结束原因 = "完成" | "撞墙" | "命中" | "中断" | "死亡";

type 命中过滤函数 = (移动单位: any, 目标单位: any, 位移ID: number) => boolean;
type 命中回调函数 = (移动单位: any, 目标单位: any, 位移ID: number) => void;
type 撞墙回调函数 = (this: void, 移动单位: any, 位移ID: number) => void;
type 结束回调函数 = (移动单位: any, 原因: 位移结束原因, 位移ID: number, 命中目标?: any) => void;

export interface 通用位移参数 {
  距离: number;
  持续时间?: number;
  每秒速度?: number;
  检查地形?: boolean;
  朝向跟随位移?: boolean;
  暂停单位?: boolean;
  禁用碰撞?: boolean;
  位移特效?: string;

  命中半径?: number;
  只命中敌人?: boolean;
  允许命中自己?: boolean;
  允许重复命中?: boolean;
  命中后结束?: boolean;

  命中伤害?: number;
  伤害来源?: any;
  攻击类型?: any;
  伤害类型?: any;
  武器类型?: any;

  命中过滤?: 命中过滤函数;
  命中回调?: 命中回调函数;
  撞墙回调?: 撞墙回调函数;
  结束回调?: 结束回调函数;
}

export interface 冲锋参数 extends 通用位移参数 {
  角度?: number;
  目标X?: number;
  目标Y?: number;
}

export interface 击退参数 extends 通用位移参数 {
  角度?: number;
  来源单位?: any;
  来源X?: number;
  来源Y?: number;
}

interface 位移实例 {
  id: number;
  listIndex: number;
  单位: any;
  单位ID: number;
  角度: number;
  每Tick位移: number;
  总距离: number;
  已移动: number;
  检查地形: boolean;
  朝向跟随位移: boolean;
  暂停单位: boolean;
  禁用碰撞: boolean;
  位移特效: string;
  命中半径: number;
  只命中敌人: boolean;
  允许命中自己: boolean;
  允许重复命中: boolean;
  命中后结束: boolean;
  命中伤害: number;
  伤害来源: any;
  攻击类型: any;
  伤害类型: any;
  武器类型: any;
  命中过滤?: 命中过滤函数;
  命中回调?: 命中回调函数;
  撞墙回调?: 撞墙回调函数;
  结束回调?: 结束回调函数;
}

const 活动位移列表: 位移实例[] = [];
const 位移映射: Record<number, 位移实例 | undefined> = {};
const 单位当前位移: Record<number, number | undefined> = {};
const 命中记录: Record<string, true | undefined> = {};
const 枚举组 = jass.CreateGroup();
let 单位组快照缓存: any[] = [];

let 下一个位移ID = 0;
let 已注册到中心计时器 = false;
let tick计数 = 0;

function 取句柄ID(h: any): number {
  return (h != null && h !== 0 ? (jass.GetHandleId(h) as number) : 0) || 0;
}

function 收集单位组成员(): void {
  const 单位 = GetEnumUnit();
  if (单位 != null && 单位 !== 0) {
    单位组快照缓存.push(单位);
  }
}

function 快照单位组(单位组: any): any[] {
  if (单位组 == null || 单位组 === 0) return [];
  单位组快照缓存 = [];
  ForGroup(单位组, 收集单位组成员);
  const 结果 = 单位组快照缓存;
  单位组快照缓存 = [];
  return 结果;
}

function 单位存活(u: any): boolean {
  return u != null && u !== 0 && (jass.GetUnitState(u, jass.UNIT_STATE_LIFE) as number) > UNIT_ALIVE_LIFE;
}

function 在可玩区域内(x: number, y: number): boolean {
  return x >= (jass.GetRectMinX(jglobals.bj_mapInitialPlayableArea) as number)
    && y >= (jass.GetRectMinY(jglobals.bj_mapInitialPlayableArea) as number)
    && x <= (jass.GetRectMaxX(jglobals.bj_mapInitialPlayableArea) as number)
    && y <= (jass.GetRectMaxY(jglobals.bj_mapInitialPlayableArea) as number);
}

function 计算坐标距离(x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return jass.SquareRoot(dx * dx + dy * dy) as number;
}

function 清理命中记录(位移ID: number): void {
  const 前缀 = `${位移ID}:`;
  for (const key in 命中记录) {
    if (key.indexOf(前缀) === 0) {
      delete 命中记录[key];
    }
  }
}

function 生成命中键(位移ID: number, 目标单位: any): string {
  return `${位移ID}:${取句柄ID(目标单位)}`;
}

function 计算每Tick位移(距离: number, 持续时间?: number, 每秒速度?: number): number {
  if (每秒速度 != null && 每秒速度 > 0) {
    return 每秒速度 * TICK_INTERVAL;
  }
  if (持续时间 != null && 持续时间 > 0) {
    return 距离 / (持续时间 / TICK_INTERVAL);
  }
  return 距离;
}

function 设置单位暂停状态(单位: any, 是否暂停: boolean): void {
  if (单位 == null || 单位 === 0) return;
  if (japi != null && typeof japi.EXPauseUnit === "function") {
    japi.EXPauseUnit(单位, 是否暂停);
    return;
  }
  jass.PauseUnit(单位, 是否暂停);
}

function 单位已被暂停(单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  return jass.IsUnitPaused(单位) === true;
}

function 播放位移特效(实例: 位移实例): void {
  const 模型 = 实例.位移特效;
  if (模型 == null || 模型 === "") return;
  const 特效 = jass.AddSpecialEffect(模型, jass.GetUnitX(实例.单位) as number, jass.GetUnitY(实例.单位) as number);
  if (特效 != null && 特效 !== 0) {
    jass.DestroyEffect(特效);
  }
}

function 注册到中心计时器(): void {
  if (已注册到中心计时器) return;
  已注册到中心计时器 = true;
  onTick10ms(on冲锋击退系统Tick);
}

function 从中心计时器注销(): void {
  if (!已注册到中心计时器) return;
  已注册到中心计时器 = false;
  offTick10ms(on冲锋击退系统Tick);
}

function 尝试收尾中心计时器(): void {
  if (活动位移列表.length !== 0) return;
  tick计数 = 0;
  从中心计时器注销();
}

function 内部移除位移(实例: 位移实例): void {
  const 位移ID = 实例.id;
  const 单位ID = 实例.单位ID;

  delete 位移映射[位移ID];
  if (单位当前位移[单位ID] === 位移ID) {
    delete 单位当前位移[单位ID];
  }
  清理命中记录(位移ID);

  const idx = 实例.listIndex;
  const lastIdx = 活动位移列表.length - 1;
  if (idx !== lastIdx) {
    const last = 活动位移列表[lastIdx];
    活动位移列表[idx] = last;
    last.listIndex = idx;
  }
  活动位移列表.pop();
  尝试收尾中心计时器();
}

function 结束位移实例(实例: 位移实例, 原因: 位移结束原因, 命中目标?: any): void {
  if (位移映射[实例.id] !== 实例) return;

  const 单位 = 实例.单位;
  const 位移ID = 实例.id;
  const 结束回调 = 实例.结束回调;

  if (实例.禁用碰撞) {
    jass.SetUnitPathing(单位, true);
  }
  if (实例.暂停单位) {
    设置单位暂停状态(单位, false);
  }

  内部移除位移(实例);

  if (typeof 结束回调 === "function") {
    结束回调(单位, 原因, 位移ID, 命中目标);
  }
}

function 结束位移ID(位移ID: number, 原因: 位移结束原因, 命中目标?: any): boolean {
  const 实例 = 位移映射[位移ID];
  if (!实例) return false;
  结束位移实例(实例, 原因, 命中目标);
  return true;
}

function 结算命中伤害(实例: 位移实例, 目标单位: any): void {
  if (实例.命中伤害 <= 0) return;
  const 来源单位 = 实例.伤害来源 != null && 实例.伤害来源 !== 0 ? 实例.伤害来源 : 实例.单位;
  if (!来源单位 || 来源单位 === 0) return;

  jass.UnitDamageTarget(
    来源单位,
    目标单位,
    实例.命中伤害,
    false,
    false,
    实例.攻击类型 ?? DEFAULT_ATTACK_TYPE,
    实例.伤害类型 ?? DEFAULT_DAMAGE_TYPE,
    实例.武器类型 ?? DEFAULT_WEAPON_TYPE
  );
}

function 可命中目标(实例: 位移实例, 目标单位: any): boolean {
  if (!单位存活(目标单位)) return false;
  if (!实例.允许命中自己 && 目标单位 === 实例.单位) return false;

  if (!实例.允许重复命中) {
    const 命中键 = 生成命中键(实例.id, 目标单位);
    if (命中记录[命中键] === true) return false;
  }

  if (实例.只命中敌人) {
    const 参考单位 = (实例.伤害来源 != null && 实例.伤害来源 !== 0) ? 实例.伤害来源 : 实例.单位;
    const 所属玩家 = jass.GetOwningPlayer(参考单位);
    if (!jass.IsUnitEnemy(目标单位, 所属玩家)) {
      return false;
    }
  }

  const 命中过滤 = 实例.命中过滤;
  if (typeof 命中过滤 === "function" && !命中过滤(实例.单位, 目标单位, 实例.id)) {
    return false;
  }

  return true;
}

function 记录命中(实例: 位移实例, 目标单位: any): void {
  if (实例.允许重复命中) return;
  命中记录[生成命中键(实例.id, 目标单位)] = true;
}

function 清空枚举组(): void {
  while (true) {
    const u = jass.FirstOfGroup(枚举组);
    if (u == null || u === 0) break;
    jass.GroupRemoveUnit(枚举组, u);
  }
}

function 检查命中(实例: 位移实例): any {
  if (实例.命中半径 <= 0) return null;

  jass.GroupEnumUnitsInRange(枚举组, jass.GetUnitX(实例.单位), jass.GetUnitY(实例.单位), 实例.命中半径, null);

  while (true) {
    const 目标单位 = jass.FirstOfGroup(枚举组);
    if (目标单位 == null || 目标单位 === 0) break;
    jass.GroupRemoveUnit(枚举组, 目标单位);

    if (!可命中目标(实例, 目标单位)) continue;

    记录命中(实例, 目标单位);
    结算命中伤害(实例, 目标单位);

    const 命中回调 = 实例.命中回调;
    if (typeof 命中回调 === "function") {
      命中回调(实例.单位, 目标单位, 实例.id);
      if (位移映射[实例.id] !== 实例) {
        清空枚举组();
        return 目标单位;
      }
    }

    if (实例.命中后结束) {
      清空枚举组();
      return 目标单位;
    }
  }

  return null;
}

function 尝试移动一步(实例: 位移实例, 位移距离: number): { 停止: boolean; 原因?: 位移结束原因; 命中目标?: any } {
  const 单位 = 实例.单位;
  const 当前X = jass.GetUnitX(单位) as number;
  const 当前Y = jass.GetUnitY(单位) as number;
  const 弧度 = 实例.角度 * BJ_DEGTORAD;
  const 新X = 当前X + 位移距离 * jass.Cos(弧度);
  const 新Y = 当前Y + 位移距离 * jass.Sin(弧度);

  if (实例.检查地形) {
    if (!在可玩区域内(新X, 新Y)) {
      const 撞墙回调 = 实例.撞墙回调;
      if (typeof 撞墙回调 === "function") {
        撞墙回调(单位, 实例.id);
        if (位移映射[实例.id] !== 实例) {
          return { 停止: true, 原因: "中断" };
        }
      }
      return { 停止: true, 原因: "撞墙" };
    }

    if (!X_IsTerrainWalkable(新X, 新Y)) {
      const 可通行X = X_GetAbleX();
      const 可通行Y = X_GetAbleY();
      const ableDist = 计算坐标距离(新X, 新Y, 可通行X, 可通行Y);
      if (ableDist > WALKABLE_TOLERANCE) {
        const 撞墙回调 = 实例.撞墙回调;
        if (typeof 撞墙回调 === "function") {
          撞墙回调(单位, 实例.id);
          if (位移映射[实例.id] !== 实例) {
            return { 停止: true, 原因: "中断" };
          }
        }
        return { 停止: true, 原因: "撞墙" };
      }

    }
  }

  if (实例.朝向跟随位移) {
    jass.SetUnitFacing(单位, 实例.角度);
  }
  jass.SetUnitX(单位, 新X);
  jass.SetUnitY(单位, 新Y);
  实例.已移动 += 位移距离;

  const 命中目标 = 检查命中(实例);
  if (命中目标 != null && 命中目标 !== 0) {
    return { 停止: true, 原因: "命中", 命中目标 };
  }

  if (实例.已移动 >= 实例.总距离) {
    return { 停止: true, 原因: "完成" };
  }

  return { 停止: false };
}

function 推进一步(实例: 位移实例): { 停止: boolean; 原因?: 位移结束原因; 命中目标?: any } {
  const 起始已移动 = 实例.已移动;
  const 剩余距离 = 实例.总距离 - 实例.已移动;
  if (剩余距离 <= 0) {
    return { 停止: true, 原因: "完成" };
  }

  let 本Tick位移 = 实例.每Tick位移;
  if (本Tick位移 > 剩余距离) {
    本Tick位移 = 剩余距离;
  }
  if (本Tick位移 <= 0) {
    return { 停止: true, 原因: "完成" };
  }

  let 剩余步长 = 本Tick位移;
  while (剩余步长 > 0) {
    const 子步长 = 剩余步长 > MAX_SUB_STEP ? MAX_SUB_STEP : 剩余步长;
    const 结果 = 尝试移动一步(实例, 子步长);
    if (结果.停止) {
      if (实例.已移动 > 起始已移动) {
        播放位移特效(实例);
      }
      return 结果;
    }
    if (位移映射[实例.id] !== 实例) {
      return { 停止: true, 原因: "中断" };
    }
    剩余步长 -= 子步长;
  }

  if (实例.已移动 > 起始已移动) {
    播放位移特效(实例);
  }
  return { 停止: false };
}

function on冲锋击退系统Tick(): void {
  tick计数 += 1;
  if (tick计数 < CENTER_TIMER_TICKS) return;
  tick计数 = 0;

  let i = 0;
  while (i < 活动位移列表.length) {
    const 实例 = 活动位移列表[i];
    if (位移映射[实例.id] !== 实例) {
      i += 1;
      continue;
    }

    if (!单位存活(实例.单位)) {
      结束位移实例(实例, "死亡");
      continue;
    }

    if (!实例.暂停单位 && 单位已被暂停(实例.单位)) {
      结束位移实例(实例, "中断");
      continue;
    }

    const 结果 = 推进一步(实例);
    if (结果.停止) {
      结束位移实例(实例, 结果.原因 ?? "完成", 结果.命中目标);
      continue;
    }

    i += 1;
  }
}

function 创建位移实例(单位: any, 角度: number, 参数: 通用位移参数): number {
  if (!单位存活(单位)) return 0;
  if (参数.距离 == null || 参数.距离 <= 0) return 0;

  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return 0;

  停止单位位移(单位, "中断");

  const 每Tick位移 = 计算每Tick位移(参数.距离, 参数.持续时间, 参数.每秒速度);
  if (每Tick位移 <= 0) return 0;

  const 位移ID = ++下一个位移ID;
  const 实例: 位移实例 = {
    id: 位移ID,
    listIndex: 活动位移列表.length,
    单位,
    单位ID,
    角度,
    每Tick位移,
    总距离: 参数.距离,
    已移动: 0,
    检查地形: 参数.检查地形 !== false,
    朝向跟随位移: 参数.朝向跟随位移 !== false,
    暂停单位: 参数.暂停单位 === true,
    禁用碰撞: 参数.禁用碰撞 === true,
    位移特效: 参数.位移特效 ?? DEFAULT_MOVE_EFFECT_MODEL,
    命中半径: 参数.命中半径 ?? 0,
    只命中敌人: 参数.只命中敌人 === true,
    允许命中自己: 参数.允许命中自己 === true,
    允许重复命中: 参数.允许重复命中 === true,
    命中后结束: 参数.命中后结束 === true,
    命中伤害: 参数.命中伤害 ?? 0,
    伤害来源: 参数.伤害来源 ?? 单位,
    攻击类型: 参数.攻击类型 ?? DEFAULT_ATTACK_TYPE,
    伤害类型: 参数.伤害类型 ?? DEFAULT_DAMAGE_TYPE,
    武器类型: 参数.武器类型 ?? DEFAULT_WEAPON_TYPE,
    命中过滤: 参数.命中过滤,
    命中回调: 参数.命中回调,
    撞墙回调: 参数.撞墙回调,
    结束回调: 参数.结束回调,
  };

  位移映射[位移ID] = 实例;
  单位当前位移[单位ID] = 位移ID;
  活动位移列表.push(实例);
  if (实例.禁用碰撞) {
    jass.SetUnitPathing(单位, false);
  }
  if (实例.暂停单位) {
    设置单位暂停状态(单位, true);
  }
  注册到中心计时器();
  return 位移ID;
}

function 解析冲锋角度(单位: any, 参数: 冲锋参数): number | null {
  if (参数.角度 != null) return 参数.角度;
  if (参数.目标X != null && 参数.目标Y != null) {
    return X_GAFC(jass.GetUnitX(单位) as number, jass.GetUnitY(单位) as number, 参数.目标X, 参数.目标Y);
  }
  return null;
}

function 解析击退角度(单位: any, 参数: 击退参数): number | null {
  if (参数.角度 != null) return 参数.角度;

  if (参数.来源单位 != null && 参数.来源单位 !== 0) {
    return X_GAFC(
      jass.GetUnitX(参数.来源单位) as number,
      jass.GetUnitY(参数.来源单位) as number,
      jass.GetUnitX(单位) as number,
      jass.GetUnitY(单位) as number
    );
  }

  if (参数.来源X != null && 参数.来源Y != null) {
    return X_GAFC(参数.来源X, 参数.来源Y, jass.GetUnitX(单位) as number, jass.GetUnitY(单位) as number);
  }

  return null;
}

export function 开始冲锋(单位: any, 参数: 冲锋参数): number {
  const 角度 = 解析冲锋角度(单位, 参数);
  if (角度 == null) return 0;
  return 创建位移实例(单位, 角度, 参数);
}

export function 开始击退(单位: any, 参数: 击退参数): number {
  const 角度 = 解析击退角度(单位, 参数);
  if (角度 == null) return 0;
  return 创建位移实例(单位, 角度, 参数);
}

export function 开始单位组冲锋(单位组: any, 参数: 冲锋参数): number[] {
  const 单位列表 = 快照单位组(单位组);
  const 结果: number[] = [];
  for (const 单位 of 单位列表) {
    const 位移ID = 开始冲锋(单位, 参数);
    if (位移ID > 0) {
      结果.push(位移ID);
    }
  }
  return 结果;
}

export function 开始单位组击退(单位组: any, 参数: 击退参数): number[] {
  const 单位列表 = 快照单位组(单位组);
  const 结果: number[] = [];
  for (const 单位 of 单位列表) {
    const 位移ID = 开始击退(单位, 参数);
    if (位移ID > 0) {
      结果.push(位移ID);
    }
  }
  return 结果;
}

export function 停止位移(位移ID: number, 原因: 位移结束原因 = "中断"): boolean {
  return 结束位移ID(位移ID, 原因);
}

export function 停止单位位移(单位: any, 原因: 位移结束原因 = "中断"): boolean {
  const 位移ID = 单位当前位移[取句柄ID(单位)];
  if (!位移ID) return false;
  return 结束位移ID(位移ID, 原因);
}

export function 单位是否正在位移(单位: any): boolean {
  const 位移ID = 单位当前位移[取句柄ID(单位)];
  return !!(位移ID && 位移映射[位移ID]);
}

export function 获取单位当前位移ID(单位: any): number {
  return 单位当前位移[取句柄ID(单位)] ?? 0;
}

export function 获取活跃位移数量(): number {
  return 活动位移列表.length;
}

export {};
