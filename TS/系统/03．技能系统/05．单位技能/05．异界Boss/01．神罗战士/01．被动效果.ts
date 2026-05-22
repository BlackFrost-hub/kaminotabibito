/** @noSelfInFile */

const { 转四位ID } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  转四位ID: (this: void, rawIdText: string) => number;
};
const { 注册目标带原生Buff时必定暴击 } = require("系统.03．技能系统.05．单位技能.00．公共.05．原生Buff必定暴击修正") as {
  注册目标带原生Buff时必定暴击: (this: void, unitTypeId: number, buffId: number) => void;
};
const { 神罗战士单位技能配置 } = require("系统.03．技能系统.05．单位技能.05．异界Boss.01．神罗战士.00．配置") as {
  神罗战士单位技能配置: {
    单位ID: string;
    眩晕BuffID: string;
  };
};

const 神罗战士单位类型ID = 转四位ID(神罗战士单位技能配置.单位ID);
const 神罗战士眩晕BuffID = 转四位ID(神罗战士单位技能配置.眩晕BuffID);

export function 注册神罗战士被动效果(this: void): void {
  注册目标带原生Buff时必定暴击(神罗战士单位类型ID, 神罗战士眩晕BuffID);
}

注册神罗战士被动效果();
