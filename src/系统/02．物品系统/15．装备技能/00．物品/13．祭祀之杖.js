/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const jass = require("jass.common");
const GetItemTypeId = jass.GetItemTypeId;
const GetUnitState = jass.GetUnitState;
const SetUnitState = jass.SetUnitState;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
import { 祭祀之杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 祭祀之杖配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
function 是否为祭祀之杖(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return GetItemTypeId(物品) === 祭祀之杖物品ID;
}
export function 处理祭祀之杖使用(上下文) {
    debugLogForce("14．祭祀之杖", "进入", "处理祭祀之杖使用");
    if (!是否为祭祀之杖(上下文.物品))
        return;
    const 施法单位 = 上下文.施法单位;
    if (施法单位 == null || 施法单位 === 0)
        return;
    SetUnitState(施法单位, UNIT_STATE_LIFE, GetUnitState(施法单位, UNIT_STATE_LIFE) - 祭祀之杖配置.生命消耗);
}
