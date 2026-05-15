/** @noSelfInFile */
/**
 * 区域效果测试
 *
 * 输入 "1101"：在大法师位置创建区域效果，测试进入/离开事件
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};

const sfbModule = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统") as {
  SFB_setBuff: (this: void, sourceUnit: any, u: any, id: number, time: number) => void;
  SFB_setSlow: (this: void, sourceUnit: any, u: any, as: number, ms: number, time: number) => void;
  SFB_Unit: any;
};
const { SFB_setBuff, SFB_setSlow } = sfbModule;

const 模块名 = "区域效果测试";
const 测试命令 = "1101";

function getSFBUnit(): any {
  return sfbModule.SFB_Unit;
}

function safeUnitName(u: any): string {
  if (u == null || u === 0) return "无效单位";
  const n = GetUnitName(u);
  return (typeof n === "string" && n !== "") ? n : "无名单位";
}

function safeHid(h: any): number {
  if (h == null || h === 0) return 0;
  return GetHandleId(h);
}

import { 创建区域效果 } from "../01．技能函数/04．区域效果/区域效果";

let 当前测试单位: any | undefined;

function 区域效果测试_进入(单位: any): void {
  const 测试单位 = 当前测试单位;
  if (测试单位 == null || 测试单位 === 0 || 单位 == null || 单位 === 0) {
    debugLogForce(模块名, "[进入-跳过] 测试单位或进入单位无效");
    return;
  }

  const sfbUnit = getSFBUnit();
  debugLogForce(模块名, "[进入] SFB_Unit=" + (sfbUnit != null && sfbUnit !== 0 ? "有效(hid=" + safeHid(sfbUnit) + ")" : "NULL!") + " 目标=" + safeUnitName(单位) + "(hid=" + safeHid(单位) + ")");
  SFB_setSlow(测试单位, 单位, 0, 30, 1);
  debugLogForce(模块名, "进入区域，减速1秒");
}

function 区域效果测试_离开(单位: any): void {
  const 测试单位 = 当前测试单位;
  if (测试单位 == null || 测试单位 === 0 || 单位 == null || 单位 === 0) {
    debugLogForce(模块名, "[离开-跳过] 测试单位或离开单位无效");
    return;
  }

  const sfbUnit = getSFBUnit();
  debugLogForce(模块名, "[离开] SFB_Unit=" + (sfbUnit != null && sfbUnit !== 0 ? "有效(hid=" + safeHid(sfbUnit) + ")" : "NULL!") + " 目标=" + safeUnitName(单位) + "(hid=" + safeHid(单位) + ")");
  SFB_setBuff(测试单位, 单位, 0, 1);
  debugLogForce(模块名, "离开区域，眩晕1秒");
}

function 区域效果测试_销毁(): void {
  debugLogForce(模块名, "区域效果已结束");
}

function on聊天测试(): void {
  const 测试单位 = g.gg_unit_Hamg_0002;
  if (测试单位 == null || 测试单位 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  当前测试单位 = 测试单位;

  创建区域效果({
    X: GetUnitX(测试单位),
    Y: GetUnitY(测试单位),
    半径: 400,
    持续时间: 10,
    检测间隔: 1,
    影响目标: "全部",
    所有者: 测试单位,
    周期伤害: 50,
    on进入: 区域效果测试_进入,
    on离开: 区域效果测试_离开,
    on销毁: 区域效果测试_销毁,
  });

  debugLogForce(模块名, "完整效果已创建", "位置=(" + GetUnitX(测试单位) + "," + GetUnitY(测试单位) + ")");
  debugLogForce(模块名, "请让其他单位进入/离开区域测试");
}

注册聊天命令监听(测试命令, on聊天测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "在大法师位置创建区域效果");

export {};