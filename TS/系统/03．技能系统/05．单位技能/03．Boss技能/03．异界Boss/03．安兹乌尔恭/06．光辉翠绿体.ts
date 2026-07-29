/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 安兹运行时上下文 } from './01．运行时上下文';
import { 获取或创建安兹运行时上下文, 标记安兹普通机制忙碌 } from './01．运行时上下文';
import { 安兹乌尔恭单位技能配置 } from './00．配置';
import { 安兹模型动画配置, 安兹乌尔恭数值与表现配置 } from './02．数值与表现配置';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';
import { 创建次数型伤害免疫 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/08．次数型伤害免疫';
import { 开始击退 } from '../../../../00．技能模板+函数/01．技能函数/02．冲锋·击退/击退系统';
import { stringToFourCC } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 播放安兹台词 } from './12．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';

const { 启动基础施法时间线 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线') as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 创建单位坐标跟随特效, 销毁单位坐标跟随特效, 设置特效颜色 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number, animSpeed?: number) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
  设置特效颜色: (this: void, effect: any, red: number, green: number, blue: number, alpha?: number) => void;
};

const jass = require('jass.common') as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const 安兹单位类型ID = stringToFourCC(安兹乌尔恭单位技能配置.正式单位ID);
const 光辉翠绿体技能ID = stringToFourCC(安兹乌尔恭单位技能配置.技能壳.光辉翠绿体);
let 光辉翠绿体已注册 = false;
const 光辉翠绿体特效键 = '安兹·光辉翠绿体';

function 释放翠绿冲击(this: void, boss: any): void {
  if (!单位有效(boss)) return;
  const config = 安兹乌尔恭数值与表现配置.普通技能;
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  const radius2 = config.光辉翠绿体击退半径 * config.光辉翠绿体击退半径;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const dx = GetUnitX(hero) - x;
    const dy = GetUnitY(hero) - y;
    if (dx * dx + dy * dy > radius2) continue;
    开始击退(hero, {
      来源单位: boss,
      距离: config.光辉翠绿体击退距离,
      持续时间: config.光辉翠绿体击退持续秒,
      检查地形: true,
      暂停单位: true,
      禁用碰撞: true,
      主单位死亡时中断: false,
    });
  }
}

function 创建翠绿防护(this: void, context: 安兹运行时上下文): void {
  const boss = context.安兹单位;
  if (!单位有效(boss)) return;
  const config = 安兹乌尔恭数值与表现配置;
  const effect = 创建单位坐标跟随特效(
    boss,
    config.表现资源.光辉翠绿体特效路径,
    光辉翠绿体特效键,
    config.普通技能.光辉翠绿体特效缩放,
    config.普通技能.光辉翠绿体特效高度,
  );
  设置特效颜色(
    effect,
    config.普通技能.光辉翠绿体特效红,
    config.普通技能.光辉翠绿体特效绿,
    config.普通技能.光辉翠绿体特效蓝,
  );
  let effectDestroyed = false;
  function 销毁翠绿防护特效(this: void): void {
    if (effectDestroyed) return;
    effectDestroyed = true;
    销毁单位坐标跟随特效(boss, 光辉翠绿体特效键);
  }
  创建次数型伤害免疫({
    名称: '安兹·光辉翠绿体',
    单位: boss,
    免疫类型: '物理伤害',
    免疫次数: 1,
    持续秒: config.普通技能.光辉翠绿体持续秒,
    最低伤害占最大生命比例: config.普通技能.光辉翠绿体最低伤害最大生命比例,
    清理: context.清理,
    过滤伤害: function 光辉翠绿体过滤伤害(this: void, damageContext: any): boolean {
      return damageContext.isDotDamage !== true
        && damageContext.isReflectDamage !== true
        && damageContext.isTransferredDamage !== true
        && damageContext.isDamageTransfer !== true;
    },
    on抵挡: function 光辉翠绿体抵挡(this: void): void {
      销毁翠绿防护特效();
      释放翠绿冲击(boss);
    },
    on结束: function 光辉翠绿体结束(this: void, _unit: any, 原因: any): void {
      销毁翠绿防护特效();
      if (原因 === '到期') 释放翠绿冲击(boss);
    },
  });
}

export function 释放安兹光辉翠绿体(this: void, context: 安兹运行时上下文): void {
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束 || context.当前大型技能 != null) return;
  播放安兹台词(boss, '光辉翠绿体');
  播放Boss坐标音效(安兹乌尔恭数值与表现配置.音效.光辉翠绿体, GetUnitX(boss), GetUnitY(boss), 安兹乌尔恭数值与表现配置.音效默认裁断距离);
  const config = 安兹乌尔恭数值与表现配置.普通技能;
  标记安兹普通机制忙碌(context, config.光辉翠绿体施法硬直秒 + config.光辉翠绿体持续秒);
  启动基础施法时间线({
    施法者: boss,
    硬直秒: config.光辉翠绿体施法硬直秒,
    动画编号: config.光辉翠绿体动画编号,
    动画速度: config.光辉翠绿体动画速度,
    恢复动画编号: 安兹模型动画配置.待机编号,
    吟唱条: {
      通道: '常规技能',
      总时长: config.光辉翠绿体施法硬直秒,
      颜色ID: 3,
      标题文本: '光辉翠绿体',
      提示文本: '下一次直接物理攻击将被完全抵挡',
    },
    on生效: function 光辉翠绿体生效(this: void): void {
      创建翠绿防护(context);
    },
  });
}

export function 注册安兹光辉翠绿体(this: void): void {
  if (光辉翠绿体已注册) return;
  光辉翠绿体已注册 = true;
  注册单位技能壳监听({
    名称: '安兹·光辉翠绿体',
    单位类型ID: 安兹单位类型ID,
    技能ID: 光辉翠绿体技能ID,
    获取或创建上下文: 获取或创建安兹运行时上下文,
    释放技能: function 光辉翠绿体技能监听(this: void, context: 安兹运行时上下文): void {
      释放安兹光辉翠绿体(context);
    },
  });
}

export const 光辉翠绿体技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: '无直接伤害',
  包含战斗自身位移: false,
  语义: '无效化下一次达到条件的直接物理伤害；DOT、反伤和极小伤害不消耗防护。',
} as const;
