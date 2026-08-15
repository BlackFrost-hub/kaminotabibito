/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 提米诺斯Buff表 } from "./01．提米诺斯";
import { 欧菲莉亚Buff表 } from "./02．欧菲莉亚";
import { 蕾米莉亚Buff表 } from "./03．蕾米莉亚";
import { 藤原妹红Buff表 } from "./04．藤原妹红";
import { 坂井悠二Buff表 } from "./05．坂井悠二";
import { 塞拉斯Buff表 } from "./06．塞拉斯";
import { 一方通行Buff表 } from "./07．一方通行";
import { SaberBuff表 } from "./08．Saber";
import { 黑崎一护Buff表 } from "./09．黑崎一护";
import { 鹿目圆Buff表 } from "./10．鹿目圆";
import { 佐佐木小次郎Buff表 } from "./11．佐佐木小次郎";
import { 铃仙Buff表 } from "./12．铃仙";
import { 阿伦劳特Buff表 } from "./13．阿伦劳特";
import { 八云紫Buff表 } from "./14．八云紫";

// 英雄专属 Buff。后续按单英雄拆文件，并在这里聚合。
export const 英雄Buff表: Record<string, BuffData> = {
  ...提米诺斯Buff表,
  ...欧菲莉亚Buff表,
  ...蕾米莉亚Buff表,
  ...藤原妹红Buff表,
  ...坂井悠二Buff表,
  ...塞拉斯Buff表,
  ...一方通行Buff表,
  ...SaberBuff表,
  ...黑崎一护Buff表,
  ...鹿目圆Buff表,
  ...佐佐木小次郎Buff表,
  ...铃仙Buff表,
  ...阿伦劳特Buff表,
  ...八云紫Buff表,
};

export * from "./01．提米诺斯";
export * from "./02．欧菲莉亚";
export * from "./03．蕾米莉亚";
export * from "./04．藤原妹红";
export * from "./05．坂井悠二";
export * from "./06．塞拉斯";
export * from "./07．一方通行";
export * from "./08．Saber";
export * from "./09．黑崎一护";
export * from "./10．鹿目圆";
export * from "./11．佐佐木小次郎";
export * from "./12．铃仙";
export * from "./13．阿伦劳特";
export * from "./14．八云紫";

export default 英雄Buff表;
