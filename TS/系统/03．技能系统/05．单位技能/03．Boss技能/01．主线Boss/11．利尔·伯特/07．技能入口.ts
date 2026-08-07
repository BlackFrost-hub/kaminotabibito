/** @noSelfInFile */

import { 注册利尔伯特正义审判 } from './03．正义审判';
import { 注册利尔伯特裂地斩 } from './04．裂地斩';
import { 注册利尔伯特审判拷问 } from './05．审判拷问';
import { 注册利尔伯特检查 } from './06．检查';

let 利尔伯特技能结构已注册 = false;

export function 注册利尔伯特技能结构(this: void): void {
  if (利尔伯特技能结构已注册) return;
  利尔伯特技能结构已注册 = true;
  注册利尔伯特正义审判();
  注册利尔伯特裂地斩();
  注册利尔伯特审判拷问();
  注册利尔伯特检查();
}
