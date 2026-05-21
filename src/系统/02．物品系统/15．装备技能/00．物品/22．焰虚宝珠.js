/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const jass = require("jass.common");
const japi = require("jass.japi");
const { createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效");
const GetItemTypeId = jass.GetItemTypeId;
const UnitRemoveBuffsEx = jass.UnitRemoveBuffsEx;
const EXSetEffectSize = japi.EXSetEffectSize;
import { 焰虚宝珠物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 焰虚宝珠配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
function 是否为焰虚宝珠(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return GetItemTypeId(物品) === 焰虚宝珠物品ID;
}
export function 处理焰虚宝珠使用(上下文) {
    debugLogForce("23．焰虚宝珠", "进入", "处理焰虚宝珠使用");
    if (!是否为焰虚宝珠(上下文.物品))
        return;
    const 施法单位 = 上下文.施法单位;
    const 目标单位 = 上下文.目标单位;
    if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0)
        return;
    const 特效 = createUnitEffect(施法单位, 焰虚宝珠配置.特效挂点, 焰虚宝珠配置.特效路径, 焰虚宝珠配置.特效持续时间, "焰虚宝珠");
    if (特效 != null && 特效 !== 0) {
        EXSetEffectSize(特效, 焰虚宝珠配置.特效大小);
    }
    UnitRemoveBuffsEx(目标单位, false, true, false, false, false, false, true);
}
