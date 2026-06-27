/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 瑟兰迪尔Buff表 } from "./01．瑟兰迪尔";
import { 米亚Buff表 } from "./02．米亚";
import { 巴尔扎罗斯Buff表 } from "./03．巴尔扎罗斯";
import { 菲尼克斯尔Buff表 } from "./04．菲尼克斯尔";

export const BossBuff表: Record<string, BuffData> = {
  ...瑟兰迪尔Buff表,
  ...米亚Buff表,
  ...巴尔扎罗斯Buff表,
  ...菲尼克斯尔Buff表,
};

export default BossBuff表;
