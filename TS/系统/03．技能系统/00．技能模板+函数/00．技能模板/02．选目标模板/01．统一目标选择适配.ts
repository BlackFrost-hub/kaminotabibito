/** @noSelfInFile */
/**
 * 统一目标选择适配（M-03）
 *
 * 统一配置入口：按显式「模式」字段转发到正确的底层，不合并英雄/Boss 业务语义，不自动猜测模式。
 * - 英雄模式 → 技能模板/02．选目标模板/00．目标筛选模板（范围/最近/最远/血量/扇形/矩形/主副）
 * - Boss 模式 → 仇恨系统/05．技能目标选择（最高仇恨/应攻击/随机/最近/最远/全部敌对）
 *
 * 保留：Boss 测试目标、注册玩家英雄优先级、Boss 默认范围（均由仇恨系统底层承担）；普通英雄不访问仇恨表。
 */

import { 获取范围内单位组, 选择范围内最近目标, 选择范围内最远目标, 选择范围内血量最低目标, 选择范围内血量最高目标, 选择扇形区域内最近目标, 选择矩形区域内最近目标, 选择主目标和副目标, type 范围目标筛选参数, type 技能筛选条件 } from "./00．目标筛选模板";
import type { 英雄技能距离修正上下文 } from "../../04．机制组件/11．技能属性修正";

const jass = require("jass.common") as any;
const GetUnitXSafe = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitYSafe = jass.GetUnitY as (this: void, unit: any) => number;
const GetRandomIntSafe = jass.GetRandomInt as (this: void, low: number, high: number) => number;

const { 获取Boss技能最高仇恨目标, 获取Boss技能应攻击目标, 获取Boss技能随机敌对英雄, 获取Boss技能最近敌对英雄Ex, 获取Boss技能最远敌对英雄Ex, 获取Boss技能敌对英雄列表Ex } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能最高仇恨目标: (this: void, boss: any, filter?: (this: void, entry: any) => boolean) => any;
  获取Boss技能应攻击目标: (this: void, boss: any, filter?: (this: void, entry: any) => boolean) => any;
  获取Boss技能随机敌对英雄: (this: void, boss: any, centerUnit?: any, radius?: number, excludeList?: any[], filter?: 技能筛选条件) => any;
  获取Boss技能最近敌对英雄Ex: (this: void, boss: any, centerUnit?: any, radius?: number, excludeList?: any[], filter?: 技能筛选条件) => any;
  获取Boss技能最远敌对英雄Ex: (this: void, boss: any, centerUnit?: any, radius?: number, excludeList?: any[], filter?: 技能筛选条件) => any;
  获取Boss技能敌对英雄列表Ex: (this: void, boss: any, centerUnit?: any, radius?: number, excludeList?: any[], filter?: 技能筛选条件) => any[];
};

export type 统一目标选择模式 =
  | "英雄-范围内"
  | "英雄-最近"
  | "英雄-最远"
  | "英雄-血量最低"
  | "英雄-血量最高"
  | "英雄-扇形最近"
  | "英雄-矩形最近"
  | "英雄-随机"
  | "英雄-主副目标"
  | "Boss-最高仇恨"
  | "Boss-应攻击"
  | "Boss-随机"
  | "Boss-最近"
  | "Boss-最远"
  | "Boss-全部敌对";

export interface 统一目标选择参数 {
  /** 显式模式（禁止自动猜测英雄/Boss） */
  模式: 统一目标选择模式;
  /** 来源单位：英雄模式为筛选中心单位，Boss 模式为 Boss */
  来源单位: any;
  /** 英雄模式可选的中心坐标（缺省取来源单位位置） */
  中心坐标?: { X: number; Y: number };
  /** 半径（英雄范围类；Boss-最近/最远由仇恨系统默认范围） */
  半径?: number;
  /** 英雄技能距离修正上下文，透传给范围/扇形/矩形底层。 */
  英雄技能距离修正?: 英雄技能距离修正上下文;
  /** 矩形参数（英雄-矩形最近） */
  矩形?: { 长度: number; 宽度: number; 方向角: number; 包含边界?: boolean };
  /** 扇形参数（英雄-扇形最近） */
  扇形?: { 方向角: number; 角度: number };
  /** 阵营（英雄范围类）：缺省敌方 */
  阵营?: "敌方" | "友方" | "全部";
  /** 排除单位 */
  排除列表?: any[];
  /** 旧的单个排除单位字段，兼容直接转发的调用方。 */
  排除单位?: any;
  /** 额外单位过滤条件 */
  自定义条件?: 技能筛选条件;
  /** Boss 目标选择的距离中心；缺省使用来源单位。 */
  中心单位?: any;
  /** 主目标（英雄-主副目标） */
  主目标?: any;
  /** 数量限制（范围内/全部敌对/副目标数量） */
  数量限制?: number;
}

export interface 统一目标选择结果 {
  单位: any;
  列表: any[];
}

function 中心坐标(this: void, 参数: 统一目标选择参数): { X: number; Y: number } {
  if (参数.中心坐标 != null) return 参数.中心坐标;
  return { X: GetUnitXSafe(参数.来源单位), Y: GetUnitYSafe(参数.来源单位) };
}

function 构建英雄范围参数(this: void, 参数: 统一目标选择参数): 范围目标筛选参数 {
  const c = 中心坐标(参数);
  const base: 范围目标筛选参数 = {
    X: c.X,
    Y: c.Y,
    半径: 参数.半径 ?? 600,
    英雄技能距离修正: 参数.英雄技能距离修正,
    影响目标: 参数.阵营 ?? "敌方",
    来源单位: 参数.来源单位,
    排除单位: 参数.排除单位,
    自定义条件: function 统一英雄目标条件(this: void, 单位: any): boolean {
      if (参数.排除列表 != null) {
        for (let i = 0; i < 参数.排除列表.length; i++) {
          if (参数.排除列表[i] === 单位) return false;
        }
      }
      return 参数.自定义条件 == null || 参数.自定义条件(单位);
    },
  };
  return base;
}

function 截断结果(this: void, 列表: any[], 数量限制?: number): any[] {
  return 数量限制 != null && 数量限制 > 0 ? 列表.slice(0, 数量限制) : 列表;
}

function Boss目标过滤(this: void, 参数: 统一目标选择参数, 目标: any): boolean {
  if (参数.排除单位 != null && 参数.排除单位 === 目标) return false;
  if (参数.排除列表 != null) {
    for (let i = 0; i < 参数.排除列表.length; i++) {
      if (参数.排除列表[i] === 目标) return false;
    }
  }
  return 参数.自定义条件 == null || 参数.自定义条件(目标);
}

function Boss目标在范围内(this: void, 参数: 统一目标选择参数, 目标: any): boolean {
  const 中心 = 参数.中心单位 ?? 参数.来源单位;
  if (参数.半径 == null || !(参数.半径 > 0) || 中心 == null || 中心 === 0) return true;
  const dx = GetUnitXSafe(目标) - GetUnitXSafe(中心);
  const dy = GetUnitYSafe(目标) - GetUnitYSafe(中心);
  return dx * dx + dy * dy <= 参数.半径 * 参数.半径;
}

function Boss英雄过滤器(this: void, 参数: 统一目标选择参数, 目标: any): boolean {
  return Boss目标过滤(参数, 目标) && Boss目标在范围内(参数, 目标);
}

function Boss仇恨过滤器(this: void, 参数: 统一目标选择参数, entry: any): boolean {
  return entry != null && Boss英雄过滤器(参数, entry.targetRef);
}

/**
 * 统一目标选择入口。
 * @returns { 单位: 单一目标（列表类模式取首个/空为 null）, 列表: 完整列表 }
 */
export function 统一选择目标(this: void, 参数: 统一目标选择参数): 统一目标选择结果 {
  const 模式 = 参数.模式;
  const 空: 统一目标选择结果 = { 单位: null, 列表: [] };

  if (参数.来源单位 == null || 参数.来源单位 === 0) return 空;

  // ---------------- 英雄模式 ----------------
  if (模式 === "英雄-范围内") {
    const 列表 = 获取范围内单位组(构建英雄范围参数(参数));
    const 截断 = 截断结果(列表, 参数.数量限制);
    return { 单位: 截断.length > 0 ? 截断[0] : null, 列表: 截断 };
  }
  if (模式 === "英雄-最近") {
    const 单位 = 选择范围内最近目标(构建英雄范围参数(参数));
    return { 单位, 列表: 单位 == null ? [] : [单位] };
  }
  if (模式 === "英雄-最远") {
    const 单位 = 选择范围内最远目标(构建英雄范围参数(参数));
    return { 单位, 列表: 单位 == null ? [] : [单位] };
  }
  if (模式 === "英雄-血量最低") {
    const 单位 = 选择范围内血量最低目标(构建英雄范围参数(参数));
    return { 单位, 列表: 单位 == null ? [] : [单位] };
  }
  if (模式 === "英雄-血量最高") {
    const 单位 = 选择范围内血量最高目标(构建英雄范围参数(参数));
    return { 单位, 列表: 单位 == null ? [] : [单位] };
  }
  if (模式 === "英雄-扇形最近") {
    const 参数2 = 构建英雄范围参数(参数);
    const 单位 = 选择扇形区域内最近目标({
      ...参数2,
      方向角: 参数.扇形?.方向角 ?? 0,
      扇形角度: 参数.扇形?.角度 ?? 90,
    });
    return { 单位, 列表: 单位 == null ? [] : [单位] };
  }
  if (模式 === "英雄-矩形最近") {
    const 参数2 = 构建英雄范围参数(参数);
    const 矩形 = 参数.矩形 ?? { 长度: 参数.半径 ?? 600, 宽度: 参数.半径 ?? 600, 方向角: 0 };
    const 单位 = 选择矩形区域内最近目标({
      ...参数2,
      长度: 矩形.长度,
      宽度: 矩形.宽度,
      方向角: 矩形.方向角,
      包含边界: 矩形.包含边界,
    });
    return { 单位, 列表: 单位 == null ? [] : [单位] };
  }
  if (模式 === "英雄-随机") {
    const 列表 = 获取范围内单位组(构建英雄范围参数(参数));
    if (列表.length <= 0) return 空;
    const 单位 = 列表[GetRandomIntSafe(0, 列表.length - 1)];
    return { 单位, 列表: [单位] };
  }
  if (模式 === "英雄-主副目标") {
    const 参数2 = 构建英雄范围参数(参数);
    const 结果 = 选择主目标和副目标({
      ...参数2,
      主目标: 参数.主目标 ?? null,
      副目标数量: 参数.数量限制 ?? 1,
    });
    return { 单位: 结果.主目标 ?? null, 列表: 结果.副目标列表 ?? [] };
  }

  // ---------------- Boss 模式 ----------------
  if (模式 === "Boss-最高仇恨") {
    const entry = 获取Boss技能最高仇恨目标(参数.来源单位, function Boss最高仇恨过滤(this: void, item: any): boolean {
      return Boss仇恨过滤器(参数, item);
    }) as any;
    const 单位 = entry != null ? entry.targetRef : null;
    return { 单位, 列表: 单位 == null ? [] : [单位] };
  }
  if (模式 === "Boss-应攻击") {
    const entry = 获取Boss技能应攻击目标(参数.来源单位, function Boss应攻击过滤(this: void, item: any): boolean {
      return Boss仇恨过滤器(参数, item);
    }) as any;
    const 单位 = entry != null ? (entry.targetRef ?? entry) : null;
    return { 单位, 列表: 单位 == null ? [] : [单位] };
  }
  if (模式 === "Boss-随机") {
    const 单位 = 获取Boss技能随机敌对英雄(参数.来源单位, 参数.中心单位 ?? 参数.来源单位, 参数.半径, 参数.排除列表, function Boss随机过滤(this: void, hero: any): boolean {
      return Boss目标过滤(参数, hero);
    });
    return { 单位, 列表: 单位 == null ? [] : [单位] };
  }
  if (模式 === "Boss-最近") {
    const 单位 = 获取Boss技能最近敌对英雄Ex(参数.来源单位, 参数.中心单位 ?? 参数.来源单位, 参数.半径, 参数.排除列表, function Boss最近过滤(this: void, hero: any): boolean {
      return Boss目标过滤(参数, hero);
    });
    return { 单位, 列表: 单位 == null ? [] : [单位] };
  }
  if (模式 === "Boss-最远") {
    const 单位 = 获取Boss技能最远敌对英雄Ex(参数.来源单位, 参数.中心单位 ?? 参数.来源单位, 参数.半径, 参数.排除列表, function Boss最远过滤(this: void, hero: any): boolean {
      return Boss目标过滤(参数, hero);
    });
    return { 单位, 列表: 单位 == null ? [] : [单位] };
  }
  if (模式 === "Boss-全部敌对") {
    const 列表 = 获取Boss技能敌对英雄列表Ex(参数.来源单位, 参数.中心单位 ?? 参数.来源单位, 参数.半径, 参数.排除列表, function Boss全部过滤(this: void, hero: any): boolean {
      return Boss目标过滤(参数, hero);
    });
    const 截断 = 截断结果(列表, 参数.数量限制);
    return { 单位: 截断.length > 0 ? 截断[0] : null, 列表: 截断 };
  }

  return 空;
}
