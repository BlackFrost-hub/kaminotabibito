/** @noSelfInFile */
const { createDelayedCall, cancelDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.02．计时器");
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效");
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程");
const { 扩散伤害 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.08．扩散伤害.扩散伤害");
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数");
const { 获取同类伤害类型 } = require("系统.03．技能系统.00．技能模板+函数.04．辅助函数.01．同类伤害类型");
const jass = require("jass.common");
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetHandleId = jass.GetHandleId;
const IsUnitType = jass.IsUnitType;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO;
import { 巨魔大剑物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 巨魔大剑配置 } from "../03．主动技能/02．施法触发/00．施法触发配置";
const 巨魔大剑窗口计时器 = new Map();
let 已注册巨魔大剑首伤监听 = false;
function 单位持有巨魔大剑(单位) {
    if (单位 == null || 单位 === 0)
        return false;
    if (巨魔大剑物品ID <= 0) {
        return false;
    }
    const result = UnitHasItemOfTypeBJ(单位, 巨魔大剑物品ID) === true;
    return result;
}
function 巨魔大剑条件成立(施法单位, 目标单位) {
    if (!IsUnitType(施法单位, UNIT_TYPE_HERO)) {
        return false;
    }
    if (!单位持有巨魔大剑(施法单位)) {
        return false;
    }
    const result = 目标单位 != null && 目标单位 !== 0;
    return result;
}
function 获取巨魔大剑窗口键(单位) {
    if (单位 == null || 单位 === 0)
        return 0;
    return GetHandleId(单位);
}
function 清理巨魔大剑窗口(单位, 取消计时器 = true) {
    const 键 = 获取巨魔大剑窗口键(单位);
    if (键 <= 0)
        return;
    const 句柄 = 巨魔大剑窗口计时器.get(键);
    if (取消计时器 && 句柄 != null) {
        cancelDelayedCall(句柄);
    }
    巨魔大剑窗口计时器.delete(键);
}
function 打开巨魔大剑窗口(单位) {
    const 键 = 获取巨魔大剑窗口键(单位);
    if (键 <= 0) {
        return;
    }
    清理巨魔大剑窗口(单位, true);
    let 句柄 = null;
    句柄 = createDelayedCall(巨魔大剑配置.持续时间, function () {
        if (句柄 == null)
            return;
        if (巨魔大剑窗口计时器.get(键) === 句柄) {
            巨魔大剑窗口计时器.delete(键);
        }
    });
    巨魔大剑窗口计时器.set(键, 句柄);
}
function 处理巨魔大剑首伤(target, attacker, applied, snapshot) {
    if (target == null || attacker == null || !(applied >= 1)) {
        return;
    }
    if (snapshot != null && snapshot.isTrueDamage === true) {
        return;
    }
    if (!单位持有巨魔大剑(attacker)) {
        return;
    }
    const 键 = 获取巨魔大剑窗口键(attacker);
    if (键 <= 0) {
        return;
    }
    const 句柄 = 巨魔大剑窗口计时器.get(键);
    if (句柄 == null) {
        return;
    }
    巨魔大剑窗口计时器.delete(键);
    cancelDelayedCall(句柄);
    const x = GetUnitX(target);
    const y = GetUnitY(target);
    createTimedEffect(巨魔大剑配置.扩散特效路径, x, y, 0, 巨魔大剑配置.扩散特效持续时间);
    const 类型 = 获取同类伤害类型(snapshot);
    扩散伤害({
        来源单位: attacker,
        主目标: target,
        伤害值: applied,
        扩散半径: 巨魔大剑配置.扩散半径,
        扩散百分比: 巨魔大剑配置.扩散百分比,
        是否包含主目标: false,
        攻击类型: 类型.攻击类型,
        伤害类型: 类型.伤害类型,
        武器类型: 类型.武器类型,
    });
}
function 初始化巨魔大剑首伤监听() {
    if (已注册巨魔大剑首伤监听)
        return;
    已注册巨魔大剑首伤监听 = true;
    registerAppliedFinalDamageListener(处理巨魔大剑首伤);
}
export function 处理巨魔大剑施法(施法单位, 技能ID, 目标单位) {
    初始化巨魔大剑首伤监听();
    if (!巨魔大剑条件成立(施法单位, 目标单位))
        return;
    打开巨魔大剑窗口(施法单位);
}
初始化巨魔大剑首伤监听();
