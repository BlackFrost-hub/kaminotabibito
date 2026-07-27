/** @noSelfInFile */
import { 注册最终伤害触发模板, type 最终伤害触发事件 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板';
import { 创建单位临时属性效果托管器 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/19．临时属性效果';
import { 创建装备玩家属性项, 装备属性键 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/23．装备属性定义';
import {
    四Boss战利品装备名,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
import { registerManualBuff, 移除单位指定Buff } from '../../../05．Buff系统/00．Buff系统';
import { 常规BuffID } from '../../../05．Buff系统/03．Buff表/00．Buff登记';
const { SFB_setSlow } = require('lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口') as {
    SFB_setSlow: (
        this: void,
        来源单位: any,
        目标单位: any,
        攻速降低: number,
        移速降低: number,
        持续时间: number,
        效果来源名称?: string,
        效果来源类型?: "装备" | "技能"
    ) => void;
};

const 残誓不退触发生命比例 = 0.35;
const 残誓不退持续秒数 = 6;
const 残誓不退魔抗 = 0.18;
const 残誓不退属性效果 = 创建单位临时属性效果托管器();

function 清除残誓不退属性(this: void, unit: any, _buffID: string, _row: any): void {
    残誓不退属性效果.清除(unit);
    移除单位指定Buff(unit, 常规BuffID.减速);
}

function on残誓不退触发(this: void, e: 最终伤害触发事件): void {
    registerManualBuff(e.持有者, 常规BuffID.裂誓战躯重铠_残誓不退, 残誓不退持续秒数, 0.25, {
        sourceUnit: e.持有者,
        effectSourceName: 四Boss战利品装备名.裂誓战躯重铠,
        effectSourceType: '装备',
        effectValue2: 残誓不退魔抗,
        onRemove: 清除残誓不退属性,
    });
    残誓不退属性效果.施加(e.持有者, 0, [
        创建装备玩家属性项(装备属性键.物理抗性, 0.25),
        创建装备玩家属性项(装备属性键.魔法抗性, 残誓不退魔抗),
        创建装备玩家属性项(装备属性键.控制抗性, 0.4),
    ]);
    SFB_setSlow(e.持有者, e.持有者, 0, 0.25, 残誓不退持续秒数, "裂誓战躯重铠", "装备");
}

注册最终伤害触发模板({
    名称: '裂誓战躯重铠-残誓不退',
    装备名: 四Boss战利品装备名.裂誓战躯重铠,
    持有者: '受击者',
    冷却秒数: 45,
    受击后生命比例上限: 残誓不退触发生命比例,
    on触发: on残誓不退触发,
});
export {};
