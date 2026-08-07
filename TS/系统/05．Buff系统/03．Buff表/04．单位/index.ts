/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 封印守卫战Buff表 } from "./01．封印守卫战";

export * from "./01．封印守卫战";

export const 单位Buff表: Record<string, BuffData> = {
  ...封印守卫战Buff表,
};

export default 单位Buff表;
