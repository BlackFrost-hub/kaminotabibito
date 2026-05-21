/** @noSelfInFile */
/**
 * 冲锋残影表现模板
 *
 * 说明：
 * 1. 这是“冲锋位移 + 表现”的组合模板，不修改冲锋/击退底层。
 * 2. 残影改用特效模拟，不再用马甲单位。
 * 3. `DzSetEffectAnimation` / `DzPlayEffectAnimation` 为平台扩展 API，可能只在平台环境可用。
 * 4. 残影生命周期统一交给 `YDWETimerDestroyEffect`，其底层走中心计时器回收。
 */
const jass = require("jass.common");
let japi = null;
try {
    japi = require("jass.japi");
}
catch (_e) {
    japi = null;
}
const { 开始冲锋, 获取单位当前位移ID, } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统");
const { YDWETimerDestroyEffect, getObjectProperty, ObjectType, } = require("lib.扩展函数.YDWE函数.00．YDWE函数");
const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器");
const AddSpecialEffect = jass["AddSpecialEffect"];
const GetUnitX = jass["GetUnitX"];
const GetUnitY = jass["GetUnitY"];
const GetUnitTypeId = jass["GetUnitTypeId"];
const GetUnitState = jass["GetUnitState"];
const SetUnitAnimationByIndex = jass["SetUnitAnimationByIndex"];
const SetUnitAnimation = jass["SetUnitAnimation"];
const SetUnitTimeScale = jass["SetUnitTimeScale"];
const GetUnitFlyHeight = jass["GetUnitFlyHeight"];
const SetUnitFlyHeight = jass["SetUnitFlyHeight"];
const UnitAddAbility = jass["UnitAddAbility"];
const UnitRemoveAbility = jass["UnitRemoveAbility"];
const R2I = jass["R2I"];
const DzSetEffectAnimation = japi?.DzSetEffectAnimation;
const DzPlayEffectAnimation = japi?.DzPlayEffectAnimation;
const DzSetEffectVertexColor = japi?.DzSetEffectVertexColor;
const DzSetEffectVertexAlpha = japi?.DzSetEffectVertexAlpha;
const DzSetEffectScale = japi?.DzSetEffectScale;
const EXSetEffectXY = japi?.EXSetEffectXY;
const EXSetEffectZ = japi?.EXSetEffectZ;
const EXSetEffectSize = japi?.EXSetEffectSize;
const EXSetEffectSpeed = japi?.EXSetEffectSpeed;
const TICK_INTERVAL = 0.01;
const UNIT_ALIVE_LIFE = 0.405;
const DEFAULT_AFTERIMAGE_INTERVAL = 0.05;
const DEFAULT_AFTERIMAGE_LIFETIME = 0.35;
const DEFAULT_AFTERIMAGE_ALPHA = 160;
const DEFAULT_AFTERIMAGE_SCALE = 1.0;
const DEFAULT_ANIMATION_SPEED = 1.0;
const CROW_FORM_ABILITY_ID = 1097691750;
const 活动冲锋残影表现列表 = [];
const 冲锋残影表现映射 = {};
let 已注册到中心计时器 = false;
function 单位存活(u) {
    return u != null && u !== 0 && GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}
function 限制到字节(v) {
    if (v <= 0)
        return 0;
    if (v >= 255)
        return 255;
    return R2I(v);
}
function 组装颜色值(r, g, b) {
    return 限制到字节(r) * 65536 + 限制到字节(g) * 256 + 限制到字节(b);
}
function 确保单位可设置飞行高度(单位) {
    UnitAddAbility(单位, CROW_FORM_ABILITY_ID);
    UnitRemoveAbility(单位, CROW_FORM_ABILITY_ID);
}
function 解析残影模型(单位, 参数) {
    if (参数.残影模型 != null && 参数.残影模型 !== "") {
        return 参数.残影模型;
    }
    const 残影单位类型 = 参数.残影单位类型 ?? GetUnitTypeId(单位);
    if (残影单位类型 == null || 残影单位类型 === 0 || 残影单位类型 === "") {
        return "";
    }
    return getObjectProperty(ObjectType.UNIT, 残影单位类型, "file") || "";
}
function 应用单位动画表现(单位, 参数) {
    if (参数.动画序号 != null) {
        SetUnitAnimationByIndex(单位, 参数.动画序号);
    }
    else if (参数.动画名 != null && 参数.动画名 !== "") {
        SetUnitAnimation(单位, 参数.动画名);
    }
    if (参数.动画速度 != null && 参数.动画速度 > 0) {
        SetUnitTimeScale(单位, 参数.动画速度);
    }
}
function 恢复单位表现(实例) {
    if (实例.单位 != null && 实例.单位 !== 0) {
        SetUnitTimeScale(实例.单位, 1.0);
        if (实例.已应用飞行高度变化 && 实例.飞行高度变化 !== 0) {
            const 当前高度 = GetUnitFlyHeight(实例.单位);
            SetUnitFlyHeight(实例.单位, 当前高度 - 实例.飞行高度变化, 0);
            实例.已应用飞行高度变化 = false;
        }
    }
}
function 销毁冲锋残影表现实例(实例) {
    恢复单位表现(实例);
    delete 冲锋残影表现映射[实例.冲锋ID];
    const idx = 活动冲锋残影表现列表.indexOf(实例);
    if (idx >= 0) {
        活动冲锋残影表现列表.splice(idx, 1);
    }
    if (活动冲锋残影表现列表.length === 0 && 已注册到中心计时器) {
        已注册到中心计时器 = false;
        offTick10ms(on冲锋残影表现Tick);
    }
}
function 创建一次残影(实例) {
    const effect = AddSpecialEffect(实例.残影模型, GetUnitX(实例.单位), GetUnitY(实例.单位));
    if (effect == null || effect === 0)
        return;
    if (typeof EXSetEffectXY === "function") {
        EXSetEffectXY(effect, GetUnitX(实例.单位), GetUnitY(实例.单位));
    }
    if (typeof EXSetEffectZ === "function" && 实例.飞行高度变化 !== 0) {
        EXSetEffectZ(effect, 实例.飞行高度变化);
    }
    if (typeof DzSetEffectScale === "function") {
        DzSetEffectScale(effect, 实例.残影缩放);
    }
    if (typeof EXSetEffectSize === "function") {
        EXSetEffectSize(effect, 实例.残影缩放);
    }
    if (typeof EXSetEffectSpeed === "function") {
        EXSetEffectSpeed(effect, 实例.动画速度);
    }
    if (typeof DzSetEffectAnimation === "function" && 实例.动画序号 != null) {
        DzSetEffectAnimation(effect, 实例.动画序号, 0);
    }
    if (typeof DzPlayEffectAnimation === "function" && 实例.动画名 != null && 实例.动画名 !== "") {
        DzPlayEffectAnimation(effect, 实例.动画名, "");
    }
    if (typeof DzSetEffectVertexColor === "function") {
        DzSetEffectVertexColor(effect, 组装颜色值(实例.染色R, 实例.染色G, 实例.染色B));
    }
    if (typeof DzSetEffectVertexAlpha === "function") {
        DzSetEffectVertexAlpha(effect, 实例.残影透明度);
    }
    YDWETimerDestroyEffect(实例.残影生命周期, effect);
}
function on冲锋残影表现Tick() {
    let i = 0;
    while (i < 活动冲锋残影表现列表.length) {
        const 实例 = 活动冲锋残影表现列表[i];
        if (!单位存活(实例.单位) || 获取单位当前位移ID(实例.单位) !== 实例.冲锋ID) {
            销毁冲锋残影表现实例(实例);
            continue;
        }
        实例.下次生成剩余时间 -= TICK_INTERVAL;
        if (实例.下次生成剩余时间 <= 0) {
            创建一次残影(实例);
            实例.下次生成剩余时间 += 实例.残影生成间隔;
        }
        i += 1;
    }
}
function 注册到中心计时器() {
    if (已注册到中心计时器)
        return;
    已注册到中心计时器 = true;
    onTick10ms(on冲锋残影表现Tick);
}
export function 开始冲锋并附带残影表现(单位, 位移参数, 表现参数) {
    const 冲锋ID = 开始冲锋(单位, 位移参数);
    if (冲锋ID <= 0)
        return 0;
    const 残影模型 = 解析残影模型(单位, 表现参数);
    if (残影模型 === "") {
        return 冲锋ID;
    }
    应用单位动画表现(单位, 表现参数);
    const 飞行高度变化 = 表现参数.飞行高度变化 ?? 0;
    if (飞行高度变化 !== 0) {
        确保单位可设置飞行高度(单位);
        SetUnitFlyHeight(单位, GetUnitFlyHeight(单位) + 飞行高度变化, 0);
    }
    const 实例 = {
        冲锋ID,
        单位,
        残影模型,
        动画序号: 表现参数.动画序号,
        动画名: 表现参数.动画名,
        动画速度: 表现参数.动画速度 != null && 表现参数.动画速度 > 0 ? 表现参数.动画速度 : DEFAULT_ANIMATION_SPEED,
        残影生命周期: 表现参数.残影生命周期 != null && 表现参数.残影生命周期 > 0 ? 表现参数.残影生命周期 : DEFAULT_AFTERIMAGE_LIFETIME,
        残影透明度: 表现参数.残影透明度 != null ? 限制到字节(表现参数.残影透明度) : DEFAULT_AFTERIMAGE_ALPHA,
        染色R: 表现参数.染色R != null ? 限制到字节(表现参数.染色R) : 255,
        染色G: 表现参数.染色G != null ? 限制到字节(表现参数.染色G) : 255,
        染色B: 表现参数.染色B != null ? 限制到字节(表现参数.染色B) : 255,
        残影生成间隔: 表现参数.残影生成间隔 != null && 表现参数.残影生成间隔 > 0 ? 表现参数.残影生成间隔 : DEFAULT_AFTERIMAGE_INTERVAL,
        下次生成剩余时间: 0,
        飞行高度变化,
        已应用飞行高度变化: 飞行高度变化 !== 0,
        残影缩放: 表现参数.残影缩放 != null && 表现参数.残影缩放 > 0 ? 表现参数.残影缩放 : DEFAULT_AFTERIMAGE_SCALE,
    };
    冲锋残影表现映射[冲锋ID] = 实例;
    活动冲锋残影表现列表.push(实例);
    创建一次残影(实例);
    实例.下次生成剩余时间 = 实例.残影生成间隔;
    注册到中心计时器();
    return 冲锋ID;
}
