/** @noSelfInFile */

import { 注册地精祭祀受击反应观察 } from './03．受击反应观察';
import { 注册地精祭祀破坏死光 } from './04．破坏死光';
import { 注册地精祭祀血爆 } from './05．血爆';
import { 注册地精祭祀毒蕴 } from './06．毒蕴';

let 地精祭祀技能结构已注册 = false;

export function 注册地精祭祀技能结构(this: void): void {
  if (地精祭祀技能结构已注册) return;
  地精祭祀技能结构已注册 = true;
  注册地精祭祀受击反应观察();
  注册地精祭祀破坏死光();
  注册地精祭祀血爆();
  注册地精祭祀毒蕴();
}
