/** @noSelfInFile */

import { 瑟兰迪尔单位技能配置 } from "./00．配置";

const { 播放Boss台词广播 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.12．Boss台词广播") as {
  播放Boss台词广播: (this: void, 来源单位: any, 台词表: Record<string, readonly string[]>, 类型: string, 持续时间Ms: number, index?: number) => void;
};

export type 瑟兰迪尔台词类型 = keyof typeof 瑟兰迪尔单位技能配置.台词;

export function 播放瑟兰迪尔台词(this: void, boss: any, 类型: 瑟兰迪尔台词类型, index?: number): void {
  播放Boss台词广播(boss, 瑟兰迪尔单位技能配置.台词, 类型, 瑟兰迪尔单位技能配置.广播持续时间Ms, index);
}
