/** @noSelfInFile */

import { 安兹乌尔恭单位技能配置 } from './00．配置';
import { 获取或创建安兹运行时上下文, 注册安兹运行时 } from './01．运行时上下文';
import { 注册安兹技能结构 } from './14．技能入口';
import { stringToFourCC } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';

const { 注册Boss自动技能启动监听 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表') as {
  注册Boss自动技能启动监听: (this: void, 参数: any) => number;
};

const 安兹单位类型ID = stringToFourCC(安兹乌尔恭单位技能配置.正式单位ID);
let 安兹被动已注册 = false;

function on安兹Boss启动(this: void, context: any): void {
  获取或创建安兹运行时上下文(context.Boss单位);
}

export function 注册安兹被动效果(this: void): void {
  if (安兹被动已注册) return;
  安兹被动已注册 = true;
  注册安兹运行时();
  注册安兹技能结构();
  注册Boss自动技能启动监听({
    名称: '安兹运行时上下文绑定',
    单位类型ID: 安兹单位类型ID,
    on启动: on安兹Boss启动,
  });
}

export const 安兹被动效果状态 = {
  已设计: true,
  已实现: true,
  已注册: true,
  包含机制: ['Boss启动上下文绑定', '阶段生命阈值', '死亡清理', '雅儿贝德显式绑定接口'],
  待实现机制: ['死亡法则防护', '大招只释放一次', '挑战结束锁血'],
} as const;

注册安兹被动效果();
