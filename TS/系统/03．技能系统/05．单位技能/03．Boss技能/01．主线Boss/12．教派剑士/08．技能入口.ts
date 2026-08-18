/** @noSelfInFile */

import { 注册教派剑士黑魔法侵蚀 } from './03．黑魔法侵蚀';
import { 注册教派剑士深渊旋风 } from './04．深渊旋风';
import { 注册教派剑士黑洞跨越 } from './05．黑洞跨越';
import { 注册教派剑士魔祭吸魂 } from './06．魔祭吸魂';
import { 注册教派剑士深渊分身 } from './07．深渊分身';

const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

let 教派剑士技能结构已注册 = false;

export function 注册教派剑士技能结构(this: void): void {
  if (教派剑士技能结构已注册) return;
  教派剑士技能结构已注册 = true;
  注册教派剑士黑魔法侵蚀();
  注册教派剑士深渊旋风();
  注册教派剑士黑洞跨越();
  注册教派剑士魔祭吸魂();
  注册教派剑士深渊分身();
}
