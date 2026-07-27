/** @noSelfInFile */
import { 创建同目标普攻计数触发器 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/21．攻击效果/05．同目标普攻计数触发';
import {
    单位持有装备,
    取攻击力,
    取最大生命,
    恢复生命魔法,
    造成装备伤害,
    播放单位特效,
    四Boss战利品装备名,
    四Boss装备特效,
    装备伤害类型,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
import { 常规BuffID } from '../../../05．Buff系统/03．Buff表/00．Buff登记';
const { registerManualBuff } = require('系统.05．Buff系统.00．Buff系统') as {
    registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};

function 滴管汲血过滤(this: void, e: any): boolean {
    return 单位持有装备(e.source, 四Boss战利品装备名.滴管长枪投影);
}

function on滴管汲血触发(this: void, e: any): void {
    const damage = 取攻击力(e.source) * 0.8 + 220;
    const healByDamage = damage * 0.25;
    const healCap = 取最大生命(e.source) * 0.06;
    造成装备伤害(e.source, e.target, damage, 装备伤害类型.物理, false, undefined, {
        装备技能类型: '普攻强化',
        标签: '滴管汲血',
        伤害形态: '单体',
    });
    恢复生命魔法(e.source, e.source, healByDamage < healCap ? healByDamage : healCap);
    registerManualBuff(e.target, 常规BuffID.滴管长枪投影_鲜血枯竭, 8, 0, {
        sourceUnit: e.source,
        effectSourceName: '滴管长枪投影',
        effectSourceType: '装备',
    });
    播放单位特效(四Boss装备特效.血滴, e.target, 'overhead', 8, 0.2);
    播放单位特效(四Boss装备特效.血色冲击, e.target, 'origin', 1, 0.25);
}

创建同目标普攻计数触发器({
    名称: '滴管长枪投影-滴管汲血',
    窗口秒: 5,
    次数阈值: 3,
    内置CD秒: 8,
    冷却作用域: '攻击者目标',
    仅纯普攻: true,
    过滤: 滴管汲血过滤,
    on触发: on滴管汲血触发,
});
export {};
