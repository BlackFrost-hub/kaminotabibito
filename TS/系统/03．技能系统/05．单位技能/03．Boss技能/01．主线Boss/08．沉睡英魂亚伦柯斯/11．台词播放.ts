/** @noSelfInFile */

import { 亚伦柯斯单位技能配置, type 亚伦柯斯台词类型 } from './00．配置';

const { 播放Boss台词 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.12．Boss台词广播') as {
  播放Boss台词: (this: void, source: any, config: any, type: string, index?: number) => void;
};

export function 播放亚伦柯斯台词(this: void, boss: any, type: 亚伦柯斯台词类型, index?: number): void {
  播放Boss台词(boss, 亚伦柯斯单位技能配置, type, index);
}

