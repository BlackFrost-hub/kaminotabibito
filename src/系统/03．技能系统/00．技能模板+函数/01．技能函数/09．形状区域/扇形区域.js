/** @noSelfInFile */
/**
 * 形状区域 - 扇形区域
 *
 * 说明：
 * 1. 先用圆形范围粗筛，再按“与中心方向的最小夹角”做扇形判定。
 * 2. 正确处理跨 0° / 360° 的扇形，不走 `a1~a2` 直接区间比较。
 * 3. 默认边界算命中。
 */
const jass = require("jass.common");
const jglobals = require("jass.globals");
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const CreateGroup = jass.CreateGroup;
const GroupAddUnit = jass.GroupAddUnit;
const bj_RADTODEG = jglobals.bj_RADTODEG ?? 57.29577951308232;
function 标准化角度(角度) {
    let 结果 = 角度;
    while (结果 < 0) {
        结果 += 360;
    }
    while (结果 >= 360) {
        结果 -= 360;
    }
    return 结果;
}
function 绝对值(值) {
    return 值 < 0 ? -值 : 值;
}
function 取最小夹角(角度A, 角度B) {
    let 差值 = 标准化角度(角度A - 角度B);
    if (差值 > 180) {
        差值 = 360 - 差值;
    }
    return 绝对值(差值);
}
function 取坐标朝向角(源X, 源Y, 目标X, 目标Y) {
    return jass.Atan2(目标Y - 源Y, 目标X - 源X) * bj_RADTODEG;
}
export function 单位是否在扇形区域(单位, X, Y, 半径, 方向角, 扇形角度, 包含边界 = true) {
    if (单位 == null || 单位 === 0)
        return false;
    if (半径 <= 0 || 扇形角度 <= 0)
        return false;
    const 单位X = GetUnitX(单位);
    const 单位Y = GetUnitY(单位);
    const dx = 单位X - X;
    const dy = 单位Y - Y;
    const 距离平方 = dx * dx + dy * dy;
    const 半径平方 = 半径 * 半径;
    if (距离平方 > 半径平方) {
        return false;
    }
    if (距离平方 <= 0.0001) {
        return true;
    }
    if (扇形角度 >= 360) {
        return true;
    }
    const 中心方向 = 标准化角度(方向角);
    const 单位方向 = 标准化角度(取坐标朝向角(X, Y, 单位X, 单位Y));
    const 半角 = 扇形角度 / 2;
    const 夹角 = 取最小夹角(单位方向, 中心方向);
    if (包含边界) {
        return 夹角 <= 半角;
    }
    return 夹角 < 半角;
}
export function 获取扇形区域单位(参数) {
    if (参数.半径 <= 0 || 参数.扇形角度 <= 0) {
        return [];
    }
    const 候选单位 = getUnitsInRange(参数.X, 参数.Y, 参数.半径);
    const 结果 = [];
    for (const 单位 of 候选单位) {
        if (!单位是否在扇形区域(单位, 参数.X, 参数.Y, 参数.半径, 参数.方向角, 参数.扇形角度, 参数.包含边界 ?? true)) {
            continue;
        }
        if (参数.单位筛选 != null && !参数.单位筛选(单位)) {
            continue;
        }
        结果.push(单位);
    }
    return 结果;
}
export function 创建扇形单位组(参数) {
    const 单位组 = CreateGroup();
    const 单位列表 = 获取扇形区域单位(参数);
    for (const 单位 of 单位列表) {
        GroupAddUnit(单位组, 单位);
    }
    return 单位组;
}
