/** @noSelfInFile */
import { 狱生面具配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";
const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果");
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值");
const { 获取范围敌人, 取单位X, 取单位Y, 取最大魔法, 造成暗影伤害, 执行治疗 } = require("../05．物品使用/00．公共/02．物品使用工具");
function on狱生面具周期(unit) {
    const consumed = -减少魔法值(unit, 取最大魔法(unit) * 狱生面具配置.最大魔法消耗比例, true, false);
    if (!(consumed > 0))
        return;
    const targets = 获取范围敌人(unit, 取单位X(unit), 取单位Y(unit), 狱生面具配置.作用范围);
    for (let i = 0; i < targets.length; i++) {
        造成暗影伤害(unit, targets[i], consumed);
    }
    执行治疗(unit, unit, consumed, 0);
}
function 初始化狱生面具() {
    if (获得物品装备ID.狱生面具 === 0)
        return;
    注册持有型周期效果({
        物品类型ID: 获得物品装备ID.狱生面具,
        间隔毫秒: 狱生面具配置.间隔毫秒,
        周期回调: on狱生面具周期,
    });
}
初始化狱生面具();
