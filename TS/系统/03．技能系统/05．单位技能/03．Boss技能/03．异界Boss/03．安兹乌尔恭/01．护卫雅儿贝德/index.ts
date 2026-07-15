export * from './00．状态';
export * from './01．至尊拦截';
export * from './02．黑翼横扫';
export * from './03．守护者之职责';
export * from './04．至尊共护';
export * from './05．黑翼拘束';
export * from './06．生命锚点封锁';
export * from './07．技能驱动';
export * from './08．守护回归';
export * from './09．护卫反击';

import { 至尊拦截技能状态 } from './01．至尊拦截';
import { 黑翼横扫技能状态 } from './02．黑翼横扫';
import { 守护者之职责技能状态 } from './03．守护者之职责';
import { 至尊共护技能状态 } from './04．至尊共护';
import { 黑翼拘束技能状态 } from './05．黑翼拘束';
import { 生命锚点封锁技能状态 } from './06．生命锚点封锁';
import { 雅儿贝德技能驱动状态 } from './07．技能驱动';
import { 守护回归技能状态 } from './08．守护回归';
import { 护卫反击技能状态 } from './09．护卫反击';

export const 雅儿贝德技能状态 = {
  已注册: true,
  技能: [至尊拦截技能状态, 黑翼横扫技能状态, 守护回归技能状态, 护卫反击技能状态, 守护者之职责技能状态, 至尊共护技能状态, 黑翼拘束技能状态, 生命锚点封锁技能状态],
  驱动: 雅儿贝德技能驱动状态,
} as const;
