/** @noSelfInFile */
import { 祭祀面具配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";
const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果");
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值");
const { 单位存活, 取当前魔法, 取最大魔法 } = require("../05．物品使用/00．公共/02．物品使用工具");
const jass = require("jass.common");
const KillUnit = jass.KillUnit;
const GetOwningPlayer = jass.GetOwningPlayer;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer;
function on祭祀面具周期(unit) {
    const amount = 祭祀面具配置.固定扣蓝 + 取最大魔法(unit) * 祭祀面具配置.最大魔法扣蓝比例;
    减少魔法值(unit, amount, true, true);
    if (!单位存活(unit))
        return;
    if (取最大魔法(unit) < 祭祀面具配置.死亡最小最大魔法 || 取当前魔法(unit) < 祭祀面具配置.死亡最小当前魔法) {
        KillUnit(unit);
        DisplayTimedTextToPlayer(GetOwningPlayer(unit), 0, 0, 20, 祭祀面具配置.死亡提示);
    }
}
function 初始化祭祀面具() {
    if (获得物品装备ID.祭祀面具 === 0)
        return;
    注册持有型周期效果({
        物品类型ID: 获得物品装备ID.祭祀面具,
        间隔毫秒: 祭祀面具配置.间隔毫秒,
        周期回调: on祭祀面具周期,
    });
}
初始化祭祀面具();
