/** @noSelfInFile */
/**
 * 技能引导阶段
 *
 * 说明：
 * 1. 基于 `充能系统.ts` 的周期回调能力构建
 * 2. 适合持续施法、持续喷火、持续法阵、持续瞄准等技能
 * 3. 已预留“自我打断”接口；未来命令/按键事件接进来后可直接生效
 */

const jass = require("jass.common") as any;

const SetUnitAnimation = jass.SetUnitAnimation as (u: any, name: string) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (u: any, index: number) => void;

const {
  开始充能,
  停止充能,
  获取单位当前充能ID,
  单位是否正在充能,
} = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, 单位: any, 参数: any) => number;
  停止充能: (this: void, 充能ID: number) => boolean;
  获取单位当前充能ID: (this: void, 单位: any) => number;
  单位是否正在充能: (this: void, 单位: any) => boolean;
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

export type 技能引导结束原因 = "完成" | "中断" | "死亡" | "主单位死亡" | "自我打断";

export interface 技能引导参数 {
  最大持续时间: number;
  主单位?: any;
  主单位死亡时中断?: boolean;

  显示进度条特效?: boolean;
  进度条特效高度偏移?: number;
  进度条特效动画序号?: number;
  进度条特效动画速度?: number;

  过程特效?: string;
  过程特效播放次数?: number;
  过程特效间隔?: number;
  过程特效生命周期?: number;
  完成特效?: string;
  完成特效生命周期?: number;
  周期回调间隔?: number;

  施法动作名?: string;
  施法动画序号?: number;
  首段零秒后播放动画?: boolean;

  /**
   * 默认启用。
   * 玩家按下 S 时，若该单位当前处于此引导阶段，则视为自我打断。
   */
  允许自我打断?: boolean;
  自我打断回调?: (this: void, 单位: any, 方式: 技能自我打断方式, 引导ID: number) => void;

  开始回调?: (this: void, 单位: any, 引导ID: number) => void;
  周期回调?: (this: void, 单位: any, 引导ID: number, 已进行时间: number, 剩余时间: number, 进度: number) => void;
  完成回调?: (this: void, 单位: any, 引导ID: number) => void;
  中断回调?: (this: void, 单位: any, 原因: Exclude<技能引导结束原因, "完成">, 引导ID: number) => void;
  结束回调?: (this: void, 单位: any, 原因: 技能引导结束原因, 引导ID: number) => void;
}

interface 技能引导上下文 {
  单位: any;
  首段零秒后播放动画: boolean;
  施法动作名?: string;
  施法动画序号?: number;
  允许自我打断: boolean;
  强制结束原因?: 技能引导结束原因;
  自我打断回调?: (this: void, 单位: any, 方式: 技能自我打断方式, 引导ID: number) => void;
  开始回调?: (this: void, 单位: any, 引导ID: number) => void;
  周期回调?: (this: void, 单位: any, 引导ID: number, 已进行时间: number, 剩余时间: number, 进度: number) => void;
  完成回调?: (this: void, 单位: any, 引导ID: number) => void;
  中断回调?: (this: void, 单位: any, 原因: Exclude<技能引导结束原因, "完成">, 引导ID: number) => void;
  结束回调?: (this: void, 单位: any, 原因: 技能引导结束原因, 引导ID: number) => void;
}

const 引导上下文表: Record<number, 技能引导上下文 | undefined> = {};

function 播放引导动作(单位: any, 上下文: 技能引导上下文): void {
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

function 技能引导_开始回调(单位: any, 引导ID: number): void {
  const 上下文 = 引导上下文表[引导ID];
  if (上下文 == null) return;

  if (上下文.允许自我打断) {
    注册技能自我打断监听(单位, 引导ID, on技能引导自我打断);
  }

  const 开始回调 = 上下文.开始回调;
  if (开始回调 != null) {
    开始回调(单位, 引导ID);
  }

  播放引导动作(单位, 上下文);
}

function 技能引导_周期回调(
  单位: any,
  引导ID: number,
  已进行时间: number,
  剩余时间: number,
  进度: number,
): void {
  const 上下文 = 引导上下文表[引导ID];
  if (上下文 == null) return;

  const 周期回调 = 上下文.周期回调;
  if (周期回调 != null) {
    周期回调(单位, 引导ID, 已进行时间, 剩余时间, 进度);
  }
}

function 技能引导_完成回调(单位: any, 引导ID: number): void {
  const 上下文 = 引导上下文表[引导ID];
  if (上下文 == null) return;

  const 完成回调 = 上下文.完成回调;
  if (完成回调 != null) {
    完成回调(单位, 引导ID);
  }
}

function 技能引导_结束回调(单位: any, 原因: 技能引导结束原因, 引导ID: number): void {
  const 上下文 = 引导上下文表[引导ID];
  if (上下文 == null) return;

  取消技能自我打断监听(引导ID);
  delete 引导上下文表[引导ID];

  const 最终原因 = 上下文.强制结束原因 ?? 原因;
  if (最终原因 !== "完成") {
    const 中断回调 = 上下文.中断回调;
    if (中断回调 != null) {
      中断回调(单位, 最终原因, 引导ID);
    }
  }

  const 结束回调 = 上下文.结束回调;
  if (结束回调 != null) {
    结束回调(单位, 最终原因, 引导ID);
  }
}

function on技能引导自我打断(单位: any, 引导ID: number, 方式: 技能自我打断方式): void {
  const 上下文 = 引导上下文表[引导ID];
  if (上下文 == null) return;

  上下文.强制结束原因 = "自我打断";

  const 自我打断回调 = 上下文.自我打断回调;
  if (自我打断回调 != null) {
    自我打断回调(单位, 方式, 引导ID);
  }

  停止充能(引导ID);
}

export function 开始技能引导(单位: any, 参数: 技能引导参数): number {
  const 引导ID = 开始充能(单位, {
    持续时间: 参数.最大持续时间,
    主单位: 参数.主单位,
    主单位死亡时中断: 参数.主单位死亡时中断,
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
    周期回调: 技能引导_周期回调,
    周期回调间隔: 参数.周期回调间隔,
    充能完成回调: 技能引导_完成回调,
    结束回调: 技能引导_结束回调,
  });

  if (引导ID <= 0) return 0;

  引导上下文表[引导ID] = {
    单位,
    首段零秒后播放动画: 参数.首段零秒后播放动画 !== false,
    施法动作名: 参数.施法动作名,
    施法动画序号: 参数.施法动画序号,
    允许自我打断: 参数.允许自我打断 !== false,
    自我打断回调: 参数.自我打断回调,
    开始回调: 参数.开始回调,
    周期回调: 参数.周期回调,
    完成回调: 参数.完成回调,
    中断回调: 参数.中断回调,
    结束回调: 参数.结束回调,
  };

  技能引导_开始回调(单位, 引导ID);
  return 引导ID;
}

export function 停止技能引导(引导ID: number, 原因: 技能引导结束原因 = "中断"): boolean {
  const 上下文 = 引导上下文表[引导ID];
  if (上下文 != null) {
    上下文.强制结束原因 = 原因;
  }
  return 停止充能(引导ID);
}

export function 停止单位技能引导(单位: any, 原因: 技能引导结束原因 = "中断"): boolean {
  const 引导ID = 获取单位当前技能引导ID(单位);
  if (引导ID <= 0) return false;
  return 停止技能引导(引导ID, 原因);
}

export function 单位是否正在技能引导(单位: any): boolean {
  const 引导ID = 获取单位当前技能引导ID(单位);
  return 引导ID > 0 && 单位是否正在充能(单位);
}

export function 获取单位当前技能引导ID(单位: any): number {
  const 引导ID = 获取单位当前充能ID(单位);
  if (引导ID <= 0) return 0;
  return 引导上下文表[引导ID] != null ? 引导ID : 0;
}
