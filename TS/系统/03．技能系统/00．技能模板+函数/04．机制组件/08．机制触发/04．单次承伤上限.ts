/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};

export interface 单次承伤上限清理篮子 {
  登记清理(名称: string, 清理: (this: void) => void): void;
}

export interface 单次承伤上限参数 {
  名称?: string;
  单位: any;
  最大生命比例?: number;
  固定上限?: number;
  优先级?: number;
  清理篮子?: 单次承伤上限清理篮子;
  过滤伤害?: (this: void, context: any) => boolean;
}

export interface 单次承伤上限控制器 {
  readonly 名称: string;
  readonly 修正器ID: number;
  停止(): void;
}

function 取单位ID(this: void, 单位: any): number {
  if (单位 == null || 单位 === 0) return 0;
  return GetHandleId(单位) || 0;
}

function 计算上限(this: void, 参数: 单次承伤上限参数): number {
  let 上限 = 参数.固定上限 ?? 0;
  if (参数.最大生命比例 != null && 参数.最大生命比例 > 0) {
    const 最大生命 = GetUnitState(参数.单位, UNIT_STATE_MAX_LIFE);
    const 百分比上限 = 最大生命 * 参数.最大生命比例;
    if (上限 <= 0 || 百分比上限 < 上限) 上限 = 百分比上限;
  }
  return 上限;
}

class 单次承伤上限控制器实现 implements 单次承伤上限控制器 {
  readonly 名称: string;
  readonly 修正器ID: number;
  private 已停止 = false;

  constructor(名称: string, 修正器ID: number) {
    this.名称 = 名称;
    this.修正器ID = 修正器ID;
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    if (this.修正器ID !== 0) unregisterDamageModifier(this.修正器ID);
  }
}

export function 创建单次承伤上限(this: void, 参数: 单次承伤上限参数): 单次承伤上限控制器 {
  const 名称 = 参数.名称 ?? "单次承伤上限";
  const 目标ID = 取单位ID(参数.单位);
  const 修正器ID = registerDamageModifier(function 单次承伤上限伤害修正(this: void, context: any): number {
    if (目标ID === 0 || 取单位ID(context.target) !== 目标ID) return context.currentDamage;
    if (参数.过滤伤害 != null && !参数.过滤伤害(context)) return context.currentDamage;
    const 上限 = 计算上限(参数);
    if (上限 <= 0 || context.currentDamage <= 上限) return context.currentDamage;
    return 上限;
  }, 参数.优先级 ?? 130);

  const 控制器 = new 单次承伤上限控制器实现(名称, 修正器ID);
  if (参数.清理篮子 != null) {
    参数.清理篮子.登记清理(`${名称}-停止`, function 停止单次承伤上限(this: void): void {
      控制器.停止();
    });
  }
  return 控制器;
}
