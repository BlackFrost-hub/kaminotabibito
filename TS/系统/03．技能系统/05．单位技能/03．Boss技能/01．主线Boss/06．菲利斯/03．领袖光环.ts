/** @noSelfInFile */

import { 获取全部菲利斯上下文, 获取菲利斯上下文, type 菲利斯运行时上下文 } from "./01．运行时上下文";
import { 菲利斯数值与表现配置, 菲利斯音效配置 } from "./02．数值与表现配置";
import { 单位有效, stringToFourCC } from "./11．公共工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 播放菲利斯台词 } from "./08．台词播放";
import { 创建周期机制调度器 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器";
import { 创建手动数值Buff范围光环, 同步手动数值Buff范围光环 } from "../../../../00．技能模板+函数/01．技能函数/23．光环/02．数值Buff范围光环";
import { 调整状态ID属性 } from "../../../../00．技能模板+函数/01．技能函数/20．物品辅助/16．属性位移与指令";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 菲利斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.05．菲利斯") as {
  菲利斯BuffID: { 领袖光环: string };
};
const { 创建Dz绑定单位特效, 销毁Dz绑定单位特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建Dz绑定单位特效: (this: void, unit: any, attachPoint: string, modelPath: string, effectKey?: string, scale?: number) => any;
  销毁Dz绑定单位特效: (this: void, unit: any, effectKey?: string) => void;
};
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, unit: any, abilityId: number, cooldown: number, maxCooldown: number) => boolean;
};
const { 技能_获取技能当前冷却时间 } = require("平台扩展API取值") as {
  技能_获取技能当前冷却时间: (this: void, unit: any, abilityId: number) => number;
};

const 剑气灵斩技能ID = stringToFourCC(菲利斯数值与表现配置.剑气灵斩.技能槽位);
const 攻击力属性ID = 1;
let 领袖光环已注册 = false;
const 领袖光环特效键 = "菲利斯-领袖光环";
let 领袖光环范围ID = 0;

function 生命比例(this: void, unit: any): number {
  const maxLife = GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE);
  if (!(maxLife > 0)) return 0;
  return GetUnitState(unit, UNIT_STATE_LIFE) / maxLife;
}

function 取领袖光环攻击力倍率(this: void, holder: any): number {
  const context = 获取菲利斯上下文(holder);
  if (context == null) return 0;
  const cfg = 菲利斯数值与表现配置.领袖光环;
  return context.当前领袖光环低血 ? -cfg.低血友军攻击降低 : cfg.高血友军攻击提高;
}

function 计算领袖光环攻击增量(this: void, target: any, 总层数: number, 已应用攻击力增量: number, holder: any): number {
  if (总层数 <= 0) return 0;
  const 当前攻击力 = 读取单位攻击力(target);
  const 基础攻击力 = 当前攻击力 - 已应用攻击力增量;
  const 攻击力倍率 = 取领袖光环攻击力倍率(holder);
  return 基础攻击力 > 0 ? 基础攻击力 * 攻击力倍率 : 0;
}

function 同步剑气灵斩低血冷却(this: void, context: 菲利斯运行时上下文, low: boolean, wasLow: boolean): void {
  if (low === wasLow) return;
  const boss = context.Boss单位;
  if (!单位有效(boss) || GetUnitAbilityLevel(boss, 剑气灵斩技能ID) <= 0) return;
  const cfg = 菲利斯数值与表现配置;
  const 当前冷却 = 技能_获取技能当前冷却时间(boss, 剑气灵斩技能ID) || 0;
  if (low) {
    const 缩短后冷却 = 当前冷却 * (1 - cfg.领袖光环.低血剑气灵斩冷却缩短);
    技能_设置技能冷却时间(boss, 剑气灵斩技能ID, 缩短后冷却, cfg.剑气灵斩.低血冷却秒);
    return;
  }
  技能_设置技能冷却时间(boss, 剑气灵斩技能ID, 当前冷却, cfg.剑气灵斩.冷却秒);
}

function 应用领袖光环攻击力差值(this: void, target: any, 差值: number): void {
  调整状态ID属性(target, 攻击力属性ID, 差值);
}

function 取领袖光环Buff显示值(this: void, _target: any, _总层数: number, holder: any): number {
  return 取领袖光环攻击力倍率(holder);
}

function 取领袖光环Buff附加参数(this: void, _target: any, _总层数: number, _holder: any): any {
  return {
    sourceName: "菲利斯-领袖光环",
  };
}

function 注册领袖光环清理(this: void, context: 菲利斯运行时上下文): void {
  if (context.领袖光环清理已注册) return;
  context.领袖光环清理已注册 = true;
  const boss = context.Boss单位;
  context.清理.登记清理("菲利斯-领袖光环", function 清理菲利斯领袖光环(this: void): void {
    同步手动数值Buff范围光环(领袖光环范围ID, boss, false);
  });
}

function 刷新单个领袖光环(this: void, context: 菲利斯运行时上下文): void {
  const boss = context.Boss单位;
  注册领袖光环清理(context);
  if (!单位有效(boss)) return;
  const cfg = 菲利斯数值与表现配置.领袖光环;
  const low = 生命比例(boss) < cfg.生命切换阈值;
  const wasLow = context.当前领袖光环低血;
  同步剑气灵斩低血冷却(context, low, wasLow);
  context.当前领袖光环低血 = low;
  if (!wasLow && low) {
    播放Boss坐标音效(菲利斯音效配置.领袖光环.低血切换, GetUnitX(boss), GetUnitY(boss), 菲利斯音效配置.默认裁断距离);
    播放菲利斯台词(boss, "领袖光环", 0);
  }
  registerManualBuff(boss, 菲利斯BuffID.领袖光环, 1.4, low ? -cfg.低血友军攻击降低 : cfg.高血友军攻击提高, {
    sourceName: "菲利斯-领袖光环",
  });
  同步手动数值Buff范围光环(领袖光环范围ID, boss, true);

  销毁Dz绑定单位特效(boss, 领袖光环特效键);
  创建Dz绑定单位特效(
    boss,
    "origin",
    low ? cfg.低血光环特效路径 : cfg.高血光环特效路径,
    领袖光环特效键,
    cfg.光环特效缩放,
  );
}

export function 注册菲利斯领袖光环(this: void): void {
  if (领袖光环已注册) return;
  领袖光环已注册 = true;
  领袖光环范围ID = 创建手动数值Buff范围光环({
    状态ID: "菲利斯-领袖光环",
    半径: 菲利斯数值与表现配置.领袖光环.范围,
    目标类型: "友军不含自己",
    排除无敌: true,
    最大层数: 1,
    数值效果列表: [{ key: "攻击力", 计算总值: 计算领袖光环攻击增量, 应用差值: 应用领袖光环攻击力差值 }],
    Buff: {
      BuffID: 菲利斯BuffID.领袖光环,
      持续秒: 1.4,
      取显示值: 取领袖光环Buff显示值,
      取附加参数: 取领袖光环Buff附加参数,
    },
  });
  创建周期机制调度器({
    名称: "菲利斯-领袖光环",
    间隔毫秒: 菲利斯数值与表现配置.领袖光环.检查间隔毫秒,
    取上下文列表: 获取全部菲利斯上下文,
    执行: 刷新单个领袖光环,
  });
}
