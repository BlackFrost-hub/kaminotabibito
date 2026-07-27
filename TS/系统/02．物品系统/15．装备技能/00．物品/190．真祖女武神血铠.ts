/** @noSelfInFile */
import { 注册最终伤害触发模板, type 最终伤害触发事件 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板';
import { 创建事件叠层状态 } from '../../../03．技能系统/00．技能模板+函数/04．机制组件/01．层数状态/05．事件叠层状态';
import type { 层数变化事件 } from '../../../03．技能系统/00．技能模板+函数/04．机制组件/01．层数状态/01．可配置层数状态';
import { 施加临时属性效果 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/19．临时属性效果';
import {
    单位持有装备,
    取最大生命,
    开始通用护盾,
    播放单位特效,
    四Boss战利品装备名,
    四Boss装备特效,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
import { 常规BuffID } from '../../../05．Buff系统/03．Buff表/00．Buff登记';
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
    registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
    移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const 血宴武装触发生命比例 = 0.35;
const 血晶获得特效缩放 = 0.066;

function 过滤血晶伤害(this: void, e: any): boolean {
    return 单位持有装备(e.单位, 四Boss战利品装备名.真祖女武神血铠) &&
        (e.伤害值 ?? 0) >= 取最大生命(e.单位) * 0.06 &&
        e.伤害快照?.isDotDamage !== true &&
        e.伤害快照?.isReflectedDamage !== true &&
        e.伤害快照?.isDamageTransfer !== true &&
        e.伤害快照?.isEquipmentSkillDamage !== true;
}

function 同步血晶Buff(this: void, unit: any, layers: number): void {
    registerManualBuff(unit, 常规BuffID.真祖女武神血铠_血晶, 12, 0, {
        sourceUnit: unit,
        effectSourceName: 四Boss战利品装备名.真祖女武神血铠,
        effectSourceType: '装备',
        stack: layers,
    });
}

function on血晶层数变化(this: void, event: 层数变化事件): void {
    if (event.新层数 <= 0) 移除单位指定Buff(event.单位, 常规BuffID.真祖女武神血铠_血晶);
}

function 触发血宴武装(this: void, unit: any): void {
    const layers = 血晶.消耗全部(unit, '血宴武装');
    if (layers <= 0) return;
    开始通用护盾(unit, unit, 取最大生命(unit) * (0.05 + layers * 0.04), 6, '血宴武装');
    施加临时属性效果(unit, 6000, [{ 类型: '攻速', 数值: layers * 0.18 }]);
    播放单位特效(四Boss装备特效.血晶重构, unit, 'origin', 1.5, 0.32);
}

function 血宴武装有可消耗血晶(this: void, event: 最终伤害触发事件): boolean {
    return 血晶.取层数(event.持有者) > 0;
}

function on血宴武装触发(this: void, event: 最终伤害触发事件): void {
    触发血宴武装(event.持有者);
}

function on血晶获得(this: void, e: any, newLayers: number): void {
    播放单位特效(四Boss装备特效.血晶球壳, e.单位, 'origin', 1, 血晶获得特效缩放);
    同步血晶Buff(e.单位, newLayers);
}

const 血晶 = 创建事件叠层状态({
    状态ID: '真祖女武神血铠-血晶',
    最大层数: 3,
    触发来源: '受到伤害',
    内置CD秒: 2,
    持续模式: '刷新持续时间',
    层持续秒: 12,
    on层数变化: on血晶层数变化,
    过滤事件: 过滤血晶伤害,
    on事件触发: on血晶获得,
});
注册最终伤害触发模板({
    名称: '真祖女武神血铠-血宴武装',
    装备名: 四Boss战利品装备名.真祖女武神血铠,
    持有者: '受击者',
    要求双方存活: false,
    受击后生命比例上限: 血宴武装触发生命比例,
    自定义过滤: 血宴武装有可消耗血晶,
    on触发: on血宴武装触发,
});
export {};
