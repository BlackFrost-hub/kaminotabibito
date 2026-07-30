/** @noSelfInFile */

import { 影骨莫特斯单位技能配置 } from "./00．配置";
import { 获取或创建影骨莫特斯上下文, 刷新影骨盗贼遗产Buff, type 影骨莫特斯运行时上下文 } from "./01．运行时上下文";
import { 影骨莫特斯数值与表现配置, 影骨莫特斯表现配置, 影骨莫特斯音效配置 } from "./02．数值与表现配置";
import { 播放影骨莫特斯台词 } from "./08．台词播放";
import { 单位有效, 播放影骨莫特斯限时动作, 开始影骨莫特斯常规施法, stringToFourCC } from "./11．公共工具";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 创建固定组合技能执行器 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器";
import { 创建固定时间轴阶段列表, type 固定时间轴事件 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂";
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;

const { 创建交互宝箱 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.12．交互宝箱桥接") as {
  创建交互宝箱: (this: void, 参数: any) => any;
};
const { 临时调整攻击 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const 影骨单位类型ID = stringToFourCC(影骨莫特斯单位技能配置.单位ID);
const 盗贼遗产技能ID = stringToFourCC(影骨莫特斯单位技能配置.技能壳.盗贼的遗产);
let 已注册盗贼遗产 = false;

interface 影骨遗产宝箱变量 {
  context: 影骨莫特斯运行时上下文;
  X: number;
  Y: number;
}

function 给Boss叠加盗贼遗产(this: void, context: 影骨莫特斯运行时上下文): void {
  context.已开启遗产宝箱数 += 1;
  const bonus = 读取单位攻击力(context.Boss单位) * 影骨莫特斯数值与表现配置.盗贼的遗产.每个宝箱Boss攻击提高;
  临时调整攻击(context.Boss单位, bonus);
  刷新影骨盗贼遗产Buff(context);
}

function 开启影骨宝箱(this: void, context: 影骨莫特斯运行时上下文, x: number, y: number): void {
  给Boss叠加盗贼遗产(context);
  创建点特效({ 模型路径: 影骨莫特斯表现配置.宝箱出现, X: x, Y: y, 持续秒: 影骨莫特斯数值与表现配置.盗贼的遗产.瞬时特效持续秒 });
  播放Boss坐标音效(影骨莫特斯音效配置.盗贼的遗产.增益回流, GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), 影骨莫特斯音效配置.默认裁断距离);
}

function 影骨遗产宝箱开启中(this: void, opener: any, _chest: any, _elapsed: number, _config: any, variable: 影骨遗产宝箱变量): void {
  if (variable == null || !单位有效(opener)) return;
  const context = variable.context;
  if (单位有效(context.Boss单位)) IssueTargetOrder(context.Boss单位, "attack", opener);
  for (let i = 0; i < context.幽影召唤物.length; i++) {
    const summon = context.幽影召唤物[i];
    if (单位有效(summon)) IssueTargetOrder(summon, "attack", opener);
  }
}

function 影骨遗产宝箱开启完成(this: void, opener: any, _chest: any, _config: any, variable: 影骨遗产宝箱变量): void {
  if (variable == null || !单位有效(opener)) return;
  开启影骨宝箱(variable.context, variable.X, variable.Y);
}

function 创建影骨宝箱(this: void, context: 影骨莫特斯运行时上下文, index: number): void {
  const point = 影骨莫特斯数值与表现配置.盗贼的遗产.宝箱点[index];
  if (point == null) return;
  创建点特效({ 模型路径: 影骨莫特斯表现配置.宝箱出现, X: point.X, Y: point.Y, 持续秒: 影骨莫特斯数值与表现配置.盗贼的遗产.瞬时特效持续秒 });
  播放Boss坐标音效(影骨莫特斯音效配置.盗贼的遗产.宝箱出现, point.X, point.Y, 影骨莫特斯音效配置.默认裁断距离);
  创建交互宝箱({
    清理: context.清理,
    名称: "影骨-盗贼遗产宝箱",
    可破坏物ID: 影骨莫特斯数值与表现配置.盗贼的遗产.宝箱可破坏物ID,
    X: point.X,
    Y: point.Y,
    朝向: point.朝向,
    变量: { context, X: point.X, Y: point.Y } as 影骨遗产宝箱变量,
    on开启中: 影骨遗产宝箱开启中,
    on开启完成: 影骨遗产宝箱开启完成,
  });
}

function 追加遗产宝箱生成时间轴(this: void, 事件列表: 固定时间轴事件[], context: 影骨莫特斯运行时上下文, index: number): void {
  事件列表.push({
    时点毫秒: index * 500,
    名称: "盗贼遗产第" + String(index + 1) + "个宝箱",
    执行: function 影骨遗产宝箱生成(this: void): void {
      创建影骨宝箱(context, index);
    },
  });
}

export function 释放影骨盗贼遗产(this: void, context: 影骨莫特斯运行时上下文): void {
  if (context.遗产宝箱已生成) return;
  const cfg = 影骨莫特斯数值与表现配置.盗贼的遗产;
  const count = cfg.宝箱数量;
  if (count <= 0) return;
  if (context.盗贼遗产组合执行器 == null) {
    context.盗贼遗产组合执行器 = 创建固定组合技能执行器<影骨莫特斯运行时上下文>({
      名称: "影骨莫特斯-盗贼遗产",
      清理: context.清理,
      互斥组: "影骨莫特斯盗贼遗产",
    });
  }
  if (context.盗贼遗产组合执行器.是否运行中()) return;
  const 事件列表: 固定时间轴事件[] = [];
  for (let i = 0; i < count; i++) 追加遗产宝箱生成时间轴(事件列表, context, i);
  context.遗产宝箱已生成 = true;
  开始影骨莫特斯常规施法(context.Boss单位, cfg.动画播放秒, "盗贼的遗产", "遗产宝箱正在依次出现");
  播放影骨莫特斯限时动作(context.Boss单位, cfg.动画编号, cfg.动画速度, cfg.动画播放秒);
  播放影骨莫特斯台词(context.Boss单位, "盗贼的遗产");
  const 执行ID = context.盗贼遗产组合执行器.开始({
    key: "盗贼的遗产",
    单位: context.Boss单位,
    上下文: context,
    最大持续毫秒: count * 500 + 500,
    阶段列表: 创建固定时间轴阶段列表(事件列表),
  });
  if (执行ID === 0) context.遗产宝箱已生成 = false;
}

function on影骨盗贼遗产施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 盗贼遗产技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 影骨单位类型ID) return;
  const context = 获取或创建影骨莫特斯上下文(castingUnit);
  if (context != null) 释放影骨盗贼遗产(context);
}

export function 注册影骨莫特斯盗贼的遗产(this: void): void {
  if (已注册盗贼遗产) return;
  已注册盗贼遗产 = true;
  注册单位技能壳监听({
    名称: "07．盗贼的遗产",
    单位类型ID: 影骨单位类型ID,
    技能ID: 盗贼遗产技能ID,
    获取或创建上下文: 获取或创建影骨莫特斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 影骨莫特斯运行时上下文, boss: any): void {
      on影骨盗贼遗产施法(boss, 盗贼遗产技能ID);
    },
  });
}
