/** @noSelfInFile */
/**
 * 通用函数 - 区域效果
 *
 * 支持持续性区域效果：周期性伤害、进入/离开事件、地面特效等。
 * 使用中心计时器 addPeriodicCallback 做周期检测，不额外创建 timer。
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const GetHandleId = jass.GetHandleId;
const AddSpecialEffect = jass.AddSpecialEffect;
const DestroyEffect = jass.DestroyEffect;
const CreateGroup = jass.CreateGroup;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange;
const FirstOfGroup = jass.FirstOfGroup;
const GroupRemoveUnit = jass.GroupRemoveUnit;
const DestroyGroup = jass.DestroyGroup;
const UnitDamageTarget = jass.UnitDamageTarget;
const EXSetEffectZ = japi.EXSetEffectZ;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
const { addPeriodicCallback, removePeriodicCallback, getServerTime, } = require("系统.00．核心系统.05．中心计时器");
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const { isUnitEnemy, isUnitAlly } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数");
const { 创建渐变圆形提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效");
// ─── 内部实现 ────────────────────────────────────────────
function 数字升序排序(a, b) {
    return a - b;
}
function 获取单位集合有序单位数组(单位集合) {
    const 单位ID列表 = [];
    for (const key in 单位集合) {
        const 单位ID = parseInt(key, 10);
        if (!isNaN(单位ID)) {
            单位ID列表.push(单位ID);
        }
    }
    单位ID列表.sort(数字升序排序);
    const result = [];
    for (let i = 0; i < 单位ID列表.length; i++) {
        const 单位 = 单位集合[单位ID列表[i]];
        if (单位 != null) {
            result.push(单位);
        }
    }
    return result;
}
class 区域效果实现 {
    参数;
    实例ID;
    当前单位集合 = {};
    剩余时间值;
    已暂停值 = false;
    已销毁值 = false;
    特效句柄 = null;
    提示圈特效 = null;
    当前X;
    当前Y;
    检测间隔秒值;
    检测间隔毫秒值;
    下次检测时间毫秒;
    销毁时间毫秒;
    首次检测值 = true;
    防抖间隔毫秒值;
    单位最后进入时间 = {};
    单位最后离开时间 = {};
    constructor(参数) {
        this.实例ID = ++区域效果实例ID计数器;
        this.参数 = 参数;
        this.当前X = 参数.X;
        this.当前Y = 参数.Y;
        this.剩余时间值 = 参数.持续时间;
        this.检测间隔秒值 = 参数.检测间隔 ?? 0.02;
        const 原始毫秒 = this.检测间隔秒值 * 1000;
        this.检测间隔毫秒值 = 原始毫秒 > 20 ? 原始毫秒 : 20;
        this.防抖间隔毫秒值 = (参数.防抖间隔 ?? 0.2) * 1000;
        const 当前时间毫秒 = getServerTime();
        this.下次检测时间毫秒 = 当前时间毫秒 + this.检测间隔毫秒值;
        this.销毁时间毫秒 = 参数.持续时间 > 0 ? 当前时间毫秒 + 参数.持续时间 * 1000 : 0;
        if (参数.模型路径) {
            this.特效句柄 = AddSpecialEffect(参数.模型路径, this.当前X, this.当前Y);
            if (this.特效句柄 && 参数.特效高度) {
                EXSetEffectZ(this.特效句柄, 参数.特效高度);
            }
        }
        // 创建渐变圆形提示圈（白→红），半径=区域半径，持续时间=效果持续时间
        if (参数.显示提示圈 !== false && 参数.持续时间 > 0) {
            this.提示圈特效 = 创建渐变圆形提示圈(this.当前X, this.当前Y, 参数.半径, 参数.持续时间);
        }
        注册区域效果实例(this);
    }
    get 剩余时间() {
        return this.剩余时间值;
    }
    get 当前区域内单位() {
        return 获取单位集合有序单位数组(this.当前单位集合);
    }
    get 已暂停() {
        return this.已暂停值;
    }
    系统Tick(当前时间毫秒) {
        if (this.已暂停值 || this.已销毁值)
            return;
        if (this.销毁时间毫秒 > 0 && 当前时间毫秒 >= this.销毁时间毫秒) {
            this.销毁();
            return;
        }
        if (当前时间毫秒 < this.下次检测时间毫秒) {
            return;
        }
        this.下次检测时间毫秒 = 当前时间毫秒 + this.检测间隔毫秒值;
        this.执行检测();
    }
    执行检测() {
        if (this.已暂停值 || this.已销毁值)
            return;
        const 间隔 = this.检测间隔秒值;
        if (this.参数.持续时间 > 0) {
            this.剩余时间值 -= 间隔;
            if (this.剩余时间值 <= 0) {
                this.销毁();
                return;
            }
        }
        const 当前单位 = getUnitsInRange(this.当前X, this.当前Y, this.参数.半径);
        const 新集合 = {};
        const 是首次 = this.首次检测值;
        if (是首次) {
            this.首次检测值 = false;
        }
        const 当前时间 = getServerTime();
        const 防抖毫秒 = this.防抖间隔毫秒值;
        for (const 单位 of 当前单位) {
            const hid = GetHandleId(单位);
            if (!this.是否影响目标(单位))
                continue;
            新集合[hid] = 单位;
            if (!是首次 && !this.当前单位集合[hid]) {
                const 上次离开 = this.单位最后离开时间[hid];
                if (上次离开 == null || 当前时间 - 上次离开 >= 防抖毫秒) {
                    this.参数.on进入?.(单位, this.参数.回调上下文ID);
                }
                this.单位最后进入时间[hid] = 当前时间;
            }
        }
        for (const hid in this.当前单位集合) {
            if (!新集合[hid]) {
                const 上次进入 = this.单位最后进入时间[hid];
                if (上次进入 == null || 当前时间 - 上次进入 >= 防抖毫秒) {
                    this.参数.on离开?.(this.当前单位集合[hid], this.参数.回调上下文ID);
                }
                this.单位最后离开时间[hid] = 当前时间;
            }
        }
        this.当前单位集合 = 新集合;
        const 当前单位数组 = 获取单位集合有序单位数组(新集合);
        if (this.参数.周期伤害 && this.参数.周期伤害 > 0 && ATTACK_TYPE_NORMAL) {
            const 去重组 = this.参数.周期伤害去重组 ?? 0;
            const 去重间隔毫秒 = (this.参数.周期伤害去重间隔 ?? this.检测间隔秒值) * 1000;
            const 启用去重 = 去重组 > 0;
            for (const 单位 of 当前单位数组) {
                if (启用去重) {
                    const 单位ID = GetHandleId(单位);
                    const 去重Key = make区域效果去重Key(去重组, 单位ID);
                    const 上次伤害时间 = 区域效果周期伤害去重记录[去重Key];
                    if (上次伤害时间 != null && 当前时间 - 上次伤害时间 < 去重间隔毫秒) {
                        continue;
                    }
                    区域效果周期伤害去重记录[去重Key] = 当前时间;
                }
                UnitDamageTarget(this.参数.所有者 ?? 单位, 单位, this.参数.周期伤害, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, null);
            }
        }
        this.参数.on周期?.(当前单位数组, this.参数.回调上下文ID);
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
    销毁() {
        if (this.已销毁值)
            return;
        this.已销毁值 = true;
        注销区域效果实例(this);
        if (this.特效句柄) {
            DestroyEffect(this.特效句柄);
            this.特效句柄 = null;
        }
        if (this.提示圈特效) {
            DestroyEffect(this.提示圈特效);
            this.提示圈特效 = null;
        }
        this.参数.on销毁?.(this.参数.回调上下文ID);
        this.当前单位集合 = {};
        this.单位最后进入时间 = {};
        this.单位最后离开时间 = {};
    }
    暂停() {
        this.已暂停值 = true;
    }
    恢复() {
        this.已暂停值 = false;
    }
    移动到(X, Y) {
        this.当前X = X;
        this.当前Y = Y;
        if (this.特效句柄 && this.参数.模型路径) {
            DestroyEffect(this.特效句柄);
            this.特效句柄 = AddSpecialEffect(this.参数.模型路径, X, Y);
            if (this.特效句柄 && this.参数.特效高度) {
                EXSetEffectZ(this.特效句柄, this.参数.特效高度);
            }
        }
        const 当前时间 = getServerTime();
        const 防抖毫秒 = this.防抖间隔毫秒值;
        for (const hid in this.当前单位集合) {
            const 上次进入 = this.单位最后进入时间[hid];
            if (上次进入 == null || 当前时间 - 上次进入 >= 防抖毫秒) {
                this.参数.on离开?.(this.当前单位集合[hid], this.参数.回调上下文ID);
            }
            this.单位最后离开时间[hid] = 当前时间;
        }
        this.当前单位集合 = {};
    }
}
let 区域效果实例ID计数器 = 0;
let 区域效果系统回调ID = 0;
const 活跃区域效果实例 = [];
const 区域效果周期伤害去重记录 = {};
function make区域效果去重Key(去重组, 单位ID) {
    return `${去重组}:${单位ID}`;
}
function 确保区域效果系统已启动() {
    if (区域效果系统回调ID !== 0) {
        return;
    }
    区域效果系统回调ID = addPeriodicCallback(100, 区域效果系统Tick);
}
function 注册区域效果实例(实例) {
    活跃区域效果实例.push(实例);
    确保区域效果系统已启动();
}
function 注销区域效果实例(实例) {
    const 索引 = 活跃区域效果实例.indexOf(实例);
    if (索引 >= 0) {
        活跃区域效果实例.splice(索引, 1);
    }
    if (活跃区域效果实例.length === 0 && 区域效果系统回调ID !== 0) {
        removePeriodicCallback(区域效果系统回调ID);
        区域效果系统回调ID = 0;
    }
}
function 区域效果系统Tick() {
    const 当前时间毫秒 = getServerTime();
    let 索引 = 0;
    while (索引 < 活跃区域效果实例.length) {
        const 实例 = 活跃区域效果实例[索引];
        实例.系统Tick(当前时间毫秒);
        if (索引 < 活跃区域效果实例.length && 活跃区域效果实例[索引] === 实例) {
            索引++;
        }
    }
}
// ─── 导出 ───────────────────────────────────────────────
export function 创建区域效果(参数) {
    return new 区域效果实现(参数);
}
export function 清理区域效果周期伤害去重组(去重组ID) {
    if (去重组ID <= 0) {
        return;
    }
    const 前缀 = `${去重组ID}:`;
    for (const key in 区域效果周期伤害去重记录) {
        if (key.indexOf(前缀) === 0) {
            delete 区域效果周期伤害去重记录[key];
        }
    }
}
