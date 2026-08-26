/** @noSelfInFile */
/**
 * 通用技能时间线工厂（M-01）
 *
 * 基于技能阶段链执行器（06）提供"立即/延迟阶段 + 动作/硬直/音效/特效 + 业务回调"的
 * 配置化时间线编排。复用阶段链驱动（不重新实现阶段调度）：
 * - 每个时间线阶段转为阶段链的 延迟执行阶段（延迟 0 = 立即执行阶段）
 * - 整条时间线结束回调只执行一次（阶段链执行器已结束 幂等保证）
 * - 单位死亡自动中断时间线（文件级死亡监听）
 *
 * 职责边界：不读取英雄属性、不计算伤害、不选择目标、不写 Buff 名称与暂停来源。
 * 硬直统一走 GS_Suspend（具名来源）；阶段硬直自然到期，时间线结束不主动清零。
 */

import { 开始技能阶段链, 停止技能阶段链, 创建延迟执行阶段, type 技能阶段链结束原因, type 技能阶段定义 } from "./06．技能阶段链执行器";
import { 显示常规技能吟唱条, 关闭吟唱条 } from "../../../../09．表现系统/08．吟唱条/06．对外接口";
import { 秒转毫秒 } from "../../02．通用函数/24．整数与时间换算";
import type { 机制清理篮子 } from "../../04．机制组件/06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { GS_Suspend } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  GS_Suspend: (this: void, u: any, time: number) => void;
};
const { 创建点特效, createUnitEffect, destroyUnitEffect, createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
  destroyUnitEffect: (this: void, unit: any, effectKey?: string) => void;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitXSafe = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitYSafe = jass.GetUnitY as (this: void, unit: any) => number;

export type 技能时间线结束原因 = 技能阶段链结束原因;

export interface 时间线音效配置 {
  路径: string;
  裁断?: number;
}

export interface 时间线点特效配置 {
  模型: string;
  X?: number;
  Y?: number;
  Z?: number;
  缩放?: number;
  持续秒?: number;
}

export interface 时间线单位特效配置 {
  模型: string;
  挂点?: string;
  持续秒?: number;
}

export interface 时间线吟唱条配置 {
  总时长: number;
  标题?: string;
  类型?: string;
}

/** 时间线阶段配置（一个阶段 = 一次延迟 + 一组表现 + 一个业务回调） */
export interface 技能时间线阶段配置 {
  名称?: string;
  /** 延迟秒；0 或省略 = 立即执行 */
  延迟秒?: number;
  /** 阶段业务回调：可同步（立即调完成）或异步（延迟调完成）；不调用完成则阶段不推进 */
  业务?: (this: void, 单位: any, 数据: Record<string, any>, 完成: (this: void) => void) => void;
  /** 阶段硬直秒（GS_Suspend，自然到期） */
  硬直秒?: number;
  /** 阶段音效（单位绑定 3D 音效） */
  音效?: 时间线音效配置;
  /** 阶段点特效（持续秒自销毁） */
  点特效?: 时间线点特效配置;
  /** 阶段单位绑定限时特效 */
  单位特效?: 时间线单位特效配置;
}

export interface 通用技能时间线参数 {
  单位: any;
  阶段: 技能时间线阶段配置[];
  数据?: Record<string, any>;
  /** 外部清理篮子：时间线结束时由阶段链回调清除登记；篮子清理时主动停止时间线。 */
  清理?: 机制清理篮子;
  /** 全局吟唱条：首个阶段开始时显示，时间线结束时关闭 */
  吟唱条?: 时间线吟唱条配置;
  结束回调?: (this: void, 单位: any, 原因: 技能时间线结束原因, 时间线ID: number) => void;
}

export interface 通用技能时间线上下文 {
  时间线ID: number;
  /** 阶段链底层上下文的同义 ID；业务回调中可选读取。 */
  阶段链ID?: number;
  单位: any;
  数据: Record<string, any>;
  当前阶段索引: number;
}

/** 活动时间线（按单位 handleId → 时间线ID列表，死亡时全部收束） */
const 活动时间线表: Record<number, number[] | undefined> = {};
const 吟唱时间线表: Record<string, number | undefined> = {};
let 死亡监听已注册 = false;

function 单位有效时间线(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 登记活动时间线(this: void, 单位: any, 时间线ID: number): void {
  const 单位ID = GetHandleId(单位);
  let 列表 = 活动时间线表[单位ID];
  if (列表 == null) {
    列表 = [];
    活动时间线表[单位ID] = 列表;
  }
  列表.push(时间线ID);
}

function 移除活动时间线(this: void, 单位: any, 时间线ID: number): void {
  if (!单位有效时间线(单位)) return;
  const 单位ID = GetHandleId(单位);
  const 列表 = 活动时间线表[单位ID];
  if (列表 == null) return;
  const index = 列表.indexOf(时间线ID);
  if (index >= 0) 列表.splice(index, 1);
  if (列表.length <= 0) delete 活动时间线表[单位ID];
}

function 播放时间线阶段表现(this: void, 上下文: 通用技能时间线上下文, 阶段: 技能时间线阶段配置, 清理?: 机制清理篮子): void {
  const 单位 = 上下文.单位;
  if (阶段.硬直秒 != null && 阶段.硬直秒 > 0) GS_Suspend(单位, 阶段.硬直秒);
  if (阶段.音效 != null && 阶段.音效.路径 != null && 阶段.音效.路径 !== "") {
    Sound3DII_UnitPlayReuse(阶段.音效.路径, 单位, 阶段.音效.裁断 ?? 0);
  }
  if (阶段.点特效 != null && 阶段.点特效.模型 != null && 阶段.点特效.模型 !== "") {
    const 点特效 = 创建点特效({
      模型路径: 阶段.点特效.模型,
      X: 阶段.点特效.X ?? GetUnitXSafe(单位),
      Y: 阶段.点特效.Y ?? GetUnitYSafe(单位),
      Z: 阶段.点特效.Z ?? 0,
      缩放: 阶段.点特效.缩放,
      持续秒: 清理 == null ? 阶段.点特效.持续秒 : undefined,
    });
    if (清理 != null && 点特效 != null && 点特效 !== 0) {
      const 持续毫秒 = (阶段.点特效.持续秒 ?? 0) * 1000;
      if (持续毫秒 > 0) 清理.登记限时特效("时间线点特效-" + 上下文.当前阶段索引, 点特效, 持续毫秒);
      else 清理.登记特效("时间线点特效-" + 上下文.当前阶段索引, 点特效);
    }
  }
  if (阶段.单位特效 != null && 阶段.单位特效.模型 != null && 阶段.单位特效.模型 !== "") {
    if (清理 == null) {
      createTimedUnitEffect(单位, 阶段.单位特效.挂点 ?? "origin", 阶段.单位特效.模型, 阶段.单位特效.持续秒);
    } else {
      const effectKey = "时间线-" + (上下文.阶段链ID ?? 上下文.时间线ID) + "-" + 上下文.当前阶段索引;
      const 特效 = createUnitEffect(单位, 阶段.单位特效.挂点 ?? "origin", 阶段.单位特效.模型, undefined, effectKey);
      if (特效 != null && 特效 !== 0) {
        清理.登记清理("时间线单位特效-" + 上下文.当前阶段索引, function 时间线单位特效清理(this: void): void {
          destroyUnitEffect(单位, effectKey);
        });
        if (阶段.单位特效.持续秒 != null && 阶段.单位特效.持续秒 > 0) {
          const 到期ID = addDelayedCallback(阶段.单位特效.持续秒 * 1000, function 时间线单位特效到期(this: void): void {
            destroyUnitEffect(单位, effectKey);
          });
          清理.登记延迟回调("时间线单位特效到期-" + 上下文.当前阶段索引, 到期ID);
        }
      }
    }
  }
}

function 时间线死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (!单位有效时间线(dyingUnit)) return;
  const 列表 = 活动时间线表[GetHandleId(dyingUnit)];
  if (列表 == null) return;
  const 快照 = 列表.slice();
  for (let i = 0; i < 快照.length; i++) 停止技能阶段链(快照[i], "死亡");
}

function 时间线结束回调包装(this: void, 单位: any, 原因: 技能时间线结束原因, 时间线ID: number, 参数: 通用技能时间线参数): void {
  移除活动时间线(单位, 时间线ID);
  if (参数.吟唱条 != null && 吟唱时间线表["常规技能"] === 时间线ID) {
    delete 吟唱时间线表["常规技能"];
    关闭吟唱条("常规技能");
  }
  if (参数.结束回调 != null) 参数.结束回调(单位, 原因, 时间线ID);
}

/**
 * 创建并启动通用技能时间线。
 * @returns 时间线 ID（0 = 启动失败）
 */
export function 创建通用技能时间线(this: void, 参数: 通用技能时间线参数): number {
  if (!单位有效时间线(参数.单位) || 参数.阶段 == null || 参数.阶段.length <= 0) return 0;

  const 阶段列表: 技能阶段定义[] = [];
  for (let i = 0; i < 参数.阶段.length; i++) {
    const 阶段 = 参数.阶段[i];
    阶段列表.push(
      创建延迟执行阶段(
        秒转毫秒(阶段.延迟秒 ?? 0),
        function 时间线阶段执行(this: void, 上下文: any, 控制器: any): void {
          播放时间线阶段表现(上下文 as 通用技能时间线上下文, 阶段, 参数.清理);
          const 数据 = 上下文.数据 as Record<string, any>;
          if (阶段.业务 != null) {
            let 已完成 = false;
            阶段.业务(上下文.单位, 数据, function 完成时间线阶段(this: void): void {
              if (已完成) return;
              已完成 = true;
              控制器.完成当前阶段();
            });
          } else {
            控制器.完成当前阶段();
          }
        },
        阶段.名称,
        阶段.业务 == null,
      ),
    );
  }

  let 已同步结束 = false;
  const 时间线ID = 开始技能阶段链(参数.单位, 阶段列表, {
    数据: 参数.数据 ?? {},
    结束回调: function (this: void, 单位: any, 原因: 技能时间线结束原因, _阶段链ID: number, _上下文: any): void {
      已同步结束 = true;
      时间线结束回调包装(单位, 原因, _阶段链ID, 参数);
    },
  });
  if (时间线ID === 0) return 0;

  if (!已同步结束) 登记活动时间线(参数.单位, 时间线ID);
  if (!已同步结束 && 参数.吟唱条 != null) {
    显示常规技能吟唱条({
      总时长: 参数.吟唱条.总时长,
      标题: 参数.吟唱条.标题 ?? "技能",
      类型: 参数.吟唱条.类型 ?? "常规技能",
    });
    吟唱时间线表["常规技能"] = 时间线ID;
  }
  if (!已同步结束 && 参数.清理 != null) {
    参数.清理.登记清理("时间线-" + 时间线ID, function 通用技能时间线清理(this: void): void {
      停止通用技能时间线(时间线ID, "中断");
    });
  }
  if (!死亡监听已注册) {
    死亡监听已注册 = true;
    registerDeathListener(时间线死亡清理);
  }
  return 时间线ID;
}

/**
 * 主动停止时间线（中断/收尾/目标失效）。幂等：已结束的时间线返回 false。
 */
export function 停止通用技能时间线(this: void, 时间线ID: number, 原因: 技能时间线结束原因 = "中断"): boolean {
  return 停止技能阶段链(时间线ID, 原因);
}
