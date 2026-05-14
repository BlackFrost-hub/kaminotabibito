/** @noSelfInFile */

import { 初始化翻页动画 } from "./04．翻页动画";
import { 初始化手册交互, 打开游戏说明手册, 关闭游戏说明手册, 切换游戏说明手册 } from "./05．交互控制";
import { 创建游戏说明手册UI, 设置手册帧显示 } from "./03．手册UI创建";
import { KEY, KEY_STATE, registerKeyEventByCode } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";

let 已初始化 = false;
let 已注册K键 = false;

function on游戏说明手册K键抬起(this: void): void {
  切换游戏说明手册();
}

function 注册游戏说明手册K键(this: void): void {
  if (已注册K键) return;
  已注册K键 = true;
  registerKeyEventByCode(KEY.K, KEY_STATE.UP, false, on游戏说明手册K键抬起 as any);
}

export function init(this: void): void {
  if (已初始化) return;
  已初始化 = true;

  const ui = 创建游戏说明手册UI();
  初始化翻页动画(ui);
  初始化手册交互(ui);
  设置手册帧显示(ui, false);
  注册游戏说明手册K键();
}

export { 打开游戏说明手册, 关闭游戏说明手册, 切换游戏说明手册 };
