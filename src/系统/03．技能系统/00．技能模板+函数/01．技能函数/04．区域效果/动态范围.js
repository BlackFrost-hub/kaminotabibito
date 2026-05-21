/** @noSelfInFile */
/**
 * 通用函数 - 动态范围
 * 支持半径随时间动态变化的范围伤害效果。
 * 扩散：起始半径 → 结束半径（从小到大）
 * 收缩：起始半径 → 结束半径（从大到小）
 * 每次 tick 对当前半径内目标造成一次伤害。
 * 使用中心计时器 addPeriodicCallback 做周期检测，不额外创建 timer。
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const AddSpecialEffect = jass.AddSpecialEffect;
const DestroyEffect = jass.DestroyEffect;
const UnitDamageTarget = jass.UnitDamageTarget;
const EXSetEffectZ = japi.EXSetEffectZ;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
const { addPeriodicCallback, removePeriodicCallback, getServerTime, } = require("系统.00．核心系统.05．中心计时器");
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const { isUnitEnemy, isUnitAlly } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数");
const { 创建薄圆形提示圈特效, 立即销毁提示圈特效 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效");
class 动态范围实现 {
    参数;
    实例ID;
    当前半径值;
    已过时间值 = 0;
    已销毁值 = false;
    特效句柄 = null;
    提示圈特效 = null;
    当前X;
    当前Y;
    半径差值;
    检测间隔毫秒值;
    当前段目标时间毫秒;
    变化时间毫秒;
    创建时间毫秒;
    结束时间毫秒;
    constructor(参数) {
        this.实例ID = ++动态范围实例ID计数器;
        this.参数 = 参数;
        this.当前X = 参数.X;
        this.当前Y = 参数.Y;
        this.当前半径值 = 参数.起始半径;
        this.半径差值 = 参数.结束半径 - 参数.起始半径;
        this.变化时间毫秒 = 参数.变化时间 * 1000;
        const 原始毫秒 = (参数.检测间隔 ?? 0.1) * 1000;
        this.检测间隔毫秒值 = 原始毫秒 > 20 ? 原始毫秒 : 20;
        const 当前时间毫秒 = getServerTime();
        this.创建时间毫秒 = 当前时间毫秒;
        this.结束时间毫秒 = 当前时间毫秒 + this.变化时间毫秒;
        this.当前段目标时间毫秒 = 取较小值(this.创建时间毫秒 + this.检测间隔毫秒值, this.结束时间毫秒);
        if (参数.模型路径) {
            this.特效句柄 = AddSpecialEffect(参数.模型路径, this.当前X, this.当前Y);
            if (this.特效句柄 && 参数.特效高度) {
                EXSetEffectZ(this.特效句柄, 参数.特效高度);
            }
        }
        if (参数.变化时间 > 0) {
            this.创建当前段提示特效(this.创建时间毫秒);
        }
        注册动态范围实例(this);
    }
    get 当前半径() {
        return this.当前半径值;
    }
    get 已过时间() {
        return this.已过时间值;
    }
    get 已销毁() {
        return this.已销毁值;
    }
    系统Tick(当前时间毫秒) {
        if (this.已销毁值) {
            return;
        }
        this.已过时间值 = (当前时间毫秒 - this.创建时间毫秒) / 1000;
        if (当前时间毫秒 < this.当前段目标时间毫秒) {
            return;
        }
        while (!this.已销毁值 && 当前时间毫秒 >= this.当前段目标时间毫秒) {
            this.销毁当前段提示特效();
            this.当前半径值 = this.取指定时间半径(this.当前段目标时间毫秒);
            this.执行检测();
            if (this.当前段目标时间毫秒 >= this.结束时间毫秒) {
                this.销毁();
                return;
            }
            this.当前段目标时间毫秒 = 取较小值(this.当前段目标时间毫秒 + this.检测间隔毫秒值, this.结束时间毫秒);
            if (当前时间毫秒 < this.当前段目标时间毫秒) {
                this.创建当前段提示特效(当前时间毫秒);
            }
        }
    }
    执行检测() {
        if (this.已销毁值) {
            return;
        }
        const 当前半径 = this.当前半径值;
        if (当前半径 <= 0) {
            return;
        }
        const 所有单位 = getUnitsInRange(this.当前X, this.当前Y, 当前半径);
        const 目标单位 = [];
        for (const 单位 of 所有单位) {
            if (this.是否影响目标(单位)) {
                目标单位.push(单位);
            }
        }
        if ((this.参数.伤害值 ?? 0) > 0 && ATTACK_TYPE_NORMAL) {
            for (const 单位 of 目标单位) {
                UnitDamageTarget(this.参数.所有者 ?? 单位, 单位, this.参数.伤害值 ?? 0, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, null);
            }
        }
        this.参数.on周期?.(目标单位, 当前半径);
    }
    是否影响目标(单位) {
        const 影响目标 = this.参数.影响目标 ?? "敌方";
        const 所有者 = this.参数.所有者;
        if (影响目标 === "全部")
            return true;
        if (!所有者)
            return true;
        if (影响目标 === "敌方")
            return isUnitEnemy(单位, 所有者);
        return isUnitAlly(单位, 所有者);
    }
    取指定时间半径(目标时间毫秒) {
        if (this.变化时间毫秒 <= 0) {
            return this.参数.结束半径;
        }
        let 进度 = (目标时间毫秒 - this.创建时间毫秒) / this.变化时间毫秒;
        if (进度 < 0) {
            进度 = 0;
        }
        else if (进度 > 1) {
            进度 = 1;
        }
        const 半径 = this.参数.起始半径 + this.半径差值 * 进度;
        return 半径 < 0 ? 0 : 半径;
    }
    创建当前段提示特效(当前时间毫秒) {
        if (this.参数.变化时间 <= 0) {
            return;
        }
        const 当前段目标半径 = this.取指定时间半径(this.当前段目标时间毫秒);
        if (当前段目标半径 <= 0) {
            return;
        }
        const 剩余持续时间毫秒 = this.当前段目标时间毫秒 - 当前时间毫秒;
        if (剩余持续时间毫秒 <= 0) {
            return;
        }
        const 剩余持续时间秒 = 剩余持续时间毫秒 / 1000;
        this.提示圈特效 = 创建薄圆形提示圈特效(this.当前X, this.当前Y, 当前段目标半径, 1 / 剩余持续时间秒, this.参数.所有者);
    }
    销毁当前段提示特效() {
        if (!this.提示圈特效) {
            return;
        }
        立即销毁提示圈特效(this.提示圈特效);
        this.提示圈特效 = null;
    }
    销毁() {
        if (this.已销毁值) {
            return;
        }
        this.已销毁值 = true;
        注销动态范围实例(this);
        if (this.特效句柄) {
            DestroyEffect(this.特效句柄);
            this.特效句柄 = null;
        }
        this.销毁当前段提示特效();
        this.参数.on销毁?.();
    }
}
let 动态范围实例ID计数器 = 0;
let 动态范围系统回调ID = 0;
const 活跃动态范围实例 = [];
function 确保动态范围系统已启动() {
    if (动态范围系统回调ID !== 0) {
        return;
    }
    动态范围系统回调ID = addPeriodicCallback(20, 动态范围系统Tick);
}
function 注册动态范围实例(实例) {
    活跃动态范围实例.push(实例);
    确保动态范围系统已启动();
}
function 注销动态范围实例(实例) {
    const 索引 = 活跃动态范围实例.indexOf(实例);
    if (索引 >= 0) {
        活跃动态范围实例.splice(索引, 1);
    }
    if (活跃动态范围实例.length === 0 && 动态范围系统回调ID !== 0) {
        removePeriodicCallback(动态范围系统回调ID);
        动态范围系统回调ID = 0;
    }
}
function 动态范围系统Tick() {
    const 当前时间毫秒 = getServerTime();
    let 索引 = 0;
    while (索引 < 活跃动态范围实例.length) {
        const 实例 = 活跃动态范围实例[索引];
        实例.系统Tick(当前时间毫秒);
        if (索引 < 活跃动态范围实例.length && 活跃动态范围实例[索引] === 实例) {
            索引++;
        }
    }
}
export function 创建动态范围(参数) {
    return new 动态范围实现(参数);
}
function 取较小值(a, b) {
    return a < b ? a : b;
}
