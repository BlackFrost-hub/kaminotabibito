/** @noSelfInFile */

import { 卡瑟拉单位技能配置 } from "./00．配置";
import { 获取或创建卡瑟拉上下文, type 卡瑟拉运行时上下文 } from "./01．运行时上下文";
import { 卡瑟拉数值与表现配置, 卡瑟拉音效配置 } from "./02．数值与表现配置";
import { 播放卡瑟拉台词 } from "./11．台词播放";
import { 单位有效, stringToFourCC, 取单位间角度, 取坐标角度, 距离平方XY, 角度差, 极坐标X, 极坐标Y } from "./14．公共工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import {
  创建二阶贝塞尔XYZ轨迹,
  创建原生弹幕,
} from "../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕/index";
import { 创建限次周期执行器, type 限次周期执行器实例 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/22．限次周期执行器";
import { 提交预计算BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetRandomReal = jass.GetRandomReal as (lowBound: number, highBound: number) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};

const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对英雄列表, 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  获取Boss技能随机敌对英雄: (this: void, boss: any, centerUnit?: any, radius?: number) => any;
};
const { 满足属性抗性门槛 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.13．属性抗性门槛") as {
  满足属性抗性门槛: (this: void, unit: any, type: string, threshold: number, applyLimit?: boolean) => boolean;
};
const { 施加战斗视野压制 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.10．战斗视野压制") as {
  施加战斗视野压制: (this: void, 参数: any) => void;
};
const { 施加快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速控制Buff: (this: void, source: any, target: any, controlType: number, duration: number) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 卡瑟拉BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.02．卡瑟拉") as {
  卡瑟拉BuffID: { 墨汁遮蔽: string };
};

interface 墨汁区域 {
  context: 卡瑟拉运行时上下文;
  起点X: number;
  起点Y: number;
  方向角: number;
  剩余跳数: number;
  周期?: 限次周期执行器实例;
  是否喷吐阶段: boolean;
  地面残留X: number;
  地面残留Y: number;
}

const 卡瑟拉单位类型ID = stringToFourCC(卡瑟拉单位技能配置.单位ID);
const 墨汁喷吐技能ID = stringToFourCC(卡瑟拉数值与表现配置.墨汁喷吐.技能槽位);
let 已注册 = false;

function 取墨汁喷吐目标(this: void, boss: any): any {
  const spellTarget = GetSpellTargetUnit();
  if (单位有效(spellTarget)) return spellTarget;
  return 获取Boss技能随机敌对英雄(boss, boss, 1400);
}

function 播放墨汁地面特效(this: void, context: 卡瑟拉运行时上下文, x: number, y: number): void {
  const cfg = 卡瑟拉数值与表现配置.墨汁喷吐;
  const model: string = cfg.墨汁残留模型路径;
  if (model === "") return;
  const effect = 创建点特效({ 模型路径: model, X: x, Y: y });
  context.清理.登记限时特效("卡瑟拉-墨汁地面残留", effect, cfg.残留秒 * 1000);
}

function 单位在墨汁区域内(this: void, unit: any, area: 墨汁区域): boolean {
  const cfg = 卡瑟拉数值与表现配置.墨汁喷吐;
  const ux = GetUnitX(unit);
  const uy = GetUnitY(unit);
  if (!area.是否喷吐阶段) {
    const 残留半径平方 = cfg.残留半径 * cfg.残留半径;
    return 距离平方XY(ux, uy, area.地面残留X, area.地面残留Y) <= 残留半径平方;
  }
  const 扇形半径平方 = cfg.扇形半径 * cfg.扇形半径;
  if (距离平方XY(ux, uy, area.起点X, area.起点Y) > 扇形半径平方) return false;
  const angle = 取坐标角度(area.起点X, area.起点Y, ux, uy);
  return 角度差(angle, area.方向角) <= cfg.扇形角度 * 0.5;
}

function 发射墨汁贝塞尔喷吐(this: void, context: 卡瑟拉运行时上下文, originX: number, originY: number, baseAngle: number): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 卡瑟拉数值与表现配置.墨汁喷吐;
  const model: string = cfg.墨汁抛射模型路径;
  if (model === "") return;

  const shotAngle = baseAngle + GetRandomReal(-cfg.扇形角度 * 0.35, cfg.扇形角度 * 0.35);
  const startX = originX;
  const startY = originY;
  const startZ = GetUnitFlyHeight(boss) + cfg.喷吐起点高度;
  const endDist = cfg.扇形半径 * GetRandomReal(0.55, 0.95);
  const endX = 极坐标X(originX, shotAngle, endDist);
  const endY = 极坐标Y(originY, shotAngle, endDist);
  const endZ = cfg.喷吐终点高度;
  const midX = (startX + endX) * 0.5;
  const midY = (startY + endY) * 0.5;
  const sideBend = GetRandomReal(-cfg.喷吐侧弯距离, cfg.喷吐侧弯距离);
  const controlX = 极坐标X(midX, shotAngle + 90, sideBend);
  const controlY = 极坐标Y(midY, shotAngle + 90, sideBend);
  const controlZ = cfg.喷吐控制高度;

  创建原生弹幕({
    所有者: boss,
    载体模式: "特效",
    X: startX,
    Y: startY,
    方向角: shotAngle,
    速度: 0,
    生命周期: cfg.喷吐飞行秒,
    命中半径: 0,
    碰撞消失: false,
    禁用碰撞: true,
    不可阻挡: true,
    飞行高度: startZ,
    附加特效1: {
      模型: model,
      跟随轨迹俯仰: true,
      缩放: cfg.喷吐弹幕缩放 * 3,  // 扩大300%
    },
    轨迹采样器: 创建二阶贝塞尔XYZ轨迹(
      startX, startY, startZ,
      controlX, controlY, controlZ,
      endX, endY, endZ,
    ),
    on到达目标点: function 墨汁喷吐弹幕落地(this: void): void {
      播放墨汁地面特效(context, endX, endY);
    },
  });
}

function 结算墨汁区域伤害(this: void, area: 墨汁区域): void {
  const boss = area.context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 卡瑟拉数值与表现配置.墨汁喷吐;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const affected: any[] = [];
  let damagePerTick = 读取单位攻击力(boss) * cfg.每秒Boss攻击力比例;
  if (area.是否喷吐阶段) {
    damagePerTick /= 10; // 保持总伤害不变，频率10次/秒
  }
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero) || !单位在墨汁区域内(hero, area)) continue;
    const resisted = 满足属性抗性门槛(hero, "水", cfg.水抗门槛, true);
    const factor = resisted ? cfg.达标效果倍率 : 1;
    提交预计算BossAOE技能伤害({
      技能ID: 墨汁喷吐技能ID,
      来源: boss,
      目标: hero,
      伤害: damagePerTick * factor,
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_COLD,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      标签: "卡瑟拉墨汁喷吐",
    });
    施加快速控制Buff(boss, hero, 2, cfg.tick秒 * factor);
    registerManualBuff(hero, 卡瑟拉BuffID.墨汁遮蔽, cfg.tick秒 + 0.2, factor, { sourceName: "卡瑟拉-墨汁遮蔽" });
    affected.push(hero);
  }
  if (affected.length > 0) {
    施加战斗视野压制({
      名称: "卡瑟拉-墨汁视野压制",
      来源单位: boss,
      目标列表: affected,
      持续时间: cfg.tick秒 + 0.2,
      视野减少值: cfg.视野降低,
      BuffID: 卡瑟拉BuffID.墨汁遮蔽,
      叠加键: "卡瑟拉-墨汁遮蔽",
    });
  }
}

function 取墨汁区域后续执行次数(this: void, 总执行次数: number): number {
  const 后续执行次数 = 总执行次数 - 1;
  return 后续执行次数 > 0 ? 后续执行次数 : 0;
}

function 启动墨汁区域周期(this: void, area: 墨汁区域, 名称: string): 限次周期执行器实例 {
  const cfg = 卡瑟拉数值与表现配置.墨汁喷吐;
  const 喷吐阶段 = area.是否喷吐阶段;
  const 总执行次数 = 喷吐阶段 ? cfg.持续秒 / 0.1 : cfg.残留秒 / cfg.tick秒;
  const 周期间隔毫秒 = 喷吐阶段 ? 0.1 * 1000 : cfg.tick秒 * 1000;
  return 创建限次周期执行器<墨汁区域>({
    名称,
    间隔毫秒: 周期间隔毫秒,
    最大执行次数: 取墨汁区域后续执行次数(总执行次数),
    变量: area,
    清理: area.context.清理,
    onTick: function 卡瑟拉墨汁区域周期(this: void, _执行次数: number, variable?: 墨汁区域): boolean {
      return variable != null && 结算墨汁区域一跳(variable);
    },
  });
}

function 开始墨汁残留区域(this: void, area: 墨汁区域): void {
  const cfg = 卡瑟拉数值与表现配置.墨汁喷吐;
  播放墨汁地面特效(area.context, area.地面残留X, area.地面残留Y);
  area.是否喷吐阶段 = false;
  area.剩余跳数 = cfg.残留秒 / cfg.tick秒;
  const 周期 = 启动墨汁区域周期(area, "卡瑟拉-墨汁残留周期");
  area.周期 = 周期;
  const 继续执行 = 结算墨汁区域一跳(area);
  if (!继续执行 && area.周期 === 周期) 周期.停止();
}

function 结算墨汁区域一跳(this: void, area: 墨汁区域): boolean {
  const boss = area.context.Boss单位;
  if (!单位有效(boss) || area.剩余跳数 <= 0) {
    if (area.是否喷吐阶段) {
      开始墨汁残留区域(area);
    }
    return false;
  }
  area.剩余跳数 = area.剩余跳数 - 1;
  if (area.是否喷吐阶段) {
    发射墨汁贝塞尔喷吐(area.context, area.起点X, area.起点Y, area.方向角);
  }
  结算墨汁区域伤害(area);
  if (area.剩余跳数 <= 0 && area.是否喷吐阶段) {
    开始墨汁残留区域(area);
    return false;
  }
  return true;
}

function 开始墨汁喷吐区域(this: void, context: 卡瑟拉运行时上下文, x: number, y: number, angle: number, groundX: number, groundY: number): void {
  const cfg = 卡瑟拉数值与表现配置.墨汁喷吐;
  const area: 墨汁区域 = {
    context,
    起点X: x,
    起点Y: y,
    方向角: angle,
    剩余跳数: cfg.持续秒 / 0.1,
    周期: undefined,
    是否喷吐阶段: true,
    地面残留X: groundX,
    地面残留Y: groundY,
  };
  const 周期 = 启动墨汁区域周期(area, "卡瑟拉-墨汁喷吐周期");
  area.周期 = 周期;
  const 继续执行 = 结算墨汁区域一跳(area);
  if (!继续执行 && area.周期 === 周期) 周期.停止();
}

export function 释放卡瑟拉墨汁喷吐(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const target = 取墨汁喷吐目标(boss);
  if (!单位有效(target)) return;
  const cfg = 卡瑟拉数值与表现配置.墨汁喷吐;
  const bx = GetUnitX(boss);
  const by = GetUnitY(boss);
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);
  const angle = 取单位间角度(boss, target);
  const effectX = 极坐标X(bx, angle, cfg.扇形半径 * 0.45);
  const effectY = 极坐标Y(by, angle, cfg.扇形半径 * 0.45);
  创建技能提示圈({
    类型: "扇形",
    X: bx,
    Y: by,
    半径: cfg.扇形半径,
    扇形角度: cfg.扇形角度,
    朝向: angle,
    持续时间: cfg.持续秒,
    来源单位: boss,
  });
  // 喷吐阶段开始时播放第一滴墨汁残留
  播放墨汁地面特效(context, effectX, effectY);
  开始墨汁喷吐区域(context, bx, by, angle, effectX, effectY);
  启动基础施法时间线({
    名称: "卡瑟拉-墨汁喷吐",
    施法者: boss,
    目标X: targetX,
    目标Y: targetY,
    生效前重新面向: false,
    硬直秒: cfg.持续秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    恢复动画编号: 5,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.持续秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    清理: context.清理,
    播放台词: function 卡瑟拉墨汁喷吐开始提示(this: void): void {
      播放卡瑟拉台词(boss, "墨汁喷吐");
      播放Boss坐标音效(卡瑟拉音效配置.墨汁喷吐.主段, bx, by, 卡瑟拉音效配置.默认裁断距离);
    },
    on生效: function 卡瑟拉墨汁喷吐通道结束(this: void): void {
      // 喷吐区域从施法开始运行，时间线生效点只负责结束硬直与吟唱。
    },
  });
}

function on卡瑟拉墨汁喷吐施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 墨汁喷吐技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 卡瑟拉单位类型ID) return;
  const context = 获取或创建卡瑟拉上下文(castingUnit);
  if (context == null) return;
  释放卡瑟拉墨汁喷吐(context);
}

export function 注册卡瑟拉墨汁喷吐(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "05．墨汁喷吐",
    单位类型ID: 卡瑟拉单位类型ID,
    技能ID: 墨汁喷吐技能ID,
    获取或创建上下文: 获取或创建卡瑟拉上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 卡瑟拉运行时上下文, boss: any): void {
      on卡瑟拉墨汁喷吐施法(boss, 墨汁喷吐技能ID);
    },
  });
}
