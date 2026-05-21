/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const jass = require("jass.common");
const japi = require("jass.japi");
const { createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效");
const { getObjectPropertyRealSafe, ObjectType } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版");
const GetItemTypeId = jass.GetItemTypeId;
const GetUnitState = jass.GetUnitState;
const GetUnitTypeId = jass.GetUnitTypeId;
const KillUnit = jass.KillUnit;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE;
const EXSetEffectSize = japi.EXSetEffectSize;
import { 幽冥法杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 幽冥法杖配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
function 是否为幽冥法杖(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return GetItemTypeId(物品) === 幽冥法杖物品ID;
}
export function 处理幽冥法杖使用(上下文) {
    debugLogForce("15．幽冥法杖", "进入", "处理幽冥法杖使用");
    if (!是否为幽冥法杖(上下文.物品))
        return;
    const 目标单位 = 上下文.目标单位;
    if (目标单位 == null || 目标单位 === 0)
        return;
    if (GetUnitState(目标单位, UNIT_STATE_MAX_LIFE) * 幽冥法杖配置.斩杀生命比例 < GetUnitState(目标单位, UNIT_STATE_LIFE))
        return;
    KillUnit(目标单位);
    const 特效 = createUnitEffect(目标单位, 幽冥法杖配置.特效挂点, 幽冥法杖配置.特效路径, 幽冥法杖配置.特效持续时间, "幽冥法杖");
    if (特效 != null && 特效 !== 0) {
        EXSetEffectSize(特效, getObjectPropertyRealSafe(ObjectType.UNIT, GetUnitTypeId(目标单位), "modelScale"));
    }
}
