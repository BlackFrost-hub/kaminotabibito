/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const 蛇人族入口暂停来源 = "剧情系统:蛇人族入口";
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 注册剧情片段清理 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表") as {
  注册剧情片段清理: (this: void, 片段ID: string, 清理函数: (this: void) => void) => void;
};
const { 消费世界地图单位缓存, 蛇人入口守卫缓存键表 } = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.09．世界地图单位缓存") as {
  消费世界地图单位缓存: (this: void, 缓存键: string) => any;
  蛇人入口守卫缓存键表: string[];
};
import { 注册剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
export { 蛇人族入口剧情片段 } from "../01．第一章/07．蛇人族入口";

const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const RemoveRect = jass.RemoveRect as (this: void, whichRect: any) => void;

export function 执行蛇人族入口区域清理(this: void, 参数: 剧情动作参数表): void {
  const 矩形名 = String(参数.触发区域 ?? "");
  if (矩形名 === "") return;
  const rectHandle = jglobals[矩形名];
  if (rectHandle != null && rectHandle !== 0) RemoveRect(rectHandle);
}

export function 执行蛇人族领地入口(this: void, 参数: 剧情动作参数表): void {
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  if (触发单位 != null && 触发单位 !== 0) {
    IssueImmediateOrder(触发单位, "stop");
    添加单位暂停(触发单位, 蛇人族入口暂停来源);
  }

  for (let i = 0; i < 蛇人入口守卫缓存键表.length; i++) {
    const 缓存键 = 蛇人入口守卫缓存键表[i];
    const 守卫 = 消费世界地图单位缓存(缓存键);
    if (守卫 == null || 守卫 === 0) continue;
    IssueImmediateOrder(守卫, "stop");
    注册剧情运行时单位(缓存键, 守卫);
  }
}

export function 执行蛇人族领地放行收尾(this: void): void {
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  if (触发单位 != null && 触发单位 !== 0) {
    移除单位暂停(触发单位, 蛇人族入口暂停来源);
  }
}

function 清理蛇人族入口(this: void): void {
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  if (触发单位 != null && 触发单位 !== 0) {
    移除单位暂停(触发单位, 蛇人族入口暂停来源);
  }
}

export const 蛇人族入口剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SRZ蛇人族_入口区域清理": 执行蛇人族入口区域清理,
  "SRZ蛇人族_领地入口": 执行蛇人族领地入口,
  "SRZ蛇人族_领地放行收尾": 执行蛇人族领地放行收尾,
};

注册剧情片段清理("jlc_snake_territory_entry", 清理蛇人族入口);
