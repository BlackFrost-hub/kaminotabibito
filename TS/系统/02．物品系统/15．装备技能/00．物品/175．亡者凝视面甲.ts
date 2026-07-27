/** @noSelfInFile */
import { 创建单位时限标记 } from '../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/14．单位时限标记';
import {
    单位持有装备,
    取装备冷却键,
    装备冷却就绪,
    进入装备冷却并显示,
    播放单位特效,
    四Boss战利品装备名,
    四Boss装备特效,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
import { 目标正面朝向来源 } from '../../../03．技能系统/00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { registerManualBuff, 移除单位指定Buff } from '../../../05．Buff系统/00．Buff系统';
import { 常规BuffID } from '../../../05．Buff系统/03．Buff表/00．Buff登记';
const { registerDamageModifier } = require('系统.04．伤害系统.00．伤害计算.06．伤害修正回调') as {
    registerDamageModifier: (this: void, cb: (this: void, c: any) => number, p?: number) => number;
};
const 反击强化 = 创建单位时限标记('亡者凝视面甲-反击强化');
const 反击强化持续秒 = 5;
const 反击伤害阈值 = 1000;
const 反击强化内置冷却秒 = 1;

function 清除亡者反击强化(this: void, unit: any, _buffID: string, _row: any): void {
    反击强化.清空(unit);
}

function 尝试获得亡者反击强化(this: void, unit: any): void {
    const key = 取装备冷却键(unit, '亡者凝视反击强化');
    if (!装备冷却就绪(key)) return;
    进入装备冷却并显示(key, 反击强化内置冷却秒, unit, 四Boss战利品装备名.亡者凝视面甲);
    registerManualBuff(unit, 常规BuffID.亡者凝视面甲_亡者反击, 反击强化持续秒, 0.25, {
        sourceUnit: unit,
        effectSourceName: 四Boss战利品装备名.亡者凝视面甲,
        effectSourceType: '装备',
        effectValue2: 反击伤害阈值,
        onRemove: 清除亡者反击强化,
    });
    反击强化.标记(unit, 反击强化持续秒);
    播放单位特效(四Boss装备特效.灵魂崩解, unit, 'overhead', 0.8, 0.18);
}

registerDamageModifier(function 亡者凝视正面减伤(this: void, c: any): number {
    let result = c.currentDamage;
    if (
        反击强化.存在(c.attacker) &&
        ((c.isNormalAttack === true && c.isSkillAttack !== true && c.isSkillDamage !== true) ||
            c.isSingleTargetSkillDamage === true)
    ) {
        反击强化.消耗(c.attacker);
        移除单位指定Buff(c.attacker, 常规BuffID.亡者凝视面甲_亡者反击);
        result *= 1.25;
    }
    if (
        !单位持有装备(c.target, 四Boss战利品装备名.亡者凝视面甲) ||
        !目标正面朝向来源(c.attacker, c.target, 100) ||
        c.isDotDamage === true ||
        c.isReflectedDamage === true ||
        c.isDamageTransfer === true
    )
        return result;
    if (result >= 反击伤害阈值) 尝试获得亡者反击强化(c.target);
    return result * 0.82;
}, 25);
export {};
