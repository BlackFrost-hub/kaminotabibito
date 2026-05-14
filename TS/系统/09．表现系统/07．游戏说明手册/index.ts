/** @noSelfInFile */

import { 初始化翻页动画 } from "./04．翻页动画";
import { 初始化手册交互, 打开游戏说明手册, 关闭游戏说明手册, 切换游戏说明手册 } from "./05．交互控制";
import { 创建游戏说明手册UI, 设置手册帧显示 } from "./03．手册UI创建";

let 已初始化 = false;

export function init(this: void): void {
  if (已初始化) return;
  已初始化 = true;

  const ui = 创建游戏说明手册UI();
  初始化翻页动画(ui);
  初始化手册交互(ui);
  设置手册帧显示(ui, false);

  // 首版默认打开，便于进图直接确认正式手册视觉效果。
  打开游戏说明手册();
}

export { 打开游戏说明手册, 关闭游戏说明手册, 切换游戏说明手册 };
