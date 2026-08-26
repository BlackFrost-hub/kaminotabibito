/** @noSelfInFile */
/**
 * 技能实例收束适配器（M-06）
 *
 * 每次施法一个实例标识；统一收束 延迟/周期回调、特效、临时单位、自定义清理函数；
 * 结束原因只读一次、只收束一次。复用：
 * - 机制清理篮子（06．机制清理/01）
 * - 独立技能伤害实例（08．技能伤害系统，可选结束时结束）
 * - 中心计时器（回调登记透传）
 *
 * 不把暂停、无敌、Buff、飞行高度写死在适配器里——调用方通过自定义清理函数恢复。
 */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { 创建机制清理篮子 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.06．机制清理.01．机制清理篮子") as {
  创建机制清理篮子: (this: void, 名称: string) => 机制清理篮子;
};
const { 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;

export type 技能实例结束原因 = "完成" | "中断" | "死亡" | "目标失效" | "主动清理";

export interface 技能实例收束参数 {
  名称: string;
  /** 施法者（死亡监听） */
  单位: any;
  /** 独立技能伤害实例 ID（可选，结束时一并结束） */
  技能实例ID?: number;
  数据?: any;
  结束回调?: (this: void, 原因: 技能实例结束原因, 控制器: 技能实例收束控制器) => void;
}

export interface 技能实例收束控制器 {
  /** 每次施法唯一标识 */
  实例标识: number;
  数据: any;
  /** 结束原因（null = 未结束） */
  结束原因: 技能实例结束原因 | null;
  登记延迟回调(this: void, id: number): void;
  登记周期回调(this: void, id: number): void;
  登记特效(this: void, 特效: any): void;
  登记限时特效(this: void, 特效: any, 持续毫秒: number): void;
  登记单位(this: void, 单位: any): void;
  登记自定义清理(this: void, 名称: string, 清理: (this: void) => void): void;
  /** 正常完成 */
  完成(this: void): void;
  /** 施法中断 */
  中断(this: void): void;
  /** 目标失效 */
  目标失效(this: void): void;
  /** 主动清理 */
  主动清理(this: void): void;
  已结束(this: void): boolean;
}

/** 活动实例（单位 handleId → 控制器数组；死亡时统一收束） */
const 活动实例表: Record<number, 技能实例收束控制器[] | undefined> = {};
let 下一个实例标识 = 1;
let 死亡监听已注册 = false;

function 单位有效收束(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 实例收束死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (!单位有效收束(dyingUnit)) return;
  const 列表 = 活动实例表[GetHandleId(dyingUnit)];
  if (列表 == null) return;
  delete 活动实例表[GetHandleId(dyingUnit)];
  for (let i = 0; i < 列表.length; i++) {
    const 控制器 = 列表[i];
    if (控制器 != null && !控制器.已结束()) 控制器.主动清理();
  }
}

function 确保收束死亡监听(this: void): void {
  if (死亡监听已注册) return;
  死亡监听已注册 = true;
  registerDeathListener(实例收束死亡清理);
}

/**
 * 创建技能实例收束控制器。单位死亡时自动以"主动清理"收束。
 */
export function 创建技能实例收束(this: void, 参数: 技能实例收束参数): 技能实例收束控制器 | undefined {
  if (参数.名称 === "") return undefined;

  const 实例标识 = 下一个实例标识++;
  const 篮子: 机制清理篮子 = 创建机制清理篮子(参数.名称 + "-实例" + 实例标识);
  let 已收束 = false;
  let 结束原因: 技能实例结束原因 | null = null;

  function 收束(this: void, 原因: 技能实例结束原因): void {
    if (已收束) return;
    已收束 = true;
    结束原因 = 原因;
    控制器.结束原因 = 原因;
    篮子.清理全部();
    if (参数.技能实例ID != null) 结束独立技能伤害实例(参数.技能实例ID);
    if (单位有效收束(参数.单位)) {
      const 列表 = 活动实例表[GetHandleId(参数.单位)];
      if (列表 != null) {
        const idx = 列表.indexOf(控制器);
        if (idx >= 0) 列表.splice(idx, 1);
        if (列表.length <= 0) delete 活动实例表[GetHandleId(参数.单位)];
      }
    }
    if (参数.结束回调 != null) {
      const 回调 = 参数.结束回调;
      回调(原因, 控制器);
    }
  }

  const 控制器: 技能实例收束控制器 = {
    实例标识,
    数据: 参数.数据,
    结束原因: 结束原因,
    登记延迟回调: function (this: void, id: number): void {
      if (!已收束) 篮子.登记延迟回调("延迟" + id, id);
    },
    登记周期回调: function (this: void, id: number): void {
      if (!已收束) 篮子.登记周期回调("周期" + id, id);
    },
    登记特效: function (this: void, 特效: any): void {
      if (!已收束) 篮子.登记特效("特效" + GetHandleId(特效), 特效);
    },
    登记限时特效: function (this: void, 特效: any, 持续毫秒: number): void {
      if (!已收束) 篮子.登记限时特效("限时特效" + GetHandleId(特效), 特效, 持续毫秒);
    },
    登记单位: function (this: void, 单位: any): void {
      if (!已收束) 篮子.登记单位("单位" + GetHandleId(单位), 单位);
    },
    登记自定义清理: function (this: void, 名称: string, 清理: (this: void) => void): void {
      if (!已收束) 篮子.登记清理(名称, 清理);
    },
    完成: function (this: void): void { 收束("完成"); },
    中断: function (this: void): void { 收束("中断"); },
    目标失效: function (this: void): void { 收束("目标失效"); },
    主动清理: function (this: void): void { 收束("主动清理"); },
    已结束: function (this: void): boolean { return 已收束; },
  };

  if (单位有效收束(参数.单位)) {
    let 列表 = 活动实例表[GetHandleId(参数.单位)];
    if (列表 == null) {
      列表 = [];
      活动实例表[GetHandleId(参数.单位)] = 列表;
    }
    列表.push(控制器);
    确保收束死亡监听();
  }
  return 控制器;
}

/** 读取结束原因（null = 未结束） */
export function 读取技能实例结束原因(this: void, 控制器: 技能实例收束控制器 | undefined): 技能实例结束原因 | null {
  return 控制器 == null ? null : 控制器.结束原因;
}
