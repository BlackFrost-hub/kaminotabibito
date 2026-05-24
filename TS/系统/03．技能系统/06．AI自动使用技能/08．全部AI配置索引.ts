/** @noSelfInFile */

import type { 单位AI配置 } from "./01．AI配置类型";
import { 构建单位AI配置ID索引, 构建单位IDAI配置索引, 构建单位名AI配置索引 } from "./02．AI配置工具";
import { BossAI配置表 } from "./03．BossAI配置表";
import { 杂鱼AI配置表 } from "./04．杂鱼AI配置表";
import { 精英AI配置表 } from "./05．精英AI配置表";
import { 英雄BossAI配置表 } from "./06．英雄BossAI配置表";
import { 异界BossAI配置表 } from "./07．异界BossAI配置表";

export const 全部单位AI配置表: 单位AI配置[] = [
  ...杂鱼AI配置表,
  ...精英AI配置表,
  ...BossAI配置表,
  ...英雄BossAI配置表,
  ...异界BossAI配置表,
];

export const 全部单位AI配置ID索引 = 构建单位AI配置ID索引(全部单位AI配置表);
export const 全部单位IDAI配置索引 = 构建单位IDAI配置索引(全部单位AI配置表);
export const 全部单位名AI配置索引 = 构建单位名AI配置索引(全部单位AI配置表);
