/** @noSelfInFile */
/**
 * 形状区域 - 动态扇形
 *
 * 支持扇形波前按时间推进。
 * 默认模式为“每 0.02 秒只命中新扫到的那一圈”，也就是由近到远扫过去。
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const AddSpecialEffect = jass.AddSpecialEffect;
const DestroyEffect = jass.DestroyEffect;
const GetHandleId = jass.GetHandleId;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const UnitDamageTarget = jass.UnitDamageTarget;
const EXSetEffectZ = japi.EXSetEffectZ;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
const { addPeriodicCallback, removePeriodicCallback, getServerTime, } = require("系统.00．核心系统.05．中心计时器");
const { isUnitEnemy, isUnitAlly } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数");
const { 获取扇形区域单位 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域");
const { 创建红色扇形提示圈特效, 设置扇形提示圈朝向与尺寸, 重播提示圈动画, 立即销毁提示圈特效 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效");
class 动态扇形实现 {
    参数;
    实例ID;
    当前半径值;
    上次半径值;
    已过时间值 = 0;
    已销毁值 = false;
    特效句柄 = null;
    提示圈特效 = null;
    当前X;
    当前Y;
    检测间隔毫秒值;
    下次检测时间毫秒;
    变化时间毫秒;
    创建时间毫秒;
    半径差值;
    命中记录 = {};
    constructor(参数) {
        this.实例ID = ++动态扇形实例ID计数器;
        this.参数 = 参数;
        this.当前X = 参数.X;
        this.当前Y = 参数.Y;
        this.当前半径值 = 参数.起始半径;
        this.上次半径值 = 参数.起始半径;
        this.半径差值 = 参数.结束半径 - 参数.起始半径;
        this.变化时间毫秒 = 参数.变化时间 * 1000;
        const 原始毫秒 = (参数.检测间隔 ?? 0.02) * 1000;
        this.检测间隔毫秒值 = 原始毫秒 > 20 ? 原始毫秒 : 20;
        const 当前时间毫秒 = getServerTime();
        this.创建时间毫秒 = 当前时间毫秒;
        this.下次检测时间毫秒 = 当前时间毫秒 + this.检测间隔毫秒值;
        if (参数.模型路径) {
            this.特效句柄 = AddSpecialEffect(参数.模型路径, this.当前X, this.当前Y);
            if (this.特效句柄 && 参数.特效高度) {
                EXSetEffectZ(this.特效句柄, 参数.特效高度);
            }
        }
        if (参数.显示提示特效 !== false && 参数.变化时间 > 0) {
            this.提示圈特效 = 创建红色扇形提示圈特效(this.当前X, this.当前Y, 参数.方向角, 取扇形提示圈尺寸(this.当前半径值), 1 / 参数.变化时间);
        }
        注册动态扇形实例(this);
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
        if (当前时间毫秒 - this.创建时间毫秒 >= this.变化时间毫秒) {
            this.上次半径值 = this.当前半径值;
            this.当前半径值 = this.参数.结束半径;
            this.执行检测();
            this.销毁();
            return;
        }
        if (当前时间毫秒 < this.下次检测时间毫秒) {
            return;
        }
        this.下次检测时间毫秒 = 当前时间毫秒 + this.检测间隔毫秒值;
        this.上次半径值 = this.当前半径值;
        const 进度 = (当前时间毫秒 - this.创建时间毫秒) / this.变化时间毫秒;
        this.当前半径值 = this.参数.起始半径 + this.半径差值 * 进度;
        if (this.当前半径值 < 0) {
            this.当前半径值 = 0;
        }
        this.执行检测();
    }
    执行检测() {
        if (this.已销毁值) {
            return;
        }
        const 当前半径 = this.当前半径值;
        if (当前半径 <= 0 || this.参数.扇形角度 <= 0) {
            return;
        }
        if (this.提示圈特效) {
            设置扇形提示圈朝向与尺寸(this.提示圈特效, this.参数.方向角, 取扇形提示圈尺寸(当前半径));
            重播提示圈动画(this.提示圈特效, 0);
        }
        const 所有单位 = 获取扇形区域单位({
            X: this.当前X,
            Y: this.当前Y,
            半径: 当前半径,
            方向角: this.参数.方向角,
            扇形角度: this.参数.扇形角度,
            包含边界: true,
        });
        const 当前命中单位 = [];
        const 只命中新增范围 = this.参数.只命中新增范围 ?? true;
        const 允许重复命中 = this.参数.允许重复命中 ?? false;
        const 内半径 = 只命中新增范围 ? 取较小值(this.上次半径值, 当前半径) : 0;
        const 外半径 = 只命中新增范围 ? 取较大值(this.上次半径值, 当前半径) : 当前半径;
        for (const 单位 of 所有单位) {
            if (!this.是否影响目标(单位)) {
                continue;
            }
            const 距离 = 计算坐标距离(this.当前X, this.当前Y, GetUnitX(单位), GetUnitY(单位));
            if (只命中新增范围) {
                if (距离 > 外半径 || 距离 < 内半径) {
                    continue;
                }
            }
            const 单位ID = 取句柄ID(单位);
            if (!允许重复命中 && this.命中记录[单位ID]) {
                continue;
            }
            当前命中单位.push(单位);
            this.命中记录[单位ID] = true;
            if ((this.参数.伤害值 ?? 0) > 0 && ATTACK_TYPE_NORMAL) {
                UnitDamageTarget(this.参数.所有者 ?? 单位, 单位, this.参数.伤害值 ?? 0, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, null);
            }
            this.参数.on命中?.(单位, 当前半径);
        }
        this.参数.on周期?.(当前命中单位, 当前半径, this.上次半径值);
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
        if (this.已销毁值) {
            return;
        }
        this.已销毁值 = true;
        注销动态扇形实例(this);
        if (this.特效句柄) {
            DestroyEffect(this.特效句柄);
            this.特效句柄 = null;
        }
        if (this.提示圈特效) {
            立即销毁提示圈特效(this.提示圈特效);
            this.提示圈特效 = null;
        }
        this.参数.on销毁?.();
    }
}
let 动态扇形实例ID计数器 = 0;
let 动态扇形系统回调ID = 0;
const 活跃动态扇形实例 = [];
function 取句柄ID(h) {
    return (h != null && h !== 0 ? GetHandleId(h) : 0) || 0;
}
function 计算坐标距离(x1, y1, x2, y2) {
    const dx = x2 - x1;
    const dy = y2 - y1;
    return jass.SquareRoot(dx * dx + dy * dy);
}
function 取较小值(a, b) {
    return a < b ? a : b;
}
function 取较大值(a, b) {
    return a > b ? a : b;
}
function 取扇形提示圈尺寸(半径) {
    if (半径 <= 0) {
        return 0.01;
    }
    return 半径 / 512;
}
function 确保动态扇形系统已启动() {
    if (动态扇形系统回调ID !== 0) {
        return;
    }
    动态扇形系统回调ID = addPeriodicCallback(100, 动态扇形系统Tick);
}
function 注册动态扇形实例(实例) {
    活跃动态扇形实例.push(实例);
    确保动态扇形系统已启动();
}
function 注销动态扇形实例(实例) {
    const 索引 = 活跃动态扇形实例.indexOf(实例);
    if (索引 >= 0) {
        活跃动态扇形实例.splice(索引, 1);
    }
    if (活跃动态扇形实例.length === 0 && 动态扇形系统回调ID !== 0) {
        removePeriodicCallback(动态扇形系统回调ID);
        动态扇形系统回调ID = 0;
    }
}
function 动态扇形系统Tick() {
    const 当前时间毫秒 = getServerTime();
    let 索引 = 0;
    while (索引 < 活跃动态扇形实例.length) {
        const 实例 = 活跃动态扇形实例[索引];
        实例.系统Tick(当前时间毫秒);
        if (索引 < 活跃动态扇形实例.length && 活跃动态扇形实例[索引] === 实例) {
            索引++;
        }
    }
}
export function 创建动态扇形(参数) {
    return new 动态扇形实现(参数);
}
