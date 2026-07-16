/** @noSelfInFile */
import { 开始主动技能前摇预警执行模板 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/04．主动技能流程模板/01．前摇预警执行模板';
import {
    取坐标范围敌人,
    造成装备伤害,
    播放点特效,
    四Boss装备特效,
    装备伤害类型,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
const jass = require('jass.common') as any;
export function 处理超位魔法残章天空坠落使用(this: void, ctx: any): void {
    const caster = ctx.施法单位,
        x = ctx.目标X,
        y = ctx.目标Y;
    开始主动技能前摇预警执行模板({
        施法者: caster,
        目标X: x,
        目标Y: y,
        前摇: {
            持续时间: 2.5,
            强制硬直: true,
            允许自我打断: true,
            施法动作名: 'spell',
            开始回调: function on天空坠落开始(this: void): void {
                播放点特效(四Boss装备特效.天空法阵, x, y, 2.6, 0.75);
            },
        },
        提示圈: { 类型: '敌方圆形', X: x, Y: y, 半径: 500, 持续时间: 2.5, 来源单位: caster },
        执行: function on天空坠落结算(this: void): void {
            播放点特效(四Boss装备特效.天空光柱, x, y, 1.2, 0.8);
            播放点特效(四Boss装备特效.天空冲击, x, y, 1.5, 0.85);
            const units = 取坐标范围敌人(caster, x, y, 500),
                damage = 1800 + jass.GetHeroInt(caster, true) * 7;
            for (let i = 0; i < units.length; i++)
                造成装备伤害(caster, units[i], damage, 装备伤害类型.魔法, true, undefined, {
                    装备技能类型: '装备主动',
                    物品ID: jass.GetItemTypeId(ctx.物品),
                    物品实例: ctx.物品,
                    技能ID: ctx.技能ID,
                    标签: '天空坠落',
                    伤害形态: 'AOE',
                });
        },
    });
}
export {};
