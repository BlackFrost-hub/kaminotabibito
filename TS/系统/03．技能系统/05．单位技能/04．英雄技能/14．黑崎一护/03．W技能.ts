/** @noSelfInFile */
// 黑崎一护 W：灵压爆发（A01K）。400 码范围雷属性伤害 + 眩晕 + 击退，D 连携强化。
// 源 JASS 真源：技能.j（A01K 段 693-730；伤害/眩晕 Func007A 117-129；击退周期 Func009T 144-166）。
// 源辅助马甲 thunderbolt（A01N/A01O）迁移为项目 施加眩晕；击退迁移为击退封装（含地形检查）。
// 源每 tick 位移 15/25 码 × 20 tick → 总击退 300/500（连携），持续 0.4 秒。

import { 黑崎一护技能配置 } from "./00．配置";
import { 是否瞬步连携中 } from "./01．状态表";
import { 黑崎一护BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/09．黑崎一护";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始击退: (this: void, unit: any, params: any) => number;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { PlaySoundAtPointBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundAtPointBJ: (this: void, soundHandle: any, volumePercent: number, x: number, y: number, z: number) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;

const 配置 = 黑崎一护技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const W类型ID = stringToFourCC(配置.W.技能ID);

interface W上下文 {
  已启动?: boolean;
}

const W上下文表: Record<number, W上下文> = {};

function 获取或创建W上下文(this: void, unit: any): W上下文 {
  const id = GetHandleId(unit);
  let ctx = W上下文表[id];
  if (ctx == null) {
    ctx = {};
    W上下文表[id] = ctx;
  }
  return ctx;
}

function 释放灵压爆发(this: void, _context: W上下文, caster: any, 技能实例ID?: number): void {
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  const 连携 = 是否瞬步连携中(caster);
  const 分支 = 连携 ? 配置.W.连携 : 配置.W.普通;

  // 源：选取时排除“免控”单位
  const 候选 = 获取范围敌军(caster, x, y, 配置.W.半径码);
  const 敌军: any[] = [];
  if (候选 != null) {
    for (let i = 0; i < 候选.length; i++) {
      const u = 候选[i];
      if (u == null || u === 0) continue;
      if (YDUserDataGetSafe("unit", u, "免控", "boolean") === true) continue;
      敌军.push(u);
    }
  }

  创建点特效({ 模型路径: 配置.W.主特效.模型, X: x, Y: y, Z: 0, 缩放: 配置.W.主特效.缩放, 持续秒: 配置.W.主特效.持续秒 });
  创建点特效({ 模型路径: 配置.W.爆发特效.模型, X: x, Y: y, Z: 0, 缩放: 配置.W.爆发特效.缩放, 持续秒: 配置.W.爆发特效.持续秒 });
  if (连携) {
    创建点特效({ 模型路径: 配置.W.连携.附加特效.模型, X: x, Y: y, Z: 0, 缩放: 配置.W.连携.附加特效.缩放, 持续秒: 配置.W.连携.附加特效.持续秒 });
  }
  PlaySoundAtPointBJ(jglobals.gg_snd_ThunderClapCaster, 100, x, y, 0);

  const 伤害 = 读取单位攻击力(caster) * 配置.W.伤害攻击力倍率;
  for (let i = 0; i < 敌军.length; i++) {
    const target = 敌军[i];
    造成单体技能伤害({
      来源: caster,
      目标: target,
      伤害,
      伤害类型: DAMAGE_TYPE_LIGHTNING,
      attack: false,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      标签: "黑崎一护-W灵压爆发",
      技能ID: W类型ID,
      技能实例ID,
    });
    施加眩晕(caster, target, 分支.眩晕秒, "黑崎一护-灵压爆发", "技能");
    registerManualBuff(target, 黑崎一护BuffID.灵压爆发眩晕, 分支.眩晕秒, 0);
    开始击退(target, {
      来源单位: caster,
      距离: 分支.击退总距离,
      持续时间: 连携 ? 配置.W.连携.击退持续时间秒 : 0.4,
      检查地形: true,
    });
  }

  // 源：W 只读取连携开关不消耗；开关由 D 的 2 秒窗口定时或 E 连携关闭。
}

export function 注册黑崎一护W(this: void): void {
  注册单位技能壳监听({
    名称: "黑崎一护-灵压爆发（W）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.W.技能ID,
    获取或创建上下文: 获取或创建W上下文,
    释放技能: 释放灵压爆发,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 2,
  });
}

注册黑崎一护W();

export {};
