/** @noSelfInFile */
/**
 * 牵引系统 - 移动逻辑、闪电效果与牵引实例生命周期
 */
import { IsUnitPaused, SetUnitPathing, PauseUnit, GetUnitX, GetUnitY, SetUnitX, SetUnitY, SetUnitFacing, AddLightning, MoveLightning, MoveLightningEx, DestroyLightning, MAX_SUB_STEP, bj_DEGTORAD, Cos, Sin, 牵引映射, 单位当前牵引, 活动牵引列表, 单位存活, 在可玩区域内, 计算坐标距离, 计算朝向角度, X_IsTerrainWalkable, X_GetAbleX, X_GetAbleY, } from "./00．共享";
function 尝试触发到达回调(实例, 距离中心) {
    if (实例.已触发到达回调 || 实例.到达距离 <= 0)
        return false;
    if (距离中心 > 实例.到达距离)
        return false;
    实例.已触发到达回调 = true;
    if (typeof 实例.到达回调 === "function") {
        实例.到达回调(实例.单位, 实例.id);
    }
    return 实例.到达后结束 === true;
}
function 内部移除牵引(实例) {
    delete 牵引映射[实例.id];
    if (单位当前牵引[实例.单位ID] === 实例.id) {
        delete 单位当前牵引[实例.单位ID];
    }
    销毁闪电(实例);
    const idx = 实例.listIndex;
    const lastIdx = 活动牵引列表.length - 1;
    if (idx !== lastIdx) {
        const last = 活动牵引列表[lastIdx];
        活动牵引列表[idx] = last;
        last.listIndex = idx;
    }
    活动牵引列表.pop();
}
export function 销毁闪电(实例) {
    const 闪电 = 实例.闪电句柄;
    if (闪电 != null && 闪电 !== 0 && typeof DestroyLightning === "function") {
        DestroyLightning(闪电);
    }
    实例.闪电句柄 = undefined;
}
export function 更新闪电(实例) {
    if (!实例.启用闪电效果 || typeof AddLightning !== "function")
        return;
    const 单位X = GetUnitX(实例.单位);
    const 单位Y = GetUnitY(实例.单位);
    const 中心X = 实例.中心X;
    const 中心Y = 实例.中心Y;
    if (实例.闪电句柄 == null || 实例.闪电句柄 === 0) {
        实例.闪电句柄 = AddLightning(实例.闪电效果代码, false, 单位X, 单位Y, 中心X, 中心Y);
        return;
    }
    if (typeof MoveLightningEx === "function") {
        MoveLightningEx(实例.闪电句柄, false, 单位X, 单位Y, 实例.闪电高度, 中心X, 中心Y, 实例.闪电高度);
    }
    else if (typeof MoveLightning === "function") {
        MoveLightning(实例.闪电句柄, false, 单位X, 单位Y, 中心X, 中心Y);
    }
}
function 尝试移动一步(实例, 位移距离) {
    const 当前X = GetUnitX(实例.单位);
    const 当前Y = GetUnitY(实例.单位);
    const 距离中心 = 计算坐标距离(当前X, 当前Y, 实例.中心X, 实例.中心Y);
    if (实例.最大牵引距离 > 0 && 距离中心 > 实例.最大牵引距离) {
        return { 停止: true, 原因: "超距断开" };
    }
    if (尝试触发到达回调(实例, 距离中心)) {
        return { 停止: true, 原因: "完成" };
    }
    if (距离中心 <= 实例.最小距离) {
        return { 停止: true, 原因: "完成" };
    }
    const 实际位移 = 位移距离 >= 距离中心 - 实例.最小距离 ? 距离中心 - 实例.最小距离 : 位移距离;
    if (实际位移 <= 0) {
        return { 停止: true, 原因: "完成" };
    }
    const 角度 = 计算朝向角度(当前X, 当前Y, 实例.中心X, 实例.中心Y);
    const 弧度 = 角度 * bj_DEGTORAD;
    const 新X = 当前X + 实际位移 * Cos(弧度);
    const 新Y = 当前Y + 实际位移 * Sin(弧度);
    if (!在可玩区域内(新X, 新Y)) {
        return { 停止: true, 原因: "阻挡" };
    }
    if (实例.检查地形 && !X_IsTerrainWalkable(新X, 新Y)) {
        const ableDist = 计算坐标距离(新X, 新Y, X_GetAbleX(), X_GetAbleY());
        if (ableDist > 8.0) {
            return { 停止: true, 原因: "阻挡" };
        }
    }
    SetUnitX(实例.单位, 新X);
    SetUnitY(实例.单位, 新Y);
    if (实例.朝向跟随牵引) {
        SetUnitFacing(实例.单位, 角度);
    }
    const 新距离中心 = 计算坐标距离(新X, 新Y, 实例.中心X, 实例.中心Y);
    if (尝试触发到达回调(实例, 新距离中心)) {
        return { 停止: true, 原因: "完成" };
    }
    return { 停止: false };
}
export function 结束牵引实例(实例, 原因) {
    if (牵引映射[实例.id] !== 实例)
        return;
    if (实例.禁用碰撞) {
        SetUnitPathing(实例.单位, true);
    }
    if (实例.暂停单位) {
        PauseUnit(实例.单位, false);
    }
    const 单位 = 实例.单位;
    const 牵引ID = 实例.id;
    const 结束回调 = 实例.结束回调;
    内部移除牵引(实例);
    if (typeof 结束回调 === "function") {
        结束回调(单位, 原因, 牵引ID);
    }
}
export function 推进牵引实例(实例) {
    if (!单位存活(实例.单位)) {
        结束牵引实例(实例, "死亡");
        return;
    }
    if (实例.主单位死亡时中断 && 实例.主单位 != null && 实例.主单位 !== 0 && !单位存活(实例.主单位)) {
        结束牵引实例(实例, "主单位死亡");
        return;
    }
    if (实例.中心单位 != null && 实例.中心单位 !== 0) {
        if (!单位存活(实例.中心单位)) {
            结束牵引实例(实例, "中心失效");
            return;
        }
        实例.中心X = GetUnitX(实例.中心单位);
        实例.中心Y = GetUnitY(实例.中心单位);
    }
    if (实例.外部暂停时中断 && !实例.暂停单位 && IsUnitPaused(实例.单位) === true) {
        结束牵引实例(实例, "中断");
        return;
    }
    实例.已运行Tick数 += 1;
    if (实例.已运行Tick数 > 实例.持续Tick数) {
        结束牵引实例(实例, "完成");
        return;
    }
    let 剩余位移 = 实例.每Tick位移;
    while (剩余位移 > 0) {
        const 子步长 = 剩余位移 > MAX_SUB_STEP ? MAX_SUB_STEP : 剩余位移;
        const 结果 = 尝试移动一步(实例, 子步长);
        if (结果.停止) {
            结束牵引实例(实例, 结果.原因 ?? "完成");
            return;
        }
        剩余位移 -= 子步长;
    }
    更新闪电(实例);
}
