import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 写入剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 创建并冻结剧情Boss预置 } from "../../00．剧情系统核心工具/03．剧情Boss预置桥接";
import { 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import {
  定位并登记王宫密室剧情单位,
  王宫密室对峙镜头预设,
  王宫密室场景站位表,
  播放王宫密室演出特效,
  播放王宫传送门封印特效,
} from "./33A．王宫密室场景单位";
import { 应用剧情电影镜头 } from "../../00．剧情系统核心工具/12．剧情电影镜头";

const { 注册剧情配置传送 } = require("系统.07．地形系统.03．区域传送") as {
  注册剧情配置传送: (this: void, 配置ID: string, 覆盖: {
    读取玩家英雄组: (this: void) => any;
    允许进入单位?: (this: void, unit: any) => boolean;
    完成?: (this: void, 触发单位?: any) => void;
  }) => (this: void) => void;
};
const { 是玩家英雄组单位, 获取玩家英雄单位组 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
  获取玩家英雄单位组: (this: void) => any;
};
const { 播放主线剧情片段 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
  播放主线剧情片段: (this: void, 片段ID: string, 上下文?: any) => boolean;
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};

export { 第二章王子Boss战过程剧情片段 } from "../02．第二章/32．第二章王子Boss战过程";

const 王宫传承密室传送配置ID = "jlc_elven_palace_secret_room";
const 王宫密室门外对白标记表 = "主线剧情标记";
const 王宫密室门外对白标记键 = "第二章王宫密室门外对白已完成";
let 取消王宫传承密室传送: ((this: void) => void) | undefined;
let 王宫传承密室剧情已触发 = false;

export function 执行第二章王子Boss战前置(this: void): void {
  YDUserDataSetSafe("string", 王宫密室门外对白标记表, 王宫密室门外对白标记键, "integer", 1);
  const 已有里科特 = 读取语义单位引用("Boss.里科特");
  if (已有里科特 != null && 已有里科特 !== 0) return;
  创建并冻结剧情Boss预置({
    Boss键: "Boss.里科特",
    Boss名: "里科特",
    X: 王宫密室场景站位表.里科特密室.X,
    Y: 王宫密室场景站位表.里科特密室.Y,
    朝向: 王宫密室场景站位表.里科特密室.朝向,
    预创建后暂停: true,
    预创建后无敌: true,
  });
}

export function 执行进入传承密室(this: void): void {
  定位并登记王宫密室剧情单位("主线NPC.耶提尔", "主线NPC.耶提尔", 王宫密室场景站位表.耶提尔密室内);
  定位并登记王宫密室剧情单位("主线NPC.里凡特", "主线NPC.里凡特", 王宫密室场景站位表.里凡特密室内);
}

export function 执行里凡特开启传承密室门(this: void): void {
  播放王宫传送门封印特效();
  播放王宫密室演出特效("里凡特开启传承密室门", 王宫密室场景站位表.里凡特密室门外);
}

export function 执行玩家队伍抵达传承密室(this: void): void {
  播放王宫密室演出特效("玩家队伍抵达传承密室", 王宫密室场景站位表.玩家队伍密室对白);
}

function on玩家队伍进入传承密室(this: void, 触发单位?: any): void {
  if (王宫传承密室剧情已触发) return;
  王宫传承密室剧情已触发 = true;
  取消王宫传承密室传送 = undefined;
  写入剧情进度(34);
  执行进入传承密室();
  应用剧情电影镜头(王宫密室对峙镜头预设, 0);
  执行玩家队伍抵达传承密室();
  播放主线剧情片段("elven_city_prince_secret_room_boss_start", {
    片段ID: "elven_city_prince_secret_room_boss_start",
    触发配置名: "王宫传承密室传送入口",
    触发单位,
  });
}

export function 执行注册王宫传承密室传送(this: void): void {
  if (王宫传承密室剧情已触发 || 取消王宫传承密室传送 != null) return;
  取消王宫传承密室传送 = 注册剧情配置传送(王宫传承密室传送配置ID, {
    读取玩家英雄组: 获取玩家英雄单位组,
    允许进入单位: 是玩家英雄组单位,
    完成: on玩家队伍进入传承密室,
  });
}

export const 第二章王子Boss战过程剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_第二章王子Boss战前置": 执行第二章王子Boss战前置,
  "JLC精灵城_里凡特开启传承密室门": 执行里凡特开启传承密室门,
  "JLC精灵城_进入传承密室": 执行进入传承密室,
  "JLC精灵城_玩家队伍抵达传承密室": 执行玩家队伍抵达传承密室,
  "JLC精灵城_注册王宫传承密室传送": 执行注册王宫传承密室传送,
};
