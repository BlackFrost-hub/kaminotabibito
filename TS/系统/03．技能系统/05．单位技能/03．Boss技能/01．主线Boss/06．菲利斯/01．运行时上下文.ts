/** @noSelfInFile */

import type { 机制清理篮子 } from "../../../../00．技能模板+函数/04．机制组件/06．机制清理";
import { 创建单位运行时上下文工厂 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂";
import { 菲利斯单位技能配置 } from "./00．配置";
import { 播放菲利斯台词 } from "./08．台词播放";
import { stringToFourCC } from "./11．公共工具";

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const 菲利斯单位类型ID = stringToFourCC(菲利斯单位技能配置.单位ID);

export type 菲利斯阶段 = 1 | 2;

export interface 菲利斯剑魂狼记录 {
  Boss单位: any;
  大狼: boolean;
  伤害比例: number;
}

export interface 菲利斯运行时上下文 {
  Boss单位: any;
  阶段: 菲利斯阶段;
  开战时间Ms: number;
  清理: 机制清理篮子;
  当前魔法充能: number;
  当前领袖光环低血: boolean;
  异形化中: boolean;
  异形化结束Ms: number;
  已初始化: boolean;
}

const 菲利斯剑魂狼表: Record<number, 菲利斯剑魂狼记录 | undefined> = {};
let 菲利斯死亡清理已注册 = false;

function 创建菲利斯上下文(this: void, boss: any, 清理: 机制清理篮子): 菲利斯运行时上下文 {
  播放菲利斯台词(boss, "开场", 0);
  return {
    Boss单位: boss,
    阶段: 1,
    开战时间Ms: getServerTime(),
    清理,
    当前魔法充能: 0,
    当前领袖光环低血: false,
    异形化中: false,
    异形化结束Ms: 0,
    已初始化: false,
  };
}

const 菲利斯上下文工厂 = 创建单位运行时上下文工厂<菲利斯运行时上下文>({
  名称: "菲利斯",
  主动技能提示: 菲利斯单位技能配置.主动技能提示,
  创建上下文: 创建菲利斯上下文,
});

export function 获取菲利斯上下文(this: void, boss: any): 菲利斯运行时上下文 | undefined {
  return 菲利斯上下文工厂.获取(boss);
}

export function 获取或创建菲利斯上下文(this: void, boss: any): 菲利斯运行时上下文 | undefined {
  return 菲利斯上下文工厂.获取或创建(boss);
}

export function 清理菲利斯上下文(this: void, boss: any): void {
  菲利斯上下文工厂.清理上下文(boss);
}

export function 获取全部菲利斯上下文(this: void): 菲利斯运行时上下文[] {
  return 菲利斯上下文工厂.获取全部();
}

export function 登记菲利斯剑魂狼(this: void, wolf: any, record: 菲利斯剑魂狼记录): void {
  const id = 菲利斯上下文工厂.取单位ID(wolf);
  if (id === 0) return;
  菲利斯剑魂狼表[id] = record;
}

export function 注销菲利斯剑魂狼(this: void, wolf: any): void {
  const id = 菲利斯上下文工厂.取单位ID(wolf);
  if (id !== 0) delete 菲利斯剑魂狼表[id];
}

export function 获取菲利斯剑魂狼记录(this: void, wolf: any): 菲利斯剑魂狼记录 | undefined {
  const id = 菲利斯上下文工厂.取单位ID(wolf);
  return id === 0 ? undefined : 菲利斯剑魂狼表[id];
}

function on菲利斯单位死亡(this: void, dyingUnit: any): void {
  if (GetUnitTypeId(dyingUnit) === 菲利斯单位类型ID) {
    播放菲利斯台词(dyingUnit, "死亡", 0);
  }
  const id = 菲利斯上下文工厂.取单位ID(dyingUnit);
  if (id === 0) return;
  if (菲利斯上下文工厂.获取(dyingUnit) != null) 清理菲利斯上下文(dyingUnit);
  if (菲利斯剑魂狼表[id] != null) delete 菲利斯剑魂狼表[id];
}

export function 注册菲利斯运行时(this: void): void {
  if (菲利斯死亡清理已注册) return;
  菲利斯死亡清理已注册 = true;
  registerDeathListener(on菲利斯单位死亡);
}
