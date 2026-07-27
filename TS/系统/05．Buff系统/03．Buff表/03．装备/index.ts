/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 瑟兰迪尔装备Buff表 } from "./01．瑟兰迪尔装备";
import { 菲利斯装备Buff表 } from "./02．菲利斯装备";
import { 米亚装备Buff表 } from "./03．米亚装备";
import { 使者系列装备Buff表 } from "./04．使者系列";
import { 旧主动物品Buff表 } from "./05．旧主动物品";
import { 亚伦柯斯装备Buff表 } from "./06．亚伦柯斯装备";
import { 祖地双灵卫装备Buff表 } from "./07．祖地双灵卫装备";
import { 异界装备Buff表 } from "./08．异界装备";

export const 装备Buff表: Record<string, BuffData> = {
  ...瑟兰迪尔装备Buff表,
  ...菲利斯装备Buff表,
  ...米亚装备Buff表,
  ...使者系列装备Buff表,
  ...旧主动物品Buff表,
  ...亚伦柯斯装备Buff表,
  ...祖地双灵卫装备Buff表,
  ...异界装备Buff表,
};

export default 装备Buff表;
