/** @noSelfInFile */
import { 注册最终伤害触发模板 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板';
import {
    取攻击力,
    取坐标范围敌人,
    造成装备伤害,
    播放点特效,
    四Boss战利品装备名,
    四Boss装备特效,
    装备伤害类型,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
const jass = require('jass.common') as any;
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
    addDelayedCallback: (this: void, ms: number, cb: (this: void) => void) => number;
};
注册最终伤害触发模板({
    名称: '亡冥归魂巨剑-归魂回斩',
    装备名: 四Boss战利品装备名.亡冥归魂巨剑,
    伤害过滤: '技能',
    冷却秒数: 8,
    on触发(event): void {
        const source = event.持有者;
        const x = jass.GetUnitX(event.目标);
        const y = jass.GetUnitY(event.目标);
        addDelayedCallback(600, function 归魂回斩(this: void): void {
            播放点特效(四Boss装备特效.归魂剑痕, x, y, 1, 1.1);
            const units = 取坐标范围敌人(source, x, y, 280);
            const damage = 取攻击力(source) * 0.75;
            for (let i = 0; i < units.length; i++)
                造成装备伤害(source, units[i], damage, 装备伤害类型.物理, false, undefined, {
                    装备技能类型: '装备被动',
                    标签: '归魂回斩',
                    伤害形态: 'AOE',
                });
        });
    },
});
export {};
