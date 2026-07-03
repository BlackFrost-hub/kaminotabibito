/** @noSelfInFile */

import { 设置原生弹幕指定角度飞行 } from "../../01．技能函数/01．弹幕/01．TS原生弹幕/06．改向与反弹/00．弹幕改向";
import { 两点方向角 } from "./08．方位判定工具";
import type { 阶段上下文 } from "./01．阶段上下文";
import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

export interface 阶段弹幕改向规则 {
  阶段ID: string;
  延迟秒: number;
  新速度?: number;
  目标单位?: any | ((this: void) => any);
  目标点?: { X: number; Y: number } | ((this: void) => { X: number; Y: number });
  固定角度?: number;
}

export interface 阶段弹幕编排参数 {
  清理?: 机制清理篮子;
  名称: string;
  阶段上下文: 阶段上下文;
  弹幕ID: number;
  规则列表: 阶段弹幕改向规则[];
}

function 解析目标单位(this: void, raw: any): any {
  return typeof raw === "function" ? raw() : raw;
}

function 解析目标点(this: void, raw: any): { X: number; Y: number } | undefined {
  if (raw == null) return undefined;
  return typeof raw === "function" ? raw() : raw;
}

export function 注册阶段弹幕编排(this: void, 参数: 阶段弹幕编排参数): void {
  for (let i = 0; i < 参数.规则列表.length; i++) {
    const 规则 = 参数.规则列表[i];
    const id = addDelayedCallback(规则.延迟秒 * 1000, function 阶段弹幕延迟改向(this: void): void {
      if (!参数.阶段上下文.是阶段(规则.阶段ID)) return;
      let angle = 规则.固定角度;
      if (angle == null) {
        const unit = 解析目标单位(规则.目标单位);
        if (unit != null && unit !== 0) {
          const bulletUnit = require("../../01．技能函数/01．弹幕/01．TS原生弹幕/03．对外接口") as {
            获取原生弹幕: (this: void, 弹幕ID: number) => { 弹幕单位: any } | undefined;
          };
          const bullet = bulletUnit.获取原生弹幕(参数.弹幕ID);
          const fromUnit = bullet != null ? bullet.弹幕单位 : null;
          if (fromUnit != null && fromUnit !== 0) angle = 两点方向角(GetUnitX(fromUnit), GetUnitY(fromUnit), GetUnitX(unit), GetUnitY(unit));
        }
      }
      if (angle == null) {
        const point = 解析目标点(规则.目标点);
        if (point != null) {
          const bulletUnit = require("../../01．技能函数/01．弹幕/01．TS原生弹幕/03．对外接口") as {
            获取原生弹幕: (this: void, 弹幕ID: number) => { 弹幕单位: any } | undefined;
          };
          const bullet = bulletUnit.获取原生弹幕(参数.弹幕ID);
          const fromUnit = bullet != null ? bullet.弹幕单位 : null;
          if (fromUnit != null && fromUnit !== 0) angle = 两点方向角(GetUnitX(fromUnit), GetUnitY(fromUnit), point.X, point.Y);
        }
      }
      if (angle != null) 设置原生弹幕指定角度飞行(参数.弹幕ID, angle, 规则.新速度);
    });
    if (参数.清理 != null) 参数.清理.登记延迟回调(参数.名称 + "-阶段弹幕改向" + String(i), id);
  }
}
