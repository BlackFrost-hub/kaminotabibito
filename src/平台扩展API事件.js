/** @noSelfInFile */
const 平台原生表 = require("jass.japi");
const 原生函数表 = 平台原生表;
export function 平台扩展_注册_随机存档删除事件(触发器) {
    return 原生函数表["KKApiTriggerRegisterBackendLogicDelete"](触发器);
}
export function 平台扩展_注册_随机存档更新事件(触发器) {
    return 原生函数表["KKApiTriggerRegisterBackendLogicUpdata"](触发器);
}
export function 平台扩展_注册_天梯投降事件(触发器) {
    return 原生函数表["KKApiTriggerRegisterLadderSurrender"](触发器);
}
