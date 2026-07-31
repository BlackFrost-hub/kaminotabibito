/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚技能数值配置, 米亚音效配置, 米亚运行时配置 } from "./02．数值与表现配置";
import { 播放米亚台词 } from "./15．台词播放";
import { 延迟播放Boss坐标音效, 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 创建世界坐标进度UI, 更新世界坐标进度UI, 销毁世界坐标进度UI, type 世界坐标进度UI } from "../../../../../09．表现系统/15．世界坐标进度UI";

const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口") as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 创建点特效, 创建单位脚下点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  创建单位脚下点特效: (this: void, unit: any, 参数: any) => any;
};
const { X_FixUnitStandingSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_FixUnitStandingSafe: (this: void, unit: any) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

interface 米亚灵猫分身倒计时变量 {
  context: 米亚运行时上下文;
  单位: any;
  UI: 世界坐标进度UI | null;
  周期ID: number;
  到期时间毫秒: number;
}

const 米亚灵猫分身倒计时表: Record<number, 米亚灵猫分身倒计时变量 | undefined> = {};
let 米亚灵猫分身死亡监听已注册 = false;

function 清理米亚灵猫分身倒计时(this: void, data: 米亚灵猫分身倒计时变量 | undefined): void {
  if (data == null) return;
  if (data.周期ID !== 0) {
    removePeriodicCallback(data.周期ID);
    data.周期ID = 0;
  }
  销毁世界坐标进度UI(data.UI);
  data.UI = null;
  if (data.单位 != null && data.单位 !== 0) {
    const unitId = GetHandleId(data.单位);
    if (米亚灵猫分身倒计时表[unitId] === data) 米亚灵猫分身倒计时表[unitId] = undefined;
  }
}

function 清理米亚灵猫分身单位倒计时(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  清理米亚灵猫分身倒计时(米亚灵猫分身倒计时表[GetHandleId(unit)]);
}

function on米亚灵猫分身死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  清理米亚灵猫分身单位倒计时(dyingUnit);
}

function 确保米亚灵猫分身死亡监听(this: void): void {
  if (米亚灵猫分身死亡监听已注册) return;
  米亚灵猫分身死亡监听已注册 = true;
  registerDeathListener(on米亚灵猫分身死亡);
}

function 更新米亚灵猫分身倒计时(this: void, variable?: any): void {
  const data = variable as 米亚灵猫分身倒计时变量 | undefined;
  if (data == null) return;
  if (!单位有效(data.单位) || !单位有效(data.context.Boss单位)) {
    清理米亚灵猫分身倒计时(data);
    return;
  }
  let remaining = (data.到期时间毫秒 - getServerTime()) / 1000;
  if (remaining < 0) remaining = 0;
  更新世界坐标进度UI(data.UI, remaining);
  if (!(remaining > 0)) 清理米亚灵猫分身倒计时(data);
}

function 创建米亚灵猫分身倒计时(this: void, context: 米亚运行时上下文, unit: any, x: number, y: number): void {
  if (context == null || context.清理 == null || context.清理.已清理() || !单位有效(unit)) return;
  确保米亚灵猫分身死亡监听();
  const config = 米亚技能数值配置.灵猫分身;
  const data: 米亚灵猫分身倒计时变量 = {
    context,
    单位: unit,
    UI: 创建世界坐标进度UI({
      X: x,
      Y: y,
      Z: 220,
      最大值: config.持续秒,
      当前值: config.持续秒,
      标题: "灵猫分身",
      数值后缀: "秒",
      类型: "危险",
      平滑过渡秒: 0.1,
      初始显示: true,
      雾中可见: false,
    }),
    周期ID: 0,
    到期时间毫秒: getServerTime() + config.持续秒 * 1000,
  };
  if (data.UI == null) return;
  米亚灵猫分身倒计时表[GetHandleId(unit)] = data;
  data.周期ID = addPeriodicCallback(100, 更新米亚灵猫分身倒计时, data);
  context.清理.登记周期回调("米亚-灵猫分身倒计时", data.周期ID);
  context.清理.登记清理("米亚-灵猫分身倒计时UI", 清理米亚灵猫分身倒计时, data);
}

function 播放分身出生表现(this: void, x: number, y: number): void {
  创建点特效({
    模型路径: "Common\\Effect\\Element\\magic\\WhiteElement.mdx",
    X: x,
    Y: y,
    持续秒: 1.5,
    缩放: 1,
  });
}

function 恢复Boss生命(this: void, boss: any, amount: number): void {
  if (!单位有效(boss) || amount <= 0) return;
  doHeal({ HealSource: boss, HealTarget: boss, HealAmount: amount, ItemHeal: false, HealEffect: false });
}

function 安排分身到期结算(this: void, context: 米亚运行时上下文, summons: any[]): void {
  const config = 米亚技能数值配置.灵猫分身;
  addDelayedCallback((config.持续秒 - 5) * 1000, function 米亚灵猫分身剩余5秒提示(this: void): void {
    for (let i = 0; i < summons.length; i++) {
      if (单位有效(summons[i])) {
        播放米亚台词(context.Boss单位, "灵猫分身", 2);
        break;
      }
    }
  });
  addDelayedCallback(config.持续秒 * 1000, function 米亚灵猫分身到期结算(this: void): void {
    const boss = context.Boss单位;
    if (!单位有效(boss)) return;
    const healPerSummon = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * config.未击杀每只恢复生命比例;
    let aliveCount = 0;
    for (let i = 0; i < summons.length; i++) {
      const summon = summons[i];
      if (!单位有效(summon)) continue;
      aliveCount++;
      创建单位脚下点特效(summon, {
        模型路径: "Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx",
        持续秒: 1.2,
        缩放: 1,
      });
      RemoveUnit(summon);
    }
    if (aliveCount > 0) {
      恢复Boss生命(boss, healPerSummon * aliveCount);
      播放米亚台词(boss, "灵猫分身", 3);
    } else {
      播放米亚台词(boss, "灵猫分身", 4);
    }
  });
}

export function 触发米亚灵猫分身(this: void, context: 米亚运行时上下文): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return false;

  const config = 米亚技能数值配置.灵猫分身;
  const bossX = GetUnitX(boss);
  const bossY = GetUnitY(boss);
  const facing = GetUnitFacing(boss);
  const maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE);
  const rawAttack = 读取单位攻击力(boss);
  const attack = rawAttack > 0 ? rawAttack : 米亚运行时配置.Boss攻击力兜底;
  const summons: any[] = [];

  播放米亚台词(boss, "灵猫分身", 0);
  播放Boss坐标音效(米亚音效配置.灵猫分身.主辨识音, bossX, bossY, 米亚音效配置.默认裁断距离);
  延迟播放Boss坐标音效(米亚音效配置.灵猫分身.凝形补层, bossX, bossY, 米亚音效配置.灵猫分身.凝形补层延迟Ms, 米亚音效配置.默认裁断距离);
  创建单位脚下点特效(boss, {
    模型路径: "Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx",
    持续秒: 1.2,
    缩放: 1,
  });

  const offsets = [-1, 1];
  for (let i = 0; i < config.分身数量; i++) {
    const side = offsets[i % offsets.length];
    const angle = facing + 90 * side;
    const x = bossX + CosBJ(angle) * config.召唤距离;
    const y = bossY + SinBJ(angle) * config.召唤距离;
    播放分身出生表现(x, y);
      const summon = 创建召唤物({
      主人单位: boss,
      单位名称: "腐化灵猫幻影",
      X: x,
      Y: y,
      朝向: facing,
      持续时间: config.持续秒 + 0.5,
      模型文件: 米亚单位技能配置.模型.Boss,
      生命值: maxLife * config.分身生命比例,
      生命值受小怪倍率: false,
      攻击力: attack * config.分身攻击力比例,
      攻击间隔: config.分身攻击间隔,
      攻击范围: config.分身攻击范围,
      索敌范围: config.分身索敌范围,
      缩放: config.分身缩放,
    });
    if (单位有效(summon)) {
      X_FixUnitStandingSafe(summon);
      创建米亚灵猫分身倒计时(context, summon, x, y);
      summons.push(summon);
    }
  }

  if (summons.length > 0) {
    播放米亚台词(boss, "灵猫分身", 1);
    安排分身到期结算(context, summons);
  }
  return true;
}
