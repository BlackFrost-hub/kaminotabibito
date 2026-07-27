/** @noSelfInFile */
import {
    添加强化普攻,
    清除强化普攻,
    type 强化普攻结束上下文,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/21．攻击效果/04．强化普攻';
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
import { registerManualBuff, 移除单位指定Buff } from '../../../05．Buff系统/00．Buff系统';
import { 常规BuffID } from '../../../05．Buff系统/03．Buff表/00．Buff登记';
const jass = require('jass.common') as any;
const GetHandleId = jass.GetHandleId as (unit: any) => number;
const 誓锋壁进状态名 = '誓锋壁进';
const 赤誓Buff移除中: Record<number, boolean | undefined> = {};
const 赤誓强化结束中: Record<number, boolean | undefined> = {};

function 取赤誓单位ID(this: void, unit: any): number {
    if (unit == null || unit === 0) return 0;
    return GetHandleId(unit) || 0;
}

function on誓锋Buff移除(this: void, unit: any, _buffID: string, _row: any): void {
    const id = 取赤誓单位ID(unit);
    if (id !== 0 && 赤誓强化结束中[id] === true) return;
    if (id !== 0) 赤誓Buff移除中[id] = true;
    清除强化普攻(unit, 誓锋壁进状态名);
    if (id !== 0) delete 赤誓Buff移除中[id];
}

function on誓锋强化结束(this: void, context: 强化普攻结束上下文): void {
    const id = 取赤誓单位ID(context.单位);
    if (id !== 0 && 赤誓Buff移除中[id] === true) return;
    if (id !== 0) 赤誓强化结束中[id] = true;
    移除单位指定Buff(context.单位, 常规BuffID.赤誓断界剑_誓锋壁进);
    if (id !== 0) delete 赤誓强化结束中[id];
}

function on誓锋命中(this: void, c: any): void {
    const sx = jass.GetUnitX(c.单位);
    const sy = jass.GetUnitY(c.单位);
    const tx = jass.GetUnitX(c.目标);
    const ty = jass.GetUnitY(c.目标);
    const angle = jass.Atan2(ty - sy, tx - sx) * 57.2957795;
    const units = 获取扇形区域单位({
        X: sx,
        Y: sy,
        半径: 360,
        方向角: angle,
        扇形角度: 100,
    });
    for (let i = 0; i < units.length; i++) {
        if (units[i] === c.目标 || !是敌对单位(c.单位, units[i])) continue;
        造成装备伤害(c.单位, units[i], 取攻击力(c.单位) * 0.7, 装备伤害类型.物理, false, undefined, {
            装备技能类型: '普攻强化',
            标签: '誓锋壁进',
            伤害形态: 'AOE',
        });
    }
    开始通用护盾(c.单位, c.单位, 取最大生命(c.单位) * 0.08, 4, '誓锋壁进');
    播放单位特效(四Boss装备特效.誓盾, c.单位, 'origin', 1, 0.35);
}

function on赤誓位移(this: void, unit: any): void {
    if (!单位持有装备(unit, 四Boss战利品装备名.赤誓断界剑)) return;
    const key = 取装备冷却键(unit, '誓锋壁进');
    if (!装备冷却就绪(key)) return;
    进入装备冷却并显示(key, 10, unit, 四Boss战利品装备名.赤誓断界剑);
    移除单位指定Buff(unit, 常规BuffID.赤誓断界剑_誓锋壁进);
    const added = 添加强化普攻({
        单位: unit,
        名称: 誓锋壁进状态名,
        持续时间: 8,
        次数: 1,
        伤害倍率: 1.3,
        on命中: on誓锋命中,
        on结束: on誓锋强化结束,
    });
    if (!added) return;
    registerManualBuff(unit, 常规BuffID.赤誓断界剑_誓锋壁进, 8, 0.3, {
        sourceUnit: unit,
        effectSourceName: 四Boss战利品装备名.赤誓断界剑,
        effectSourceType: '装备',
        onRemove: on誓锋Buff移除,
    });
}
注册战斗自身位移完成监听(on赤誓位移);
export {};
