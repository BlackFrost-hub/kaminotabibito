/** @noSelfInFile */

export const 首领奖励同步前缀 = "首领奖励领取";
export const 首领奖励同步分隔符 = "|";

export interface 首领奖励同步请求 {
  奖励池ID: string;
  已选装备名: string[];
}

export function 编码首领奖励同步请求(
  this: void,
  请求: 首领奖励同步请求
): string {
  let 内容 = 请求.奖励池ID;
  for (let 序号 = 0; 序号 < 请求.已选装备名.length; 序号++) {
    内容 = 内容 + 首领奖励同步分隔符 + 请求.已选装备名[序号];
  }
  return 内容;
}

export function 解码首领奖励同步请求(
  this: void,
  内容: string
): 首领奖励同步请求 {
  const 分段 = 内容.split(首领奖励同步分隔符);
  const 已选装备名: string[] = [];
  for (let 序号 = 1; 序号 < 分段.length; 序号++) {
    已选装备名.push(分段[序号]);
  }
  return { 奖励池ID: 分段[0] ?? "", 已选装备名 };
}
