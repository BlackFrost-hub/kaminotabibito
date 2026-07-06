/** @noSelfInFile */
/**
 * 前摇与持续施法
 *
 * 说明：
 * 1. 底层复用 `01．技能函数/06．施法·蓄力·充能/充能系统.ts`
 * 2. 用于“等待施法/蓄力完成后，再执行下一个技能模块”
 * 3. 可选创建/销毁提示特效，便于穿插进冲锋、跳跃、范围伤害等技能组合
 * 4. 施法进度条默认智能启用；若未显式关闭，则自动接入 `进度条特效.ts`
 * 5. 施法进度条动画速度默认按 `1 / 持续时间` 自动匹配
 */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const SetUnitAnimation = jass.SetUnitAnimation as (u: any, name: string) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (u: any, index: number) => void;

const {
  开始充能,
  停止充能,
  停止单位充能,
  单位是否正在充能,
  获取单位当前充能ID,
} = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, 单位: any, 参数: any) => number;
  停止充能: (this: void, 充能ID: number) => boolean;
  停止单位充能: (this: void, 单位: any) => boolean;
  单位是否正在充能: (this: void, 单位: any) => boolean;
  获取单位当前充能ID: (this: void, 单位: any) => number;
};
const {
  注册施法被打断回调,
  取消注册施法被打断回调,
} = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.施法状态") as {
  注册施法被打断回调: (this: void, 回调: (单位: any, 原因: 技能前摇结束原因, 前摇ID: number) => void) => void;
  取消注册施法被打断回调: (this: void, 回调: (单位: any, 原因: 技能前摇结束原因, 前摇ID: number) => void) => void;
};

const {
  零秒后播放单位动画,
  零秒后播放单位动作,
} = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待") as {
  零秒后播放单位动画: (this: void, 单位: any, 动画序号: number, 下一步?: () => void) => any;
  零秒后播放单位动作: (this: void, 单位: any, 动画名: string, 下一步?: () => void) => any;
};
import {
  注册技能自我打断监听,
  取消技能自我打断监听,
  type 技能自我打断方式,
} from "./04．自我打断预留";

export type 技能前摇结束原因 = "完成" | "中断" | "死亡" | "主单位死亡" | "自我打断";

export interface 技能前摇参数 {
  持续时间: number;
  主单位?: any;
  主单位死亡时中断?: boolean;
  强制硬直?: boolean;

  /**
   * 默认启用。
   * 若未显式设为 `false`，会自动显示施法进度条。
   */
  显示进度条特效?: boolean;
  进度条特效高度偏移?: number;
  进度条特效动画序号?: number;
  /**
   * 默认按 `1 / 持续时间` 自动计算。
   */
  进度条特效动画速度?: number;

  过程特效?: string;
  过程特效播放次数?: number;
  过程特效间隔?: number;
  过程特效生命周期?: number;
  完成特效?: string;
  完成特效生命周期?: number;

  创建提示特效?: (this: void, 单位: any, 前摇ID: number) => any;
  销毁提示特效?: (this: void, 特效句柄: any, 单位: any, 前摇ID: number, 原因: 技能前摇结束原因) => void;
  施法动作名?: string;
  施法动画序号?: number;
  首段零秒后播放动画?: boolean;
  允许自我打断?: boolean;
  自我打断回调?: (this: void, 单位: any, 方式: 技能自我打断方式, 前摇ID: number) => void;

  开始回调?: (this: void, 单位: any, 前摇ID: number) => void;
  前摇完成回调?: (this: void, 单位: any, 前摇ID: number) => void;
  完成后执行?: (this: void, 单位: any, 前摇ID: number) => void;
  结束回调?: (this: void, 单位: any, 原因: 技能前摇结束原因, 前摇ID: number) => void;
}

interface 技能前摇上下文 {
  单位: any;
  提示特效句柄: any;
  销毁提示特效?: (this: void, 特效句柄: any, 单位: any, 前摇ID: number, 原因: 技能前摇结束原因) => void;
  施法动作名?: string;
  施法动画序号?: number;
  首段零秒后播放动画: boolean;
  允许自我打断: boolean;
  强制结束原因?: 技能前摇结束原因;
  自我打断回调?: (this: void, 单位: any, 方式: 技能自我打断方式, 前摇ID: number) => void;
  开始回调?: (this: void, 单位: any, 前摇ID: number) => void;
  前摇完成回调?: (this: void, 单位: any, 前摇ID: number) => void;
  完成后执行?: (this: void, 单位: any, 前摇ID: number) => void;
  结束回调?: (this: void, 单位: any, 原因: 技能前摇结束原因, 前摇ID: number) => void;
}

const 前摇上下文表: Record<number, 技能前摇上下文 | undefined> = {};

function 取句柄ID(h: any): number {
  return (h != null && h !== 0 ? GetHandleId(h) : 0) || 0;
}

function 清理提示特效(前摇ID: number, 原因: 技能前摇结束原因): void {
  const 上下文 = 前摇上下文表[前摇ID];
  if (!上下文) return;

  const 提示特效句柄 = 上下文.提示特效句柄;
  const 销毁提示特效 = 上下文.销毁提示特效;
  上下文.提示特效句柄 = null;

  if (提示特效句柄 == null || 提示特效句柄 === 0) {
    return;
  }

  if (销毁提示特效 != null) {
    销毁提示特效(提示特效句柄, 上下文.单位, 前摇ID, 原因);
  }
}

function 销毁前摇上下文(前摇ID: number, 原因: 技能前摇结束原因): 技能前摇上下文 | undefined {
  const 上下文 = 前摇上下文表[前摇ID];
  if (!上下文) {
    return undefined;
  }

  清理提示特效(前摇ID, 原因);
  delete 前摇上下文表[前摇ID];
  return 上下文;
}

function 技能前摇_开始回调(单位: any, 前摇ID: number): void {
  const 上下文 = 前摇上下文表[前摇ID];
  if (!上下文) {
    return;
  }

  if (上下文.允许自我打断) {
    注册技能自我打断监听(单位, 前摇ID, on技能前摇自我打断);
  }

  const 开始回调 = 上下文.开始回调;
  if (开始回调 != null) {
    开始回调(单位, 前摇ID);
  }

  if (typeof 上下文.施法动画序号 === "number") {
    if (上下文.首段零秒后播放动画) {
      零秒后播放单位动画(单位, 上下文.施法动画序号);
    } else {
      SetUnitAnimationByIndex(单位, 上下文.施法动画序号);
    }
    return;
  }

  if (typeof 上下文.施法动作名 === "string" && 上下文.施法动作名 !== "") {
    if (上下文.首段零秒后播放动画) {
      零秒后播放单位动作(单位, 上下文.施法动作名);
    } else {
      SetUnitAnimation(单位, 上下文.施法动作名);
    }
  }
}

function 技能前摇_充能完成回调(单位: any, 前摇ID: number): void {
  const 上下文 = 前摇上下文表[前摇ID];
  if (!上下文) {
    return;
  }

  const 前摇完成回调 = 上下文.前摇完成回调;
  if (前摇完成回调 != null) {
    前摇完成回调(单位, 前摇ID);
  }

  const 完成后执行 = 上下文.完成后执行;
  if (完成后执行 != null) {
    完成后执行(单位, 前摇ID);
  }
}

function 技能前摇_结束回调(单位: any, 原因: 技能前摇结束原因, 前摇ID: number): void {
  const 原上下文 = 前摇上下文表[前摇ID];
  if (原上下文 != null) {
    取消技能自我打断监听(前摇ID);
  }

  const 上下文 = 销毁前摇上下文(前摇ID, 原因);
  if (!上下文) {
    return;
  }

  const 最终原因 = 上下文.强制结束原因 ?? 原因;
  const 结束回调 = 上下文.结束回调;
  if (结束回调 != null) {
    结束回调(单位, 最终原因, 前摇ID);
  }
}

function on技能前摇自我打断(单位: any, 前摇ID: number, 方式: 技能自我打断方式): void {
  const 上下文 = 前摇上下文表[前摇ID];
  if (上下文 == null) return;

  上下文.强制结束原因 = "自我打断";

  const 自我打断回调 = 上下文.自我打断回调;
  if (自我打断回调 != null) {
    自我打断回调(单位, 方式, 前摇ID);
  }

  停止充能(前摇ID);
}

export function 开始技能前摇(单位: any, 参数: 技能前摇参数): number {
  const 前摇ID = 开始充能(单位, {
    持续时间: 参数.持续时间,
    主单位: 参数.主单位,
    主单位死亡时中断: 参数.主单位死亡时中断,
    强制硬直: 参数.强制硬直,
    显示进度条特效: 参数.显示进度条特效,
    进度条特效高度偏移: 参数.进度条特效高度偏移,
    进度条特效动画序号: 参数.进度条特效动画序号,
    进度条特效动画速度: 参数.进度条特效动画速度,
    过程特效: 参数.过程特效,
    过程特效播放次数: 参数.过程特效播放次数,
    过程特效间隔: 参数.过程特效间隔,
    过程特效生命周期: 参数.过程特效生命周期,
    完成特效: 参数.完成特效,
    完成特效生命周期: 参数.完成特效生命周期,
    充能完成回调: 技能前摇_充能完成回调,
    结束回调: 技能前摇_结束回调,
  });

  if (前摇ID <= 0) {
    return 0;
  }

  前摇上下文表[前摇ID] = {
    单位,
    提示特效句柄: null,
    销毁提示特效: 参数.销毁提示特效,
    施法动作名: 参数.施法动作名,
    施法动画序号: 参数.施法动画序号,
    首段零秒后播放动画: 参数.首段零秒后播放动画 !== false,
    允许自我打断: 参数.允许自我打断 !== false,
    自我打断回调: 参数.自我打断回调,
    开始回调: 参数.开始回调,
    前摇完成回调: 参数.前摇完成回调,
    完成后执行: 参数.完成后执行,
    结束回调: 参数.结束回调,
  };

  const 创建提示特效 = 参数.创建提示特效;
  if (创建提示特效 != null) {
    前摇上下文表[前摇ID]!.提示特效句柄 = 创建提示特效(单位, 前摇ID);
  }

  技能前摇_开始回调(单位, 前摇ID);

  return 前摇ID;
}

export function 停止技能前摇(前摇ID: number, 原因: 技能前摇结束原因 = "中断"): boolean {
  const 上下文 = 前摇上下文表[前摇ID];
  if (上下文 != null) {
    上下文.强制结束原因 = 原因;
  }
  return 停止充能(前摇ID);
}

export function 停止单位技能前摇(单位: any, 原因: 技能前摇结束原因 = "中断"): boolean {
  const 前摇ID = 获取单位当前技能前摇ID(单位);
  if (前摇ID <= 0) {
    return false;
  }
  return 停止技能前摇(前摇ID, 原因);
}

export function 单位是否正在技能前摇(单位: any): boolean {
  const 前摇ID = 获取单位当前技能前摇ID(单位);
  return 前摇ID > 0 && 单位是否正在充能(单位);
}

export function 单位是否正在技能施法(单位: any): boolean {
  return 单位是否正在技能前摇(单位);
}

export function 单位是否正在技能蓄力(单位: any): boolean {
  return 单位是否正在技能前摇(单位);
}

export function 注册技能施法被打断回调(
  回调: (this: void, 单位: any, 原因: 技能前摇结束原因, 前摇ID: number) => void
): void {
  注册施法被打断回调(回调);
}

export function 取消注册技能施法被打断回调(
  回调: (this: void, 单位: any, 原因: 技能前摇结束原因, 前摇ID: number) => void
): void {
  取消注册施法被打断回调(回调);
}

export function 获取单位当前技能前摇ID(单位: any): number {
  const 前摇ID = 获取单位当前充能ID(单位);
  if (前摇ID <= 0) {
    return 0;
  }
  return 前摇上下文表[前摇ID] != null ? 前摇ID : 0;
}

export function 根据单位句柄ID获取技能前摇ID(单位句柄ID: number): number {
  for (const key in 前摇上下文表) {
    const 前摇ID = key as unknown as number;
    const 上下文 = 前摇上下文表[前摇ID];
    if (上下文 != null && 取句柄ID(上下文.单位) === 单位句柄ID) {
      return Number(key);
    }
  }
  return 0;
}

export {};
