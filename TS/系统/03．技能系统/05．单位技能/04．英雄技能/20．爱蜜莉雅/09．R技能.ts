/** @noSelfInFile */
/**
 * 爱蜜莉雅 - R：永冻之庭（A8，R002.2 修正）
 *
 * - 蓄力使用通用"施法·蓄力·充能"模板（06．施法·蓄力·充能/充能系统）：
 *   指令中断 / 硬控制中断 / 死亡中断 / 世界坐标进度 UI 倒计时与销毁均由充能系统处理，
 *   蓄力被硬控或下达其他指令时真正中断，不再生成领域。
 * - 领域：真实持续区域（周期伤害/寒意/减速），视觉半径不作为判定依据。
 * - 冰晶读取：按创建顺序有限读取（配置上限），连接光用项目通用闪电 code（BLSB），
 *   每枚冰晶延迟爆发并移除节点；爆发延迟回调登记到 R 实例（打断/死亡一并移除）。
 * - 最终冰爆：领域结束/打断/死亡时清理法阵、冰环、连接光、冰晶锁与计时器；
 *   结束结算使用结束时点的实时单位快照（刚进入结算、已离开不结算）。
 * - D 强化 R：消耗剩余强化资源并结束 D；领域半径与最终伤害提升。
 */

import { 爱蜜莉雅技能配置, 爱蜜莉雅R配置, 爱蜜莉雅读条配置, 爱蜜莉雅表现配置, 爱蜜莉雅音效配置 } from "./00．配置";
import { 创建战斗技能实例 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/27．战斗技能实例生命周期工厂";
import { 播放爱蜜莉雅动作, 查询爱蜜莉雅冰晶, 移除爱蜜莉雅冰晶 } from "./02．公共状态与冰晶";
import { 爱蜜莉雅动作槽 } from "./00．配置";
import { 标记目标在爱蜜莉雅区域, 取消标记目标在爱蜜莉雅区域 } from "./04．普攻联动";
import { 结束爱蜜莉雅D } from "./08．D技能";

const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string, 伊蕾娜变式?: string) => boolean;
};

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
const { 开始充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, 单位: any, 参数: any) => number;
};
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
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
  /** 实例结束原因（H-01 收束时写入；null=区域自然到期 → 可结算最终冰爆；打断/死亡 → 只清理不结算） */
  结束原因: string | null;
  半径: number;
  最终伤害: number;
}

/** 结束时点实时快照：按中心+半径枚举当前敌人（刚进入结算、已离开不结算） */
function R取实时区域敌人(this: void, 施法者: any, X: number, Y: number, 半径: number): any[] {
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

/** 蓄力完成：创建领域 + 冰晶读取 + D 强化结算（由充能系统 充能完成回调 调用） */
function R创建领域(
  this: void,
  施法者: any,
  技能实例ID: number | undefined,
  中心X: number,
  中心Y: number,
  半径: number,
  最终伤害: number,
  有强化: boolean,
  来源键: string,
): void {
  if (!单位存活(施法者)) return;
  if (有强化) {
    while (消费爱蜜莉雅D强化(施法者)) {
      // 消耗全部剩余强化
    }
    结束爱蜜莉雅D(施法者);
  }

  const 数据: R领域数据 = { 区域: null, 连接光: [], 已结束: false, 结束原因: null, 半径, 最终伤害 };
  const 控制器 = 创建战斗技能实例({
    技能键: "R领域",
    施法者,
    技能实例ID,
    数据,
    结束回调: function R结束(this: void, 原因: string, _c: any): void {
      // 记录结束原因（on销毁 据此区分自然结束 vs 打断/死亡）
      数据.结束原因 = 原因;
      R清理连接光(数据);
      if (数据.区域 != null) {
        数据.区域.销毁();
        数据.区域 = null;
      }
    },
  });

  const 区域 = 创建持续危险区域({
    X: 中心X,
    Y: 中心Y,
    半径,
    持续时间: 爱蜜莉雅R配置.持续秒,
    影响目标: "敌方",
    所有者: 施法者,
    首次扫描触发进入: true,
    防抖间隔: 0,
    on进入: function R目标进入(this: void, 单位: any): void {
      标记目标在爱蜜莉雅区域(单位);
      施加快速减速Buff(施法者, 单位, 0, 爱蜜莉雅R配置.减速百分比, 爱蜜莉雅R配置.周期秒, "爱蜜莉雅-R", "技能");
    },
    on离开: function R目标离开(this: void, 单位: any): void {
      取消标记目标在爱蜜莉雅区域(单位);
    },
    on周期: function R周期(this: void, 区域内单位: any[]): void {
      R区域内结算(施法者, 区域内单位, 技能实例ID, 读取单位攻击力(施法者) * 爱蜜莉雅R配置.周期伤害攻击力倍率);
    },
    on销毁: function R区域销毁(this: void): void {
      // 先逐个取消区域标记：底层销毁只调 on销毁 后直接清空集合、不触发 on离开
      const 残留单位 = 区域.区域效果.当前区域内单位;
      for (let i = 0; i < 残留单位.length; i++) 取消标记目标在爱蜜莉雅区域(残留单位[i]);
      R清理连接光(数据);
      数据.区域 = null;
      // 打断/死亡（H-01 收束触发销毁）：只清理不结算最终冰爆
      if (数据.结束原因 != null) return;
      if (数据.已结束) return;
      数据.已结束 = true;
      // 最终冰爆：结束时点实时快照（刚进入结算、已离开不结算）
      const 区域内单位 = R取实时区域敌人(施法者, 中心X, 中心Y, 半径);
      R区域内结算(施法者, 区域内单位, 技能实例ID, 数据.最终伤害);
      创建点特效({
        模型路径: 爱蜜莉雅表现配置.最终冰爆.模型路径,
        RGB: 爱蜜莉雅表现配置.最终冰爆.RGB,
        X: 中心X,
        Y: 中心Y,
        Z: 爱蜜莉雅表现配置.最终冰爆.高度,
        缩放: 半径 / 爱蜜莉雅表现配置.最终冰爆.基准半径 * 爱蜜莉雅表现配置.最终冰爆.基准缩放,
        持续秒: 爱蜜莉雅表现配置.最终冰爆.持续秒,
      });
      // 最终冰爆音：仅自然结束结算点一次（打断/死亡收束在上方已提前返回不播；坐标=结算点=领域中心，参数配置驱动）
      Sound3DII_CooPlayReuse(爱蜜莉雅音效配置.R最终.路径, 中心X, 中心Y, 爱蜜莉雅音效配置.R最终.高度, 爱蜜莉雅音效配置.R最终.裁断距离);
      控制器.完成();
    },
  });
  数据.区域 = 区域;

  // ===== r_field 持续层（计划第 7 节方案 2：按配置真实时长周期重播；项目 3D 封装为非循环单发） =====
  // 重播间隔 = 爱蜜莉雅音效配置.R领域.持续秒 × 1000（emilia_r_field 真实音频时长 3.0s）；
  // 播放锚点 = 领域固定中心（中心X/中心Y，本领域区域不跟随施法者）。
  // 停止条件（统一收束，幂等）：
  //   1) R 实例收束（自然结束 完成 / 中断 / 施法者死亡 / 战斗结束 / 手动清理）→
  //      实例清理篮子执行 "R领域音效重播" 自定义清理，移除挂起的重播计时器；
  //   2) 重播回调自检：实例已收束（数据.已结束 / 数据.结束原因）或施法者已死亡 → 不再续播。
  // 禁止按技能 tick/每帧播放；领域销毁后不得继续响。
  Sound3DII_CooPlayReuse(爱蜜莉雅音效配置.R领域.路径, 中心X, 中心Y, 爱蜜莉雅音效配置.R领域.高度, 爱蜜莉雅音效配置.R领域.裁断距离);
  let 领域音效回调ID = 0;
  const 领域音效重播间隔毫秒 = 爱蜜莉雅音效配置.R领域.持续秒 * 1000;
  function 排程领域音效重播(this: void): void {
    if (数据.已结束 || 数据.结束原因 != null) return;
    领域音效回调ID = addDelayedCallback(领域音效重播间隔毫秒, function R领域音效重播(this: void): void {
      领域音效回调ID = 0;
      // 停止条件自检：领域已收束（自然结束/打断/死亡）则不再续播
      if (数据.已结束 || 数据.结束原因 != null || !单位存活(施法者)) return;
      Sound3DII_CooPlayReuse(爱蜜莉雅音效配置.R领域.路径, 中心X, 中心Y, 爱蜜莉雅音效配置.R领域.高度, 爱蜜莉雅音效配置.R领域.裁断距离);
      排程领域音效重播();
    });
  }
  // 重播计时器登记到 R 实例生命周期：所有收束原因统一经 实例清理篮子 移除挂起计时器（含英雄死亡/重复施法收旧）
  控制器.登记自定义清理("R领域音效重播", function R领域音效停止(this: void): void {
    if (领域音效回调ID !== 0) {
      removeDelayedCallback(领域音效回调ID);
      领域音效回调ID = 0;
    }
  });
  排程领域音效重播();

  // 领域主体表现（常驻句柄，生命周期由实例清理统一管理：自然到期随收束销毁，打断/死亡提前销毁；不传持续秒避免 EC_CreateEffect 内置定时器与 DestroyEffect 双销毁）
  const 领域主体特效 = 创建点特效({
    模型路径: 爱蜜莉雅表现配置.领域主体.模型路径,
    RGB: 爱蜜莉雅表现配置.领域主体.RGB,
    X: 中心X,
    Y: 中心Y,
    Z: 爱蜜莉雅表现配置.领域主体.高度,
    缩放: 半径 / 爱蜜莉雅表现配置.领域主体.基准半径 * 爱蜜莉雅表现配置.领域主体.基准缩放,
    持续秒: 爱蜜莉雅表现配置.领域主体.持续秒,
  });
  if (领域主体特效 != null && 领域主体特效 !== 0) {
    控制器.登记自定义清理("R领域主体", function R领域主体清理(this: void): void {
      jass.DestroyEffect(领域主体特效);
    });
  }

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
    // 登记到 R 实例：R 被打断/死亡/提前清理时，延迟爆发回调一并移除（不再结算伤害与特效）
    const 爆发ID = addDelayedCallback(爆发延迟 * 1000, function R冰晶爆发(this: void): void {
      const 移除结果 = 移除爱蜜莉雅冰晶(施法者, 序号);
      if (移除结果 != null) {
        创建点特效({
          模型路径: 爱蜜莉雅表现配置.冰晶读取爆发.模型路径,
          RGB: 爱蜜莉雅表现配置.冰晶读取爆发.RGB,
          X: 移除结果.X,
          Y: 移除结果.Y,
          Z: 爱蜜莉雅表现配置.冰晶读取爆发.高度,
          缩放: 爱蜜莉雅表现配置.冰晶读取爆发.缩放,
          持续秒: 爱蜜莉雅表现配置.冰晶读取爆发.持续秒,
        });
        // 冰晶爆发伤害（冰晶点小范围实时快照）
        const 目标列表 = R取实时区域敌人(施法者, 移除结果.X, 移除结果.Y, 180);
        造成批量AOE技能伤害({
          来源: 施法者,
          目标列表,
          伤害: 读取单位攻击力(施法者) * 爱蜜莉雅R配置.冰晶爆发伤害攻击力倍率,
          伤害类型: DAMAGE_TYPE_COLD,
          来源类型: "单位技能",
          技能ID: R技能类型ID,
          技能实例ID,
          标签: "爱蜜莉雅-R冰晶爆发",
          参与技能伤害加成: true,
        });
        // 冰晶爆发音（规划复用 q_hit；每枚冰晶独立爆发各播一次，坐标=冰晶点）
        Sound3DII_CooPlayReuse(爱蜜莉雅音效配置.Q命中.路径, 移除结果.X, 移除结果.Y, 爱蜜莉雅音效配置.Q命中.高度, 爱蜜莉雅音效配置.Q命中.裁断距离);
      }
      // 销毁该连接光
      if (数据.连接光.length > 0) {
        const 光 = 数据.连接光[0];
        数据.连接光.splice(0, 1);
        if (光 != null && 光 !== 0) DestroyLightning(光);
      }
    });
    控制器.登记延迟回调(爆发ID);
  }
  void 来源键;
}

function 释放R永冻之庭(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0) return;
  播放爱蜜莉雅动作(施法者, 爱蜜莉雅动作槽.R);
  const 中心X = GetSpellTargetX();
  const 中心Y = GetSpellTargetY();
  const 攻击力 = 读取单位攻击力(施法者);

  // D 强化：蓄力完成后生效（消耗剩余强化资源并结束 D）
  const D状态 = 获取爱蜜莉雅D强化(施法者);
  const 有强化 = D状态 != null && D状态.剩余次数 > 0;
  const 半径 = 有强化 ? 爱蜜莉雅R配置.半径 * 爱蜜莉雅R配置.强化半径倍率 : 爱蜜莉雅R配置.半径;
  const 最终伤害 = 有强化
    ? 攻击力 * 爱蜜莉雅R配置.强化最终冰爆伤害攻击力倍率
    : 攻击力 * 爱蜜莉雅R配置.最终冰爆伤害攻击力倍率;
  const 来源键 = "R:" + (技能实例ID ?? 0);

  // 蓄力：通用充能系统（指令中断 / 硬控中断 / 死亡中断 / 世界坐标进度 UI 倒计时与销毁）
  let 法阵特效: any = null;
  开始充能(施法者, {
    持续时间: 爱蜜莉雅R配置.蓄力秒,
    指令中断: true,
    世界坐标进度UI: true,
    世界坐标进度UI类型: 爱蜜莉雅读条配置.UI类型,
    世界坐标进度UI标题: "永冻之庭",
    世界坐标进度UI数值后缀: "",
    世界坐标进度UI高度偏移: 爱蜜莉雅读条配置.跟随Z偏移,
    显示进度条特效: false,
    // 蓄力预警法阵（一次）
    开始回调: function R蓄力开始(this: void, _单位: any, _充能ID: number): void {
      播放英雄技能喊话(施法者, "爱蜜莉雅", 爱蜜莉雅技能配置.R.技能ID);
      法阵特效 = 创建点特效({
        模型路径: 爱蜜莉雅表现配置.蓄力法阵.模型路径,
        RGB: 爱蜜莉雅表现配置.蓄力法阵.RGB,
        X: 中心X,
        Y: 中心Y,
        Z: 爱蜜莉雅表现配置.蓄力法阵.高度,
        缩放: 半径 / 爱蜜莉雅表现配置.蓄力法阵.基准半径 * 爱蜜莉雅表现配置.蓄力法阵.基准缩放,
        持续秒: 爱蜜莉雅表现配置.蓄力法阵.持续秒,
      });
      // 蓄力法阵展开音：充能成功建立、法阵展开时一次（被打断/死亡不会先播法阵音以外的领域音；坐标=领域中心，参数配置驱动）
      Sound3DII_CooPlayReuse(爱蜜莉雅音效配置.R蓄力.路径, 中心X, 中心Y, 爱蜜莉雅音效配置.R蓄力.高度, 爱蜜莉雅音效配置.R蓄力.裁断距离);
    },
    // 蓄力结束（完成/被打断/死亡统一销毁常驻法阵；充能系统结束回调对任意原因都会调用）
    结束回调: function R蓄力结束(this: void, _单位: any, _原因: string, _充能ID: number): void {
      if (法阵特效 != null && 法阵特效 !== 0) {
        jass.DestroyEffect(法阵特效);
        法阵特效 = null;
      }
    },
    // 蓄力完成：创建领域（被打断/死亡不会走到这里）
    充能完成回调: function R蓄力完成(this: void, _单位: any, _充能ID: number): void {
      R创建领域(施法者, 技能实例ID, 中心X, 中心Y, 半径, 最终伤害, 有强化, 来源键);
    },
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
