import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 写入剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 创建并冻结剧情Boss预置, 剧情Boss预置暂停来源 } from "../../00．剧情系统核心工具/03．剧情Boss预置桥接";
import { 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 注册剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
import {
  定位并登记王宫密室剧情单位,
  王宫密室对峙镜头预设,
  王宫密室场景站位表,
  播放王宫密室演出特效,
  播放王宫传送门封印特效,
  读取或创建并定位王宫密室剧情单位,
} from "./33A．王宫密室场景单位";
import {
  应用剧情电影镜头,
  进入剧情电影模式,
  type 剧情镜头预设参数,
} from "../../00．剧情系统核心工具/12．剧情电影镜头";
export { 章节末战后承接剧情片段 } from "../02．第二章/33．第二章王子Boss战后承接";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { 注册主线剧情运行时单位范围入口 } = require("系统.11．剧情系统.01．主线任务.01．主线剧情入口.02．主线剧情入口初始化") as {
  注册主线剧情运行时单位范围入口: (this: void, unit: any, 配置: {
    配置名: string;
    剧情片段ID: string;
    注册范围: number;
    需要剧情进度: number;
    触发后注销?: boolean;
    运行时条件?: (this: void) => boolean;
  }) => (this: void) => void;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 打开Boss死亡首领奖励UI } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑") as {
  打开Boss死亡首领奖励UI: (this: void, 奖励池ID: string | undefined) => void;
};
const { 菲利斯奖励池ID } = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表.14．主线_菲利斯战利品") as {
  菲利斯奖励池ID: string;
};

const { 播放原生任务音效 } = require("lib.扩展函数.封装函数.02．音效系统.07．原生任务音效") as {
  播放原生任务音效: (this: void, 类型: "警告") => void;
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 消费世界地图单位缓存, 王宫禁卫缓存键表 } = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.09．世界地图单位缓存") as {
  消费世界地图单位缓存: (this: void, 缓存键: string) => any;
  王宫禁卫缓存键表: string[];
};

const GetDestructableX = jass.GetDestructableX as (this: void, destructable: any) => number;
const GetDestructableY = jass.GetDestructableY as (this: void, destructable: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const IssuePointOrder = jass.IssuePointOrder as (this: void, whichUnit: any, order: string, x: number, y: number) => boolean;
const Player = jass.Player as (this: void, playerId: number) => any;
const ShowDestructable = jass.ShowDestructable as (this: void, destructable: any, flag: boolean) => void;
const ShowUnit = jass.ShowUnit as (this: void, unit: any, flag: boolean) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, whichUnit: any, animation: string) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, whichUnit: any, animationIndex: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facingAngle: number) => void;
const KillUnit = jass.KillUnit as (this: void, whichUnit: any) => void;

const 里科特登场特效 = "war3mapImported\\BlueRitualTarget.mdx";
const 王宫潜入镜头预设: 剧情镜头预设参数 = {
  X: 15925.86,
  Y: -24806.4,
  高度偏移: 0,
  旋转角度: 100,
  攻角: 324,
  距离到目标: 2500,
  滚动角度: 0,
  观察区域: 70,
  远景剪裁: 5000,
};
const 王宫门口近景镜头预设: 剧情镜头预设参数 = {
  X: 15864.2,
  Y: -24381.7,
  高度偏移: 200,
  旋转角度: 40,
  攻角: 344,
  距离到目标: 1000.61,
  滚动角度: 0,
  观察区域: 70,
  远景剪裁: 5000,
};
const 第二章战后对白玩家引用 = "剧情运行时.第二章战后对白玩家";
let 已注册王宫密室承接入口 = false;
let 王宫禁卫单位列表: any[] = [];
const 王宫密室门外对白标记表 = "主线剧情标记";
const 王宫密室门外对白标记键 = "第二章王宫密室门外对白已完成";

function 王宫密室门外对白尚未完成(this: void): boolean {
  return Number(YDUserDataGetSafe("string", 王宫密室门外对白标记表, 王宫密室门外对白标记键, "integer")) !== 1;
}

const 王宫禁卫击杀特效 = "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl";

function 执行里科特击杀王宫禁卫(this: void): void {
  for (let i = 0; i < 王宫禁卫单位列表.length; i++) {
    const 禁卫 = 王宫禁卫单位列表[i];
    if (禁卫 == null || 禁卫 === 0) continue;
    IssueImmediateOrder(禁卫, "stop");
    SetUnitAnimation(禁卫, "death");
    createTimedEffect(王宫禁卫击杀特效, GetUnitX(禁卫), GetUnitY(禁卫), 0, 1);
    KillUnit(禁卫);
  }
}

function 登记第二章战后对白玩家(this: void): void {
  const 玩家单位 = getRegisteredPlayerHero(Player(0));
  if (玩家单位 != null && 玩家单位 !== 0) 注册剧情运行时单位(第二章战后对白玩家引用, 玩家单位);
}

function 登记王宫四名预置禁卫(this: void): void {
  王宫禁卫单位列表 = [];
  for (let i = 0; i < 王宫禁卫缓存键表.length; i++) {
    const 缓存键 = 王宫禁卫缓存键表[i];
    const 禁卫 = 消费世界地图单位缓存(缓存键);
    if (禁卫 == null || 禁卫 === 0) continue;
    王宫禁卫单位列表.push(禁卫);
    IssueImmediateOrder(禁卫, "stop");
    注册剧情运行时单位(缓存键, 禁卫);
  }
}

function 使王宫禁卫面向里科特(this: void): void {
  const 里科特站位 = 王宫密室场景站位表.里科特王宫异变;
  for (let i = 0; i < 王宫禁卫单位列表.length; i++) {
    const 禁卫 = 王宫禁卫单位列表[i];
    if (禁卫 == null || 禁卫 === 0) continue;
    SetUnitFacing(禁卫, Math.atan2(里科特站位.Y - GetUnitY(禁卫), 里科特站位.X - GetUnitX(禁卫)) * 180 / Math.PI);
    IssueImmediateOrder(禁卫, "stop");
  }
}

export function 执行章节末长对白承接(this: void, 参数: 剧情动作参数表): void {
  进入剧情电影模式();
  登记第二章战后对白玩家();
  写入剧情进度(Number(参数.设置剧情进度) || Number(参数.目标进度) || 33);
}

export function 执行章节末紧急警告(this: void, _参数: 剧情动作参数表): void {
  播放原生任务音效("警告");
}

function 执行布置王宫潜入现场(this: void): void {
  登记王宫四名预置禁卫();
  读取或创建并定位王宫密室剧情单位("主线NPC.伪装卫兵", "精灵王卫", 王宫密室场景站位表.伪装卫兵王宫异变);
  const 皇家禁卫 = 读取或创建并定位王宫密室剧情单位("主线NPC.皇家禁卫", "虔诚的高等精灵骑士", 王宫密室场景站位表.皇家禁卫王宫异变);
  if (皇家禁卫 != null && 皇家禁卫 !== 0) 王宫禁卫单位列表.push(皇家禁卫);

  let 里科特 = 读取语义单位引用("Boss.里科特");
  if (里科特 == null || 里科特 === 0) {
    里科特 = 创建并冻结剧情Boss预置({
      Boss键: "Boss.里科特",
      Boss名: "里科特",
      X: 王宫密室场景站位表.里科特王宫异变.X,
      Y: 王宫密室场景站位表.里科特王宫异变.Y,
      朝向: 王宫密室场景站位表.里科特王宫异变.朝向,
      预创建后暂停: true,
      预创建后无敌: true,
    });
  }
  if (里科特 == null || 里科特 === 0) return;

  定位并登记王宫密室剧情单位("Boss.里科特", "Boss.里科特", 王宫密室场景站位表.里科特王宫异变);
  ShowUnit(里科特, false);
  使王宫禁卫面向里科特();
  应用剧情电影镜头(王宫潜入镜头预设, 0);
}

function 执行里科特现身(this: void): void {
  const 里科特 = 读取语义单位引用("Boss.里科特");
  if (里科特 == null || 里科特 === 0) return;
  const 站位 = 王宫密室场景站位表.里科特王宫异变;
  createTimedEffect(里科特登场特效, 站位.X, 站位.Y, 0, 1.2);
  ShowUnit(里科特, true);
  使王宫禁卫面向里科特();
}

function 执行里科特威慑禁卫(this: void): void {
  const 里科特 = 读取语义单位引用("Boss.里科特");
  if (里科特 != null && 里科特 !== 0) SetUnitAnimationByIndex(里科特, 4);
}

function 执行切换王宫门口近景镜头(this: void): void {
  应用剧情电影镜头(王宫门口近景镜头预设, 0);
}

function 执行里科特走向王宫传送门(this: void): void {
  const 里科特 = 读取语义单位引用("Boss.里科特");
  const 传送门 = jglobals.gg_dest_B00K_5466;
  if (传送门 == null || 传送门 === 0 || 里科特 == null || 里科特 === 0) return;

  ShowDestructable(传送门, true);
  const 传送门X = GetDestructableX(传送门);
  const 传送门Y = GetDestructableY(传送门);
  const dx = GetUnitX(里科特) - 传送门X;
  const dy = GetUnitY(里科特) - 传送门Y;
  const distance = Math.sqrt(dx * dx + dy * dy);
  const scale = distance > 0.01 ? 50 / distance : 0;
  const 目标X = 传送门X + dx * scale;
  const 目标Y = distance > 0.01 ? 传送门Y + dy * scale : 传送门Y + 50;

  移除单位暂停(里科特, 剧情Boss预置暂停来源);
  IssuePointOrder(里科特, "move", 目标X, 目标Y);
}

function 执行布置传承密室对峙场景(this: void): void {
  定位并登记王宫密室剧情单位("ZX.克林姆德王", "主线NPC.克林姆德王", 王宫密室场景站位表.克林姆德王对峙);
  定位并登记王宫密室剧情单位("ZX.赫克提尔", "主线NPC.赫克提尔", 王宫密室场景站位表.赫克提尔对峙);
  定位并登记王宫密室剧情单位("Boss.里科特", "Boss.里科特", 王宫密室场景站位表.里科特密室);
  应用剧情电影镜头(王宫密室对峙镜头预设, 0);
}

function 执行里科特进入传承密室(this: void): void {
  播放王宫密室演出特效("里科特进入传承密室", 王宫密室场景站位表.里科特密室);
}

function 执行布置王宫门外回援人员(this: void): void {
  const 艾伦 = 读取或创建并定位王宫密室剧情单位("主线NPC.艾伦", "王宫卫队长-艾伦", 王宫密室场景站位表.艾伦密室门外);
  const 里凡特 = 读取或创建并定位王宫密室剧情单位("主线NPC.里凡特", "第一王子-里凡特", 王宫密室场景站位表.里凡特密室门外);
  读取或创建并定位王宫密室剧情单位("主线NPC.耶提尔", "防卫部长-耶提尔", 王宫密室场景站位表.耶提尔返回王宫);
  if (里凡特 != null && 里凡特 !== 0) {
    for (let i = 0; i < 王宫禁卫单位列表.length; i++) {
      const 禁卫 = 王宫禁卫单位列表[i];
      if (禁卫 == null || 禁卫 === 0) continue;
      IssuePointOrder(禁卫, "move", GetUnitX(里凡特), GetUnitY(里凡特));
    }
  }
  if (已注册王宫密室承接入口) return;
  已注册王宫密室承接入口 = true;
  const 入口基础配置 = {
    剧情片段ID: "elven_city_prince_boss_start",
    注册范围: 400,
    需要剧情进度: 33,
    触发后注销: true,
    运行时条件: 王宫密室门外对白尚未完成,
  };
  注册主线剧情运行时单位范围入口(艾伦, { ...入口基础配置, 配置名: "艾伦密室承接" });
  注册主线剧情运行时单位范围入口(里凡特, { ...入口基础配置, 配置名: "里凡特密室承接" });
}

function 执行里科特开启传承密室门(this: void): void {
  播放王宫传送门封印特效();
}

function 执行完成里科特传送入密室(this: void): void {
  const 里科特 = 读取语义单位引用("Boss.里科特");
  if (里科特 != null && 里科特 !== 0) {
    IssueImmediateOrder(里科特, "stop");
    添加单位暂停(里科特, 剧情Boss预置暂停来源);
    ShowUnit(里科特, false);
  }

  执行布置传承密室对峙场景();
  if (里科特 != null && 里科特 !== 0) ShowUnit(里科特, true);
  执行里科特进入传承密室();
  执行布置王宫门外回援人员();
}

function 执行打开菲利斯首领奖励(this: void): void {
  // 先让剧情播放器退出电影模式并恢复镜头，再打开奖励 UI，避免奖励面板叠在最后一句对白上。
  addDelayedCallback(100, function on菲利斯承接对白结束(): void {
    打开Boss死亡首领奖励UI(菲利斯奖励池ID);
  });
}

export const 第二章王子Boss战后承接剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_章节末长对白承接": 执行章节末长对白承接,
  "SW01死亡事件_章节末紧急警告": 执行章节末紧急警告,
  "JLC精灵城_布置王宫潜入现场": 执行布置王宫潜入现场,
  "JLC精灵城_里科特现身": 执行里科特现身,
  "JLC精灵城_里科特威慑禁卫": 执行里科特威慑禁卫,
  "JLC精灵城_里科特击杀王宫禁卫": 执行里科特击杀王宫禁卫,
  "JLC精灵城_切换王宫门口近景镜头": 执行切换王宫门口近景镜头,
  "JLC精灵城_里科特开启传承密室门": 执行里科特开启传承密室门,
  "JLC精灵城_里科特走向王宫传送门": 执行里科特走向王宫传送门,
  "JLC精灵城_布置传承密室对峙场景": 执行布置传承密室对峙场景,
  "JLC精灵城_里科特进入传承密室": 执行里科特进入传承密室,
  "JLC精灵城_布置王宫门外回援人员": 执行布置王宫门外回援人员,
  "JLC精灵城_完成里科特传送入密室": 执行完成里科特传送入密室,
  "主线.打开菲利斯首领奖励": 执行打开菲利斯首领奖励,
};
