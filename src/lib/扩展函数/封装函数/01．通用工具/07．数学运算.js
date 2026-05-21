/** @noSelfInFile */
/**
 * 数学运算工具函数
 * 加法/乘法叠加等通用计算
 */
const jass = require("jass.common");
/**
 * 加法/乘法叠加计算
 * 正数：加法叠加（累加到 addValue）
 * 负数：乘法叠加（累乘到 multiplier）
 *
 * @param value 属性值
 * @param addValue 加法叠加引用对象
 * @param multiplier 乘法叠加引用对象
 */
export function OperatorRealMultiply(value, addValue, multiplier) {
    const 安全值 = value ?? 0;
    if (!addValue || typeof addValue.value !== "number")
        return;
    if (!multiplier || typeof multiplier.value !== "number")
        return;
    if (安全值 >= 0) {
        addValue.value += 安全值;
    }
    else {
        multiplier.value *= (1 + 安全值);
    }
}
/**
 * 抗性减伤计算（乘法叠加）
 *
 * @param resist 抗性值
 * @param multiplier 乘法叠加引用对象
 */
export function OperatorResistReduction(resist, multiplier) {
    const 安全抗性 = resist ?? 0;
    if (!multiplier || typeof multiplier.value !== "number")
        return;
    multiplier.value *= (1 - 安全抗性);
}
/**
 * 创建可变数值容器
 * 用于传递引用
 */
export function createValueHolder(initialValue = 0) {
    return { value: initialValue ?? 0 };
}
/**
 * 四舍五入到最近整数。
 */
export function round(value) {
    const 安全值 = value ?? 0;
    if (安全值 >= 0)
        return jass.R2I(安全值 + 0.5);
    return -jass.R2I(-安全值 + 0.5);
}
/**
 * 向上取整到整数。
 */
export function ceil(value) {
    const 安全值 = value ?? 0;
    const truncated = jass.R2I(安全值);
    if (安全值 > 0 && truncated < 安全值)
        return truncated + 1;
    return truncated;
}
export function clampMin(value, minValue) {
    const 安全最小值 = minValue ?? 0;
    const 安全值 = value ?? 安全最小值;
    return 安全值 < 安全最小值 ? 安全最小值 : 安全值;
}
export function clampRange(value, minValue, maxValue) {
    const 安全最小值 = minValue ?? 0;
    const 安全最大值 = maxValue ?? 安全最小值;
    const 安全值 = value ?? 安全最小值;
    if (安全值 < 安全最小值)
        return 安全最小值;
    if (安全值 > 安全最大值)
        return 安全最大值;
    return 安全值;
}
export function max(a, b) {
    const 安全A = a ?? 0;
    const 安全B = b ?? 0;
    return 安全A >= 安全B ? 安全A : 安全B;
}
export function min(a, b) {
    const 安全A = a ?? 0;
    const 安全B = b ?? 0;
    return 安全A <= 安全B ? 安全A : 安全B;
}
