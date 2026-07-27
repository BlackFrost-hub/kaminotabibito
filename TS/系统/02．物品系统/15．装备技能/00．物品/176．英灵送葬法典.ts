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
const { 创建点特效 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
    创建点特效: (this: void, 参数: any) => any;
};

interface 英灵送葬结算上下文 {
    来源: any;
    目标: any;
    X: number;
    Y: number;
}

function 过滤英灵送葬伤害(this: void, e: any): boolean {
    return 是AOE技能伤害(e.伤害快照);
}

function 结算英灵送葬(this: void, context: 英灵送葬结算上下文): void {
    创建点特效({ 模型路径: 四Boss装备特效.英灵陨星, X: context.X, Y: context.Y, Z: 80, 持续秒: 0.8, 缩放: 0.02 });
    创建点特效({ 模型路径: 四Boss装备特效.英灵陨星落地, X: context.X, Y: context.Y, Z: 80, 持续秒: 0.4, 缩放: 0.01 });
    const us = 取范围敌人(context.来源, context.目标, 300);
    const d = 取攻击力(context.来源) * 0.65 + 350;
    for (let i = 0; i < us.length; i++)
        造成装备伤害(context.来源, us[i], d, 装备伤害类型.魔法, true, undefined, {
            装备技能类型: '装备被动',
            标签: '英灵送葬',
            伤害形态: 'AOE',
        });
}

function on英灵送葬触发(this: void, e: any): void {
    const s = e.持有者;
    const t = e.目标;
    const x = jass.GetUnitX(t);
    const y = jass.GetUnitY(t);
    播放点特效(四Boss装备特效.英灵陨星预警, x, y, 1, 0.55);
    addDelayedCallback(900, 结算英灵送葬, { 来源: s, 目标: t, X: x, Y: y });
}

注册最终伤害触发模板({
    名称: '英灵送葬法典',
    装备名: 四Boss战利品装备名.英灵送葬法典,
    伤害过滤: '技能',
    冷却秒数: 10,
    自定义过滤: 过滤英灵送葬伤害,
    on触发: on英灵送葬触发,
});
export {};
