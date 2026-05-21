/** @noSelfInFile */
/**
 * 形状区域 - 矩形 / 条形区域
 *
 * 说明：
 * 1. 支持“中心点 + 朝向 + 长宽”的普通矩形判定。
 * 2. 支持“起点 -> 终点 + 宽度”的条形区域判定，适合路径落地统一结算。
 * 3. 先做圆形粗筛，再做局部坐标精判。
 */
const jass = require("jass.common");
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const CreateGroup = jass.CreateGroup;
const GroupAddUnit = jass.GroupAddUnit;
function 绝对值(值) {
    return 值 < 0 ? -值 : 值;
}
function 计算平方根(值) {
    return jass.SquareRoot(值);
}
function 计算坐标距离(x1, y1, x2, y2) {
    const dx = x2 - x1;
    const dy = y2 - y1;
    return 计算平方根(dx * dx + dy * dy);
}
function 计算矩形粗筛半径(长度, 宽度) {
    const 半长 = 长度 / 2;
    const 半宽 = 宽度 / 2;
    return 计算平方根(半长 * 半长 + 半宽 * 半宽);
}
function 计算方向单位向量(方向角) {
    return {
        X: jass.Cos(方向角 * jass.bj_DEGTORAD),
        Y: jass.Sin(方向角 * jass.bj_DEGTORAD),
    };
}
function 单位是否在已归一矩形区域(单位, 中心X, 中心Y, 半长, 半宽, 方向X, 方向Y, 包含边界) {
    if (单位 == null || 单位 === 0)
        return false;
    if (半长 <= 0 || 半宽 <= 0)
        return false;
    const 单位X = GetUnitX(单位);
    const 单位Y = GetUnitY(单位);
    const dx = 单位X - 中心X;
    const dy = 单位Y - 中心Y;
    const 前向投影 = dx * 方向X + dy * 方向Y;
    const 侧向投影 = dx * (-方向Y) + dy * 方向X;
    const 绝对前向 = 绝对值(前向投影);
    const 绝对侧向 = 绝对值(侧向投影);
    if (包含边界) {
        return 绝对前向 <= 半长 && 绝对侧向 <= 半宽;
    }
    return 绝对前向 < 半长 && 绝对侧向 < 半宽;
}
export function 单位是否在矩形区域(单位, X, Y, 长度, 宽度, 方向角, 包含边界 = true) {
    if (长度 <= 0 || 宽度 <= 0)
        return false;
    const 半长 = 长度 / 2;
    const 半宽 = 宽度 / 2;
    const 方向 = 计算方向单位向量(方向角);
    return 单位是否在已归一矩形区域(单位, X, Y, 半长, 半宽, 方向.X, 方向.Y, 包含边界);
}
export function 获取矩形区域单位(参数) {
    if (参数.长度 <= 0 || 参数.宽度 <= 0) {
        return [];
    }
    const 粗筛半径 = 计算矩形粗筛半径(参数.长度, 参数.宽度);
    const 候选单位 = getUnitsInRange(参数.X, 参数.Y, 粗筛半径);
    const 结果 = [];
    for (const 单位 of 候选单位) {
        if (!单位是否在矩形区域(单位, 参数.X, 参数.Y, 参数.长度, 参数.宽度, 参数.方向角, 参数.包含边界 ?? true)) {
            continue;
        }
        if (参数.单位筛选 != null && !参数.单位筛选(单位)) {
            continue;
        }
        结果.push(单位);
    }
    return 结果;
}
export function 创建矩形单位组(参数) {
    const 单位组 = CreateGroup();
    const 单位列表 = 获取矩形区域单位(参数);
    for (const 单位 of 单位列表) {
        GroupAddUnit(单位组, 单位);
    }
    return 单位组;
}
export function 单位是否在条形区域(单位, 起点X, 起点Y, 终点X, 终点Y, 宽度, 包含边界 = true) {
    if (宽度 <= 0)
        return false;
    const 长度 = 计算坐标距离(起点X, 起点Y, 终点X, 终点Y);
    if (长度 <= 0) {
        return false;
    }
    const 中心X = (起点X + 终点X) / 2;
    const 中心Y = (起点Y + 终点Y) / 2;
    const 方向X = (终点X - 起点X) / 长度;
    const 方向Y = (终点Y - 起点Y) / 长度;
    return 单位是否在已归一矩形区域(单位, 中心X, 中心Y, 长度 / 2, 宽度 / 2, 方向X, 方向Y, 包含边界);
}
export function 获取条形区域单位(参数) {
    if (参数.宽度 <= 0) {
        return [];
    }
    const 长度 = 计算坐标距离(参数.起点X, 参数.起点Y, 参数.终点X, 参数.终点Y);
    if (长度 <= 0) {
        return [];
    }
    const 中心X = (参数.起点X + 参数.终点X) / 2;
    const 中心Y = (参数.起点Y + 参数.终点Y) / 2;
    const 粗筛半径 = 计算矩形粗筛半径(长度, 参数.宽度);
    const 候选单位 = getUnitsInRange(中心X, 中心Y, 粗筛半径);
    const 结果 = [];
    for (const 单位 of 候选单位) {
        if (!单位是否在条形区域(单位, 参数.起点X, 参数.起点Y, 参数.终点X, 参数.终点Y, 参数.宽度, 参数.包含边界 ?? true)) {
            continue;
        }
        if (参数.单位筛选 != null && !参数.单位筛选(单位)) {
            continue;
        }
        结果.push(单位);
    }
    return 结果;
}
export function 创建条形单位组(参数) {
    const 单位组 = CreateGroup();
    const 单位列表 = 获取条形区域单位(参数);
    for (const 单位 of 单位列表) {
        GroupAddUnit(单位组, 单位);
    }
    return 单位组;
}
