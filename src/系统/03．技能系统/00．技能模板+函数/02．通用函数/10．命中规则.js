/**
 * 通用函数 - 命中规则模板
 *
 * 说明：
 * 1. 这里只处理“命中后怎么管”，不负责查找单位、移动、伤害、特效。
 * 2. 当前版本不依赖弹幕系统，可先给冲锋、跳跃、区域、落点打击等模块复用。
 * 3. 弹道穿透、回程再命中等规则后续可在这个状态结构上继续扩展。
 */
const jass = require("jass.common");
const GetHandleId = jass.GetHandleId;
function 取单位ID(单位) {
    if (单位 == null || 单位 === 0)
        return 0;
    return GetHandleId(单位) || 0;
}
function 获取每单位最大命中次数(参数) {
    if (参数.每单位只命中一次 === true) {
        return 1;
    }
    const 次数 = 参数.每单位最大命中次数 ?? 0;
    return 次数 > 0 ? 次数 : 0;
}
export function 创建命中规则状态(参数 = {}) {
    return {
        参数,
        总命中次数: 0,
        是否已停止: false,
        停止原因: "未停止",
        单位命中次数: {},
    };
}
export function 重置命中规则状态(状态) {
    状态.总命中次数 = 0;
    状态.是否已停止 = false;
    状态.停止原因 = "未停止";
    状态.单位命中次数 = {};
}
export function 获取单位已命中次数(状态, 单位) {
    const 单位ID = 取单位ID(单位);
    if (单位ID <= 0)
        return 0;
    return 状态.单位命中次数[单位ID] ?? 0;
}
export function 单位是否还能命中(状态, 单位) {
    if (状态.是否已停止)
        return false;
    const 单位ID = 取单位ID(单位);
    if (单位ID <= 0)
        return false;
    const 目标筛选 = 状态.参数.目标筛选;
    if (目标筛选 != null && !目标筛选(单位))
        return false;
    const 每单位最大命中次数 = 获取每单位最大命中次数(状态.参数);
    if (每单位最大命中次数 > 0 && 获取单位已命中次数(状态, 单位) >= 每单位最大命中次数) {
        return false;
    }
    const 最大总命中次数 = 状态.参数.最大总命中次数 ?? 0;
    if (最大总命中次数 > 0 && 状态.总命中次数 >= 最大总命中次数) {
        状态.是否已停止 = true;
        状态.停止原因 = "总命中上限";
        return false;
    }
    return true;
}
export function 记录单位命中(状态, 单位) {
    if (!单位是否还能命中(状态, 单位)) {
        return false;
    }
    const 单位ID = 取单位ID(单位);
    状态.单位命中次数[单位ID] = (状态.单位命中次数[单位ID] ?? 0) + 1;
    状态.总命中次数 += 1;
    if (状态.参数.首个命中后停止 === true && 状态.总命中次数 >= 1) {
        状态.是否已停止 = true;
        状态.停止原因 = "首个命中";
        return true;
    }
    if (状态.参数.命中后停止 === true) {
        状态.是否已停止 = true;
        状态.停止原因 = "命中后停止";
        return true;
    }
    const 最大总命中次数 = 状态.参数.最大总命中次数 ?? 0;
    if (最大总命中次数 > 0 && 状态.总命中次数 >= 最大总命中次数) {
        状态.是否已停止 = true;
        状态.停止原因 = "总命中上限";
    }
    return true;
}
export function 处理单位命中规则(状态, 单位) {
    return 记录单位命中(状态, 单位);
}
export function 命中规则是否应停止(状态) {
    return 状态.是否已停止;
}
