/** @noSelfInFile */
/**
 * 02．目标选择
 *
 * 从仇恨表中选出应攻击目标（返回含 targetRef），施加目标粘性防止频繁横跳。
 * 切换条件：新目标仇恨 >= 当前目标仇恨的 1.2 倍。
 *
 * 初始化时注册清除回调到 00．仇恨存储，实现 removeTarget/clearAllThreat 自动联动清理。
 */
const jass = require("jass.common");
const { getHighestThreat, getThreatByHid, 注册当前目标清除回调, } = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储");
const GetHandleId = jass.GetHandleId;
const 当前目标表 = {};
function 取单位ID(u) {
    if (u == null || u === 0)
        return 0;
    return GetHandleId(u) || 0;
}
function 数字升序排序(a, b) {
    return a - b;
}
function 获取有序当前目标敌人ID列表() {
    const result = [];
    for (const key in 当前目标表) {
        const id = parseInt(key, 10);
        if (!isNaN(id)) {
            result.push(id);
        }
    }
    result.sort(数字升序排序);
    return result;
}
function 清除当前目标(敌人ID, 目标ID) {
    if (敌人ID === 0)
        return;
    if (目标ID === 0) {
        // 全清：clearAllThreat / clearAllThreatById 触发
        delete 当前目标表[敌人ID];
        return;
    }
    // 精确清除：removeTarget 触发，仅当被移除目标是当前目标
    const 记录 = 当前目标表[敌人ID];
    if (记录 != null && 记录.targetHid === 目标ID) {
        delete 当前目标表[敌人ID];
    }
}
// 初始化联动：注册到 00．仇恨存储（仅当被移除目标是当前目标才清理）
注册当前目标清除回调(清除当前目标);
/** 获取当前缓存的攻击目标ID */
export function 获取当前目标ID(敌人) {
    const 敌人ID = 取单位ID(敌人);
    if (敌人ID === 0)
        return 0;
    const 记录 = 当前目标表[敌人ID];
    return 记录 == null ? 0 : 记录.targetHid;
}
/**
 * 根据仇恨表和粘性规则选出应攻击目标。
 * @param filter 由驱动层传入，过滤死亡/超距目标（filter 接收 ThreatEntry，含 targetRef）
 */
export function 获取应攻击目标(敌人, filter) {
    const 敌人ID = 取单位ID(敌人);
    if (敌人ID === 0)
        return null;
    const best = getHighestThreat(敌人, filter);
    if (best == null)
        return null;
    const 当前记录 = 当前目标表[敌人ID];
    if (当前记录 != null && 当前记录.targetHid !== 0 && 当前记录.targetHid !== best.targetHid) {
        const 当前仇恨 = getThreatByHid(敌人, 当前记录.targetHid);
        if (当前仇恨 > 0 && best.threat < 当前仇恨 * 1.2) {
            // 从仇恨表找当前目标的 entry（含 targetRef）
            const entries = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储").getEnemyThreats;
            const 列表 = entries(敌人);
            for (let i = 0; i < 列表.length; i++) {
                if (列表[i].targetHid === 当前记录.targetHid) {
                    return 列表[i];
                }
            }
        }
    }
    return best;
}
/** 设置当前攻击目标缓存 */
export function 设置当前目标(敌人ID, 目标ID) {
    if (敌人ID === 0)
        return;
    当前目标表[敌人ID] = { targetHid: 目标ID };
}
/** 清除所有当前目标缓存 */
export function 清除所有当前目标() {
    const 敌人ID列表 = 获取有序当前目标敌人ID列表();
    for (let i = 0; i < 敌人ID列表.length; i++) {
        delete 当前目标表[敌人ID列表[i]];
    }
}
