/** @noSelfInFile */
/**
 * 动态技能文本系统 - 入口与导出
 *
 * 改为和冷却/蓝耗一致的本地选中驱动：
 * - 只处理本地玩家当前唯一选中的已注册英雄
 * - 不再轮询所有已注册英雄
 */

const jass = require("jass.common") as any;

const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
};
const selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照") as {
  初始化本地选中技能快照: (this: void) => void;
  获取本地选中技能快照: (this: void) => {
    hero: any | null;
    skills: Record<"Q" | "W" | "E" | "R" | "D", number>;
  };
};
const 功能开关模块 = require("系统.00．核心系统.02．功能开关.01．QWERD显示开关") as {
  本地玩家是否开启动态技能文本: (this: void) => boolean;
};

const { debugLog } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (module: string, ...args: any[]) => void;
};

import { 恢复英雄技能原始文本, 检查英雄技能 } from "./03．核心逻辑";

const MODULE_NAME = "动态技能文本";
const REFRESH_MS = 300;

let initialized = false;
let 当前生效英雄: any | null = null;
let 当前快照签名 = "";

function isValidHandle(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 获取本地当前选中英雄(this: void): any | null {
  return selectionSnapshotSystem.获取本地选中技能快照().hero;
}

function 构建动态文本快照签名(this: void, hero: any): string {
  if (!isValidHandle(hero)) return "";

  const 命令卡快照 = selectionSnapshotSystem.获取本地选中技能快照();
  const 片段列表: string[] = [];
  片段列表.push("hero=" + tostring(hero));

  const 技能热键列表: Array<"Q" | "W" | "E" | "R" | "D"> = ["Q", "W", "E", "R", "D"];
  for (let i = 0; i < 技能热键列表.length; i++) {
    const 热键 = 技能热键列表[i];
    const abilityId = 命令卡快照.skills[热键] || 0;
    const level = abilityId !== 0 ? jass.GetUnitAbilityLevel(hero, abilityId) : 0;
    片段列表.push(热键 + "=" + abilityId + ":" + level);
  }

  return 片段列表.join("|");
}

function 恢复当前生效英雄(this: void): void {
  if (!isValidHandle(当前生效英雄)) {
    当前生效英雄 = null;
    当前快照签名 = "";
    return;
  }
  恢复英雄技能原始文本(当前生效英雄);
  当前生效英雄 = null;
  当前快照签名 = "";
}

function onTick(this: void): void {
  const 已开启 = 功能开关模块.本地玩家是否开启动态技能文本();
  const localHero = 已开启 ? 获取本地当前选中英雄() : null;

  if (当前生效英雄 !== localHero) {
    if (isValidHandle(当前生效英雄)) {
      恢复英雄技能原始文本(当前生效英雄);
    }
    当前生效英雄 = localHero;
    当前快照签名 = "";
  }

  if (!isValidHandle(当前生效英雄)) return;
  if (!已开启) return;

  const nextSignature = 构建动态文本快照签名(当前生效英雄);
  if (nextSignature === 当前快照签名) return;

  当前快照签名 = nextSignature;
  检查英雄技能(当前生效英雄);
}

export function registerDynamicSkillTextHero(this: void, whichHero: any): void {
  if (!isValidHandle(whichHero)) return;
  debugLog(MODULE_NAME, "注册英雄用于动态文本");
}

export function initDynamicSkillTextSystem(this: void): void {
  if (initialized) return;
  initialized = true;
  selectionSnapshotSystem.初始化本地选中技能快照();
  addPeriodicCallback(REFRESH_MS, onTick);
  debugLog(MODULE_NAME, "初始化动态技能文本系统");
}

export function restoreDynamicSkillTextCurrentHero(this: void): void {
  恢复当前生效英雄();
}
