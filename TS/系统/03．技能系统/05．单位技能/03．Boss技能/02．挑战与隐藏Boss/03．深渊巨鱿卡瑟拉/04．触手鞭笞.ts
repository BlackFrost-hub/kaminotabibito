/** @noSelfInFile */

import { 卡瑟拉单位技能配置 } from "./00．配置";
import { 获取或创建卡瑟拉上下文, 增加玩家触手残片, 取玩家触手残片, type 卡瑟拉运行时上下文 } from "./01．运行时上下文";
import { 卡瑟拉数值与表现配置, 卡瑟拉音效配置 } from "./02．数值与表现配置";
import { 播放卡瑟拉台词 } from "./11．台词播放";
import { 单位有效, stringToFourCC, 极坐标X, 极坐标Y } from "./14．公共工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 创建限次周期执行器, type 限次周期执行器实例 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/22．限次周期执行器";
import { 执行Boss单体技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRandomReal = jass.GetRandomReal as (lowBound: number, highBound: number) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对英雄列表, 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  获取Boss技能随机敌对英雄: (this: void, boss: any, centerUnit?: any, radius?: number) => any;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 卡瑟拉BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.02．卡瑟拉") as {
  卡瑟拉BuffID: { 触手缠绕: string };
};
const { 施加快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number) => void;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};

interface 触手鞭笞实例 {
  context: 卡瑟拉运行时上下文;
  触手单位: any;
  目标: any;
  周期?: 限次周期执行器实例;
}

const 卡瑟拉单位类型ID = stringToFourCC(卡瑟拉单位技能配置.单位ID);
const 触手鞭笞技能ID = stringToFourCC(卡瑟拉数值与表现配置.触手鞭笞.技能槽位);
let 已注册 = false;

function 选择触手鞭笞目标(this: void, context: 卡瑟拉运行时上下文): any {
  const boss = context.Boss单位;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  let best: any = undefined;
  let bestScore = -1;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const score = 取玩家触手残片(context, hero) * 10 + GetRandomReal(0, 10);
    if (score > bestScore) {
      bestScore = score;
      best = hero;
    }
  }
  return 单位有效(best) ? best : 获取Boss技能随机敌对英雄(boss, boss, 2000);
}

function 掉落触手残片给击杀者(this: void, context: 卡瑟拉运行时上下文, killer: any): void {
  if (!单位有效(killer)) return;
  const cfg = 卡瑟拉数值与表现配置.触手鞭笞;
  if (GetRandomReal(0, 1) > cfg.触手残片掉落概率) return;
  const next = 增加玩家触手残片(context, killer, 1);
  if (next > 卡瑟拉数值与表现配置.触手残片.大于数量时恢复已损生命) {
    const maxLife = GetUnitStateJapi(killer, UNIT_STATE_MAX_LIFE);
    const life = GetUnitState(killer, UNIT_STATE_LIFE);
    const heal = (maxLife - life) * 卡瑟拉数值与表现配置.触手残片.已损生命恢复比例;
    if (heal > 0) doHeal({ HealSource: killer, HealTarget: killer, HealAmount: heal, ItemHeal: false, HealEffect: false });
  }
}

function 触手鞭笞一跳(this: void, data: 触手鞭笞实例): boolean {
  const context = data.context;
  const boss = context.Boss单位;
  const target = data.目标;
  if (!单位有效(boss) || !单位有效(data.触手单位) || !单位有效(target)) return false;
  const cfg = 卡瑟拉数值与表现配置.触手鞭笞;
  const dx = GetUnitX(target) - GetUnitX(data.触手单位);
  const dy = GetUnitY(target) - GetUnitY(data.触手单位);
  if (dx * dx + dy * dy > cfg.触手攻击半径 * cfg.触手攻击半径) return true;
  执行Boss单体技能伤害({
    技能ID: 触手鞭笞技能ID,
    来源: boss,
    目标: target,
    伤害公式: { 来源攻击力比例: cfg.触手Boss攻击力比例 },
    attack: true,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: "卡瑟拉触手鞭笞",
  });
  施加快速减速Buff(boss, target, cfg.缠绕减速比例, cfg.缠绕减速比例, cfg.缠绕持续秒);
  registerManualBuff(target, 卡瑟拉BuffID.触手缠绕, cfg.缠绕持续秒, cfg.缠绕减速比例, {
    sourceName: "卡瑟拉-触手缠绕",
  });
  return true;
}

function 创建单条触手(this: void, context: 卡瑟拉运行时上下文, target: any, x: number, y: number): void {
  const boss = context.Boss单位;
  const cfg = 卡瑟拉数值与表现配置.触手鞭笞;
  const instance = 创建可攻击机制单位({
    清理: context.清理,
    名称: "卡瑟拉-鞭笞触手",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: "hfoo",
    模型路径: cfg.触手模型路径,
    X: x,
    Y: y,
    朝向: 0,
    最大生命: cfg.触手生命值,
    攻击范围: cfg.触手攻击半径,
    固定站桩: true,
    缩放: cfg.触手缩放,
    持续时间: cfg.触手持续秒,
    on死亡: function 卡瑟拉鞭笞触手死亡(this: void, _unit: any, killer: any): void {
      掉落触手残片给击杀者(context, killer);
    },
  });
  if (instance == null || !单位有效(instance.单位)) return;
  const data: 触手鞭笞实例 = {
    context,
    触手单位: instance.单位,
    目标: target,
  };
  data.周期 = 创建限次周期执行器<触手鞭笞实例>({
    名称: "卡瑟拉-触手鞭笞周期",
    间隔毫秒: cfg.触手攻击间隔秒 * 1000,
    最大执行次数: cfg.触手持续秒 / cfg.触手攻击间隔秒,
    变量: data,
    清理: context.清理,
    onTick: function 卡瑟拉触手鞭笞周期(this: void, _执行次数: number, variable?: 触手鞭笞实例): boolean {
      return variable != null && 触手鞭笞一跳(variable);
    },
  });
}

function 播放触手出现特效(this: void, context: 卡瑟拉运行时上下文, x: number, y: number): void {
  const cfg = 卡瑟拉数值与表现配置.触手鞭笞;
  const effect = 创建点特效({
    模型路径: cfg.触手出现特效模型路径,
    X: x,
    Y: y,
    缩放: cfg.触手出现特效缩放,
  });
  context.清理.登记限时特效("卡瑟拉-触手鞭笞出现特效", effect, cfg.触手出现特效持续秒 * 1000);
}

function 释放触手围攻(this: void, context: 卡瑟拉运行时上下文, target: any): void {
  const cfg = 卡瑟拉数值与表现配置.触手鞭笞;
  const cx = GetUnitX(target);
  const cy = GetUnitY(target);
  播放Boss坐标音效(卡瑟拉音效配置.触手鞭笞.小触手出现, cx, cy, 卡瑟拉音效配置.默认裁断距离);
  播放触手出现特效(context, cx, cy);
  for (let i = 0; i < cfg.触手数量; i++) {
    const angle = i * 120;
    创建单条触手(context, target, 极坐标X(cx, angle, cfg.触手半径), 极坐标Y(cy, angle, cfg.触手半径));
  }
}

export function 释放卡瑟拉触手鞭笞(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const target = 选择触手鞭笞目标(context);
  if (!单位有效(target)) return;
  const cfg = 卡瑟拉数值与表现配置.触手鞭笞;
  创建技能提示圈({
    类型: "圆形",
    X: GetUnitX(target),
    Y: GetUnitY(target),
    半径: cfg.触手半径 + 120,
    持续时间: cfg.延迟秒,
    来源单位: boss,
  });
  启动基础施法时间线({
    名称: "卡瑟拉-触手鞭笞",
    施法者: boss,
    目标单位: target,
    目标失效时取消: true,
    硬直秒: cfg.硬直秒,
    生效延迟秒: cfg.延迟秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    恢复动画编号: 5,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.延迟秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    清理: context.清理,
    播放台词: function 卡瑟拉触手鞭笞台词(this: void): void {
      播放卡瑟拉台词(boss, "触手鞭笞");
    },
    on生效: function 卡瑟拉触手鞭笞生效(this: void): void {
      释放触手围攻(context, target);
    },
  });
}

function on卡瑟拉触手鞭笞施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 触手鞭笞技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 卡瑟拉单位类型ID) return;
  const context = 获取或创建卡瑟拉上下文(castingUnit);
  if (context == null) return;
  释放卡瑟拉触手鞭笞(context);
}

export function 注册卡瑟拉触手鞭笞(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "04．触手鞭笞",
    单位类型ID: 卡瑟拉单位类型ID,
    技能ID: 触手鞭笞技能ID,
    获取或创建上下文: 获取或创建卡瑟拉上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 卡瑟拉运行时上下文, boss: any): void {
      on卡瑟拉触手鞭笞施法(boss, 触手鞭笞技能ID);
    },
  });
}
