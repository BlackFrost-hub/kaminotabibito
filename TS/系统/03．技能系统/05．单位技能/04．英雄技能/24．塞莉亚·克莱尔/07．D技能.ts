/** @noSelfInFile */
/**
 * 塞莉亚·克莱尔 - D：术式转写（A6）
 *
 * - 点目标：选择一个已有节点移动到目标点并重算连接。
 *   选择规则（确定且可解释）：取"离目标点最近"的合法节点；平局时取序号更小者。
 * - 转写走容器事务：校验 → R 锁检查 → 关闭旧连接 → 更新位置/特效 → 重算连接 → 解锁；
 *   失败任一步安全收口，不留半条连接。重复 D 无法并发移动同一节点（转写中锁）。
 * - 场上无节点时在塞莉亚脚下创建短寿命临时节点（不造成任何伤害），
 *   使 D 不完全空放，同时参与正常节点/连接生命周期。
 * - 重连落点短闪使用正式 Line 模型表现；真实连线为原生双点连线（容器负责）。
 * - 动作分槽未确认：本技能暂不接动作（缺口见报告）。
 */

import {
  塞莉亚克莱尔技能配置,
  塞莉亚克莱尔D配置,
  塞莉亚克莱尔表现子配置,
} from "./00．配置";
import {
  查询塞莉亚节点,
  转写塞莉亚节点事务,
  创建塞莉亚节点,
  登记塞莉亚技能清理,
} from "./02．被动效果";

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 单位存活, 距离平方XY } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
  距离平方XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, u: any, 来源: string) => boolean;
  移除单位暂停: (this: void, u: any, 来源: string) => boolean;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};

const 英雄单位类型ID = 塞莉亚克莱尔技能配置.单位类型ID;
const D硬直来源 = "塞莉亚-D硬直";

//=============================================================================
// 选择与执行
//=============================================================================

/** 确定性选择：距目标点最近的合法节点；同距取序号小者。 */
function 选择最近合法节点(
  this: void,
  列表: { 序号: number; X: number; Y: number }[],
  目标X: number,
  目标Y: number,
): { 序号: number; X: number; Y: number } | null {
  let 最佳: { 序号: number; X: number; Y: number } | null = null;
  let 最佳平方 = Number.MAX_SAFE_INTEGER;
  for (let i = 0; i < 列表.length; i++) {
    const 节点 = 列表[i];
    const 平方 = 距离平方XY(目标X, 目标Y, 节点.X, 节点.Y);
    if (平方 < 最佳平方 || (平方 === 最佳平方 && 最佳 != null && 节点.序号 < 最佳.序号)) {
      最佳平方 = 平方;
      最佳 = 节点;
    }
  }
  return 最佳;
}

function 释放D术式转写(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) return;

  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 硬直来源 = D硬直来源;

  // 无节点兜底：在脚下创建短寿命临时节点（不伤害），本次转写随之完成
  addDelayedCallback(塞莉亚克莱尔D配置.硬直秒 * 1000, function D执行(this: void): void {
    if (!单位存活(施法者)) return;
    添加单位暂停收尾(施法者, 硬直来源);

    const 列表 = 查询塞莉亚节点(施法者);
    if (列表.length <= 0) {
      // 兜底分支：短寿命临时节点（存续读 D 配置，不占普通节点的 20 秒周期）
      创建塞莉亚节点(施法者, "棱晶", GetUnitX(施法者), GetUnitY(施法者), 技能实例ID, 塞莉亚克莱尔D配置.临时节点存续毫秒);
      return;
    }

    const 目标节点 = 选择最近合法节点(列表, 目标X, 目标Y);
    if (目标节点 == null) return;
    const 成功 = 转写塞莉亚节点事务(施法者, 目标节点.序号, 目标X, 目标Y);
    if (!成功) {
      // R 锁定或并发冲突：安全回滚（什么都不改）
      return;
    }
    // 新位置短闪表现
    const 落点闪现 = 创建点特效({
      模型路径: 塞莉亚克莱尔表现子配置.D重连落点闪现.模型路径,
      X: 目标X,
      Y: 目标Y,
      Z: 塞莉亚克莱尔表现子配置.D重连落点闪现.高度,
      缩放: 塞莉亚克莱尔表现子配置.D重连落点闪现.缩放,
      持续秒: 塞莉亚克莱尔表现子配置.D重连落点闪现.持续秒,
    });
    void 落点闪现;
  });

  // 时序：先暂停，保证后续位移前的姿态一致（动作分槽未确认：缺口）
  添加单位暂停(施法者, 硬直来源);
  const 注销守卫 = 登记塞莉亚技能清理(施法者, "D硬直-" + (技能实例ID ?? 0), function D硬直清理(this: void): void {
    移除单位暂停(施法者, 硬直来源);
  });
  void 注销守卫;
}

function 添加单位暂停收尾(this: void, 施法者: any, 来源: string): void {
  移除单位暂停(施法者, 来源);
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册塞莉亚D(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "塞莉亚·克莱尔-术式转写（D）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 塞莉亚克莱尔技能配置.D.技能ID,
    获取或创建上下文: function D上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放D术式转写,
    创建独立技能实例: false,
  });
}

export {};
