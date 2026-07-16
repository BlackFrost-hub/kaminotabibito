/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 安兹运行时上下文 } from './01．运行时上下文';
import { 安兹模型动画配置, 安兹乌尔恭数值与表现配置 } from './02．数值与表现配置';
import { 创建固定组合技能执行器 } from '../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器';
import {
  创建立即执行阶段,
  创建延迟阶段,
} from '../../../../00．技能模板+函数/00．技能模板/01．多阶段技能编排/06．技能阶段链执行器';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 创建可攻击机制单位, type 可攻击机制单位实例 } from '../../../../00．技能模板+函数/04．机制组件/05．机制单位/01．可攻击机制单位';
import { 创建单位停留触发器, type 单位停留触发控制器 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/06．单位停留触发器';
import { 安兹乌尔恭BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/03．异界Boss/01．安兹乌尔恭';
import {
  启动雅儿贝德生命锚点封锁,
  type 生命锚点封锁控制器,
  type 生命锚点封锁目标,
} from './01．护卫雅儿贝德/06．生命锚点封锁';
import { 播放安兹台词 } from './12．台词播放';

const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 广播单位提示 } = require('系统.09．表现系统.06．广播提示消息.index') as {
  广播单位提示: (this: void, sourceUnit: any, text: string, durationMs: number) => void;
};
const { 显示大招吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示大招吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const Player = jass.Player as (id: number) => any;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (unit: any, flag: boolean) => void;
const PauseUnit = jass.PauseUnit as (unit: any, flag: boolean) => void;
const SetUnitPathing = jass.SetUnitPathing as (unit: any, flag: boolean) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, unit: any, point: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS as any;
const DAMAGE_TYPE_UNIVERSAL = jass.DAMAGE_TYPE_UNIVERSAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;
const EXSetEffectXY = japi.EXSetEffectXY as (effect: any, x: number, y: number) => void;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as (effect: any, degrees: number) => void;
const DEG_TO_RAD = 0.017453292519943295;
const 一切生命的终点大型技能Key = '一切生命的终点';

interface 生命锚点状态 {
  单位实例: 可攻击机制单位实例;
  地面特效: any;
  圣光特效: any;
  停留控制器?: 单位停留触发控制器;
  已激活: boolean;
  已封锁: boolean;
}

interface 一切生命的终点实例 {
  context: 安兹运行时上下文;
  锚点列表: 生命锚点状态[];
  庇护单位表: Record<number, true | undefined>;
  倒计时特效: any;
  锚点封锁?: 生命锚点封锁控制器;
  已清理: boolean;
}

function 销毁特效(this: void, effect: any): void {
  if (effect != null && effect !== 0) DestroyEffect(effect);
}

function 清理生命锚点(this: void, anchor: 生命锚点状态): void {
  if (anchor.停留控制器 != null) {
    anchor.停留控制器.停止();
    anchor.停留控制器 = undefined;
  }
  销毁特效(anchor.地面特效);
  销毁特效(anchor.圣光特效);
  anchor.地面特效 = 0;
  anchor.圣光特效 = 0;
  anchor.单位实例.销毁();
}

function 清理一切生命的终点实例(this: void, instance: 一切生命的终点实例): void {
  if (instance.已清理) return;
  instance.已清理 = true;
  关闭吟唱条('大招');
  销毁特效(instance.倒计时特效);
  instance.倒计时特效 = 0;
  instance.锚点封锁?.结束('一切生命的终点清理');
  instance.锚点封锁 = undefined;
  for (let i = 0; i < instance.锚点列表.length; i++) 清理生命锚点(instance.锚点列表[i]);
  const heroes = 获取Boss技能敌对英雄列表(instance.context.安兹单位);
  for (let i = 0; i < heroes.length; i++) 移除单位指定Buff(heroes[i], 安兹乌尔恭BuffID.生命庇护);
  if (instance.context.当前大型技能 === 一切生命的终点大型技能Key) {
    instance.context.当前大型技能 = undefined;
    instance.context.上次大型技能结束Ms = getServerTime();
  }
}

function 取已激活锚点数量(this: void, instance: 一切生命的终点实例): number {
  let count = 0;
  for (let i = 0; i < instance.锚点列表.length; i++) {
    if (instance.锚点列表[i].已激活) count++;
  }
  return count;
}

function 授予全队生命庇护(this: void, instance: 一切生命的终点实例): void {
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  const heroes = 获取Boss技能敌对英雄列表(instance.context.安兹单位);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    instance.庇护单位表[GetHandleId(hero)] = true;
    registerManualBuff(hero, 安兹乌尔恭BuffID.生命庇护, cfg.一切生命的终点倒计时秒 + 2, 1, {
      sourceName: '安兹-一切生命的终点',
    });
  }
  广播单位提示(instance.context.安兹单位, '|cffffff99三座生命锚点已经响应：英魂庇护将抵挡女妖哭嚎。|r', 3600);
}

function 激活生命锚点(this: void, instance: 一切生命的终点实例, anchor: 生命锚点状态): void {
  if (instance.已清理 || anchor.已激活 || anchor.已封锁) return;
  anchor.已激活 = true;
  if (anchor.停留控制器 != null) {
    anchor.停留控制器.停止();
    anchor.停留控制器 = undefined;
  }
  const count = 取已激活锚点数量(instance);
  const required = 安兹乌尔恭数值与表现配置.阶段技能.生命锚点数量;
  广播单位提示(instance.context.安兹单位, `|cffffff99生命锚点已激活（${count}/${required}）|r`, 2200);
  if (instance.锚点列表.length === required && count >= required) 授予全队生命庇护(instance);
}

function 创建生命锚点(this: void, instance: 一切生命的终点实例, x: number, y: number, index: number): void {
  const cfg = 安兹乌尔恭数值与表现配置;
  const stage = cfg.阶段技能;
  const unitInstance = 创建可攻击机制单位({
    名称: `安兹-生命锚点-${index + 1}`,
    主人单位: instance.context.安兹单位,
    所属玩家: Player(15),
    单位类型: stage.生命锚点单位ID,
    模型路径: cfg.表现资源.生命锚点特效路径,
    X: x,
    Y: y,
    最大生命: 1,
    生命值受小怪倍率: false,
    缩放: stage.生命锚点缩放,
  });
  if (unitInstance == null) return;
  SetUnitInvulnerable(unitInstance.单位, true);
  PauseUnit(unitInstance.单位, true);
  SetUnitPathing(unitInstance.单位, false);
  const ground = AddSpecialEffect(cfg.表现资源.生命锚点地面层特效路径, x, y);
  const holy = AddSpecialEffect(cfg.表现资源.生命锚点圣光层特效路径, x, y);
  if (ground != null && ground !== 0) EXSetEffectSize(ground, stage.生命锚点地面层缩放);
  if (holy != null && holy !== 0) EXSetEffectSize(holy, stage.生命锚点圣光层缩放);
  const anchor: 生命锚点状态 = {
    单位实例: unitInstance,
    地面特效: ground,
    圣光特效: holy,
    已激活: false,
    已封锁: false,
  };
  instance.锚点列表.push(anchor);
  anchor.停留控制器 = 创建单位停留触发器({
    名称: `安兹-生命锚点停留-${index + 1}`,
    中心单位: unitInstance.单位,
    半径: stage.生命锚点激活半径,
    需求持续毫秒: stage.生命锚点激活停留秒 * 1000,
    检查间隔毫秒: 100,
    离开后重置: true,
    只触发一次: true,
    读取单位列表: function 读取生命锚点玩家(this: void): any[] {
      return 获取Boss技能敌对英雄列表(instance.context.安兹单位);
    },
    过滤单位: function 过滤封锁中的生命锚点(this: void): boolean {
      return !anchor.已封锁;
    },
    on触发: function 生命锚点停留完成(this: void): void {
      激活生命锚点(instance, anchor);
    },
  });
}

function 创建生命锚点封锁目标(this: void, anchor: 生命锚点状态): 生命锚点封锁目标 {
  return {
    单位: anchor.单位实例.单位,
    是否已激活: function 读取生命锚点激活状态(this: void): boolean {
      return anchor.已激活;
    },
    设置封锁: function 写入生命锚点封锁状态(this: void, blocked: boolean): void {
      anchor.已封锁 = blocked;
    },
  };
}

function 创建一切生命的终点预警(this: void, instance: 一切生命的终点实例): void {
  const context = instance.context;
  const boss = context.安兹单位;
  const cfg = 安兹乌尔恭数值与表现配置;
  const stage = cfg.阶段技能;
  const originX = GetUnitX(boss);
  const originY = GetUnitY(boss);
  instance.倒计时特效 = AddSpecialEffectTarget(cfg.表现资源.一切生命的终点倒计时特效路径, boss, 'origin');
  for (let i = 0; i < stage.生命锚点数量; i++) {
    const angle = (90 + i * 360 / stage.生命锚点数量) * DEG_TO_RAD;
    创建生命锚点(instance, originX + Cos(angle) * stage.生命锚点距离, originY + Sin(angle) * stage.生命锚点距离, i);
  }
  const blockTargets: 生命锚点封锁目标[] = [];
  for (let i = 0; i < instance.锚点列表.length; i++) blockTargets.push(创建生命锚点封锁目标(instance.锚点列表[i]));
  instance.锚点封锁 = 启动雅儿贝德生命锚点封锁(context, blockTargets, stage.一切生命的终点倒计时秒);
  广播单位提示(boss, '|cffff6666一切生命的终点：在十二秒内依次激活三座生命锚点！|r', 4200);
}

function 播放女妖哭嚎表现(this: void, instance: 一切生命的终点实例): void {
  const boss = instance.context.安兹单位;
  const cfg = 安兹乌尔恭数值与表现配置;
  const stage = cfg.阶段技能;
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  for (let i = 0; i < stage.女妖哭嚎死亡波数量; i++) {
    const effect = AddSpecialEffect(cfg.表现资源.女妖哭嚎死亡波特效路径, x, y);
    if (effect == null || effect === 0) continue;
    EXSetEffectXY(effect, x, y);
    EXEffectMatRotateZ(effect, i * 360 / stage.女妖哭嚎死亡波数量);
    EXSetEffectSize(effect, stage.女妖哭嚎死亡波缩放);
    YDWETimerDestroyEffectSafe(stage.女妖哭嚎特效持续秒, effect);
  }
}

function 结算女妖哭嚎(this: void, instance: 一切生命的终点实例): boolean {
  if (instance.已清理 || instance.context.挑战已结束) return false;
  播放女妖哭嚎表现(instance);
  const boss = instance.context.安兹单位;
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const solved = instance.锚点列表.length === cfg.生命锚点数量
    && 取已激活锚点数量(instance) >= cfg.生命锚点数量;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero) || instance.庇护单位表[GetHandleId(hero)] === true) continue;
    造成AOE技能伤害({
      来源: boss,
      目标: hero,
      伤害: GetUnitState(hero, UNIT_STATE_MAX_LIFE) * cfg.女妖哭嚎致命伤害最大生命比例,
      attack: false,
      ranged: true,
      attackType: ATTACK_TYPE_CHAOS,
      伤害类型: DAMAGE_TYPE_UNIVERSAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: 'Boss技能',
      标签: '安兹·女妖哭嚎',
    });
  }
  if (solved) 广播单位提示(boss, '|cffffff99死亡法则已经被英魂誓约撕开，集中攻击安兹！|r', 3600);
  else 广播单位提示(boss, '|cffff4444生命锚点未能全部响应，女妖哭嚎完成致命裁定。|r', 3200);
  return solved;
}

export function 释放安兹一切生命的终点(this: void, context: 安兹运行时上下文): boolean {
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束 || context.一切生命的终点已释放 || context.当前大型技能 != null) return false;
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  const executor = 创建固定组合技能执行器<安兹运行时上下文>({
    名称: '安兹·一切生命的终点固定序列',
    清理: context.清理,
    互斥组: '安兹大型技能',
  });
  const instance: 一切生命的终点实例 = {
    context,
    锚点列表: [],
    庇护单位表: {},
    倒计时特效: 0,
    已清理: false,
  };
  context.一切生命的终点已释放 = true;
  context.当前大型技能 = 一切生命的终点大型技能Key;
  播放安兹台词(boss, '一切生命的终点');
  context.清理.登记清理('安兹-一切生命的终点实例', function 一切生命的终点实例清理(this: void): void {
    清理一切生命的终点实例(instance);
  });
  播放限时单位动画({
    单位: boss,
    动画编号: cfg.一切生命的终点动画编号,
    动画速度: cfg.一切生命的终点动画速度,
    持续秒: cfg.一切生命的终点倒计时秒,
    恢复动画编号: 安兹模型动画配置.待机编号,
  });
  显示大招吟唱条({
    通道: '大招',
    总时长: cfg.一切生命的终点倒计时秒,
    颜色ID: 2,
    标题文本: '一切生命的终点',
    提示文本: '依次激活三座生命锚点，取得英魂庇护',
  });
  let solved = false;
  const executionId = executor.开始({
    key: 一切生命的终点大型技能Key,
    单位: boss,
    上下文: context,
    最大持续毫秒: (cfg.一切生命的终点倒计时秒 + cfg.一切生命的终点破解输出窗口秒 + 2) * 1000,
    阶段列表: [
      创建立即执行阶段(function 一切生命的终点展示(this: void): void {
        创建一切生命的终点预警(instance);
      }, '死亡倒计时与生命锚点'),
      创建延迟阶段(cfg.一切生命的终点倒计时秒 * 1000, '十二秒死亡倒计时'),
      创建立即执行阶段(function 女妖哭嚎结算(this: void): void {
        solved = 结算女妖哭嚎(instance);
      }, '女妖哭嚎'),
      创建延迟阶段(cfg.一切生命的终点破解输出窗口秒 * 1000, '死亡法则破解输出窗口'),
    ],
    结束回调: function 一切生命的终点固定序列结束(this: void): void {
      if (!solved) context.上次大型技能结束Ms = getServerTime();
      清理一切生命的终点实例(instance);
    },
  });
  if (executionId === 0) {
    清理一切生命的终点实例(instance);
    return false;
  }
  return true;
}

export const 一切生命的终点技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  类型: '死亡法则阶段技',
  语义: '十二秒倒计时内激活生命锚点，借亚伦柯斯英魂庇护承受最终女妖哭嚎。',
  实现要求: '缺少生命庇护才进入致命结算；成功破解后给予主要输出窗口。',
} as const;
