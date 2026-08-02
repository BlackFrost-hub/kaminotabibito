/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

import type { 安兹运行时上下文 } from './01．运行时上下文';
import { 安兹模型动画配置, 安兹乌尔恭数值与表现配置 } from './02．数值与表现配置';
import { 创建安兹现实断裂移动 } from './03．现实断裂';
import { 安排安兹高阶魔法箭特效后音效 } from './05．高阶魔法箭';
import { 取安兹亡灵箭伤害倍率 } from './08．高阶亡灵召唤';
import { 创建固定组合技能执行器 } from '../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器';
import {
  创建立即执行阶段,
  创建延迟阶段,
} from '../../../../00．技能模板+函数/00．技能模板/01．多阶段技能编排/06．技能阶段链执行器';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 开始硬直 } from '../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 播放安兹台词 } from './12．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 创建雅儿贝德时间停止冲锋预警, 启动雅儿贝德时间停止冲锋 } from './01．护卫雅儿贝德/07．技能驱动';

const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 添加单位暂停, 移除单位暂停 } = require('lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统') as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 显示大招吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示大招吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { 创建点特效 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  创建点特效: (this: void, 参数: any) => any;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, unit: any, point: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;
const RAD_TO_DEG = 57.29577951308232;
const 时间停止大型技能Key = '时间停止';
const 时间停止暂停来源 = '安兹-时间停止';

interface 时间停止锁定数据 {
  地面法阵X: number;
  地面法阵Y: number;
  魔法箭X: number;
  魔法箭Y: number;
  裂缝起点X: number;
  裂缝起点Y: number;
  裂缝终点X: number;
  裂缝终点Y: number;
  裂缝角度: number;
  雅儿贝德冲锋终点X: number;
  雅儿贝德冲锋终点Y: number;
}

interface 时间停止实例 {
  context: 安兹运行时上下文;
  锁定: 时间停止锁定数据;
  暂停单位列表: any[];
  持续特效列表: any[];
  已清理: boolean;
}

function 取时间停止总时长秒(this: void): number {
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  return cfg.时间停止预展示秒
    + cfg.时间停止冻结秒
    + cfg.时间停止结算间隔秒 * 2
    + cfg.时间停止收尾秒;
}

function 创建时间停止锁定(this: void, context: 安兹运行时上下文): 时间停止锁定数据 | undefined {
  const boss = context.安兹单位;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  if (heroes.length <= 0) return undefined;
  const start = GetRandomInt(0, heroes.length - 1);
  const groundTarget = heroes[start];
  const arrowTarget = heroes[(start + 1) % heroes.length];
  const lineTarget = heroes[(start + 2) % heroes.length];
  if (!单位有效(groundTarget) || !单位有效(arrowTarget) || !单位有效(lineTarget)) return undefined;
  const ordinary = 安兹乌尔恭数值与表现配置.普通技能;
  const originX = GetUnitX(boss);
  const originY = GetUnitY(boss);
  const angleRadians = Atan2(GetUnitY(lineTarget) - originY, GetUnitX(lineTarget) - originX);
  return {
    地面法阵X: GetUnitX(groundTarget),
    地面法阵Y: GetUnitY(groundTarget),
    魔法箭X: GetUnitX(arrowTarget),
    魔法箭Y: GetUnitY(arrowTarget),
    裂缝起点X: originX,
    裂缝起点Y: originY,
    裂缝终点X: originX + Cos(angleRadians) * ordinary.现实断裂路径长度,
    裂缝终点Y: originY + Sin(angleRadians) * ordinary.现实断裂路径长度,
    裂缝角度: angleRadians * RAD_TO_DEG,
    雅儿贝德冲锋终点X: GetUnitX(lineTarget),
    雅儿贝德冲锋终点Y: GetUnitY(lineTarget),
  };
}

function 创建时间停止预警(this: void, instance: 时间停止实例): void {
  const cfg = 安兹乌尔恭数值与表现配置;
  const stage = cfg.阶段技能;
  const ordinary = cfg.普通技能;
  const locked = instance.锁定;
  const groundDuration = stage.时间停止预展示秒 + stage.时间停止冻结秒;
  创建技能提示圈({
    类型: '敌方圆形',
    X: locked.地面法阵X,
    Y: locked.地面法阵Y,
    半径: stage.时间停止地面法阵半径,
    持续时间: groundDuration,
    来源单位: instance.context.安兹单位,
  });
  if (instance.context.模式 === '守护者介入') {
    创建雅儿贝德时间停止冲锋预警(
      instance.context,
      locked.雅儿贝德冲锋终点X,
      locked.雅儿贝德冲锋终点Y,
      groundDuration,
    );
  }
  创建技能提示圈({
    类型: '矩形',
    X: locked.裂缝起点X,
    Y: locked.裂缝起点Y,
    宽度: ordinary.现实断裂路径宽度,
    长度: ordinary.现实断裂路径长度,
    朝向: locked.裂缝角度,
    持续时间: groundDuration + stage.时间停止结算间隔秒,
    来源单位: instance.context.安兹单位,
  });
  创建技能提示圈({
    类型: '敌方圆形',
    X: locked.魔法箭X,
    Y: locked.魔法箭Y,
    半径: ordinary.高阶魔法箭伤害半径,
    持续时间: groundDuration + stage.时间停止结算间隔秒 * 2,
    来源单位: instance.context.安兹单位,
  });
}

function 创建时间停止持续表现(this: void, instance: 时间停止实例): void {
  const cfg = 安兹乌尔恭数值与表现配置;
  const boss = instance.context.安兹单位;
  const clock = AddSpecialEffectTarget(cfg.表现资源.时间停止钟面特效路径, boss, 'origin');
  const gear = AddSpecialEffectTarget(cfg.表现资源.时间停止齿轮特效路径, boss, 'origin');
  if (clock != null && clock !== 0) {
    EXSetEffectSize(clock, cfg.阶段技能.时间停止钟面缩放);
    instance.持续特效列表.push(clock);
  }
  if (gear != null && gear !== 0) {
    EXSetEffectSize(gear, cfg.阶段技能.时间停止齿轮缩放);
    instance.持续特效列表.push(gear);
  }
}

function 冻结时间停止玩家(this: void, instance: 时间停止实例): void {
  if (instance.context.挑战已结束 || instance.context.清理.已清理()) return;
  instance.context.时间停止中 = true;
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  显示大招吟唱条({
    通道: '大招',
    总时长: cfg.时间停止冻结秒,
    颜色ID: 4,
    标题文本: '时间停止中',
    提示文本: '冻结持续1.6秒；解冻后依次结算法阵、现实断裂和魔法箭',
  });
  const heroes = 获取Boss技能敌对英雄列表(instance.context.安兹单位);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (添加单位暂停(hero, 时间停止暂停来源)) instance.暂停单位列表.push(hero);
  }
}

function 恢复时间停止玩家(this: void, instance: 时间停止实例): void {
  for (let i = 0; i < instance.暂停单位列表.length; i++) {
    const hero = instance.暂停单位列表[i];
    if (hero != null && hero !== 0) 移除单位暂停(hero, 时间停止暂停来源);
  }
  instance.暂停单位列表 = [];
  instance.context.时间停止中 = false;
  关闭吟唱条('大招');
}

function 销毁时间停止持续表现(this: void, instance: 时间停止实例): void {
  for (let i = 0; i < instance.持续特效列表.length; i++) {
    const effect = instance.持续特效列表[i];
    if (effect != null && effect !== 0) DestroyEffect(effect);
  }
  instance.持续特效列表 = [];
}

function 清理时间停止实例(this: void, instance: 时间停止实例): void {
  if (instance.已清理) return;
  instance.已清理 = true;
  恢复时间停止玩家(instance);
  销毁时间停止持续表现(instance);
  const context = instance.context;
  if (context.当前大型技能 === 时间停止大型技能Key) {
    context.当前大型技能 = undefined;
    context.上次大型技能结束Ms = getServerTime();
  }
  const boss = context.安兹单位;
  if (单位有效(boss)) {
    SetUnitTimeScale(boss, 1);
    SetUnitAnimationByIndex(boss, 安兹模型动画配置.待机编号);
  }
}

function 播放时间停止结算特效(this: void, model: string, x: number, y: number, scale: number): any {
  return 创建点特效({
    模型路径: model,
    X: x,
    Y: y,
    缩放: scale,
    持续秒: 安兹乌尔恭数值与表现配置.阶段技能.时间停止结算特效持续秒,
  });
}

function 造成时间停止伤害(this: void, boss: any, target: any, 伤害公式: any, tag: string): void {
  执行BossAOE技能伤害({
    来源: boss,
    目标: target,
    伤害公式,
    attack: false,
    ranged: true,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_MAGIC,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: tag,
  });
}

function 结算时间停止地面法阵(this: void, instance: 时间停止实例): void {
  const context = instance.context;
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束) return;
  const cfg = 安兹乌尔恭数值与表现配置;
  const locked = instance.锁定;
  播放时间停止结算特效(
    cfg.表现资源.时间停止地面法阵特效路径,
    locked.地面法阵X,
    locked.地面法阵Y,
    cfg.阶段技能.时间停止地面法阵缩放,
  );
  const radius2 = cfg.阶段技能.时间停止地面法阵半径 * cfg.阶段技能.时间停止地面法阵半径;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    if (!单位有效(target)) continue;
    const dx = GetUnitX(target) - locked.地面法阵X;
    const dy = GetUnitY(target) - locked.地面法阵Y;
    if (dx * dx + dy * dy > radius2) continue;
    造成时间停止伤害(
      boss,
      target,
      {
        来源攻击力比例: cfg.阶段技能.时间停止地面法阵伤害Boss攻击力比例,
        目标最大生命比例: cfg.阶段技能.时间停止地面法阵伤害目标最大生命比例,
      },
      '安兹·时间停止·地面法阵',
    );
  }
}

function 结算时间停止现实断裂(this: void, instance: 时间停止实例): void {
  const context = instance.context;
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束) return;
  const locked = instance.锁定;
  播放Boss坐标音效(
    安兹乌尔恭数值与表现配置.音效.现实断裂,
    locked.裂缝起点X,
    locked.裂缝起点Y,
    安兹乌尔恭数值与表现配置.音效默认裁断距离,
  );
  创建安兹现实断裂移动(context, locked.裂缝角度, locked.裂缝起点X, locked.裂缝起点Y);
}

function 结算时间停止魔法箭(this: void, instance: 时间停止实例): void {
  const context = instance.context;
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束) return;
  const cfg = 安兹乌尔恭数值与表现配置;
  const ordinary = cfg.普通技能;
  const locked = instance.锁定;
  播放时间停止结算特效(
    cfg.表现资源.高阶魔法箭特效路径,
    locked.魔法箭X,
    locked.魔法箭Y,
    ordinary.高阶魔法箭特效缩放,
  );
  安排安兹高阶魔法箭特效后音效(context);
  const radius2 = ordinary.高阶魔法箭伤害半径 * ordinary.高阶魔法箭伤害半径;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    if (!单位有效(target)) continue;
    const dx = GetUnitX(target) - locked.魔法箭X;
    const dy = GetUnitY(target) - locked.魔法箭Y;
    if (dx * dx + dy * dy > radius2) continue;
    造成时间停止伤害(
      boss,
      target,
      {
        来源攻击力比例: ordinary.高阶魔法箭伤害Boss攻击力比例,
        目标最大生命比例: ordinary.高阶魔法箭伤害目标最大生命比例,
        总倍率: 取安兹亡灵箭伤害倍率(context),
      },
      '安兹·时间停止·高阶魔法箭',
    );
  }
}

export function 释放安兹时间停止(this: void, context: 安兹运行时上下文): boolean {
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束 || context.当前大型技能 != null || context.时间停止中) return false;
  const locked = 创建时间停止锁定(context);
  if (locked == null) return false;
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  const executor = 创建固定组合技能执行器<安兹运行时上下文>({
    名称: '安兹·时间停止固定序列',
    清理: context.清理,
    互斥组: '安兹大型技能',
  });
  const instance: 时间停止实例 = {
    context,
    锁定: locked,
    暂停单位列表: [],
    持续特效列表: [],
    已清理: false,
  };
  context.当前大型技能 = 时间停止大型技能Key;
  播放安兹台词(boss, '时间停止启动');
  播放Boss坐标音效(安兹乌尔恭数值与表现配置.音效.时间停止启动, GetUnitX(boss), GetUnitY(boss), 安兹乌尔恭数值与表现配置.音效默认裁断距离);
  context.清理.登记清理('安兹-时间停止实例', function 时间停止实例清理(this: void): void {
    清理时间停止实例(instance);
  });
  const totalSeconds = 取时间停止总时长秒();
  开始硬直(boss, totalSeconds);
  播放限时单位动画({
    单位: boss,
    动画编号: cfg.时间停止动画编号,
    动画速度: cfg.时间停止动画速度,
    持续秒: totalSeconds,
    恢复动画编号: 安兹模型动画配置.待机编号,
  });
  显示大招吟唱条({
    通道: '大招',
    总时长: cfg.时间停止预展示秒,
    颜色ID: 4,
    标题文本: '2.8秒后时间停止',
    提示文本: '2.8秒后冻结1.6秒；预展示期间离开预警并分散',
  });
  const executionId = executor.开始({
    key: 时间停止大型技能Key,
    单位: boss,
    上下文: context,
    最大持续毫秒: (totalSeconds + 1) * 1000,
    阶段列表: [
      创建立即执行阶段(function 时间停止展示未来(this: void): void {
        创建时间停止预警(instance);
        创建时间停止持续表现(instance);
      }, '展示未来落点'),
      创建延迟阶段(cfg.时间停止预展示秒 * 1000, '冻结前走位'),
      创建立即执行阶段(function 时间停止冻结(this: void): void {
        冻结时间停止玩家(instance);
      }, '时间冻结'),
      创建延迟阶段(cfg.时间停止冻结秒 * 1000, '冻结布置'),
      创建立即执行阶段(function 时间停止恢复并结算法阵(this: void): void {
        恢复时间停止玩家(instance);
        启动雅儿贝德时间停止冲锋(
          context,
          locked.雅儿贝德冲锋终点X,
          locked.雅儿贝德冲锋终点Y,
        );
        播放安兹台词(boss, '时间停止结算');
        结算时间停止地面法阵(instance);
      }, '地面法阵结算'),
      创建延迟阶段(cfg.时间停止结算间隔秒 * 1000, '裂缝结算间隔'),
      创建立即执行阶段(function 时间停止结算裂缝(this: void): void {
        结算时间停止现实断裂(instance);
      }, '现实断裂结算'),
      创建延迟阶段(cfg.时间停止结算间隔秒 * 1000, '魔法箭结算间隔'),
      创建立即执行阶段(function 时间停止结算魔法箭(this: void): void {
        结算时间停止魔法箭(instance);
      }, '魔法箭结算'),
      创建延迟阶段(cfg.时间停止收尾秒 * 1000, '时间停止收尾'),
    ],
    结束回调: function 时间停止固定序列结束(this: void): void {
      清理时间停止实例(instance);
    },
  });
  if (executionId === 0) {
    清理时间停止实例(instance);
    return false;
  }
  return true;
}

export const 时间停止技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  类型: '阶段编排机制',
  语义: '停止前完整展示未来落点，冻结期间只布置，恢复后按固定顺序结算。',
  实现要求: '不得在冻结期间偷偷改变已展示的位置、方向或目标。',
} as const;
