/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";
import { 两点角度, 创建咲夜单位壳, 安全移除单位壳, 极坐标X, 极坐标Y, 单位存活, 播放咲夜单位音效, 注册咲夜周期任务, 移除咲夜周期任务, 登记咲夜飞刀, 注销咲夜飞刀 } from "./01．飞刀与时间工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 设置十六夜咲夜符卡书冷却 } from "./符卡公共";
import { 获取坐标范围单位按筛选 } from "../../../00．技能模板+函数/02．通用函数/02．单位与范围";

const jass = require("jass.common") as any;
const { 造成单体技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};

interface RC监听上下文 { 占位: boolean; }
interface RC状态 {
  施法者: any;
  飞刀: any;
  技能实例ID?: number;
  角度: number;
  每Tick位移: number;
  已飞行距离: number;
  最大距离: number;
  伤害: number;
  反弹次数: number;
  上次命中单位: any;
  周期ID: number;
  已结束: boolean;
}

function 获取RC监听上下文(this: void, _caster: any): RC监听上下文 { return { 占位: true }; }

function 结束RC(this: void, state: RC状态): void {
  if (state.已结束) return;
  state.已结束 = true;
  if (state.周期ID !== 0) 移除咲夜周期任务(state.周期ID);
  注销咲夜飞刀(state.飞刀);
  安全移除单位壳(state.飞刀);
  结束独立技能伤害实例(state.技能实例ID);
}

/**
 * 命中目标选取。源规则：排除上次命中 + 存活 + 敌对 + 排除 Ancient（放行建筑/机械/古树），
 * 返回第一个合法目标。配置型筛选逐项等价：要求有效单位=false 跳过四重过滤、
 * 允许死亡=false 排除死亡、允许无敌=true 保持源语义、仅敌人 排除非敌对（含施法者自身）、
 * 自定义条件 排除上次命中与 Ancient。
 */
function RC取命中目标(this: void, state: RC状态, x: number, y: number): any {
  const 候选 = 获取坐标范围单位按筛选(x, y, 配置.RC.命中半径, state.施法者, {
    要求有效单位: false,
    允许死亡: false,
    允许建筑: true,
    允许机械: true,
    允许古树: true,
    允许无敌: true,
    仅敌人: true,
    自定义条件: (u: any) => u !== state.上次命中单位 && !jass.IsUnitType(u, jass.UNIT_TYPE_ANCIENT),
  });
  return 候选.length > 0 ? 候选[0] : null;
}

function RC执行反弹(this: void, state: RC状态, nextAngle: number): void {
  state.反弹次数 += 1;
  state.角度 = nextAngle;
  state.每Tick位移 *= 1 - 配置.RC.每次衰减;
  state.伤害 *= 1 - 配置.RC.每次衰减;
  jass.SetUnitFacing(state.飞刀, state.角度);
}

function 推进RC(this: void, variable?: any): void {
  const state = variable as RC状态 | undefined;
  if (state == null || state.已结束) return;
  if (!单位存活(state.施法者) || !单位存活(state.飞刀) || state.已飞行距离 >= state.最大距离 || state.反弹次数 >= 配置.RC.最大反弹次数) {
    结束RC(state);
    return;
  }
  const currentX = jass.GetUnitX(state.飞刀) as number;
  const currentY = jass.GetUnitY(state.飞刀) as number;
  const x = 极坐标X(currentX, state.每Tick位移, state.角度);
  const y = 极坐标Y(currentY, state.每Tick位移, state.角度);
  if (jass.IsTerrainPathable(x, y, jass.PATHING_TYPE_WALKABILITY)) {
    state.上次命中单位 = null;
    RC执行反弹(state, state.角度 + 180);
    return;
  }
  jass.SetUnitX(state.飞刀, x);
  jass.SetUnitY(state.飞刀, y);
  state.已飞行距离 += state.每Tick位移;
  const target = RC取命中目标(state, x, y);
  if (target == null || target === 0) {
    state.上次命中单位 = null;
    return;
  }
  造成单体技能伤害({
    来源: state.施法者,
    目标: target,
    伤害: state.伤害,
    伤害类型: jass.DAMAGE_TYPE_ENHANCED,
    attack: false,
    ranged: true,
    attackType: jass.ATTACK_TYPE_NORMAL,
    weaponType: jass.WEAPON_TYPE_METAL_HEAVY_SLICE,
    来源类型: "单位技能",
    标签: "十六夜咲夜-RC-闪光弹跳",
    技能ID: 配置.技能.RC.类型ID,
    技能实例ID: state.技能实例ID,
  });
  state.上次命中单位 = target;
  RC执行反弹(state, state.角度 + 180);
}

function 释放十六夜咲夜RC(this: void, _listener: RC监听上下文, caster: any, 技能实例ID?: number): void {
  设置十六夜咲夜符卡书冷却(caster, 配置.符卡间隔秒.RC);
  const x = jass.GetUnitX(caster) as number;
  const y = jass.GetUnitY(caster) as number;
  const angle = 两点角度(x, y, jass.GetSpellTargetX(), jass.GetSpellTargetY());
  const knife = 创建咲夜单位壳(caster, 配置.单位壳.光速红刀, 极坐标X(x, 配置.RC.创建距离, angle), 极坐标Y(y, 配置.RC.创建距离, angle), angle);
  if (knife == null || knife === 0) {
    结束独立技能伤害实例(技能实例ID);
    return;
  }
  jass.SetUnitScale(knife, 配置.RC.缩放, 配置.RC.缩放, 配置.RC.缩放);
  const state: RC状态 = {
    施法者: caster,
    飞刀: knife,
    技能实例ID,
    角度: angle,
    每Tick位移: 配置.RC.初始每Tick位移,
    已飞行距离: 0,
    最大距离: 配置.RC.最大距离,
    伤害: 读取单位攻击力(caster) * 配置.RC.初始伤害攻击力倍率,
    反弹次数: 0,
    上次命中单位: null,
    周期ID: 0,
    已结束: false,
  };
  登记咲夜飞刀({
    单位: knife,
    主人: caster,
    取角度: function 取RC角度(this: void): number { return state.角度; },
    设置角度: function 设置RC角度(this: void, value: number): void { state.角度 = value; jass.SetUnitFacing(knife, value); },
    取每Tick位移: function 取RC步长(this: void): number { return state.每Tick位移; },
    设置每Tick位移: function 设置RC步长(this: void, value: number): void { state.每Tick位移 = value; },
    取已飞行距离: function 取RC距离(this: void): number { return state.已飞行距离; },
    设置已飞行距离: function 设置RC距离(this: void, value: number): void { state.已飞行距离 = value; },
    取最大距离: function 取RC最大距离(this: void): number { return state.最大距离; },
    设置最大距离: function 设置RC最大距离(this: void, value: number): void { state.最大距离 = value; },
    结束: function 结束登记RC(this: void): void { 结束RC(state); },
  });
  播放咲夜单位音效("gg_snd_IzayoiSakuya_RE", caster);
  播放咲夜单位音效("gg_snd_feidaoYX", caster);
  state.周期ID = 注册咲夜周期任务(配置.RC.周期毫秒, 推进RC, state);
}

export function 注册十六夜咲夜RC(this: void): void {
  注册单位技能壳监听({
    名称: "十六夜咲夜-闪光弹跳（RC）",
    单位类型ID: 配置.英雄单位类型ID,
    技能ID: 配置.技能.RC.类型ID,
    获取或创建上下文: 获取RC监听上下文,
    释放技能: 释放十六夜咲夜RC,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 12,
  });
}

注册十六夜咲夜RC();

export {};
