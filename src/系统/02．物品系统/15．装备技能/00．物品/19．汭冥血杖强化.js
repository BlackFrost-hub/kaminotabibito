/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const jass = require("jass.common");
const GetItemTypeId = jass.GetItemTypeId;
import { 汭冥血杖强化物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 执行汭冥血杖献祭 } from "./18．汭冥血杖";
function 是否为汭冥血杖强化(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return GetItemTypeId(物品) === 汭冥血杖强化物品ID;
}
export function 处理汭冥血杖强化使用(上下文) {
    debugLogForce("20．汭冥血杖强化", "进入", "处理汭冥血杖强化使用");
    if (!是否为汭冥血杖强化(上下文.物品))
        return;
    执行汭冥血杖献祭(上下文, true);
}
