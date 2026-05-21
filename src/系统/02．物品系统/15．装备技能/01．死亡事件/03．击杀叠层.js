/** @noSelfInFile */
const jass = require("jass.common");
const itemJudgeFns = require("lib.扩展函数.物品相关函数.index");
import { 获取死亡事件配置, 取物品四字码 } from "./01．死亡事件配置表";
function 给予升级装备(单位, 升级到装备ID) {
    const 升级四字码 = 取物品四字码(升级到装备ID);
    if (!(升级四字码 > 0))
        return;
    const x = jass.GetUnitX(单位);
    const y = jass.GetUnitY(单位);
    const item = jass.CreateItem(升级四字码, x, y);
    if (item == null || item === 0)
        return;
    jass.UnitAddItem(单位, item);
}
function 处理单个击杀叠层(击杀者, 配置) {
    const 物品四字码 = 取物品四字码(配置.装备ID);
    if (!(物品四字码 > 0))
        return;
    const item = itemJudgeFns.GetItemOfTypeFromUnitBJ(击杀者, 物品四字码);
    if (item == null || item === 0)
        return;
    const 当前层数 = jass.GetItemCharges(item);
    if (配置.满层升级到装备名 == null) {
        if (当前层数 >= 配置.最大层数)
            return;
        const 新层数 = 当前层数 + 配置.每次增加层数 >= 配置.最大层数
            ? 配置.最大层数
            : 当前层数 + 配置.每次增加层数;
        jass.SetItemCharges(item, 新层数);
        return;
    }
    const 新层数 = 当前层数 + 配置.每次增加层数;
    jass.SetItemCharges(item, 新层数);
    if (新层数 < 配置.最大层数)
        return;
    jass.RemoveItem(item);
    给予升级装备(击杀者, 配置.满层升级到装备ID);
}
export function 处理击杀叠层(上下文) {
    const 击杀者 = 上下文.击杀单位;
    if (击杀者 == null || 击杀者 === 0)
        return;
    for (const 配置 of 获取死亡事件配置().击杀叠层列表) {
        处理单个击杀叠层(击杀者, 配置);
    }
}
