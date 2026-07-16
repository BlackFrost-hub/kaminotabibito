/** @noSelfInFile */
import { 开始主动技能前摇预警执行模板 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/04．主动技能流程模板/01．前摇预警执行模板';
import {
    创建友军范围承伤转移,
    创建句柄上下文托管器,
} from '../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/index';
import {
    单位存活,
    取当前生命,
    取最大生命,
    是敌对单位,
    开始通用护盾,
    造成装备伤害,
    播放单位特效,
    四Boss装备特效,
    装备伤害类型,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
const jass = require('jass.common') as any;
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as any;
interface 守护连接 {
    守护者: any;
    到期: number;
}
const 连接 = 创建句柄上下文托管器<守护连接>('黑翼守护重盾');
创建友军范围承伤转移({
    名称: '黑翼守护重盾-守护者之职责',
    转移比例: 0.35,
    转移半径: 900,
    过滤伤害: (e) =>
        e.上下文.isTrueDamage !== true &&
        e.上下文.isDotDamage !== true &&
        e.上下文.isDamageTransfer !== true &&
        e.上下文.isReflectedDamage !== true &&
        e.上下文.isEquipmentSkillDamage !== true,
    获取候选单位列表: (e) => {
        const s = 连接.读取(e.受击者);
        if (
            s == null ||
            getServerTime() >= s.到期 ||
            !单位存活(s.守护者) ||
            取当前生命(s.守护者) / 取最大生命(s.守护者) <= 0.2
        ) {
            连接.清空(e.受击者);
            return [];
        }
        return [s.守护者];
    },
    on转移: (e) =>
        造成装备伤害(e.承受者, e.承受者, e.转移伤害, 装备伤害类型.物理, false, undefined, {
            装备技能类型: '装备主动',
            标签: '守护者伤害转移',
            伤害形态: '单体',
        }),
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
            连接.写入(target, { 守护者: caster, 到期: getServerTime() + 8000 });
            开始通用护盾(caster, caster, 取最大生命(caster) * 0.12, 8, '守护者之职责');
            开始通用护盾(caster, target, 取最大生命(target) * 0.1, 8, '守护者之职责');
            播放单位特效(四Boss装备特效.黑翼屏障, caster, 'origin', 8, 0.32);
            播放单位特效(四Boss装备特效.黑翼拘束, target, 'origin', 8, 0.25);
        },
    });
}
export {};
