/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { 启动Boss战运行 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动") as {
  启动Boss战运行: (this: void, bossUnit: any) => void;
};
const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用") as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { 记录Boss自动技能启动, 是否已登记Boss自动技能 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  记录Boss自动技能启动: (this: void, unit: any, source: "Boss战.绑定单位") => any;
  是否已登记Boss自动技能: (this: void, unit: any) => boolean;
};

import { 读取当前剧情动作上下文 } from "./01．剧情动作上下文";
import { 释放并登记剧情Boss预置随从, 剧情Boss预置暂停来源 } from "./03．剧情Boss预置桥接";

const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;

export interface 剧情Boss战启动参数 {
  触发单位?: any;
  暂停来源?: string;
}

export function 启动剧情Boss战(this: void, bossUnit: any, 参数?: 剧情Boss战启动参数): boolean {
  if (bossUnit == null || bossUnit === 0) return false;

  释放并登记剧情Boss预置随从(bossUnit);

  if (!是否已登记Boss自动技能(bossUnit)) {
    记录Boss自动技能启动(bossUnit, "Boss战.绑定单位");
  }
  应用Boss战启动属性配置(bossUnit);
  YDUserDataSetSafe("string", "Boss战", "绑定单位", "unit", bossUnit);

  const 触发单位 = 参数?.触发单位 ?? 读取当前剧情动作上下文().触发单位;
  if (触发单位 != null && 触发单位 !== 0) {
    YDUserDataSetSafe("string", "Boss战", "触发玩家", "unit", 触发单位);
  }

  移除单位暂停(bossUnit, 参数?.暂停来源 ?? 剧情Boss预置暂停来源);
  SetUnitInvulnerable(bossUnit, false);
  启动Boss战运行(bossUnit);
  return true;
}
