/** @noSelfInFile */
const { registerHealCallback } = require("系统.04．伤害系统.02．治疗系统.01．核心功能");
import { 处理黑牧杖治疗 } from "../../00．物品/03．黑牧杖";
let 已初始化治疗触发主动技能核心 = false;
function 处理治疗触发主动技能(来源, 目标, 治疗量, 是否物品治疗) {
    return 处理黑牧杖治疗(来源, 目标, 治疗量, 是否物品治疗);
}
export function 初始化治疗触发主动技能核心() {
    if (已初始化治疗触发主动技能核心)
        return;
    已初始化治疗触发主动技能核心 = true;
    registerHealCallback(处理治疗触发主动技能);
}
