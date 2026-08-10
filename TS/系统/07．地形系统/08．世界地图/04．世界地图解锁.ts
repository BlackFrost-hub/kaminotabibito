/** @noSelfInFile */

const jass = require("jass.common") as any;
const 统一矩形区域读取 = require("系统.07．地形系统.09．动态矩形区域注册表.04．统一矩形区域读取") as {
  获取矩形区域: (this: void, 名称: string) => any;
};

const 区域事件中心 = require("系统.00．核心系统.01．事件中心.02．区域事件中心") as {
  registerEnterRegionTrigger: (this: void, trigger: any, region: any, filter?: any) => (this: void) => void;
};
const 英雄桥接 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const YD安全版 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (
    this: void,
    tableType: string,
    tableKey: any,
    attr: string,
    valueType: string,
    value: any,
  ) => void;
};
const FourCC安全版 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, raw: string | undefined | null) => number;
};
const 剧情进度系统 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文") as {
  读取剧情进度: (this: void) => number;
  注册剧情进度变更监听: (
    this: void,
    监听器: (this: void, 新进度: number, 旧进度: number) => void,
  ) => void;
};
const 剧情视野工具 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具") as {
  给玩家组添加多个区域视野: (this: void, 矩形区域名称列表: string) => void;
};

import { 世界地图旅行奖励配置表, 世界地图解锁配置表 } from "./01．世界地图地点配置";
import { 更新世界地图地点显示 } from "./02．世界地图界面";
import { 注册世界地图地点传送 } from "./05．世界地图传送";

interface 世界地图区域运行配置 {
  矩形区域名称: string;
  解锁配置索引?: number;
  旅行奖励配置索引?: number;
}

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const TriggerAddAction = jass.TriggerAddAction as (
  this: void,
  trigger: any,
  callback: (this: void) => void,
) => any;
const CreateRegion = jass.CreateRegion as (this: void) => any;
const RegionAddRect = jass.RegionAddRect as (this: void, region: any, rect: any) => void;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetTriggeringRegion = jass.GetTriggeringRegion as (this: void) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const UnitAddItemById = jass.UnitAddItemById as (this: void, unit: any, itemId: number) => any;
const 获取矩形区域 = 统一矩形区域读取.获取矩形区域;

const 世界地图区域配置By矩形区域名称: Record<string, 世界地图区域运行配置 | undefined> = {};
const 世界地图区域配置By句柄ID: Record<number, 世界地图区域运行配置 | undefined> = {};
const 世界地图区域运行配置表: 世界地图区域运行配置[] = [];
const 已解锁地点表: Record<number, boolean | undefined> = {};

let 世界地图解锁已初始化 = false;

function 取或创建区域配置(this: void, 矩形区域名称: string): 世界地图区域运行配置 {
  let 配置 = 世界地图区域配置By矩形区域名称[矩形区域名称];
  if (配置 == null) {
    配置 = { 矩形区域名称 };
    世界地图区域配置By矩形区域名称[矩形区域名称] = 配置;
    世界地图区域运行配置表.push(配置);
  }
  return 配置;
}

function 构建区域运行配置(this: void): void {
  for (let 索引 = 0; 索引 < 世界地图解锁配置表.length; 索引++) {
    const 解锁配置 = 世界地图解锁配置表[索引];
    if (
      (解锁配置.解锁来源 != null && 解锁配置.解锁来源 !== "区域探索") ||
      解锁配置.矩形区域名称 == null
    ) continue;
    取或创建区域配置(解锁配置.矩形区域名称).解锁配置索引 = 索引;
  }
  for (let 索引 = 0; 索引 < 世界地图旅行奖励配置表.length; 索引++) {
    const 奖励配置 = 世界地图旅行奖励配置表[索引];
    取或创建区域配置(奖励配置.矩形区域名称).旅行奖励配置索引 = 索引;
  }
}

function 处理旅行奖励(this: void, unit: any, 配置索引: number | undefined): void {
  if (配置索引 == null) return;
  if (GetUnitTypeId(unit) !== FourCC安全版.stringToFourCCSafe("H014")) return;
  const 配置 = 世界地图旅行奖励配置表[配置索引];
  if (配置 == null) return;
  const 字段 = "旅行" + tostring(配置.旅行编号);
  if (YD安全版.YDUserDataGetSafe("unit", unit, 字段, "boolean") === true) return;
  YD安全版.YDUserDataSetSafe("unit", unit, 字段, "boolean", true);
  UnitAddItemById(unit, FourCC安全版.stringToFourCCSafe("I0DN"));
}

function 应用地点解锁(this: void, 配置索引: number): void {
  const 配置 = 世界地图解锁配置表[配置索引];
  if (配置 == null || 已解锁地点表[配置.地点ID] === true) return;
  已解锁地点表[配置.地点ID] = true;
  更新世界地图地点显示(配置.地点ID, 配置.解锁提示, 配置.解锁图标);
  if (配置.解锁后注册传送 === true) 注册世界地图地点传送(配置.地点ID);
  if (配置.进入后开启视野 != null && 配置.进入后开启视野 !== "") {
    剧情视野工具.给玩家组添加多个区域视野(配置.进入后开启视野);
  }
}

function 处理区域地点解锁(this: void, 配置索引: number | undefined): void {
  if (配置索引 == null) return;
  应用地点解锁(配置索引);
}

function on剧情进度变更解锁世界地图(this: void, 新进度: number, 旧进度: number): void {
  if (新进度 <= 旧进度) return;
  for (let 索引 = 0; 索引 < 世界地图解锁配置表.length; 索引++) {
    const 配置 = 世界地图解锁配置表[索引];
    if (配置.解锁来源 !== "主线剧情" || 配置.目标剧情进度 == null) continue;
    if (配置.目标剧情进度 > 旧进度 && 配置.目标剧情进度 <= 新进度) 应用地点解锁(索引);
  }
}

function 恢复当前剧情进度地图解锁(this: void): void {
  const 当前剧情进度 = 剧情进度系统.读取剧情进度();
  for (let 索引 = 0; 索引 < 世界地图解锁配置表.length; 索引++) {
    const 配置 = 世界地图解锁配置表[索引];
    if (配置.解锁来源 !== "主线剧情" || 配置.目标剧情进度 == null) continue;
    if (配置.目标剧情进度 <= 当前剧情进度) 应用地点解锁(索引);
  }
}

function on世界地图区域进入(this: void): void {
  const unit = GetTriggerUnit();
  if (unit == null || unit === 0 || !英雄桥接.是玩家英雄组单位(unit)) return;
  const region = GetTriggeringRegion();
  if (region == null || region === 0) return;
  const 运行配置 = 世界地图区域配置By句柄ID[GetHandleId(region)];
  if (运行配置 == null) return;

  处理旅行奖励(unit, 运行配置.旅行奖励配置索引);
  处理区域地点解锁(运行配置.解锁配置索引);
}

function 注册区域(this: void, 业务触发器: any, 运行配置: 世界地图区域运行配置): void {
  const rect = 获取矩形区域(运行配置.矩形区域名称);
  if (rect == null || rect === 0) return;
  const region = CreateRegion();
  if (region == null || region === 0) return;
  RegionAddRect(region, rect);
  世界地图区域配置By句柄ID[GetHandleId(region)] = 运行配置;
  区域事件中心.registerEnterRegionTrigger(业务触发器, region, null);
}

export function 初始化世界地图解锁(this: void): void {
  if (世界地图解锁已初始化) return;
  世界地图解锁已初始化 = true;
  构建区域运行配置();
  剧情进度系统.注册剧情进度变更监听(on剧情进度变更解锁世界地图);
  恢复当前剧情进度地图解锁();

  const 业务触发器 = CreateTrigger();
  if (业务触发器 == null || 业务触发器 === 0) return;
  TriggerAddAction(业务触发器, on世界地图区域进入);
  for (let 索引 = 0; 索引 < 世界地图区域运行配置表.length; 索引++) {
    const 运行配置 = 世界地图区域运行配置表[索引];
    if (运行配置 != null) 注册区域(业务触发器, 运行配置);
  }
}
