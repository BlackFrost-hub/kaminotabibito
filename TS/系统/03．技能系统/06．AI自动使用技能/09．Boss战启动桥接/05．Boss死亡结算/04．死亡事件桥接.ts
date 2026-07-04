/** @noSelfInFile */

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 获取Boss死亡结算配置, 执行Boss死亡结算 } = require("./03．核心逻辑") as {
  获取Boss死亡结算配置: (this: void, Boss单位: any) => any;
  执行Boss死亡结算: (this: void, 配置: any, Boss单位?: any, 击杀者?: any) => boolean;
};

const 测试Boss跳过死亡结算字段 = "测试Boss跳过死亡结算";
const 初始注册Boss跳过死亡结算字段 = "初始注册Boss跳过死亡结算";

let 已初始化Boss死亡结算桥接 = false;

function onBoss死亡结算事件(this: void, dyingUnit: any, killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  if (YDUserDataGetSafe("unit", dyingUnit, 测试Boss跳过死亡结算字段, "boolean") === true) return;
  if (YDUserDataGetSafe("unit", dyingUnit, 初始注册Boss跳过死亡结算字段, "boolean") === true) return;
  const 配置 = 获取Boss死亡结算配置(dyingUnit);
  if (配置 == null) return;
  if (配置.保留原剧情执行 === true) return;
  执行Boss死亡结算(配置, dyingUnit, killingUnit);
}

export function 初始化Boss死亡结算死亡事件桥接(this: void): void {
  if (已初始化Boss死亡结算桥接) return;
  已初始化Boss死亡结算桥接 = true;
  registerDeathListener(onBoss死亡结算事件);
}

初始化Boss死亡结算死亡事件桥接();

