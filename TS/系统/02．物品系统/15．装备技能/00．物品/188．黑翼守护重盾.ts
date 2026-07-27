/** @noSelfInFile */
import { 开始主动技能前摇预警执行模板 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/04．主动技能流程模板/01．前摇预警执行模板';
import {
    创建友军范围承伤转移,
    创建句柄上下文托管器,
} from '../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/index';
import { 创建单位绑定闪电 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/10．跳链/单位绑定闪电';
import { 闪电效果代码 } from '../../../03．技能系统/00．技能模板+函数/02．通用函数/17．闪电效果代码';
const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
    debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { registerDamageModifier } = require('系统.04．伤害系统.00．伤害计算.06．伤害修正回调') as {
    registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
import {
    施加黑翼守护契约Buff,
    清除黑翼守护契约Buff,
} from '../../../03．技能系统/00．技能模板+函数/02．通用函数/01．控制与Buff';
import {
    单位存活,
    取当前生命,
    取最大生命,
    是敌对单位,
    开始通用护盾,
    造成装备伤害,
    播放单位特效,
    四Boss装备特效,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
const jass = require('jass.common') as any;
const DAMAGE_TYPE_UNIVERSAL = jass.DAMAGE_TYPE_UNIVERSAL as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
    addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
    removePeriodicCallback: (this: void, id: number) => void;
    getServerTime: (this: void) => number;
};

const 守护连接持续秒 = 8;
const 守护连接转移比例 = 0.35;
const 守护连接断开距离 = 900;

function 黑翼守护伤害日志(this: void, ...内容: any[]): void {
    debugLogForce('wp188-伤害转移', ...内容);
}

interface 守护连接 {
    守护者: any;
    受护者: any;
    到期: number;
    下次闪电时间: number;
}
const 连接 = 创建句柄上下文托管器<守护连接>('黑翼守护重盾');
const 守护目标 = 创建句柄上下文托管器<any>('黑翼守护重盾-守护目标');
const 活跃守护连接: 守护连接[] = [];
let 守护连接驱动ID = 0;

function 移除活跃守护连接(this: void, state: 守护连接): void {
    for (let i = 活跃守护连接.length - 1; i >= 0; i--) {
        if (活跃守护连接[i] === state) 活跃守护连接.splice(i, 1);
    }
    if (活跃守护连接.length === 0 && 守护连接驱动ID !== 0) {
        removePeriodicCallback(守护连接驱动ID);
        守护连接驱动ID = 0;
    }
}

function 结束守护连接(this: void, 受护者: any, 预期守护者?: any): void {
    const state = 连接.读取(受护者);
    if (state == null || (预期守护者 != null && state.守护者 !== 预期守护者)) return;
    连接.清空(受护者);
    if (守护目标.读取(state.守护者) === state.受护者) 守护目标.清空(state.守护者);
    清除黑翼守护契约Buff(state.守护者, state.受护者);
    移除活跃守护连接(state);
}

function 守护连接距离超限(this: void, state: 守护连接): boolean {
    const dx = GetUnitX(state.守护者) - GetUnitX(state.受护者);
    const dy = GetUnitY(state.守护者) - GetUnitY(state.受护者);
    return dx * dx + dy * dy > 守护连接断开距离 * 守护连接断开距离;
}

function 创建守护契约闪电(this: void, state: 守护连接): void {
    创建单位绑定闪电({
        效果代码: 闪电效果代码.白色细束,
        起点单位: state.守护者,
        终点单位: state.受护者,
        持续时间: 1,
        起点高度偏移: 85,
        终点高度偏移: 85,
        任一死亡时销毁: true,
        颜色: { r: 1, g: 0.82, b: 0.42, a: 0.92 },
    });
}

function on守护连接驱动Tick(this: void): void {
    const now = getServerTime();
    for (let i = 活跃守护连接.length - 1; i >= 0; i--) {
        const state = 活跃守护连接[i];
        if (
            连接.读取(state.受护者) !== state ||
            now >= state.到期 ||
            !单位存活(state.守护者) ||
            !单位存活(state.受护者) ||
            取当前生命(state.守护者) / 取最大生命(state.守护者) <= 0.2 ||
            守护连接距离超限(state)
        ) {
            结束守护连接(state.受护者, state.守护者);
            continue;
        }
        if (now >= state.下次闪电时间) {
            创建守护契约闪电(state);
            state.下次闪电时间 = now + 1000;
        }
    }
}

function 启动守护连接驱动(this: void): void {
    if (守护连接驱动ID === 0) 守护连接驱动ID = addPeriodicCallback(100, on守护连接驱动Tick);
}

function on黑翼守护护盾前伤害(this: void, context: any): number {
    const state = 连接.读取(context.target);
    if (state != null) {
        黑翼守护伤害日志('护盾前', '受护者:', context.target, '伤害:', context.currentDamage, '守护者:', state.守护者);
    }
    return context.currentDamage;
}

function on黑翼守护转移后伤害(this: void, context: any): number {
    const state = 连接.读取(context.target);
    if (state != null) {
        黑翼守护伤害日志('承伤阶段后', '受护者:', context.target, '剩余伤害:', context.currentDamage, '守护者:', state.守护者);
    }
    return context.currentDamage;
}

function 是黑翼守护直接伤害(this: void, e: { 受击者: any; 攻击者: any; 当前伤害: number; 上下文: any }): boolean {
    const context = e.上下文;
    const state = 连接.读取(e.受击者);
    if (state == null) return false;
    if (
        context.isTrueDamage === true ||
        context.isDamageTransfer === true ||
        context.isReflectedDamage === true ||
        context.isEquipmentSkillDamage === true
    ) {
        黑翼守护伤害日志('排除特殊伤害', '受护者:', e.受击者, '伤害:', e.当前伤害, '真实:', context.isTrueDamage, '转移:', context.isDamageTransfer, '反伤:', context.isReflectedDamage, '装备:', context.isEquipmentSkillDamage);
        return false;
    }
    const tag = context.skillDamageTag;
    if (typeof tag === 'string' && (tag.indexOf('DOT') >= 0 || tag.indexOf('持续') >= 0 || tag.indexOf('反伤') >= 0 || tag.indexOf('环境') >= 0)) {
        黑翼守护伤害日志('排除标签伤害', '受护者:', e.受击者, '伤害:', e.当前伤害, '标签:', tag);
        return false;
    }
    黑翼守护伤害日志('护盾后允许承伤', '受护者:', e.受击者, '伤害:', e.当前伤害, '攻击者:', e.攻击者);
    return true;
}

function 获取黑翼守护承受者(this: void, e: { 受击者: any }): any[] {
    const state = 连接.读取(e.受击者);
    if (
        state == null ||
        getServerTime() >= state.到期 ||
        !单位存活(state.守护者) ||
        取当前生命(state.守护者) / 取最大生命(state.守护者) <= 0.2
    ) {
        黑翼守护伤害日志('守护者无效', '受护者:', e.受击者, '状态:', state);
        if (state != null) 结束守护连接(e.受击者, state.守护者);
        return [];
    }
    黑翼守护伤害日志('找到守护者', '受护者:', e.受击者, '守护者:', state.守护者);
    return [state.守护者];
}

function on黑翼守护伤害转移(this: void, e: { 攻击者: any; 承受者: any; 转移伤害: number }): void {
    const 伤害来源 = 单位存活(e.攻击者) ? e.攻击者 : e.承受者;
    黑翼守护伤害日志('执行转移', '来源:', 伤害来源, '守护者:', e.承受者, '转移伤害:', e.转移伤害);
    造成装备伤害(伤害来源, e.承受者, e.转移伤害, DAMAGE_TYPE_UNIVERSAL, false, undefined, {
        装备技能类型: '装备主动',
        标签: '守护者伤害转移',
        伤害形态: '单体',
        参与技能伤害加成: false,
        伤害转移: true,
    });
}

registerDamageModifier(on黑翼守护护盾前伤害, 110);
registerDamageModifier(on黑翼守护转移后伤害, 34);

创建友军范围承伤转移({
    名称: '黑翼守护重盾-守护者之职责',
    转移比例: 守护连接转移比例,
    转移半径: 守护连接断开距离,
    过滤伤害: 是黑翼守护直接伤害,
    获取候选单位列表: 获取黑翼守护承受者,
    on转移: on黑翼守护伤害转移,
});
export function 处理黑翼守护重盾使用(this: void, ctx: any): void {
    const caster = ctx.施法单位,
        target = ctx.目标单位;
    if (!单位存活(target) || target === caster || 是敌对单位(caster, target)) return;
    开始主动技能前摇预警执行模板({
        施法者: caster,
        目标: target,
        前摇: {
            持续时间: 1,
            强制硬直: true,
            允许自我打断: true,
            施法动作名: 'spell',
            过程特效: 四Boss装备特效.黑翼拘束,
            过程特效生命周期: 1,
        },
        提示圈: false,
        执行: function on守护连接建立(this: void): void {
            const 原守护目标 = 守护目标.读取(caster);
            if (原守护目标 != null) 结束守护连接(原守护目标, caster);
            结束守护连接(target);
            const state: 守护连接 = {
                守护者: caster,
                受护者: target,
                到期: getServerTime() + 守护连接持续秒 * 1000,
                下次闪电时间: getServerTime() + 1000,
            };
            连接.写入(target, state);
            守护目标.写入(caster, target);
            活跃守护连接.push(state);
            创建守护契约闪电(state);
            启动守护连接驱动();
            施加黑翼守护契约Buff(caster, target, 守护连接持续秒, 守护连接转移比例);
            开始通用护盾(caster, caster, 取最大生命(caster) * 0.12, 守护连接持续秒, '守护者之职责');
            开始通用护盾(caster, target, 取最大生命(target) * 0.1, 守护连接持续秒, '守护者之职责');
            播放单位特效(四Boss装备特效.黑翼屏障, caster, 'origin', 守护连接持续秒, 0.32);
            播放单位特效(四Boss装备特效.黑翼拘束, target, 'origin', 守护连接持续秒, 0.25);
        },
    });
}
export {};
