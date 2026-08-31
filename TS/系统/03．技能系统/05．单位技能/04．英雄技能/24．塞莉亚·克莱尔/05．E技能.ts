/** @noSelfInFile */
/**
 * 塞莉亚·克莱尔 - E：锚定魔法阵（A5）
 *
 * - 点目标施法：t0 快照中心/半径/延迟/实例；预警范围、真实区域与配置一致。
 * - 生效点：范围实时枚举敌方 → 一次魔法伤害 + 减速；随后阵内存续期间
 *   目标停留达到阈值触发一次定身强化控制（每目标每阵仅一次），离开/死亡立即清除记录。
 * - 区域创建时传所有者且只影响敌方；目标一律结算时实时枚举，不使用过期单位列表。
 * - 打断/死亡只取消周期与表现，不产生任何结束爆发。
 * - 锚定节点在生效点由被动容器创建并参与连接。
 */

import {
  塞莉亚克莱尔技能配置,
  塞莉亚克莱尔E配置,
  塞莉亚克莱尔表现配置,
  塞莉亚音效配置,
} from "./00．配置";
import { 塞莉亚BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/24．塞莉亚·克莱尔";
import {
  创建塞莉亚节点,
  授予塞莉亚演算窗口,
  登记塞莉亚技能清理,
  标记目标在塞莉亚E区域,
  取消标记目标在塞莉亚E区域,
  目标在塞莉亚E区域,
} from "./02．被动效果";

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, angle: number) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 创建战斗技能实例 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂") as {
  创建战斗技能实例: (this: void, 参数: any) => any;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const {
  获取坐标范围敌人,
  单位是否敌对,
} = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  /** 注意：公共实现为 (中心来源单位, X, Y, 半径) */
  获取坐标范围敌人: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
  单位是否敌对: (this: void, sourceUnit: any, targetUnit: any) => boolean;
};
const {
  两点角度,
  单位存活,
  取单位ID,
  读取单位攻击力,
} = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  单位存活: (this: void, unit: any) => boolean;
  取单位ID: (this: void, unit: any) => number;
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, u: any, 来源: string) => boolean;
  移除单位暂停: (this: void, u: any, 来源: string) => boolean;
};
const { AOE施加扩展控制, 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  AOE施加扩展控制: (this: void, 来源: any, 中心X: number, 中心Y: number, 半径: number, 类型: string, 持续秒: number) => any[];
  施加扩展控制: (this: void, 来源: any, 目标: any, 类型: string, 持续秒: number) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 创建点特效, 销毁点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  销毁点特效: (this: void, effect: any) => void;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string) => boolean;
};

const 英雄单位类型ID = 塞莉亚克莱尔技能配置.单位类型ID;
const E硬直来源 = "塞莉亚-E硬直";

//=============================================================================
// 区域状态查询（供 Q/A2 只读使用）
//=============================================================================

/** 每名塞莉亚至多一个活跃锚定区域（重复释放收旧建新） */
interface 塞莉亚锚定区域数据 {
  英雄: any;
  X: number;
  Y: number;
  半径: number;
  到期时间: number;
  阵特效: any;
  停留累计毫秒: Record<number, number | undefined>;
  已触发阈值: Record<number, boolean | undefined>;
  /** 上一 tick 阵内单位快照（id → 单位），用于离场时对账 */
  上次内部成员: Record<number, any | undefined>;
  周期ID: number;
  已关闭: boolean;
}

const 塞莉亚锚定区域表: Record<number, 塞莉亚锚定区域数据 | undefined> = {};

export function 查询塞莉亚锚定区域(this: void, 英雄: any): { X: number; Y: number; 半径: number } | null {
  const 数据 = 塞莉亚锚定区域表[取单位ID(英雄)];
  if (数据 == null || getGameTime() >= 数据.到期时间) return null;
  return { X: 数据.X, Y: 数据.Y, 半径: 数据.半径 };
}

/** 锚定区域内最近敌人（Q 追迹分支用；实时校验存活与敌对）。 */
export function 取塞莉亚锚定区域内最近敌人(this: void, 来源: any, X: number, Y: number, 半径: number): any {
  const 列表 = 获取坐标范围敌人(来源, X, Y, 半径);
  let 最近: any = null;
  let 最近平方 = 半径 * 半径;
  for (let i = 0; i < 列表.length; i++) {
    const 敌人 = 列表[i];
    if (!单位存活(敌人)) continue;
    if (!单位是否敌对(来源, 敌人)) continue;
    const dx = GetUnitX(敌人) - X;
    const dy = GetUnitY(敌人) - Y;
    const 平方 = dx * dx + dy * dy;
    if (平方 <= 最近平方) {
      最近平方 = 平方;
      最近 = 敌人;
    }
  }
  return 最近;
}

function 关闭锚定区域(数据: 塞莉亚锚定区域数据): void {
  if (数据.已关闭) return;
  数据.已关闭 = true;
  数据.到期时间 = 0; // 周期回调据此自停
  if (数据.周期ID > 0) {
    removePeriodicCallback(数据.周期ID);
    数据.周期ID = 0;
  }
  if (数据.阵特效 != null && 数据.阵特效 !== 0) {
    销毁点特效(数据.阵特效);
    数据.阵特效 = null;
  }
  // 全员按离场处理：摘除 Buff、容器标记与记录
  for (const tid in 数据.上次内部成员) {
    const 成员 = 数据.上次内部成员[tid];
    取消标记目标在塞莉亚E区域(成员);
    if (成员 != null && 单位存活(成员) && !目标在塞莉亚E区域(成员)) {
      移除单位指定Buff(成员, 塞莉亚BuffID.锚定魔法阵);
    }
    delete 数据.停留累计毫秒[tid];
    delete 数据.已触发阈值[tid];
    delete 数据.上次内部成员[tid];
  }
  const 表 = 塞莉亚锚定区域表[取单位ID(数据.英雄)];
  if (表 === 数据) delete 塞莉亚锚定区域表[取单位ID(数据.英雄)];
}

function on锚定区域周期(数据: 塞莉亚锚定区域数据, 步长毫秒: number): void {
  if (getGameTime() >= 数据.到期时间) {
    关闭锚定区域(数据);
    return;
  }
  const 英雄 = 数据.英雄;
  if (!单位存活(英雄)) return;
  const 列表 = 获取坐标范围敌人(英雄, 数据.X, 数据.Y, 数据.半径);
  const 在内索引: Record<number, boolean | undefined> = {};
  for (let i = 0; i < 列表.length; i++) {
    const 敌人 = 列表[i];
    if (!单位存活(敌人)) continue;
    const tid = 取单位ID(敌人);
    在内索引[tid] = true;
    // 仅首次进入计数登记，避免每周期重复累加导致永久残留
    if (数据.上次内部成员[tid] == null) {
      标记目标在塞莉亚E区域(敌人);
      数据.停留累计毫秒[tid] = 0;
    }
    registerManualBuff(敌人, 塞莉亚BuffID.锚定魔法阵, Math最小值(1.2, (数据.到期时间 - getGameTime()) / 1000), 0);
    // 停留累计 + 一次性阈值控制
    const 原 = 数据.停留累计毫秒[tid] ?? 0;
    const 新累计 = 原 + 步长毫秒;
    if (新累计 >= 塞莉亚克莱尔E配置.停留阈值毫秒 && 数据.已触发阈值[tid] !== true) {
      数据.已触发阈值[tid] = true;
      施加扩展控制(英雄, 敌人, "roots", 塞莉亚克莱尔E配置.阈值定身秒);
      // 定身锁死音（阈值定身真实触发时一次；坐标=目标位置，已触发阈值保证每目标每阵一次，参数配置驱动）
      Sound3DII_CooPlayReuse(塞莉亚音效配置.E锁死.路径, GetUnitX(敌人), GetUnitY(敌人), 塞莉亚音效配置.E锁死.高度, 塞莉亚音效配置.E锁死.裁断距离);
    }
    数据.停留累计毫秒[tid] = 新累计 > 4000 ? 4000 : 新累计;
  }
  // 离开：取消容器标记并清账（本 tick 不在成员快照者）
  for (const tid in 数据.上次内部成员) {
    if (在内索引[Number(tid)] !== true) {
      const 成员 = 数据.上次内部成员[tid];
      取消标记目标在塞莉亚E区域(成员);
      if (!目标在塞莉亚E区域(成员)) 移除单位指定Buff(成员, 塞莉亚BuffID.锚定魔法阵);
      delete 数据.停留累计毫秒[tid];
      delete 数据.上次内部成员[tid];
    }
  }
  // 刷新本 tick 成员快照
  for (let i = 0; i < 列表.length; i++) {
    const 敌人 = 列表[i];
    if (!单位存活(敌人)) continue;
    数据.上次内部成员[取单位ID(敌人)] = 敌人;
  }
}

function Math最小值(a: number, b: number): number {
  return a < b ? a : b;
}

//=============================================================================
// 施放流程
//=============================================================================

function 释放E锚定魔法阵(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) return;

  // t0 快照
  const 中心X = GetSpellTargetX();
  const 中心Y = GetSpellTargetY();
  SetUnitFacing(施法者, 两点角度(GetUnitX(施法者), GetUnitY(施法者), 中心X, 中心Y));

  const 实例 = 创建战斗技能实例({
    技能键: "E锚定魔法阵",
    施法者,
    技能实例ID,
    结束回调: function E实例结束(this: void, _原因: string, _控制器: any): void {
      void _原因;
      void _控制器;
    },
  });

  // 技能喊话：施法成功起点（技能实例成功创建；全局 3D；随机二选一由喊话系统驱动）
  播放英雄技能喊话(施法者, "塞莉亚·克莱尔", 塞莉亚克莱尔技能配置.E.技能ID);

  // 同一塞莉亚旧区域先关闭（避免同范围双阵）
  const 旧区域 = 塞莉亚锚定区域表[取单位ID(施法者)];
  if (旧区域 != null) 关闭锚定区域(旧区域);

  // 预警符文：覆盖从锁定到生效的窗口（小型提示，不替代真实判定）
  const 预警缩放 = 塞莉亚克莱尔E配置.生效延迟秒 <= 0 ? 1 : 塞莉亚克莱尔表现配置.E锚定阵.预警缩放系数;
  const 预警 = 创建点特效({
    模型路径: 塞莉亚克莱尔表现配置.E锚定阵.模型路径,
    RGB: 塞莉亚克莱尔表现配置.E锚定阵.RGB,
    X: 中心X,
    Y: 中心Y,
    Z: 塞莉亚克莱尔表现配置.E锚定阵.高度,
    缩放: 预警缩放 * 塞莉亚克莱尔E配置.区域半径 / 塞莉亚克莱尔表现配置.E锚定阵.基准半径,
    持续秒: 塞莉亚克莱尔E配置.生效延迟秒,
  });
  void 预警;

  // 时序：先暂停，硬直结束恢复
  添加单位暂停(施法者, E硬直来源);
  实例.登记延迟回调(addDelayedCallback(塞莉亚克莱尔E配置.硬直秒 * 1000, function E硬直结束(this: void): void {
    移除单位暂停(施法者, E硬直来源);
  }));

  实例.登记延迟回调(addDelayedCallback(塞莉亚克莱尔E配置.生效延迟秒 * 1000, function E生效(this: void): void {
    if (实例.已结束()) return;
    if (!单位存活(施法者)) return;

    // 真实区域视觉（常驻句柄随区域数据单次销毁）
    const 数据: 塞莉亚锚定区域数据 = {
      英雄: 施法者,
      X: 中心X,
      Y: 中心Y,
      半径: 塞莉亚克莱尔E配置.区域半径,
      到期时间: getGameTime() + 塞莉亚克莱尔E配置.阵持续秒 * 1000,
      阵特效: null,
      停留累计毫秒: {},
      已触发阈值: {},
      上次内部成员: {},
      周期ID: 0,
      已关闭: false,
    };
    数据.阵特效 = 创建点特效({
      模型路径: 塞莉亚克莱尔表现配置.E锚定阵.模型路径,
      RGB: 塞莉亚克莱尔表现配置.E锚定阵.RGB,
    X: 中心X,
      Y: 中心Y,
      Z: 塞莉亚克莱尔表现配置.E锚定阵.高度,
      缩放: 塞莉亚克莱尔E配置.区域半径 / 塞莉亚克莱尔表现配置.E锚定阵.基准半径 * 塞莉亚克莱尔表现配置.E锚定阵.基准缩放,
      持续秒: 塞莉亚克莱尔表现配置.E锚定阵.持续秒,
    });
    塞莉亚锚定区域表[取单位ID(施法者)] = 数据;

    // 法阵扣合音（锚定法阵真正落地建立时一次；坐标=法阵中心，参数配置驱动）
    Sound3DII_CooPlayReuse(塞莉亚音效配置.E扣合.路径, 中心X, 中心Y, 塞莉亚音效配置.E扣合.高度, 塞莉亚音效配置.E扣合.裁断距离);

    // 生效成功：授予一次演算普攻窗口（打断/死亡路径不会走到这里）
    授予塞莉亚演算窗口(施法者);

    // 生效点：一次性伤害 + 减速（实时枚举）
    const 攻击力 = 读取单位攻击力(施法者);
    const 列表 = 获取坐标范围敌人(施法者, 中心X, 中心Y, 塞莉亚克莱尔E配置.区域半径);
    for (let i = 0; i < 列表.length; i++) {
      const 敌人 = 列表[i];
      if (!单位存活(敌人)) continue;
      造成技能伤害({
        来源: 施法者,
        目标: 敌人,
        伤害: 攻击力 * 塞莉亚克莱尔E配置.生效伤害攻击力倍率,
        伤害类型: DAMAGE_TYPE_MAGIC,
        攻击类型: ATTACK_TYPE_NORMAL,
        武器类型: WEAPON_TYPE_WHOKNOWS,
        来源类型: "单位技能",
        技能实例ID,
        标签: "塞莉亚-锚定冲击",
        伤害形态: "AOE",
        参与技能伤害加成: true,
      });
      施加扩展控制(施法者, 敌人, "slow", 塞莉亚克莱尔E配置.生效减速秒);
    }

    // 锚定节点在真实阵心建立并参与连接
    创建塞莉亚节点(施法者, "锚定", 中心X, 中心Y, 技能实例ID);

    // 存留阶段周期：进入登记 / 停留阈值 / 离开清账
    const 步长毫秒 = 400;
    数据.周期ID = addPeriodicCallback(步长毫秒, function E阵周期(this: void): void {
      on锚定区域周期(数据, 步长毫秒);
    });

    // 打断/死亡/场景清理兜底：无结束爆发
    const 注销 = 登记塞莉亚技能清理(施法者, "E区域-" + (技能实例ID ?? 0), function E区域清理(this: void): void {
      关闭锚定区域(数据);
      if (!实例.已结束()) 实例.结束("中断");
    });
    void 注销;

    // 正常到期路径：注销周期并完成实例
    实例.登记延迟回调(addDelayedCallback(塞莉亚克莱尔E配置.阵持续秒 * 1000, function E阵自然到期(this: void): void {
      关闭锚定区域(数据);
      if (!实例.已结束()) 实例.完成();
      注销();
    }));
  }));
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册塞莉亚E(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "塞莉亚·克莱尔-锚定魔法阵（E）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 塞莉亚克莱尔技能配置.E.技能ID,
    获取或创建上下文: function E上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放E锚定魔法阵,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 10,
  });
}

export {};
