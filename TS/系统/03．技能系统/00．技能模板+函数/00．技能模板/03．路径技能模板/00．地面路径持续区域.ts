/** @noSelfInFile */
/**
 * 地面路径持续区域模板
 *
 * 说明：
 * 1. 沿一条路径按段铺设多个持续区域。
 * 2. 适合地裂、火焰路径、冰霜路径、毒雾路径等技能。
 * 3. 每段复用现有 `区域效果`，统一处理持续伤害与敌友筛选。
 */

const jass = require("jass.common") as any;

const CreateTimer = jass.CreateTimer as () => any;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

const {
  safeTimerStart,
  safeDestroyTimer,
} = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (this: void, timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (this: void, timer: any) => void;
};

const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any, target: any, amount: number,
  attack: boolean, ranged: boolean,
  attackType: any, damageType: any, weaponType: any
) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;

const {
  addPeriodicCallback,
  removePeriodicCallback,
  getServerTime,
} = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

import { 创建区域效果, 清理区域效果周期伤害去重组, type 区域效果实例 } from "../../01．技能函数/04．区域效果/index";
import { 获取矩形区域单位 } from "../../01．技能函数/09．形状区域/矩形区域";

const { isUnitEnemy, isUnitAlly } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
  isUnitAlly: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};

export interface 地面路径持续区域参数 {
  起点X: number;
  起点Y: number;
  方向角: number;
  路径长度: number;
  路径半径: number;
  区域持续时间: number;
  伤害模式?: "分段区域" | "整体矩形";
  段间距?: number;
  铺设间隔?: number;
  检测间隔?: number;
  周期伤害?: number;
  整体伤害长度?: number;
  整体伤害半径?: number;
  影响目标?: "敌方" | "友方" | "全部";
  所有者?: any;
  模型路径?: string;
  特效高度?: number;
  显示提示圈?: boolean;
  on单段创建?: (this: void, 段序号: number, X: number, Y: number) => void;
  on全部铺设完成?: (this: void, 实例ID: number) => void;
  on销毁?: (this: void, 实例ID: number) => void;
}

export interface 地面路径持续区域实例 {
  readonly 实例ID: number;
  销毁(): void;
}

interface 路径段信息 {
  X: number;
  Y: number;
}

class 地面路径持续区域实现 implements 地面路径持续区域实例 {
  readonly 实例ID: number;
  readonly 参数: 地面路径持续区域参数;
  private readonly 路径段列表: 路径段信息[];
  private readonly 区域实例列表: 区域效果实例[] = [];
  private 铺设定时器: any = null;
  private 下一个段索引 = 0;
  private 已销毁 = false;
  private 已全部铺设 = false;
  private 整体伤害结束时间毫秒 = 0;
  private 下次整体伤害时间毫秒 = 0;

  constructor(实例ID: number, 参数: 地面路径持续区域参数) {
    this.实例ID = 实例ID;
    this.参数 = 参数;
    this.路径段列表 = 生成路径段列表(参数);
    const 当前时间毫秒 = getServerTime();
    this.整体伤害结束时间毫秒 = 当前时间毫秒 + 参数.区域持续时间 * 1000;
    this.下次整体伤害时间毫秒 = 当前时间毫秒;
  }

  启动(): void {
    if (this.路径段列表.length <= 0) {
      this.处理全部铺设完成();
      return;
    }

    this.创建下一段区域();
    if (this.下一个段索引 >= this.路径段列表.length) {
      return;
    }

    const 铺设间隔 = this.参数.铺设间隔 != null && this.参数.铺设间隔 > 0
      ? this.参数.铺设间隔
      : 0.06;

    this.铺设定时器 = CreateTimer();
    if (this.铺设定时器 == null || this.铺设定时器 === 0) {
      while (this.下一个段索引 < this.路径段列表.length) {
        this.创建下一段区域();
      }
      return;
    }

    const 定时器ID = 取句柄ID(this.铺设定时器);
    if (定时器ID > 0) {
      铺设定时器实例映射[定时器ID] = this.实例ID;
    }
    safeTimerStart(this.铺设定时器, 铺设间隔, true, on地面路径铺设定时器到时);
  }

  创建下一段区域(): void {
    if (this.已销毁) {
      return;
    }

    const 段索引 = this.下一个段索引;
    const 路径段 = this.路径段列表[段索引];
    if (路径段 == null) {
      this.停止铺设定时器();
      this.处理全部铺设完成();
      return;
    }

    const 区域实例 = 创建区域效果({
      X: 路径段.X,
      Y: 路径段.Y,
      半径: this.参数.路径半径,
      持续时间: this.参数.区域持续时间,
      检测间隔: this.参数.检测间隔,
      影响目标: this.参数.影响目标 ?? "敌方",
      所有者: this.参数.所有者,
      模型路径: this.参数.模型路径,
      特效高度: this.参数.特效高度,
      显示提示圈: this.参数.显示提示圈,
      周期伤害: this.参数.伤害模式 === "整体矩形" ? 0 : this.参数.周期伤害,
      周期伤害去重组: this.实例ID,
      周期伤害去重间隔: this.参数.检测间隔,
    });
    this.区域实例列表.push(区域实例);
    this.下一个段索引 += 1;
    this.参数.on单段创建?.(段索引 + 1, 路径段.X, 路径段.Y);

    if (this.下一个段索引 >= this.路径段列表.length) {
      this.停止铺设定时器();
      this.处理全部铺设完成();
    }
  }

  销毁(): void {
    if (this.已销毁) {
      return;
    }
    this.已销毁 = true;
    this.停止铺设定时器();
    for (const 区域实例 of this.区域实例列表) {
      区域实例.销毁();
    }
    清理区域效果周期伤害去重组(this.实例ID);
    delete 活跃地面路径持续区域实例[this.实例ID];
    this.参数.on销毁?.(this.实例ID);
  }

  整体伤害系统Tick(当前时间毫秒: number): void {
    if (this.已销毁) {
      return;
    }
    if (this.参数.伤害模式 !== "整体矩形") {
      return;
    }
    if ((this.参数.周期伤害 ?? 0) <= 0) {
      return;
    }
    if (当前时间毫秒 >= this.整体伤害结束时间毫秒) {
      return;
    }
    if (当前时间毫秒 < this.下次整体伤害时间毫秒) {
      return;
    }

    const 检测间隔秒 = this.参数.检测间隔 != null && this.参数.检测间隔 > 0
      ? this.参数.检测间隔
      : 0.02;
    this.下次整体伤害时间毫秒 = 当前时间毫秒 + 检测间隔秒 * 1000;

    const 整体伤害长度 = this.参数.整体伤害长度 != null && this.参数.整体伤害长度 > 0
      ? this.参数.整体伤害长度
      : this.参数.路径长度;
    const 整体伤害半径 = this.参数.整体伤害半径 != null && this.参数.整体伤害半径 > 0
      ? this.参数.整体伤害半径
      : this.参数.路径半径;
    if (整体伤害长度 <= 0 || 整体伤害半径 <= 0) {
      return;
    }

    const 中心X = this.参数.起点X + CosBJ(this.参数.方向角) * (整体伤害长度 * 0.5);
    const 中心Y = this.参数.起点Y + SinBJ(this.参数.方向角) * (整体伤害长度 * 0.5);
    const 单位列表 = 获取矩形区域单位({
      X: 中心X,
      Y: 中心Y,
      长度: 整体伤害长度,
      宽度: 整体伤害半径 * 2,
      方向角: this.参数.方向角,
    });

    for (const 单位 of 单位列表) {
      if (!this.整体伤害单位筛选(单位)) {
        continue;
      }
      UnitDamageTarget(
        this.参数.所有者 ?? 单位,
        单位,
        this.参数.周期伤害 ?? 0,
        false,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
      );
    }
  }

  private 整体伤害单位筛选 = (单位: any): boolean => {
    const 影响目标 = this.参数.影响目标 ?? "敌方";
    const 所有者 = this.参数.所有者;
    if (影响目标 === "全部") {
      return true;
    }
    if (所有者 == null || 所有者 === 0) {
      return true;
    }
    if (影响目标 === "敌方") {
      return isUnitEnemy(单位, 所有者);
    }
    return isUnitAlly(单位, 所有者);
  };

  private 停止铺设定时器(): void {
    if (this.铺设定时器 == null || this.铺设定时器 === 0) {
      return;
    }
    const 定时器ID = 取句柄ID(this.铺设定时器);
    if (定时器ID > 0) {
      delete 铺设定时器实例映射[定时器ID];
    }
    safeDestroyTimer(this.铺设定时器);
    this.铺设定时器 = null;
  }

  private 处理全部铺设完成(): void {
    if (this.已全部铺设) {
      return;
    }
    this.已全部铺设 = true;
    this.参数.on全部铺设完成?.(this.实例ID);
  }
}

const 默认火焰路径特效 = "Abilities\\Spells\\Other\\ImmolationRed\\ImmolationRedDamage.mdl";

const 活跃地面路径持续区域实例: Record<number, 地面路径持续区域实现 | undefined> = {};
const 铺设定时器实例映射: Record<number, number | undefined> = {};
let 下一个地面路径持续区域实例ID = 0;
let 地面路径整体伤害系统回调ID = 0;

function 取句柄ID(h: any): number {
  if (h == null || h === 0) {
    return 0;
  }
  return GetHandleId(h) || 0;
}

function 数字升序排序(this: void, a: number, b: number): number {
  return a - b;
}

function 获取有序地面路径实例ID列表(this: void): number[] {
  const ids: number[] = [];
  for (const 实例ID文本 in 活跃地面路径持续区域实例) {
    const 实例ID = Number(实例ID文本);
    if (!isNaN(实例ID)) ids.push(实例ID);
  }
  ids.sort(数字升序排序);
  return ids;
}

function 生成路径段列表(参数: 地面路径持续区域参数): 路径段信息[] {
  const 结果: 路径段信息[] = [];
  const 路径长度 = 参数.路径长度 > 0 ? 参数.路径长度 : 0;
  const 路径半径 = 参数.路径半径 > 0 ? 参数.路径半径 : 0;
  const 段间距 = 参数.段间距 != null && 参数.段间距 > 0
    ? 参数.段间距
    : (路径半径 > 0 ? 路径半径 : 100);

  if (路径长度 <= 0) {
    结果.push({ X: 参数.起点X, Y: 参数.起点Y });
    return 结果;
  }

  let 当前距离 = 0;
  while (当前距离 <= 路径长度) {
    结果.push({
      X: 参数.起点X + CosBJ(参数.方向角) * 当前距离,
      Y: 参数.起点Y + SinBJ(参数.方向角) * 当前距离,
    });
    当前距离 += 段间距;
  }

  const 最后一段 = 结果[结果.length - 1];
  const 终点X = 参数.起点X + CosBJ(参数.方向角) * 路径长度;
  const 终点Y = 参数.起点Y + SinBJ(参数.方向角) * 路径长度;
  if (最后一段 == null || 最后一段.X !== 终点X || 最后一段.Y !== 终点Y) {
    结果.push({ X: 终点X, Y: 终点Y });
  }

  return 结果;
}

function 确保地面路径整体伤害系统已启动(): void {
  if (地面路径整体伤害系统回调ID !== 0) {
    return;
  }
  地面路径整体伤害系统回调ID = addPeriodicCallback(20, on地面路径整体伤害系统Tick);
}

function on地面路径整体伤害系统Tick(): void {
  const 当前时间毫秒 = getServerTime();
  let 仍有整体矩形实例 = false;

  const 实例ID列表 = 获取有序地面路径实例ID列表();
  for (let i = 0; i < 实例ID列表.length; i++) {
    const 实例ID = 实例ID列表[i];
    const 实例 = 活跃地面路径持续区域实例[实例ID];
    if (实例 == null) {
      continue;
    }
    if (实例.参数.伤害模式 === "整体矩形") {
      仍有整体矩形实例 = true;
      实例.整体伤害系统Tick(当前时间毫秒);
    }
  }

  if (!仍有整体矩形实例 && 地面路径整体伤害系统回调ID !== 0) {
    removePeriodicCallback(地面路径整体伤害系统回调ID);
    地面路径整体伤害系统回调ID = 0;
  }
}

function on地面路径铺设定时器到时(): void {
  const timer = GetExpiredTimer();
  if (timer == null || timer === 0) {
    return;
  }
  const 定时器ID = 取句柄ID(timer);
  const 实例ID = 铺设定时器实例映射[定时器ID];
  if (实例ID == null || 实例ID <= 0) {
    return;
  }
  const 实例 = 活跃地面路径持续区域实例[实例ID];
  if (实例 == null) {
    return;
  }
  实例.创建下一段区域();
}

export function 创建地面路径持续区域(参数: 地面路径持续区域参数): 地面路径持续区域实例 {
  const 实例ID = ++下一个地面路径持续区域实例ID;
  const 实例 = new 地面路径持续区域实现(实例ID, 参数);
  活跃地面路径持续区域实例[实例ID] = 实例;
  if (参数.伤害模式 === "整体矩形") {
    确保地面路径整体伤害系统已启动();
  }
  实例.启动();
  return 实例;
}

export function 创建火焰路径持续区域(参数: 地面路径持续区域参数): 地面路径持续区域实例 {
  return 创建地面路径持续区域({
    ...参数,
    模型路径: 参数.模型路径 ?? 默认火焰路径特效,
  });
}
