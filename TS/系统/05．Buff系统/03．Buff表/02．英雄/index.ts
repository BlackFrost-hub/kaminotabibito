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
import { 克劳德Buff表 } from "./15．克劳德";
import { 安斯艾尔Buff表 } from "./16．安斯艾尔";
import { 欧尔贝克Buff表 } from "./17．欧尔贝克";
import { 云端Buff表 } from "./18．云端";
import { 十六夜咲夜Buff表 } from "./19．十六夜咲夜";
import { 爱蜜莉雅Buff表 } from "./20．爱蜜莉雅";
import { 朱雀院红叶Buff表 } from "./21．朱雀院红叶";
import { 朱雀院椿Buff表 } from "./22．朱雀院椿";
import { 伊蕾娜Buff表 } from "./23．伊蕾娜";
import { 塞莉亚Buff表 } from "./24．塞莉亚·克莱尔";
import { 芙莉莲Buff表 } from "./25．芙莉莲";

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
  ...克劳德Buff表,
  ...安斯艾尔Buff表,
  ...欧尔贝克Buff表,
  ...云端Buff表,
  ...十六夜咲夜Buff表,
  ...爱蜜莉雅Buff表,
  ...朱雀院红叶Buff表,
  ...朱雀院椿Buff表,
  ...伊蕾娜Buff表,
  ...塞莉亚Buff表,
  ...芙莉莲Buff表,
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
export * from "./15．克劳德";
export * from "./16．安斯艾尔";
export * from "./17．欧尔贝克";
export * from "./18．云端";
export * from "./19．十六夜咲夜";
export * from "./20．爱蜜莉雅";
export * from "./21．朱雀院红叶";
export * from "./22．朱雀院椿";
export * from "./23．伊蕾娜";
export * from "./24．塞莉亚·克莱尔";
export * from "./25．芙莉莲";

export default 英雄Buff表;
