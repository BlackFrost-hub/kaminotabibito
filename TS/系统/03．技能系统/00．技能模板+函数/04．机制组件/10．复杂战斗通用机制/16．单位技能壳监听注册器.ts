/** @noSelfInFile */

import { stringToFourCC, 单位有效 } from "../../02．通用函数/19．战斗公共工具";

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};

const { 创建独立技能伤害实例, 绑定单位当前独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  创建独立技能伤害实例: (this: void, 参数?: {
    技能ID?: number;
    来源类型?: string;
    标签?: string;
    持续时间Ms?: number;
    持续时间秒?: number;
  }) => number;
  绑定单位当前独立技能伤害实例: (this: void, 单位: any, id: number | undefined) => void;
};

export interface 单位技能壳监听参数<T> {
  名称: string;
  单位类型ID: string | number;
  技能ID: string | number;
  获取或创建上下文: (this: void, unit: any) => T | undefined;
  释放技能: (this: void, context: T, unit: any, 技能实例ID?: number) => void;
  可释放?: (this: void, context: T, unit: any) => boolean;
  创建独立技能实例?: boolean;
  独立技能来源类型?: string;
  技能实例持续时间Ms?: number;
  技能实例持续时间秒?: number;
}

const 监听列表: 单位技能壳监听参数<any>[] = [];
let 已注册监听 = false;

/** 20-25号新英雄调试用：单位类型ID -> 英雄名（用于一次定位定位事件流到达层级） */
const 新英雄调试类型ID表: Record<number, string> = {
  [stringToFourCC("E0L0")]: "爱蜜莉雅",
  [stringToFourCC("E0L1")]: "朱雀院红叶",
  [stringToFourCC("E0L2")]: "朱雀院椿",
  [stringToFourCC("E0L3")]: "伊蕾娜",
  [stringToFourCC("E0L4")]: "塞莉亚·克莱尔",
  [stringToFourCC("E0L5")]: "芙莉莲",
};

function 转ID(this: void, id: string | number): number {
  return typeof id === "number" ? id : stringToFourCC(id);
}

function on单位技能壳监听施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (!单位有效(castingUnit)) return;
  const unitTypeId = GetUnitTypeId(castingUnit);
  const 调试英雄名 = 新英雄调试类型ID表[unitTypeId];
  if (调试英雄名 != null) {
    debugLogForce(
      "新英雄技能壳诊断",
      "收到施法",
      "英雄",
      调试英雄名,
      "技能ID",
      spellAbilityId,
      "监听总数",
      监听列表.length,
    );
  }
  if (unitTypeId === 转ID("H00F") || unitTypeId === 转ID("H00G")) {
    debugLogForce(
      "阿伦劳特技能壳诊断",
      "收到施法",
      "施法单位类型ID",
      unitTypeId,
      "技能ID",
      spellAbilityId,
      "监听总数",
      监听列表.length,
    );
  }
  for (let i = 0; i < 监听列表.length; i++) {
    const 参数 = 监听列表[i];
    if (spellAbilityId !== 转ID(参数.技能ID)) continue;
    if (unitTypeId !== 转ID(参数.单位类型ID)) continue;
    const context = 参数.获取或创建上下文(castingUnit);
    if (context == null) continue;
    if (参数.可释放 != null && !参数.可释放(context, castingUnit)) continue;
    const 技能实例ID = 参数.创建独立技能实例 === false
      ? undefined
      : 创建独立技能伤害实例({
        技能ID: spellAbilityId,
        来源类型: 参数.独立技能来源类型 ?? "Boss技能",
        标签: 参数.名称,
        持续时间Ms: 参数.技能实例持续时间Ms,
        持续时间秒: 参数.技能实例持续时间秒,
      });
    绑定单位当前独立技能伤害实例(castingUnit, 技能实例ID);
    if (调试英雄名 != null) {
      debugLogForce("新英雄技能壳诊断", "命中监听", "英雄", 调试英雄名, "技能ID", spellAbilityId, "监听名", 参数.名称, "实例ID", 技能实例ID);
    }
    参数.释放技能(context, castingUnit, 技能实例ID);
  }
}

function 确保单位技能壳总监听(this: void): void {
  if (已注册监听) return;
  已注册监听 = true;
  registerSpellEffectListener(on单位技能壳监听施法);
}

export function 注册单位技能壳监听<T>(this: void, 参数: 单位技能壳监听参数<T>): void {
  确保单位技能壳总监听();
  监听列表.push(参数 as 单位技能壳监听参数<any>);
}

export {};
