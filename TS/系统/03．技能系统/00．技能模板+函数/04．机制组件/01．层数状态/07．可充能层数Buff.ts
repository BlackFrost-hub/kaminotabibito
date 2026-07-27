/** @noSelfInFile */

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};

export interface 可充能层数Buff同步参数 {
  单位: any;
  BuffID: string;
  当前层数: number;
  有层剩余毫秒: number;
  下次充能剩余毫秒: number;
  Buff显示值: number;
  Buff附加参数?: any;
  最短显示毫秒?: number;
}

/**
 * 可充能层数 Buff 的统一显示：有层时显示层持续时间，0 层时显示下次充能时间。
 * 当前层数会原样写入 Buff UI，因此支持 0 层角标。
 */
export function 同步可充能层数Buff(this: void, 参数: 可充能层数Buff同步参数): void {
  if (参数.单位 == null || 参数.单位 === 0 || 参数.BuffID === "") return;
  const 当前层数 = 参数.当前层数 > 0 ? 参数.当前层数 : 0;
  let 显示剩余毫秒 = 当前层数 > 0 ? 参数.有层剩余毫秒 : 参数.下次充能剩余毫秒;
  const 最短显示毫秒 = 参数.最短显示毫秒 != null && 参数.最短显示毫秒 > 0 ? 参数.最短显示毫秒 : 100;
  if (显示剩余毫秒 <= 0) 显示剩余毫秒 = 最短显示毫秒;
  registerManualBuff(参数.单位, 参数.BuffID, 显示剩余毫秒 / 1000, 参数.Buff显示值, {
    ...(参数.Buff附加参数 ?? {}),
    stack: 当前层数,
    allowZeroStack: true,
  });
}

export function 清除可充能层数Buff(this: void, 单位: any, BuffID: string): boolean {
  if (单位 == null || 单位 === 0 || BuffID === "") return false;
  return 移除单位指定Buff(单位, BuffID);
}
