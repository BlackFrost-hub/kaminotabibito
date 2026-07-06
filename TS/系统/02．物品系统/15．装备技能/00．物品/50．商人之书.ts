/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 单位存活, 增加英雄经验与智力 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 创建单位永久标记 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/22．单位永久标记";

const { 获取玩家英雄单位组 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  获取玩家英雄单位组: (this: void) => any;
};
const { 开始充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, 单位: any, 参数: any) => number;
};

const jass = require("jass.common") as any;
const GetHeroInt = jass.GetHeroInt as (whichHero: any, includeBonuses: boolean) => number;
const ForGroup = jass.ForGroup as (whichGroup: any, callback: () => void) => void;
const GetEnumUnit = jass.GetEnumUnit as () => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const GetPlayerId = jass.GetPlayerId as (whichPlayer: any) => number;
const Player = jass.Player as (playerId: number) => any;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (whichPlayer: any, x: number, y: number, duration: number, message: string) => void;

const 商人之书已参悟 = 创建单位永久标记("商人之书已参悟");
const 商人之书施法毫秒 = 3000;
const 商人之书提示前缀 = "|cffffff00『系统提示』|r：";
const 商人之书施法中: Record<number, boolean | undefined> = {};

let 智力比较目标智力 = 0;
let 智力比较最大值 = 0;

function 提示商人之书(this: void, unit: any, text: string): void {
  if (unit == null || unit === 0) return;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return;
  DisplayTimedTextToPlayer(Player(GetPlayerId(owner)), 0, 0, 5, 商人之书提示前缀 + text + "|r");
}

function on统计最高智力英雄(this: void): void {
  const hero = GetEnumUnit();
  if (!单位存活(hero)) return;
  const value = GetHeroInt(hero, true);
  if (value > 智力比较最大值) 智力比较最大值 = value;
}

function 是否当前最高智力英雄(this: void, unit: any): boolean {
  if (!单位存活(unit)) return false;
  const group = 获取玩家英雄单位组();
  if (group == null || group === 0) return true;
  智力比较目标智力 = GetHeroInt(unit, true);
  智力比较最大值 = 智力比较目标智力;
  ForGroup(group, on统计最高智力英雄);
  return 智力比较目标智力 >= 智力比较最大值;
}

function on商人之书充能完成(this: void, unit: any, _充能ID: number): void {
  const id = GetHandleId(unit) || 0;
  if (id !== 0) delete 商人之书施法中[id];
  if (!单位存活(unit)) return;
  if (!是否当前最高智力英雄(unit)) {
    提示商人之书(unit, "此书晦涩难懂，我看不明白。");
    return;
  }
  if (!商人之书已参悟.标记若不存在(unit)) {
    提示商人之书(unit, "这本书的内容已经被参透了。");
    return;
  }
  const cfg = 物品使用数值配置.商人之书;
  增加英雄经验与智力(unit, cfg.经验次数, cfg.每次经验, cfg.智力增加);
  提示商人之书(unit, "你读懂了商人的手札，获得经验与智力提升。");
}

function on商人之书充能结束(this: void, unit: any, _原因: any, _充能ID: number): void {
  const id = GetHandleId(unit) || 0;
  if (id !== 0) delete 商人之书施法中[id];
}

export function 处理商人之书使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.商人之书)) return;
  const unit = ctx.施法单位;
  if (!是否当前最高智力英雄(unit)) {
    提示商人之书(unit, "此书晦涩难懂，我看不明白。");
    return;
  }
  if (商人之书已参悟.存在(unit)) {
    提示商人之书(unit, "这本书的内容已经被参透了。");
    return;
  }
  const id = GetHandleId(unit) || 0;
  if (id !== 0 && 商人之书施法中[id] === true) return;
  if (id !== 0) 商人之书施法中[id] = true;
  开始充能(unit, {
    持续时间: 商人之书施法毫秒 / 1000,
    主单位: unit,
    主单位死亡时中断: true,
    强制硬直: true,
    显示进度条特效: true,
    充能完成回调: on商人之书充能完成,
    结束回调: on商人之书充能结束,
  });
}

export {};
