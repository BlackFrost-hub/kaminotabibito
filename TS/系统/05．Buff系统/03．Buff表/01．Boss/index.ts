/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 瑟兰迪尔Buff表 } from "./01．瑟兰迪尔";
import { 米亚Buff表 } from "./02．米亚";
import { 巴尔扎罗斯Buff表 } from "./03．巴尔扎罗斯";
import { 菲尼克斯尔Buff表 } from "./04．菲尼克斯尔";
import { 树魔首领Buff表 } from "./05．树魔首领";
import { 菲利斯Buff表 } from "./06．菲利斯";
import { 里科特Buff表 } from "./07．里科特";
import { 卡瑟拉Buff表 } from "./08．卡瑟拉";
import { 莫尔特斯Buff表 } from "./09．莫尔特斯";
import { 影骨莫特斯Buff表 } from "./10．影骨莫特斯";

export const BossBuff表: Record<string, BuffData> = {
  ...瑟兰迪尔Buff表,
  ...米亚Buff表,
  ...巴尔扎罗斯Buff表,
  ...菲尼克斯尔Buff表,
  ...树魔首领Buff表,
  ...菲利斯Buff表,
  ...里科特Buff表,
  ...卡瑟拉Buff表,
  ...莫尔特斯Buff表,
  ...影骨莫特斯Buff表,
};

export default BossBuff表;
