/** @noSelfInFile */

import type { Boss测试注册配置 } from "./00．Boss测试类型";

const globals = require("jass.globals") as { udg_Boss?: any; [key: string]: any };
const { 设置Boss自动施法开启, Boss自动施法是否开启 } = require("系统.03．技能系统.06．AI自动使用技能.04．Boss自动施法开关") as {
  设置Boss自动施法开启: (this: void, 开启: boolean) => void;
  Boss自动施法是否开启: (this: void) => boolean;
};
const { 记录Boss自动技能启动, 清理Boss自动技能启动上下文, 是否已登记Boss自动技能 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  记录Boss自动技能启动: (this: void, unit: any, source: "Boss测试") => any;
  清理Boss自动技能启动上下文: (this: void, unit: any) => void;
  是否已登记Boss自动技能: (this: void, unit: any) => boolean;
};

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const jass = require("jass.common") as any;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (player: any, x: number, y: number, duration: number, text: string) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetPlayerName = jass.GetPlayerName as (player: any) => string;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (unit: any, player: any) => boolean;
const CreateGroup = jass.CreateGroup as () => any;
const DestroyGroup = jass.DestroyGroup as (group: any) => void;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (group: any, x: number, y: number, radius: number, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (group: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (group: any, unit: any) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const {
  Boss测试单位存活,
  获取Boss测试玩家基准英雄,
  创建Boss测试临时步兵,
  击杀最近Boss测试临时步兵,
  清理Boss测试临时步兵,
} = require("系统.12．测试系统.00．Boss测试系统.02．Boss测试单位") as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  创建Boss测试临时步兵: (this: void, x: number, y: number, facing?: number) => any;
  击杀最近Boss测试临时步兵: (this: void) => any;
  清理Boss测试临时步兵: (this: void) => void;
};

interface Boss测试当前会话 {
  玩家: any;
  配置: Boss测试注册配置;
  上下文: any;
  Boss单位: any;
}

const Boss测试选择命令表: Record<string, Boss测试注册配置 | undefined> = {};
const Boss测试配置列表: Boss测试注册配置[] = [];
const 已注册技能命令表: Record<string, boolean | undefined> = {};
const Boss测试玩家ID = 0;
const Boss测试玩家名称 = "WorldEdit";
const Boss测试列表命令 = "Boss列表";
const Boss测试重置命令 = "Boss重置";
const Boss测试清理命令 = "Boss清理";
const Boss测试AI开启命令 = "BossAI开启";
const Boss测试AI关闭命令 = "BossAI关闭";
const Boss测试触发受击命令 = "55";
const Boss测试创建临时步兵命令 = "77";
const Boss测试击杀临时步兵命令 = "77-kill";
const Boss测试触发受击伤害 = 1000;
const Boss测试触发受击搜索半径 = 1000;
const Boss测试触发受击日志模块 = "Boss测试55";
let 当前Boss测试会话: Boss测试当前会话 | undefined;
let 已注册Boss测试公共命令 = false;

function 发送Boss测试提示(this: void, player: any, Boss名称: string, text: string): void {
  DisplayTimedTextToPlayer(player, 0, 0, 12, "[" + Boss名称 + "测试] " + text);
}

function 获取Boss测试技能命令文本(this: void, item: Boss测试注册配置["技能命令列表"][number]): string {
  if (item.命令 != null && item.命令 !== "") return item.命令;
  return item.序号.toString();
}

function 生成命令说明(this: void, 配置: Boss测试注册配置): string {
  let text = "";
  const list = 配置.技能命令列表;
  for (let i = 0; i < list.length; i++) {
    text = text + " " + 获取Boss测试技能命令文本(list[i]) + list[i].名称;
  }
  return text + "。";
}

function 是允许Boss测试玩家(this: void, player: any): boolean {
  if (player == null || player === 0) return false;
  if (GetPlayerId(player) !== Boss测试玩家ID) return false;
  const playerName = GetPlayerName(player) ?? "";
  return playerName === Boss测试玩家名称 || playerName === Boss测试玩家名称 + ":";
}

function 从Boss测试上下文取Boss单位(this: void, context: any): any {
  if (context == null) return null;
  const runtime = context.运行时;
  const candidates = [
    context.Boss单位,
    context.Boss,
    context.安兹单位,
    context.赤誓灵卫单位,
    context.red,
    runtime?.Boss单位,
    runtime?.Boss,
    runtime?.安兹单位,
    runtime?.赤誓灵卫单位,
    runtime?.red,
  ];
  for (let i = 0; i < candidates.length; i++) {
    if (Boss测试单位存活(candidates[i])) return candidates[i];
  }
  return null;
}

function 解析当前Boss测试单位(this: void, context: any, 会话Boss: any): any {
  const contextBoss = 从Boss测试上下文取Boss单位(context);
  if (Boss测试单位存活(contextBoss)) return contextBoss;
  if (Boss测试单位存活(globals.udg_Boss)) return globals.udg_Boss;
  if (Boss测试单位存活(会话Boss)) return 会话Boss;
  return null;
}

function 取诊断句柄ID(this: void, unit: any): number {
  return unit != null && unit !== 0 ? (GetHandleId(unit) || 0) : 0;
}

function 取诊断单位类型ID(this: void, unit: any): number {
  return unit != null && unit !== 0 ? (GetUnitTypeId(unit) || 0) : 0;
}

function 记录Boss测试55解析日志(this: void, Boss名称: string, contextBoss: any, globalBoss: any, sessionBoss: any, resolvedBoss: any): void {
  debugLogForce(
    Boss测试触发受击日志模块,
    "Boss=", Boss名称,
    "context(id/type/alive)=", 取诊断句柄ID(contextBoss), 取诊断单位类型ID(contextBoss), Boss测试单位存活(contextBoss),
    "global(id/type/alive)=", 取诊断句柄ID(globalBoss), 取诊断单位类型ID(globalBoss), Boss测试单位存活(globalBoss),
    "session(id/type/alive)=", 取诊断句柄ID(sessionBoss), 取诊断单位类型ID(sessionBoss), Boss测试单位存活(sessionBoss),
    "resolved(id/type/alive)=", 取诊断句柄ID(resolvedBoss), 取诊断单位类型ID(resolvedBoss), Boss测试单位存活(resolvedBoss),
  );
}

function 清理当前Boss测试会话(this: void): void {
  const session = 当前Boss测试会话;
  当前Boss测试会话 = undefined;
  清理Boss测试临时步兵();
  if (session != null) {
    清理Boss自动技能启动上下文(session.Boss单位);
    session.配置.清理上下文(session.玩家, session.上下文);
  }
  设置Boss自动施法开启(true);
}

function 激活Boss测试配置(this: void, player: any, 配置: Boss测试注册配置): void {
  清理当前Boss测试会话();
  设置Boss自动施法开启(false);
  const context = 配置.创建或获取上下文(player);
  if (context == null) {
    设置Boss自动施法开启(true);
    发送Boss测试提示(player, 配置.Boss名称, "测试场景创建失败。");
    return;
  }
  当前Boss测试会话 = { 玩家: player, 配置, 上下文: context, Boss单位: 解析当前Boss测试单位(context, globals.udg_Boss) };
  发送Boss测试提示(player, 配置.Boss名称, "已创建玩家1 Boss、1个固定步兵靶与1个固定山丘之王靶，自动AI已关闭。输入技能序号：" + 生成命令说明(配置) + " 输入55可让测试单位对Boss造成伤害；输入77可在玩家英雄位置创建临时步兵，输入77-kill可击杀最近创建的临时步兵；输入BossAI开启可验证正式AI。");
}

function onBoss测试选择命令(this: void, player: any, command: string): void {
  if (!是允许Boss测试玩家(player)) return;
  const 配置 = Boss测试选择命令表[command];
  if (配置 == null) return;
  激活Boss测试配置(player, 配置);
}

function onBoss测试技能命令(this: void, player: any, command: string): void {
  if (!是允许Boss测试玩家(player)) return;
  const session = 当前Boss测试会话;
  if (session == null || GetPlayerId(session.玩家) !== GetPlayerId(player)) return;

  const list = session.配置.技能命令列表;
  for (let i = 0; i < list.length; i++) {
    const item = list[i];
    if (获取Boss测试技能命令文本(item) !== command) continue;
    const context = session.上下文;
    if (context == null) return;
    session.Boss单位 = 解析当前Boss测试单位(context, session.Boss单位);
    发送Boss测试提示(player, session.配置.Boss名称, "正在测试：" + 获取Boss测试技能命令文本(item) + " " + item.名称 + "。");
    item.执行(player, context);
    return;
  }
  发送Boss测试提示(player, session.配置.Boss名称, "没有测试命令 " + command + "。可用命令：" + 生成命令说明(session.配置));
}

function onBoss测试列表命令(this: void, player: any): void {
  if (!是允许Boss测试玩家(player)) return;
  let text = "";
  for (let i = 0; i < Boss测试配置列表.length; i++) {
    text = text + (i > 0 ? "、" : "") + "Boss" + Boss测试配置列表[i].命令单位名;
  }
  发送Boss测试提示(player, "Boss", "可用场景：" + text + "。");
}

function onBoss测试重置命令(this: void, player: any): void {
  if (!是允许Boss测试玩家(player)) return;
  const session = 当前Boss测试会话;
  if (session == null || GetPlayerId(session.玩家) !== GetPlayerId(player)) return;
  激活Boss测试配置(player, session.配置);
}

function onBoss测试清理命令(this: void, player: any): void {
  if (!是允许Boss测试玩家(player)) return;
  const session = 当前Boss测试会话;
  if (session == null || GetPlayerId(session.玩家) !== GetPlayerId(player)) return;
  const Boss名称 = session.配置.Boss名称;
  清理当前Boss测试会话();
  发送Boss测试提示(player, Boss名称, "测试场景已清理。");
}

function onBoss测试AI开启命令(this: void, player: any): void {
  if (!是允许Boss测试玩家(player)) return;
  const session = 当前Boss测试会话;
  if (session == null || GetPlayerId(session.玩家) !== GetPlayerId(player)) return;
  if (Boss自动施法是否开启()) {
    发送Boss测试提示(player, session.配置.Boss名称, "自动AI已经处于开启状态。");
    return;
  }
  const context = session.上下文;
  session.Boss单位 = 解析当前Boss测试单位(context, session.Boss单位);
  if (session.Boss单位 == null || session.Boss单位 === 0) {
    发送Boss测试提示(player, session.配置.Boss名称, "自动AI开启失败：找不到当前测试Boss。");
    return;
  }
  if (!是否已登记Boss自动技能(session.Boss单位)) 记录Boss自动技能启动(session.Boss单位, "Boss测试");
  设置Boss自动施法开启(true);
  发送Boss测试提示(player, session.配置.Boss名称, "自动AI已开启，将按正式逻辑自动施法。");
}

function onBoss测试AI关闭命令(this: void, player: any): void {
  if (!是允许Boss测试玩家(player)) return;
  const session = 当前Boss测试会话;
  if (session == null || GetPlayerId(session.玩家) !== GetPlayerId(player)) return;
  if (!Boss自动施法是否开启()) {
    发送Boss测试提示(player, session.配置.Boss名称, "自动AI已经处于关闭状态。");
    return;
  }
  设置Boss自动施法开启(false);
  发送Boss测试提示(player, session.配置.Boss名称, "自动AI已关闭，仅数字命令会主动施法。");
}

function 查找Boss附近敌人(this: void, boss: any): any {
  const bossX = GetUnitX(boss);
  const bossY = GetUnitY(boss);
  const bossOwner = GetOwningPlayer(boss);
  const group = CreateGroup();
  let nearest: any = null;
  let nearestDistanceSquared = Boss测试触发受击搜索半径 * Boss测试触发受击搜索半径 + 1;
  GroupEnumUnitsInRange(group, bossX, bossY, Boss测试触发受击搜索半径, null);
  while (true) {
    const unit = FirstOfGroup(group);
    if (unit == null || unit === 0) break;
    GroupRemoveUnit(group, unit);
    if (unit !== boss && Boss测试单位存活(unit) && IsUnitEnemy(unit, bossOwner) === true) {
      const dx = GetUnitX(unit) - bossX;
      const dy = GetUnitY(unit) - bossY;
      const distanceSquared = dx * dx + dy * dy;
      if (distanceSquared < nearestDistanceSquared) {
        nearest = unit;
        nearestDistanceSquared = distanceSquared;
      }
    }
  }
  DestroyGroup(group);
  return nearest;
}

function onBoss测试触发受击命令(this: void, player: any): void {
  if (!是允许Boss测试玩家(player)) return;
  const session = 当前Boss测试会话;
  if (session == null || GetPlayerId(session.玩家) !== GetPlayerId(player)) return;
  const context = session.上下文;
  const sessionBossBeforeResolve = session.Boss单位;
  const globalBoss = globals.udg_Boss;
  let contextBoss: any = null;
  if (context != null) {
    contextBoss = 从Boss测试上下文取Boss单位(context);
  }
  session.Boss单位 = 解析当前Boss测试单位(context, session.Boss单位);
  const boss = session.Boss单位;
  记录Boss测试55解析日志(session.配置.Boss名称, contextBoss, globalBoss, sessionBossBeforeResolve, boss);
  if (!Boss测试单位存活(boss)) {
    发送Boss测试提示(player, session.配置.Boss名称, "触发受击失败：找不到当前测试Boss。");
    return;
  }
  const source = 查找Boss附近敌人(boss);
  if (!Boss测试单位存活(source)) {
    发送Boss测试提示(player, session.配置.Boss名称, "触发受击失败：Boss周围1000码内没有存活敌人。");
    return;
  }
  发送Boss测试提示(player, session.配置.Boss名称, "正在测试受击/反击：" + GetUnitName(source) + " 对Boss造成一次普通攻击伤害。");
  if (!UnitDamageTarget(source, boss, Boss测试触发受击伤害, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)) {
    发送Boss测试提示(player, session.配置.Boss名称, "触发受击失败：已找到敌人，但原生伤害调用失败。");
  }
}

function onBoss测试创建临时步兵命令(this: void, player: any): void {
  if (!是允许Boss测试玩家(player)) return;
  const session = 当前Boss测试会话;
  if (session == null || GetPlayerId(session.玩家) !== GetPlayerId(player)) return;
  const hero = 获取Boss测试玩家基准英雄(player);
  if (!Boss测试单位存活(hero)) {
    发送Boss测试提示(player, session.配置.Boss名称, "创建临时步兵失败：找不到玩家英雄。");
    return;
  }
  const infantry = 创建Boss测试临时步兵(GetUnitX(hero), GetUnitY(hero));
  if (!Boss测试单位存活(infantry)) {
    发送Boss测试提示(player, session.配置.Boss名称, "创建临时步兵失败：单位创建失败。");
    return;
  }
  发送Boss测试提示(player, session.配置.Boss名称, "正在测试安全圈：已在玩家英雄位置创建中立敌对步兵。");
}

function onBoss测试击杀临时步兵命令(this: void, player: any): void {
  if (!是允许Boss测试玩家(player)) return;
  const session = 当前Boss测试会话;
  if (session == null || GetPlayerId(session.玩家) !== GetPlayerId(player)) return;
  const infantry = 击杀最近Boss测试临时步兵();
  if (infantry == null || infantry === 0) {
    发送Boss测试提示(player, session.配置.Boss名称, "没有可击杀的77临时步兵。");
    return;
  }
  发送Boss测试提示(player, session.配置.Boss名称, "已击杀最近创建的77临时步兵。");
}

function 确保注册Boss测试公共命令(this: void): void {
  if (已注册Boss测试公共命令) return;
  已注册Boss测试公共命令 = true;
  注册聊天命令监听(Boss测试列表命令, onBoss测试列表命令);
  注册聊天命令监听(Boss测试重置命令, onBoss测试重置命令);
  注册聊天命令监听(Boss测试清理命令, onBoss测试清理命令);
  注册聊天命令监听(Boss测试AI开启命令, onBoss测试AI开启命令);
  注册聊天命令监听(Boss测试AI关闭命令, onBoss测试AI关闭命令);
  已注册技能命令表[Boss测试触发受击命令] = true;
  注册聊天命令监听(Boss测试触发受击命令, onBoss测试触发受击命令);
  已注册技能命令表[Boss测试创建临时步兵命令] = true;
  注册聊天命令监听(Boss测试创建临时步兵命令, onBoss测试创建临时步兵命令);
  已注册技能命令表[Boss测试击杀临时步兵命令] = true;
  注册聊天命令监听(Boss测试击杀临时步兵命令, onBoss测试击杀临时步兵命令);
}

export function 注册Boss测试命令组(this: void, 配置: Boss测试注册配置): void {
  确保注册Boss测试公共命令();
  const 选择命令 = "Boss" + 配置.命令单位名;
  if (Boss测试选择命令表[选择命令] == null) {
    Boss测试配置列表.push(配置);
    注册聊天命令监听(选择命令, onBoss测试选择命令);
  }
  Boss测试选择命令表[选择命令] = 配置;

  const list = 配置.技能命令列表;
  for (let i = 0; i < list.length; i++) {
    const item = list[i];
    const 命令 = 获取Boss测试技能命令文本(item);
    if (已注册技能命令表[命令] === true) continue;
    已注册技能命令表[命令] = true;
    注册聊天命令监听(命令, onBoss测试技能命令);
  }
}

export function 清理当前Boss测试(this: void): void {
  清理当前Boss测试会话();
}
