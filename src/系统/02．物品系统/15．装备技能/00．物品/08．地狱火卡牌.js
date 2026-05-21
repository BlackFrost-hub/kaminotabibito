/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const jass = require("jass.common");
const GetUnitState = jass.GetUnitState;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE;
const { 施加持续恢复生命魔法 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.01．持续恢复生命魔法");
import { 地狱火卡牌物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 地狱火卡牌配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
function 是否为地狱火卡牌(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return jass.GetItemTypeId(物品) === 地狱火卡牌物品ID;
}
function 计算每跳生命恢复(单位) {
    return GetUnitState(单位, UNIT_STATE_MAX_LIFE) * 地狱火卡牌配置.生命恢复百分比 + 地狱火卡牌配置.固定生命恢复;
}
function 计算每跳魔法恢复(单位) {
    return 计算每跳生命恢复(单位) * 地狱火卡牌配置.魔法恢复比例;
}
export function 处理地狱火卡牌施法(施法单位) {
    debugLogForce("地狱火卡牌", "处理施法入口", "施法单位:", 施法单位);
    if (施法单位 == null || 施法单位 === 0) {
        debugLogForce("地狱火卡牌", "提前返回: 施法单位为空");
        return;
    }
    const 每跳生命恢复 = 计算每跳生命恢复(施法单位);
    const 每跳魔法恢复 = 计算每跳魔法恢复(施法单位);
    debugLogForce("地狱火卡牌", "计算恢复值", "每跳生命恢复:", 每跳生命恢复, "每跳魔法恢复:", 每跳魔法恢复);
    施加持续恢复生命魔法(施法单位, 施法单位, {
        BuffID: 地狱火卡牌配置.BuffID,
        图标路径: 地狱火卡牌配置.图标路径,
        特效路径: 地狱火卡牌配置.特效路径,
        特效挂点: 地狱火卡牌配置.特效挂点,
        特效键: 地狱火卡牌配置.特效键,
        持续时间: 地狱火卡牌配置.持续时间,
        间隔: 地狱火卡牌配置.间隔,
        每跳生命恢复: 每跳生命恢复,
        每跳魔法恢复: 每跳魔法恢复,
    });
    debugLogForce("地狱火卡牌", "施加恢复完成");
}
export function 处理地狱火卡牌使用(上下文) {
    debugLogForce("地狱火卡牌", "使用入口", "物品:", 上下文.物品, "施法单位:", 上下文.施法单位);
    if (!是否为地狱火卡牌(上下文.物品)) {
        debugLogForce("地狱火卡牌", "提前返回: 不是地狱火卡牌");
        return;
    }
    debugLogForce("地狱火卡牌", "确认为地狱火卡牌，准备施法");
    处理地狱火卡牌施法(上下文.施法单位);
}
