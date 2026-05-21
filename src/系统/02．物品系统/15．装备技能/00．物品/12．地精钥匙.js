/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const jass = require("jass.common");
const jglobals = require("jass.globals");
const { ModifyGateBJ } = require("lib.扩展函数.BJ函数.07．杂项");
const GetItemTypeId = jass.GetItemTypeId;
const IsDestructableInvulnerable = jass.IsDestructableInvulnerable;
const SetDestructableInvulnerable = jass.SetDestructableInvulnerable;
const bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN;
import { 地精钥匙物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
function 是否为地精钥匙(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return GetItemTypeId(物品) === 地精钥匙物品ID;
}
export function 处理地精钥匙使用(上下文) {
    debugLogForce("13．地精钥匙", "进入", "处理地精钥匙使用");
    if (!是否为地精钥匙(上下文.物品))
        return;
    const 大门 = 上下文.目标可破坏物;
    if (大门 == null || 大门 === 0)
        return;
    if (IsDestructableInvulnerable(大门))
        return;
    ModifyGateBJ(bj_GATEOPERATION_OPEN, 大门);
    SetDestructableInvulnerable(大门, true);
}
