/** @noSelfInFile */

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};
const {
  转四位ID,
  取单位X,
  取单位Y,
  在坐标播放特效,
} = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  转四位ID: (this: void, rawIdText: string) => number;
  取单位X: (this: void, unit: any) => number;
  取单位Y: (this: void, unit: any) => number;
  在坐标播放特效: (this: void, model: string, x: number, y: number, z: number, size: number, lifeSec: number) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const {
  注册指定单位闪避后监听,
  以攻击力倍率造成范围暗影伤害,
} = require("系统.03．技能系统.05．单位技能.00．公共.04．闪避被动公共工具") as {
  注册指定单位闪避后监听: (this: void, unitTypeId: number, handler: (this: void, record: any, applied: number, snapshot: any) => void) => void;
  以攻击力倍率造成范围暗影伤害: (this: void, source: any, x: number, y: number, radius: number, damageRate: number) => void;
};
const { 灵力意识体单位技能配置 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.01．灵力意识体.00．配置") as {
  灵力意识体单位技能配置: {
    单位ID: string;
    爆点特效1: string;
    爆点特效2: string;
    伤害半径: number;
    伤害倍率: number;
    延迟毫秒: number;
  };
};

interface 灵力意识体爆点记录 {
  来源单位: any;
  X: number;
  Y: number;
}

const 灵力意识体单位类型ID = 转四位ID(灵力意识体单位技能配置.单位ID);
const 灵力意识体爆点队列: 灵力意识体爆点记录[] = [];
function 播放灵力意识体爆点特效(this: void, x: number, y: number): void {
  在坐标播放特效(灵力意识体单位技能配置.爆点特效1, x, y, 35, 1.1, 1.1);
  在坐标播放特效(灵力意识体单位技能配置.爆点特效2, x, y, 35, 1.1, 0.1);
}

function 处理灵力意识体延迟爆点(this: void): void {
  const record = 灵力意识体爆点队列.shift();
  if (record == null) return;
  播放灵力意识体爆点特效(record.X, record.Y);
  以攻击力倍率造成范围暗影伤害(
    record.来源单位,
    record.X,
    record.Y,
    灵力意识体单位技能配置.伤害半径,
    灵力意识体单位技能配置.伤害倍率,
  );
}

function 灵力意识体闪避后处理(this: void, record: any, _applied: number, _snapshot: any): void {
  const x = 取单位X(record.attacker);
  const y = 取单位Y(record.attacker);
  创建技能提示圈({
    类型: "敌方圆形",
    X: x,
    Y: y,
    半径: 灵力意识体单位技能配置.伤害半径,
    持续时间: 灵力意识体单位技能配置.延迟毫秒 / 1000,
    来源单位: record.target,
  });
  灵力意识体爆点队列.push({ 来源单位: record.target, X: x, Y: y });
  addDelayedCallback(灵力意识体单位技能配置.延迟毫秒, 处理灵力意识体延迟爆点);
}

export function 注册灵力意识体被动效果(this: void): void {
  注册指定单位闪避后监听(灵力意识体单位类型ID, 灵力意识体闪避后处理);
}

注册灵力意识体被动效果();
