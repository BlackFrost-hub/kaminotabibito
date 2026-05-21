/** @noSelfInFile */
/**
 * 跳链 - 单位绑定闪电
 *
 * 说明：
 * 1. 用于让闪电效果在持续时间内跟随两个单位，而不是只取创建瞬间坐标。
 * 2. 适合跳链、治疗波、生命汲取等“短时单位到单位连线”表现。
 * 3. 这是跳链内部辅助层，不负责查找目标或伤害/治疗结算。
 */
const jass = require("jass.common");
const AddLightningEx = jass.AddLightningEx;
const MoveLightningEx = jass.MoveLightningEx;
const DestroyLightning = jass.DestroyLightning;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget;
const DestroyEffect = jass.DestroyEffect;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitFlyHeight = jass.GetUnitFlyHeight;
const SetLightningColor = jass.SetLightningColor;
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器");
const { isValidUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数");
const 活跃单位绑定闪电 = {};
let 下一个单位绑定闪电ID = 0;
let 单位绑定闪电回调ID = 0;
const 待销毁特效列表 = [];
let 特效销毁回调ID = 0;
// 约定规则：
// 闪电表现底层最短持续时间固定为 0.8 秒。
// 外部即使传入更短的持续时间，也统一按 0.8 秒处理，
// 避免闪电链刚创建就销毁，视觉上看起来像没有生效。
const 闪电最短持续时间秒 = 0.8;
const 默认命中特效持续时间秒 = 1;
function 获取闪电命中特效模型(效果代码) {
    if (效果代码 === "HWPB" || 效果代码 === "HWSB") {
        return "Abilities\\Spells\\Orc\\HealingWave\\HealingWaveTarget.mdl";
    }
    if (效果代码 === "DRAB" || 效果代码 === "DRAL" || 效果代码 === "DRAM") {
        return "Abilities\\Spells\\Other\\Drain\\DrainTarget.mdl";
    }
    if (效果代码 === "LEAS" || 效果代码 === "ROP") {
        return "Abilities\\Spells\\Human\\AerialShackles\\AerialShacklesTarget.mdl";
    }
    if (效果代码 === "AFOD") {
        return "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl";
    }
    if (效果代码 === "SPLK") {
        return "Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkZapTarget.mdl";
    }
    if (效果代码 === "CLPB" || 效果代码 === "CLSB" || 效果代码 === "FORK" || 效果代码 === "CHIM" || 效果代码 === "MFPB") {
        return "Abilities\\Weapons\\Bolt\\BoltImpact.mdl";
    }
    return "Abilities\\Weapons\\Bolt\\BoltImpact.mdl";
}
function 规范闪电持续时间(持续时间) {
    return 持续时间 >= 闪电最短持续时间秒 ? 持续时间 : 闪电最短持续时间秒;
}
function on命中特效销毁Tick() {
    const 当前时间毫秒 = getServerTime();
    for (let i = 待销毁特效列表.length - 1; i >= 0; i--) {
        const 记录 = 待销毁特效列表[i];
        if (当前时间毫秒 < 记录.到期时间毫秒)
            continue;
        DestroyEffect(记录.句柄);
        待销毁特效列表.splice(i, 1);
    }
    if (待销毁特效列表.length === 0 && 特效销毁回调ID !== 0) {
        removePeriodicCallback(特效销毁回调ID);
        特效销毁回调ID = 0;
    }
}
function 安排命中特效销毁(effect, 持续时间秒) {
    if (effect == null || effect === 0)
        return;
    if (特效销毁回调ID === 0) {
        特效销毁回调ID = addPeriodicCallback(100, on命中特效销毁Tick);
    }
    待销毁特效列表.push({
        句柄: effect,
        到期时间毫秒: getServerTime() + 持续时间秒 * 1000,
    });
}
function 播放闪电命中特效(效果代码, 终点单位) {
    if (!isValidUnit(终点单位))
        return;
    const 模型 = 获取闪电命中特效模型(效果代码);
    if (模型 === "")
        return;
    const effect = AddSpecialEffectTarget(模型, 终点单位, "origin");
    安排命中特效销毁(effect, 默认命中特效持续时间秒);
}
function 销毁单位绑定闪电实例(实例) {
    delete 活跃单位绑定闪电[实例.id];
    if (实例.闪电句柄 != null && 实例.闪电句柄 !== 0) {
        DestroyLightning(实例.闪电句柄);
    }
}
function 计算单位绑定闪电Z(单位, 高度偏移) {
    return GetUnitFlyHeight(单位) + 高度偏移;
}
function 更新单位绑定闪电(实例) {
    const 起点单位 = 实例.起点单位;
    const 终点单位 = 实例.终点单位;
    if (实例.任一死亡时销毁) {
        if (!isValidUnit(起点单位) || !isValidUnit(终点单位)) {
            销毁单位绑定闪电实例(实例);
            return false;
        }
    }
    else {
        if (起点单位 == null || 起点单位 === 0 || 终点单位 == null || 终点单位 === 0) {
            销毁单位绑定闪电实例(实例);
            return false;
        }
    }
    MoveLightningEx(实例.闪电句柄, false, GetUnitX(起点单位), GetUnitY(起点单位), 计算单位绑定闪电Z(起点单位, 实例.起点高度偏移), GetUnitX(终点单位), GetUnitY(终点单位), 计算单位绑定闪电Z(终点单位, 实例.终点高度偏移));
    return true;
}
function on单位绑定闪电Tick() {
    const 当前时间毫秒 = getServerTime();
    let 仍有活跃实例 = false;
    for (const 实例ID文本 in 活跃单位绑定闪电) {
        const 实例 = 活跃单位绑定闪电[实例ID文本];
        if (实例 == null) {
            continue;
        }
        if (当前时间毫秒 >= 实例.到期时间毫秒) {
            销毁单位绑定闪电实例(实例);
            continue;
        }
        if (更新单位绑定闪电(实例)) {
            仍有活跃实例 = true;
        }
    }
    if (!仍有活跃实例 && 单位绑定闪电回调ID !== 0) {
        removePeriodicCallback(单位绑定闪电回调ID);
        单位绑定闪电回调ID = 0;
    }
}
function 确保单位绑定闪电Tick已启动() {
    if (单位绑定闪电回调ID !== 0) {
        return;
    }
    单位绑定闪电回调ID = addPeriodicCallback(20, on单位绑定闪电Tick);
}
export function 创建单位绑定闪电(参数) {
    if (参数.效果代码 == null || 参数.效果代码 === "")
        return null;
    if (参数.起点单位 == null || 参数.起点单位 === 0)
        return null;
    if (参数.终点单位 == null || 参数.终点单位 === 0)
        return null;
    if (参数.持续时间 <= 0)
        return null;
    if (!isValidUnit(参数.起点单位) || !isValidUnit(参数.终点单位))
        return null;
    const 持续时间秒 = 规范闪电持续时间(参数.持续时间);
    const 起点高度偏移 = 参数.起点高度偏移 ?? 60;
    const 终点高度偏移 = 参数.终点高度偏移 ?? 60;
    const 闪电句柄 = AddLightningEx(参数.效果代码, false, GetUnitX(参数.起点单位), GetUnitY(参数.起点单位), 计算单位绑定闪电Z(参数.起点单位, 起点高度偏移), GetUnitX(参数.终点单位), GetUnitY(参数.终点单位), 计算单位绑定闪电Z(参数.终点单位, 终点高度偏移));
    if (闪电句柄 == null || 闪电句柄 === 0) {
        return null;
    }
    const 颜色 = 参数.颜色;
    if (颜色 != null) {
        SetLightningColor(闪电句柄, 颜色.r, 颜色.g, 颜色.b, 颜色.a);
    }
    播放闪电命中特效(参数.效果代码, 参数.终点单位);
    下一个单位绑定闪电ID += 1;
    const 实例 = {
        id: 下一个单位绑定闪电ID,
        闪电句柄,
        起点单位: 参数.起点单位,
        终点单位: 参数.终点单位,
        起点高度偏移,
        终点高度偏移,
        到期时间毫秒: getServerTime() + 持续时间秒 * 1000,
        任一死亡时销毁: 参数.任一死亡时销毁 !== false,
    };
    活跃单位绑定闪电[实例.id] = 实例;
    确保单位绑定闪电Tick已启动();
    return 闪电句柄;
}
