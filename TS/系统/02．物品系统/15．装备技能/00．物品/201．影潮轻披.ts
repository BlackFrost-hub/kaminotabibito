/** @noSelfInFile */
// 祖地秘境·环境互动掉落：影潮轻披（被动·影潮）
// 影潮：持有者闪避成功后1.5秒内移动速度提高20%，内置1秒冷却。
// 实现选型：闪避系统 registerDodgeAppliedFinalDamageListener（target 为闪避者）+ 施加移速提升Buff + 模块内句柄冷却表。

const { registerDodgeAppliedFinalDamageListener } = require("系统.04．伤害系统.05．闪避系统.01．闪避核心") as {
  registerDodgeAppliedFinalDamageListener: (this: void, callback: (this: void, source: any, target: any, damage: number) => void) => void;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { 施加移速提升Buff } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.04．移速提升") as {
  施加移速提升Buff: (this: void, 来源单位: any, 目标单位: any, 参数: {
    BuffID?: string;
    持续时间: number;
    固定移速?: number;
    基础移速百分比?: number;
    当前移速百分比?: number;
    图标路径?: string;
    效果来源名称?: string;
    效果来源类型?: "装备" | "技能";
  }) => boolean;
};
const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
import { 单位持有装备, 播放单位特效, 装备小特效, 祖地秘境战利品装备名 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

const 影潮移速比例 = 0.2;
const 影潮持续秒 = 1.5;
const 影潮内置冷却毫秒 = 1000;
const 影潮下次可用: Record<number, number | undefined> = {};
const 影潮披风图标 = "ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Clothes\\BTNShadowTideCloak.blp";

function on影潮闪避(this: void, _source: any, target: any, _damage: number): void {
    if (target == null || target === 0) return;
    if (!单位持有装备(target, 祖地秘境战利品装备名.影潮轻披)) return;
    const id = GetHandleId(target) || 0;
    if (id !== 0) {
        const now = getServerTime();
        if ((影潮下次可用[id] ?? 0) > now) return;
        影潮下次可用[id] = now + 影潮内置冷却毫秒;
    }
    施加移速提升Buff(target, target, {
        BuffID: 常规BuffID.影潮轻披_影潮,
        持续时间: 影潮持续秒,
        基础移速百分比: 影潮移速比例,
        图标路径: 影潮披风图标,
        效果来源名称: 祖地秘境战利品装备名.影潮轻披,
        效果来源类型: "装备",
    });
    播放单位特效(装备小特效.小风爆, target, "origin", 1, 0.5);
}

registerDodgeAppliedFinalDamageListener(on影潮闪避);
export {};
