/** @noSelfInFile */

const {
  转四位ID,
  单位拥有原生Buff,
  获取范围敌军,
  对单位造成强化伤害,
  在坐标播放特效,
  取单位X,
  取单位Y,
  注册指定单位暴击后监听,
  播放动作,
  恢复时间流速,
} = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  转四位ID: (this: void, rawIdText: string) => number;
  单位拥有原生Buff: (this: void, unit: any, buffId: number) => boolean;
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
  对单位造成强化伤害: (this: void, source: any, target: any, amount: number) => void;
  在坐标播放特效: (this: void, model: string, x: number, y: number, z: number, size: number, lifeSec: number) => void;
  取单位X: (this: void, unit: any) => number;
  取单位Y: (this: void, unit: any) => number;
  注册指定单位暴击后监听: (this: void, unitTypeId: number, handler: (this: void, record: any, applied: number, snapshot: any) => void) => void;
  播放动作: (this: void, unit: any, animationIndex: number, timeScale: number) => void;
  恢复时间流速: (this: void, unit: any) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => any;
};
const { cloud单位技能配置 } = require("系统.03．技能系统.05．单位技能.04．英雄技能.01．cloud.00．配置") as {
  cloud单位技能配置: {
    单位ID: string;
    触发BuffID: string;
    溅射半径: number;
    特效路径: string;
    动作序号: number;
    动作时间流速: number;
    硬直毫秒: number;
  };
};

const cloud单位类型ID = 转四位ID(cloud单位技能配置.单位ID);
const cloud触发BuffID = 转四位ID(cloud单位技能配置.触发BuffID);
const cloud待恢复流速队列: any[] = [];

function 处理cloud硬直恢复(this: void): void {
  const unit = cloud待恢复流速队列.shift();
  if (unit == null) return;
  恢复时间流速(unit);
}

function cloud暴击后处理(this: void, record: any, applied: number, _snapshot: any): void {
  if (!单位拥有原生Buff(record.attacker, cloud触发BuffID)) return;
  开始硬直(record.attacker, cloud单位技能配置.硬直毫秒 * 0.001);
  播放动作(record.attacker, cloud单位技能配置.动作序号, cloud单位技能配置.动作时间流速);
  cloud待恢复流速队列.push(record.attacker);
  addDelayedCallback(cloud单位技能配置.硬直毫秒, 处理cloud硬直恢复);
  const x = 取单位X(record.target);
  const y = 取单位Y(record.target);
  在坐标播放特效(cloud单位技能配置.特效路径, x, y, 0, 1, 1);
  const targets = 获取范围敌军(record.attacker, x, y, cloud单位技能配置.溅射半径);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (target === record.target) continue;
    对单位造成强化伤害(record.attacker, target, applied);
  }
}

export function 注册cloud被动效果(this: void): void {
  注册指定单位暴击后监听(cloud单位类型ID, cloud暴击后处理);
}

注册cloud被动效果();
