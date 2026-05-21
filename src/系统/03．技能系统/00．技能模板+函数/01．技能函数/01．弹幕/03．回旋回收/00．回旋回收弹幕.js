/** @noSelfInFile */
/**
 * 回旋 / 回收型弹幕模板
 *
 * 去程与回程分别创建原生弹幕，因此可以配置不同伤害和命中上限。
 */
import { 创建二阶贝塞尔轨迹, 创建原生弹幕 } from "../01．TS原生弹幕/index";
const jass = require("jass.common");
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitFacing = jass.GetUnitFacing;
const SquareRoot = jass.SquareRoot;
const Atan2 = jass.Atan2;
const bj_RADTODEG = jass.bj_RADTODEG;
const CosBJ = require("lib.扩展函数.BJ函数.12．数学函数").CosBJ;
const SinBJ = require("lib.扩展函数.BJ函数.12．数学函数").SinBJ;
function 计算距离(x1, y1, x2, y2) {
    const dx = x2 - x1;
    const dy = y2 - y1;
    return SquareRoot(dx * dx + dy * dy);
}
function 计算持续时间(距离, 速度) {
    if (速度 <= 0)
        return 0.01;
    const t = 距离 / 速度;
    return t > 0.01 ? t : 0.01;
}
function 创建回程锁定施法者轨迹(施法者, 到达半径) {
    return function 回程锁定施法者轨迹(实例, delta) {
        const targetX = GetUnitX(施法者);
        const targetY = GetUnitY(施法者);
        const dx = targetX - 实例.当前X;
        const dy = targetY - 实例.当前Y;
        const 距离 = SquareRoot(dx * dx + dy * dy);
        const 方向角 = Atan2(dy, dx) * bj_RADTODEG;
        const 步长 = 实例.当前速度 * delta;
        if (距离 <= 到达半径 || 距离 <= 步长 || 距离 <= 0.01) {
            return { X: targetX, Y: targetY, 方向角, 完成: true };
        }
        const 比例 = 步长 / 距离;
        return {
            X: 实例.当前X + dx * 比例,
            Y: 实例.当前Y + dy * 比例,
            方向角,
            完成: false,
        };
    };
}
export function 创建回旋回收弹幕(参数) {
    const 施法者 = 参数.施法者;
    if (施法者 == null || 施法者 === 0)
        return;
    const startX = GetUnitX(施法者);
    const startY = GetUnitY(施法者);
    const face = GetUnitFacing(施法者);
    const endX = startX + CosBJ(face) * 参数.距离;
    const endY = startY + SinBJ(face) * 参数.距离;
    const 偏移 = 参数.曲线偏移 ?? 180;
    const ctrlX = startX + CosBJ(face + 90) * 偏移 + CosBJ(face) * 参数.距离 * 0.5;
    const ctrlY = startY + SinBJ(face + 90) * 偏移 + SinBJ(face) * 参数.距离 * 0.5;
    const 去程距离 = 计算距离(startX, startY, endX, endY);
    创建原生弹幕({
        所有者: 施法者,
        X: startX,
        Y: startY,
        方向角: face,
        弹幕单位类型: 参数.弹幕单位类型,
        模型: 参数.模型,
        附着特效模型: 参数.附着特效模型,
        速度: 参数.速度,
        生命周期: 计算持续时间(去程距离, 参数.速度),
        最大距离: 去程距离,
        轨迹采样器: 创建二阶贝塞尔轨迹(startX, startY, ctrlX, ctrlY, endX, endY),
        命中半径: 参数.命中半径 ?? 96,
        伤害值: 参数.去程伤害 ?? 0,
        每单位最大命中次数: 参数.去程每单位最大命中次数 ?? 1,
        on结束: function 回旋去程结束() {
            const returnStartX = endX;
            const returnStartY = endY;
            const ownerX = GetUnitX(施法者);
            const ownerY = GetUnitY(施法者);
            const 回程距离 = 计算距离(returnStartX, returnStartY, ownerX, ownerY);
            const returnCtrlX = (returnStartX + ownerX) * 0.5 - CosBJ(face + 90) * 偏移;
            const returnCtrlY = (returnStartY + ownerY) * 0.5 - SinBJ(face + 90) * 偏移;
            const 回程锁定施法者 = 参数.回程锁定施法者 === true;
            创建原生弹幕({
                所有者: 施法者,
                X: returnStartX,
                Y: returnStartY,
                方向角: face + 180,
                弹幕单位类型: 参数.弹幕单位类型,
                模型: 参数.模型,
                附着特效模型: 参数.附着特效模型,
                速度: 参数.速度,
                生命周期: 回程锁定施法者 ? 5 : 计算持续时间(回程距离, 参数.速度),
                最大距离: 回程锁定施法者 ? 参数.距离 * 3 : 回程距离,
                轨迹采样器: 回程锁定施法者
                    ? 创建回程锁定施法者轨迹(施法者, 参数.命中半径 ?? 96)
                    : 创建二阶贝塞尔轨迹(returnStartX, returnStartY, returnCtrlX, returnCtrlY, ownerX, ownerY),
                命中半径: 参数.命中半径 ?? 96,
                伤害值: 参数.回程伤害 ?? 参数.去程伤害 ?? 0,
                每单位最大命中次数: 参数.回程每单位最大命中次数 ?? 1,
                on结束: function 回旋回程结束() {
                    if (参数.on结束 != null)
                        参数.on结束();
                },
            });
        },
    });
}
