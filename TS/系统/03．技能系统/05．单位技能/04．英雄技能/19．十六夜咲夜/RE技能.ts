/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";
import { 两点角度, 创建咲夜单位壳, 安全移除单位壳, 极坐标X, 极坐标Y, 单位存活, 播放咲夜单位音效, 注册咲夜周期任务, 移除咲夜周期任务, 登记咲夜飞刀, 注销咲夜飞刀 } from "./01．飞刀与时间工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 设置十六夜咲夜符卡书冷却 } from "./符卡公共";
import { 获取坐标范围单位按筛选 } from "../../../00．技能模板+函数/02．通用函数/02．单位与范围";

const jass = require("jass.common") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 造成单体技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};

interface RE监听上下文 { 占位: boolean; }
interface RE解停参数 { 单位: any; 来源: string; }
interface RE状态 {
  施法者: any;
  飞刀: any;
  技能实例ID?: number;
  伤害: number;
  角度: number;
  每Tick位移: number;
  已飞行距离: number;
  最大距离: number;
  当前目标: any;
  已命中: Record<number, boolean | undefined>;
  命中次数: number;
  周期ID: number;
  已结束: boolean;
}

function 获取RE监听上下文(this: void, _caster: any): RE监听上下文 { return { 占位: true }; }

function RE解除短暂停(this: void, variable?: any): void {
  const data = variable as RE解停参数 | undefined;
  if (data == null) return;
  移除单位暂停(data.单位, data.来源);
  if (单位存活(data.单位)) jass.SetUnitVertexColor(data.单位, 255, 255, 255, 255);
}

/**
 * 目标枚举。源规则：存活 + 敌对 + 排除 Ancient + 排除已命中（放行建筑/机械/古树/无敌），
 * 返回全部合法目标。配置型筛选逐项等价：要求有效单位=false 跳过四重过滤、
 * 允许死亡=false 排除死亡、允许无敌=true 保持源语义、仅敌人 排除非敌对（含施法者自身）、
 * 自定义条件 排除 Ancient 与已命中。
 */
function RE枚举目标(this: void, state: RE状态, x: number, y: number, radius: number): any[] {
  return 获取坐标范围单位按筛选(x, y, radius, state.施法者, {
    要求有效单位: false,
    允许死亡: false,
    允许建筑: true,
    允许机械: true,
    允许古树: true,
    允许无敌: true,
    仅敌人: true,
    自定义条件: (u: any) => !jass.IsUnitType(u, jass.UNIT_TYPE_ANCIENT) && state.已命中[jass.GetHandleId(u) as number] !== true,
  });
}

function 结束RE(this: void, state: RE状态): void {
  if (state.已结束) return;
  state.已结束 = true;
  if (state.周期ID !== 0) 移除咲夜周期任务(state.周期ID);
  注销咲夜飞刀(state.飞刀);
  安全移除单位壳(state.飞刀);
  结束独立技能伤害实例(state.技能实例ID);
}

function RE命中(this: void, state: RE状态, target: any): void {
  state.已命中[jass.GetHandleId(target) as number] = true;
  state.命中次数 += 1;
  造成单体技能伤害({
    来源: state.施法者,
    目标: target,
    伤害: state.伤害,
    伤害类型: jass.DAMAGE_TYPE_ENHANCED,
    attack: false,
    ranged: false,
    attackType: jass.ATTACK_TYPE_NORMAL,
    weaponType: jass.WEAPON_TYPE_METAL_HEAVY_SLICE,
    来源类型: "单位技能",
    标签: "十六夜咲夜-RE-Silver Acute 360",
    技能ID: 配置.技能.RE.类型ID,
    技能实例ID: state.技能实例ID,
  });
  const source = `十六夜咲夜-RE:${state.技能实例ID ?? jass.GetHandleId(state.飞刀)}:${state.命中次数}`;
  添加单位暂停(target, source);
  jass.SetUnitVertexColor(target, 255, 255, 255, 122);
  addDelayedCallback(配置.RE.单次时停秒 * 1000, RE解除短暂停, { 单位: target, 来源: source } as RE解停参数);

  if (state.命中次数 >= 配置.RE.最大命中次数) {
    结束RE(state);
    return;
  }
  const candidates = RE枚举目标(state, jass.GetUnitX(target), jass.GetUnitY(target), 配置.RE.搜索半径);
  if (candidates.length <= 0) {
    结束RE(state);
    return;
  }
  state.当前目标 = candidates[jass.GetRandomInt(0, candidates.length - 1) as number];
  state.角度 = 两点角度(jass.GetUnitX(state.飞刀), jass.GetUnitY(state.飞刀), jass.GetUnitX(state.当前目标), jass.GetUnitY(state.当前目标));
  state.每Tick位移 = 配置.RE.锁定后步长;
  jass.SetUnitFacing(state.飞刀, state.角度);
}

function 推进RE(this: void, variable?: any): void {
  const state = variable as RE状态 | undefined;
  if (state == null || state.已结束) return;
  if (!单位存活(state.施法者) || !单位存活(state.飞刀) || state.已飞行距离 >= state.最大距离) {
    结束RE(state);
    return;
  }
  if (state.当前目标 != null && state.当前目标 !== 0 && 单位存活(state.当前目标)) {
    state.角度 = 两点角度(jass.GetUnitX(state.飞刀), jass.GetUnitY(state.飞刀), jass.GetUnitX(state.当前目标), jass.GetUnitY(state.当前目标));
    jass.SetUnitFacing(state.飞刀, state.角度);
  }
  const x = 极坐标X(jass.GetUnitX(state.飞刀), state.每Tick位移, state.角度);
  const y = 极坐标Y(jass.GetUnitY(state.飞刀), state.每Tick位移, state.角度);
  jass.SetUnitX(state.飞刀, x);
  jass.SetUnitY(state.飞刀, y);
  state.已飞行距离 += state.每Tick位移;
  const targets = RE枚举目标(state, x, y, 配置.RE.命中半径);
  if (targets.length > 0) RE命中(state, targets[0]);
}

function 释放十六夜咲夜RE(this: void, _listener: RE监听上下文, caster: any, 技能实例ID?: number): void {
  设置十六夜咲夜符卡书冷却(caster, 配置.符卡间隔秒.RE);
  const x = jass.GetUnitX(caster) as number;
  const y = jass.GetUnitY(caster) as number;
  const angle = 两点角度(x, y, jass.GetSpellTargetX(), jass.GetSpellTargetY());
  const knife = 创建咲夜单位壳(caster, 配置.单位壳.光速红刀, 极坐标X(x, 配置.RE.创建距离, angle), 极坐标Y(y, 配置.RE.创建距离, angle), angle);
  if (knife == null || knife === 0) {
    结束独立技能伤害实例(技能实例ID);
    return;
  }
  const state: RE状态 = {
    施法者: caster,
    飞刀: knife,
    技能实例ID,
    伤害: 读取单位攻击力(caster) * 配置.RE.伤害攻击力倍率,
    角度: angle,
    每Tick位移: 配置.RE.首段步长,
    已飞行距离: 0,
    最大距离: 12000,
    当前目标: null,
    已命中: {},
    命中次数: 0,
    周期ID: 0,
    已结束: false,
  };
  登记咲夜飞刀({
    单位: knife,
    主人: caster,
    取角度: function 取RE角度(this: void): number { return state.角度; },
    设置角度: function 设置RE角度(this: void, value: number): void { state.角度 = value; jass.SetUnitFacing(knife, value); },
    取每Tick位移: function 取RE步长(this: void): number { return state.每Tick位移; },
    设置每Tick位移: function 设置RE步长(this: void, value: number): void { state.每Tick位移 = value; },
    取已飞行距离: function 取RE距离(this: void): number { return state.已飞行距离; },
    设置已飞行距离: function 设置RE距离(this: void, value: number): void { state.已飞行距离 = value; },
    取最大距离: function 取RE最大距离(this: void): number { return state.最大距离; },
    设置最大距离: function 设置RE最大距离(this: void, value: number): void { state.最大距离 = value; },
    结束: function 结束登记RE(this: void): void { 结束RE(state); },
  });
  播放咲夜单位音效("gg_snd_IzayoiSakuya_RE", caster);
  state.周期ID = 注册咲夜周期任务(配置.RE.周期毫秒, 推进RE, state);
}

export function 注册十六夜咲夜RE(this: void): void {
  注册单位技能壳监听({
    名称: "十六夜咲夜-Silver Acute 360（RE）",
    单位类型ID: 配置.英雄单位类型ID,
    技能ID: 配置.技能.RE.类型ID,
    获取或创建上下文: 获取RE监听上下文,
    释放技能: 释放十六夜咲夜RE,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 8,
  });
}

注册十六夜咲夜RE();

export {};
