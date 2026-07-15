/** @noSelfInFile */

import { 亚伦柯斯单位技能配置 } from './00．配置';
import { 获取或创建亚伦柯斯运行时上下文, 注册亚伦柯斯运行时 } from './01．运行时上下文';
import { 注册亚伦柯斯技能调度 } from './10．技能调度';
import { stringToFourCC } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';

const { 注册Boss自动技能启动监听 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表') as {
  注册Boss自动技能启动监听: (this: void, 参数: any) => number;
};

const 亚伦柯斯单位类型ID = stringToFourCC(亚伦柯斯单位技能配置.单位ID);
let 亚伦柯斯被动已注册 = false;

function on亚伦柯斯Boss启动(this: void, context: any): void {
  获取或创建亚伦柯斯运行时上下文(context.Boss单位);
}

export function 注册亚伦柯斯被动效果(this: void): void {
  if (亚伦柯斯被动已注册) return;
  亚伦柯斯被动已注册 = true;
  注册亚伦柯斯运行时();
  注册亚伦柯斯技能调度();
  注册Boss自动技能启动监听({
    名称: '亚伦柯斯运行时上下文绑定',
    单位类型ID: 亚伦柯斯单位类型ID,
    on启动: on亚伦柯斯Boss启动,
  });
}

export const 亚伦柯斯被动效果状态 = {
  已设计: true,
  已实现: true,
  已注册: true,
  包含机制: ['Boss启动上下文绑定', '阶段生命阈值', '墓碑血量锁', '不灭军魂', '最终强化', '战败归静', '统一清理篮子'],
} as const;

注册亚伦柯斯被动效果();
