/** @noSelfInFile */

import { 莫尔特斯单位技能配置, 莫尔特斯台词类型 } from "./00．配置";

const { 播放Boss台词 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.12．Boss台词广播") as {
  播放Boss台词: (this: void, 来源单位: any, 配置: { 台词: Record<string, readonly string[]>; 广播持续时间Ms: number; 配音资源?: Record<string, readonly string[]>; 配音裁断距离?: number; 配音允许重叠?: boolean }, 类型: string, index?: number) => void;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

export function 播放莫尔特斯台词(this: void, boss: any, 类型: 莫尔特斯台词类型, index?: number): void {
  播放Boss台词(boss, 莫尔特斯单位技能配置, 类型, index);
  const 广播提示 = (莫尔特斯单位技能配置.广播提示 as Record<string, string>)[类型];
  if (广播提示 != null && 广播提示 !== "") 广播单位提示(boss, 广播提示, 莫尔特斯单位技能配置.广播持续时间Ms);
}
