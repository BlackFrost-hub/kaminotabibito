/** @noSelfInFile */
// 祖地秘境·灵潮祭司掉落：潮印祈福徽（被动·祈福）
// 祈福：持有者施放非物品技能后，为600码内玩家英雄单位组的友军（含自己）提供5%物理与魔法抗性，持续2秒，重复施法刷新。
// 实现选型：技能事件中心施法生效监听（排除通用物品技能壳，防自我连锁）+ 临时属性效果托管器（灵印折步靴刷新式变体）；仅限英雄组单位。

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { 获取玩家英雄单位组 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  获取玩家英雄单位组: (this: void) => any;
};
const { 通用物品技能槽位配置表 } = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.02．通用物品技能槽位配置") as {
  通用物品技能槽位配置表: { 技能ID: string }[];
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
import { 创建单位临时属性效果托管器 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/19．临时属性效果";
import { 创建装备玩家属性项, 装备属性键 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/23．装备属性定义";
import {
    单位持有装备,
    单位存活,
    播放单位特效,
    装备小特效,
    祖地秘境战利品装备名,
} from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 常规BuffID } = require("系统.05．Buff系统.03．Buff表.00．Buff登记") as {
  常规BuffID: { 潮印祈福徽_祈福: string };
};

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const ForGroup = jass.ForGroup as (this: void, whichGroup: any, callback: () => void) => void;
const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;

const 祈福半径 = 600;
const 祈福持续秒 = 2;
const 祈福双抗 = 0.05;
const 祈福属性效果 = 创建单位临时属性效果托管器();

// ForGroup 回调无参数，用模块级暂存传递施法来源；回调结束后清空。
let 当前祈福施法者: any = null;

// 全部装备主动物品（含旧主动物品）统一走 IU/IP/IN 通用壳；命中即视为物品技能来源，不触发祈福。
const 物品壳技能ID集合: Record<number, boolean | undefined> = {};
for (const 配置 of 通用物品技能槽位配置表) {
  物品壳技能ID集合[stringToFourCCSafe(配置.技能ID)] = true;
}

function 清除祈福属性(this: void, unit: any, _buffID: string, _row: any): void {
    祈福属性效果.清除(unit);
}

function 对组内英雄施加祈福(this: void): void {
    const caster = 当前祈福施法者;
    if (caster == null || caster === 0) return;
    const ally = GetEnumUnit();
    if (!单位存活(ally)) return;
    const dx = GetUnitX(ally) - GetUnitX(caster);
    const dy = GetUnitY(ally) - GetUnitY(caster);
    if (dx * dx + dy * dy > 祈福半径 * 祈福半径) return;
    // 先刷新 Buff（移除旧行回调清除托管器），再施加新属性，实现刷新语义。
    registerManualBuff(ally, 常规BuffID.潮印祈福徽_祈福, 祈福持续秒, 祈福双抗, {
        sourceUnit: caster,
        effectSourceName: 祖地秘境战利品装备名.潮印祈福徽,
        effectSourceType: "装备",
        effectValue2: 祈福双抗,
        onRemove: 清除祈福属性,
    });
    祈福属性效果.施加(ally, 0, [
        创建装备玩家属性项(装备属性键.物理抗性, 祈福双抗),
        创建装备玩家属性项(装备属性键.魔法抗性, 祈福双抗),
    ]);
    播放单位特效(装备小特效.护盾闪光, ally, "origin", 1, 0.5);
}

function on祈福施法(this: void, caster: any, spellAbilityId: number): void {
    if (物品壳技能ID集合[spellAbilityId] === true) return;
    if (!单位持有装备(caster, 祖地秘境战利品装备名.潮印祈福徽)) return;
    if (!单位存活(caster)) return;
    const 玩家英雄单位组 = 获取玩家英雄单位组();
    if (玩家英雄单位组 == null || 玩家英雄单位组 === 0) return;
    // 直接遍历玩家英雄单位组：只对组内的玩家英雄生效，属性加在玩家表上天然不叠加。
    当前祈福施法者 = caster;
    ForGroup(玩家英雄单位组, 对组内英雄施加祈福);
    当前祈福施法者 = null;
}

registerSpellEffectListener(on祈福施法);
export {};
