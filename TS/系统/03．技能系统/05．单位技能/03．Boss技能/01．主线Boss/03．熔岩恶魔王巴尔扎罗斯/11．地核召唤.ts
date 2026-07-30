/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "./03．运行时上下文";
import { 巴尔扎罗斯技能数值配置, 巴尔扎罗斯音效配置 } from "./02．数值与表现配置";
import { 播放巴尔扎罗斯台词 } from "./14．台词播放";
import { 施加巴尔扎罗斯灼热 } from "./16．灼热层数工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { stringToFourCC, 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.index") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 创建血量节点触发器 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.index") as {
  创建血量节点触发器: (this: void, 参数: any) => any;
};
const { 创建Boss战场地点位集 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.02．战斗区域.03．Boss战场地点位") as {
  创建Boss战场地点位集: (this: void, 区域组: any, 回退X: number, 回退Y: number) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const CreateItem = jass.CreateItem as (itemId: number, x: number, y: number) => any;
const Player = jass.Player as (id: number) => any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const EXSetEffectZ = japi.EXSetEffectZ as ((effect: any, z: number) => void) | undefined;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;

interface 地核状态 {
  context: 巴尔扎罗斯运行时上下文;
  coreUnit: any;
  tickId: number;
  stopped: boolean;
}

function 取场地中心(this: void, context: 巴尔扎罗斯运行时上下文): { X: number; Y: number } {
  const boss = context.Boss单位;
  const points = 创建Boss战场地点位集(context.战斗区域组, GetUnitX(boss), GetUnitY(boss));
  const center = points.取中心();
  return { X: center.X, Y: center.Y };
}

function 播放地核Tick特效(this: void, x: number, y: number): void {
  const config = 巴尔扎罗斯技能数值配置.地核召唤;
  const effects = [
    { 路径: config.Tick冲击波路径, 缩放: config.Tick冲击波特效缩放 },
    { 路径: config.Tick叠加冲击波路径, 缩放: config.Tick叠加冲击波特效缩放 },
  ];
  for (let i = 0; i < effects.length; i++) {
    const effect = effects[i];
    创建点特效({
      模型路径: effect.路径, X: x, Y: y, Z: config.Tick特效高度,
      缩放: effect.缩放, 持续秒: config.Tick特效持续秒,
    });
  }
}

function 地核叠加全场灼热(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (单位有效(hero)) 施加巴尔扎罗斯灼热(hero, 巴尔扎罗斯技能数值配置.地核召唤.Tick灼热层数);
  }
}

function 掉落冷却水晶(this: void, x: number, y: number): void {
  const itemId = stringToFourCC(巴尔扎罗斯技能数值配置.地核召唤.冷却水晶物品ID);
  if (itemId <= 0) return;
  CreateItem(itemId, x, y);
}

function 停止地核(this: void, state: 地核状态): void {
  if (state.stopped) return;
  state.stopped = true;
  if (state.tickId !== 0) {
    removePeriodicCallback(state.tickId);
    state.tickId = 0;
  }
}

function on地核Tick(this: void, state: 地核状态): void {
  if (state.stopped) return;
  const core = state.coreUnit;
  if (!单位有效(core)) {
    停止地核(state);
    return;
  }
  播放地核Tick特效(GetUnitX(core), GetUnitY(core));
  地核叠加全场灼热(state.context);
}

function 创建地核单位(this: void, context: 巴尔扎罗斯运行时上下文, x: number, y: number): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const config = 巴尔扎罗斯技能数值配置.地核召唤;
  const maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE);
  const state: 地核状态 = { context, coreUnit: undefined, tickId: 0, stopped: false };
  const core = 创建可攻击机制单位({
    清理: context.清理,
    名称: "巴尔扎罗斯-不稳定地核",
    主人单位: boss,
    所属玩家: Player(PLAYER_NEUTRAL_AGGRESSIVE),
    单位类型: config.地核单位ID,
    单位名称: config.地核单位名称,
    模型路径: config.地核模型路径,
    X: x,
    Y: y,
    最大生命: maxLife * config.地核生命Boss最大生命比例,
    生命值受小怪倍率: false,
    飞行高度: config.地核飞行高度,
    缩放: config.地核缩放,
    on死亡: function 巴尔扎罗斯地核死亡(this: void, 单位: any): void {
      停止地核(state);
      掉落冷却水晶(GetUnitX(单位), GetUnitY(单位));
    },
  });
  if (core == null || !单位有效(core.单位)) return;
  state.coreUnit = core.单位;
  播放Boss坐标音效(巴尔扎罗斯音效配置.地核召唤.地核出现, x, y, 巴尔扎罗斯音效配置.默认裁断距离);
  state.tickId = addPeriodicCallback(config.Tick秒 * 1000, function 巴尔扎罗斯地核Tick(this: void): void {
    on地核Tick(state);
  });
  context.清理.登记周期回调("巴尔扎罗斯-地核Tick", state.tickId);
}

export function 释放巴尔扎罗斯地核召唤(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const config = 巴尔扎罗斯技能数值配置.地核召唤;
  const center = 取场地中心(context);
  创建技能提示圈({
    类型: "渐变圆形",
    X: center.X,
    Y: center.Y,
    半径: config.预警半径,
    持续时间: config.施法硬直秒,
    来源单位: boss,
  });
  启动基础施法时间线({
    施法者: boss,
    目标X: center.X,
    目标Y: center.Y,
    硬直秒: config.施法硬直秒,
    动画编号: config.动画编号,
    动画速度: config.动画速度,
    吟唱条: {
      通道: "大招",
      总时长: config.施法硬直秒,
      颜色ID: config.吟唱条颜色ID,
      标题文本: config.吟唱条标题文本,
      提示文本: config.吟唱条提示文本,
    },
    播放台词: function 巴尔扎罗斯地核召唤台词(this: void): void {
      播放巴尔扎罗斯台词(boss, "地核召唤");
    },
    on生效: function 巴尔扎罗斯地核召唤生效(this: void): void {
      创建地核单位(context, center.X, center.Y);
    },
  });
}

export function 初始化巴尔扎罗斯地核召唤节点(this: void, context: 巴尔扎罗斯运行时上下文): void {
  if (context.地核召唤节点已初始化) return;
  context.地核召唤节点已初始化 = true;
  const config = 巴尔扎罗斯技能数值配置.地核召唤;
  创建血量节点触发器({
    清理: context.清理,
    名称: "巴尔扎罗斯-地核召唤血量节点",
    单位: context.Boss单位,
    节点列表: [
      {
        ID: "地核召唤-70",
        百分比: config.触发生命比例[0],
        on触发: function 巴尔扎罗斯地核召唤70(this: void): void {
          释放巴尔扎罗斯地核召唤(context);
        },
      },
      {
        ID: "地核召唤-40",
        百分比: config.触发生命比例[1],
        on触发: function 巴尔扎罗斯地核召唤40(this: void): void {
          释放巴尔扎罗斯地核召唤(context);
        },
      },
    ],
  });
}

export function 注册巴尔扎罗斯地核召唤(this: void): void {
  // 代码侧血量节点触发；真正绑定在巴尔扎罗斯运行时上下文创建后完成。
}

export {};
