/** @noSelfInFile */

import {
  祖地双灵卫单位技能配置,
  type 赤誓灵卫台词类型,
  type 苍影灵卫台词类型,
} from './00．配置';

const { 播放Boss台词 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.12．Boss台词广播') as {
  播放Boss台词: (this: void, source: any, config: any, type: string, index?: number) => void;
};

export function 播放赤誓灵卫台词(this: void, unit: any, type: 赤誓灵卫台词类型, index?: number): void {
  播放Boss台词(unit, 祖地双灵卫单位技能配置.单位.赤誓灵卫, type, index);
}

export function 播放苍影灵卫台词(this: void, unit: any, type: 苍影灵卫台词类型, index?: number): void {
  播放Boss台词(unit, 祖地双灵卫单位技能配置.单位.苍影灵卫, type, index);
}
