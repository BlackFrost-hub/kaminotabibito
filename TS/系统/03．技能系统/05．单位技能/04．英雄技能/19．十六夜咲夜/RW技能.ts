/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";
import { 创建直线飞刀, 创建咲夜单位壳, 安全移除单位壳, 两点角度, 极坐标X, 极坐标Y, 播放咲夜单位音效, 施加短硬直并播放动作, 注册咲夜周期任务, 移除咲夜周期任务, type 直线飞刀状态 } from "./01．飞刀与时间工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 设置十六夜咲夜符卡书冷却 } from "./符卡公共";
import { 十六夜咲夜处于咲夜世界 } from "./RR技能";

const jass = require("jass.common") as any;
const { 造成单体技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};

interface RW监听上下文 { 占位: boolean; }
interface RW施法上下文 {
  施法者: any;
  技能实例ID?: number;
  目标X: number;
  目标Y: number;
  伤害: number;
  已发射: number;
  活动飞刀: number;
  发射周期ID: number;
  分身: any;
  已结束: boolean;
}

function 获取RW监听上下文(this: void, _caster: any): RW监听上下文 { return { 占位: true }; }

function 尝试结束RW(this: void, cast: RW施法上下文): void {
  if (cast.已结束 || cast.已发射 < 配置.RW.数量 || cast.活动飞刀 > 0) return;
  cast.已结束 = true;
  结束独立技能伤害实例(cast.技能实例ID);
  安全移除单位壳(cast.分身);
  cast.分身 = null;
}

function RW飞刀结束(this: void, state: 直线飞刀状态): void {
  const cast = state.自定义数据 as RW施法上下文;
  cast.活动飞刀 -= 1;
  尝试结束RW(cast);
}

function RW飞刀命中(this: void, target: any, state: 直线飞刀状态): "结束" {
  const cast = state.自定义数据 as RW施法上下文;
  造成单体技能伤害({
    来源: cast.施法者,
    目标: target,
    伤害: cast.伤害,
    伤害类型: jass.DAMAGE_TYPE_NORMAL,
    attack: false,
    ranged: true,
    attackType: jass.ATTACK_TYPE_NORMAL,
    weaponType: jass.WEAPON_TYPE_METAL_HEAVY_SLICE,
    来源类型: "单位技能",
    标签: "十六夜咲夜-RW-Eternal Meek",
    技能ID: 配置.技能.RW.类型ID,
    技能实例ID: cast.技能实例ID,
  });
  return "结束";
}

function 发射RW飞刀(this: void, variable?: any): void {
  const cast = variable as RW施法上下文 | undefined;
  if (cast == null || cast.已结束) return;
  if (cast.已发射 >= 配置.RW.数量) {
    if (cast.发射周期ID !== 0) 移除咲夜周期任务(cast.发射周期ID);
    cast.发射周期ID = 0;
    尝试结束RW(cast);
    return;
  }
  const x = jass.GetUnitX(cast.施法者) as number;
  const y = jass.GetUnitY(cast.施法者) as number;
  const baseAngle = 两点角度(x, y, cast.目标X, cast.目标Y);
  const angle = baseAngle + (jass.GetRandomReal(-配置.RW.随机角度, 配置.RW.随机角度) as number);
  const state = 创建直线飞刀({
    施法者: cast.施法者,
    单位类型ID: 配置.单位壳.蓝刀,
    X: 极坐标X(x, 配置.RW.创建距离, angle),
    Y: 极坐标Y(y, 配置.RW.创建距离, angle),
    角度: angle,
    周期毫秒: 配置.RW.周期毫秒,
    每Tick位移: 配置.RW.每Tick位移,
    最大距离: 配置.RW.最大距离,
    命中半径: 配置.RW.命中半径,
    命中回调: RW飞刀命中,
    结束回调: RW飞刀结束,
  });
  cast.已发射 += 1;
  if (state != null) {
    state.自定义数据 = cast;
    cast.活动飞刀 += 1;
  }
}

function 释放十六夜咲夜RW(this: void, _listener: RW监听上下文, caster: any, 技能实例ID?: number): void {
  设置十六夜咲夜符卡书冷却(caster, 配置.符卡间隔秒.RW);
  const cast: RW施法上下文 = {
    施法者: caster,
    技能实例ID,
    目标X: jass.GetSpellTargetX(),
    目标Y: jass.GetSpellTargetY(),
    伤害: 读取单位攻击力(caster) * 配置.RW.伤害攻击力倍率,
    已发射: 0,
    活动飞刀: 0,
    发射周期ID: 0,
    分身: null,
    已结束: false,
  };
  const x = jass.GetUnitX(caster) as number;
  const y = jass.GetUnitY(caster) as number;
  const angle = 两点角度(x, y, cast.目标X, cast.目标Y);
  if (十六夜咲夜处于咲夜世界(caster)) {
    // 源 JASS 在完美空间中使用 e00H 正常分身，不叠加施法者飞行高度。
    cast.分身 = 创建咲夜单位壳(caster, 配置.单位壳.正常分身, 极坐标X(x, 50, angle), 极坐标Y(y, 50, angle), angle);
    if (cast.分身 != null && cast.分身 !== 0) {
      jass.SetUnitFlyHeight(cast.分身, jass.GetUnitDefaultFlyHeight(cast.分身), 0);
      jass.SetUnitAnimation(cast.分身, "channel");
    }
  }
  if (!十六夜咲夜处于咲夜世界(caster)) {
    施加短硬直并播放动作(caster, `十六夜咲夜-RW:${技能实例ID ?? jass.GetHandleId(caster)}`, 配置.RW.硬直秒, "channel");
  }
  播放咲夜单位音效("gg_snd_IzayoiSakuya_RW", caster);
  发射RW飞刀(cast);
  cast.发射周期ID = 注册咲夜周期任务(配置.RW.周期毫秒, 发射RW飞刀, cast);
}

export function 注册十六夜咲夜RW(this: void): void {
  注册单位技能壳监听({
    名称: "十六夜咲夜-Eternal Meek（RW）",
    单位类型ID: 配置.英雄单位类型ID,
    技能ID: 配置.技能.RW.类型ID,
    获取或创建上下文: 获取RW监听上下文,
    释放技能: 释放十六夜咲夜RW,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 5,
  });
}

注册十六夜咲夜RW();

export {};
