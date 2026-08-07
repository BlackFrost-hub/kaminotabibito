/** @noSelfInFile */

import { 食人魔公共台词表, type 食人魔公共台词类型 } from './00．配置';

const { 取Boss台词文本 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.12．Boss台词广播') as {
  取Boss台词文本: (this: void, 台词表: Record<string, readonly string[]>, 类型: string, index?: number) => string | undefined;
};
const { 广播单位提示 } = require('系统.09．表现系统.06．广播提示消息.index') as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

export function 播放食人魔公共台词(this: void, boss: any, 类型: 食人魔公共台词类型, 后缀文本?: string): void {
  const 文本 = 取Boss台词文本(食人魔公共台词表.台词, 类型);
  if (文本 == null || 文本 === '') return;
  广播单位提示(boss, 文本 + (后缀文本 ?? ''), 食人魔公共台词表.广播持续时间Ms);
}
