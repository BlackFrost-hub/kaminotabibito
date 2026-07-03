/** @noSelfInFile */

import type { 机制清理篮子 } from "../../../00．技能模板+函数/04．机制组件/06．机制清理";
import { 创建Boss运行时上下文工厂 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．Boss运行时上下文工厂";
import { 菲尼克斯尔场地配置 } from "./01．场地配置";
import { 菲尼克斯尔单位技能配置 } from "./00．配置";

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

export type 菲尼克斯尔形态 = "第一形态" | "第二形态" | "永恒轮回";
export type 菲尼克斯尔元素类型 = "火" | "冰" | "毒" | "暗";

export interface 菲尼克斯尔机制单位 {
  单位: any;
  已摧毁: boolean;
}

export interface 菲尼克斯尔运行时上下文 {
  Boss: any;
  Boss单位: any;
  当前形态: 菲尼克斯尔形态;
  开战时间Ms: number;
  清理: 机制清理篮子;
  已摧毁导管数: number;
  导管列表: 菲尼克斯尔机制单位[];
  凤凰蛋列表: 菲尼克斯尔机制单位[];
  怨火核心: any;
  永恒冰核: any;
  怨火锚点: any;
  P1机制已初始化: boolean;
  P2机制已初始化: boolean;
  元素爆发已初始化: boolean;
  怨火核心暴露已初始化: boolean;
  永恒轮回已触发: boolean;
  怨火核心暴露中: boolean;
  当前主导元素: 菲尼克斯尔元素类型;
}

function 创建菲尼克斯尔上下文(this: void, boss: any, 清理: 机制清理篮子): 菲尼克斯尔运行时上下文 {
  return {
    Boss: boss,
    Boss单位: boss,
    当前形态: "第一形态",
    开战时间Ms: getServerTime(),
    清理,
    已摧毁导管数: 0,
    导管列表: [],
    凤凰蛋列表: [],
    怨火核心: undefined,
    永恒冰核: undefined,
    怨火锚点: undefined,
    P1机制已初始化: false,
    P2机制已初始化: false,
    元素爆发已初始化: false,
    怨火核心暴露已初始化: false,
    永恒轮回已触发: false,
    怨火核心暴露中: false,
    当前主导元素: "火",
  };
}

const 菲尼克斯尔上下文工厂 = 创建Boss运行时上下文工厂<菲尼克斯尔运行时上下文>({
  名称: "菲尼克斯尔",
  主动技能提示: 菲尼克斯尔单位技能配置.主动技能提示,
  创建上下文: 创建菲尼克斯尔上下文,
});

export function 获取菲尼克斯尔上下文(this: void, boss: any): 菲尼克斯尔运行时上下文 | undefined {
  return 菲尼克斯尔上下文工厂.获取(boss);
}

export function 获取或创建菲尼克斯尔上下文(this: void, boss: any): 菲尼克斯尔运行时上下文 | undefined {
  return 菲尼克斯尔上下文工厂.获取或创建(boss);
}

export function 创建菲尼克斯尔运行时上下文(this: void, boss: any): 菲尼克斯尔运行时上下文 {
  const context = 获取或创建菲尼克斯尔上下文(boss);
  return context as 菲尼克斯尔运行时上下文;
}

export function 清理菲尼克斯尔上下文(this: void, boss: any): void {
  菲尼克斯尔上下文工厂.清理上下文(boss);
}

export function 取菲尼克斯尔战场中心(this: void): { x: number; y: number } {
  return {
    x: 菲尼克斯尔场地配置.中心点.x,
    y: 菲尼克斯尔场地配置.中心点.y,
  };
}

export function 注册菲尼克斯尔运行时(this: void): void {
  // 当前运行时由 Boss 战启动记录和测试命令主动创建上下文；具体机制在各技能入口初始化。
}
