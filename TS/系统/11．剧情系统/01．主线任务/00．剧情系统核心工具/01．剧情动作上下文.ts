/** @noSelfInFile */

const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};

import type { 剧情动作执行上下文 } from "./00．剧情动作类型";

const 剧情入口表名 = "主线剧情入口";
const 剧情进度表名 = "剧情进度";
const 剧情进度键 = "整数";

export function 读取当前剧情动作上下文(this: void): 剧情动作执行上下文 {
  return {
    片段ID: YDUserDataGetSafe("string", 剧情入口表名, "剧情片段ID", "string"),
    触发配置名: YDUserDataGetSafe("string", 剧情入口表名, "触发配置", "string"),
    触发单位: YDUserDataGetSafe("string", 剧情入口表名, "触发单位", "unit"),
  };
}

export function 写入当前剧情动作上下文(this: void, 上下文: 剧情动作执行上下文): void {
  if (上下文.片段ID != null) {
    YDUserDataSetSafe("string", 剧情入口表名, "剧情片段ID", "string", 上下文.片段ID);
  }
  if (上下文.触发配置名 != null) {
    YDUserDataSetSafe("string", 剧情入口表名, "触发配置", "string", 上下文.触发配置名);
  }
  if (上下文.触发单位 != null) {
    YDUserDataSetSafe("string", 剧情入口表名, "触发单位", "unit", 上下文.触发单位);
  }
}

export function 读取剧情进度(this: void): number {
  return Number(YDUserDataGetSafe("string", 剧情进度表名, 剧情进度键, "integer")) || 0;
}

export function 写入剧情进度(this: void, 进度: number): void {
  YDUserDataSetSafe("string", 剧情进度表名, 剧情进度键, "integer", 进度);
}
