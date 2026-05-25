/** @noSelfInFile */

const jass = require("jass.common") as any;

const { SetUnitFacingToFaceUnitTimed } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  SetUnitFacingToFaceUnitTimed: (this: void, whichUnit: any, target: any, duration: number) => void;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09－YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "./00．剧情动作类型";
import { 读取当前剧情动作上下文, 写入剧情进度 } from "./01．剧情动作上下文";
import {
  发送剧情任务消息,
  发送剧情小地图信号,
  在触发单位脚下创建剧情物品,
} from "./02．剧情动作桥接";
import { 创建并冻结剧情Boss预置 } from "./03．剧情Boss预置桥接";

const CreateFogModifierRect = jass.CreateFogModifierRect as (this: void, whichPlayer: any, whichState: any, where: any, useSharedVision: boolean, afterUnits: boolean) => any;
const CreateItem = jass.CreateItem as (this: void, itemId: number, x: number, y: number) => any;
const FogModifierStart = jass.FogModifierStart as (this: void, whichFog: any) => void;
const GetPlayersAll = jass.GetPlayersAll as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitFacingTimed = jass.SetUnitFacingTimed as (this: void, whichUnit: any, facing: number, duration: number) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;

const FOG_OF_WAR_VISIBLE = jass.FOG_OF_WAR_VISIBLE as number;
const bj_QUESTMESSAGE_ITEMACQUIRED = (require("jass.globals") as any).bj_QUESTMESSAGE_ITEMACQUIRED as number;
const bj_QUESTMESSAGE_UPDATED = (require("jass.globals") as any).bj_QUESTMESSAGE_UPDATED as number;

function 读取长老单位(this: void): any {
  return YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit");
}

function 分割名称列表(this: void, value: string | undefined): string[] {
  if (value == null || value === "") return [];
  return value.split(",").map((item) => item.trim()).filter((item) => item.length > 0);
}

function 对所有玩家添加区域视野(this: void, rectVarName: string): void {
  const rectHandle = (require("jass.globals") as any)[rectVarName];
  if (rectHandle == null || rectHandle === 0) return;
  for (let playerId = 0; playerId < 8; playerId++) {
    const fogModifier = CreateFogModifierRect(Player(playerId), FOG_OF_WAR_VISIBLE, rectHandle, true, false);
    if (fogModifier == null || fogModifier === 0) continue;
    FogModifierStart(fogModifier);
  }
}

function 执行长老任务物品生成(this: void, 参数: 剧情动作参数表): void {
  const 长老单位 = 读取长老单位();
  if (长老单位 == null || 长老单位 === 0) return;

  const 物品名列表 = 分割名称列表(String(参数.物品名列表 ?? ""));
  const x = GetUnitX(长老单位);
  const y = GetUnitY(长老单位);
  for (let i = 0; i < 物品名列表.length; i++) {
    const rawId = 按名字反查物品ID(物品名列表[i]);
    const itemTypeId = stringToFourCCSafe(rawId);
    if (!(itemTypeId > 0)) continue;
    CreateItem(itemTypeId, x, y);
  }
}

function 执行长老任务更新(this: void, 参数: 剧情动作参数表): void {
  发送剧情小地图信号({
    X: Number(参数.小地图X) || 0,
    Y: Number(参数.小地图Y) || 0,
    持续时间: Number(参数.小地图持续时间) || 0,
  });
  发送剧情任务消息({
    消息类型: bj_QUESTMESSAGE_UPDATED,
    文本: String(参数.任务更新提示 ?? ""),
  });
}

function 执行地精区域显视野(this: void, 参数: 剧情动作参数表): void {
  对所有玩家添加区域视野(String(参数.可见区域1 ?? ""));
  对所有玩家添加区域视野(String(参数.可见区域2 ?? ""));
}

function 执行地精祭祀Boss预备(this: void, 参数: 剧情动作参数表): void {
  创建并冻结剧情Boss预置({
    Boss键: String(参数.Boss键 ?? ""),
    Boss名: String(参数.Boss名 ?? ""),
    X: Number(参数.X) || 0,
    Y: Number(参数.Y) || 0,
    朝向: Number(参数.朝向) || 0,
    注册范围: Number(参数.注册范围) || 0,
    预创建后暂停: 参数.预创建后暂停 === true,
    预创建后无敌: 参数.预创建后无敌 === true,
    范围触发配置名: String(参数.范围触发配置名 ?? "地精祭祀范围预置触发"),
    范围触发剧情片段ID: typeof 参数.范围触发剧情片段ID === "string" ? 参数.范围触发剧情片段ID : undefined,
  });
}

function 执行长老对话前置(this: void, 参数: 剧情动作参数表): void {
  const 上下文 = 读取当前剧情动作上下文();
  const 触发单位 = 上下文.触发单位;
  const 长老单位 = 读取长老单位();

  if (typeof 参数.设置剧情进度 === "number") {
    写入剧情进度(参数.设置剧情进度);
  }

  if (触发单位 != null && 触发单位 !== 0 && 参数.触发单位发布命令 != null) {
    IssueImmediateOrder(触发单位, String(参数.触发单位发布命令));
  }
  if (触发单位 != null && 触发单位 !== 0 && 长老单位 != null && 长老单位 !== 0) {
    SetUnitFacingToFaceUnitTimed(触发单位, 长老单位, Number(参数.触发单位转向耗时) || 0);
  }

  if (长老单位 != null && 长老单位 !== 0) {
    if (typeof 参数.长老归属玩家 === "number") {
      SetUnitOwner(长老单位, Player(参数.长老归属玩家), true);
    }
    if (触发单位 != null && 触发单位 !== 0) {
      const angle = jass.YDWEAngleBetweenUnits(长老单位, 触发单位) as number;
      SetUnitFacingTimed(长老单位, angle, Number(参数.长老转向耗时) || 0);
    }
  }
}

function 执行远古波动奖励(this: void, 参数: 剧情动作参数表): void {
  const 上下文 = 读取当前剧情动作上下文();
  if (上下文.触发单位 == null || 上下文.触发单位 === 0) return;
  发送剧情任务消息({
    消息类型: bj_QUESTMESSAGE_ITEMACQUIRED,
    文本: String(参数.任务消息模板 ?? ""),
  });
}

const 主线剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵村_长老对话前置": 执行长老对话前置,
  "JLC精灵村_长老任务物品生成": 执行长老任务物品生成,
  "JLC精灵村_发布地精任务": 执行长老任务更新,
  "JLC精灵村_地精区域显视野": 执行地精区域显视野,
  "JLC精灵村_创建地精祭祀Boss预备": 执行地精祭祀Boss预备,
  "JLC精灵村_远古波动奖励": 执行远古波动奖励,
};

export function 查找主线剧情动作处理器(this: void, 动作ID: string): 剧情动作处理器 | undefined {
  return 主线剧情动作注册表[动作ID];
}

export function 执行主线剧情动作(this: void, 动作ID: string, 参数: 剧情动作参数表): void {
  const handler = 查找主线剧情动作处理器(动作ID);
  if (handler == null) return;
  handler(参数);
}
