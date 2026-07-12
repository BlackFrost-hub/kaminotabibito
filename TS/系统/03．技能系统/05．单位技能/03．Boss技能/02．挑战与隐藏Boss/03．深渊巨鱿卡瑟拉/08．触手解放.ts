/** @noSelfInFile */

import { type 卡瑟拉运行时上下文, 刷新卡瑟拉阶段 } from "./01．运行时上下文";
import { 卡瑟拉数值与表现配置, 卡瑟拉音效配置 } from "./02．数值与表现配置";
import { 播放卡瑟拉台词 } from "./11．台词播放";
import { 单位有效, 极坐标X, 极坐标Y } from "./14．公共工具";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const ShowUnit = jass.ShowUnit as (unit: any, show: boolean) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 临时调整护甲 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  临时调整护甲: (this: void, unit: any, value: number) => void;
};
const { 申请单位暂停占用, 释放单位暂停占用 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  申请单位暂停占用: (this: void, unit: any, source: string) => boolean;
  释放单位暂停占用: (this: void, unit: any, source: string) => boolean;
};

const 卡瑟拉触手解放暂停来源 = "Boss:Kasela:触手解放";

interface 触手解放实例 {
  context: 卡瑟拉运行时上下文;
  已结束: boolean;
  击破数量: number;
  总数量: number;
}

function 治疗Boss最大生命比例(this: void, boss: any, ratio: number): void {
  if (!单位有效(boss) || !(ratio > 0)) return;
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  const life = GetUnitState(boss, UNIT_STATE_LIFE);
  const next = life + maxLife * ratio;
  SetUnitState(boss, UNIT_STATE_LIFE, next > maxLife ? maxLife : next);
}

function 播放潜入特效(this: void, x: number, y: number): void {
  const model: string = 卡瑟拉数值与表现配置.触手解放.潜入特效路径;
  if (model === "") return;
  const effect = AddSpecialEffect(model, x, y);
  DestroyEffect(effect);
}

function 回归卡瑟拉(this: void, data: 触手解放实例, success: boolean): void {
  if (data.已结束) return;
  data.已结束 = true;
  const context = data.context;
  const boss = context.Boss单位;
  context.Boss潜入中 = false;
  if (!单位有效(boss)) return;
  ShowUnit(boss, true);
  释放单位暂停占用(boss, 卡瑟拉触手解放暂停来源);
  播放潜入特效(GetUnitX(boss), GetUnitY(boss));
  const cfg = 卡瑟拉数值与表现配置.触手解放;
  if (success) {
    播放Boss坐标音效(卡瑟拉音效配置.触手解放.成功破甲, GetUnitX(boss), GetUnitY(boss), 卡瑟拉音效配置.默认裁断距离);
    const armorDown = data.击破数量 * cfg.每条破甲比例 * 100;
    if (armorDown > 0) 临时调整护甲(boss, -armorDown);
  } else {
    播放Boss坐标音效(卡瑟拉音效配置.触手解放.失败回血, GetUnitX(boss), GetUnitY(boss), 卡瑟拉音效配置.默认裁断距离);
    治疗Boss最大生命比例(boss, cfg.失败回血比例);
  }
}

function on巨型触手死亡(this: void, data: 触手解放实例): void {
  if (data.已结束) return;
  data.击破数量 = data.击破数量 + 1;
  if (data.击破数量 >= data.总数量) 回归卡瑟拉(data, true);
}

function 创建巨型触手(this: void, data: 触手解放实例, angle: number): void {
  const context = data.context;
  const boss = context.Boss单位;
  const cfg = 卡瑟拉数值与表现配置.触手解放;
  const x = 极坐标X(GetUnitX(boss), angle, 650);
  const y = 极坐标Y(GetUnitY(boss), angle, 650);
  创建可攻击机制单位({
    清理: context.清理,
    名称: "卡瑟拉-解放巨型触手",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: "hfoo",
    模型路径: cfg.巨型触手模型路径,
    X: x,
    Y: y,
    朝向: angle + 180,
    最大生命: cfg.巨型触手生命值,
    缩放: cfg.巨型触手缩放,
    持续时间: cfg.限时秒 + 2,
    on死亡: function 卡瑟拉解放巨型触手死亡(this: void): void {
      on巨型触手死亡(data);
    },
  });
}

export function 尝试触发卡瑟拉触手解放(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  if (context.触手解放已触发 || context.Boss潜入中) return;
  if (刷新卡瑟拉阶段(context) < 3) return;
  const cfg = 卡瑟拉数值与表现配置.触手解放;
  context.触手解放已触发 = true;
  context.Boss潜入中 = true;
  播放卡瑟拉台词(boss, "触手解放");
  播放Boss坐标音效(卡瑟拉音效配置.触手解放.Boss下潜, GetUnitX(boss), GetUnitY(boss), 卡瑟拉音效配置.默认裁断距离);
  尝试播放Boss拟声池({
    标识: 卡瑟拉音效配置.怪物拟声.标识,
    音效路径列表: 卡瑟拉音效配置.怪物拟声.音效路径列表,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    裁断距离: 卡瑟拉音效配置.默认裁断距离,
    冷却Ms: 卡瑟拉音效配置.怪物拟声.冷却Ms,
    触发概率百分比: 卡瑟拉音效配置.怪物拟声.转阶段触发概率百分比,
  });
  播放潜入特效(GetUnitX(boss), GetUnitY(boss));
  ShowUnit(boss, false);
  申请单位暂停占用(boss, 卡瑟拉触手解放暂停来源);
  创建技能提示圈({
    类型: "双环",
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    半径: 720,
    持续时间: cfg.限时秒,
    来源单位: boss,
  });
  const data: 触手解放实例 = { context, 已结束: false, 击破数量: 0, 总数量: cfg.触手数量 };
  播放Boss坐标音效(卡瑟拉音效配置.触手解放.巨型触手出水, GetUnitX(boss), GetUnitY(boss), 卡瑟拉音效配置.默认裁断距离);
  for (let i = 0; i < cfg.触手数量; i++) {
    创建巨型触手(data, i * 90);
  }
  const id = addDelayedCallback(cfg.限时秒 * 1000, function 卡瑟拉触手解放限时结束(this: void): void {
    if (!data.已结束) 回归卡瑟拉(data, false);
  });
  context.清理.登记延迟回调("卡瑟拉-触手解放限时", id);
}

export function 注册卡瑟拉触手解放(this: void): void {
}
