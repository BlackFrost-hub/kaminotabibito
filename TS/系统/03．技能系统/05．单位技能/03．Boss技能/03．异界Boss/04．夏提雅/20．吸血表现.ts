/** @noSelfInFile */

import { 夏提雅数值与表现配置 } from './02．数值与表现配置';

const { createTimedUnitEffect } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};

export function 播放夏提雅吸血恢复特效(this: void, boss: any): void {
  const cfg = 夏提雅数值与表现配置.吸血表现;
  createTimedUnitEffect(
    boss,
    cfg.挂点,
    夏提雅数值与表现配置.表现资源.吸血恢复特效路径,
    cfg.持续秒,
  );
}
