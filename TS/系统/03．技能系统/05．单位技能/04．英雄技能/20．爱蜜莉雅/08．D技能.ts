/** @noSelfInFile */
/**
 * 爱蜜莉雅 - D：帕克显现（A7）
 *
 * - 无目标施法：创建帕克环绕表现 + 状态 Buff + 最多 3 次强化资源（A1 状态容器）。
 * - Q/W/E/R 按规划读取并消费资源（消费爱蜜莉雅D强化）；资源不足不执行强化分支。
 * - R 强化成功后结束 D 状态并清理环绕表现（结束爱蜜莉雅D）。
 * - D 到期/被打断/英雄死亡统一清理环绕特效、Buff、计时器与状态（A1 统一回收 + 本文件清理）。
 * - 不创建可选取独立帕克单位。
 */

import { 爱蜜莉雅技能配置, 爱蜜莉雅D配置 } from "./00．配置";
import { 爱蜜莉雅BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/20．爱蜜莉雅";
import {
  获取爱蜜莉雅D强化,
  设置爱蜜莉雅D强化,
  清理爱蜜莉雅D强化,
  登记爱蜜莉雅技能清理,
} from "./02．公共状态与冰晶";
import { 播放爱蜜莉雅动作 } from "./02．公共状态与冰晶";

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 创建点特效, createUnitEffect, destroyUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
  destroyUnitEffect: (this: void, unit: any, effectKey?: string) => void;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { addDelayedCallback, removeDelayedCallback, getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  getGameTime: (this: void) => number;
};

const 英雄单位类型ID = jass.FourCC(爱蜜莉雅技能配置.单位类型ID) as number;
const 环绕特效键 = "爱蜜莉雅D环绕";
/** 每英雄 D 到期回调 ID（重复开启时先取消旧回调，防止旧回调提前清掉新 D 状态） */
const D到期回调表: Record<number, number | undefined> = {};

const { 取单位ID } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  取单位ID: (this: void, unit: any) => number;
};

/** 清理 D 表现与状态（到期/打断/死亡/R 收束共用；幂等） */
export function 结束爱蜜莉雅D(this: void, 施法者: any): void {
  if (施法者 == null || 施法者 === 0) return;
  // 取消挂起的到期回调（若仍存在）
  const 旧ID = D到期回调表[取单位ID(施法者)];
  if (旧ID != null && 旧ID !== 0) {
    removeDelayedCallback(旧ID);
    delete D到期回调表[取单位ID(施法者)];
  }
  destroyUnitEffect(施法者, 环绕特效键);
  移除单位指定Buff(施法者, 爱蜜莉雅BuffID.帕克显现);
  清理爱蜜莉雅D强化(施法者);
}

function 释放D帕克显现(this: void, _context: any, 施法者: any, _技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0) return;
  const 英雄ID = 取单位ID(施法者);
  播放爱蜜莉雅动作(施法者, 爱蜜莉雅D配置.动作索引, 1.0);
  // 重复 D：先取消旧到期回调（旧回调不得清掉新 D 状态）+ 清理旧环绕表现
  const 旧到期ID = D到期回调表[英雄ID];
  if (旧到期ID != null && 旧到期ID !== 0) removeDelayedCallback(旧到期ID);
  delete D到期回调表[英雄ID];
  destroyUnitEffect(施法者, 环绕特效键);
  移除单位指定Buff(施法者, 爱蜜莉雅BuffID.帕克显现);

  const 持续毫秒 = 爱蜜莉雅D配置.持续秒 * 1000;
  设置爱蜜莉雅D强化(施法者, 爱蜜莉雅D配置.强化次数, 持续毫秒);
  registerManualBuff(施法者, 爱蜜莉雅BuffID.帕克显现, 爱蜜莉雅D配置.持续秒, 爱蜜莉雅D配置.强化次数, {
    stack: 爱蜜莉雅D配置.强化次数,
  });

  // 帕克环绕（常驻，到期/结束销毁）+ 360° 显现扩散（一次性）
  createUnitEffect(施法者, "origin", 爱蜜莉雅D配置.环绕模型, 爱蜜莉雅D配置.持续秒, 环绕特效键);
  创建点特效({
    模型路径: 爱蜜莉雅D配置.扩散模型,
    X: GetUnitX(施法者),
    Y: GetUnitY(施法者),
    Z: 30,
    缩放: 1,
    持续秒: 0.5,
  });

  // 到期清理（幂等：结束爱蜜莉雅D 已清理状态）；重复 D 时旧回调先被取消
  const 到期ID = addDelayedCallback(持续毫秒, function D到期清理(this: void): void {
    delete D到期回调表[英雄ID];
    结束爱蜜莉雅D(施法者);
  });
  D到期回调表[英雄ID] = 到期ID;
  const 注销 = 登记爱蜜莉雅技能清理(施法者, "D到期", function D清理(this: void): void {
    const 当前ID = D到期回调表[英雄ID];
    if (当前ID != null && 当前ID === 到期ID) {
      removeDelayedCallback(当前ID);
      delete D到期回调表[英雄ID];
    }
    结束爱蜜莉雅D(施法者);
  });
  void 注销;
}

export function 注册爱蜜莉雅D(this: void): void {
  注册单位技能壳监听({
    名称: "爱蜜莉雅-帕克显现（D）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 爱蜜莉雅技能配置.D.技能ID,
    获取或创建上下文: function D上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放D帕克显现,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 爱蜜莉雅D配置.持续秒,
  });
}

export {};
