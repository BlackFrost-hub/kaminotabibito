/** @noSelfInFile */

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};
const {
  转四位ID,
  单位拥有原生Buff,
  读取单位护甲,
  计算无视护甲补正伤害,
  对单位造成强化伤害,
  注册指定单位暴击后监听,
  播放动作,
  恢复时间流速,
} = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  转四位ID: (this: void, rawIdText: string) => number;
  单位拥有原生Buff: (this: void, unit: any, buffId: number) => boolean;
  读取单位护甲: (this: void, unit: any) => number;
  计算无视护甲补正伤害: (this: void, damage: number, armor: number) => number;
  对单位造成强化伤害: (this: void, source: any, target: any, amount: number) => void;
  注册指定单位暴击后监听: (this: void, unitTypeId: number, handler: (this: void, record: any, applied: number, snapshot: any) => void) => void;
  播放动作: (this: void, unit: any, animationIndex: number, timeScale: number) => void;
  恢复时间流速: (this: void, unit: any) => void;
};
const { 恶魔战士单位技能配置 } = require("系统.03．技能系统.05．单位技能.01．杂鱼技能.03．第三章.01．恶魔战士.00．配置") as {
  恶魔战士单位技能配置: {
    单位ID: string;
    触发BuffID: string;
    动作序号: number;
    动作时间流速: number;
    动作恢复毫秒: number;
  };
};

interface 动作恢复记录 {
  单位: any;
}

const 恶魔战士单位类型ID = 转四位ID(恶魔战士单位技能配置.单位ID);
const 恶魔战士触发BuffID = 转四位ID(恶魔战士单位技能配置.触发BuffID);
const 动作恢复队列: 动作恢复记录[] = [];

function 处理恶魔战士动作恢复(this: void): void {
  const record = 动作恢复队列.shift();
  if (record == null) return;
  恢复时间流速(record.单位);
}

function 恶魔战士暴击后处理(this: void, record: any, applied: number, _snapshot: any): void {
  if (!单位拥有原生Buff(record.attacker, 恶魔战士触发BuffID)) return;

  const armor = 读取单位护甲(record.target);
  const bonusDamage = 计算无视护甲补正伤害(applied, armor);
  if (bonusDamage > 0) {
    对单位造成强化伤害(record.attacker, record.target, bonusDamage);
  }

  播放动作(record.attacker, 恶魔战士单位技能配置.动作序号, 恶魔战士单位技能配置.动作时间流速);
  动作恢复队列.push({ 单位: record.attacker });
  addDelayedCallback(恶魔战士单位技能配置.动作恢复毫秒, 处理恶魔战士动作恢复);
}

export function 注册恶魔战士被动效果(this: void): void {
  注册指定单位暴击后监听(恶魔战士单位类型ID, 恶魔战士暴击后处理);
}

注册恶魔战士被动效果();
