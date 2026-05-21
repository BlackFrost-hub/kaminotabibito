/** @noSelfInFile */
import { DEFAULT_ATTACK_TYPE, DEFAULT_DAMAGE_TYPE, DEFAULT_WEAPON_TYPE, jass, BJ_DEGTORAD, 位移映射, 命中记录, 单位存活, 生成命中键, 播放位移特效, 获取枚举组, 清空枚举组, } from "./00．共享";
const { 沿角度步进直到地形阻挡 } = require("lib.扩展函数.封装函数.01．通用工具.11．地形步进");
const 最小冲锋步进距离 = 30.0;
function 结算命中伤害(实例, 目标单位) {
    if (实例.命中伤害 <= 0)
        return;
    const 来源单位 = 实例.伤害来源 != null && 实例.伤害来源 !== 0 ? 实例.伤害来源 : 实例.单位;
    if (!来源单位 || 来源单位 === 0)
        return;
    jass.UnitDamageTarget(来源单位, 目标单位, 实例.命中伤害, false, false, 实例.攻击类型 ?? DEFAULT_ATTACK_TYPE, 实例.伤害类型 ?? DEFAULT_DAMAGE_TYPE, 实例.武器类型 ?? DEFAULT_WEAPON_TYPE);
}
function 可命中目标(实例, 目标单位) {
    if (!单位存活(目标单位))
        return false;
    if (!实例.允许命中自己 && 目标单位 === 实例.单位)
        return false;
    if (!实例.允许重复命中) {
        const 命中键 = 生成命中键(实例.id, 目标单位);
        if (命中记录[命中键] === true)
            return false;
    }
    if (实例.只命中敌人) {
        const 参考单位 = (实例.伤害来源 != null && 实例.伤害来源 !== 0) ? 实例.伤害来源 : 实例.单位;
        const 所属玩家 = jass.GetOwningPlayer(参考单位);
        if (!jass.IsUnitEnemy(目标单位, 所属玩家))
            return false;
    }
    const 命中过滤 = 实例.命中过滤;
    if (typeof 命中过滤 === "function" && !命中过滤(实例.单位, 目标单位, 实例.id))
        return false;
    return true;
}
function 记录命中(实例, 目标单位) {
    if (实例.允许重复命中)
        return;
    命中记录[生成命中键(实例.id, 目标单位)] = true;
}
function 检查命中(实例) {
    if (实例.命中半径 <= 0)
        return null;
    const 枚举用组 = 获取枚举组();
    jass.GroupEnumUnitsInRange(枚举用组, jass.GetUnitX(实例.单位), jass.GetUnitY(实例.单位), 实例.命中半径, null);
    while (true) {
        const 目标单位 = jass.FirstOfGroup(枚举用组);
        if (目标单位 == null || 目标单位 === 0)
            break;
        jass.GroupRemoveUnit(枚举用组, 目标单位);
        if (!可命中目标(实例, 目标单位))
            continue;
        记录命中(实例, 目标单位);
        结算命中伤害(实例, 目标单位);
        const 命中回调 = 实例.命中回调;
        if (typeof 命中回调 === "function") {
            命中回调(实例.单位, 目标单位, 实例.id);
            if (位移映射[实例.id] !== 实例) {
                清空枚举组();
                return 目标单位;
            }
        }
        if (实例.命中后结束) {
            清空枚举组();
            return 目标单位;
        }
    }
    return null;
}
function 尝试移动一步(实例, 位移距离) {
    const 单位 = 实例.单位;
    const 当前X = jass.GetUnitX(单位);
    const 当前Y = jass.GetUnitY(单位);
    const 弧度 = 实例.角度 * BJ_DEGTORAD;
    let 新X = 当前X + 位移距离 * jass.Cos(弧度);
    let 新Y = 当前Y + 位移距离 * jass.Sin(弧度);
    if (实例.检查地形) {
        const 步进结果 = 沿角度步进直到地形阻挡({
            起点X: 当前X,
            起点Y: 当前Y,
            角度度: 实例.角度,
            单步距离: 位移距离,
            步数: 1,
            检测单位: 单位,
        });
        if (步进结果.实际步数 <= 0) {
            const 撞墙回调 = 实例.撞墙回调;
            if (typeof 撞墙回调 === "function") {
                撞墙回调(单位, 实例.id);
                if (位移映射[实例.id] !== 实例) {
                    return { 停止: true, 原因: "中断" };
                }
            }
            return { 停止: true, 原因: "撞墙" };
        }
        新X = 步进结果.最终X;
        新Y = 步进结果.最终Y;
    }
    if (实例.朝向跟随位移) {
        jass.SetUnitFacing(单位, 实例.角度);
    }
    jass.SetUnitX(单位, 新X);
    jass.SetUnitY(单位, 新Y);
    实例.已移动 += 位移距离;
    const 命中目标 = 检查命中(实例);
    if (命中目标 != null && 命中目标 !== 0) {
        return { 停止: true, 原因: "命中", 命中目标 };
    }
    if (实例.已移动 >= 实例.总距离) {
        return { 停止: true, 原因: "完成" };
    }
    return { 停止: false };
}
export function 推进一步(实例) {
    const 起始已移动 = 实例.已移动;
    const 剩余距离 = 实例.总距离 - 实例.已移动;
    if (剩余距离 <= 0) {
        return { 停止: true, 原因: "完成" };
    }
    let 本Tick位移 = 实例.每Tick位移;
    if (本Tick位移 > 剩余距离) {
        本Tick位移 = 剩余距离;
    }
    if (本Tick位移 < 最小冲锋步进距离 && 剩余距离 > 最小冲锋步进距离) {
        本Tick位移 = 最小冲锋步进距离;
    }
    if (本Tick位移 <= 0) {
        return { 停止: true, 原因: "完成" };
    }
    const 结果 = 尝试移动一步(实例, 本Tick位移);
    if (结果.停止) {
        if (实例.已移动 > 起始已移动) {
            播放位移特效(实例);
        }
        return 结果;
    }
    if (位移映射[实例.id] !== 实例) {
        return { 停止: true, 原因: "中断" };
    }
    if (实例.已移动 > 起始已移动) {
        播放位移特效(实例);
    }
    return { 停止: false };
}
