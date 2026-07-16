/** @noSelfInFile */
import { 注册最终伤害触发模板 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板';
import {
    是AOE技能伤害,
    取攻击力,
    取范围敌人,
    造成装备伤害,
    播放点特效,
    四Boss战利品装备名,
    四Boss装备特效,
    装备伤害类型,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
const jass = require('jass.common') as any;
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as any;
注册最终伤害触发模板({
    名称: '英灵送葬法典',
    装备名: 四Boss战利品装备名.英灵送葬法典,
    伤害过滤: '技能',
    冷却秒数: 10,
    自定义过滤: (e) => 是AOE技能伤害(e.伤害快照),
    on触发(e): void {
        const s = e.持有者,
            t = e.目标,
            x = jass.GetUnitX(t),
            y = jass.GetUnitY(t);
        播放点特效(四Boss装备特效.英灵陨星预警, x, y, 1, 0.55);
        addDelayedCallback(900, function 英灵送葬(this: void): void {
            播放点特效(四Boss装备特效.英灵陨星, x, y, 1, 0.65);
            播放点特效(四Boss装备特效.英灵陨星落地, x, y, 1, 0.5);
            const us = 取范围敌人(s, t, 300),
                d = 取攻击力(s) * 0.65 + 350;
            for (let i = 0; i < us.length; i++)
                造成装备伤害(s, us[i], d, 装备伤害类型.魔法, true, undefined, {
                    装备技能类型: '装备被动',
                    标签: '英灵送葬',
                    伤害形态: 'AOE',
                });
        });
    },
});
export {};
