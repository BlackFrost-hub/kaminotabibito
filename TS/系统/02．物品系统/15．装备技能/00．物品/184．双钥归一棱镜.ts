/** @noSelfInFile */
import { 注册最终伤害触发模板 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板';
import { 创建单位时限标记 } from '../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/14．单位时限标记';
import { 创建句柄上下文托管器 } from '../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/24．句柄上下文托管';
import {
    取装备冷却键,
    装备冷却就绪,
    进入装备冷却并显示,
    取攻击力,
    取范围敌人,
    取最大生命,
    开始通用护盾,
    造成装备伤害,
    播放单位特效,
    四Boss战利品装备名,
    四Boss装备特效,
    装备伤害类型,
    监听装备丢弃清理,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';

const { addDelayedCallback, removeDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
    addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
    removeDelayedCallback: (this: void, id: number) => void;
};
const { createUnitEffect, destroyUnitEffect } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
    createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
    destroyUnitEffect: (this: void, unit: any, effectKey?: string) => void;
};

const 钥匙持续秒 = 6;
const 武魂钥特效路径 = 'Common\\Effect\\Form\\Aura\\EquipmentMartialSoulKeyAura.mdx';
const 灵识钥特效路径 = 'Common\\Effect\\Form\\Aura\\EquipmentSpiritKeyAura.mdx';
const 武魂钥特效键 = '双钥归一-武魂钥特效';
const 灵识钥特效键 = '双钥归一-灵识钥特效';

interface 双钥表现状态 {
    单位: any;
    武魂钥特效存在: boolean;
    灵识钥特效存在: boolean;
    武魂钥到期任务ID: number;
    灵识钥到期任务ID: number;
}

const 武魂钥 = 创建单位时限标记('双钥归一-武魂钥'),
    灵识钥 = 创建单位时限标记('双钥归一-灵识钥');
const 双钥表现 = 创建句柄上下文托管器<双钥表现状态>('双钥归一棱镜-钥匙表现');

function 获取双钥表现状态(this: void, unit: any): 双钥表现状态 {
    let state = 双钥表现.读取(unit);
    if (state != null && state.单位 === unit) return state;
    state = {
        单位: unit,
        武魂钥特效存在: false,
        灵识钥特效存在: false,
        武魂钥到期任务ID: 0,
        灵识钥到期任务ID: 0,
    };
    双钥表现.写入(unit, state);
    return state;
}

function 清理空双钥表现状态(this: void, unit: any, state: 双钥表现状态): void {
    if (state.武魂钥特效存在 || state.灵识钥特效存在) return;
    if (state.武魂钥到期任务ID > 0 || state.灵识钥到期任务ID > 0) return;
    双钥表现.清空(unit);
}

function 销毁武魂钥表现(this: void, unit: any): void {
    const state = 双钥表现.读取(unit);
    if (state != null && state.单位 === unit) {
        if (state.武魂钥到期任务ID > 0) removeDelayedCallback(state.武魂钥到期任务ID);
        state.武魂钥到期任务ID = 0;
        state.武魂钥特效存在 = false;
        清理空双钥表现状态(unit, state);
    }
    destroyUnitEffect(unit, 武魂钥特效键);
}

function 销毁灵识钥表现(this: void, unit: any): void {
    const state = 双钥表现.读取(unit);
    if (state != null && state.单位 === unit) {
        if (state.灵识钥到期任务ID > 0) removeDelayedCallback(state.灵识钥到期任务ID);
        state.灵识钥到期任务ID = 0;
        state.灵识钥特效存在 = false;
        清理空双钥表现状态(unit, state);
    }
    destroyUnitEffect(unit, 灵识钥特效键);
}

function on武魂钥到期(this: void, variable?: any): void {
    const unit = variable;
    const state = 双钥表现.读取(unit);
    if (state == null || state.单位 !== unit) return;
    state.武魂钥到期任务ID = 0;
    武魂钥.清空(unit);
    销毁武魂钥表现(unit);
}

function on灵识钥到期(this: void, variable?: any): void {
    const unit = variable;
    const state = 双钥表现.读取(unit);
    if (state == null || state.单位 !== unit) return;
    state.灵识钥到期任务ID = 0;
    灵识钥.清空(unit);
    销毁灵识钥表现(unit);
}

function 标记武魂钥(this: void, unit: any): void {
    const state = 获取双钥表现状态(unit);
    武魂钥.标记(unit, 钥匙持续秒);
    if (!state.武魂钥特效存在) {
        state.武魂钥特效存在 = createUnitEffect(unit, 'origin', 武魂钥特效路径, undefined, 武魂钥特效键) != null;
    }
    if (state.武魂钥到期任务ID > 0) removeDelayedCallback(state.武魂钥到期任务ID);
    state.武魂钥到期任务ID = addDelayedCallback(钥匙持续秒 * 1000, on武魂钥到期, unit);
}

function 标记灵识钥(this: void, unit: any): void {
    const state = 获取双钥表现状态(unit);
    灵识钥.标记(unit, 钥匙持续秒);
    if (!state.灵识钥特效存在) {
        state.灵识钥特效存在 = createUnitEffect(unit, 'origin', 灵识钥特效路径, undefined, 灵识钥特效键) != null;
    }
    if (state.灵识钥到期任务ID > 0) removeDelayedCallback(state.灵识钥到期任务ID);
    state.灵识钥到期任务ID = addDelayedCallback(钥匙持续秒 * 1000, on灵识钥到期, unit);
}

function 清理双钥(this: void, unit: any): void {
    武魂钥.清空(unit);
    灵识钥.清空(unit);
    销毁武魂钥表现(unit);
    销毁灵识钥表现(unit);
}

function 尝试双钥共鸣(this: void, unit: any, target: any): void {
    if (!武魂钥.存在(unit) || !灵识钥.存在(unit)) return;
    const key = 取装备冷却键(unit, '双钥共鸣');
    if (!装备冷却就绪(key)) return;
    武魂钥.消耗(unit);
    灵识钥.消耗(unit);
    销毁武魂钥表现(unit);
    销毁灵识钥表现(unit);
    进入装备冷却并显示(key, 6, unit, 四Boss战利品装备名.双钥归一棱镜);
    const units = 取范围敌人(unit, target, 260);
    for (let i = 0; i < units.length; i++)
        造成装备伤害(unit, units[i], 取攻击力(unit) * 0.55 + 180, 装备伤害类型.魔法, false, undefined, {
            装备技能类型: '装备被动',
            标签: '双钥共鸣',
            伤害形态: 'AOE',
        });
    开始通用护盾(unit, unit, 取最大生命(unit) * 0.06, 4, '双钥共鸣');
    播放单位特效(四Boss装备特效.誓盾, unit, 'origin', 1, 0.28);
}

function on武魂钥触发(this: void, e: any): void {
    标记武魂钥(e.持有者);
    尝试双钥共鸣(e.持有者, e.目标);
}

function 非装备技能伤害(this: void, e: any): boolean {
    return e.伤害快照?.isEquipmentSkillDamage !== true;
}

function on灵识钥触发(this: void, e: any): void {
    标记灵识钥(e.持有者);
    尝试双钥共鸣(e.持有者, e.目标);
}

function on双钥归一棱镜丢弃(this: void, unit: any): void {
    清理双钥(unit);
}

注册最终伤害触发模板({
    名称: '双钥归一-武魂钥',
    装备名: 四Boss战利品装备名.双钥归一棱镜,
    伤害过滤: '纯普攻',
    on触发: on武魂钥触发,
});
注册最终伤害触发模板({
    名称: '双钥归一-灵识钥',
    装备名: 四Boss战利品装备名.双钥归一棱镜,
    伤害过滤: '技能',
    自定义过滤: 非装备技能伤害,
    on触发: on灵识钥触发,
});
监听装备丢弃清理(四Boss战利品装备名.双钥归一棱镜, on双钥归一棱镜丢弃);
export {};
