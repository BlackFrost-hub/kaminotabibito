/** @noSelfInFile */

import { 树魔首领单位技能配置 } from "./00．配置";
import { 获取或创建树魔首领上下文, 获取全部树魔首领上下文, 清理树魔首领上下文, 树魔首领运行时上下文 } from "./01．运行时上下文";
import { 树魔首领数值与表现配置, 树魔首领音效配置 } from "./02．数值与表现配置";
import { 播放树魔首领台词 } from "./08．台词播放";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";
import { stringToFourCC, 读取单位攻击力, 单位句柄存在, 单位未标记死亡 as 单位存活, 两点角度 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 发起治疗波跳链 } from '../../../../00．技能模板+函数/01．技能函数/10．跳链/治疗波跳链';
import { 开始充能 } from '../../../../00．技能模板+函数/01．技能函数/06．施法·蓄力·充能/充能系统';
import type { 充能结束原因 } from '../../../../00．技能模板+函数/01．技能函数/06．施法·蓄力·充能/充能系统';
import { 创建周期机制调度器 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器';
import { 创建周期行为 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/22．限次周期执行器';

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const jglobals = require("jass.globals") as { udg_Boss?: any; [key: string]: any };

const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (whichUnit: any, facing: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (whichUnit: any, animation: string) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (whichUnit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (whichUnit: any, timeScale: number) => void;
const GetUnitFacing = jass.GetUnitFacing as (whichUnit: any) => number;
const GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed as (whichUnit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetUnitState = jass.GetUnitState as (whichUnit: any, state: any) => number;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const {
  getServerTime,
} = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, unit: any, buffID: string, duration: number, effect: number, extra?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => void;
};
const { 树魔首领BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.04．树魔首领") as {
  树魔首领BuffID: { 兽群号令: string; 无从暴怒: string };
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};
const {
  创建护卫单位,
  获取Boss护卫列表,
  是否指定Boss护卫,
  处理Boss结束全部护卫,
} = require("系统.01．单位系统.10．护卫系统.index") as {
  创建护卫单位: (this: void, 参数: any) => any;
  获取Boss护卫列表: (this: void, boss: any, 只返回存活?: boolean) => any[];
  是否指定Boss护卫: (this: void, unit: any, boss: any) => boolean;
  处理Boss结束全部护卫: (this: void, boss: any) => void;
};
const { 消费剧情Boss战带入随从 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接") as {
  消费剧情Boss战带入随从: (this: void, boss: any) => any[];
};

const 攻击力属性ID = 1;
const 攻速属性ID = 10;
const 叠加移动速度属性ID = 9;
const 树魔首领单位类型ID = stringToFourCC(树魔首领单位技能配置.单位ID);
const 猎头者单位类型ID = stringToFourCC(树魔首领单位技能配置.召唤物ID.猎头者);
const 巫医单位类型ID = stringToFourCC(树魔首领单位技能配置.召唤物ID.巫医);
const 投掷者单位类型ID = stringToFourCC(树魔首领单位技能配置.召唤物ID.投掷者);

let 树魔首领随从特性已注册 = false;

function 是树魔首领(this: void, unit: any): boolean {
  return 单位存活(unit) && GetUnitTypeId(unit) === 树魔首领单位类型ID;
}

interface 树魔随从存活统计 {
  猎头者: number;
  巫医: number;
  投掷者: number;
}

interface 树魔随从编制项 {
  数量: number;
  召唤距离: number;
  相对Boss朝向角度: number;
  槽位间隔角度: number;
}

interface 树魔巫医治疗驱动变量 {
  context: 树魔首领运行时上下文;
  巫医单位: any;
  下一次治疗Ms: number;
}

function 统计树魔随从(this: void, context: 树魔首领运行时上下文): 树魔随从存活统计 {
  const result: 树魔随从存活统计 = { 猎头者: 0, 巫医: 0, 投掷者: 0 };
  const list = context.随从组.取单位列表();
  for (let i = 0; i < list.length; i++) {
    const unit = list[i];
    if (!单位存活(unit)) continue;
    const typeId = GetUnitTypeId(unit);
    if (typeId === 猎头者单位类型ID) result.猎头者++;
    else if (typeId === 巫医单位类型ID) result.巫医++;
    else if (typeId === 投掷者单位类型ID) result.投掷者++;
  }
  return result;
}

function 登记剧情带入树魔随从(this: void, context: 树魔首领运行时上下文): void {
  const list = 消费剧情Boss战带入随从(context.Boss单位);
  for (let i = 0; i < list.length; i++) {
    const minion = list[i];
    if (!单位存活(minion)) continue;
    context.随从组.登记(minion);
    if (GetUnitTypeId(minion) === 巫医单位类型ID) 启动巫医治疗驱动(context, minion);
  }
}

function 计算随从召唤点(
  this: void,
  boss: any,
  编制: 树魔随从编制项,
  槽位序号: number,
): { x: number; y: number } {
  const cfg = 树魔首领数值与表现配置.随从特性;
  const 居中槽位 = 槽位序号 - (编制.数量 - 1) * 0.5;
  const angle = GetUnitFacing(boss)
    + 编制.相对Boss朝向角度
    + 居中槽位 * 编制.槽位间隔角度
    + GetRandomReal(-cfg.召唤角度抖动, cfg.召唤角度抖动);
  return {
    x: GetUnitX(boss) + CosBJ(angle) * 编制.召唤距离,
    y: GetUnitY(boss) + SinBJ(angle) * 编制.召唤距离,
  };
}

function 获取树魔随从护卫类型(this: void, unitTypeId: number): string {
  if (unitTypeId === 猎头者单位类型ID) return "树魔首领:猎头者";
  if (unitTypeId === 巫医单位类型ID) return "树魔首领:巫医";
  if (unitTypeId === 投掷者单位类型ID) return "树魔首领:投掷者";
  return "树魔首领:随从";
}

function 获取树魔随从血条优先级(this: void, unitTypeId: number): number {
  const priorities = 树魔首领数值与表现配置.随从特性.血条优先级;
  if (unitTypeId === 投掷者单位类型ID) return priorities.投掷者;
  if (unitTypeId === 巫医单位类型ID) return priorities.巫医;
  if (unitTypeId === 猎头者单位类型ID) return priorities.猎头者;
  return 0;
}

function 召唤树魔随从(
  this: void,
  context: 树魔首领运行时上下文,
  unitTypeId: number,
  编制: 树魔随从编制项,
  槽位序号: number,
): any {
  const boss = context.Boss单位;
  const 点 = 计算随从召唤点(boss, 编制, 槽位序号);
  const minion = 创建护卫单位({
    主Boss单位: boss,
    护卫类型: 获取树魔随从护卫类型(unitTypeId),
    护卫血条优先级: 获取树魔随从血条优先级(unitTypeId),
    标记为召唤单位: true,
    Boss结束处理: "移除",
    单位类型: unitTypeId,
    所属玩家: GetOwningPlayer(boss),
    X: 点.x,
    Y: 点.y,
    面向: GetUnitFacing(boss),
  });
  if (minion == null || minion === 0) return null;
  context.随从组.登记(minion);
  return minion;
}

function 随机取音效路径(this: void, list: readonly string[]): string {
  if (list.length <= 0) return "";
  return list[GetRandomInt(0, list.length - 1)];
}

function 尝试播放树魔首领怪叫(this: void, boss: any, 触发概率百分比: number): void {
  const soundCfg = 树魔首领音效配置;
  尝试播放Boss拟声池({
    标识: soundCfg.怪物拟声.标识,
    音效路径列表: soundCfg.怪物拟声.音效路径列表,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    裁断距离: soundCfg.默认裁断距离,
    冷却Ms: soundCfg.怪物拟声.冷却Ms,
    触发概率百分比,
  });
}

function 取单位缺血比例(this: void, unit: any): number {
  if (!单位存活(unit)) return 0;
  const maxLife = GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE);
  if (!(maxLife > 0)) return 0;
  const currentLife = GetUnitState(unit, UNIT_STATE_LIFE);
  const ratio = (maxLife - currentLife) / maxLife;
  return ratio > 0 ? ratio : 0;
}

function 选择巫医治疗目标(this: void, context: 树魔首领运行时上下文): any {
  const cfg = 树魔首领数值与表现配置.随从特性;
  const boss = context.Boss单位;
  const bossMissingRatio = 取单位缺血比例(boss);
  if (bossMissingRatio >= cfg.巫医优先治疗Boss缺血比例) return boss;

  const list = 获取Boss护卫列表(boss, true);
  let target: any = null;
  let highestMissingRatio = 0;
  for (let i = 0; i < list.length; i++) {
    const minion = list[i];
    const missingRatio = 取单位缺血比例(minion);
    if (missingRatio > highestMissingRatio) {
      target = minion;
      highestMissingRatio = missingRatio;
    }
  }
  if (target != null) return target;
  return bossMissingRatio > 0 ? boss : null;
}

function 发起树魔巫医疗波(this: void, context: 树魔首领运行时上下文, witchDoctor: any): void {
  const cfg = 树魔首领数值与表现配置.随从特性;
  const boss = context.Boss单位;
  const target = 选择巫医治疗目标(context);
  if (target == null || target === 0) return;
  const healAmount = GetUnitStateJapi(context.Boss单位, UNIT_STATE_MAX_LIFE) * cfg.巫医疗波Boss最大生命比例;
  function 树魔巫医疗波目标筛选(this: void, unit: any): boolean {
    if (!单位存活(unit) || 取单位缺血比例(unit) <= 0) return false;
    return unit === boss || 是否指定Boss护卫(unit, boss);
  }
  发起治疗波跳链({
    起始目标: target,
    来源单位: witchDoctor,
    最大跳数: cfg.巫医疗波最大目标数,
    初始治疗量: healAmount,
    影响目标: "友方",
    每跳最大距离: cfg.巫医疗波每跳最大距离,
    每跳衰减系数: cfg.巫医疗波每跳衰减系数,
    允许重复治疗: false,
    跳跃间隔: cfg.巫医疗波跳跃间隔秒,
    闪电效果代码: "HWPB",
    目标筛选: 树魔巫医疗波目标筛选,
  });
}

interface 树魔巫医治疗充能记录 {
  context: 树魔首领运行时上下文;
  target: any;
}

const 树魔巫医治疗充能记录表: Record<number, 树魔巫医治疗充能记录 | undefined> = {};

function 面向树魔巫医治疗目标(this: void, witchDoctor: any, target: any): void {
  if (!单位存活(witchDoctor) || !单位存活(target)) return;
  SetUnitFacing(witchDoctor, 两点角度(GetUnitX(witchDoctor), GetUnitY(witchDoctor), GetUnitX(target), GetUnitY(target)));
}

function 树魔巫医治疗充能开始(this: void, witchDoctor: any, _充能ID: number): void {
  if (!单位存活(witchDoctor)) return;
  SetUnitTimeScale(witchDoctor, 1);
  SetUnitAnimation(witchDoctor, "spell");
}

function 树魔巫医治疗充能完成(this: void, witchDoctor: any, 充能ID: number): void {
  const 记录 = 树魔巫医治疗充能记录表[充能ID];
  delete 树魔巫医治疗充能记录表[充能ID];
  if (记录 == null) return;

  面向树魔巫医治疗目标(witchDoctor, 记录.target);
  if (单位存活(witchDoctor) && 单位存活(记录.context.Boss单位)) {
    发起树魔巫医疗波(记录.context, witchDoctor);
  }
}

function 树魔巫医治疗充能结束(
  this: void,
  witchDoctor: any,
  _原因: 充能结束原因,
  充能ID: number,
): void {
  delete 树魔巫医治疗充能记录表[充能ID];
  if (!单位存活(witchDoctor)) return;
  SetUnitTimeScale(witchDoctor, 1);
  SetUnitAnimationByIndex(witchDoctor, 0);
}

function 启动巫医治疗波施法(
  this: void,
  context: 树魔首领运行时上下文,
  witchDoctor: any,
  target: any,
): void {
  const cfg = 树魔首领数值与表现配置.随从特性;
  const 施法硬直秒 = cfg.巫医疗波施法硬直秒;
  面向树魔巫医治疗目标(witchDoctor, target);
  const 充能ID = 开始充能(witchDoctor, {
    持续时间: 施法硬直秒,
    主单位: context.Boss单位,
    主单位死亡时中断: true,
    强制硬直: true,
    显示进度条特效: true,
    进度条特效动画序号: 0,
    进度条特效动画速度: 施法硬直秒 > 0 ? 1 / 施法硬直秒 : 1,
    开始回调: 树魔巫医治疗充能开始,
    充能完成回调: 树魔巫医治疗充能完成,
    结束回调: 树魔巫医治疗充能结束,
  });
  if (充能ID > 0) {
    树魔巫医治疗充能记录表[充能ID] = { context, target };
  }
}

function 启动巫医治疗驱动(this: void, context: 树魔首领运行时上下文, witchDoctor: any): void {
  const cfg = 树魔首领数值与表现配置.随从特性;
  const 变量: 树魔巫医治疗驱动变量 = {
    context,
    巫医单位: witchDoctor,
    下一次治疗Ms: getServerTime() + cfg.巫医疗波首次延迟秒 * 1000,
  };
  创建周期行为({
    名称: "树魔-巫医治疗驱动",
    间隔毫秒: cfg.巫医治疗检测间隔秒 * 1000,
    变量,
    清理: context.清理,
    onTick: 树魔巫医治疗Tick,
  });
}

function 树魔巫医治疗Tick(this: void, _执行次数: number, variable?: any): boolean {
  const data = variable as 树魔巫医治疗驱动变量 | undefined;
  if (data == null || !单位存活(data.巫医单位) || !单位存活(data.context.Boss单位)) return false;
  const now = getServerTime();
  if (now < data.下一次治疗Ms) return true;
  const target = 选择巫医治疗目标(data.context);
  if (target == null || target === 0) return true;
  data.下一次治疗Ms = now + 树魔首领数值与表现配置.随从特性.巫医疗波冷却秒 * 1000;
  启动巫医治疗波施法(data.context, data.巫医单位, target);
  return true;
}

export function 测试触发树魔巫医疗波(this: void, context: 树魔首领运行时上下文): boolean {
  if (!单位存活(context.Boss单位)) return false;
  const target = 选择巫医治疗目标(context);
  if (target == null || target === 0) return false;
  const list = context.随从组.取单位列表();
  for (let i = 0; i < list.length; i++) {
    const witchDoctor = list[i];
    if (!单位存活(witchDoctor) || GetUnitTypeId(witchDoctor) !== 巫医单位类型ID) continue;
    启动巫医治疗波施法(context, witchDoctor, target);
    return true;
  }
  return false;
}

function 补充指定类型随从(
  this: void,
  context: 树魔首领运行时上下文,
  unitTypeId: number,
  当前数量: number,
  编制: 树魔随从编制项,
): number {
  let created = 0;
  for (let i = 当前数量; i < 编制.数量; i++) {
    const minion = 召唤树魔随从(context, unitTypeId, 编制, i);
    if (minion == null || minion === 0) continue;
    created++;
    if (unitTypeId === 巫医单位类型ID) 启动巫医治疗驱动(context, minion);
  }
  return created;
}

function 补充树魔随从编制(this: void, context: 树魔首领运行时上下文): number {
  const cfg = 树魔首领数值与表现配置.随从特性;
  const counts = 统计树魔随从(context);
  let created = 0;
  created += 补充指定类型随从(context, 猎头者单位类型ID, counts.猎头者, cfg.编制.猎头者);
  created += 补充指定类型随从(context, 巫医单位类型ID, counts.巫医, cfg.编制.巫医);
  created += 补充指定类型随从(context, 投掷者单位类型ID, counts.投掷者, cfg.编制.投掷者);
  if (created <= 0) return 0;

  const soundCfg = 树魔首领音效配置;
  播放Boss坐标音效(
    随机取音效路径(soundCfg.随从特性.召唤号令列表),
    GetUnitX(context.Boss单位),
    GetUnitY(context.Boss单位),
    soundCfg.默认裁断距离,
  );
  尝试播放树魔首领怪叫(context.Boss单位, soundCfg.怪物拟声.召唤触发概率百分比);
  播放树魔首领台词(context.Boss单位, "随从特性");
  return created;
}

export function 初始化树魔首领随从特性(this: void, context: 树魔首领运行时上下文): void {
  if (context.随从特性已初始化 || !单位存活(context.Boss单位)) return;
  const cfg = 树魔首领数值与表现配置.随从特性;
  context.随从特性已初始化 = true;
  const boss = context.Boss单位;
  context.清理.登记清理("树魔首领-护卫登记清理", function 清理树魔随从护卫登记(this: void): void {
    处理Boss结束全部护卫(boss);
  });
  context.清理.登记清理("树魔首领-兽群攻击力回滚", function 清理树魔首领兽群攻击力(this: void): void {
    清除兽群攻击力加成(context);
  });
  context.清理.登记清理("树魔首领-无从暴怒清理", function 清理树魔首领无从暴怒(this: void): void {
    退出无从暴怒(context);
  });
  登记剧情带入树魔随从(context);
  if (cfg.初始召唤延迟秒 <= 0) {
    补充树魔随从编制(context);
    context.下一次召唤Ms = getServerTime() + cfg.补员间隔秒 * 1000;
  } else {
    context.下一次召唤Ms = getServerTime() + cfg.初始召唤延迟秒 * 1000;
  }
  刷新随从状态(context);
}

export function 立即补充树魔首领随从(this: void, context: 树魔首领运行时上下文): number {
  if (!单位存活(context.Boss单位)) return 0;
  const cfg = 树魔首领数值与表现配置.随从特性;
  context.随从特性已初始化 = true;
  const created = 补充树魔随从编制(context);
  context.下一次召唤Ms = getServerTime() + cfg.补员间隔秒 * 1000;
  刷新随从状态(context);
  return created;
}

function 进入无从暴怒(this: void, context: 树魔首领运行时上下文): void {
  if (context.无从暴怒中) return;
  const cfg = 树魔首领数值与表现配置.随从特性;
  context.无从暴怒中 = true;
  context.暴怒攻速增量 = cfg.无小弟攻速提高;
  context.暴怒移速增量 = GetUnitDefaultMoveSpeed(context.Boss单位) * cfg.无小弟移速提高;
  SGSS_SetState(context.Boss单位, 攻速属性ID, context.暴怒攻速增量);
  SGSS_SetState(context.Boss单位, 叠加移动速度属性ID, context.暴怒移速增量);
  context.暴怒持续特效 = AddSpecialEffectTarget(cfg.暴怒持续特效路径, context.Boss单位, "origin");
  播放Boss坐标音效(树魔首领音效配置.随从特性.无从暴怒, GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), 树魔首领音效配置.默认裁断距离);
  尝试播放树魔首领怪叫(context.Boss单位, 树魔首领音效配置.怪物拟声.暴怒触发概率百分比);
}

function 退出无从暴怒(this: void, context: 树魔首领运行时上下文): void {
  if (!context.无从暴怒中) return;
  context.无从暴怒中 = false;
  if (context.暴怒持续特效 != null && context.暴怒持续特效 !== 0) DestroyEffect(context.暴怒持续特效);
  context.暴怒持续特效 = null;
  if (context.暴怒攻速增量 !== 0) SGSS_SetState(context.Boss单位, 攻速属性ID, -context.暴怒攻速增量);
  if (context.暴怒移速增量 !== 0) SGSS_SetState(context.Boss单位, 叠加移动速度属性ID, -context.暴怒移速增量);
  context.暴怒攻速增量 = 0;
  context.暴怒移速增量 = 0;
  移除单位指定Buff(context.Boss单位, 树魔首领BuffID.无从暴怒);
}

function 清除兽群攻击力加成(this: void, context: 树魔首领运行时上下文): void {
  const applied = context.兽群攻击力增量;
  if (applied !== 0 && 单位句柄存在(context.Boss单位)) {
    SGSS_SetState(context.Boss单位, 攻击力属性ID, -applied);
  }
  context.兽群攻击力增量 = 0;
}

function 刷新兽群攻击力加成(this: void, context: 树魔首领运行时上下文): void {
  const cfg = 树魔首领数值与表现配置.随从特性;
  const rawRatio = context.当前兽群层数 * cfg.每个小弟攻击提高;
  const ratio = rawRatio < cfg.最高攻击提高 ? rawRatio : cfg.最高攻击提高;
  const currentAttack = 读取单位攻击力(context.Boss单位);
  const attackWithoutPack = currentAttack - context.兽群攻击力增量;
  const baseAttack = attackWithoutPack > 0 ? attackWithoutPack : 0;
  const nextBonus = baseAttack * ratio;
  const delta = nextBonus - context.兽群攻击力增量;
  if (delta > 0.001 || delta < -0.001) {
    SGSS_SetState(context.Boss单位, 攻击力属性ID, delta);
  }
  context.兽群攻击力增量 = nextBonus;
}

function 刷新随从状态(this: void, context: 树魔首领运行时上下文): void {
  if (!单位存活(context.Boss单位)) {
    清理树魔首领上下文(context.Boss单位);
    return;
  }
  const cfg = 树魔首领数值与表现配置.随从特性;
  const count = context.随从组.取存活数量();
  context.当前随从数量 = count;
  context.当前兽群层数 = count < cfg.兽群最高层数 ? count : cfg.兽群最高层数;
  刷新兽群攻击力加成(context);

  if (count > 0) {
    退出无从暴怒(context);
    registerManualBuff(context.Boss单位, 树魔首领BuffID.兽群号令, cfg.兽群Buff刷新秒, context.当前兽群层数, {
      sourceName: "树魔首领",
      stack: context.当前兽群层数,
    });
  } else {
    移除单位指定Buff(context.Boss单位, 树魔首领BuffID.兽群号令);
    进入无从暴怒(context);
    registerManualBuff(context.Boss单位, 树魔首领BuffID.无从暴怒, cfg.暴怒Buff刷新秒, 1, {
      sourceName: "树魔首领",
    });
  }
}

function 获取树魔首领随从特性上下文列表(this: void): 树魔首领运行时上下文[] {
  const currentBoss = jglobals.udg_Boss;
  if (是树魔首领(currentBoss)) {
    const context = 获取或创建树魔首领上下文(currentBoss);
    if (context != null) 初始化树魔首领随从特性(context);
  }
  return 获取全部树魔首领上下文();
}

function 执行树魔首领随从特性Tick(this: void, context: 树魔首领运行时上下文, now: number): void {
  if (context == null) return;
  if (context.随从特性已初始化) 登记剧情带入树魔随从(context);
  if (context.随从特性已初始化 && context.下一次召唤Ms > 0 && now >= context.下一次召唤Ms) {
    补充树魔随从编制(context);
    context.下一次召唤Ms = now + 树魔首领数值与表现配置.随从特性.补员间隔秒 * 1000;
  }
  刷新随从状态(context);
}

export function 注册树魔首领随从特性(this: void): void {
  if (树魔首领随从特性已注册) return;
  树魔首领随从特性已注册 = true;
  创建周期机制调度器({
    名称: "树魔首领-随从特性驱动",
    间隔毫秒: 树魔首领数值与表现配置.随从特性.追随刷新间隔毫秒,
    取上下文列表: 获取树魔首领随从特性上下文列表,
    取当前时间: getServerTime,
    执行: 执行树魔首领随从特性Tick,
  });
}
