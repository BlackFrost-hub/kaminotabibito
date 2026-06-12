/** @noSelfInFile */

import { items } from "../01．装备数据";
import { 按名字反查物品ID } from "../13．物品名反查";
import { 首领奖励选项配置 } from "./00．类型定义";
import { 生成装备属性文本 } from "../../../lib/扩展函数/物品相关函数/装备数据查询";

export interface 首领奖励装备详情 {
  分类: string;
  等级: string;
  评分: string;
  描述: string;
  属性: string;
  特效: string;
  图标: string;
}

const 默认奖励图标 = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp";

export function 获取首领奖励装备详情(this: void, 选项: 首领奖励选项配置): 首领奖励装备详情 {
  const 物品ID = 按名字反查物品ID(选项.装备名);
  const 数据 = 物品ID != null ? items[物品ID] : undefined;
  return {
    分类: 数据?.type ?? "装备",
    等级: 数据?.level ?? "",
    评分: 数据?.score != null ? "" + 数据.score : "",
    描述: 选项.描述,
    属性: 数据 != null ? 生成装备属性文本(数据 as Record<string, any>) : "",
    特效: 选项.特效,
    图标: 选项.图标 || 默认奖励图标,
  };
}
