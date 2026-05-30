/** @noSelfInFile */
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { registerStesListener, ydlStes_syncTriggerStep, ydlStes_finishChildCleanup } = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  registerStesListener: (this: void, eventName: string, callback: () => void) => any | null;
  ydlStes_syncTriggerStep: (this: void, self: any) => void;
  ydlStes_finishChildCleanup: (this: void, self: any) => void;
};
import { addPeriodicCallback, removePeriodicCallback } from "../../00．核心系统/05．中心计时器";
import {
  创建背景框,
  设置段落文字,
  设置背景框透明度,
  显示背景框,
  隐藏背景框,
  背景框实例,
  背景框配置,
} from "./01．背景框创建";
import {
  异界段落文字,
  异界第二句随机,
} from "./00．常量定义";

const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const R2I = jass.R2I as (value: number) => number;

const 异界段落数量 = 4;
const 文字间隔毫秒 = 1660;
const 淡出间隔毫秒 = 30;
const 淡出总帧数 = 100;
const 最大透明度 = 255;

let 背景帧组: 背景框实例 | null = null;
let 文字tick进度 = 0;
let 淡出tick进度 = 0;
let 文字定时器ID = 0;
let 淡出定时器ID = 0;

function 清除文字定时器(): void {
  if (文字定时器ID !== 0) {
    removePeriodicCallback(文字定时器ID);
    文字定时器ID = 0;
  }
}

function 清除淡出定时器(): void {
  if (淡出定时器ID !== 0) {
    removePeriodicCallback(淡出定时器ID);
    淡出定时器ID = 0;
  }
}

function 异界背景框淡出Tick(): void {
  淡出tick进度 += 1;
  if (淡出tick进度 >= 淡出总帧数) {
    if (背景帧组 !== null) {
      隐藏背景框(背景帧组);
    }
    清除淡出定时器();
    return;
  }
  if (背景帧组 !== null) {
    const alpha = R2I(最大透明度 * (1 - 0.01 * 淡出tick进度));
    设置背景框透明度(背景帧组, alpha);
  }
}

function 异界背景框文字Tick(): void {
  文字tick进度 += 1;
  if (文字tick进度 > 4) {
    清除文字定时器();
    淡出tick进度 = 0;
    淡出定时器ID = addPeriodicCallback(淡出间隔毫秒, 异界背景框淡出Tick);
    return;
  }
  if (背景帧组 === null) return;
  const 段落索引 = 文字tick进度 - 1;
  if (段落索引 < 0 || 段落索引 >= 异界段落数量) return;
  if (文字tick进度 === 2) {
    const 随机索引 = GetRandomInt(0, 异界第二句随机.length - 1);
    设置段落文字(背景帧组, 段落索引, 异界第二句随机[随机索引]);
  } else {
    设置段落文字(背景帧组, 段落索引, 异界段落文字[段落索引]);
  }
}

function 重置状态(): void {
  清除文字定时器();
  清除淡出定时器();
  文字tick进度 = 0;
  淡出tick进度 = 0;
}

function on异界Boss背景框触发(): void {
  ydlStes_syncTriggerStep(undefined);
  重置状态();
  if (背景帧组 === null) {
    const 配置: 背景框配置 = {
      段落数量: 异界段落数量,
    };
    背景帧组 = 创建背景框(配置);
  }
  if (背景帧组 === null) {
    ydlStes_finishChildCleanup(undefined);
    return;
  }
  设置背景框透明度(背景帧组, 最大透明度);
  显示背景框(背景帧组);
  for (let i = 0; i < 异界段落数量; i++) {
    设置段落文字(背景帧组, i, "");
  }
  文字定时器ID = addPeriodicCallback(文字间隔毫秒, 异界背景框文字Tick);
  ydlStes_finishChildCleanup(undefined);
}

export function init异界背景框(): void {
  registerStesListener("异界Boss背景框", on异界Boss背景框触发);
}
