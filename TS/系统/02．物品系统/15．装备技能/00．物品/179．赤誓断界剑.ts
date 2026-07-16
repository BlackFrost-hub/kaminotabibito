/** @noSelfInFile */
import { 添加强化普攻 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/21．攻击效果/04．强化普攻';
import { 获取扇形区域单位 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/09．形状区域/扇形区域';
import { 注册战斗自身位移完成监听 } from '../../../03．技能系统/00．技能模板+函数/02．通用函数/20．位移技能限制';
import {
    单位持有装备,
    取装备冷却键,
    装备冷却就绪,
    进入装备冷却并显示,
    是敌对单位,
    取攻击力,
    取最大生命,
    开始通用护盾,
    造成装备伤害,
    播放单位特效,
    四Boss战利品装备名,
    四Boss装备特效,
    装备伤害类型,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
const jass = require('jass.common') as any;
function on赤誓位移(this: void, unit: any): void {
    if (!单位持有装备(unit, 四Boss战利品装备名.赤誓断界剑)) return;
    const key = 取装备冷却键(unit, '誓锋壁进');
    if (!装备冷却就绪(key)) return;
    进入装备冷却并显示(key, 10, unit, 四Boss战利品装备名.赤誓断界剑);
    添加强化普攻({
        单位: unit,
        名称: '誓锋壁进',
        持续时间: 8,
        次数: 1,
        伤害倍率: 1.3,
        on命中: function on誓锋命中(this: void, c): void {
            const sx = jass.GetUnitX(c.单位),
                sy = jass.GetUnitY(c.单位),
                tx = jass.GetUnitX(c.目标),
                ty = jass.GetUnitY(c.目标);
            const angle = jass.Atan2(ty - sy, tx - sx) * 57.2957795;
            const units = 获取扇形区域单位({
                X: sx,
                Y: sy,
                半径: 360,
                方向角: angle,
                扇形角度: 100,
                单位筛选: (u) => u !== c.目标 && 是敌对单位(c.单位, u),
            });
            for (let i = 0; i < units.length; i++)
                造成装备伤害(c.单位, units[i], 取攻击力(c.单位) * 0.7, 装备伤害类型.物理, false, undefined, {
                    装备技能类型: '普攻强化',
                    标签: '誓锋壁进',
                    伤害形态: 'AOE',
                });
            开始通用护盾(c.单位, c.单位, 取最大生命(c.单位) * 0.08, 4, '誓锋壁进');
            播放单位特效(四Boss装备特效.誓盾, c.单位, 'origin', 1, 0.35);
        },
    });
}
注册战斗自身位移完成监听(on赤誓位移);
export {};
