/** @noSelfInFile */
/**
 * 位移回调模板
 *
 * 为冲锋/击退系统提供可复用的回调工厂函数。
 * 配合 `击退系统.ts` 的 `开始回调`、`结束回调`、`命中回调` 使用。
 */
const jass = require("jass.common");
const AddSpecialEffect = jass["AddSpecialEffect"];
const DestroyEffect = jass["DestroyEffect"];
const GetUnitX = jass["GetUnitX"];
const GetUnitY = jass["GetUnitY"];
const UnitDamageTarget = jass["UnitDamageTarget"];
const { SFB_setBuff, SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统");
// ─── 单功能工厂函数 ──────────────────────────────────────
export function 创建位移开始特效回调(模型路径) {
    return function 位移开始特效回调(单位, _ID) {
        const 特效 = AddSpecialEffect(模型路径, GetUnitX(单位), GetUnitY(单位));
        if (特效 != null && 特效 !== 0) {
            DestroyEffect(特效);
        }
    };
}
export function 创建位移结束特效回调(模型路径) {
    return function 位移结束特效回调(单位, _原因, _ID) {
        const 特效 = AddSpecialEffect(模型路径, GetUnitX(单位), GetUnitY(单位));
        if (特效 != null && 特效 !== 0) {
            DestroyEffect(特效);
        }
    };
}
export function 创建位移结束伤害回调(伤害, 来源) {
    return function 位移结束伤害回调(单位, 原因, _ID) {
        if (原因 === "死亡" || 原因 === "主单位死亡")
            return;
        const 伤害来源 = 来源 ?? 单位;
        UnitDamageTarget(伤害来源, 单位, 伤害, false, false, jass.ATTACK_TYPE_NORMAL, jass.DAMAGE_TYPE_NORMAL, jass.WEAPON_TYPE_WHOKNOWS);
    };
}
export function 创建位移结束控制回调(控制ID, 持续时间) {
    return function 位移结束控制回调(单位, 原因, _ID) {
        if (原因 === "死亡" || 原因 === "主单位死亡")
            return;
        SFB_setBuff(单位, 单位, 控制ID, 持续时间);
    };
}
export function 创建命中特效回调(模型路径) {
    return function 命中特效回调(_移动单位, 目标单位, _ID) {
        const 特效 = AddSpecialEffect(模型路径, GetUnitX(目标单位), GetUnitY(目标单位));
        if (特效 != null && 特效 !== 0) {
            DestroyEffect(特效);
        }
    };
}
export function 创建命中控制回调(控制ID, 持续时间) {
    return function 命中控制回调(移动单位, 目标单位, _ID) {
        SFB_setBuff(移动单位, 目标单位, 控制ID, 持续时间);
    };
}
export function 创建位移回调(选项) {
    const 结果 = {};
    if (选项.开始特效) {
        结果.开始回调 = 创建位移开始特效回调(选项.开始特效);
    }
    const 结束回调列表 = [];
    if (选项.结束特效) {
        结束回调列表.push(创建位移结束特效回调(选项.结束特效));
    }
    if (选项.结束伤害 != null && 选项.结束伤害 > 0) {
        结束回调列表.push(创建位移结束伤害回调(选项.结束伤害, 选项.结束伤害来源));
    }
    if (选项.结束控制 != null && 选项.结束控制时间 != null && 选项.结束控制时间 > 0) {
        结束回调列表.push(创建位移结束控制回调(选项.结束控制, 选项.结束控制时间));
    }
    if (结束回调列表.length > 0) {
        结果.结束回调 = function 合并结束回调(单位, 原因, ID) {
            for (const 回调 of 结束回调列表) {
                回调(单位, 原因, ID);
            }
        };
    }
    const 命中回调列表 = [];
    if (选项.命中特效) {
        命中回调列表.push(创建命中特效回调(选项.命中特效));
    }
    if (选项.命中控制 != null && 选项.命中控制时间 != null && 选项.命中控制时间 > 0) {
        命中回调列表.push(创建命中控制回调(选项.命中控制, 选项.命中控制时间));
    }
    if (命中回调列表.length > 0) {
        结果.命中回调 = function 合并命中回调(移动单位, 目标单位, ID) {
            for (const 回调 of 命中回调列表) {
                回调(移动单位, 目标单位, ID);
            }
        };
    }
    return 结果;
}
