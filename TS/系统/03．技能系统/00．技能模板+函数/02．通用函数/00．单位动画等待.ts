/** @noSelfInFile */
/**
 * 单位动画等待通用函数。
 * 用途：播放单位动画、延迟播放单位动画、等待指定秒数后执行下一步。
 * 也可用于纯技能阶段延迟，不依赖单位动画。
 */

const jass = require("jass.common") as any;
const { EXSetUnitFacing } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  EXSetUnitFacing: (this: void, u: any, angle: number) => void;
};
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  getServerTime: (this: void) => number;
};
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animationName: string) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, animationIndex: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, timeScale: number) => void;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const DEGREES_TO_RADIANS = jass.bj_DEGTORAD as number;

type VoidCallback = () => void;

interface 动画等待上下文 {
  单位?: any;
  动画序号?: number;
  动画名?: string;
  下一步?: VoidCallback;
  恢复待机?: boolean;
}

interface 动画等待任务 {
  ID: number;
  到期时间毫秒: number;
  上下文: 动画等待上下文;
}

const 动画等待任务列表: 动画等待任务[] = [];
const 单位限时动画令牌表: { [unitID: number]: number | undefined } = {};
let 动画等待任务ID序号 = 0;
let 单位限时动画令牌序号 = 0;
let 动画等待驱动已注册 = false;

export interface 限时单位动画参数 {
  单位: any;
  动画编号?: number;
  动画名?: string;
  动画速度?: number;
  持续秒: number;
  重播时点秒列表?: number[];
  /** false 时到期只恢复动画速度，不主动切换动画。 */
  恢复动画?: boolean;
  恢复动画编号?: number;
  恢复动画名?: string;
  恢复动画速度?: number;
  完成回调?: VoidCallback;
}

function 重置单位待机动画(this: void, 单位: any): void {
  if (单位 == null || 单位 === 0) return;
  SetUnitAnimation(单位, "stand");
}

function 播放上下文动画(ctx: 动画等待上下文): void {
  if (ctx.单位 == null || ctx.单位 === 0) return;
  if (typeof ctx.动画序号 === "number") {
    SetUnitAnimationByIndex(ctx.单位, ctx.动画序号);
    return;
  }
  if (typeof ctx.动画名 === "string" && ctx.动画名 !== "") {
    SetUnitAnimation(ctx.单位, ctx.动画名);
    return;
  }
  重置单位待机动画(ctx.单位);
}

function 执行动画等待上下文(ctx: 动画等待上下文): void {
  播放上下文动画(ctx);
  if (ctx.恢复待机 === true && ctx.单位 != null && ctx.单位 !== 0) {
    SetUnitAnimationByIndex(ctx.单位, 0);
  }
  if (ctx.下一步 != null) {
    ctx.下一步();
  }
}

function on动画等待驱动(this: void): void {
  if (动画等待任务列表.length === 0) return;

  const 当前时间毫秒 = getServerTime();
  const 原任务数量 = 动画等待任务列表.length;
  let 写入位置 = 0;

  for (let i = 0; i < 原任务数量; i++) {
    const 任务 = 动画等待任务列表[i];
    if (当前时间毫秒 >= 任务.到期时间毫秒) {
      执行动画等待上下文(任务.上下文);
    } else {
      动画等待任务列表[写入位置] = 任务;
      写入位置++;
    }
  }

  // 回调内可能登记新任务；保留本轮扫描期间追加的任务，下一 tick 再处理。
  for (let i = 原任务数量; i < 动画等待任务列表.length; i++) {
    动画等待任务列表[写入位置] = 动画等待任务列表[i];
    写入位置++;
  }
  while (动画等待任务列表.length > 写入位置) {
    动画等待任务列表.pop();
  }
}

function 确保动画等待驱动(): void {
  if (动画等待驱动已注册) return;
  动画等待驱动已注册 = true;
  addPeriodicCallback(10, on动画等待驱动);
}

function 创建动画等待任务(ctx: 动画等待上下文, 等待秒数: number): number {
  const ID = ++动画等待任务ID序号;
  动画等待任务列表.push({
    ID,
    到期时间毫秒: getServerTime() + 等待秒数 * 1000,
    上下文: ctx,
  });
  确保动画等待驱动();
  return ID;
}

export function 播放单位动画并等待(
  单位: any,
  动画序号: number,
  等待秒数: number,
  下一步?: VoidCallback
): any {
  if (单位 == null || 单位 === 0) return null;
  if (等待秒数 < 0) 等待秒数 = 0;
  SetUnitAnimationByIndex(单位, 动画序号);
  return 创建动画等待任务({ 单位, 下一步 }, 等待秒数);
}

export function 播放单位动作并等待(
  单位: any,
  动画名: string,
  等待秒数: number,
  下一步?: VoidCallback
): any {
  if (单位 == null || 单位 === 0) return null;
  if (!动画名 || 动画名 === "") return null;
  if (等待秒数 < 0) 等待秒数 = 0;
  SetUnitAnimation(单位, 动画名);
  return 创建动画等待任务({ 单位, 下一步 }, 等待秒数);
}

export function 播放单位动画并等待后恢复待机(
  单位: any,
  动画序号: number,
  等待秒数: number,
  下一步?: VoidCallback
): any {
  if (单位 == null || 单位 === 0) return null;
  if (等待秒数 < 0) 等待秒数 = 0;
  SetUnitAnimationByIndex(单位, 动画序号);
  return 创建动画等待任务({
    单位,
    恢复待机: true,
    下一步,
  }, 等待秒数);
}

export function 播放限时单位动画(参数: 限时单位动画参数): any {
  const 单位 = 参数.单位;
  if (单位 == null || 单位 === 0) return null;
  if (参数.动画编号 == null && (参数.动画名 == null || 参数.动画名 === "")) return null;
  const 单位ID = GetHandleId(单位);
  if (单位ID === 0) return null;

  let 持续秒 = 参数.持续秒;
  if (持续秒 < 0) 持续秒 = 0;
  const 令牌 = ++单位限时动画令牌序号;
  单位限时动画令牌表[单位ID] = 令牌;
  SetUnitTimeScale(单位, 参数.动画速度 ?? 1);
  if (参数.动画编号 != null) {
    SetUnitAnimationByIndex(单位, 参数.动画编号);
  } else {
    SetUnitAnimation(单位, 参数.动画名 as string);
  }

  const 重播时点秒列表 = 参数.重播时点秒列表 ?? [];
  for (let i = 0; i < 重播时点秒列表.length; i++) {
    const 重播时点秒 = 重播时点秒列表[i];
    if (!(重播时点秒 > 0) || 重播时点秒 >= 持续秒) continue;
    创建动画等待任务({
      下一步: function 限时单位动画重播(this: void): void {
        if (单位限时动画令牌表[单位ID] !== 令牌) return;
        SetUnitTimeScale(单位, 参数.动画速度 ?? 1);
        if (参数.动画编号 != null) {
          SetUnitAnimationByIndex(单位, 参数.动画编号);
        } else {
          SetUnitAnimation(单位, 参数.动画名 as string);
        }
      },
    }, 重播时点秒);
  }

  return 创建动画等待任务({
    下一步: function 限时单位动画恢复(this: void): void {
      if (单位限时动画令牌表[单位ID] !== 令牌) return;
      单位限时动画令牌表[单位ID] = undefined;
      SetUnitTimeScale(单位, 参数.恢复动画速度 ?? 1);
      if (参数.恢复动画 !== false) {
        if (参数.恢复动画编号 != null) {
          SetUnitAnimationByIndex(单位, 参数.恢复动画编号);
        } else if (参数.恢复动画名 != null && 参数.恢复动画名 !== "") {
          SetUnitAnimation(单位, 参数.恢复动画名);
        } else {
          SetUnitAnimation(单位, "stand");
        }
      }
      if (参数.完成回调 != null) 参数.完成回调();
    },
  }, 持续秒);
}

export function 延迟播放单位动画(
  单位: any,
  动画序号: number,
  延迟秒数: number,
  下一步?: VoidCallback
): any {
  if (单位 == null || 单位 === 0) return null;
  if (延迟秒数 < 0) 延迟秒数 = 0;
  return 创建动画等待任务({
    单位,
    动画序号,
    下一步,
  }, 延迟秒数);
}

export function 延迟播放单位动作(
  单位: any,
  动画名: string,
  延迟秒数: number,
  下一步?: VoidCallback
): any {
  if (单位 == null || 单位 === 0) return null;
  if (!动画名 || 动画名 === "") return null;
  if (延迟秒数 < 0) 延迟秒数 = 0;
  return 创建动画等待任务({
    单位,
    动画名,
    下一步,
  }, 延迟秒数);
}

export function 零秒后播放单位动画(
  单位: any,
  动画序号: number,
  下一步?: VoidCallback
): any {
  return 延迟播放单位动画(单位, 动画序号, 0.0, 下一步);
}

export function 零秒后播放单位动作(
  单位: any,
  动画名: string,
  下一步?: VoidCallback
): any {
  return 延迟播放单位动作(单位, 动画名, 0.0, 下一步);
}

export function 零秒后重置单位动画(
  单位: any,
  下一步?: VoidCallback
): any {
  if (单位 == null || 单位 === 0) return null;
  return 创建动画等待任务({
    单位,
    下一步,
  }, 0.0);
}

/**
 * 立即设置单位朝向。
 *
 * 说明：
 * - 技能层统一传角度制，与 `GetUnitFacing` / `SetUnitFacing` 保持一致。
 * - 内部会同步调用 `EXSetUnitFacing`，用弧度制立即修正朝向。
 */
export function 立即设置单位朝向(
  单位: any,
  朝向角度: number
): void {
  if (单位 == null || 单位 === 0) return;
  SetUnitFacing(单位, 朝向角度);
  EXSetUnitFacing(单位, 朝向角度 * DEGREES_TO_RADIANS);
}

export function 技能延迟执行(
  延迟秒数: number,
  下一步?: VoidCallback
): any {
  if (延迟秒数 < 0) 延迟秒数 = 0;
  return 创建动画等待任务({
    下一步,
  }, 延迟秒数);
}

export {};
