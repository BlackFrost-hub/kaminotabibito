/** @noSelfInFile */
/**
 * 原地击飞系统
 *
 * 只控制单位飞行高度，不修改 XY。适合水流冲击、喷泉顶起、原地浮空抖动等表现。
 */
import { CENTER_TIMER_TICKS, TICK_INTERVAL, 申请单位暂停占用, 释放单位暂停占用, 单位是否存在其他暂停占用, 零秒后重置单位动画, GetHandleId, GetRandomReal, AddSpecialEffect, DestroyEffect, GetUnitX, GetUnitY, GetUnitFlyHeight, SetUnitFlyHeight, 确保单位可设置飞行高度, 单位存活, 单位已被暂停, } from "./01．跳跃系统/00．共享";
import { 停止单位跳跃 } from "./01．跳跃系统/03．对外接口";
const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器");
const 默认冲击波模型 = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl";
const 活动原地击飞列表 = [];
const 原地击飞映射 = {};
const 单位当前原地击飞 = {};
let 下一个原地击飞ID = 0;
let 已注册到中心计时器 = false;
let tick计数 = 0;
function 分配原地击飞ID() {
    下一个原地击飞ID += 1;
    return 下一个原地击飞ID;
}
function 取单位ID(单位) {
    return (单位 != null && 单位 !== 0 ? GetHandleId(单位) : 0) || 0;
}
function 注册到中心计时器() {
    if (已注册到中心计时器)
        return;
    已注册到中心计时器 = true;
    onTick10ms(on原地击飞系统Tick);
}
function 从中心计时器注销() {
    if (!已注册到中心计时器)
        return;
    已注册到中心计时器 = false;
    offTick10ms(on原地击飞系统Tick);
}
function 尝试收尾中心计时器() {
    if (活动原地击飞列表.length !== 0)
        return;
    tick计数 = 0;
    从中心计时器注销();
}
function 解析高度区间(参数) {
    let 最小高度 = 参数.最小高度 ?? 200;
    let 最大高度 = 参数.最大高度 ?? 250;
    if (最大高度 < 最小高度) {
        const oldMin = 最小高度;
        最小高度 = 最大高度;
        最大高度 = oldMin;
    }
    return { 最小高度, 最大高度 };
}
function 播放冲击波(单位, 模型) {
    const 最终模型 = 模型 == null ? 默认冲击波模型 : 模型;
    if (最终模型 === "")
        return;
    const 特效 = AddSpecialEffect(最终模型, GetUnitX(单位), GetUnitY(单位));
    if (特效 != null && 特效 !== 0) {
        DestroyEffect(特效);
    }
}
function 创建脚下特效(单位, 模型) {
    if (模型 === "")
        return;
    const 特效 = AddSpecialEffect(模型, GetUnitX(单位), GetUnitY(单位));
    if (特效 != null && 特效 !== 0) {
        DestroyEffect(特效);
    }
}
function 内部移除原地击飞(实例) {
    const 击飞ID = 实例.id;
    const 单位ID = 实例.单位ID;
    delete 原地击飞映射[击飞ID];
    if (单位当前原地击飞[单位ID] === 击飞ID) {
        delete 单位当前原地击飞[单位ID];
    }
    const idx = 实例.listIndex;
    const lastIdx = 活动原地击飞列表.length - 1;
    if (idx !== lastIdx) {
        const last = 活动原地击飞列表[lastIdx];
        活动原地击飞列表[idx] = last;
        last.listIndex = idx;
    }
    活动原地击飞列表.pop();
    尝试收尾中心计时器();
}
function 结束原地击飞实例(实例, 原因) {
    if (原地击飞映射[实例.id] !== 实例)
        return;
    const 单位 = 实例.单位;
    const 击飞ID = 实例.id;
    const 结束回调 = 实例.结束回调;
    if (单位 != null && 单位 !== 0 && 实例.上次附加高度 !== 0) {
        const 当前高度 = GetUnitFlyHeight(单位);
        SetUnitFlyHeight(单位, 当前高度 - 实例.上次附加高度, 0);
        实例.上次附加高度 = 0;
    }
    if (实例.暂停单位) {
        释放单位暂停占用(单位, 实例.暂停来源);
    }
    if (单位存活(单位) && 原因 !== "死亡" && 原因 !== "主单位死亡") {
        零秒后重置单位动画(单位);
    }
    内部移除原地击飞(实例);
    if (结束回调 != null) {
        结束回调(单位, 原因, 击飞ID);
    }
}
function 更新原地击飞高度(实例) {
    const 单位 = 实例.单位;
    const 当前高度 = GetUnitFlyHeight(单位);
    const 新附加高度 = GetRandomReal(实例.最小高度, 实例.最大高度);
    SetUnitFlyHeight(单位, 当前高度 - 实例.上次附加高度 + 新附加高度, 0);
    实例.上次附加高度 = 新附加高度;
}
function 更新持续特效(实例) {
    if (实例.持续特效模型 === "")
        return;
    实例.持续特效计时 += TICK_INTERVAL;
    if (实例.持续特效计时 < 实例.持续特效间隔)
        return;
    实例.持续特效计时 = 0;
    创建脚下特效(实例.单位, 实例.持续特效模型);
}
function on原地击飞系统Tick() {
    tick计数 += 1;
    if (tick计数 < CENTER_TIMER_TICKS)
        return;
    tick计数 = 0;
    let i = 0;
    while (i < 活动原地击飞列表.length) {
        const 实例 = 活动原地击飞列表[i];
        if (原地击飞映射[实例.id] !== 实例) {
            i += 1;
            continue;
        }
        if (!单位存活(实例.单位)) {
            结束原地击飞实例(实例, "死亡");
            continue;
        }
        if (实例.主单位死亡时中断 && 实例.主单位 != null && 实例.主单位 !== 0 && !单位存活(实例.主单位)) {
            结束原地击飞实例(实例, "主单位死亡");
            continue;
        }
        if (单位已被暂停(实例.单位)) {
            if (!实例.暂停单位 || 单位是否存在其他暂停占用(实例.单位, 实例.暂停来源)) {
                i += 1;
                continue;
            }
        }
        实例.已运行时间 += TICK_INTERVAL;
        更新原地击飞高度(实例);
        更新持续特效(实例);
        if (实例.已运行时间 >= 实例.持续时间) {
            结束原地击飞实例(实例, "完成");
            continue;
        }
        i += 1;
    }
}
export function 开始原地击飞(单位, 参数) {
    if (!单位存活(单位))
        return 0;
    if (参数.持续时间 == null || 参数.持续时间 <= 0)
        return 0;
    const 单位ID = 取单位ID(单位);
    if (单位ID <= 0)
        return 0;
    停止单位原地击飞(单位, "中断");
    if (参数.中断已有跳跃 !== false) {
        停止单位跳跃(单位, "中断");
    }
    确保单位可设置飞行高度(单位);
    const 击飞ID = 分配原地击飞ID();
    const 高度区间 = 解析高度区间(参数);
    const 实例 = {
        id: 击飞ID,
        listIndex: 活动原地击飞列表.length,
        单位,
        单位ID,
        主单位: 参数.主单位,
        主单位死亡时中断: 参数.主单位死亡时中断 !== false,
        持续时间: 参数.持续时间,
        已运行时间: 0,
        最小高度: 高度区间.最小高度,
        最大高度: 高度区间.最大高度,
        上次附加高度: 0,
        持续特效模型: 参数.持续特效模型 ?? "",
        持续特效间隔: 参数.持续特效间隔 != null && 参数.持续特效间隔 > 0 ? 参数.持续特效间隔 : 0.08,
        持续特效计时: 0,
        暂停单位: 参数.暂停单位 !== false,
        暂停来源: `原地击飞系统:${击飞ID}`,
        结束回调: 参数.结束回调,
    };
    原地击飞映射[击飞ID] = 实例;
    单位当前原地击飞[单位ID] = 击飞ID;
    活动原地击飞列表.push(实例);
    if (实例.暂停单位) {
        申请单位暂停占用(单位, 实例.暂停来源);
    }
    播放冲击波(单位, 参数.冲击波模型);
    if (实例.持续特效模型 !== "") {
        创建脚下特效(单位, 实例.持续特效模型);
    }
    更新原地击飞高度(实例);
    注册到中心计时器();
    if (参数.开始回调 != null) {
        参数.开始回调(单位, 击飞ID);
    }
    return 击飞ID;
}
export function 停止原地击飞(击飞ID, 原因 = "中断") {
    const 实例 = 原地击飞映射[击飞ID];
    if (实例 == null)
        return false;
    结束原地击飞实例(实例, 原因);
    return true;
}
export function 停止单位原地击飞(单位, 原因 = "中断") {
    const 击飞ID = 单位当前原地击飞[取单位ID(单位)] ?? 0;
    if (击飞ID <= 0)
        return false;
    return 停止原地击飞(击飞ID, 原因);
}
export function 单位是否正在原地击飞(单位) {
    const 击飞ID = 单位当前原地击飞[取单位ID(单位)] ?? 0;
    return 击飞ID > 0 && 原地击飞映射[击飞ID] != null;
}
export function 获取单位当前原地击飞ID(单位) {
    return 单位当前原地击飞[取单位ID(单位)] ?? 0;
}
