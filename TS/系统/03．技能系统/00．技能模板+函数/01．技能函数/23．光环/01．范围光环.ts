/** @noSelfInFile */

const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果") as {
  注册持有型周期效果: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    周期回调: (this: void, unit: any, currentCount: number) => void;
    丢弃回调?: (this: void, unit: any, currentCount: number) => void;
  }) => void;
};
const { 获取单位当前持有指定物品数量 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听") as {
  获取单位当前持有指定物品数量: (this: void, unit: any, itemTypeId: number) => number;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { matchUnitFilter } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  matchUnitFilter: (this: void, targetUnit: any, sourceUnit: any, options: {
    仅敌人?: boolean;
    仅友军?: boolean;
    排除自身?: boolean;
    要求有效单位?: boolean;
    允许建筑?: boolean;
    允许机械?: boolean;
    允许古树?: boolean;
    允许无敌?: boolean;
    允许死亡?: boolean;
    自定义条件?: (this: void, targetUnit: any, sourceUnit?: any) => boolean;
  }) => boolean;
};
const { SUC_GetUnitLife } = require("lib.扩展函数.Star扩展函数.Star扩展库.08．单位判定与筛选函数") as {
  SUC_GetUnitLife: (this: void, unit: any) => number;
};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;

const 存活生命阈值 = 0.405;

export type 范围光环目标类型 = "友军含自己" | "友军不含自己" | "敌人";
export type 范围光环去重类型 = "单位" | "玩家";

export interface 范围光环基础参数 {
  半径: number;
  目标类型: 范围光环目标类型;
  去重类型?: 范围光环去重类型;
  排除无敌?: boolean;
  最小生命值?: number;
  额外筛选?: (this: void, target: any, holder: any) => boolean;
  应用目标效果: (this: void, target: any, holder: any, currentCount: number) => void;
  同步目标效果?: (this: void, target: any, holder: any, currentCount: number) => void;
  移除目标效果: (this: void, target: any, holder: any, currentCount: number) => void;
}

export interface 范围光环参数 extends 范围光环基础参数 {
  物品类型ID: number;
  间隔毫秒: number;
}

export interface 手动范围光环参数 extends 范围光环基础参数 {}

type 持有者光环状态 = {
  目标键列表: number[];
  目标单位列表: any[];
};

type 范围光环实例 = 范围光环基础参数 & {
  持有者状态表: Record<number, 持有者光环状态 | undefined>;
};

type 持有型范围光环实例 = 范围光环实例 & Pick<范围光环参数, "物品类型ID" | "间隔毫秒">;

const 范围光环实例表: 持有型范围光环实例[] = [];
const 手动范围光环实例表: 范围光环实例[] = [];

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取玩家ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return -1;
  const player = GetOwningPlayer(unit);
  if (player == null || player === 0) return -1;
  return GetPlayerId(player);
}

function 单位当前存活(this: void, unit: any, minLife: number): boolean {
  if (unit == null || unit === 0) return false;
  return SUC_GetUnitLife(unit) > minLife;
}

function 构建筛选参数(this: void, 配置: 范围光环实例): {
  仅敌人?: boolean;
  仅友军?: boolean;
  排除自身?: boolean;
  要求有效单位?: boolean;
  允许建筑?: boolean;
  允许机械?: boolean;
  允许古树?: boolean;
  允许无敌?: boolean;
  允许死亡?: boolean;
} {
  if (配置.目标类型 === "敌人") {
    return {
      仅敌人: true,
      排除自身: true,
      要求有效单位: true,
      允许建筑: false,
      允许机械: false,
      允许古树: false,
      允许无敌: 配置.排除无敌 !== true,
      允许死亡: false,
    };
  }
  return {
    仅友军: true,
    排除自身: 配置.目标类型 === "友军不含自己",
    要求有效单位: true,
    允许建筑: false,
    允许机械: false,
    允许古树: false,
    允许无敌: 配置.排除无敌 !== true,
    允许死亡: false,
  };
}

function 目标通过光环筛选(this: void, 配置: 范围光环实例, target: any, holder: any): boolean {
  const 最小生命值 = 配置.最小生命值 == null ? 存活生命阈值 : 配置.最小生命值;
  if (!单位当前存活(target, 最小生命值)) return false;
  if (!matchUnitFilter(target, holder, 构建筛选参数(配置))) return false;
  if (配置.额外筛选 != null && 配置.额外筛选(target, holder) !== true) return false;
  return true;
}

function 取目标去重键(this: void, 配置: 范围光环实例, target: any): number {
  if (配置.去重类型 === "玩家") {
    return 取玩家ID(target);
  }
  return 取单位ID(target);
}

function 构建下一批目标(this: void, 配置: 范围光环实例, holder: any): { 目标键列表: number[]; 目标单位列表: any[] } {
  const x = GetUnitX(holder);
  const y = GetUnitY(holder);
  const units = getUnitsInRange(x, y, 配置.半径);
  const 目标单位映射表: Record<number, any | undefined> = {};
  const 目标键列表: number[] = [];

  for (let i = 0; i < units.length; i++) {
    const target = units[i];
    if (!目标通过光环筛选(配置, target, holder)) continue;
    const 目标键 = 取目标去重键(配置, target);
    if (目标键 < 0) continue;
    if (目标单位映射表[目标键] != null) continue;
    目标单位映射表[目标键] = target;
    let 插入位置 = 目标键列表.length;
    while (插入位置 > 0 && 目标键列表[插入位置 - 1] > 目标键) {
      插入位置 -= 1;
    }
    目标键列表.splice(插入位置, 0, 目标键);
  }

  const 目标单位列表: any[] = [];
  for (let i = 0; i < 目标键列表.length; i++) {
    目标单位列表.push(目标单位映射表[目标键列表[i]]);
  }
  return { 目标键列表, 目标单位列表 };
}

function 取持有者状态(this: void, 配置: 范围光环实例, holderId: number): 持有者光环状态 {
  const 已有状态 = 配置.持有者状态表[holderId];
  if (已有状态 != null) return 已有状态;
  const 新状态: 持有者光环状态 = {
    目标键列表: [],
    目标单位列表: [],
  };
  配置.持有者状态表[holderId] = 新状态;
  return 新状态;
}

function 清理持有者光环(this: void, 配置: 范围光环实例, holder: any, currentCount: number): void {
  const holderId = 取单位ID(holder);
  if (holderId === 0) return;
  const 状态 = 配置.持有者状态表[holderId];
  if (状态 == null) return;
  for (let i = 0; i < 状态.目标单位列表.length; i++) {
    const target = 状态.目标单位列表[i];
    if (target == null || target === 0) continue;
    配置.移除目标效果(target, holder, currentCount);
  }
  delete 配置.持有者状态表[holderId];
}

function 同步单个持有者光环(this: void, 配置: 范围光环实例, holder: any, currentCount: number): void {
  const holderId = 取单位ID(holder);
  if (holderId === 0) return;
  if (!单位当前存活(holder, 存活生命阈值) || currentCount <= 0) {
    清理持有者光环(配置, holder, currentCount);
    return;
  }

  const 状态 = 取持有者状态(配置, holderId);
  const 下一批目标 = 构建下一批目标(配置, holder);
  const 旧键列表 = 状态.目标键列表;
  const 旧单位列表 = 状态.目标单位列表;
  const 新键列表 = 下一批目标.目标键列表;
  const 新单位列表 = 下一批目标.目标单位列表;

  let 旧索引 = 0;
  let 新索引 = 0;
  while (旧索引 < 旧键列表.length || 新索引 < 新键列表.length) {
    const 旧键 = 旧索引 < 旧键列表.length ? 旧键列表[旧索引] : 2147483647;
    const 新键 = 新索引 < 新键列表.length ? 新键列表[新索引] : 2147483647;

    if (旧键 === 新键) {
      const sameTarget = 新单位列表[新索引];
      if (sameTarget != null && sameTarget !== 0 && 配置.同步目标效果 != null) {
        配置.同步目标效果(sameTarget, holder, currentCount);
      }
      旧索引 += 1;
      新索引 += 1;
      continue;
    }

    if (旧键 < 新键) {
      const oldTarget = 旧单位列表[旧索引];
      if (oldTarget != null && oldTarget !== 0) {
        配置.移除目标效果(oldTarget, holder, currentCount);
      }
      旧索引 += 1;
      continue;
    }

    const newTarget = 新单位列表[新索引];
    if (newTarget != null && newTarget !== 0) {
      配置.应用目标效果(newTarget, holder, currentCount);
    }
    新索引 += 1;
  }

  状态.目标键列表 = 新键列表;
  状态.目标单位列表 = 新单位列表;
}

function on范围光环周期(this: void, unit: any, _currentCount: number): void {
  for (let i = 0; i < 范围光环实例表.length; i++) {
    const 配置 = 范围光环实例表[i];
    const 当前数量 = 获取单位当前持有指定物品数量(unit, 配置.物品类型ID);
    if (当前数量 <= 0) continue;
    同步单个持有者光环(配置, unit, 当前数量);
  }
}

function on范围光环丢弃(this: void, unit: any): void {
  for (let i = 0; i < 范围光环实例表.length; i++) {
    const 配置 = 范围光环实例表[i];
    const 当前数量 = 获取单位当前持有指定物品数量(unit, 配置.物品类型ID);
    if (当前数量 > 0) continue;
    清理持有者光环(配置, unit, 1);
  }
}

export function 注册持有型范围光环(this: void, 参数: 范围光环参数): void {
  if (参数 == null || 参数.物品类型ID === 0 || 参数.间隔毫秒 <= 0 || 参数.半径 <= 0) return;
  const 配置: 持有型范围光环实例 = {
    ...参数,
    持有者状态表: {},
  };
  范围光环实例表.push(配置);
  注册持有型周期效果({
    物品类型ID: 参数.物品类型ID,
    间隔毫秒: 参数.间隔毫秒,
    周期回调: on范围光环周期,
    丢弃回调: on范围光环丢弃,
  });
}

export function 创建手动范围光环(this: void, 参数: 手动范围光环参数): number {
  if (参数 == null || 参数.半径 <= 0) return 0;
  const 配置: 范围光环实例 = {
    ...参数,
    持有者状态表: {},
  };
  手动范围光环实例表.push(配置);
  return 手动范围光环实例表.length;
}

export function 同步手动范围光环(this: void, 光环ID: number, 持有者: any, 生效: boolean): void {
  if (光环ID <= 0) return;
  const 配置 = 手动范围光环实例表[光环ID - 1];
  if (配置 == null) return;
  同步单个持有者光环(配置, 持有者, 生效 ? 1 : 0);
}

export {};
