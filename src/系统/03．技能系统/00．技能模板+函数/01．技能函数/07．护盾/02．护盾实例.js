/** @noSelfInFile */
/**
 * 护盾实例管理
 *
 * 职责：
 * - 护盾实例的创建、存储、删除
 * - 单位与护盾的映射关系
 * - 护盾ID分配
 */
const jass = require("jass.common");
import { 护盾类型, 类型优先级, 默认抵挡优先级 } from "./01．护盾类型";
// ==========================================================================================
// JASS 函数别名
// ==========================================================================================
const GetHandleId = jass.GetHandleId;
// ==========================================================================================
// 数据存储
// ==========================================================================================
/** 护盾ID -> 护盾实例 */
const 护盾映射 = new Map();
/** 单位ID -> 护盾ID列表 */
const 单位护盾映射 = new Map();
/** 下一个护盾ID */
let 下一个护盾ID = 1;
// ==========================================================================================
// 内部工具
// ==========================================================================================
export function 取句柄ID(h) {
    if (h == null || h === 0)
        return 0;
    return GetHandleId(h);
}
function 获取有序护盾ID列表() {
    const result = [];
    for (const 护盾ID of 护盾映射.keys()) {
        result.push(护盾ID);
    }
    result.sort((a, b) => a - b);
    return result;
}
// ==========================================================================================
// 护盾实例管理
// ==========================================================================================
/**
 * 创建护盾实例（不触发开始回调，由调用方负责）
 */
export function 创建护盾实例(单位, 参数) {
    const 单位ID = 取句柄ID(单位);
    if (单位ID === 0)
        return null;
    const id = 下一个护盾ID++;
    const 实例 = {
        id,
        单位,
        单位ID,
        来源单位: 参数.来源单位,
        类型: 参数.类型 ?? 护盾类型.通用,
        初始值: 参数.数值,
        当前值: 参数.数值,
        总持续时间: 参数.持续时间 ?? 0,
        剩余时间: 参数.持续时间 ?? 0,
        类型优先级: 参数.类型优先级 ?? 类型优先级[参数.类型 ?? 护盾类型.通用],
        抵挡优先级: 参数.抵挡优先级 ?? 默认抵挡优先级,
        显示护盾条: 参数.显示护盾条 !== false,
        可驱散: 参数.可驱散 !== false,
        标签: 参数.标签,
        开始回调: 参数.开始回调,
        破碎回调: 参数.破碎回调,
        到期回调: 参数.到期回调,
        结束回调: 参数.结束回调,
    };
    // 存入映射
    护盾映射.set(id, 实例);
    // 更新单位护盾列表
    let 单位护盾列表 = 单位护盾映射.get(单位ID);
    if (单位护盾列表 == null) {
        单位护盾列表 = [];
        单位护盾映射.set(单位ID, 单位护盾列表);
    }
    单位护盾列表.push(id);
    return 实例;
}
/**
 * 获取护盾实例
 */
export function 获取护盾实例(护盾ID) {
    return 护盾映射.get(护盾ID);
}
/**
 * 删除护盾实例（不触发回调，由调用方负责）
 */
export function 删除护盾实例(护盾ID) {
    const 实例 = 护盾映射.get(护盾ID);
    if (实例 == null)
        return false;
    护盾映射.delete(护盾ID);
    // 从单位护盾列表中移除
    const 单位护盾列表 = 单位护盾映射.get(实例.单位ID);
    if (单位护盾列表 != null) {
        const index = 单位护盾列表.indexOf(护盾ID);
        if (index >= 0) {
            单位护盾列表.splice(index, 1);
        }
        if (单位护盾列表.length === 0) {
            单位护盾映射.delete(实例.单位ID);
        }
    }
    return true;
}
/**
 * 获取单位的所有护盾ID
 */
export function 获取单位护盾列表(单位ID) {
    return 单位护盾映射.get(单位ID) ?? [];
}
/**
 * 获取单位的所有护盾实例
 */
export function 获取单位护盾实例列表(单位ID) {
    const ids = 获取单位护盾列表(单位ID);
    const result = [];
    for (const id of ids) {
        const 实例 = 护盾映射.get(id);
        if (实例 != null) {
            result.push(实例);
        }
    }
    return result;
}
/**
 * 删除单位的所有护盾
 */
export function 删除单位所有护盾(单位ID) {
    const ids = 获取单位护盾列表(单位ID);
    const deleted = [];
    for (const id of ids) {
        const 实例 = 护盾映射.get(id);
        if (实例 != null) {
            deleted.push(实例);
        }
        护盾映射.delete(id);
    }
    单位护盾映射.delete(单位ID);
    return deleted;
}
/**
 * 检查单位是否有护盾
 */
export function 单位是否有护盾(单位ID) {
    const list = 单位护盾映射.get(单位ID);
    return list != null && list.length > 0;
}
/**
 * 获取单位总护盾值
 */
export function 获取单位总护盾值(单位ID) {
    const ids = 获取单位护盾列表(单位ID);
    let total = 0;
    for (const id of ids) {
        const 实例 = 护盾映射.get(id);
        if (实例 != null) {
            total += 实例.当前值;
        }
    }
    return total;
}
/**
 * 获取单位指定类型护盾值
 */
export function 获取单位类型护盾值(单位ID, 类型) {
    const ids = 获取单位护盾列表(单位ID);
    let total = 0;
    for (const id of ids) {
        const 实例 = 护盾映射.get(id);
        if (实例 != null && 实例.类型 === 类型) {
            total += 实例.当前值;
        }
    }
    return total;
}
export function 获取单位指定标签护盾实例(单位ID, 标签) {
    if (单位ID === 0 || 标签 === "")
        return undefined;
    const ids = 获取单位护盾列表(单位ID);
    for (const id of ids) {
        const 实例 = 护盾映射.get(id);
        if (实例 != null && 实例.标签 === 标签) {
            return 实例;
        }
    }
    return undefined;
}
export function 获取单位指定标签护盾值(单位ID, 标签) {
    const 实例 = 获取单位指定标签护盾实例(单位ID, 标签);
    return 实例 == null ? 0 : 实例.当前值;
}
export function 充能单位指定标签护盾(单位ID, 标签, 数值, 最大值) {
    const 实例 = 获取单位指定标签护盾实例(单位ID, 标签);
    if (实例 == null || !(数值 > 0))
        return 0;
    const oldValue = 实例.当前值;
    let nextValue = oldValue + 数值;
    if (nextValue > 最大值)
        nextValue = 最大值;
    实例.当前值 = nextValue;
    if (实例.初始值 < nextValue)
        实例.初始值 = nextValue;
    return nextValue - oldValue;
}
export function 删除单位指定标签护盾(单位ID, 标签) {
    const ids = 获取单位护盾列表(单位ID);
    const deleted = [];
    for (let i = ids.length - 1; i >= 0; i--) {
        const id = ids[i];
        const 实例 = 护盾映射.get(id);
        if (实例 != null && 实例.标签 === 标签) {
            deleted.push(实例);
            删除护盾实例(id);
        }
    }
    return deleted;
}
/**
 * 清除所有护盾数据（用于测试或重置）
 */
export function 清除所有护盾数据() {
    护盾映射.clear();
    单位护盾映射.clear();
    下一个护盾ID = 1;
}
/**
 * 获取所有活动护盾实例（供生命周期模块使用）
 */
export function 获取所有活动护盾实例() {
    const result = [];
    const 护盾ID列表 = 获取有序护盾ID列表();
    for (let i = 0; i < 护盾ID列表.length; i++) {
        const 实例 = 护盾映射.get(护盾ID列表[i]);
        if (实例 != null) {
            result.push(实例);
        }
    }
    return result;
}
