/** @noSelfInFile */

import type { BuffData } from "../01．Buff表";
import { 通用Buff表 } from "./01．通用";
import { DOTBuff表 } from "./02．DOT";
import { 控制Buff表 } from "./03．控制";
import { 属性Buff表 } from "./04．属性";
import { 光环Buff表 } from "./05．光环";
import { 单位Buff表 } from "./04．单位";
import { BossBuff表 } from "./01．Boss";
import { 英雄Buff表 } from "./02．英雄";
import { 装备Buff表 } from "./03．装备";

export const 分类Buff表: Record<string, BuffData> = {
  ...通用Buff表,
  ...DOTBuff表,
  ...控制Buff表,
  ...属性Buff表,
  ...光环Buff表,
  ...单位Buff表,
  ...BossBuff表,
  ...英雄Buff表,
  ...装备Buff表,
};

export default 分类Buff表;
