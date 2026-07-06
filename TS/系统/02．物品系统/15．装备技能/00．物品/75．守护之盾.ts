/** @noSelfInFile */

import { 守护之盾配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";
import { 创建单位动态加成同步器 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { 创建友军范围承伤转移 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/20．友军范围承伤转移";

const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果") as {
  注册持有型周期效果: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    周期回调: (this: void, unit: any, currentCount: number) => void;
    获取回调?: (this: void, unit: any, currentCount: number) => void;
    丢弃回调?: (this: void, unit: any, currentCount: number) => void;
  }) => { 获取单位列表: (this: void) => any[] } | null;
};
const { 获取单位当前持有指定物品数量 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听") as {
  获取单位当前持有指定物品数量: (this: void, unit: any, itemTypeId: number) => number;
};
const { 变更资源值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  变更资源值: (this: void, target: any, amount: number, type: "life" | "mana", showText?: boolean, showEffect?: boolean, effectPath?: string, lowestValue?: number) => number;
};
const { 临时调整攻击, 单位存活 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
  单位存活: (this: void, unit: any) => boolean;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const ConvertUnitState = jass.ConvertUnitState as (id: number) => any;

const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;

let 已注册守护之盾伤害修正 = false;
let 守护之盾持有控制器: { 获取单位列表: (this: void) => any[] } | null = null;

const 守护之盾攻击加成 = 创建单位动态加成同步器<"攻击">(
  function 应用守护之盾攻击加成(this: void, unit: any, _key: "攻击", delta: number): void {
    临时调整攻击(unit, delta);
  },
);

function 取单位护甲(this: void, unit: any): number {
  return GetUnitStateJapi(unit, ConvertUnitState(0x20));
}

function 清理守护之盾攻击加成(this: void, unit: any): void {
  守护之盾攻击加成.清理(unit);
}

function on守护之盾攻击同步(this: void, unit: any, currentCount: number): void {
  if (!单位存活(unit) || currentCount <= 0) {
    清理守护之盾攻击加成(unit);
    return;
  }
  const nextBonus = 取单位护甲(unit) * 守护之盾配置.防转攻比例 * currentCount;
  守护之盾攻击加成.同步(unit, "攻击", nextBonus);
}

function on守护之盾丢弃(this: void, unit: any): void {
  清理守护之盾攻击加成(unit);
}

function 守护之盾受击过滤(this: void, event: { 受击者: any }): boolean {
  return 单位存活(event.受击者);
}

function 守护之盾可承受者(this: void, event: { 候选单位: any }): boolean {
  const holder = event.候选单位;
  return 单位存活(holder) && 获取单位当前持有指定物品数量(holder, 获得物品装备ID.守护之盾) > 0;
}

function on守护之盾转移(this: void, event: { 承受者: any; 转移伤害: number }): void {
  变更资源值(event.承受者, -event.转移伤害, "life", true, false, undefined, 0);
}

function 初始化守护之盾(this: void): void {
  if (获得物品装备ID.守护之盾 === 0) return;
  守护之盾持有控制器 = 注册持有型周期效果({
    物品类型ID: 获得物品装备ID.守护之盾,
    间隔毫秒: 守护之盾配置.攻击同步间隔毫秒,
    周期回调: on守护之盾攻击同步,
    丢弃回调: on守护之盾丢弃,
  });
  if (!已注册守护之盾伤害修正) {
    已注册守护之盾伤害修正 = true;
    创建友军范围承伤转移({
      名称: "守护之盾承伤转移",
      转移比例: 守护之盾配置.转移比例,
      转移半径: 守护之盾配置.转移半径,
      优先级: 35,
      获取候选单位列表: function 获取守护之盾持有者列表(this: void): any[] {
        return 守护之盾持有控制器?.获取单位列表() ?? [];
      },
      过滤伤害: 守护之盾受击过滤,
      可承受者: 守护之盾可承受者,
      on转移: on守护之盾转移,
    });
  }
}

初始化守护之盾();

export {};
