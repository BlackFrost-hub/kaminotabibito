/** @noSelfInFile */

import { 巴尔扎罗斯单位技能配置, 巴尔扎罗斯台词类型, 格鲁姆台词类型, 塞拉台词类型 } from "./00．配置";

const { 播放Boss台词 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.12．Boss台词广播") as {
  播放Boss台词: (this: void, 来源单位: any, 配置: { 台词: Record<string, readonly string[]>; 广播持续时间Ms: number; 配音资源?: Record<string, readonly string[]>; 配音裁断距离?: number; 配音允许重叠?: boolean }, 类型: string, index?: number) => void;
};

export function 播放巴尔扎罗斯台词(this: void, boss: any, 类型: 巴尔扎罗斯台词类型, index?: number): void {
  播放Boss台词(boss, 巴尔扎罗斯单位技能配置, 类型, index);
}

export function 播放格鲁姆台词(this: void, grum: any, 类型: 格鲁姆台词类型, index?: number): void {
  播放Boss台词(grum, 巴尔扎罗斯单位技能配置.护卫.格鲁姆, 类型, index);
}

export function 播放塞拉台词(this: void, sera: any, 类型: 塞拉台词类型, index?: number): void {
  播放Boss台词(sera, 巴尔扎罗斯单位技能配置.护卫.塞拉, 类型, index);
}
