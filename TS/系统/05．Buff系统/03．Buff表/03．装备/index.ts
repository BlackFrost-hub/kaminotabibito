/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 瑟兰迪尔装备Buff表 } from "./01．瑟兰迪尔装备";
import { 菲利斯装备Buff表 } from "./02．菲利斯装备";
import { 米亚装备Buff表 } from "./03．米亚装备";

export const 装备Buff表: Record<string, BuffData> = {
  ...瑟兰迪尔装备Buff表,
  ...菲利斯装备Buff表,
  ...米亚装备Buff表,
};

export default 装备Buff表;
