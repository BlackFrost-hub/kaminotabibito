/** @noSelfInFile */
import { 高原魔力灯笼配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";
const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果");
const { 是否白天 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.05．昼夜状态");
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值");
const { 获取范围友军, 取单位X, 取单位Y, 取最大生命, 执行治疗, 调整玩家属性 } = require("../05．物品使用/00．公共/02．物品使用工具");
const jass = require("jass.common");
const GetHandleId = jass.GetHandleId;
const GetUnitState = jass.GetUnitState;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA;
const 高原魔力灯笼状态表 = {};
function 取单位ID(unit) {
    if (unit == null || unit === 0)
        return 0;
    return GetHandleId(unit) || 0;
}
function 取或创建高原魔力灯笼状态(unit) {
    const id = 取单位ID(unit);
    const state = 高原魔力灯笼状态表[id];
    if (state != null)
        return state;
    const nextState = { 当前伤害减少层数: 0 };
    高原魔力灯笼状态表[id] = nextState;
    return nextState;
}
function 同步夜晚减伤(unit, currentCount) {
    const state = 取或创建高原魔力灯笼状态(unit);
    const nextCount = 是否白天() ? 0 : currentCount;
    if (state.当前伤害减少层数 === nextCount)
        return;
    if (state.当前伤害减少层数 > 0) {
        调整玩家属性(unit, "伤害减少%", -高原魔力灯笼配置.夜晚伤害减少增加 * state.当前伤害减少层数);
    }
    if (nextCount > 0) {
        调整玩家属性(unit, "伤害减少%", 高原魔力灯笼配置.夜晚伤害减少增加 * nextCount);
    }
    state.当前伤害减少层数 = nextCount;
}
function 清理高原魔力灯笼状态(unit) {
    const id = 取单位ID(unit);
    if (id === 0)
        return;
    const state = 高原魔力灯笼状态表[id];
    if (state != null && state.当前伤害减少层数 > 0) {
        调整玩家属性(unit, "伤害减少%", -高原魔力灯笼配置.夜晚伤害减少增加 * state.当前伤害减少层数);
    }
    delete 高原魔力灯笼状态表[id];
}
function on高原魔力灯笼周期(unit, currentCount) {
    const manaCost = GetUnitState(unit, UNIT_STATE_MAX_MANA) * 高原魔力灯笼配置.最大魔法消耗比例 * currentCount;
    减少魔法值(unit, manaCost, true, false);
    同步夜晚减伤(unit, currentCount);
    if (!是否白天())
        return;
    const allies = 获取范围友军(unit, 取单位X(unit), 取单位Y(unit), 高原魔力灯笼配置.白天治疗半径);
    for (let i = 0; i < allies.length; i++) {
        const ally = allies[i];
        执行治疗(unit, ally, 取最大生命(ally) * 高原魔力灯笼配置.白天治疗最大生命比例, 0);
    }
}
function on高原魔力灯笼丢弃(unit) {
    清理高原魔力灯笼状态(unit);
}
function 初始化高原魔力灯笼() {
    if (获得物品装备ID.高原魔力灯笼 === 0)
        return;
    注册持有型周期效果({
        物品类型ID: 获得物品装备ID.高原魔力灯笼,
        间隔毫秒: 高原魔力灯笼配置.间隔毫秒,
        周期回调: on高原魔力灯笼周期,
        丢弃回调: on高原魔力灯笼丢弃,
    });
}
初始化高原魔力灯笼();
