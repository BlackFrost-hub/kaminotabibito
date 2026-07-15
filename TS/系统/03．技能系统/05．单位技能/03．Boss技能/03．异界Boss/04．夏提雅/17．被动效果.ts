/** @noSelfInFile */

import { 夏提雅单位技能配置 } from './00．配置';
import { 获取或创建夏提雅运行时上下文, 注册夏提雅运行时 } from './01．运行时上下文';
import { stringToFourCC } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 注册夏提雅技能调度 } from './14．技能调度';
import { 注册夏提雅滴管长枪连击 } from './03．滴管长枪连击';
import { 绑定夏提雅挑战生命下限 } from './15．挑战入口与收束';

const { 注册Boss自动技能启动监听 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表') as {
  注册Boss自动技能启动监听: (this: void, 参数: any) => number;
};

const 夏提雅单位类型ID = stringToFourCC(夏提雅单位技能配置.正式单位ID);
let 夏提雅被动已注册 = false;

function on夏提雅Boss启动(this: void, context: any): void {
  const runtime = 获取或创建夏提雅运行时上下文(context.Boss单位);
  if (runtime != null) 绑定夏提雅挑战生命下限(runtime);
}

export function 注册夏提雅被动效果(this: void): void {
  if (夏提雅被动已注册) return;
  夏提雅被动已注册 = true;
  注册夏提雅运行时();
  注册夏提雅滴管长枪连击();
  注册夏提雅技能调度();
  注册Boss自动技能启动监听({
    名称: '夏提雅运行时上下文绑定',
    单位类型ID: 夏提雅单位类型ID,
    on启动: on夏提雅Boss启动,
  });
}

export const 夏提雅被动效果状态 = {
  已设计: true,
  已实现: true,
  已注册: true,
  包含机制: ['Boss启动上下文绑定', '强化普攻监听', '猎血段数过期', '鲜血枯竭', '血印上限', 'P1/P2/P3单向阶段阈值', '一次性复生锁血', '第二次致死挑战收束', '统一清理篮子'],
  待实现机制: [],
} as const;

注册夏提雅被动效果();
