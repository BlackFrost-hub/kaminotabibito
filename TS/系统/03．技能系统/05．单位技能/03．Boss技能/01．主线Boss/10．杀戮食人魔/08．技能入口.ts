/** @noSelfInFile */

import { 注册食人魔共享机制 } from '../00．食人魔公共/01．共享机制';
import { 注册食人魔心脏掌握 } from '../00．食人魔公共/02．心脏掌握';
import { 注册杀戮食人魔被动效果 } from './03．被动效果';
import { 注册杀戮食人魔深渊魔咒 } from './04．深渊魔咒';
import { 注册杀戮食人魔血海绞杀 } from './05．血海绞杀';
import { 注册杀戮食人魔痛之束缚 } from './06．痛之束缚';
import { 注册杀戮食人魔雷霆震怒 } from './07．雷霆震怒';

const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

let 杀戮食人魔技能结构已注册 = false;

export function 注册杀戮食人魔技能结构(this: void): void {
  if (杀戮食人魔技能结构已注册) {
    debugLogForce('杀戮食人魔-技能入口', '重复注册请求已忽略');
    return;
  }
  杀戮食人魔技能结构已注册 = true;
  注册食人魔共享机制();
  注册食人魔心脏掌握();
  注册杀戮食人魔被动效果();
  注册杀戮食人魔深渊魔咒();
  注册杀戮食人魔血海绞杀();
  注册杀戮食人魔痛之束缚();
  注册杀戮食人魔雷霆震怒();
  debugLogForce('杀戮食人魔-技能入口', '技能结构注册完成');
}
