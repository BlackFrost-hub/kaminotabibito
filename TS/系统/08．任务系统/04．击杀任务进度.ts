/** @noSelfInFile */

const jass = require("jass.common") as any;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetPlayerController = jass.GetPlayerController as (player: any) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const Player = jass.Player as (playerId: number) => any;
const MAP_CONTROL_USER = jass.MAP_CONTROL_USER;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { fourCCToStringSafe, stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  fourCCToStringSafe: (this: void, fourcc: number) => string;
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, unit: any, itemTypeId: number) => boolean;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, player: any) => any;
};
const { 发送头像提示给玩家 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送头像提示给玩家: (this: void, 目标玩家: any, 头像路径: string, 文本: string, 持续时间?: number) => void;
};
const { 广播提示玩家槽数, 广播提示喇叭头像 } = require("系统.09．表现系统.06．广播提示消息.00．常量定义") as {
  广播提示玩家槽数: number;
  广播提示喇叭头像: string;
};

import { 任务配置, 任务配置列表 } from "./00．配置表/02．任务配置表";
import { questDB, QuestData, QuestStatus } from "./01．任务数据";
import { 触发任务UI刷新 } from "./02．任务管理器";

let 已初始化 = false;

function 是击杀任务配置(this: void, 配置: 任务配置): boolean {
  return (配置.类型 === "击杀" || 配置.类型 === "目标击杀")
    && 配置.目标单位 != null
    && 配置.目标单位 !== "";
}

function 目标单位匹配(this: void, 目标单位列表: string, 死亡单位代码: string): boolean {
  const 单位代码列表 = 目标单位列表.split("|");
  for (let i = 0; i < 单位代码列表.length; i++) {
    if (单位代码列表[i].trim() === 死亡单位代码) return true;
  }
  return false;
}

function 玩家英雄满足击杀携带条件(this: void, 玩家: any, 携带物品列表: string | undefined): boolean {
  if (!携带物品列表 || 携带物品列表 === "") return true;
  const 英雄 = getRegisteredPlayerHero(玩家);
  if (英雄 == null || 英雄 === 0) return false;

  const 物品代码列表 = 携带物品列表.split("|");
  for (let i = 0; i < 物品代码列表.length; i++) {
    const 物品类型ID = stringToFourCCSafe(物品代码列表[i].trim());
    if (物品类型ID !== 0 && UnitHasItemOfTypeBJ(英雄, 物品类型ID)) return true;
  }
  return false;
}

function 查找任务配置(this: void, 任务ID: string): 任务配置 | null {
  for (let i = 0; i < 任务配置列表.length; i++) {
    const 配置 = 任务配置列表[i];
    if (配置.任务ID != null && 配置.任务ID.toString() === 任务ID) return 配置;
  }
  return null;
}

function 奖励面向所有玩家(this: void, 奖励: string | undefined): boolean {
  if (!奖励 || 奖励 === "") return true;
  if (奖励.indexOf("所有玩家") >= 0 || 奖励.indexOf("all") >= 0) return true;
  return 奖励.indexOf("完成任务的玩家") < 0 && 奖励.indexOf("Player") < 0;
}

function 构建击杀进度播报(this: void, 配置: 任务配置, 当前数量: number, 需求数量: number): string {
  const 进度模板 = 配置.进度文本 || `${配置.名称 || "击杀目标"}N/${需求数量}`;
  const 标记位置 = 进度模板.indexOf("N/");
  if (标记位置 >= 0) {
    return "|cffffff00『任务进度』：|r"
      + 进度模板.substring(0, 标记位置)
      + `|cffffcc00${当前数量}|r/`
      + 进度模板.substring(标记位置 + 2);
  }
  return `|cffffff00『任务进度』：|r${进度模板} |cffffcc00${当前数量}/${需求数量}|r`;
}

function 播报击杀任务进度(this: void, 玩家ID: number, 配置: 任务配置, 当前数量: number, 需求数量: number): void {
  if (需求数量 <= 1) return;
  const 文本 = 构建击杀进度播报(配置, 当前数量, 需求数量);
  if (!奖励面向所有玩家(配置.奖励)) {
    发送头像提示给玩家(Player(玩家ID), 广播提示喇叭头像, 文本);
    return;
  }
  for (let 目标玩家ID = 0; 目标玩家ID < 广播提示玩家槽数; 目标玩家ID++) {
    发送头像提示给玩家(Player(目标玩家ID), 广播提示喇叭头像, 文本);
  }
}

function 增加击杀任务进度(this: void, 玩家ID: number, 任务: QuestData, 配置: 任务配置, 死亡单位代码: string): void {
  if (!配置.目标单位 || !目标单位匹配(配置.目标单位, 死亡单位代码)) return;
  let 目标 = 任务.objectives[0];
  if (配置.目标单位分别击杀 === true) {
    目标 = null as any;
    const 目标ID = "kill_" + 死亡单位代码;
    for (let i = 0; i < 任务.objectives.length; i++) {
      if (任务.objectives[i] != null && 任务.objectives[i].id === 目标ID) {
        目标 = 任务.objectives[i];
        break;
      }
    }
  }
  if (!目标 || 目标.current >= 目标.required) return;
  const 新进度 = 目标.current + 1;
  if (questDB.updateObjective(玩家ID, 任务.id, 目标.id, 新进度)) {
    触发任务UI刷新(玩家ID, 任务.id);
    let 总进度 = 0;
    let 总需求 = 0;
    for (let i = 0; i < 任务.objectives.length; i++) {
      const 当前目标 = 任务.objectives[i];
      if (!当前目标) continue;
      总进度 += 当前目标.id === 目标.id ? 新进度 : 当前目标.current;
      总需求 += 当前目标.required;
    }
    播报击杀任务进度(玩家ID, 配置, 总进度, 总需求);
  }
}

function on任务目标单位死亡(this: void, 死亡单位: any, 击杀单位: any): void {
  if (!死亡单位 || !击杀单位) return;
  const 击杀玩家 = GetOwningPlayer(击杀单位);
  if (!击杀玩家 || GetPlayerController(击杀玩家) !== MAP_CONTROL_USER) return;
  const 玩家ID = GetPlayerId(击杀玩家);
  const 死亡单位代码 = fourCCToStringSafe(GetUnitTypeId(死亡单位));
  const 进行中任务 = questDB.getPlayerActiveQuests(玩家ID);
  for (let i = 0; i < 进行中任务.length; i++) {
    const 任务 = 进行中任务[i];
    if (!任务 || 任务.status !== QuestStatus.IN_PROGRESS) continue;
    const 配置 = 查找任务配置(任务.id);
    if (!配置 || !是击杀任务配置(配置)) continue;
    if (!玩家英雄满足击杀携带条件(击杀玩家, 配置.击杀携带物品)) continue;
    增加击杀任务进度(玩家ID, 任务, 配置, 死亡单位代码);
  }
}

export function 初始化击杀任务进度(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  registerDeathListener(on任务目标单位死亡);
}

export {};
