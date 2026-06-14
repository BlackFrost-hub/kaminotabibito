/** @noSelfInFile */

import type { Boss战斗启动护卫配置 } from "./00．配置类型";
import { Boss分类战斗启动护卫配置表 } from "./01．Boss战斗启动属性配置表";
import { 英雄Boss分类战斗启动护卫配置表 } from "./02．英雄Boss战斗启动属性配置表";
import { 异界Boss分类战斗启动护卫配置表 } from "./03．异界Boss战斗启动属性配置表";

export type {
  Boss战斗启动护卫单位配置,
  Boss战斗启动护卫对白配置,
  Boss战斗启动护卫批次配置,
  Boss战斗启动护卫配置,
} from "./00．配置类型";

export const Boss战斗启动护卫配置表: Boss战斗启动护卫配置[] = [
  ...Boss分类战斗启动护卫配置表,
  ...英雄Boss分类战斗启动护卫配置表,
  ...异界Boss分类战斗启动护卫配置表,
];
