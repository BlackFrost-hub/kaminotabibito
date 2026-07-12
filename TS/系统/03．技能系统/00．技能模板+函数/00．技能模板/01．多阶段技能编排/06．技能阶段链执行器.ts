/** @noSelfInFile */
/**
 * 技能阶段链执行器
 *
 * 说明：
 * 1. 用于“前摇 -> 执行 -> 再前摇 -> 再执行 -> 收尾”这类技能
 * 2. 当前提供最小高频复用能力：前摇阶段、引导阶段、立即执行阶段
 * 3. 可与生效帧 / 后摇 / 收尾模块组合使用
 */

import { 开始技能前摇, 停止技能前摇, type 技能前摇参数, type 技能前摇结束原因 } from "./01．前摇与持续施法";
import { 开始技能引导, 停止技能引导, type 技能引导参数, type 技能引导结束原因 } from "./05．技能引导阶段";

const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

export type 技能阶段链结束原因 = "完成" | "中断" | "死亡" | "主单位死亡" | "自我打断";

export interface 技能阶段链上下文 {
  阶段链ID: number;
  单位: any;
  数据: Record<string, any>;
  当前阶段索引: number;
}

export interface 技能阶段控制器 {
  完成当前阶段(this: void): void;
  中断阶段链(this: void, 原因?: 技能阶段链结束原因): void;
  设置当前阶段停止函数(this: void, fn: ((this: void, 原因: 技能阶段链结束原因) => void) | undefined): void;
  写入数据(this: void, key: string, value: any): void;
  读取数据(this: void, key: string): any;
}

export interface 技能阶段定义 {
  名称?: string;
  开始: (this: void, 上下文: 技能阶段链上下文, 控制器: 技能阶段控制器) => void;
}

export type 技能阶段延迟毫秒 = number | ((this: void, 上下文: 技能阶段链上下文) => number);

interface 技能延迟阶段变量 {
  上下文: 技能阶段链上下文;
  控制器: 技能阶段控制器;
  执行?: (this: void, 上下文: 技能阶段链上下文, 控制器: 技能阶段控制器) => void;
  已结束: boolean;
}

export interface 技能阶段链参数 {
  数据?: Record<string, any>;
  结束回调?: (this: void, 单位: any, 原因: 技能阶段链结束原因, 阶段链ID: number, 上下文: 技能阶段链上下文) => void;
}

interface 技能阶段链运行时 {
  id: number;
  单位: any;
  阶段列表: 技能阶段定义[];
  数据: Record<string, any>;
  当前阶段索引: number;
  当前阶段停止函数?: (this: void, 原因: 技能阶段链结束原因) => void;
  已结束: boolean;
  结束回调?: (this: void, 单位: any, 原因: 技能阶段链结束原因, 阶段链ID: number, 上下文: 技能阶段链上下文) => void;
}

const 阶段链映射: Record<number, 技能阶段链运行时 | undefined> = {};
let 下一个阶段链ID = 1;

function on技能延迟阶段到期(this: void, variable?: any): void {
  const data = variable as 技能延迟阶段变量 | undefined;
  if (data == null || data.已结束) return;
  data.已结束 = true;
  if (data.执行 != null) data.执行(data.上下文, data.控制器);
  data.控制器.完成当前阶段();
}

function 取阶段延迟毫秒(this: void, 延迟毫秒: 技能阶段延迟毫秒, 上下文: 技能阶段链上下文): number {
  return typeof 延迟毫秒 === "number" ? 延迟毫秒 : 延迟毫秒(上下文);
}

function 创建阶段链上下文(运行时: 技能阶段链运行时): 技能阶段链上下文 {
  return {
    阶段链ID: 运行时.id,
    单位: 运行时.单位,
    数据: 运行时.数据,
    当前阶段索引: 运行时.当前阶段索引,
  };
}

function 完成阶段链(运行时: 技能阶段链运行时, 原因: 技能阶段链结束原因): void {
  if (运行时.已结束) return;
  运行时.已结束 = true;
  delete 阶段链映射[运行时.id];

  const 结束回调 = 运行时.结束回调;
  if (结束回调 != null) {
    结束回调(运行时.单位, 原因, 运行时.id, 创建阶段链上下文(运行时));
  }
}

function 进入下一阶段(运行时: 技能阶段链运行时): void {
  if (运行时.已结束) return;

  运行时.当前阶段停止函数 = undefined;
  运行时.当前阶段索引 += 1;
  if (运行时.当前阶段索引 >= 运行时.阶段列表.length) {
    完成阶段链(运行时, "完成");
    return;
  }

  const 当前阶段 = 运行时.阶段列表[运行时.当前阶段索引];
  const 控制器: 技能阶段控制器 = {
    完成当前阶段: function (this: void): void {
      进入下一阶段(运行时);
    },
    中断阶段链: function (this: void, 原因: 技能阶段链结束原因 = "中断"): void {
      停止技能阶段链(运行时.id, 原因);
    },
    设置当前阶段停止函数: function (
      this: void,
      fn: ((this: void, 原因: 技能阶段链结束原因) => void) | undefined,
    ): void {
      运行时.当前阶段停止函数 = fn;
    },
    写入数据: function (this: void, key: string, value: any): void {
      运行时.数据[key] = value;
    },
    读取数据: function (this: void, key: string): any {
      return 运行时.数据[key];
    },
  };

  当前阶段.开始(创建阶段链上下文(运行时), 控制器);
}

export function 开始技能阶段链(单位: any, 阶段列表: 技能阶段定义[], 参数?: 技能阶段链参数): number {
  if (阶段列表.length <= 0) return 0;

  const 阶段链ID = 下一个阶段链ID++;
  const 运行时: 技能阶段链运行时 = {
    id: 阶段链ID,
    单位,
    阶段列表,
    数据: 参数?.数据 ?? {},
    当前阶段索引: -1,
    已结束: false,
    结束回调: 参数?.结束回调,
  };

  阶段链映射[阶段链ID] = 运行时;
  进入下一阶段(运行时);
  return 阶段链ID;
}

export function 停止技能阶段链(阶段链ID: number, 原因: 技能阶段链结束原因 = "中断"): boolean {
  const 运行时 = 阶段链映射[阶段链ID];
  if (运行时 == null || 运行时.已结束) return false;

  const 停止函数 = 运行时.当前阶段停止函数;
  if (停止函数 != null) {
    运行时.当前阶段停止函数 = undefined;
    停止函数(原因);
  }

  完成阶段链(运行时, 原因);
  return true;
}

export function 创建立即执行阶段(
  执行: (this: void, 上下文: 技能阶段链上下文, 控制器: 技能阶段控制器) => void,
  名称?: string,
): 技能阶段定义 {
  return {
    名称,
    开始: function (this: void, 上下文: 技能阶段链上下文, 控制器: 技能阶段控制器): void {
      执行(上下文, 控制器);
      控制器.完成当前阶段();
    },
  };
}

export function 创建延迟执行阶段(
  延迟毫秒: 技能阶段延迟毫秒,
  执行: (this: void, 上下文: 技能阶段链上下文, 控制器: 技能阶段控制器) => void,
  名称?: string,
): 技能阶段定义 {
  return {
    名称,
    开始: function (this: void, 上下文: 技能阶段链上下文, 控制器: 技能阶段控制器): void {
      const delayMs = 取阶段延迟毫秒(延迟毫秒, 上下文);
      if (delayMs <= 0) {
        执行(上下文, 控制器);
        控制器.完成当前阶段();
        return;
      }

      const data: 技能延迟阶段变量 = { 上下文, 控制器, 执行, 已结束: false };
      const callbackId = addDelayedCallback(delayMs, on技能延迟阶段到期, data);
      控制器.设置当前阶段停止函数(function 停止技能延迟执行阶段(this: void): void {
        if (data.已结束) return;
        data.已结束 = true;
        removeDelayedCallback(callbackId);
      });
    },
  };
}

export function 创建延迟阶段(延迟毫秒: 技能阶段延迟毫秒, 名称?: string): 技能阶段定义 {
  return 创建延迟执行阶段(延迟毫秒, function 空延迟阶段(this: void): void {}, 名称);
}

export function 创建前摇阶段(参数: 技能前摇参数 & { 名称?: string }): 技能阶段定义 {
  return {
    名称: 参数.名称,
    开始: function (this: void, 上下文: 技能阶段链上下文, 控制器: 技能阶段控制器): void {
      const 原完成后执行 = 参数.完成后执行;
      const 原结束回调 = 参数.结束回调;
      const 阶段参数: 技能前摇参数 = { ...参数 };
      阶段参数.完成后执行 = function (this: void, 单位: any, 前摇ID: number): void {
        if (原完成后执行 != null) {
          原完成后执行(单位, 前摇ID);
        }
        控制器.完成当前阶段();
      };
      阶段参数.结束回调 = function (this: void, 单位: any, 原因: 技能前摇结束原因, 前摇ID: number): void {
        if (原结束回调 != null) {
          原结束回调(单位, 原因, 前摇ID);
        }
        if (原因 !== "完成") {
          控制器.中断阶段链(原因);
        }
      };
      const 阶段ID = 开始技能前摇(上下文.单位, 阶段参数);

      控制器.设置当前阶段停止函数(function (this: void): void {
        停止技能前摇(阶段ID);
      });
    },
  };
}

export function 创建引导阶段(参数: 技能引导参数 & { 名称?: string }): 技能阶段定义 {
  return {
    名称: 参数.名称,
    开始: function (this: void, 上下文: 技能阶段链上下文, 控制器: 技能阶段控制器): void {
      const 原完成回调 = 参数.完成回调;
      const 原结束回调 = 参数.结束回调;
      const 阶段参数: 技能引导参数 = { ...参数 };
      阶段参数.完成回调 = function (this: void, 单位: any, 引导ID: number): void {
        if (原完成回调 != null) {
          原完成回调(单位, 引导ID);
        }
        控制器.完成当前阶段();
      };
      阶段参数.结束回调 = function (this: void, 单位: any, 原因: 技能引导结束原因, 引导ID: number): void {
        if (原结束回调 != null) {
          原结束回调(单位, 原因, 引导ID);
        }
        if (原因 !== "完成") {
          控制器.中断阶段链(原因);
        }
      };
      const 阶段ID = 开始技能引导(上下文.单位, 阶段参数);

      控制器.设置当前阶段停止函数(function (this: void, 原因: 技能阶段链结束原因): void {
        停止技能引导(阶段ID, 原因);
      });
    },
  };
}
