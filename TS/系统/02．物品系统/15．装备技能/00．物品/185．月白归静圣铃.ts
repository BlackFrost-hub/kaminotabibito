/** @noSelfInFile */
import { 创建治疗护盾联动 } from '../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/05．治疗护盾联动';
import { 创建单位临时属性效果托管器 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/19．临时属性效果';
import { 创建装备玩家属性项, 装备属性键 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/23．装备属性定义';
import { registerManualBuff } from '../../../05．Buff系统/00．Buff系统';
import { 常规BuffID } from '../../../05．Buff系统/03．Buff表/00．Buff登记';
import {
    单位持有装备,
    是敌对单位,
    取当前生命,
    取最大生命,
    取单位对单位冷却键,
    装备冷却就绪,
    进入装备冷却并显示,
    四Boss战利品装备名,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
const 净誓余辉持续秒 = 5;
const 净誓余辉抗性 = 0.15;
const 净誓余辉属性效果 = 创建单位临时属性效果托管器();

function 清除净誓余辉属性(this: void, unit: any, _buffID: string, _row: any): void {
    净誓余辉属性效果.清除(unit);
}
function 尝试净誓余辉(this: void, event: any): void {
    const source = event.来源单位,
        target = event.目标单位;
    if (
        是敌对单位(source, target) ||
        !单位持有装备(source, 四Boss战利品装备名.月白归静圣铃) ||
        取当前生命(target) / 取最大生命(target) > 0.45
    )
        return;
    const key = 取单位对单位冷却键(source, target, '净誓余辉');
    if (!装备冷却就绪(key)) return;
    进入装备冷却并显示(key, 10, source, 四Boss战利品装备名.月白归静圣铃);
    registerManualBuff(target, 常规BuffID.月白归静圣铃_净誓余辉, 净誓余辉持续秒, 净誓余辉抗性, {
        sourceUnit: source,
        effectSourceName: 四Boss战利品装备名.月白归静圣铃,
        effectSourceType: '装备',
        effectValue2: 净誓余辉抗性,
        onRemove: 清除净誓余辉属性,
    });
    净誓余辉属性效果.施加(target, 0, [
        创建装备玩家属性项(装备属性键.物理抗性, 净誓余辉抗性),
        创建装备玩家属性项(装备属性键.魔法抗性, 净誓余辉抗性),
        创建装备玩家属性项(装备属性键.控制抗性, 0.3),
    ]);
}
创建治疗护盾联动({
    名称: '月白归静圣铃-净誓余辉',
    监听方向: '自己给予',
    治疗触发阶段: '治疗开始',
    on治疗: 尝试净誓余辉,
    on护盾: 尝试净誓余辉,
});
export {};
