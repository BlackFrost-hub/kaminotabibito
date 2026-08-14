/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 提米诺斯Buff表 } from "./01．提米诺斯";
import { 欧菲莉亚Buff表 } from "./02．欧菲莉亚";
import { 蕾米莉亚Buff表 } from "./03．蕾米莉亚";

// 英雄专属 Buff。后续按单英雄拆文件，并在这里聚合。
export const 英雄Buff表: Record<string, BuffData> = {
  ...提米诺斯Buff表,
  ...欧菲莉亚Buff表,
  ...蕾米莉亚Buff表,
};

export * from "./01．提米诺斯";
export * from "./02．欧菲莉亚";
export * from "./03．蕾米莉亚";

export default 英雄Buff表;
