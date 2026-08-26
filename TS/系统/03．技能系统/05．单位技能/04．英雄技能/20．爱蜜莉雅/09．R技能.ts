/** @noSelfInFile */
/**
 * 爱蜜莉雅 - R：永冻之庭（A8）
 *
 * - 蓄力（世界坐标进度 UI，跟随施法者，登记 A1 进度 UI）后创建大范围冰结领域。
 * - 领域：真实持续区域（周期伤害/寒意/减速），视觉半径不作为判定依据。
 * - 冰晶读取：按创建顺序有限读取（配置上限），连接光用项目通用闪电 code（BLSB），
 *   每枚冰晶延迟爆发并移除节点；无前置冰晶时仍有基础效果。
 * - 最终冰爆：领域结束/打断/死亡时清理法阵、冰环、连接光、冰晶锁与计时器。
 * - D 强化 R：消耗剩余强化资源并结束 D；领域半径与最终伤害提升。
 */

import { 爱蜜莉雅技能配置, 爱蜜莉雅R配置, 爱蜜莉雅读条配置 } from "./00．配置";
import { 创建战斗技能实例 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/27．战斗技能实例生命周期工厂";
import { 登记爱蜜莉雅进度UI, 查询爱蜜莉雅冰晶, 移除爱蜜莉雅冰晶, 播放爱蜜莉雅动作 } from "./02．公共状态与冰晶";
import { 标记目标在爱蜜莉雅区域, 取消标记目标在爱蜜莉雅区域 } from "./04．普攻联动";
import { 结束爱蜜莉雅D } from "./08．D技能";

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const AddLightning = jass.AddLightning as (this: void, codeName: string, checkVisibility: boolean, x1: number, y1: number, x2: number, y2: number) => any;
const DestroyLightning = jass.DestroyLightning as (this: void, lightning: any) => void;
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
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 创建世界坐标进度UI } = require("系统.09．表现系统.15．世界坐标进度UI.01．世界坐标进度UI") as {
  创建世界坐标进度UI: (this: void, 参数: any) => any;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { addDelayedCallback, getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  getGameTime: (this: void) => number;
};
const { 施加爱蜜莉雅寒意 } = require("./03．被动效果") as {
  施加爱蜜莉雅寒意: (this: void, 施法者: any, 目标: any, 来源键: string) => boolean;
};
const { 获取爱蜜莉雅D强化, 消费爱蜜莉雅D强化 } = require("./02．公共状态与冰晶") as {
  获取爱蜜莉雅D强化: (this: void, 英雄: any) => any;
  消费爱蜜莉雅D强化: (this: void, 英雄: any) => boolean;
};

const 英雄单位类型ID = jass.FourCC(爱蜜莉雅技能配置.单位类型ID) as number;
const R技能类型ID = jass.FourCC(爱蜜莉雅技能配置.R.技能ID) as number;

interface R领域数据 {
  区域: any;
  连接光: any[];
  已结束: boolean;
  半径: number;
  最终伤害: number;
}

function R区域内结算(this: void, 施法者: any, 区域内单位: any[], 技能实例ID: number | undefined, 伤害值: number): void {
  if (区域内单位 == null || 区域内单位.length <= 0) return;
  const 目标列表: any[] = [];
  for (let i = 0; i < 区域内单位.length; i++) 目标列表.push(区域内单位[i]);
  造成批量AOE技能伤害({
    来源: 施法者,
    目标列表,
    伤害: 伤害值,
    伤害类型: DAMAGE_TYPE_COLD,
    来源类型: "单位技能",
    技能ID: R技能类型ID,
    技能实例ID,
    标签: "爱蜜莉雅-R永冻",
    参与技能伤害加成: true,
  });
  for (let i = 0; i < 目标列表.length; i++) {
    施加爱蜜莉雅寒意(施法者, 目标列表[i], "R:" + (技能实例ID ?? 0));
  }
}

function R清理连接光(this: void, 数据: R领域数据): void {
  while (数据.连接光.length > 0) {
    const 光 = 数据.连接光[0];
    数据.连接光.splice(0, 1);
    if (光 != null && 光 !== 0) DestroyLightning(光);
  }
}

function 释放R永冻之庭(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0) return;
  播放爱蜜莉雅动作(施法者, 爱蜜莉雅R配置.动作索引, 1.2);
  const 中心X = GetSpellTargetX();
  const 中心Y = GetSpellTargetY();
  const 攻击力 = 读取单位攻击力(施法者);

  // D 强化：消耗剩余强化资源并结束 D（蓄力完成后生效）
  const D状态 = 获取爱蜜莉雅D强化(施法者);
  const 有强化 = D状态 != null && D状态.剩余次数 > 0;
  const 半径 = 有强化 ? 爱蜜莉雅R配置.半径 * 爱蜜莉雅R配置.强化半径倍率 : 爱蜜莉雅R配置.半径;
  const 最终伤害 = 有强化
    ? 攻击力 * 爱蜜莉雅R配置.强化最终冰爆伤害攻击力倍率
    : 攻击力 * 爱蜜莉雅R配置.最终冰爆伤害攻击力倍率;
  const 来源键 = "R:" + (技能实例ID ?? 0);
  const 数据: R领域数据 = { 区域: null, 连接光: [], 已结束: false, 半径, 最终伤害 };

  // 蓄力：世界坐标进度 UI（跟随施法者，登记 A1 统一销毁）
  const 进度UI = 创建世界坐标进度UI({
    X: GetUnitX(施法者),
    Y: GetUnitY(施法者),
    Z: 0,
    跟随单位: 施法者,
    跟随Z偏移: 爱蜜莉雅读条配置.跟随Z偏移,
    最大值: 爱蜜莉雅R配置.蓄力秒,
    当前值: 0,
    标题: 爱蜜莉雅R配置.蓄力秒 > 0 ? "永冻之庭" : "",
    类型: 爱蜜莉雅读条配置.UI类型,
  });
  if (进度UI != null) 登记爱蜜莉雅进度UI(施法者, 进度UI);

  // 蓄力预警法阵
  创建点特效({
    模型路径: 爱蜜莉雅R配置.领域模型,
    X: 中心X,
    Y: 中心Y,
    Z: 5,
    缩放: 半径 / 200,
    持续秒: 爱蜜莉雅R配置.蓄力秒 + 0.1,
  });

  addDelayedCallback(爱蜜莉雅R配置.蓄力秒 * 1000, function R蓄力完成(this: void): void {
    if (!单位存活(施法者)) return;
    if (有强化) {
      while (消费爱蜜莉雅D强化(施法者)) {
        // 消耗全部剩余强化
      }
      结束爱蜜莉雅D(施法者);
    }

    const 控制器 = 创建战斗技能实例({
      技能键: "R领域",
      施法者,
      技能实例ID,
      数据,
      结束回调: function R结束(this: void, _原因: string, _c: any): void {
        R清理连接光(数据);
        if (数据.区域 != null) 数据.区域.销毁();
      },
    });

    const 区域 = 创建持续危险区域({
      X: 中心X,
      Y: 中心Y,
      半径,
      持续时间: 爱蜜莉雅R配置.持续秒,
      影响目标: "敌方",
      on进入: function R目标进入(this: void, 单位: any): void {
        标记目标在爱蜜莉雅区域(单位);
        施加快速减速Buff(施法者, 单位, 0, 爱蜜莉雅R配置.减速百分比, 爱蜜莉雅R配置.周期秒, "爱蜜莉雅-R", "技能");
      },
      on离开: function R目标离开(this: void, 单位: any): void {
        取消标记目标在爱蜜莉雅区域(单位);
      },
      on周期: function R周期(this: void, 区域内单位: any[]): void {
        R区域内结算(施法者, 区域内单位, 技能实例ID, 攻击力 * 爱蜜莉雅R配置.周期伤害攻击力倍率);
      },
      on销毁: function R区域销毁(this: void): void {
        if (数据.已结束) return;
        // 最终冰爆：大范围冰封（范围与实际判定一致）
        R清理连接光(数据);
        const 区域内单位 = 区域.区域效果.当前区域内单位;
        R区域内结算(施法者, 区域内单位, 技能实例ID, 数据.最终伤害);
        for (let i = 0; i < 区域内单位.length; i++) 取消标记目标在爱蜜莉雅区域(区域内单位[i]);
        创建点特效({
          模型路径: 爱蜜莉雅R配置.最终冰爆模型,
          X: 中心X,
          Y: 中心Y,
          Z: 30,
          缩放: 半径 / 200,
          持续秒: 1.6,
        });
        控制器.完成();
      },
    });
    数据.区域 = 区域;
    数据.已结束 = false;

    // 领域主体表现（一套，持续秒自销毁）
    创建点特效({
      模型路径: 爱蜜莉雅R配置.领域模型,
      X: 中心X,
      Y: 中心Y,
      Z: 5,
      缩放: 半径 / 200,
      持续秒: 爱蜜莉雅R配置.持续秒,
    });

    // 冰晶读取：按创建顺序有限读取（配置上限）；跳过失效引用并清除已读取节点
    const 冰晶列表 = 查询爱蜜莉雅冰晶(施法者);
    const 读取上限 = 爱蜜莉雅R配置.冰晶读取上限;
    for (let i = 0; i < 冰晶列表.length && i < 读取上限; i++) {
      const 节点 = 冰晶列表[i];
      // 连接光（真实冰晶端点 → 领域中心）
      const 光 = AddLightning(爱蜜莉雅R配置.闪电代码, false, 节点.X, 节点.Y, 中心X, 中心Y);
      if (光 != null && 光 !== 0) 数据.连接光.push(光);
      const 序号 = 节点.序号;
      const 爆发延迟 = 0.25 + i * 0.2;
      addDelayedCallback(爆发延迟 * 1000, function R冰晶爆发(this: void): void {
        const 移除结果 = 移除爱蜜莉雅冰晶(施法者, 序号);
        if (移除结果 != null) {
          创建点特效({
            模型路径: 爱蜜莉雅R配置.领域模型,
            X: 移除结果.X,
            Y: 移除结果.Y,
            Z: 20,
            缩放: 0.5,
            持续秒: 0.6,
          });
          // 冰晶爆发伤害（冰晶点小范围）
          const 目标组 = jass.CreateGroup() as any;
          jass.GroupEnumUnitsInRange(目标组, 移除结果.X, 移除结果.Y, 180, null);
          const 目标列表: any[] = [];
          while (true) {
            const u = jass.FirstOfGroup(目标组) as any;
            if (u == null || u === 0) break;
            jass.GroupRemoveUnit(目标组, u);
            if (u !== 施法者 && 单位存活(u) && jass.IsUnitEnemy(u, jass.GetOwningPlayer(施法者))) 目标列表.push(u);
          }
          jass.DestroyGroup(目标组);
          造成批量AOE技能伤害({
            来源: 施法者,
            目标列表,
            伤害: 攻击力 * 爱蜜莉雅R配置.冰晶爆发伤害攻击力倍率,
            伤害类型: DAMAGE_TYPE_COLD,
            来源类型: "单位技能",
            技能ID: R技能类型ID,
            技能实例ID,
            标签: "爱蜜莉雅-R冰晶爆发",
            参与技能伤害加成: true,
          });
        }
        // 销毁该连接光
        if (数据.连接光.length > 0) {
          const 光 = 数据.连接光[0];
          数据.连接光.splice(0, 1);
          if (光 != null && 光 !== 0) DestroyLightning(光);
        }
        void 来源键;
      });
    }
    void 来源键;
  });
}

export function 注册爱蜜莉雅R(this: void): void {
  注册单位技能壳监听({
    名称: "爱蜜莉雅-永冻之庭（R）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 爱蜜莉雅技能配置.R.技能ID,
    获取或创建上下文: function R上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放R永冻之庭,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 爱蜜莉雅R配置.蓄力秒 + 爱蜜莉雅R配置.持续秒 + 2,
  });
}

export {};
