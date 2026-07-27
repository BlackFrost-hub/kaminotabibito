/** @noSelfInFile */
import { 注册不同技能伤害序列触发模板 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板/06．不同技能伤害序列触发模板';
import { 创建单位临时属性效果托管器 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/19．临时属性效果';
import { 创建装备玩家属性项, 装备属性键 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/23．装备属性定义';
import { getBuffRuntime, registerManualBuff } from '../../../05．Buff系统/00．Buff系统';
import { 常规BuffID } from '../../../05．Buff系统/03．Buff表/00．Buff登记';
import {
    取攻击力,
    造成装备伤害,
    四Boss战利品装备名,
    四Boss装备特效,
    装备伤害类型,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
const 创建单位脚下点特效 = (require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
    创建单位脚下点特效: (this: void, unit: any, 参数: { 模型路径: string; Z?: number; 持续秒?: number; 缩放?: number }) => any;
}).创建单位脚下点特效;
const 灵识校准持续秒 = 4;
const 灵识校准魔抗降低 = 0.12;
const 灵识校准属性效果 = 创建单位临时属性效果托管器();

function 清除灵识校准属性(this: void, unit: any, _buffID: string, _row: any): void {
    灵识校准属性效果.清除(unit);
}

function 施加灵识校准(this: void, source: any, target: any): void {
    registerManualBuff(target, 常规BuffID.苍影校魂法典_灵识校准, 灵识校准持续秒, 灵识校准魔抗降低, {
        sourceUnit: source,
        effectSourceName: 四Boss战利品装备名.苍影校魂法典,
        effectSourceType: '装备',
        onRemove: 清除灵识校准属性,
    });
    if (getBuffRuntime(target, 常规BuffID.苍影校魂法典_灵识校准) == null) return;
    灵识校准属性效果.施加(target, 0, [
        创建装备玩家属性项(装备属性键.魔法抗性, -灵识校准魔抗降低),
    ]);
}

注册不同技能伤害序列触发模板({
    名称: '苍影校魂法典',
    装备名: 四Boss战利品装备名.苍影校魂法典,
    需要不同技能数: 2,
    时间窗毫秒: 6000,
    作用域: '主体与目标',
    重复策略: '忽略',
    触发时机: '达成时',
    on触发: (e) => {
        施加灵识校准(e.攻击者, e.目标);
        创建单位脚下点特效(e.目标, {
            模型路径: 四Boss装备特效.灵识闪烁扩散,
            Z: 75,
            持续秒: 0.8,
            缩放: 0.22,
        });
        造成装备伤害(e.攻击者, e.目标, 取攻击力(e.攻击者) * 0.65 + 240, 装备伤害类型.魔法, false, undefined, {
            装备技能类型: '装备被动',
            标签: '灵识校准',
            伤害形态: '单体',
        });
    },
});
export {};
