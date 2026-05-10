/** @noSelfInFile */
/**
 * 通用函数 - 动态范围
 * 支持半径随时间动态变化的范围伤害效果。
 * 扩散：起始半径 → 结束半径（从小到大）
 * 收缩：起始半径 → 结束半径（从大到小）
 * 每次 tick 对当前半径内目标造成一次伤害。
 * 使用中心计时器 addPeriodicCallback 做周期检测，不额外创建 timer。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const AddSpecialEffect = jass.AddSpecialEffect as (modelPath: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any, target: any, amount: number,
  attack: boolean, ranged: boolean,
  attackType: any, damageType: any, weaponType: any
) => boolean;
const EXSetEffectZ = japi.EXSetEffectZ as (effect: any, z: number) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;

const {
  addPeriodicCallback,
  removePeriodicCallback,
  getServerTime,
} = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};

const { isUnitEnemy, isUnitAlly } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
  isUnitAlly: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};

const { 创建薄圆形提示圈特效, 设置提示圈半径, 重播提示圈动画, 立即销毁提示圈特效 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效") as {
  创建薄圆形提示圈特效: (this: void, x: number, y: number, r: number, speed?: number, 来源单位?: any) => any;
  设置提示圈半径: (this: void, e: any, r: number) => void;
  重播提示圈动画: (this: void, e: any, 动画序号?: number, 动画名?: string) => void;
  立即销毁提示圈特效: (this: void, e: any) => void;
};

export interface 动态范围参数 {
  X: number;
  Y: number;
  起始半径: number;
  结束半径: number;
  变化时间: number;
  检测间隔?: number;
  影响目标?: "敌方" | "友方" | "全部";
  所有者?: any;
  伤害值?: number;
  模型路径?: string;
  特效高度?: number;
  on周期?: (this: void, 当前半径内单位: any[], 当前半径: number) => void;
  on销毁?: (this: void) => void;
}

export interface 动态范围实例 {
  readonly 参数: 动态范围参数;
  readonly 当前半径: number;
  readonly 已过时间: number;
  readonly 已销毁: boolean;
  销毁(): void;
}

class 动态范围实现 implements 动态范围实例 {
  readonly 参数: 动态范围参数;
  readonly 实例ID: number;
  private 当前半径值: number;
  private 已过时间值 = 0;
  private 已销毁值 = false;
  private 特效句柄: any = null;
  private 提示圈特效: any = null;
  private 当前X: number;
  private 当前Y: number;
  private 半径差值: number;
  private 检测间隔毫秒值: number;
  private 下次检测时间毫秒: number;
  private 变化时间毫秒: number;
  private 创建时间毫秒: number;

  constructor(参数: 动态范围参数) {
    this.实例ID = ++动态范围实例ID计数器;
    this.参数 = 参数;
    this.当前X = 参数.X;
    this.当前Y = 参数.Y;
    this.当前半径值 = 参数.起始半径;
    this.半径差值 = 参数.结束半径 - 参数.起始半径;
    this.变化时间毫秒 = 参数.变化时间 * 1000;

    const 原始毫秒 = (参数.检测间隔 ?? 0.1) * 1000;
    this.检测间隔毫秒值 = 原始毫秒 > 20 ? 原始毫秒 : 20;

    const 当前时间毫秒 = getServerTime();
    this.创建时间毫秒 = 当前时间毫秒;
    this.下次检测时间毫秒 = 当前时间毫秒 + this.检测间隔毫秒值;

    if (参数.模型路径) {
      this.特效句柄 = AddSpecialEffect(参数.模型路径, this.当前X, this.当前Y);
      if (this.特效句柄 && 参数.特效高度) {
        EXSetEffectZ(this.特效句柄, 参数.特效高度);
      }
    }

    if (参数.变化时间 > 0) {
      this.提示圈特效 = 创建薄圆形提示圈特效(
        this.当前X,
        this.当前Y,
        this.当前半径值,
        1 / 参数.变化时间,
        参数.所有者
      );
    }

    注册动态范围实例(this);
  }

  get 当前半径(): number {
    return this.当前半径值;
  }

  get 已过时间(): number {
    return this.已过时间值;
  }

  get 已销毁(): boolean {
    return this.已销毁值;
  }

  系统Tick(当前时间毫秒: number): void {
    if (this.已销毁值) {
      return;
    }

    this.已过时间值 = (当前时间毫秒 - this.创建时间毫秒) / 1000;

    if (当前时间毫秒 - this.创建时间毫秒 >= this.变化时间毫秒) {
      this.当前半径值 = this.参数.结束半径;
      this.执行检测();
      this.销毁();
      return;
    }

    if (当前时间毫秒 < this.下次检测时间毫秒) {
      return;
    }

    this.下次检测时间毫秒 = 当前时间毫秒 + this.检测间隔毫秒值;

    const 进度 = (当前时间毫秒 - this.创建时间毫秒) / this.变化时间毫秒;
    this.当前半径值 = this.参数.起始半径 + this.半径差值 * 进度;
    if (this.当前半径值 < 0) {
      this.当前半径值 = 0;
    }

    this.执行检测();
  }

  private 执行检测(): void {
    if (this.已销毁值) {
      return;
    }

    const 当前半径 = this.当前半径值;
    if (当前半径 <= 0) {
      return;
    }

    if (this.提示圈特效) {
      设置提示圈半径(this.提示圈特效, 当前半径);
      重播提示圈动画(this.提示圈特效, 0);
    }

    const 所有单位 = getUnitsInRange(this.当前X, this.当前Y, 当前半径);
    const 目标单位: any[] = [];

    for (const 单位 of 所有单位) {
      if (this.是否影响目标(单位)) {
        目标单位.push(单位);
      }
    }

    if ((this.参数.伤害值 ?? 0) > 0 && ATTACK_TYPE_NORMAL) {
      for (const 单位 of 目标单位) {
        UnitDamageTarget(
          this.参数.所有者 ?? 单位,
          单位,
          this.参数.伤害值 ?? 0,
          false,
          false,
          ATTACK_TYPE_NORMAL,
          DAMAGE_TYPE_NORMAL,
          null
        );
      }
    }

    this.参数.on周期?.(目标单位, 当前半径);
  }

  private 是否影响目标(单位: any): boolean {
    const 影响目标 = this.参数.影响目标 ?? "敌方";
    const 所有者 = this.参数.所有者;
    if (影响目标 === "全部") return true;
    if (!所有者) return true;
    if (影响目标 === "敌方") return isUnitEnemy(单位, 所有者);
    return isUnitAlly(单位, 所有者);
  }

  销毁(): void {
    if (this.已销毁值) {
      return;
    }

    this.已销毁值 = true;
    注销动态范围实例(this);

    if (this.特效句柄) {
      DestroyEffect(this.特效句柄);
      this.特效句柄 = null;
    }

    if (this.提示圈特效) {
      立即销毁提示圈特效(this.提示圈特效);
      this.提示圈特效 = null;
    }

    this.参数.on销毁?.();
  }
}

let 动态范围实例ID计数器 = 0;
let 动态范围系统回调ID = 0;
const 活跃动态范围实例: 动态范围实现[] = [];

function 确保动态范围系统已启动(): void {
  if (动态范围系统回调ID !== 0) {
    return;
  }
  动态范围系统回调ID = addPeriodicCallback(100, 动态范围系统Tick);
}

function 注册动态范围实例(实例: 动态范围实现): void {
  活跃动态范围实例.push(实例);
  确保动态范围系统已启动();
}

function 注销动态范围实例(实例: 动态范围实现): void {
  const 索引 = 活跃动态范围实例.indexOf(实例);
  if (索引 >= 0) {
    活跃动态范围实例.splice(索引, 1);
  }

  if (活跃动态范围实例.length === 0 && 动态范围系统回调ID !== 0) {
    removePeriodicCallback(动态范围系统回调ID);
    动态范围系统回调ID = 0;
  }
}

function 动态范围系统Tick(): void {
  const 当前时间毫秒 = getServerTime();
  let 索引 = 0;

  while (索引 < 活跃动态范围实例.length) {
    const 实例 = 活跃动态范围实例[索引];
    实例.系统Tick(当前时间毫秒);

    if (索引 < 活跃动态范围实例.length && 活跃动态范围实例[索引] === 实例) {
      索引++;
    }
  }
}

export function 创建动态范围(参数: 动态范围参数): 动态范围实例 {
  return new 动态范围实现(参数);
}

export {};
