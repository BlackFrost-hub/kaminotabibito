/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";
import {
  两点角度,
  单位存活,
  创建咲夜单位壳,
  安全移除单位壳,
  极坐标X,
  极坐标Y,
  播放咲夜单位音效,
  施加短硬直并播放动作,
  注册咲夜周期任务,
  移除咲夜周期任务,
  登记咲夜飞刀,
  注销咲夜飞刀,
} from "./01．飞刀与时间工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const { 造成单体技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 单位是否暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  单位是否暂停: (this: void, unit: any) => boolean;
};

const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetUnitScale = jass.SetUnitScale as (this: void, unit: any, x: number, y: number, z: number) => void;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;

interface Q监听上下文 {
  占位: boolean;
}

interface Q施法上下文 {
  施法者: any;
  目标: any;
  伤害: number;
  技能实例ID?: number;
  剩余飞刀: number;
  已结束: boolean;
}

interface Q飞刀状态 {
  上下文: Q施法上下文;
  单位: any;
  阶段: "外扩" | "追踪";
  角度: number;
  已飞行距离: number;
  追踪Tick: number;
  周期ID: number;
  已结束: boolean;
}

function 获取Q监听上下文(this: void, _caster: any): Q监听上下文 {
  return { 占位: true };
}

function Q单刀结束(this: void, state: Q飞刀状态): void {
  if (state.已结束) return;
  state.已结束 = true;
  if (state.周期ID !== 0) 移除咲夜周期任务(state.周期ID);
  state.周期ID = 0;
  注销咲夜飞刀(state.单位);
  安全移除单位壳(state.单位);
  const cast = state.上下文;
  cast.剩余飞刀 -= 1;
  if (cast.剩余飞刀 <= 0 && !cast.已结束) {
    cast.已结束 = true;
    结束独立技能伤害实例(cast.技能实例ID);
  }
}

function 切换Q追踪刀(this: void, state: Q飞刀状态): void {
  const old = state.单位;
  const x = jass.GetUnitX(old) as number;
  const y = jass.GetUnitY(old) as number;
  const target = state.上下文.目标;
  const angle = target != null && target !== 0 ? 两点角度(x, y, GetUnitX(target), GetUnitY(target)) : state.角度;
  注销咲夜飞刀(old);
  安全移除单位壳(old);
  const replacement = 创建咲夜单位壳(state.上下文.施法者, 配置.单位壳.蓝刀, x, y, angle);
  if (replacement == null || replacement === 0) {
    state.单位 = null;
    Q单刀结束(state);
    return;
  }
  SetUnitScale(replacement, 1, 1, 1);
  state.单位 = replacement;
  state.角度 = angle;
  state.阶段 = "追踪";
  登记Q飞刀(state);
  if (state.周期ID !== 0) 移除咲夜周期任务(state.周期ID);
  state.周期ID = 注册咲夜周期任务(配置.Q.追踪周期毫秒, 推进Q飞刀, state);
}

function 登记Q飞刀(this: void, state: Q飞刀状态): void {
  登记咲夜飞刀({
    单位: state.单位,
    主人: state.上下文.施法者,
    取角度: function 取Q飞刀角度(this: void): number { return state.角度; },
    设置角度: function 设置Q飞刀角度(this: void, value: number): void {
      state.角度 = value;
      SetUnitFacing(state.单位, value);
    },
    取每Tick位移: function 取Q飞刀步长(this: void): number {
      return state.阶段 === "外扩" ? 配置.Q.外扩步长 : 配置.Q.追踪步长;
    },
    设置每Tick位移: function 设置Q飞刀步长(this: void, _value: number): void {},
    取已飞行距离: function 取Q飞刀距离(this: void): number { return state.已飞行距离; },
    设置已飞行距离: function 设置Q飞刀距离(this: void, value: number): void { state.已飞行距离 = value; },
    取最大距离: function 取Q飞刀最大距离(this: void): number { return 配置.Q.追踪步长 * 配置.Q.追踪最大Tick; },
    设置最大距离: function 设置Q飞刀最大距离(this: void, value: number): void {
      state.追踪Tick = Math.max(0, 配置.Q.追踪最大Tick - Math.floor(value / 配置.Q.追踪步长));
    },
    结束: function 结束已登记Q飞刀(this: void): void { Q单刀结束(state); },
  });
}

function 推进Q飞刀(this: void, variable?: any): void {
  const state = variable as Q飞刀状态 | undefined;
  if (state == null || state.已结束) return;
  const shell = state.单位;
  if (!单位存活(shell) || !单位存活(state.上下文.施法者)) {
    Q单刀结束(state);
    return;
  }
  if (单位是否暂停(shell)) return;

  if (state.阶段 === "外扩") {
    if (state.已飞行距离 >= 配置.Q.外扩距离) {
      切换Q追踪刀(state);
      return;
    }
    SetUnitX(shell, 极坐标X(GetUnitX(shell), 配置.Q.外扩步长, state.角度));
    SetUnitY(shell, 极坐标Y(GetUnitY(shell), 配置.Q.外扩步长, state.角度));
    state.已飞行距离 += 配置.Q.外扩步长;
    return;
  }

  state.追踪Tick += 1;
  if (state.追踪Tick >= 配置.Q.追踪最大Tick) {
    Q单刀结束(state);
    return;
  }
  const target = state.上下文.目标;
  if (target == null || target === 0) {
    Q单刀结束(state);
    return;
  }
  const angle = 两点角度(GetUnitX(shell), GetUnitY(shell), GetUnitX(target), GetUnitY(target));
  state.角度 = angle;
  SetUnitFacing(shell, angle);
  const nextX = 极坐标X(GetUnitX(shell), 配置.Q.追踪步长, angle);
  const nextY = 极坐标Y(GetUnitY(shell), 配置.Q.追踪步长, angle);
  SetUnitX(shell, nextX);
  SetUnitY(shell, nextY);
  if (GetUnitFlyHeight(shell) > GetUnitFlyHeight(target)) SetUnitFlyHeight(shell, GetUnitFlyHeight(shell) - 5, 0);

  const dx = nextX - GetUnitX(target);
  const dy = nextY - GetUnitY(target);
  if (dx * dx + dy * dy > 配置.Q.命中半径 * 配置.Q.命中半径) return;
  if (单位存活(target) && IsUnitEnemy(target, GetOwningPlayer(state.上下文.施法者))) {
    造成单体技能伤害({
      来源: state.上下文.施法者,
      目标: target,
      伤害: state.上下文.伤害,
      伤害类型: DAMAGE_TYPE_NORMAL,
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
      来源类型: "单位技能",
      标签: "十六夜咲夜-Q-杀人玩偶",
      技能ID: 配置.技能.Q.类型ID,
      技能实例ID: state.上下文.技能实例ID,
    });
  }
  Q单刀结束(state);
}

function 释放十六夜咲夜Q(this: void, _context: Q监听上下文, caster: any, 技能实例ID?: number): void {
  const target = GetSpellTargetUnit();
  if (target == null || target === 0) {
    结束独立技能伤害实例(技能实例ID);
    return;
  }
  const cast: Q施法上下文 = {
    施法者: caster,
    目标: target,
    伤害: 读取单位攻击力(caster) * 配置.Q.伤害攻击力倍率,
    技能实例ID,
    剩余飞刀: 配置.Q.数量,
    已结束: false,
  };
  const source = `十六夜咲夜-Q:${技能实例ID ?? jass.GetHandleId(caster)}`;
  施加短硬直并播放动作(caster, source, 配置.Q.硬直秒, "spell");
  播放咲夜单位音效("gg_snd_IzayoiSakuya_RQ3", caster);
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  for (let i = 1; i <= 配置.Q.数量; i++) {
    const angle = 配置.Q.初始角度间隔 * i;
    const shell = 创建咲夜单位壳(caster, 配置.单位壳.环绕蓝刀, x, y, angle);
    if (shell == null || shell === 0) {
      cast.剩余飞刀 -= 1;
      continue;
    }
    const state: Q飞刀状态 = {
      上下文: cast,
      单位: shell,
      阶段: "外扩",
      角度: angle,
      已飞行距离: 0,
      追踪Tick: 0,
      周期ID: 0,
      已结束: false,
    };
    登记Q飞刀(state);
    state.周期ID = 注册咲夜周期任务(配置.Q.外扩周期毫秒, 推进Q飞刀, state);
  }
  if (cast.剩余飞刀 <= 0) 结束独立技能伤害实例(技能实例ID);
}

export function 注册十六夜咲夜Q(this: void): void {
  注册单位技能壳监听({
    名称: "十六夜咲夜-杀人玩偶（Q）",
    单位类型ID: 配置.英雄单位类型ID,
    技能ID: 配置.技能.Q.类型ID,
    获取或创建上下文: 获取Q监听上下文,
    释放技能: 释放十六夜咲夜Q,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 10,
  });
}

注册十六夜咲夜Q();

export {};
