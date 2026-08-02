/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 安兹运行时上下文 } from './01．运行时上下文';
import { 安兹模型动画配置, 安兹乌尔恭数值与表现配置 } from './02．数值与表现配置';
import { 创建可攻击机制单位 } from '../../../../00．技能模板+函数/04．机制组件/05．机制单位/01．可攻击机制单位';
import type { 可攻击机制单位实例 } from '../../../../00．技能模板+函数/04．机制组件/05．机制单位/01．可攻击机制单位';
import { 创建致命伤害保命与限时免疫 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/10．致命伤害保命与限时免疫';
import type { 致命伤害保命与限时免疫控制器 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/10．致命伤害保命与限时免疫';
import { 播放安兹台词 } from './12．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';

const { 读取单位攻击力 } = require('系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具') as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 启动基础施法时间线 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线') as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 获取Boss技能随机敌对英雄 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};
const { addDelayedCallback, removeDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { 广播单位提示 } = require('系统.09．表现系统.06．广播提示消息.index') as {
  广播单位提示: (this: void, sourceUnit: any, text: string, durationMs: number) => void;
};
const { 创建点特效 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 创建Dz绑定单位特效, 获取Dz绑定单位特效, 销毁Dz绑定单位特效 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  创建Dz绑定单位特效: (this: void, unit: any, attachPoint: string, modelPath: string, effectKey?: string, scale?: number) => any;
  获取Dz绑定单位特效: (this: void, unit: any, effectKey?: string) => any;
  销毁Dz绑定单位特效: (this: void, unit: any, effectKey?: string) => void;
};
const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const DzSetEffectAnimation = japi.DzSetEffectAnimation as ((effect: any, animationIndex: number, flag: number) => void) | undefined;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const DEG_TO_RAD = 0.017453292519943295;
const 高阶亡灵召唤大型技能Key = '高阶亡灵召唤';
const 高阶亡灵致命护盾特效Key = '安兹-高阶亡灵致命护盾';

interface 高阶亡灵召唤实例 {
  context: 安兹运行时上下文;
  unit: any;
  机制单位: 可攻击机制单位实例;
  已移除: boolean;
  致命保护已触发: boolean;
  致命保护?: 致命伤害保命与限时免疫控制器;
  致命护盾特效: any;
  致命护盾特效回调ID: number;
}

interface 高阶亡灵致命护盾到期参数 {
  instance: 高阶亡灵召唤实例;
  effect: any;
  callbackId: number;
}

function on高阶亡灵致命护盾到期(this: void, variable?: any): void {
  const 参数 = variable as 高阶亡灵致命护盾到期参数;
  if (参数 == null || 参数.instance == null || 参数.instance.已移除) return;
  const instance = 参数.instance;
  if (instance.致命护盾特效回调ID !== 参数.callbackId || instance.致命护盾特效 !== 参数.effect) return;
  instance.致命护盾特效回调ID = 0;
  if (获取Dz绑定单位特效(instance.unit, 高阶亡灵致命护盾特效Key) === 参数.effect) {
    销毁Dz绑定单位特效(instance.unit, 高阶亡灵致命护盾特效Key);
  }
  instance.致命护盾特效 = null;
}

function 创建高阶亡灵致命护盾特效(this: void, instance: 高阶亡灵召唤实例): void {
  if (instance.已移除 || !单位有效(instance.unit)) return;
  if (instance.致命护盾特效回调ID > 0) {
    removeDelayedCallback(instance.致命护盾特效回调ID);
    instance.致命护盾特效回调ID = 0;
  }
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  const effect = 创建Dz绑定单位特效(
    instance.unit,
    'origin',
    安兹乌尔恭数值与表现配置.表现资源.高阶亡灵召唤致命护盾特效路径,
    高阶亡灵致命护盾特效Key,
    cfg.高阶亡灵召唤致命护盾特效缩放,
  );
  if (effect == null || effect === 0) return;
  instance.致命护盾特效 = effect;
  if (DzSetEffectAnimation != null) DzSetEffectAnimation(effect, 1, 0);
  const 到期参数: 高阶亡灵致命护盾到期参数 = { instance, effect, callbackId: 0 };
  const callbackId = addDelayedCallback(cfg.高阶亡灵召唤致命保护免疫秒 * 1000, on高阶亡灵致命护盾到期, 到期参数);
  到期参数.callbackId = callbackId;
  instance.致命护盾特效回调ID = callbackId;
  instance.context.清理.登记延迟回调('安兹-高阶亡灵致命护盾到期', callbackId);
}

function 停用高阶亡灵致命保护(this: void, instance: 高阶亡灵召唤实例): void {
  instance.致命保护?.停止();
  instance.致命保护 = undefined;
  if (instance.致命护盾特效回调ID > 0) {
    removeDelayedCallback(instance.致命护盾特效回调ID);
    instance.致命护盾特效回调ID = 0;
  }
  if (instance.unit != null && instance.unit !== 0) {
    销毁Dz绑定单位特效(instance.unit, 高阶亡灵致命护盾特效Key);
  }
  instance.致命护盾特效 = null;
}

function 创建高阶亡灵致命保护(this: void, instance: 高阶亡灵召唤实例): void {
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  instance.致命保护 = 创建致命伤害保命与限时免疫({
    名称: '安兹-高阶亡灵致命保护',
    单位: instance.unit,
    固定生命下限: 1,
    免疫持续秒: cfg.高阶亡灵召唤致命保护免疫秒,
    生命下限修正优先级: -100001,
    免疫修正优先级: -100000,
    清理: instance.context.清理,
    过滤致命伤害: function 高阶亡灵致命伤害过滤(this: void): boolean {
      return !instance.已移除 && !instance.致命保护已触发;
    },
    过滤免疫伤害: function 高阶亡灵限时免疫过滤(this: void): boolean {
      return !instance.已移除;
    },
    on触发: function 高阶亡灵致命保护触发(this: void): void {
      instance.致命保护已触发 = true;
      创建高阶亡灵致命护盾特效(instance);
    },
  });
}

interface 高阶亡灵机制单位回调变量 {
  instance?: 高阶亡灵召唤实例;
}

function 清理高阶亡灵状态(this: void, instance: 高阶亡灵召唤实例): void {
  if (instance.已移除) return;
  instance.已移除 = true;
  停用高阶亡灵致命保护(instance);
  if (instance.context.高阶亡灵召唤物 === instance.unit) instance.context.高阶亡灵召唤物 = undefined;
  instance.unit = 0;
}

function 清理高阶亡灵实例(this: void, instance: 高阶亡灵召唤实例): void {
  if (instance == null || instance.已移除) return;
  instance.机制单位.销毁();
}

function on高阶亡灵机制单位销毁(this: void, _unit: any, variable?: any): void {
  const instance = (variable as 高阶亡灵机制单位回调变量 | undefined)?.instance;
  if (instance == null) return;
  清理高阶亡灵状态(instance);
}

function on高阶亡灵尸体移除(this: void, variable?: any): void {
  const instance = variable as 高阶亡灵召唤实例 | undefined;
  if (instance == null || instance.已移除) return;
  清理高阶亡灵实例(instance);
}

function on高阶亡灵机制单位死亡(this: void, _dyingUnit: any, _killingUnit: any, variable?: any): void {
  const instance = (variable as 高阶亡灵机制单位回调变量 | undefined)?.instance;
  if (instance == null || instance.已移除) return;
  const context = instance.context;
  if (context.高阶亡灵召唤物 === instance.unit) context.高阶亡灵召唤物 = undefined;
  停用高阶亡灵致命保护(instance);
  if (!context.挑战已结束 && !context.清理.已清理()) {
    context.亡灵箭削弱到Ms = getServerTime() + 安兹乌尔恭数值与表现配置.阶段技能.高阶亡灵击败削弱秒 * 1000;
    广播单位提示(
      context.安兹单位,
      '|cff80d8ff[机制]|r 高阶亡灵已消灭：亡灵箭伤害降低25%，持续12秒。（优先击败死亡骑士，可降低后续亡灵箭压力。）',
      3500,
    );
  }
  const removeId = addDelayedCallback(3000, on高阶亡灵尸体移除, instance);
  context.清理.登记延迟回调('安兹-高阶亡灵尸体移除', removeId);
}

function 播放召唤特效(this: void, model: string, x: number, y: number, scale: number): void {
  创建点特效({
    模型路径: model,
    X: x,
    Y: y,
    缩放: scale,
    持续秒: 安兹乌尔恭数值与表现配置.阶段技能.高阶亡灵召唤表现持续秒,
  });
}

function 创建高阶亡灵(this: void, context: 安兹运行时上下文, x: number, y: number, target: any): void {
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束) return;
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  const 回调变量: 高阶亡灵机制单位回调变量 = {};
  const 机制单位 = 创建可攻击机制单位({
    清理: context.清理,
    名称: '安兹-高阶亡灵召唤物',
    主人单位: boss,
    单位类型: cfg.高阶亡灵召唤单位ID,
    单位名称: cfg.高阶亡灵召唤单位名称,
    模型文件: cfg.高阶亡灵召唤模型路径,
    X: x,
    Y: y,
    朝向: GetUnitFacing(boss),
    生命值: GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * cfg.高阶亡灵召唤生命Boss最大生命比例,
    生命值受小怪倍率: false,
    攻击力: 读取单位攻击力(boss) * cfg.高阶亡灵召唤攻击Boss攻击力比例,
    攻击间隔: cfg.高阶亡灵召唤攻击间隔,
    攻击范围: cfg.高阶亡灵召唤攻击范围,
    索敌范围: cfg.高阶亡灵召唤索敌范围,
    护甲: cfg.高阶亡灵召唤护甲,
    缩放: cfg.高阶亡灵召唤缩放,
    透明度: cfg.高阶亡灵召唤透明度,
    红: 150,
    绿: 205,
    蓝: 255,
    变量: 回调变量,
    on死亡: on高阶亡灵机制单位死亡,
    on销毁: on高阶亡灵机制单位销毁,
  });
  if (机制单位 == null || !单位有效(机制单位.单位)) return;
  const summon = 机制单位.单位;
  const instance: 高阶亡灵召唤实例 = {
    context,
    unit: summon,
    机制单位,
    已移除: false,
    致命保护已触发: false,
    致命护盾特效: null,
    致命护盾特效回调ID: 0,
  };
  回调变量.instance = instance;
  context.高阶亡灵召唤物 = summon;
  创建高阶亡灵致命保护(instance);
  if (单位有效(target)) IssueTargetOrder(summon, 'attack', target);
  广播单位提示(
    boss,
    '|cffff6060[机制]|r 死亡骑士存活期间，安兹的亡灵箭伤害提高35%；首次受到致命伤害时保留1点生命并免伤1秒，之后可正常击败。（护盾消失后再次集火，可让亡灵箭降至基础值的75%。）',
    3500,
  );
}

export function 取安兹亡灵箭伤害倍率(this: void, context: 安兹运行时上下文): number {
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  if (单位有效(context.高阶亡灵召唤物)) return cfg.高阶亡灵召唤亡灵箭强化倍率;
  if (getServerTime() < context.亡灵箭削弱到Ms) return cfg.高阶亡灵击败后亡灵箭倍率;
  return 1;
}

export function 释放安兹高阶亡灵召唤(this: void, context: 安兹运行时上下文): boolean {
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束 || context.当前大型技能 != null) return false;
  if (单位有效(context.高阶亡灵召唤物)) return false;
  context.高阶亡灵召唤物 = undefined;
  const target = 获取Boss技能随机敌对英雄(boss);
  if (!单位有效(target)) return false;
  const cfg = 安兹乌尔恭数值与表现配置;
  const stage = cfg.阶段技能;
  const angle = GetUnitFacing(boss) * DEG_TO_RAD;
  const summonX = GetUnitX(boss) + Cos(angle) * stage.高阶亡灵召唤距离;
  const summonY = GetUnitY(boss) + Sin(angle) * stage.高阶亡灵召唤距离;
  context.当前大型技能 = 高阶亡灵召唤大型技能Key;
  播放安兹台词(boss, '高阶亡灵召唤');
  播放Boss坐标音效(安兹乌尔恭数值与表现配置.音效.高阶亡灵召唤, GetUnitX(boss), GetUnitY(boss), 安兹乌尔恭数值与表现配置.音效默认裁断距离);
  播放召唤特效(cfg.表现资源.高阶亡灵召唤门特效路径, summonX, summonY, stage.高阶亡灵召唤门缩放);
  播放召唤特效(cfg.表现资源.高阶亡灵召唤外圈特效路径, summonX, summonY, stage.高阶亡灵召唤外圈缩放);
  播放召唤特效(cfg.表现资源.高阶亡灵召唤内圈特效路径, summonX, summonY, stage.高阶亡灵召唤内圈缩放);
  启动基础施法时间线({
    施法者: boss,
    目标X: summonX,
    目标Y: summonY,
    硬直秒: stage.高阶亡灵召唤施法秒,
    动画编号: stage.高阶亡灵召唤动画编号,
    动画速度: stage.高阶亡灵召唤动画速度,
    恢复动画编号: 安兹模型动画配置.待机编号,
    吟唱条: {
      通道: '常规技能',
      总时长: stage.高阶亡灵召唤施法秒,
      颜色ID: 4,
      标题文本: '高阶亡灵召唤',
      提示文本: '1.2秒后召唤死亡骑士；存活时亡灵箭伤害提高35%，击败后12秒内降至75%',
    },
    on生效: function 高阶亡灵召唤生效(this: void): void {
      创建高阶亡灵(context, summonX, summonY, target);
      const finishId = addDelayedCallback(stage.高阶亡灵召唤收尾秒 * 1000, function 高阶亡灵召唤收尾(this: void): void {
        if (context.当前大型技能 === 高阶亡灵召唤大型技能Key) {
          context.当前大型技能 = undefined;
          context.上次大型技能结束Ms = getServerTime();
        }
      });
      context.清理.登记延迟回调('安兹-高阶亡灵召唤收尾', finishId);
    },
  });
  return true;
}

export const 高阶亡灵召唤技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  类型: '高威胁单体召唤',
  语义: '每次只召唤一个高威胁亡灵，只强化安兹的一类法术，击败后给予明确团队收益。',
} as const;
