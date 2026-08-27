/** @noSelfInFile */
/**
 * 爱蜜莉雅 - W：冰花绽放（A5）
 *
 * - 目标点创建冰花 + 真实减速区域（视觉范围不代替判定；判定由持续危险区域承载）。
 * - 持续期间按配置周期结算（伤害/寒意/减速），不每 tick 重建完整特效。
 * - 二段：窗口内再次按 W 锁定方向引爆冰花（扇形冰片 + 引爆伤害），窗口结束后再次按 W 创建新区域。
 * - 自然结束 / 主动引爆 / 打断 / 死亡走可区分的收尾路径（H-01 实例统一收束）。
 */

import { 爱蜜莉雅技能配置, 爱蜜莉雅W配置, 爱蜜莉雅被动配置 } from "./00．配置";
import { 创建战斗技能实例, 查询战斗技能实例 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/27．战斗技能实例生命周期工厂";
import { 播放爱蜜莉雅动作 } from "./02．公共状态与冰晶";
import { 爱蜜莉雅动作槽 } from "./00．配置";
import { 标记目标在爱蜜莉雅区域, 取消标记目标在爱蜜莉雅区域 } from "./04．普攻联动";

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;

const { 创建持续危险区域 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域") as {
  创建持续危险区域: (this: void, 参数: any) => any;
};
const { 施加快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速减速Buff: (this: void, source: any, target: any, as: number, ms: number, time: number, sourceName?: string, sourceType?: "装备" | "技能", displayBuffID?: string) => void;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, 参数: any) => number;
};
const { 发射弹道 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂") as {
  发射弹道: (this: void, 参数: any) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 读取单位攻击力, 两点角度, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { 创建限时二段技能壳, 确认限时二段技能壳, 清理限时二段技能壳, 通用二段技能壳ID } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.25．限时二段技能壳") as {
  创建限时二段技能壳: (this: void, 参数: any) => any;
  确认限时二段技能壳: (this: void, 控制器: any) => boolean;
  清理限时二段技能壳: (this: void, 控制器: any) => boolean;
  通用二段技能壳ID: any;
};
const { 创建爱蜜莉雅场上冰晶 } = require("./03．被动效果") as {
  创建爱蜜莉雅场上冰晶: (this: void, 英雄: any, 来源技能: any, X: number, Y: number, 持续秒: number) => any;
};
const { 消费爱蜜莉雅D强化 } = require("./02．公共状态与冰晶") as {
  消费爱蜜莉雅D强化: (this: void, 英雄: any) => boolean;
};

const 英雄单位类型ID = jass.FourCC(爱蜜莉雅技能配置.单位类型ID) as number;
const W技能类型ID = jass.FourCC(爱蜜莉雅技能配置.W.技能ID) as number;

interface W冰花数据 {
  区域: any;
  目标X: number;
  目标Y: number;
  已二段: boolean;
  /** 二段输入壳控制器（25．限时二段技能壳；二段窗口切换按钮） */
  二段壳: any;
  /** 实例结束原因（H-01 收束时写入；null=区域自然到期 → 可结算自然结束；打断/死亡 → 只清理不结算） */
  结束原因: string | null;
}

/** 结束时点实时快照：按目标点+半径枚举当前敌人（刚进入结算、已离开不结算） */
function W取实时区域敌人(this: void, 施法者: any, X: number, Y: number, 半径: number): any[] {
  const 结果: any[] = [];
  const 组 = jass.CreateGroup() as any;
  jass.GroupEnumUnitsInRange(组, X, Y, 半径, null);
  while (true) {
    const u = jass.FirstOfGroup(组) as any;
    if (u == null || u === 0) break;
    jass.GroupRemoveUnit(组, u);
    if (u === 施法者 || !单位存活(u)) continue;
    if (!jass.IsUnitEnemy(u, jass.GetOwningPlayer(施法者))) continue;
    结果.push(u);
  }
  jass.DestroyGroup(组);
  return 结果;
}

function W区域内目标结算(this: void, 施法者: any, 区域内单位: any[], 技能实例ID: number | undefined, 伤害值: number, 施加寒意: boolean): void {
  if (区域内单位 == null || 区域内单位.length <= 0) return;
  const 目标列表: any[] = [];
  for (let i = 0; i < 区域内单位.length; i++) 目标列表.push(区域内单位[i]);
  造成批量AOE技能伤害({
    来源: 施法者,
    目标列表,
    伤害: 伤害值,
    伤害类型: DAMAGE_TYPE_COLD,
    来源类型: "单位技能",
    技能ID: W技能类型ID,
    技能实例ID,
    标签: "爱蜜莉雅-W冰花",
    参与技能伤害加成: true,
  });
  if (施加寒意) {
    for (let i = 0; i < 目标列表.length; i++) {
      施加W寒意(施法者, 目标列表[i], 技能实例ID);
    }
  }
}

// 避免循环依赖：寒意由 03 被动提供；此处直接引入函数引用
const { 施加爱蜜莉雅寒意 } = require("./03．被动效果") as {
  施加爱蜜莉雅寒意: (this: void, 施法者: any, 目标: any, 来源键: string) => boolean;
};

function 施加W寒意(this: void, 施法者: any, 目标: any, 技能实例ID: number | undefined): void {
  施加爱蜜莉雅寒意(施法者, 目标, "W:" + (技能实例ID ?? 0));
}

function 二段引爆W(this: void, 施法者: any, 控制器: any, 技能实例ID: number | undefined): void {
  const 数据 = 控制器.数据 as W冰花数据;
  if (数据 == null || 数据.已二段) return;
  数据.已二段 = true;
  // ASW2 为瞬发输入壳无目标点（GetSpellTargetX/Y 为无效坐标）→ 扇形方向取英雄当前朝向
  // 弹道编排工厂 发射方向角 为 GetUnitFacing 角度制（0-360），直接透传不做弧度换算
  const 方向 = jass.GetUnitFacing(施法者);
  const 伤害 = 读取单位攻击力(施法者) * 爱蜜莉雅W配置.二段伤害攻击力倍率;
  const 冰片伤害 = 读取单位攻击力(施法者) * 爱蜜莉雅W配置.冰片伤害攻击力倍率;
  // 引爆伤害（结束时点实时快照）
  const 区域内单位 = W取实时区域敌人(施法者, 数据.目标X, 数据.目标Y, 爱蜜莉雅W配置.半径);
  W区域内目标结算(施法者, 区域内单位, 技能实例ID, 伤害, true);
  // 标记取消统一由 on销毁 处理（二段引爆随后立即销毁区域 → on销毁 对残留单位取消一次），此处不重复取消，避免重叠区域多扣层
  // D 强化：二段引爆后保留一枚小冰晶
  if (消费爱蜜莉雅D强化(施法者)) {
    创建爱蜜莉雅场上冰晶(施法者, "D强化", 数据.目标X, 数据.目标Y, 爱蜜莉雅W配置.D强化冰晶持续秒);
  }
  // 关闭二段输入壳（按钮恢复一段）
  if (数据.二段壳 != null) 确认限时二段技能壳(数据.二段壳);
  // 扇形冰片弹幕
  const 数量 = 爱蜜莉雅W配置.冰片数量;
  for (let i = 0; i < 数量; i++) {
    const 偏移 = (i - (数量 - 1) / 2) * 12;
    发射弹道({
      名称: "爱蜜莉雅-W冰片",
      所有者: 施法者,
      发射X: 数据.目标X,
      发射Y: 数据.目标Y,
      发射方向角: 方向 + 偏移,
      速度: 爱蜜莉雅W配置.冰片速度,
      轨迹: { 类型: "直线", 距离: 500 },
      命中半径: 80,
      影响目标: "敌方",
      碰撞消失: true,
      每单位最大命中次数: 1,
      伤害值: 冰片伤害,
      伤害类型: DAMAGE_TYPE_COLD,
      来源类型: "单位技能",
      技能ID: W技能类型ID,
      技能实例ID,
      技能标签: "爱蜜莉雅-W冰片",
      伤害形态: "单体",
      参与技能伤害加成: true,
      模型: 爱蜜莉雅W配置.冰片模型,
      缩放: 爱蜜莉雅W配置.表现.冰片.缩放,
    });
  }
  // 收束区域（销毁触发 on销毁，不再结算自然结束伤害）
  数据.区域.销毁();
  控制器.完成();
}

function 释放W冰花(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0) return;
  播放爱蜜莉雅动作(施法者, 爱蜜莉雅动作槽.W);
  // 二段：已有活跃 W 且未二段
  const 活跃列表 = 查询战斗技能实例(施法者, "W冰花");
  for (let i = 0; i < 活跃列表.length; i++) {
    const 活跃 = 活跃列表[i];
    const 数据 = 活跃.数据 as W冰花数据;
    if (数据 != null && !数据.已二段) {
      二段引爆W(施法者, 活跃, 技能实例ID);
      return;
    }
  }

  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 数据: W冰花数据 = { 区域: null, 目标X, 目标Y, 已二段: false, 二段壳: null, 结束原因: null };
  const 控制器 = 创建战斗技能实例({
    技能键: "W冰花",
    施法者,
    技能实例ID,
    数据,
    结束回调: function W结束(this: void, 原因: string, _控制器: any): void {
      // 记录结束原因（on销毁 据此区分自然结束 vs 打断/死亡）
      数据.结束原因 = 原因;
      // 打断/死亡：销毁区域且不结算自然结束伤害
      if (数据.区域 != null) {
        数据.区域.销毁();
        数据.区域 = null;
      }
    },
  });

  const 区域 = 创建持续危险区域({
    X: 目标X,
    Y: 目标Y,
    半径: 爱蜜莉雅W配置.半径,
    持续时间: 爱蜜莉雅W配置.持续秒,
    影响目标: "敌方",
    所有者: 施法者,
    首次扫描触发进入: true,
    防抖间隔: 0,
    on进入: function W目标进入(this: void, 单位: any): void {
      标记目标在爱蜜莉雅区域(单位);
      施加快速减速Buff(施法者, 单位, 0, 爱蜜莉雅W配置.减速百分比, 爱蜜莉雅W配置.周期秒, "爱蜜莉雅-W", "技能");
    },
    on离开: function W目标离开(this: void, 单位: any): void {
      取消标记目标在爱蜜莉雅区域(单位);
    },
    on周期: function W周期(this: void, 区域内单位: any[]): void {
      // 周期寒意（配置开启时）
      if (爱蜜莉雅W配置.周期施加寒意) {
        for (let i = 0; i < 区域内单位.length; i++) 施加W寒意(施法者, 区域内单位[i], 技能实例ID);
      }
    },
    on销毁: function W区域销毁(this: void): void {
      // 二段壳兜底关闭（按钮恢复一段）
      if (数据.二段壳 != null) 清理限时二段技能壳(数据.二段壳);
      // 先逐个取消区域标记：底层销毁只调 on销毁 后直接清空集合、不触发 on离开（打断/死亡也必须取消，否则计数残留到目标死亡）
      const 残留单位 = 区域.区域效果.当前区域内单位;
      for (let i = 0; i < 残留单位.length; i++) 取消标记目标在爱蜜莉雅区域(残留单位[i]);
      数据.区域 = null;
      // 仅区域自然到期（未被打断/未死亡）才结算自然结束；打断/死亡只清理不结算
      if (!数据.已二段 && 数据.结束原因 == null) {
        const 区域内单位 = W取实时区域敌人(施法者, 数据.目标X, 数据.目标Y, 爱蜜莉雅W配置.半径);
        W区域内目标结算(施法者, 区域内单位, 技能实例ID, 读取单位攻击力(施法者) * 爱蜜莉雅W配置.自然结束伤害攻击力倍率, true);
        // D 强化：自然结束后保留一枚小冰晶
        if (消费爱蜜莉雅D强化(施法者)) {
          创建爱蜜莉雅场上冰晶(施法者, "D强化", 数据.目标X, 数据.目标Y, 爱蜜莉雅W配置.D强化冰晶持续秒);
        }
        控制器.完成();
      } else {
        数据.区域 = null;
      }
    },
  });
  数据.区域 = 区域;

  // 创建时伤害（规划 4.3：创建时造成一次范围伤害并施加寒意）：
  // 区域创建后首个结算周期前延迟 0.25s 结算一次；被打断/死亡时随实例清理（不再结算）
  const 创建伤害延迟 = addDelayedCallback(250, function W创建伤害(this: void): void {
    if (数据.已二段) return;
    const 区域当前 = W取实时区域敌人(施法者, 数据.目标X, 数据.目标Y, 爱蜜莉雅W配置.半径);
    W区域内目标结算(施法者, 区域当前, 技能实例ID, 读取单位攻击力(施法者) * 爱蜜莉雅W配置.创建伤害攻击力倍率, true);
  });
  控制器.登记延迟回调(创建伤害延迟);

  // 二段输入壳：W 持续期间切换 W 按钮为二段输入（ASW2），窗口结束自动恢复
  数据.二段壳 = 创建限时二段技能壳({
    名称: "爱蜜莉雅-W二段",
    单位: 施法者,
    一段技能ID: W技能类型ID,
    二段技能ID: jass.FourCC(爱蜜莉雅W配置.二段技能ID),
    持续秒: 爱蜜莉雅W配置.持续秒,
  });

  // 冰花 + 寒气边界表现（常驻句柄，生命周期由实例清理统一管理：自然到期随收束销毁，打断/死亡提前销毁；不传持续秒避免 EC_CreateEffect 内置定时器与 DestroyEffect 双销毁）
  const 冰花特效 = 创建点特效({
    模型路径: 爱蜜莉雅W配置.冰花模型,
    X: 目标X,
    Y: 目标Y,
    Z: 爱蜜莉雅W配置.表现.冰花主体.高度,
    缩放: 爱蜜莉雅W配置.表现.冰花主体.缩放,
    持续秒: 爱蜜莉雅W配置.表现.冰花主体.持续秒,
  });
  if (冰花特效 != null && 冰花特效 !== 0) {
    控制器.登记自定义清理("W冰花主体", function W冰花主体清理(this: void): void {
      jass.DestroyEffect(冰花特效);
    });
  }
  const 寒气特效 = 创建点特效({
    模型路径: 爱蜜莉雅W配置.寒气模型,
    X: 目标X,
    Y: 目标Y,
    Z: 爱蜜莉雅W配置.表现.寒气边界.高度,
    缩放: 爱蜜莉雅W配置.半径 / 爱蜜莉雅W配置.表现.寒气边界.基准半径 * 爱蜜莉雅W配置.表现.寒气边界.基准缩放,
    持续秒: 爱蜜莉雅W配置.表现.寒气边界.持续秒,
  });
  if (寒气特效 != null && 寒气特效 !== 0) {
    控制器.登记自定义清理("W寒气主体", function W寒气主体清理(this: void): void {
      jass.DestroyEffect(寒气特效);
    });
  }
}

function 释放W二段输入(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0) return;
  const 活跃列表 = 查询战斗技能实例(施法者, "W冰花");
  for (let i = 0; i < 活跃列表.length; i++) {
    const 活跃 = 活跃列表[i];
    const 数据 = 活跃.数据 as W冰花数据;
    if (数据 != null && !数据.已二段) {
      二段引爆W(施法者, 活跃, 技能实例ID);
      return;
    }
  }
}

export function 注册爱蜜莉雅W(this: void): void {
  注册单位技能壳监听({
    名称: "爱蜜莉雅-冰花绽放（W）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 爱蜜莉雅技能配置.W.技能ID,
    获取或创建上下文: function W上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放W冰花,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 爱蜜莉雅W配置.持续秒 + 1,
  });
  注册单位技能壳监听({
    名称: "爱蜜莉雅-W二段输入（ASW2）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 爱蜜莉雅W配置.二段技能ID,
    获取或创建上下文: function W二段上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放W二段输入,
    创建独立技能实例: false,
  });
}

export {};
