/** @noSelfInFile */

import { 安兹乌尔恭单位技能配置 } from '../00．配置';

const { 播放Boss台词 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.12．Boss台词广播') as {
  播放Boss台词: (
    this: void,
    来源单位: any,
    配置: {
      台词: Record<string, readonly string[]>;
      广播持续时间Ms: number;
      配音资源?: Record<string, readonly string[]>;
      配音组?: string;
      配音裁断距离?: number;
      配音允许重叠?: boolean;
    },
    类型: string,
    index?: number
  ) => void;
};

export type 雅儿贝德台词类型 = keyof typeof 安兹乌尔恭单位技能配置.雅儿贝德台词;

const 雅儿贝德台词配置 = {
  台词: 安兹乌尔恭单位技能配置.雅儿贝德台词,
  广播持续时间Ms: 安兹乌尔恭单位技能配置.广播持续时间Ms,
  配音资源: 安兹乌尔恭单位技能配置.配音资源,
  配音组: 安兹乌尔恭单位技能配置.护卫.BossKey,
  配音裁断距离: 安兹乌尔恭单位技能配置.配音裁断距离,
} as const;

export function 播放雅儿贝德台词(this: void, albedo: any, 类型: 雅儿贝德台词类型): void {
  播放Boss台词(albedo, 雅儿贝德台词配置, 类型, 0);
}
