/** @noSelfInFile */
/**
 * 爱蜜莉雅 - 表现接入（A9）
 *
 * 注册总入口：普攻联动 + Q/W/E/D/R 技能壳。
 * 动作映射：按规划 8.1 动作记录选择候选序列索引（配置 .动作索引），实机确认前不宣称最终映射；
 * 图标：BLP 迁移未完成，Buff/技能图标保留原生占位（执行规则 5，不写 PNG 路径）；
 * 音效：本阶段仅按规划 9.7.1 记录需求，不接入未确认音频路径（执行规则 7）。
 */

import { 注册爱蜜莉雅普攻联动 } from "./04．普攻联动";
import { 注册爱蜜莉雅Q } from "./05．Q技能";
import { 注册爱蜜莉雅W } from "./06．W技能";
import { 注册爱蜜莉雅E } from "./07．E技能";
import { 注册爱蜜莉雅D } from "./08．D技能";
import { 注册爱蜜莉雅R } from "./09．R技能";

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

let 已注册 = false;

export function 注册爱蜜莉雅表现(this: void): void {
  debugLogForce("爱蜜莉雅-表现接入", "注册", "名称", "注册爱蜜莉雅表现");
  if (已注册) return;
  已注册 = true;
  注册爱蜜莉雅普攻联动();
  注册爱蜜莉雅Q();
  注册爱蜜莉雅W();
  注册爱蜜莉雅E();
  注册爱蜜莉雅D();
  注册爱蜜莉雅R();
}

export {};
