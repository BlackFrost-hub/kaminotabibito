/**
 * 单位初始化创建 - 统一导出和初始化入口
 */

// ========== 子系统导出 ==========
export * from "./01．玩家英雄/02．英雄升级系统/index";
export * from "./02．世界地图单位初始化/index";

// ========== 初始化 ==========
const 英雄升级系统 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.index") as { init?: () => void };
if (typeof 英雄升级系统.init === "function") 英雄升级系统.init();
const { 初始化怪物刷新系统 } = require("系统.01．单位系统.03．怪物刷新系统.02．怪物刷新核心") as {
  初始化怪物刷新系统: (this: void) => void;
};
const {
  启用世界地图单位TS初始化,
  启动世界地图全部单位缓步创建,
  获取世界地图全部单位创建状态,
  初始化世界地图中立生物,
  初始化世界地图植物,
  初始化世界地图异界描述石,
  延迟初始化世界地图Boss初始注册,
} = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.index") as {
  启用世界地图单位TS初始化?: boolean;
  启动世界地图全部单位缓步创建?: (this: void, 选项?: { 完成回调?: (this: void) => void }) => void;
  获取世界地图全部单位创建状态?: (this: void) => {
    当前阶段: "未启动" | "杂鱼" | "杂鱼+精英" | "NPC" | "商人" | "完成";
    杂鱼总数: number;
    杂鱼已创建数: number;
    精英总数: number;
    精英已创建数: number;
  };
  初始化世界地图中立生物?: (this: void) => number;
  初始化世界地图植物?: (this: void) => number;
  初始化世界地图异界描述石?: (this: void) => number;
  延迟初始化世界地图Boss初始注册?: (this: void) => void;
};
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
let 世界地图杂鱼精英创建已完成 = false;
let 怪物刷新系统已初始化 = false;
let 刷怪初始化等待回调ID: number | undefined;
let 其他世界地图配置已初始化 = false;

function 初始化其他世界地图配置(this: void): void {
  if (其他世界地图配置已初始化) return;
  其他世界地图配置已初始化 = true;

  if (typeof 初始化世界地图中立生物 === "function") {
    初始化世界地图中立生物();
  }
  if (typeof 初始化世界地图植物 === "function") {
    初始化世界地图植物();
  }
  if (typeof 初始化世界地图异界描述石 === "function") {
    初始化世界地图异界描述石();
  }
}

function 尝试初始化怪物刷新系统(this: void): void {
  if (怪物刷新系统已初始化) return;
  if (启用世界地图单位TS初始化 === true && !世界地图杂鱼精英创建已完成) return;
  怪物刷新系统已初始化 = true;
  初始化怪物刷新系统();
}

function 停止等待杂鱼精英创建完成(this: void): void {
  if (刷怪初始化等待回调ID == null) return;
  removePeriodicCallback(刷怪初始化等待回调ID);
  刷怪初始化等待回调ID = undefined;
}

function on世界地图杂鱼精英创建完成(this: void): void {
  if (世界地图杂鱼精英创建已完成) return;
  世界地图杂鱼精英创建已完成 = true;
  停止等待杂鱼精英创建完成();
  尝试初始化怪物刷新系统();
}

function on检查世界地图杂鱼精英创建状态(this: void): void {
  if (typeof 获取世界地图全部单位创建状态 !== "function") return;
  const 状态 = 获取世界地图全部单位创建状态();
  if (状态.当前阶段 === "未启动" || 状态.当前阶段 === "杂鱼" || 状态.当前阶段 === "杂鱼+精英") return;
  on世界地图杂鱼精英创建完成();
}

/**
 * 初始化单位创建
 */
export function init(): void {
  if (启用世界地图单位TS初始化 !== true) {
    尝试初始化怪物刷新系统();
    return;
  }
  if (typeof 启动世界地图全部单位缓步创建 === "function") {
    启动世界地图全部单位缓步创建({ 完成回调: on世界地图杂鱼精英创建完成 });
    刷怪初始化等待回调ID = addPeriodicCallback(100, on检查世界地图杂鱼精英创建状态);
  } else {
    世界地图杂鱼精英创建已完成 = true;
  }
  初始化其他世界地图配置();
  if (typeof 延迟初始化世界地图Boss初始注册 === "function") {
    延迟初始化世界地图Boss初始注册();
  }
  尝试初始化怪物刷新系统();
}
