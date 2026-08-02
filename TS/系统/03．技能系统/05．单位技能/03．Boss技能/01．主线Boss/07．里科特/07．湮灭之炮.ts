/** @noSelfInFile */

import { 里科特单位技能配置 } from "./00．配置";
import { 获取或创建里科特上下文, 刷新里科特阶段, type 里科特阶段, type 里科特运行时上下文 } from "./01．运行时上下文";
import { 里科特数值与表现配置, 里科特音效配置 } from "./02．数值与表现配置";
import { 播放里科特台词 } from "./10．台词播放";
import { 单位有效, stringToFourCC, 取坐标角度, 极坐标X, 极坐标Y, 点到线段距离平方 } from "./13．公共工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import { 启动持续施法发射, 停止持续施法发射, type 持续施法发射回调上下文 } from "../../../../00．技能模板+函数/02．通用函数/14．持续施法发射";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const RemoveUnit = jass.RemoveUnit as (whichUnit: any) => void;
const GetRandomReal = jass.GetRandomReal as (lowBound: number, highBound: number) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const { createTimedEffect, 创建点特效 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
  创建点特效: (this: void, 参数: any) => any;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 里科特BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.06．里科特") as {
  里科特BuffID: { 湮灭锁定: string };
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  施加眩晕: (this: void, source: any, target: any, duration: number) => void;
};
const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口") as {
  创建召唤物: (this: void, 参数: any) => any;
};

interface 湮灭投影 {
  context: 里科特运行时上下文;
  投影: any;
  readonly 目标: any;
}

const 里科特单位类型ID = stringToFourCC(里科特单位技能配置.单位ID);
const 湮灭之炮技能ID = stringToFourCC(里科特数值与表现配置.湮灭之炮.技能槽位);
const 蝗虫技能ID = stringToFourCC("Aloc");
let 已注册 = false;

function 启动湮灭投影施法动作(this: void, data: 湮灭投影, 持续秒: number): void {
  if (!单位有效(data.投影)) return;
  const cfg = 里科特数值与表现配置.湮灭之炮;
  启动基础施法时间线({
    名称: "里科特-湮灭投影施法",
    施法者: data.投影,
    硬直秒: cfg.施法硬直秒,
    生效延迟秒: 持续秒,
    动画编号: 8,
    动画速度: cfg.动画速度,
    后续动画编号: 9,
    后续动画速度: 1,
    后续动画延迟毫秒: cfg.施法动作原始时长秒 * 1000 / cfg.动画速度,
    恢复动画编号: 3,
    清理: data.context.清理,
    on生效: function 里科特湮灭投影施法表现结束(this: void): void {},
  });
}

function 启动湮灭之炮Boss施法动作(this: void, context: 里科特运行时上下文, 持续秒: number): void {
  const boss = context.Boss单位;
  const cfg = 里科特数值与表现配置.湮灭之炮;
  启动基础施法时间线({
    名称: "里科特-湮灭之炮施法",
    施法者: boss,
    硬直秒: cfg.施法硬直秒,
    生效延迟秒: 持续秒,
    动画编号: 8,
    动画速度: cfg.动画速度,
    后续动画编号: 9,
    后续动画速度: 1,
    后续动画延迟毫秒: cfg.施法动作原始时长秒 * 1000 / cfg.动画速度,
    恢复动画编号: 3,
    清理: context.清理,
    播放台词: function 里科特湮灭之炮台词(this: void): void {
      播放里科特台词(boss, "湮灭之炮");
    },
    on生效: function 里科特湮灭之炮施法表现结束(this: void): void {},
  });
}

function 创建湮灭投影单位(this: void, boss: any, x: number, y: number, face: number): any {
  const cfg = 里科特数值与表现配置.湮灭之炮;
  const projection = 创建召唤物({
    主人单位: boss,
    单位类型: stringToFourCC(cfg.投影单位类型),
    X: x,
    Y: y,
    朝向: face,
    飞行高度: 0,
    模型文件: cfg.投影模型路径,
    添加技能: [蝗虫技能ID],
    禁用路径: true,
    固定站桩: true,
    缩放: cfg.投影缩放,
    红: 160,
    绿: 210,
    蓝: 255,
    透明度: cfg.投影透明度,
  });
  if (projection == null || projection === 0) return projection;
  createTimedEffect(cfg.出现特效路径, x, y, 0, cfg.出现特效持续秒);
  return projection;
}

function 创建湮灭之炮预警(this: void, ctx: 持续施法发射回调上下文, boss: any): void {
  const cfg = 里科特数值与表现配置.湮灭之炮;
  创建技能提示圈({
    类型: "矩形",
    X: ctx.起点X,
    Y: ctx.起点Y,
    宽度: 180,
    长度: cfg.射程,
    朝向: ctx.当前朝向,
    持续时间: cfg.tick秒,
    来源单位: boss,
  });
}

function 创建湮灭之炮射线(this: void, ctx: 持续施法发射回调上下文, 终点X: number, 终点Y: number): void {
  const cfg = 里科特数值与表现配置.湮灭之炮;
  创建点特效({
    模型路径: cfg.射线特效路径,
    X: 终点X,
    Y: 终点Y,
    Z: 0,
    Z轴角度: ctx.当前朝向 + cfg.射线朝向偏移角度,
    持续秒: cfg.射线持续秒,
  });
}

function 结算湮灭之炮一跳(this: void, ctx: 持续施法发射回调上下文): void {
  const data = ctx.数据 as 湮灭投影;
  const boss = data.context.Boss单位;
  if (!单位有效(boss)) {
    停止持续施法发射(ctx.ID, "中断");
    return;
  }
  const cfg = 里科特数值与表现配置.湮灭之炮;
  const 终点X = 极坐标X(ctx.起点X, ctx.当前朝向, cfg.射程);
  const 终点Y = 极坐标Y(ctx.起点Y, ctx.当前朝向, cfg.射程);
  创建湮灭之炮预警(ctx, boss);
  创建湮灭之炮射线(ctx, 终点X, 终点Y);

  const heroes = 获取Boss技能敌对英雄列表(boss);
  const radius2 = 90 * 90;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const dist2 = 点到线段距离平方(GetUnitX(hero), GetUnitY(hero), ctx.起点X, ctx.起点Y, 终点X, 终点Y);
    if (dist2 <= radius2) {
      执行BossAOE技能伤害({
        技能ID: 湮灭之炮技能ID,
        来源: boss,
        目标: hero,
        伤害公式: {
          来源攻击力比例: cfg.每跳Boss攻击力比例,
        },
        attack: false,
        ranged: false,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_MAGIC,
        weaponType: WEAPON_TYPE_WHOKNOWS,
      });
    }
  }
}

function 结束湮灭投影炮击(this: void, ctx: 持续施法发射回调上下文): void {
  if (ctx.施法者 != null && ctx.施法者 !== 0) RemoveUnit(ctx.施法者);
}

function 开始湮灭投影炮击(this: void, data: 湮灭投影): void {
  const cfg = 里科特数值与表现配置.湮灭之炮;
  if (!单位有效(data.投影) || !单位有效(data.目标)) {
    if (data.投影 != null && data.投影 !== 0) RemoveUnit(data.投影);
    return;
  }
  播放Boss坐标音效(里科特音效配置.湮灭之炮.射线开火, GetUnitX(data.投影), GetUnitY(data.投影), 里科特音效配置.默认裁断距离);
  const id = 启动持续施法发射({
    清理: data.context.清理,
    名称: "里科特-湮灭之炮持续锁定",
    施法者: data.投影,
    目标单位: data.目标,
    目标失效时结束: true,
    面向模式: "持续追踪目标",
    总持续秒: cfg.锁定持续秒,
    Tick间隔毫秒: cfg.tick秒 * 1000,
    发射开始秒: cfg.tick秒,
    发射结束秒: cfg.锁定持续秒,
    发射间隔秒: cfg.tick秒,
    处理动画: false,
    硬直: false,
    数据: data,
    on发射: 结算湮灭之炮一跳,
    on结束: 结束湮灭投影炮击,
  });
  if (id === 0) RemoveUnit(data.投影);
}

function 调度单个湮灭投影(
  this: void,
  context: 里科特运行时上下文,
  阶段: 里科特阶段,
  target: any,
): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(target)) return;
  const cfg = 里科特数值与表现配置.湮灭之炮;
  const angle = 取坐标角度(GetUnitX(boss), GetUnitY(boss), GetUnitX(target), GetUnitY(target));
  const px = 极坐标X(GetUnitX(target), angle, cfg.投影距离);
  const py = 极坐标Y(GetUnitY(target), angle, cfg.投影距离);
  const face = 取坐标角度(px, py, GetUnitX(target), GetUnitY(target));
  const projection = 创建湮灭投影单位(boss, px, py, face);
  const delay = 阶段 >= 2 ? cfg.P2锁定前延迟秒 : cfg.锁定前延迟秒;
  const data: 湮灭投影 = {
    context,
    投影: projection,
    目标: target,
  };
  启动湮灭投影施法动作(data, delay + cfg.锁定持续秒);
  播放Boss坐标音效(里科特音效配置.湮灭之炮.投影锁定, px, py, 里科特音效配置.默认裁断距离);
  if (projection != null && projection !== 0) context.清理.登记单位("里科特-湮灭投影", projection);
  registerManualBuff(target, 里科特BuffID.湮灭锁定, delay + cfg.锁定持续秒, 1, { sourceName: "里科特-湮灭锁定" });
  创建技能提示圈({
    类型: "矩形",
    X: px,
    Y: py,
    宽度: 180,
    长度: cfg.射程,
    朝向: face,
    持续时间: delay,
    来源单位: boss,
  });
  const id = addDelayedCallback(delay * 1000, function 里科特湮灭投影延迟开炮(this: void): void {
    开始湮灭投影炮击(data);
  });
  context.清理.登记延迟回调("里科特-湮灭投影开炮", id);
  if (单位有效(projection)) 调度P3眩晕炮(context, 阶段, target);
}

function 调度P3眩晕炮(
  this: void,
  context: 里科特运行时上下文,
  阶段: 里科特阶段,
  target: any,
): void {
  if (阶段 < 3) return;
  const boss = context.Boss单位;
  const cfg = 里科特数值与表现配置.湮灭之炮;
  const randomDelay = GetRandomReal(0, cfg.P3眩晕炮随机延迟最大秒);
  const warningId = addDelayedCallback(randomDelay * 1000, function 里科特P3湮灭眩晕炮开始预警(this: void): void {
    if (!单位有效(boss) || !单位有效(target)) return;
    const cx = GetUnitX(target);
    const cy = GetUnitY(target);
    创建技能提示圈({
      类型: "圆形",
      X: cx,
      Y: cy,
      半径: cfg.P3眩晕炮半径,
      持续时间: cfg.P3眩晕炮延迟秒,
      来源单位: boss,
    });
    const resolveId = addDelayedCallback(cfg.P3眩晕炮延迟秒 * 1000, function 里科特P3湮灭眩晕炮结算(this: void): void {
      if (!单位有效(boss)) return;
      const heroes = 获取Boss技能敌对英雄列表(boss);
      const radius2 = cfg.P3眩晕炮半径 * cfg.P3眩晕炮半径;
      for (let i = 0; i < heroes.length; i++) {
        const hero = heroes[i];
        if (!单位有效(hero)) continue;
        const dx = GetUnitX(hero) - cx;
        const dy = GetUnitY(hero) - cy;
        if (dx * dx + dy * dy <= radius2) 施加眩晕(boss, hero, cfg.P3眩晕秒);
      }
    });
    context.清理.登记延迟回调("里科特-P3湮灭眩晕炮结算", resolveId);
  });
  context.清理.登记延迟回调("里科特-P3湮灭眩晕炮预警", warningId);
}

export function 释放里科特湮灭之炮(this: void, context: 里科特运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 里科特数值与表现配置.湮灭之炮;
  const 阶段 = 刷新里科特阶段(context);
  const castDuration = 阶段 >= 2 ? cfg.P2锁定前延迟秒 : cfg.锁定前延迟秒;
  启动湮灭之炮Boss施法动作(context, castDuration);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    调度单个湮灭投影(context, 阶段, heroes[i]);
  }
}

function on里科特湮灭之炮施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 湮灭之炮技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 里科特单位类型ID) return;
  const context = 获取或创建里科特上下文(castingUnit);
  if (context == null) return;
  释放里科特湮灭之炮(context);
}

export function 注册里科特湮灭之炮(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "07．湮灭之炮",
    单位类型ID: 里科特单位类型ID,
    技能ID: 湮灭之炮技能ID,
    获取或创建上下文: 获取或创建里科特上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 里科特运行时上下文, boss: any): void {
      on里科特湮灭之炮施法(boss, 湮灭之炮技能ID);
    },
  });
}
