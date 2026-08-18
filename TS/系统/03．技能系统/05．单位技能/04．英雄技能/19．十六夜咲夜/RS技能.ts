/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";
import { 两点角度, 极坐标X, 极坐标Y, 单位存活, 获取咲夜现存飞刀, 播放咲夜单位音效, 施加短硬直并播放动作, 注册咲夜周期任务, 移除咲夜周期任务, type 咲夜飞刀控制器 } from "./01．飞刀与时间工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 执行战斗自身传送到坐标 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制") as {
  执行战斗自身传送到坐标: (this: void, unit: any, x: number, y: number) => boolean;
};

interface RS监听上下文 { 占位: boolean; }
interface RS目标解停参数 { 目标: any; 来源: string; }
interface RS回收上下文 {
  施法者: any;
  飞刀: 咲夜飞刀控制器[];
  Tick: number;
  周期ID: number;
  已结束: boolean;
}

function 获取RS监听上下文(this: void, _caster: any): RS监听上下文 { return { 占位: true }; }

function 解除RS目标暂停(this: void, variable?: any): void {
  const data = variable as RS目标解停参数 | undefined;
  if (data == null) return;
  移除单位暂停(data.目标, data.来源);
  if (单位存活(data.目标)) jass.SetUnitVertexColor(data.目标, 255, 255, 255, 255);
}

function 结束RS回收(this: void, context: RS回收上下文): void {
  if (context.已结束) return;
  context.已结束 = true;
  if (context.周期ID !== 0) 移除咲夜周期任务(context.周期ID);
  context.周期ID = 0;
}

function 推进RS回收(this: void, variable?: any): void {
  const context = variable as RS回收上下文 | undefined;
  if (context == null || context.已结束) return;
  context.Tick += 1;
  let remaining = 0;
  for (let i = 0; i < context.飞刀.length; i++) {
    const knife = context.飞刀[i];
    if (!单位存活(knife.单位)) continue;
    const dx = jass.GetUnitX(knife.单位) - jass.GetUnitX(context.施法者);
    const dy = jass.GetUnitY(knife.单位) - jass.GetUnitY(context.施法者);
    if (dx * dx + dy * dy <= 配置.RS.回收距离 * 配置.RS.回收距离) {
      knife.结束();
      continue;
    }
    knife.设置角度(两点角度(jass.GetUnitX(knife.单位), jass.GetUnitY(knife.单位), jass.GetUnitX(context.施法者), jass.GetUnitY(context.施法者)));
    remaining += 1;
  }
  if (remaining <= 0 || context.Tick >= 配置.RS.最大检查Tick) 结束RS回收(context);
}

function 释放十六夜咲夜RS(this: void, _listener: RS监听上下文, caster: any, 技能实例ID?: number): void {
  const target = jass.GetSpellTargetUnit();
  if (!单位存活(target)) return;
  const targetSource = `十六夜咲夜-RS目标:${技能实例ID ?? jass.GetHandleId(caster)}`;
  添加单位暂停(target, targetSource);
  jass.SetUnitVertexColor(target, 255, 255, 255, 120);
  addDelayedCallback(配置.RS.目标暂停秒 * 1000, 解除RS目标暂停, { 目标: target, 来源: targetSource } as RS目标解停参数);

  const targetFacing = jass.GetUnitFacing(target) as number;
  const landingX = 极坐标X(jass.GetUnitX(target), 配置.RS.瞬移偏移, targetFacing + 180);
  const landingY = 极坐标Y(jass.GetUnitY(target), 配置.RS.瞬移偏移, targetFacing + 180);
  施加短硬直并播放动作(caster, `十六夜咲夜-RS:${技能实例ID ?? jass.GetHandleId(caster)}`, 配置.RS.硬直秒, "spell,slam");
  if (!执行战斗自身传送到坐标(caster, landingX, landingY)) return;
  jass.SetUnitFacing(caster, 两点角度(landingX, landingY, jass.GetUnitX(target), jass.GetUnitY(target)));
  播放咲夜单位音效("gg_snd_IzayoiSakuya_RS", caster);

  const knives = 获取咲夜现存飞刀(caster, landingX, landingY, 配置.RS.飞刀搜索半径);
  for (let i = 0; i < knives.length; i++) {
    const knife = knives[i];
    knife.设置角度(两点角度(jass.GetUnitX(knife.单位), jass.GetUnitY(knife.单位), landingX, landingY));
    knife.设置每Tick位移(knife.取每Tick位移() * 配置.RS.回收速度倍率);
    knife.设置已飞行距离(0);
    knife.设置最大距离(配置.RS.回收最大距离);
  }
  const context: RS回收上下文 = { 施法者: caster, 飞刀: knives, Tick: 0, 周期ID: 0, 已结束: false };
  context.周期ID = 注册咲夜周期任务(配置.RS.检查周期毫秒, 推进RS回收, context);
}

export function 注册十六夜咲夜RS(this: void): void {
  注册单位技能壳监听({
    名称: "十六夜咲夜-吾刃回归（RS）",
    单位类型ID: 配置.英雄单位类型ID,
    技能ID: 配置.技能.RS.类型ID,
    获取或创建上下文: 获取RS监听上下文,
    释放技能: 释放十六夜咲夜RS,
    创建独立技能实例: false,
  });
}

注册十六夜咲夜RS();

export {};
