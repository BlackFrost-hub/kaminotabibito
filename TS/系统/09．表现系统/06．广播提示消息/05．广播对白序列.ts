/** @noSelfInFile */

import { 广播提示淡出毫秒, 广播提示滑入毫秒 } from "./00．常量定义";

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, 延迟毫秒: number, 回调: (this: void, 参数?: any) => void, 参数?: any) => number;
};

export interface 广播对白序列项 {
  说话者键: string;
  文本: string;
  停留毫秒: number;
  下一句延迟毫秒?: number;
}

export interface 广播对白序列配置 {
  对白列表: readonly 广播对白序列项[];
  读取说话单位: (this: void, 说话者键: string) => any;
  播放单句: (this: void, 来源单位: any, 文本: string, 停留毫秒: number) => void;
  播放前校验?: (this: void) => boolean;
  单句播放前校验?: (this: void, 序号: number, 说话者键: string) => boolean;
  播放中止?: (this: void) => void;
  单句播放前?: (this: void, 序号: number) => void;
  播放完成?: (this: void) => void;
}

interface 广播对白序列状态 {
  配置: 广播对白序列配置;
  当前索引: number;
}

function 播放下一句广播对白(this: void, 参数?: any): void {
  const 状态 = 参数 as 广播对白序列状态 | undefined;
  if (状态 == null) return;
  const 配置 = 状态.配置;
  if (配置.播放前校验 != null && !配置.播放前校验()) {
    if (配置.播放中止 != null) 配置.播放中止();
    return;
  }
  if (状态.当前索引 >= 配置.对白列表.length) {
    if (配置.播放完成 != null) 配置.播放完成();
    return;
  }

  const 序号 = 状态.当前索引 + 1;
  const 对白 = 配置.对白列表[状态.当前索引];
  if (配置.单句播放前校验 != null && !配置.单句播放前校验(序号, 对白.说话者键)) {
    if (配置.播放中止 != null) 配置.播放中止();
    return;
  }
  if (配置.单句播放前 != null) 配置.单句播放前(序号);
  const 来源单位 = 配置.读取说话单位(对白.说话者键);
  if (来源单位 == null || 来源单位 === 0) {
    if (配置.播放中止 != null) 配置.播放中止();
    return;
  }
  配置.播放单句(来源单位, 对白.文本, 对白.停留毫秒);
  状态.当前索引++;
  addDelayedCallback(
    对白.下一句延迟毫秒 ?? (广播提示滑入毫秒 + 对白.停留毫秒 + 广播提示淡出毫秒),
    播放下一句广播对白,
    状态,
  );
}

/** 按广播 UI 的滑入、停留、淡出总时长依次播放，不改变剧情或电影模式状态。 */
export function 播放广播对白序列(this: void, 配置: 广播对白序列配置): void {
  if (配置 == null || 配置.对白列表.length <= 0) {
    if (配置?.播放完成 != null) 配置.播放完成();
    return;
  }
  播放下一句广播对白({ 配置, 当前索引: 0 } as 广播对白序列状态);
}

export {};
