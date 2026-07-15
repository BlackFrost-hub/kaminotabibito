/** @noSelfInFile */

import {
  stringToFourCC,
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

const 里科特战斗待机动画编号 = 3;
const 里科特施法起手动画编号 = 8;
const 里科特施法维持动画编号 = 9;

export { stringToFourCC, 单位有效, 距离平方XY, 距离XY, 极坐标X, 极坐标Y, 限制数值, 点到线段距离平方 };
export const 取坐标角度 = 两点角度;
export const 取单位间角度 = 单位间角度;

export function 播放里科特限时动作(
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
    恢复动画编号: 里科特战斗待机动画编号,
  });
}

export function 播放里科特施法维持动作(
  this: void,
  unit: any,
  总持续秒: number,
  动画速度: number,
): any {
  const 起手原始持续秒 = 2.167 / 动画速度;
  const 起手持续秒 = 总持续秒 < 起手原始持续秒 ? 总持续秒 : 起手原始持续秒;
  return 播放限时单位动画({
    单位: unit,
    动画编号: 里科特施法起手动画编号,
    动画速度,
    持续秒: 起手持续秒,
    恢复动画编号: 总持续秒 > 起手持续秒 ? 里科特施法维持动画编号 : 里科特战斗待机动画编号,
    完成回调: function 里科特进入施法维持动作(this: void): void {
      const 剩余秒 = 总持续秒 - 起手持续秒;
      if (剩余秒 <= 0) return;
      播放限时单位动画({
        单位: unit,
        动画编号: 里科特施法维持动画编号,
        动画速度: 1,
        持续秒: 剩余秒,
        恢复动画编号: 里科特战斗待机动画编号,
      });
    },
  });
}
