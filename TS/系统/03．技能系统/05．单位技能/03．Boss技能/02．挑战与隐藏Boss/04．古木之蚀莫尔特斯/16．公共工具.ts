/** @noSelfInFile */

import {
  stringToFourCC,
  取单位ID,
  单位有效,
  距离平方XY,
  距离XY,
  两点角度,
  单位间角度,
  极坐标X,
  极坐标Y,
  限制数值,
  点到线段距离平方,
} from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';

const { 播放限时单位动画 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待") as {
  播放限时单位动画: (this: void, 参数: any) => any;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const { 显示常规技能吟唱条, 显示大招吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
  显示大招吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};

export { stringToFourCC, 取单位ID, 单位有效, 距离平方XY, 距离XY, 极坐标X, 极坐标Y, 限制数值, 点到线段距离平方 };
export const 取坐标角度 = 两点角度;
export const 取单位间角度 = 单位间角度;

export function 播放莫尔特斯限时动作(
  this: void,
  unit: any,
  动画编号: number,
  动画速度: number,
  持续秒: number,
): any {
  return 播放限时单位动画({
    单位: unit,
    动画编号,
    动画速度,
    持续秒,
    恢复动画编号: 0,
    恢复动画速度: 1,
  });
}

export function 开始莫尔特斯常规施法(this: void, unit: any, 持续秒: number, 标题文本: string, 提示文本: string): void {
  开始硬直(unit, 持续秒);
  显示常规技能吟唱条({ 总时长: 持续秒, 颜色ID: 3, 标题文本, 提示文本 });
}

export function 开始莫尔特斯大招施法(this: void, unit: any, 持续秒: number, 标题文本: string, 提示文本: string): void {
  开始硬直(unit, 持续秒);
  显示大招吟唱条({ 通道: "大招", 总时长: 持续秒, 颜色ID: 3, 标题文本, 提示文本 });
}

export function 显示莫尔特斯大招吟唱条(this: void, 持续秒: number, 标题文本: string, 提示文本: string): void {
  显示大招吟唱条({ 通道: "大招", 总时长: 持续秒, 颜色ID: 3, 标题文本, 提示文本 });
}

export function 关闭莫尔特斯大招吟唱条(this: void): void {
  关闭吟唱条("大招");
}
