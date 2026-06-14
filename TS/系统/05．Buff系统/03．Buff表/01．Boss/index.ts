/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 瑟兰迪尔Buff表 } from "./01．瑟兰迪尔";
import { 米亚Buff表 } from "./02．米亚";

export const BossBuff表: Record<string, BuffData> = {
  ...瑟兰迪尔Buff表,
  ...米亚Buff表,
};

export default BossBuff表;
