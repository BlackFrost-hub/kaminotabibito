/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as Record<string, any>;

import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 切换剧情大门 } from "../../00．剧情系统核心工具/02．剧情动作桥接";
import { 给玩家组添加多个区域视野 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";

const ShowDestructable = jass.ShowDestructable as (this: void, destructable: any, flag: boolean) => void;

function 执行王城门禁收尾(this: void): void {
  切换剧情大门({ 可破坏物全局名: "gg_dest_LTe1_11879", 开关: "打开" });
  const 阻挡 = jglobals.gg_dest_B00K_5466;
  if (阻挡 != null && 阻挡 !== 0) ShowDestructable(阻挡, false);
  给玩家组添加多个区域视野("场景.精灵城大区域,场景.精灵城区域028");
}

export { 王城门禁剧情片段 } from "../02．第二章/21．王城门禁开启";

export const 王城门禁开启剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_王城门禁收尾": 执行王城门禁收尾,
};
