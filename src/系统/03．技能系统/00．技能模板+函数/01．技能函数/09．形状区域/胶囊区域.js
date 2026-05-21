/** @noSelfInFile */
/**
 * 形状区域 - 胶囊形 / 线段宽度区域
 *
 * 说明：
 * 1. 形状等价于“中间一段线 + 两端半圆”。
 * 2. 适合检测“沿路径扫过、但到结算时只看是否仍停留在路径宽度内”的目标。
 * 3. 先以线段中点粗筛，再做投影精判。
 */
const jass = require("jass.common");
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const CreateGroup = jass.CreateGroup;
const GroupAddUnit = jass.GroupAddUnit;
function 计算平方根(值) {
    return jass.SquareRoot(值);
}
function 计算坐标距离(x1, y1, x2, y2) {
    const dx = x2 - x1;
    const dy = y2 - y1;
    return 计算平方根(dx * dx + dy * dy);
}
function 单位是否在线段宽度区域内部(单位, 起点X, 起点Y, 终点X, 终点Y, 半宽, 包含边界) {
    if (单位 == null || 单位 === 0)
        return false;
    if (半宽 <= 0)
        return false;
    const 线段X = 终点X - 起点X;
    const 线段Y = 终点Y - 起点Y;
    const 线段长度平方 = 线段X * 线段X + 线段Y * 线段Y;
    if (线段长度平方 <= 0.0001) {
        const dx = GetUnitX(单位) - 起点X;
        const dy = GetUnitY(单位) - 起点Y;
        const 距离平方 = dx * dx + dy * dy;
        const 半宽平方 = 半宽 * 半宽;
        return 包含边界 ? 距离平方 <= 半宽平方 : 距离平方 < 半宽平方;
    }
    const 点X = GetUnitX(单位);
    const 点Y = GetUnitY(单位);
    const 到起点X = 点X - 起点X;
    const 到起点Y = 点Y - 起点Y;
    let 投影比例 = (到起点X * 线段X + 到起点Y * 线段Y) / 线段长度平方;
    if (投影比例 < 0) {
        投影比例 = 0;
    }
    else if (投影比例 > 1) {
        投影比例 = 1;
    }
    const 最近点X = 起点X + 线段X * 投影比例;
    const 最近点Y = 起点Y + 线段Y * 投影比例;
    const dx = 点X - 最近点X;
    const dy = 点Y - 最近点Y;
    const 距离平方 = dx * dx + dy * dy;
    const 半宽平方 = 半宽 * 半宽;
    if (包含边界) {
        return 距离平方 <= 半宽平方;
    }
    return 距离平方 < 半宽平方;
}
export function 单位是否在胶囊区域(单位, 起点X, 起点Y, 终点X, 终点Y, 宽度, 包含边界 = true) {
    return 单位是否在线段宽度区域内部(单位, 起点X, 起点Y, 终点X, 终点Y, 宽度 / 2, 包含边界);
}
export function 获取胶囊区域单位(参数) {
    if (参数.宽度 <= 0) {
        return [];
    }
    const 中心X = (参数.起点X + 参数.终点X) / 2;
    const 中心Y = (参数.起点Y + 参数.终点Y) / 2;
    const 线段长度 = 计算坐标距离(参数.起点X, 参数.起点Y, 参数.终点X, 参数.终点Y);
    const 粗筛半径 = 线段长度 / 2 + 参数.宽度 / 2;
    const 候选单位 = getUnitsInRange(中心X, 中心Y, 粗筛半径);
    const 结果 = [];
    for (const 单位 of 候选单位) {
        if (!单位是否在胶囊区域(单位, 参数.起点X, 参数.起点Y, 参数.终点X, 参数.终点Y, 参数.宽度, 参数.包含边界 ?? true)) {
            continue;
        }
        if (参数.单位筛选 != null && !参数.单位筛选(单位)) {
            continue;
        }
        结果.push(单位);
    }
    return 结果;
}
export function 创建胶囊单位组(参数) {
    const 单位组 = CreateGroup();
    const 单位列表 = 获取胶囊区域单位(参数);
    for (const 单位 of 单位列表) {
        GroupAddUnit(单位组, 单位);
    }
    return 单位组;
}
