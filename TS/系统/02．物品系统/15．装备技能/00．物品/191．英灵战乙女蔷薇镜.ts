/** @noSelfInFile */
import { 注册不同技能伤害序列触发模板 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板/06．不同技能伤害序列触发模板';
import { 创建固定时间轴阶段列表 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂';
import { 开始技能阶段链 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/01．多阶段技能编排/06．技能阶段链执行器';
import {
    是AOE技能伤害,
    取坐标范围敌人,
    造成装备伤害,
    播放点特效,
    四Boss战利品装备名,
    四Boss装备特效,
    装备伤害类型,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
const jass = require('jass.common') as any;
注册不同技能伤害序列触发模板({
    名称: '英灵战乙女蔷薇镜',
    装备名: 四Boss战利品装备名.英灵战乙女蔷薇镜,
    需要不同技能数: 3,
    时间窗毫秒: 12000,
    作用域: '主体',
    重复策略: '忽略',
    触发时机: '下一次技能伤害',
    on触发: (e) => {
        const target = e.目标,
            attacker = e.攻击者,
            x = jass.GetUnitX(target),
            y = jass.GetUnitY(target),
            damage = e.本次伤害 * 0.45,
            aoe = 是AOE技能伤害(e.伤害快照);
        播放点特效(四Boss装备特效.蔷薇镜像扩散, x, y, 0.8, 0.35);
        开始技能阶段链(
            attacker,
            创建固定时间轴阶段列表([
                {
                    时点毫秒: 650,
                    名称: '英灵镜像复刻',
                    执行: function on镜像复刻结算(this: void): void {
                        if (aoe) {
                            const units = 取坐标范围敌人(attacker, x, y, 280);
                            for (let i = 0; i < units.length; i++)
                                造成装备伤害(attacker, units[i], damage, 装备伤害类型.魔法, false, undefined, {
                                    装备技能类型: '装备被动',
                                    标签: '英灵复刻',
                                    伤害形态: 'AOE',
                                });
                        } else
                            造成装备伤害(attacker, target, damage, 装备伤害类型.魔法, false, undefined, {
                                装备技能类型: '装备被动',
                                标签: '英灵复刻',
                                伤害形态: '单体',
                            });
                    },
                },
            ]),
        );
    },
});
export {};
