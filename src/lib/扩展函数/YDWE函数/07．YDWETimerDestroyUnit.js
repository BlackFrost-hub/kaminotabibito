/** @noSelfInFile */
/**
 * 延时删除单位
 *
 * 使用中心计时器，延迟删除指定单位
 */
const jass = require("jass.common");
const { onTick10ms } = require("系统.00．核心系统.05．中心计时器");
const RemoveUnit = jass.RemoveUnit;
const _pendingUnits = [];
let _unitRecycleRegistered = false;
const _tickUnitRecycle = () => {
    for (let i = _pendingUnits.length - 1; i >= 0; i--) {
        const entry = _pendingUnits[i];
        entry.ticksLeft = entry.ticksLeft - 1;
        if (entry.ticksLeft <= 0) {
            if (entry.unit != null) {
                RemoveUnit(entry.unit);
            }
            _pendingUnits.splice(i, 1);
        }
    }
};
/**
 * 延时删除单位（使用中心计时器）
 * @param duration 延迟秒数
 * @param unit 单位句柄
 */
export function YDWETimerDestroyUnit(duration, unit) {
    if (!unit)
        return;
    if (duration <= 0) {
        RemoveUnit(unit);
        return;
    }
    if (!_unitRecycleRegistered) {
        _unitRecycleRegistered = true;
        onTick10ms(_tickUnitRecycle);
    }
    const ticks = Math.ceil(duration / 0.01);
    _pendingUnits.push({ unit, ticksLeft: ticks });
}
