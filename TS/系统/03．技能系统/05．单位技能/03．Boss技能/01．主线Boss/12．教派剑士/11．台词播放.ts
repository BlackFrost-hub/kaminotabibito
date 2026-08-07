/** @noSelfInFile */

import { 教派剑士单位技能配置, type 教派剑士台词类型 } from './00．配置';

const { 播放Boss台词 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.12．Boss台词广播') as {
  播放Boss台词: (this: void, 来源单位: any, 配置: { 台词: Record<string, readonly string[]>; 广播持续时间Ms: number }, 类型: string, index?: number) => void;
};

export function 播放教派剑士台词(this: void, boss: any, 类型: 教派剑士台词类型): void {
  播放Boss台词(boss, 教派剑士单位技能配置, 类型);
}
