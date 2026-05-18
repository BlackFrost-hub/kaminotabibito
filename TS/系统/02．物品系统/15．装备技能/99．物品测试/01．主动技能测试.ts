/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

import {
  物品主动技能测试发放顺序,
  物品主动技能测试命令列表,
  物品主动技能测试清理装备列表,
} from "./00．测试配置";

const CreateItem = jass.CreateItem as (id: number, x: number, y: number) => any;
const UnitAddItem = jass.UnitAddItem as (unit: any, item: any) => boolean;
const UnitRemoveItem = jass.UnitRemoveItem as (unit: any, item: any) => boolean;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const UnitItemInSlot = jass.UnitItemInSlot as (unit: any, slot: number) => any;

const 模块名 = "物品主动技能测试";

function 获取测试单位(this: void): any {
  return g.gg_unit_Hamg_0002 ?? (globalThis as any).bj_lastCreatedUnit ?? null;
}

const SetItemPosition = jass.SetItemPosition as (item: any, x: number, y: number) => void;

function 丢弃测试装备(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  const x = GetUnitX(unit);
  const y = GetUnitY(unit);
  for (let i = 0; i < 6; i++) {
    const item = UnitItemInSlot(unit, i);
    if (item == null || item === 0) continue;
    const itemTypeId = GetItemTypeId(item);
    for (let j = 0; j < 物品主动技能测试清理装备列表.length; j++) {
      const 装备名 = 物品主动技能测试清理装备列表[j];
      const rawId = 按名字反查物品ID(装备名);
      if (rawId == null || rawId === "") continue;
      if (stringToFourCCSafe(rawId) === itemTypeId) {
        UnitRemoveItem(unit, item);
        SetItemPosition(item, x, y);
        break;
      }
    }
  }
}

function 发放装备(this: void, unit: any, 装备名: string): void {
  const rawId = 按名字反查物品ID(装备名);
  if (rawId == null || rawId === "") {
    debugLogForce(模块名, "未找到装备ID", 装备名);
    return;
  }
  const item = CreateItem(stringToFourCCSafe(rawId), GetUnitX(unit), GetUnitY(unit));
  if (item == null || item === 0) {
    debugLogForce(模块名, "创建装备失败", 装备名, rawId);
    return;
  }
  UnitAddItem(unit, item);
}

function 发放单个装备(this: void, unit: any, 序号: number): void {
  丢弃测试装备(unit);
  if (序号 > 0 && 序号 <= 物品主动技能测试发放顺序.length) {
    发放装备(unit, 物品主动技能测试发放顺序[序号 - 1]);
    debugLogForce(模块名, "已发放测试装备", 序号, 物品主动技能测试发放顺序[序号 - 1]);
  }
}

function on聊天wp测试(this: void, _player: any, command: string): void {
  const unit = 获取测试单位();
  if (unit == null || unit === 0) {
    debugLogForce(模块名, "未找到大法师单位");
    return;
  }

  for (let i = 0; i < 物品主动技能测试命令列表.length; i++) {
    if (command === 物品主动技能测试命令列表[i]) {
      发放单个装备(unit, i + 1);
      return;
    }
  }
}

for (let i = 0; i < 物品主动技能测试命令列表.length; i++) {
  注册聊天命令监听(物品主动技能测试命令列表[i], on聊天wp测试);
}

debugLogForce(模块名, "已注册测试命令", 物品主动技能测试命令列表.join(","));

export {};
