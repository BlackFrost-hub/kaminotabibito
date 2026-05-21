/** @noSelfInFile */
/**
 * 牵引系统 - 对外接口
 */
import { 推进下一个牵引ID, 单位当前牵引, 单位存活, 取句柄ID, 快照单位组, 计算每Tick位移, 计算持续Tick数, 解析中心坐标, SetUnitPathing, PauseUnit, 活动牵引列表, 牵引映射, } from "./00．共享";
import { 更新闪电 } from "./01．移动与闪电";
import { 结束牵引ID, 注册到中心计时器 } from "./02．驱动与实例";
function 创建牵引实例(单位, 参数) {
    if (!单位存活(单位))
        return null;
    if (typeof 参数.目标筛选 === "function" && 参数.目标筛选(单位) !== true)
        return null;
    const 主单位 = 参数.主单位 ?? 参数.中心单位;
    const 中心坐标 = 解析中心坐标(参数);
    if (!中心坐标)
        return null;
    const 单位ID = 取句柄ID(单位);
    if (单位ID === 0)
        return null;
    const 旧牵引ID = 单位当前牵引[单位ID];
    if (旧牵引ID != null) {
        结束牵引ID(旧牵引ID, "中断");
    }
    const 实例 = {
        id: 推进下一个牵引ID(),
        listIndex: 活动牵引列表.length,
        单位,
        单位ID,
        主单位,
        主单位死亡时中断: 参数.主单位死亡时中断 !== false,
        中心单位: 参数.中心单位,
        中心X: 中心坐标.x,
        中心Y: 中心坐标.y,
        每Tick位移: 计算每Tick位移(参数),
        持续Tick数: 计算持续Tick数(参数),
        已运行Tick数: 0,
        最小距离: 参数.最小距离 != null ? 参数.最小距离 : 96,
        到达距离: 参数.到达距离 != null ? 参数.到达距离 : 0,
        最大牵引距离: 参数.最大牵引距离 != null && 参数.最大牵引距离 > 0 ? 参数.最大牵引距离 : 0,
        到达后结束: 参数.到达后结束,
        到达回调: 参数.到达回调,
        已触发到达回调: false,
        检查地形: 参数.检查地形 !== false,
        禁用碰撞: 参数.禁用碰撞 === true,
        暂停单位: 参数.暂停单位 === true,
        朝向跟随牵引: 参数.朝向跟随牵引 !== false,
        外部暂停时中断: 参数.外部暂停时中断 === true,
        闪电效果代码: 参数.闪电效果代码 && 参数.闪电效果代码 !== "" ? 参数.闪电效果代码 : "CLPB",
        闪电高度: 参数.闪电高度 != null ? 参数.闪电高度 : 60,
        启用闪电效果: 参数.启用闪电效果 !== false,
        结束回调: 参数.结束回调,
        开始回调: 参数.开始回调,
    };
    if (实例.禁用碰撞) {
        SetUnitPathing(单位, false);
    }
    if (实例.暂停单位) {
        PauseUnit(单位, true);
    }
    活动牵引列表.push(实例);
    牵引映射[实例.id] = 实例;
    单位当前牵引[单位ID] = 实例.id;
    更新闪电(实例);
    注册到中心计时器();
    if (typeof 参数.开始回调 === "function") {
        参数.开始回调(单位, 实例.id);
    }
    return 实例;
}
export function 开始牵引(单位, 参数) {
    const 实例 = 创建牵引实例(单位, 参数);
    return 实例 ? 实例.id : 0;
}
export function 开始单位组牵引(单位组, 参数) {
    const 结果 = [];
    for (const 单位 of 快照单位组(单位组)) {
        const 牵引ID = 开始牵引(单位, 参数);
        if (牵引ID > 0) {
            结果.push(牵引ID);
        }
    }
    return 结果;
}
export function 停止牵引(牵引ID) {
    return 结束牵引ID(牵引ID, "中断");
}
export function 停止单位牵引(单位) {
    const 单位ID = 取句柄ID(单位);
    if (单位ID === 0)
        return false;
    const 牵引ID = 单位当前牵引[单位ID];
    if (牵引ID == null)
        return false;
    return 停止牵引(牵引ID);
}
export function 单位是否正在被牵引(单位) {
    const 单位ID = 取句柄ID(单位);
    return 单位ID !== 0 && 单位当前牵引[单位ID] != null;
}
export function 获取单位当前牵引ID(单位) {
    const 单位ID = 取句柄ID(单位);
    return 单位ID !== 0 ? (单位当前牵引[单位ID] ?? 0) : 0;
}
export function 获取活跃牵引数量() {
    return 活动牵引列表.length;
}
