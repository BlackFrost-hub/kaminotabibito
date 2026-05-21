/** @noSelfInFile */
/**
 * 03．仇恨驱动
 *
 * 核心驱动，每0.25秒执行一次：
 * 1. 遍历所有有仇恨表的敌人
 * 2. 死亡清理
 * 3. 选择应攻击目标（filter 排除死亡/超距）
 * 4. 目标变更时更新缓存并下发一次 attack 命令；同目标不重复抢命令
 *
 * 目标引用直接从仇恨表的 targetRef 获取，无需额外注册。
 */
const jass = require("jass.common");
const { getAllTrackedEnemyIds, clearAllThreatById, hasThreatTable, getEnemyRef, getEnemyLastThreatUpdateTimeById, 清理敌人过期仇恨条目ById, 仇恨整表超时毫秒, } = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储");
const { 获取应攻击目标, 获取当前目标ID, 设置当前目标, 清除所有当前目标, } = require("系统.01．单位系统.06．仇恨系统.02．目标选择");
const { 更新仇恨显示, 清除仇恨显示ById, 清除所有仇恨显示, } = require("系统.01．单位系统.06．仇恨系统.04．仇恨显示");
const { 自动展开仇恨面板一次 } = require("系统.09．表现系统.05．仇恨面板.05．仇恨面板");
const GetHandleId = jass.GetHandleId;
const IsUnitType = jass.IsUnitType;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const IssueTargetOrder = jass.IssueTargetOrder;
const GetOwningPlayer = jass.GetOwningPlayer;
const GetPlayerId = jass.GetPlayerId;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;
const MAX_DISTANCE_SQ = 2500 * 2500;
const ISSUE_ORDER_DISTANCE_SQ = 1000 * 1000;
let 周期回调ID = 0;
const 模块名 = "仇恨系统";
let _nowMs = null;
function 取单位ID(u) {
    if (u == null || u === 0)
        return 0;
    return GetHandleId(u) || 0;
}
function nowMs() {
    if (_nowMs == null) {
        _nowMs = require("系统.00．核心系统.05．中心计时器").getServerTime;
    }
    return _nowMs();
}
function 清理敌人仇恨状态(敌人ID) {
    清除仇恨显示ById(敌人ID);
    clearAllThreatById(敌人ID);
}
function 尝试自动展开目标玩家仇恨面板(target) {
    if (target == null || target === 0)
        return;
    const owner = GetOwningPlayer(target);
    if (owner == null || owner === 0)
        return;
    const playerId = GetPlayerId(owner);
    自动展开仇恨面板一次(playerId);
}
/** 过滤回调：单位死亡或超距时排除 */
function 构建过滤函数(ex, ey, maxDistanceSq) {
    return (entry) => {
        const ref = entry.targetRef;
        if (ref == null || ref === 0)
            return false;
        if (IsUnitType(ref, UNIT_TYPE_DEAD))
            return false;
        const tx = GetUnitX(ref);
        const ty = GetUnitY(ref);
        const dx = tx - ex;
        const dy = ty - ey;
        return dx * dx + dy * dy <= maxDistanceSq;
    };
}
/** 驱动 Tick：通过敌人引用表拿到敌人单位，再驱动攻击 */
function onTick() {
    const 敌人ID列表 = getAllTrackedEnemyIds();
    for (let i = 0; i < 敌人ID列表.length; i++) {
        const 敌人ID = 敌人ID列表[i];
        const 敌人 = getEnemyRef(敌人ID);
        if (敌人 == null || 敌人 === 0) {
            清理敌人仇恨状态(敌人ID);
            continue;
        }
        if (IsUnitType(敌人, UNIT_TYPE_DEAD)) {
            清理敌人仇恨状态(敌人ID);
            continue;
        }
        清理敌人过期仇恨条目ById(敌人ID);
        if (!hasThreatTable(敌人ID)) {
            清除仇恨显示ById(敌人ID);
            continue;
        }
        const 最近受伤时间 = getEnemyLastThreatUpdateTimeById(敌人ID);
        if (最近受伤时间 > 0 && nowMs() - 最近受伤时间 >= 仇恨整表超时毫秒) {
            清理敌人仇恨状态(敌人ID);
            continue;
        }
        const ex = GetUnitX(敌人);
        const ey = GetUnitY(敌人);
        const filter = 构建过滤函数(ex, ey, MAX_DISTANCE_SQ);
        const issueOrderFilter = 构建过滤函数(ex, ey, ISSUE_ORDER_DISTANCE_SQ);
        const best = 获取应攻击目标(敌人, filter);
        const issueOrderBest = 获取应攻击目标(敌人, issueOrderFilter);
        if (best == null) {
            清理敌人仇恨状态(敌人ID);
            continue;
        }
        const 当前目标ID = 获取当前目标ID(敌人);
        if (best.targetRef == null || best.targetRef === 0) {
            清理敌人仇恨状态(敌人ID);
            continue;
        }
        更新仇恨显示(敌人, best.targetRef, best.threat);
        尝试自动展开目标玩家仇恨面板(best.targetRef);
        if (issueOrderBest == null || issueOrderBest.targetRef == null || issueOrderBest.targetRef === 0) {
            continue;
        }
        if (当前目标ID !== issueOrderBest.targetHid) {
            // 仅对 1000 码内存在的仇恨目标下攻击命令，避免远目标无视野时反复抢命令
            IssueTargetOrder(敌人, "attack", issueOrderBest.targetRef);
            设置当前目标(敌人ID, issueOrderBest.targetHid);
        }
    }
}
/** 带敌人引用的外部驱动入口（由调用方在 tick 外调用，传入敌人单位引用） */
export function 驱动单个敌人(敌人) {
    const 敌人ID = 取单位ID(敌人);
    if (敌人ID === 0)
        return;
    if (!hasThreatTable(敌人ID))
        return;
    if (IsUnitType(敌人, UNIT_TYPE_DEAD)) {
        清理敌人仇恨状态(敌人ID);
        return;
    }
    清理敌人过期仇恨条目ById(敌人ID);
    if (!hasThreatTable(敌人ID)) {
        清除仇恨显示ById(敌人ID);
        return;
    }
    const 最近受伤时间 = getEnemyLastThreatUpdateTimeById(敌人ID);
    if (最近受伤时间 > 0 && nowMs() - 最近受伤时间 >= 仇恨整表超时毫秒) {
        清理敌人仇恨状态(敌人ID);
        return;
    }
    const ex = GetUnitX(敌人);
    const ey = GetUnitY(敌人);
    const filter = 构建过滤函数(ex, ey, MAX_DISTANCE_SQ);
    const issueOrderFilter = 构建过滤函数(ex, ey, ISSUE_ORDER_DISTANCE_SQ);
    const best = 获取应攻击目标(敌人, filter);
    const issueOrderBest = 获取应攻击目标(敌人, issueOrderFilter);
    if (best == null) {
        清理敌人仇恨状态(敌人ID);
        return;
    }
    const 当前目标ID = 获取当前目标ID(敌人);
    if (best.targetRef == null || best.targetRef === 0) {
        清理敌人仇恨状态(敌人ID);
        return;
    }
    更新仇恨显示(敌人, best.targetRef, best.threat);
    尝试自动展开目标玩家仇恨面板(best.targetRef);
    if (issueOrderBest == null || issueOrderBest.targetRef == null || issueOrderBest.targetRef === 0) {
        return;
    }
    if (当前目标ID !== issueOrderBest.targetHid) {
        IssueTargetOrder(敌人, "attack", issueOrderBest.targetRef);
        设置当前目标(敌人ID, issueOrderBest.targetHid);
    }
}
/** 初始化仇恨系统：注册 0.25 秒周期回调 */
export function 初始化仇恨系统() {
    if (周期回调ID !== 0)
        return;
    const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器");
    周期回调ID = addPeriodicCallback(250, onTick);
}
/** 停用仇恨系统 */
export function 停用仇恨系统() {
    if (周期回调ID === 0)
        return;
    const { removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器");
    removePeriodicCallback(周期回调ID);
    周期回调ID = 0;
    清除所有当前目标();
    清除所有仇恨显示();
}
