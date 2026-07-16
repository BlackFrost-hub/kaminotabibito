/** @noSelfInFile */
import { 创建治疗护盾联动 } from '../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/05．治疗护盾联动';
import {
    单位持有装备,
    是敌对单位,
    取当前生命,
    取最大生命,
    取单位对单位冷却键,
    装备冷却就绪,
    进入装备冷却并显示,
    临时玩家属性,
    播放单位特效,
    四Boss战利品装备名,
    四Boss装备特效,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
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
    临时玩家属性(target, '物理抗性', 0.15, 5);
    临时玩家属性(target, '魔法抗性', 0.15, 5);
    临时玩家属性(target, '控制抗性', 0.3, 5);
    播放单位特效(四Boss装备特效.净化反冲, target, 'overhead', 5, 0.2);
}
创建治疗护盾联动({ 名称: '月白归静圣铃-净誓余辉', 监听方向: '自己给予', on治疗: 尝试净誓余辉, on护盾: 尝试净誓余辉 });
export {};
