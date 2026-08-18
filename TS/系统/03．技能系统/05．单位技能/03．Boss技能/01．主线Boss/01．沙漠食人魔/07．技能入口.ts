/** @noSelfInFile */

import { 注册食人魔共享机制 } from '../00．食人魔公共/01．共享机制';
import { 注册食人魔心脏掌握 } from '../00．食人魔公共/02．心脏掌握';
import { 注册沙漠食人魔被动效果 } from './01．被动效果';
import { 注册沙漠食人魔咒 } from './03．食人魔咒';
import { 注册沙漠食人魔风暴之锤 } from './04．风暴之锤';
import { 注册沙漠食人魔雷霆敲打 } from './05．雷霆敲打';
import { 注册沙漠食人魔雷霆震怒 } from './06．雷霆震怒';

const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

let 沙漠食人魔技能结构已注册 = false;

export function 注册沙漠食人魔技能结构(this: void): void {
  if (沙漠食人魔技能结构已注册) return;
  沙漠食人魔技能结构已注册 = true;
  注册食人魔共享机制();
  注册食人魔心脏掌握();
  注册沙漠食人魔被动效果();
  注册沙漠食人魔咒();
  注册沙漠食人魔风暴之锤();
  注册沙漠食人魔雷霆敲打();
  注册沙漠食人魔雷霆震怒();
}
