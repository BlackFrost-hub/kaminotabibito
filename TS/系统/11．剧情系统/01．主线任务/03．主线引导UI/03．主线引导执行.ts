/**
 * 主线引导执行逻辑
 *
 * 点击回调与执行逻辑（读取剧情进度、移动镜头、GS_news）
 * 按钮点击注册必须 sync=true
 * Dz 回调必须是模块级具名函数，不允许匿名闭包/箭头函数
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { GS_news } = require("lib.扩展函数.Star扩展函数.GS扩展库.index") as {
  GS_news: (this: void, whichPlayer: any, message: string) => void;
};
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.index") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};
const { 读取语义单位引用 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具") as {
  读取语义单位引用: (this: void, 引用: string) => any;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

import { 帧 } from "./02．主线引导框架";
import { 获取进度配置 } from "./01．主线引导配置表";
import type { 进度配置 } from "./00．主线引导类型";

// ========== JASS / japi 局部别名 ==========

const DzFrameShow = japi.DzFrameShow as (this: void, frame: number, show: boolean) => void;
const DzFrameSetText = japi.DzFrameSetText as (this: void, frame: number, text: string) => void;
const DzGetTriggerUIEventPlayer = japi.DzGetTriggerUIEventPlayer as (this: void) => any;
const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, whichPlayer: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;

// ========== 模块级状态 ==========

const 玩家展开状态表: Record<number, boolean | undefined> = {};
const 放大效果隐藏延迟毫秒 = 250;
const 放大效果隐藏玩家队列: any[] = [];

// ========== 辅助函数 ==========

/**
 * 获取镜头目标坐标
 * 优先跟随单位，其次固定坐标
 */
function 获取镜头目标(this: void, 配置: 进度配置): { x: number; y: number } | null {
  if (配置.镜头跟随单位 != null) {
    const unit = 读取语义单位引用(配置.镜头跟随单位);
    if (unit != null && unit !== 0) {
      return { x: GetUnitX(unit), y: GetUnitY(unit) };
    }
  }
  if (配置.镜头X != null && 配置.镜头Y != null) {
    return { x: 配置.镜头X, y: 配置.镜头Y };
  }
  return null;
}

// ========== 回调（模块级具名函数） ==========

/**
 * 延时隐藏放大效果
 * 全端执行，本地显隐
 */
function on隐藏放大效果(this: void): void {
  const player = 放大效果隐藏玩家队列.shift();
  if (player == null || player === 0) return;
  if (GetLocalPlayer() === player) {
    DzFrameShow(帧.放大效果, false);
  }
}

/**
 * 主线引导按钮点击回调
 * sync=true，全端执行
 */
export function on主线引导按钮点击(this: void): void {
  const 触发玩家 = DzGetTriggerUIEventPlayer();
  if (触发玩家 == null || 触发玩家 === 0) return;
  const 玩家ID = GetPlayerId(触发玩家);
  const 已展开 = 玩家展开状态表[玩家ID] === true;

  // 与旧 JASS 一致：按玩家切换主线任务点击状态，但无论展开/收起都继续执行引导提示。
  if (!已展开) {
    玩家展开状态表[玩家ID] = true;

    // 仅本地显示放大效果
    if (GetLocalPlayer() === 触发玩家) {
      DzFrameShow(帧.放大效果, true);
    }

    // 延时隐藏放大效果（全端执行，本地显隐）
    放大效果隐藏玩家队列.push(触发玩家);
    addDelayedCallback(放大效果隐藏延迟毫秒, on隐藏放大效果);
  } else {
    玩家展开状态表[玩家ID] = false;
    DzFrameShow(帧.放大效果, false);
  }

  const config = 获取进度配置();
  if (config == null) return;

  // 旧 JASS 创建了文本框但没有在点击逻辑里显示；这里仅同步更新文本内容，保持 UI 句柄可用于后续扩展。
  DzFrameSetText(帧.提示文本, config.提示文本);

  const target = 获取镜头目标(config);
  if (target != null) {
    StarOther_PanCameraToTimedForPlayer(触发玩家, target.x, target.y, 0.01);
  }

  GS_news(触发玩家, config.提示文本);
}
