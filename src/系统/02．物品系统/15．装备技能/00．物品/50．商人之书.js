/** @noSelfInFile */
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 英雄主属性是智力, 增加英雄经验与智力, 取句柄ID } from "../05．物品使用/00．公共/02．物品使用工具";
const 已参悟表 = {};
export function 处理商人之书使用(ctx) {
    if (!是否为使用物品(ctx.物品, 物品使用装备ID.商人之书))
        return;
    const unit = ctx.施法单位;
    const id = 取句柄ID(unit);
    if (id === 0 || 已参悟表[id] === true)
        return;
    if (!英雄主属性是智力(unit))
        return;
    已参悟表[id] = true;
    const cfg = 物品使用数值配置.商人之书;
    增加英雄经验与智力(unit, cfg.经验次数, cfg.每次经验, cfg.智力增加);
}
