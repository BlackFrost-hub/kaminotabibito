/** @noSelfInFile */
const jass = require("jass.common");
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统");
const { startHot } = require("系统.04．伤害系统.02．治疗系统.04．持续治疗效果");
const GetUnitName = jass.GetUnitName;
function 持续恢复结束条件恒真(_目标单位) {
    return true;
}
export function 施加持续恢复生命魔法(来源单位, 目标单位, 参数) {
    if (来源单位 == null || 来源单位 === 0)
        return;
    if (目标单位 == null || 目标单位 === 0)
        return;
    registerManualBuff(目标单位, 参数.BuffID, 参数.持续时间, 参数.每跳生命恢复, {
        effectValue2: 参数.每跳魔法恢复,
        sourceName: GetUnitName(来源单位),
        iconOverride: 参数.图标路径,
        effectModelOverride: 参数.特效路径,
    });
    startHot(目标单位, 来源单位, 参数.每跳生命恢复, 参数.每跳魔法恢复, 参数.持续时间, 参数.间隔, {
        BuffID: 参数.BuffID,
        结束条件检测: 持续恢复结束条件恒真,
        特效: {
            特效路径: 参数.特效路径,
            特效挂点: 参数.特效挂点,
            是否绑定单位: true,
            特效键: 参数.特效键,
        },
    });
}
