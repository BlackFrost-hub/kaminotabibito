/** @noSelfInFile */
// 祖地秘境·灵潮祭司掉落：灵潮护心灯（被动·护心）
// 护心：战斗状态下每5秒为600码内生命比例最低的友军（含自己）恢复持有者攻击力×40%的生命。
// 实现选型：注册持有战斗周期模板（战斗门控 + 获取/丢弃自动注册注销）。

import { 注册持有战斗周期模板 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板/04．持有战斗周期模板";
import {
    取装备物品ID,
    取范围友方,
    取当前生命,
    取最大生命,
    取攻击力,
    恢复生命魔法,
    播放单位特效,
    单位存活,
    祖地秘境战利品装备名,
} from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const 护心周期秒 = 5;
const 护心半径 = 600;
const 护心攻击系数 = 0.4;
const 护心治疗特效 = "Abilities\\Spells\\NightElf\\Rejuvenation\\RejuvenationTarget.mdl";

function on护心周期(this: void, event: { 单位: any; 持有数量: number }): void {
    const unit = event.单位;
    if (!单位存活(unit)) return;
    const 友军 = 取范围友方(unit, 护心半径);
    let 目标: any = null;
    let 最低比例 = 2;
    for (let i = 0; i < 友军.length; i++) {
        const ally = 友军[i];
        const 比例 = 取当前生命(ally) / 取最大生命(ally);
        if (比例 < 最低比例) {
            最低比例 = 比例;
            目标 = ally;
        }
    }
    if (目标 == null || 最低比例 >= 1) return;
    恢复生命魔法(unit, 目标, 取攻击力(unit) * 护心攻击系数);
    播放单位特效(护心治疗特效, 目标, "origin", 1.5, 0.6);
}

注册持有战斗周期模板({
    名称: "灵潮护心灯-护心",
    物品类型ID: 取装备物品ID(祖地秘境战利品装备名.灵潮护心灯),
    周期秒: 护心周期秒,
    on周期: on护心周期,
});
export {};
