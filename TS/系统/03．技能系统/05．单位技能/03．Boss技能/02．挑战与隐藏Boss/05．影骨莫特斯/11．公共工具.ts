/** @noSelfInFile */

import { 播放限时单位动画 } from "../../../../00．技能模板+函数/02．通用函数/00．单位动画等待";
import { 影骨莫特斯模型动画配置 } from "./02．数值与表现配置";
import {
  stringToFourCC,
  取单位ID,
  单位有效,
  距离XY,
  两点角度,
  极坐标X as 公共极坐标X,
  极坐标Y as 公共极坐标Y,
  角度差绝对值,
  目标正面朝向来源,
} from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';

const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const { 显示常规技能吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
};

export { stringToFourCC, 取单位ID, 单位有效, 两点角度, 角度差绝对值, 目标正面朝向来源 };
export const 两点距离 = 距离XY;

export function 播放影骨莫特斯限时动作(this: void, unit: any, 动画编号: number, 动画速度: number, 持续秒: number): void {
  播放限时单位动画({
    单位: unit,
    动画编号,
    动画速度,
    持续秒,
    恢复动画编号: 影骨莫特斯模型动画配置.战斗待机编号,
  });
}

export function 开始影骨莫特斯常规施法(this: void, unit: any, 持续秒: number, 标题文本: string, 提示文本: string): void {
  开始硬直(unit, 持续秒);
  显示常规技能吟唱条({ 总时长: 持续秒, 颜色ID: 4, 标题文本, 提示文本 });
}

export function 极坐标X(this: void, x: number, distance: number, angleDeg: number): number {
  return 公共极坐标X(x, angleDeg, distance);
}

export function 极坐标Y(this: void, y: number, distance: number, angleDeg: number): number {
  return 公共极坐标Y(y, angleDeg, distance);
}

export {};
