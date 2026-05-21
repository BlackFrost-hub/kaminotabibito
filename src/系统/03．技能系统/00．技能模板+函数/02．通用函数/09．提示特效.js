/** @noSelfInFile */
/**
 * 提示特效系统
 *
 * 快速创建技能预警提示圈：矩形、扇形、圆形
 * 模型路径：resource\models\Tip\
 *
 * 动画速度说明（所有特效通用）：
 * - 默认 1倍速 = 1秒延迟（动画播放1秒）
 * - 0.5倍 = 2秒延迟（动画播放2秒，更慢）
 * - 2倍 = 0.5秒延迟（动画播放0.5秒，更快）
 * - 支持传入 speed 参数自定义动画速率
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具");
// ==========================================================================================
// JASS 函数别名
// ==========================================================================================
const { RMaxBJ, RMinBJ, CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数");
const AddSpecialEffect = jass.AddSpecialEffect;
const CreateTimer = jass.CreateTimer;
const DestroyEffect = jass.DestroyEffect;
const GetExpiredTimer = jass.GetExpiredTimer;
const GetHandleId = jass.GetHandleId;
const GetOwningPlayer = jass.GetOwningPlayer;
const GetPlayerId = jass.GetPlayerId;
const Player = jass.Player;
const EXSetEffectSpeed = japi.EXSetEffectSpeed;
const EXSetEffectSize = japi.EXSetEffectSize;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ;
const EXEffectMatScale = japi.EXEffectMatScale;
const DzSetEffectVertexColor = japi.DzSetEffectVertexColor;
const DzSetEffectVertexAlpha = japi.DzSetEffectVertexAlpha;
const DzSetEffectAnimation = japi.DzSetEffectAnimation;
const DzPlayEffectAnimation = japi.DzPlayEffectAnimation;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const SetUnitScale = jass.SetUnitScale;
const SetUnitTimeScale = jass.SetUnitTimeScale;
const SetUnitVertexColor = jass.SetUnitVertexColor;
const RemoveUnit = jass.RemoveUnit;
// ==========================================================================================
// 模型路径
// ==========================================================================================
const MODEL_DIR = "resource\\models\\Tip\\skillTip\\";
const MODEL_SQUARE1X = MODEL_DIR + "Abiltip_Square1x.mdx";
const MODEL_SQUARE2X = MODEL_DIR + "Abiltip_Square2x.mdx";
const MODEL_SQUARE3X = MODEL_DIR + "Abiltip_Square3x.mdx";
const MODEL_SQUARE4X = MODEL_DIR + "Abiltip_Square4x.mdx";
const MODEL_SQUARE5X = MODEL_DIR + "Abiltip_Square5x.mdx";
const MODEL_SQUARE6X = MODEL_DIR + "Abiltip_Square6x.mdx";
const MODEL_SECTOR = MODEL_DIR + "AbilTipSX.mdx";
const MODEL_RING = MODEL_DIR + "mr.war3_ring.mdx";
const MODEL_RING_THICK = MODEL_DIR + "Abiltip_ring.mdx";
const MODEL_RING_A = MODEL_DIR + "Tip_ring_A.mdx";
const MODEL_RING_B = MODEL_DIR + "Tip_ring_B.mdx";
const MODEL_RING_C = MODEL_DIR + "Tip_ring_C.mdx";
const 提示圈友方色 = 0xFF40FF40;
const 提示圈敌方色 = 0xFFFF2020;
// ==========================================================================================
// 提示特效销毁
// ==========================================================================================
const 提示特效销毁上下文 = {};
function on提示特效延时销毁到时() {
    const t = GetExpiredTimer();
    if (!t) {
        return;
    }
    const 定时器ID = GetHandleId(t);
    const e = 提示特效销毁上下文[定时器ID];
    delete 提示特效销毁上下文[定时器ID];
    if (e) {
        立即隐藏并销毁提示特效(e);
    }
    safeDestroyTimer(t);
}
function 安全销毁特效(duration, effect) {
    if (!effect)
        return;
    if (duration <= 0) {
        立即隐藏并销毁提示特效(effect);
        return;
    }
    const t = CreateTimer();
    if (!t) {
        立即隐藏并销毁提示特效(effect);
        return;
    }
    提示特效销毁上下文[GetHandleId(t)] = effect;
    safeTimerStart(t, duration, false, on提示特效延时销毁到时);
}
function 设置提示特效顶点颜色(e, color) {
    if (!e)
        return;
    if (typeof DzSetEffectVertexColor === "function") {
        DzSetEffectVertexColor(e, color);
    }
}
export function 按所属单位设置提示圈颜色(e, 来源单位) {
    if (!e || !来源单位)
        return;
    const 所属玩家 = GetOwningPlayer(来源单位);
    if (!所属玩家)
        return;
    const 玩家ID = GetPlayerId(所属玩家);
    if (玩家ID >= 0 && 玩家ID <= 5) {
        设置提示特效顶点颜色(e, 提示圈友方色);
        return;
    }
    设置提示特效顶点颜色(e, 提示圈敌方色);
}
// ==========================================================================================
// 矩形提示圈
// ==========================================================================================
/**
* /严格且仅支持宽长比 1:1, 1:2, 1:3, 1:4, 1:5, 1:6不支持1:7及以上，否则会出现视觉错误（菱形），因为模型是固定的。
* 如宽sw=300, 那么长sl=1800
*
* @param x X坐标
* @param y Y坐标
* @param width 宽度（最大1500）
* @param long 长度（最大7500）
* @param fac 朝向角度
* @param time 持续时间（<=0 表示1秒）
* @param speed 动画速率（可选，默认 1/time）
* 严格且仅支持宽长比 1:1~1:6，否则会出现菱形视觉错误
*/
export function 创建矩形提示圈(x, y, width, long, fac, time, speed) {
    const e = 创建矩形提示圈特效(x, y, width, long, fac, speed);
    if (!e)
        return;
    const duration = time <= 0 ? 1 : time + 0.05;
    安全销毁特效(duration, e);
}
/**
 * 创建一个需要手动销毁的矩形提示圈特效句柄
 */
export function 创建矩形提示圈特效(x, y, width, long, fac, speed) {
    if (width > 1500)
        width = 1500;
    if (long > 7500)
        long = 7500;
    const sw = width / 1000;
    const dis = long / 2;
    x += CosBJ(fac) * dis;
    y += SinBJ(fac) * dis;
    let model;
    let sl;
    const ratio = long / width;
    if (ratio <= 1.0) {
        model = MODEL_SQUARE1X;
        sl = long / 1000;
    }
    else if (ratio <= 2.0) {
        model = MODEL_SQUARE2X;
        sl = long / 2000;
    }
    else if (ratio <= 3.0) {
        model = MODEL_SQUARE3X;
        sl = long / 3000;
    }
    else if (ratio <= 4.0) {
        model = MODEL_SQUARE4X;
        sl = long / 4000;
    }
    else if (ratio <= 5.0) {
        model = MODEL_SQUARE5X;
        sl = long / 5000;
    }
    else {
        model = MODEL_SQUARE6X;
        sl = long / 6000;
    }
    const e = AddSpecialEffect(model, x, y);
    if (!e)
        return;
    const s = speed ?? 1.0;
    EXEffectMatRotateZ(e, fac + 270);
    EXEffectMatScale(e, sl, sw, 1.0);
    EXSetEffectSpeed(e, s);
    return e;
}
// ==========================================================================================
// 扇形提示圈
// ==========================================================================================
/**
 * 白色扇形提示圈
 * `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
 */
export function 创建白色扇形提示圈(x, y, fac, size, time, speed) {
    x += CosBJ(fac) * 10;
    y += SinBJ(fac) * 10;
    const e = AddSpecialEffect(MODEL_SECTOR, x, y);
    if (!e)
        return;
    设置提示特效顶点颜色(e, 0xFFFFFFFF);
    EXEffectMatRotateZ(e, fac);
    EXSetEffectSize(e, size);
    EXSetEffectSpeed(e, speed ?? 1.0);
    const duration = time <= 0 ? 0.5 : time + 0.05;
    安全销毁特效(duration, e);
}
/**
 * 红色扇形提示圈
 * `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
 */
export function 创建红色扇形提示圈(x, y, fac, size, time, speed) {
    x += CosBJ(fac) * 10;
    y += SinBJ(fac) * 10;
    const e = AddSpecialEffect(MODEL_SECTOR, x, y);
    if (!e)
        return;
    设置提示特效顶点颜色(e, 提示圈敌方色);
    EXEffectMatRotateZ(e, fac);
    EXSetEffectSize(e, size);
    EXSetEffectSpeed(e, speed ?? 1.0);
    const duration = time <= 0 ? 0.5 : time + 0.05;
    安全销毁特效(duration, e);
}
/**
 * 创建一个需要手动销毁的红色扇形提示圈特效句柄。
 * `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
 */
export function 创建红色扇形提示圈特效(x, y, fac, size, speed) {
    x += CosBJ(fac) * 10;
    y += SinBJ(fac) * 10;
    const e = AddSpecialEffect(MODEL_SECTOR, x, y);
    if (!e)
        return;
    设置提示特效顶点颜色(e, 提示圈敌方色);
    设置扇形提示圈朝向与尺寸(e, fac, size);
    EXSetEffectSpeed(e, speed ?? 1.0);
    return e;
}
/**
 * 更新扇形提示圈朝向与尺寸。
 * `size = 1.0` 时，对应模型原始扇形尺寸：内侧约 32 半径，外侧约 512 半径。
 */
export function 设置扇形提示圈朝向与尺寸(e, fac, size) {
    EXEffectMatRotateZ(e, fac);
    EXSetEffectSize(e, size);
}
// ==========================================================================================
// 圆形提示圈
// ==========================================================================================
/**
 * 快速创建薄红色圆形提示圈
 * @param x X坐标
 * @param y Y坐标
 * @param r 半径
 * @param time 持续时间（<=0 表示1秒）
 * @param speed 动画速率（可选，默认 1/time）
 */
export function 创建薄圆形提示圈(x, y, r, time, speed) {
    const e = 创建薄圆形提示圈特效(x, y, r, speed);
    if (!e)
        return;
    const duration = time <= 0 ? 0.5 : time + 0.05;
    安全销毁特效(duration, e);
}
/**
 * 创建一个需要手动销毁的薄圆形提示圈特效句柄
 */
export function 创建薄圆形提示圈特效(x, y, r, speed, 来源单位) {
    const e = AddSpecialEffect(MODEL_RING, x, y);
    if (!e)
        return;
    设置提示圈半径(e, r);
    EXSetEffectSpeed(e, speed ?? 1.0);
    按所属单位设置提示圈颜色(e, 来源单位);
    return e;
}
/**
 * 按半径更新提示圈尺寸
 */
export function 设置提示圈半径(e, r) {
    EXSetEffectSize(e, r / 178);
}
/**
 * 安全重播提示圈动画。
 * 优先按动画序号重播；仅当平台提供按名称播放接口且显式传入动画名时才按名称播放。
 */
export function 重播提示圈动画(e, 动画序号, 动画名) {
    if (!e)
        return;
    if (typeof DzSetEffectAnimation === "function") {
        DzSetEffectAnimation(e, 动画序号 ?? 0, 0);
    }
    if (typeof DzPlayEffectAnimation === "function" && 动画名 != null && 动画名 !== "") {
        DzPlayEffectAnimation(e, 动画名, "");
    }
}
/**
 * 立即隐藏并销毁提示特效，避免模型自身尾动画继续可见
 */
export function 立即隐藏并销毁提示特效(e) {
    if (!e)
        return;
    if (typeof DzSetEffectVertexAlpha === "function") {
        DzSetEffectVertexAlpha(e, 0);
    }
    EXSetEffectSize(e, 0.01);
    DestroyEffect(e);
}
/**
 * 兼容旧接口名，内部统一走通用销毁逻辑
 */
export function 立即销毁提示圈特效(e) {
    立即隐藏并销毁提示特效(e);
}
/**
 * 快速创建厚红色圆形提示圈
 * @param x X坐标
 * @param y Y坐标
 * @param r 半径
 * @param time 持续时间（<=0 表示1秒）
 * @param speed 动画速率（可选，默认 1/time）
 */
export function 创建厚圆形提示圈(x, y, r, time, speed) {
    const e = AddSpecialEffect(MODEL_RING_THICK, x, y);
    if (!e)
        return;
    const size = r / 200;
    const s = speed ?? (time <= 0 ? 1 : 1 / time);
    const duration = time <= 0 ? 0.5 : time + 0.05;
    EXSetEffectSize(e, size);
    EXSetEffectSpeed(e, s);
    安全销毁特效(duration, e);
}
/**
 * 快速创建白色圆形提示圈
 * 固定表示安全区域，不参与按所属单位着色。
 */
export function 创建白色圆形提示圈(x, y, r, time, speed) {
    const e = AddSpecialEffect(MODEL_RING_A, x, y);
    if (!e)
        return;
    const size = r / 200;
    const duration = time <= 0 ? 0.5 : time + 0.05;
    DzSetEffectAnimation?.(e, 0, 0);
    EXSetEffectSize(e, size);
    EXSetEffectSpeed(e, speed ?? 1.0);
    安全销毁特效(duration, e);
}
/**
 * 快速创建渐变圆形提示圈（白→红）
 */
export function 创建渐变圆形提示圈(x, y, r, time, speed) {
    const e = AddSpecialEffect(MODEL_RING_B, x, y);
    if (!e)
        return;
    const size = r / 200;
    DzSetEffectAnimation?.(e, 1, 0);
    EXSetEffectSize(e, size);
    EXSetEffectSpeed(e, speed ?? 1.0);
    let duration = time <= 0 ? 0.1 : time + 0.05;
    if (duration < 0.1)
        duration = 0.1;
    安全销毁特效(duration, e);
    return e;
}
/**
 * 快速创建双环圆形提示圈（内圈+外圈）
 * 适用于"内圈无伤害外圈有伤害"或"外圈有伤害内圈无伤害"的模式
 * 内圈:外圈 半径比例 ≈ 1:2
 *
 * @param x X坐标
 * @param y Y坐标
 * @param r 外圈半径（内圈自动按1:2比例缩小）
 * @param time 持续时间（<=0 表示1秒）
 * @param speed 动画速率（可选，默认 1）
 */
export function 创建双环提示圈(x, y, r, time, speed) {
    const e = AddSpecialEffect(MODEL_RING_C, x, y);
    if (!e)
        return;
    const size = r / 200;
    EXSetEffectSize(e, size);
    EXSetEffectSpeed(e, speed ?? 1.0);
    const duration = time <= 0 ? 1 : time + 0.05;
    安全销毁特效(duration, e);
    return e;
}
