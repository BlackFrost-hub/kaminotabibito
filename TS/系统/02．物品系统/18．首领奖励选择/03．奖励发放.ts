/** @noSelfInFile */

import { 首领奖励发放结果 } from "./00．类型定义";
import { 查找首领奖励池, 校验首领奖励池结构 } from "./01．奖励配置表";
import { 是否已领取首领奖励, 标记首领奖励已领取 } from "./02．领取状态";

function 装备是否在奖励池中(this: void, 奖励池ID: string, 装备名: string): boolean {
  const 奖励池 = 查找首领奖励池(奖励池ID);
  if (奖励池 == null) return false;
  for (let 序号 = 0; 序号 < 奖励池.选项.length; 序号++) {
    if (奖励池.选项[序号].装备名 === 装备名) return true;
  }
  return false;
}

export function 校验首领奖励选择(
  this: void,
  奖励池ID: string,
  玩家ID: number,
  已选装备名: string[]
): 首领奖励发放结果 {
  const 奖励池 = 查找首领奖励池(奖励池ID);
  if (奖励池 == null) return 首领奖励发放结果.奖励池不存在;
  if (!校验首领奖励池结构(奖励池)) return 首领奖励发放结果.选项数量越界;
  if (已选装备名.length !== 奖励池.可选数量) {
    return 首领奖励发放结果.选择数量无效;
  }
  if (是否已领取首领奖励(奖励池ID, 玩家ID)) return 首领奖励发放结果.已领取;

  for (let 序号 = 0; 序号 < 已选装备名.length; 序号++) {
    if (!装备是否在奖励池中(奖励池ID, 已选装备名[序号])) {
      return 首领奖励发放结果.选择不在奖励池;
    }
  }

  return 首领奖励发放结果.成功;
}

export function 领取首领奖励选择(
  this: void,
  奖励池ID: string,
  玩家ID: number,
  已选装备名: string[]
): 首领奖励发放结果 {
  const 结果 = 校验首领奖励选择(奖励池ID, 玩家ID, 已选装备名);
  if (结果 !== 首领奖励发放结果.成功) return 结果;

  标记首领奖励已领取(奖励池ID, 玩家ID, 已选装备名);
  return 首领奖励发放结果.成功;
}
