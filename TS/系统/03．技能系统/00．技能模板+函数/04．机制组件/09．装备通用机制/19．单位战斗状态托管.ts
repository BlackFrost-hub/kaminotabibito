/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 创建战斗状态触发器 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.07．战斗状态触发器") as {
  创建战斗状态触发器: (this: void, 参数: {
    名称?: string;
    单位: any;
    主体类型?: "玩家英雄" | "Boss" | "普通单位";
    周期触发秒?: number;
    on周期触发?: (this: void, event: { 单位: any }) => void;
  }) => { 停止(): void };
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;

export interface 单位战斗状态托管参数 {
  名称?: string;
  主体类型?: "玩家英雄" | "Boss" | "普通单位";
  周期触发秒?: number;
  on周期触发?: (this: void, event: { 单位: any }) => void;
}

export interface 单位战斗状态托管器 {
  加入(this: void, unit: any): void;
  移除(this: void, unit: any): void;
  已加入(this: void, unit: any): boolean;
}

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 创建单位战斗状态托管器(this: void, 参数: 单位战斗状态托管参数): 单位战斗状态托管器 {
  const 控制器表: Record<number, { 停止(): void } | undefined> = {};

  function 已加入(this: void, unit: any): boolean {
    const unitId = 取单位ID(unit);
    return unitId !== 0 && 控制器表[unitId] != null;
  }

  function 加入(this: void, unit: any): void {
    const unitId = 取单位ID(unit);
    if (unitId === 0 || 控制器表[unitId] != null) return;
    控制器表[unitId] = 创建战斗状态触发器({
      名称: 参数.名称,
      单位: unit,
      主体类型: 参数.主体类型,
      周期触发秒: 参数.周期触发秒,
      on周期触发: 参数.on周期触发,
    });
  }

  function 移除(this: void, unit: any): void {
    const unitId = 取单位ID(unit);
    if (unitId === 0) return;
    const 控制器 = 控制器表[unitId];
    if (控制器 != null) {
      控制器.停止();
      delete 控制器表[unitId];
    }
  }

  return { 加入, 移除, 已加入 };
}
