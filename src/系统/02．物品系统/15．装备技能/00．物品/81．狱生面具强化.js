/** @noSelfInFile */
import { 狱生面具配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";
const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果");
const { 获取单位当前持有指定物品数量 } = require("系统.02．物品系统.15．装备技能.06．获取丢弃.index");
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器");
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值");
const { 获取范围敌人, 取单位X, 取单位Y, 取最大魔法, 取最大生命, 取当前生命, 取当前魔法, 造成暗影伤害, 执行治疗 } = require("../05．物品使用/00．公共/02．物品使用工具");
const jass = require("jass.common");
const GetHandleId = jass.GetHandleId;
const IsUnitType = jass.IsUnitType;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;
const 强化狱生面具延迟队列 = [];
let 已注册强化狱生面具延迟处理 = false;
function 单位已死亡(unit) {
    return unit == null || unit === 0 || IsUnitType(unit, UNIT_TYPE_DEAD) === true;
}
function 单位持有狱生面具强化(unit) {
    return 获取单位当前持有指定物品数量(unit, 获得物品装备ID.狱生面具强化) > 0;
}
function 是否相同单位(a, b) {
    if (a == null || a === 0 || b == null || b === 0)
        return false;
    return GetHandleId(a) === GetHandleId(b);
}
function 创建强化狱生面具延迟记录(source, target) {
    if (单位已死亡(source) || 单位已死亡(target))
        return;
    if (!单位持有狱生面具强化(source))
        return;
    const expireTime = getServerTime() + 狱生面具配置.强化延迟毫秒;
    for (let i = 0; i < 强化狱生面具延迟队列.length; i++) {
        const record = 强化狱生面具延迟队列[i];
        if (record != null && 是否相同单位(record.来源单位, source) && 是否相同单位(record.目标单位, target)) {
            record.到期时间 = expireTime;
            return;
        }
    }
    强化狱生面具延迟队列.push({
        来源单位: source,
        目标单位: target,
        到期时间: expireTime,
    });
}
function on强化狱生面具延迟结算() {
    const now = getServerTime();
    for (let i = 强化狱生面具延迟队列.length - 1; i >= 0; i--) {
        const record = 强化狱生面具延迟队列[i];
        if (record == null) {
            强化狱生面具延迟队列.splice(i, 1);
            continue;
        }
        if (record.来源单位 == null || record.来源单位 === 0 || 单位已死亡(record.来源单位) || !单位持有狱生面具强化(record.来源单位)) {
            强化狱生面具延迟队列.splice(i, 1);
            continue;
        }
        if (单位已死亡(record.目标单位)) {
            const heal = (取最大生命(record.来源单位) - 取当前生命(record.来源单位)) * 狱生面具配置.强化恢复比例;
            const mana = (取最大魔法(record.来源单位) - 取当前魔法(record.来源单位)) * 狱生面具配置.强化恢复比例;
            执行治疗(record.来源单位, record.来源单位, heal, mana);
            强化狱生面具延迟队列.splice(i, 1);
            continue;
        }
        if (now >= record.到期时间) {
            强化狱生面具延迟队列.splice(i, 1);
        }
    }
}
function 确保注册强化狱生面具延迟处理() {
    if (已注册强化狱生面具延迟处理)
        return;
    已注册强化狱生面具延迟处理 = true;
    addPeriodicCallback(100, on强化狱生面具延迟结算);
}
function on狱生面具强化周期(unit) {
    const consumed = -减少魔法值(unit, 取最大魔法(unit) * 狱生面具配置.最大魔法消耗比例, true, false);
    if (!(consumed > 0))
        return;
    const damage = consumed * 狱生面具配置.强化伤害倍率;
    const targets = 获取范围敌人(unit, 取单位X(unit), 取单位Y(unit), 狱生面具配置.作用范围);
    for (let i = 0; i < targets.length; i++) {
        const target = targets[i];
        if (单位已死亡(target))
            continue;
        创建强化狱生面具延迟记录(unit, target);
        造成暗影伤害(unit, target, damage);
    }
}
function 初始化狱生面具强化() {
    if (获得物品装备ID.狱生面具强化 === 0)
        return;
    确保注册强化狱生面具延迟处理();
    注册持有型周期效果({
        物品类型ID: 获得物品装备ID.狱生面具强化,
        间隔毫秒: 狱生面具配置.间隔毫秒,
        周期回调: on狱生面具强化周期,
    });
}
初始化狱生面具强化();
