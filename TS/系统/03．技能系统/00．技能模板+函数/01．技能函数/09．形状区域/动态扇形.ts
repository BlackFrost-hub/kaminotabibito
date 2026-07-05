/** @noSelfInFile */
/**
 * 形状区域 - 动态扇形
 *
 * 支持扇形波前按时间推进。
 * 默认模式为“每 0.02 秒只命中新扫到的那一圈”，也就是由近到远扫过去。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const AddSpecialEffect = jass.AddSpecialEffect as (modelPath: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const EXSetEffectZ = japi.EXSetEffectZ as (effect: any, z: number) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;

import type { 技能伤害来源类型 } from "../../../../04．伤害系统/08．技能伤害系统";

const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};

const {
  addPeriodicCallback,
  removePeriodicCallback,
  getServerTime,
} = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

const { isUnitEnemy, isUnitAlly } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
  isUnitAlly: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};

const { 获取扇形区域单位 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域") as {
  获取扇形区域单位: (this: void, 参数: {
    X: number;
    Y: number;
    半径: number;
    方向角: number;
    扇形角度: number;
    单位筛选?: (this: void, 单位: any) => boolean;
    包含边界?: boolean;
  }) => any[];
};

const { 创建红色扇形提示圈特效, 设置扇形提示圈朝向与尺寸, 重播提示圈动画, 立即销毁提示圈特效 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效") as {
  创建红色扇形提示圈特效: (this: void, x: number, y: number, fac: number, size: number, speed?: number) => any;
  设置扇形提示圈朝向与尺寸: (this: void, e: any, fac: number, size: number) => void;
  重播提示圈动画: (this: void, e: any, 动画序号?: number, 动画名?: string) => void;
  立即销毁提示圈特效: (this: void, e: any) => void;
};

export interface 动态扇形参数 {
  X: number;
  Y: number;
  方向角: number;
  扇形角度: number;
  起始半径: number;
  结束半径: number;
  变化时间: number;
  检测间隔?: number;
  影响目标?: "敌方" | "友方" | "全部";
  所有者?: any;
  伤害值?: number;
  伤害类型?: any;
  攻击类型?: any;
  武器类型?: any;
  来源类型?: 技能伤害来源类型;
  技能ID?: number;
  技能实例ID?: number;
  技能标签?: string;
  参与技能伤害加成?: boolean;
  只命中新增范围?: boolean;
  允许重复命中?: boolean;
  显示提示特效?: boolean;
  模型路径?: string;
  特效高度?: number;
  on命中?: (this: void, 单位: any, 当前半径: number) => void;
  on周期?: (this: void, 当前命中单位: any[], 当前半径: number, 上次半径: number) => void;
  on销毁?: (this: void) => void;
}

export interface 动态扇形实例 {
  readonly 参数: 动态扇形参数;
  readonly 当前半径: number;
  readonly 已过时间: number;
  readonly 已销毁: boolean;
  销毁(): void;
}

class 动态扇形实现 implements 动态扇形实例 {
  readonly 参数: 动态扇形参数;
  readonly 实例ID: number;
  private 当前半径值: number;
  private 上次半径值: number;
  private 已过时间值 = 0;
  private 已销毁值 = false;
  private 特效句柄: any = null;
  private 提示圈特效: any = null;
  private 当前X: number;
  private 当前Y: number;
  private 检测间隔毫秒值: number;
  private 下次检测时间毫秒: number;
  private 变化时间毫秒: number;
  private 创建时间毫秒: number;
  private 半径差值: number;
  private 命中记录: Record<number, true | undefined> = {};

  constructor(参数: 动态扇形参数) {
    this.实例ID = ++动态扇形实例ID计数器;
    this.参数 = 参数;
    this.当前X = 参数.X;
    this.当前Y = 参数.Y;
    this.当前半径值 = 参数.起始半径;
    this.上次半径值 = 参数.起始半径;
    this.半径差值 = 参数.结束半径 - 参数.起始半径;
    this.变化时间毫秒 = 参数.变化时间 * 1000;

    const 原始毫秒 = (参数.检测间隔 ?? 0.02) * 1000;
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

    if (参数.显示提示特效 !== false && 参数.变化时间 > 0) {
      this.提示圈特效 = 创建红色扇形提示圈特效(
        this.当前X,
        this.当前Y,
        参数.方向角,
        取扇形提示圈尺寸(this.当前半径值),
        1 / 参数.变化时间
      );
    }

    注册动态扇形实例(this);
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
      this.上次半径值 = this.当前半径值;
      this.当前半径值 = this.参数.结束半径;
      this.执行检测();
      this.销毁();
      return;
    }

    if (当前时间毫秒 < this.下次检测时间毫秒) {
      return;
    }

    this.下次检测时间毫秒 = 当前时间毫秒 + this.检测间隔毫秒值;
    this.上次半径值 = this.当前半径值;

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
    if (当前半径 <= 0 || this.参数.扇形角度 <= 0) {
      return;
    }

    if (this.提示圈特效) {
      设置扇形提示圈朝向与尺寸(this.提示圈特效, this.参数.方向角, 取扇形提示圈尺寸(当前半径));
      重播提示圈动画(this.提示圈特效, 0);
    }

    const 所有单位 = 获取扇形区域单位({
      X: this.当前X,
      Y: this.当前Y,
      半径: 当前半径,
      方向角: this.参数.方向角,
      扇形角度: this.参数.扇形角度,
      包含边界: true,
    });

    const 当前命中单位: any[] = [];
    const 只命中新增范围 = this.参数.只命中新增范围 ?? true;
    const 允许重复命中 = this.参数.允许重复命中 ?? false;
    const 内半径 = 只命中新增范围 ? 取较小值(this.上次半径值, 当前半径) : 0;
    const 外半径 = 只命中新增范围 ? 取较大值(this.上次半径值, 当前半径) : 当前半径;

    for (const 单位 of 所有单位) {
      if (!this.是否影响目标(单位)) {
        continue;
      }

      const 距离 = 计算坐标距离(this.当前X, this.当前Y, GetUnitX(单位), GetUnitY(单位));
      if (只命中新增范围) {
        if (距离 > 外半径 || 距离 < 内半径) {
          continue;
        }
      }

      const 单位ID = 取句柄ID(单位);
      if (!允许重复命中 && this.命中记录[单位ID]) {
        continue;
      }

      当前命中单位.push(单位);
      this.命中记录[单位ID] = true;

      if ((this.参数.伤害值 ?? 0) > 0 && ATTACK_TYPE_NORMAL) {
        造成AOE技能伤害({
          来源: this.参数.所有者 ?? 单位,
          目标: 单位,
          伤害: this.参数.伤害值 ?? 0,
          伤害类型: this.参数.伤害类型 ?? DAMAGE_TYPE_NORMAL,
          ranged: false,
          attackType: this.参数.攻击类型 ?? ATTACK_TYPE_NORMAL,
          weaponType: this.参数.武器类型,
          来源类型: this.参数.来源类型 ?? "单位技能",
          技能ID: this.参数.技能ID,
          技能实例ID: this.参数.技能实例ID,
          标签: this.参数.技能标签,
          参与技能伤害加成: this.参数.参与技能伤害加成,
        });
      }

      this.参数.on命中?.(单位, 当前半径);
    }

    this.参数.on周期?.(当前命中单位, 当前半径, this.上次半径值);
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
    注销动态扇形实例(this);

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

let 动态扇形实例ID计数器 = 0;
let 动态扇形系统回调ID = 0;
const 活跃动态扇形实例: 动态扇形实现[] = [];

function 取句柄ID(h: any): number {
  return (h != null && h !== 0 ? GetHandleId(h) : 0) || 0;
}

function 计算坐标距离(x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return jass.SquareRoot(dx * dx + dy * dy) as number;
}

function 取较小值(a: number, b: number): number {
  return a < b ? a : b;
}

function 取较大值(a: number, b: number): number {
  return a > b ? a : b;
}

function 取扇形提示圈尺寸(半径: number): number {
  if (半径 <= 0) {
    return 0.01;
  }
  return 半径 / 512;
}

function 确保动态扇形系统已启动(): void {
  if (动态扇形系统回调ID !== 0) {
    return;
  }
  动态扇形系统回调ID = addPeriodicCallback(100, 动态扇形系统Tick);
}

function 注册动态扇形实例(实例: 动态扇形实现): void {
  活跃动态扇形实例.push(实例);
  确保动态扇形系统已启动();
}

function 注销动态扇形实例(实例: 动态扇形实现): void {
  const 索引 = 活跃动态扇形实例.indexOf(实例);
  if (索引 >= 0) {
    活跃动态扇形实例.splice(索引, 1);
  }

  if (活跃动态扇形实例.length === 0 && 动态扇形系统回调ID !== 0) {
    removePeriodicCallback(动态扇形系统回调ID);
    动态扇形系统回调ID = 0;
  }
}

function 动态扇形系统Tick(): void {
  const 当前时间毫秒 = getServerTime();
  let 索引 = 0;

  while (索引 < 活跃动态扇形实例.length) {
    const 实例 = 活跃动态扇形实例[索引];
    实例.系统Tick(当前时间毫秒);

    if (索引 < 活跃动态扇形实例.length && 活跃动态扇形实例[索引] === 实例) {
      索引++;
    }
  }
}

export function 创建动态扇形(参数: 动态扇形参数): 动态扇形实例 {
  return new 动态扇形实现(参数);
}

export {};
