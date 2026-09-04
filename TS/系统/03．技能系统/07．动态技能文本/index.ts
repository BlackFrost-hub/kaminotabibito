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
const syncHardwareInput = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心") as {
  registerSyncHardwareKey: (this: void, key: number | string, status: number, callback: (this: void, event: any) => void) => any;
};
const { KEY_STATE } = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义") as {
  KEY_STATE: { DOWN: number; UP: number };
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照") as {
  初始化本地选中技能快照: (this: void) => void;
  获取本地选中技能快照: (this: void) => {
    hero: any | null;
    skills: Record<"Q" | "W" | "E" | "R" | "D", number>;
    slots: Record<"Q" | "W" | "E" | "R" | "D", { x: number; y: number }>;
  };
};
const 功能开关模块 = require("系统.00．核心系统.02．功能开关.01．QWERD显示开关") as {
  本地玩家是否开启动态技能文本: (this: void) => boolean;
};

const { debugLog } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (module: string, ...args: any[]) => void;
};

import { 动态文本白名单 } from "./01．公式配置";
import { 获取属性值 } from "./02．属性计算";
import {
  恢复英雄技能原始文本,
  检查英雄技能,
  同步刷新英雄技能界面,
  同步刷新英雄技能原始界面,
} from "./03．核心逻辑";
import { 初始化技能提示UI } from "./05．技能提示UI";

const MODULE_NAME = "动态技能文本";
const REFRESH_MS = 300;
const ALT_KEY_CODE = 18;

let initialized = false;
let 当前生效英雄: any | null = null;
let 当前快照签名 = "";
let Alt同步按下 = false;

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

  for (let i = 0; i < 动态文本白名单.length; i++) {
    const 属性名 = 动态文本白名单[i];
    const 属性值 = 获取属性值(hero, 属性名);
    片段列表.push("attr:" + 属性名 + "=" + tostring(属性值));
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

function 处理同步Alt按下(this: void, event: any): void {
  if (Alt同步按下) return;
  const player = event != null ? event.player : null;
  const hero = getRegisteredPlayerHero(player);
  if (!isValidHandle(hero)) return;

  Alt同步按下 = true;
  同步刷新英雄技能原始界面(hero);
}

function 处理同步Alt松开(this: void, event: any): void {
  if (!Alt同步按下) return;
  const player = event != null ? event.player : null;
  const hero = getRegisteredPlayerHero(player);
  if (!isValidHandle(hero)) return;

  Alt同步按下 = false;
  同步刷新英雄技能界面(hero);
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
  if (!已开启) {
    return;
  }

  const nextSignature = 构建动态文本快照签名(当前生效英雄);
  if (nextSignature !== 当前快照签名) {
    当前快照签名 = nextSignature;
    检查英雄技能(当前生效英雄);
  }

}

export function registerDynamicSkillTextHero(this: void, whichHero: any): void {
  if (!isValidHandle(whichHero)) return;
  debugLog(MODULE_NAME, "注册英雄用于动态文本");
}

export function initDynamicSkillTextSystem(this: void): void {
  if (initialized) return;
  initialized = true;
  selectionSnapshotSystem.初始化本地选中技能快照();
  // 技能提示帧在初始化时同步创建并注册悬停事件，不使用延迟回调。
  初始化技能提示UI();
  addPeriodicCallback(REFRESH_MS, onTick);
  syncHardwareInput.registerSyncHardwareKey(ALT_KEY_CODE, KEY_STATE.DOWN, 处理同步Alt按下);
  syncHardwareInput.registerSyncHardwareKey(ALT_KEY_CODE, KEY_STATE.UP, 处理同步Alt松开);
  debugLog(MODULE_NAME, "初始化动态技能文本系统");
}

export function restoreDynamicSkillTextCurrentHero(this: void): void {
  恢复当前生效英雄();
}
