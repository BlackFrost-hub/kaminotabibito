/** @noSelfInFile */
/**
 * 芙莉莲 D：创造花田的魔法（B3：A6）
 *
 * 目标点短时友方准备区（不伤害、不阻挡、不改变寻路、不强控）；
 * 提供配置化视野（FogModifier 真实接入）、静止准备的隐匿恢复加速（注入 02 判定接口）
 * 与一次下一技能修正（Q/W/E 共享单次消费锁）；R 盛开单独单次；
 * 同一芙莉莲只保留一片花田（重复释放先完整清理旧花田与一次性锁）；
 * 自然结束柔和消散；打断/死亡不播放完成盛开。
 */

import {
  芙莉莲技能配置,
  芙莉莲D配置,
  芙莉莲表现配置,
  芙莉莲音效配置,
} from "./00．配置";
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string) => boolean;
};
const { 播放限时动作, 芙莉莲动作槽 } = require("./01A．动作表现") as {
  播放限时动作: (this: void, 英雄: any, 槽: any, 登记名: string) => void;
  芙莉莲动作槽: { D花田: any };
};

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
};
const { getGameTime, addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 创建战斗技能实例, 查询战斗技能实例 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂") as {
  创建战斗技能实例: (this: void, 参数: any) => any;
  查询战斗技能实例: (this: void, 施法者: any, 技能键: string) => any[];
};
const { 创建区域效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.04．区域效果.区域效果") as {
  创建区域效果: (this: void, 参数: any) => any;
};
const { createUnitEffect, destroyUnitEffect, 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
  destroyUnitEffect: (this: void, unit: any, effectKey?: string) => void;
  创建点特效: (this: void, 参数: any) => any;
};
const { DzDoodadCreate, DzDoodadSetModel, DzDoodadRemove } = require("lib.扩展函数.KK扩展API.00．装饰物函数") as {
  DzDoodadCreate: (this: void, id: number, varId: number, x: number, y: number, z: number, rotate: number, scale: number) => number;
  DzDoodadSetModel: (this: void, doodad: number, modelFile: string) => void;
  DzDoodadRemove: (this: void, doodad: number) => void;
};
const { 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
};
const { 是芙莉莲, 记录芙莉莲活动, 登记芙莉莲清理, 花田判定接口, 重新安排隐匿计时 } = require("./02．被动效果") as {
  是芙莉莲: (this: void, unit: any) => boolean;
  记录芙莉莲活动: (this: void, 英雄: any) => void;
  登记芙莉莲清理: (this: void, 英雄: any, 名称: string, 清理: () => void) => void;
  花田判定接口: {
    在花田内: (this: void, 英雄: any) => boolean;
    在花田内静止: (this: void, 英雄: any) => boolean;
  };
  重新安排隐匿计时: (this: void, 英雄: any) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(芙莉莲技能配置.单位类型ID);
const D技能ID = stringToFourCCSafe(芙莉莲技能配置.D.技能ID);
const D配置 = 芙莉莲D配置;
const 花海装饰物ID = stringToFourCCSafe("D0B5");

const GetHandleId = jass.GetHandleId as (this: void, h: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const 距离平方 = function 距离平方XY(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return dx * dx + dy * dy;
};

//=============================================================================
// 花田数据（按芙莉莲句柄隔离；同一芙莉莲只保留一片）
//=============================================================================

interface 花田数据 {
  芙莉莲: any;
  中心X: number;
  中心Y: number;
  半径: number;
  /** 区域效果实例（友方准备区；无伤害回调） */
  区域: any;
  /** 环境粒子主体（常驻句柄） */
  花瓣句柄: any;
  /** 花簇装饰物句柄（交错网格；由 D 实例统一清理） */
  花簇句柄列表: number[];
  /** 视野修正器（真实视野接入） */
  视野句柄: any;
  /** 修正/盛开一次性锁 */
  修正已消费: boolean;
  盛开已消费: boolean;
  /** 静止检测（位置采样） */
  静止上次X: number;
  静止上次Y: number;
  静止采样计数: number;
  静止标记: boolean;
  /** 计时器 */
  到期回调ID: number;
  静止检测ID: number;
  已结束: boolean;
}

const 花田表: Record<number, 花田数据 | undefined> = {};

//=============================================================================
// 判定接口（注入 02；隐匿恢复加速使用）
//=============================================================================

function 距离平方单位(this: void, a: any, b: any): number {
  return 距离平方(GetUnitX(a), GetUnitY(a), GetUnitX(b), GetUnitY(b));
}

花田判定接口.在花田内 = function 在花田内(this: void, 英雄: any): boolean {
  if (英雄 == null || 英雄 === 0) return false;
  const 花田 = 花田表[GetHandleId(英雄)];
  return 花田 != null && !花田.已结束 && 距离平方(GetUnitX(英雄), GetUnitY(英雄), 花田.中心X, 花田.中心Y) <= 花田.半径 * 花田.半径;
};

花田判定接口.在花田内静止 = function 在花田内静止(this: void, 英雄: any): boolean {
  if (英雄 == null || 英雄 === 0) return false;
  const 花田 = 花田表[GetHandleId(英雄)];
  return 花田 != null && !花田.已结束 && 花田.静止标记 && 距离平方(GetUnitX(英雄), GetUnitY(英雄), 花田.中心X, 花田.中心Y) <= 花田.半径 * 花田.半径;
};

/** 芙莉莲是否在花田内（R/E 模块运行时读取；与 花田判定接口 同源） */
export function 在花田内(this: void, 芙莉莲: any): boolean {
  return 花田判定接口.在花田内(芙莉莲);
}

/** 花田内静止检测：采样间隔、移动阈值和连续次数均由 D 配置驱动。 */
function 启动静止检测(this: void, 花田: 花田数据): void {
  花田.静止检测ID = addPeriodicCallback(D配置.静止检测间隔毫秒, function 花田静止检测(this: void): void {
    if (花田.已结束) return;
    const 英雄 = 花田.芙莉莲;
    if (英雄 == null || 英雄 === 0 || !单位存活(英雄)) return;
    const 在内 = 距离平方(GetUnitX(英雄), GetUnitY(英雄), 花田.中心X, 花田.中心Y) <= 花田.半径 * 花田.半径;
    if (!在内) {
      花田.静止采样计数 = 0;
      花田.静止标记 = false;
      return;
    }
    const 移动平方 = 距离平方(GetUnitX(英雄), GetUnitY(英雄), 花田.静止上次X, 花田.静止上次Y);
    const 原静止 = 花田.静止标记;
    if (移动平方 <= D配置.静止移动阈值 * D配置.静止移动阈值) {
      花田.静止采样计数++;
      if (花田.静止采样计数 >= D配置.静止连续采样次数) 花田.静止标记 = true;
    } else {
      花田.静止采样计数 = 0;
      花田.静止标记 = false;
    }
    花田.静止上次X = GetUnitX(英雄);
    花田.静止上次Y = GetUnitY(英雄);
    // 静止状态变化：重新按当前倍率安排隐匿计时（D 建花田在记录活动之后，此处校正本次静默恢复）
    if (花田.静止标记 !== 原静止) 重新安排隐匿计时(英雄);
  });
}

//=============================================================================
// 修正/盛开单次消费锁（Q/W/E 修正共享一次；R 盛开单独一次）
//=============================================================================

/** Q/W/E 花田修正：花田存在 + 芙莉莲在花田内 + 修正未消费 → 消费返回 true */
export function 尝试消费花田修正(this: void, 芙莉莲: any): boolean {
  if (芙莉莲 == null || 芙莉莲 === 0) return false;
  const 花田 = 花田表[GetHandleId(芙莉莲)];
  if (花田 == null || 花田.已结束 || 花田.修正已消费) return false;
  if (!花田判定接口.在花田内(芙莉莲)) return false;
  花田.修正已消费 = true;
  return true;
}

/** R 花田盛开：花田存在 + R 在花田内释放 + 盛开未消费 → 消费返回 true（只强化一次表现，不追加伤害） */
export function 尝试消费花田盛开(this: void, 芙莉莲: any): boolean {
  if (芙莉莲 == null || 芙莉莲 === 0) return false;
  const 花田 = 花田表[GetHandleId(芙莉莲)];
  if (花田 == null || 花田.已结束 || 花田.盛开已消费) return false;
  if (!花田判定接口.在花田内(芙莉莲)) return false;
  花田.盛开已消费 = true;
  // 盛开表现：花瓣主体短时增强重播（温和，不使用爆炸表现；参数配置驱动）
  创建点特效({
    模型路径: 芙莉莲表现配置.D花瓣.模型路径,
        X: 花田.中心X,
    Y: 花田.中心Y,
    Z: 芙莉莲表现配置.D盛开.高度,
    面向角度: 芙莉莲表现配置.D盛开.面向角度,
    动画索引: 芙莉莲表现配置.D盛开.动画索引,
    缩放: (花田.半径 / 芙莉莲表现配置.D花瓣.基准半径) * 芙莉莲表现配置.D花瓣.基准缩放 * 芙莉莲表现配置.D盛开.缩放倍率,
    持续秒: 芙莉莲表现配置.D盛开.持续秒,
    RGB: 芙莉莲表现配置.D盛开.RGB,
  });
  return true;
}

//=============================================================================
// 花田销毁（自然消散/打断/死亡共用；幂等）
//=============================================================================

function 销毁花田(this: void, 花田: 花田数据, 自然结束: boolean): void {
  if (花田.已结束) return;
  花田.已结束 = true;
  // 计时器
  if (花田.到期回调ID !== 0) removeDelayedCallback(花田.到期回调ID);
  if (花田.静止检测ID !== 0) removePeriodicCallback(花田.静止检测ID);
  // 区域效果（先于特效：内部清空集合）
  if (花田.区域 != null) {
    花田.区域.销毁();
    花田.区域 = null;
  }
  // 视野修正器
  if (花田.视野句柄 != null && 花田.视野句柄 !== 0) {
    jass.DestroyFogModifier(花田.视野句柄);
    花田.视野句柄 = null;
  }
  // 环境粒子（自然结束柔和消散：短延时淡出；打断/死亡立即销毁）
  if (花田.花瓣句柄 != null && 花田.花瓣句柄 !== 0) {
    if (自然结束) {
      const 句柄 = 花田.花瓣句柄;
      花田.花瓣句柄 = null;
      addDelayedCallback(D配置.自然淡出延迟毫秒, function 花瓣淡出(this: void): void {
        jass.DestroyEffect(句柄);
      });
    } else {
      jass.DestroyEffect(花田.花瓣句柄);
      花田.花瓣句柄 = null;
    }
  }
  for (let i = 0; i < 花田.花簇句柄列表.length; i++) {
    const 花簇 = 花田.花簇句柄列表[i];
    if (花簇 != null && 花簇 !== 0) DzDoodadRemove(花簇);
  }
  花田.花簇句柄列表 = [];
  delete 花田表[GetHandleId(花田.芙莉莲)];
}

/** 在花田半径内按交错网格创建有限花簇，避免规则方格的拼接感和无限实例。 */
function 创建花海(this: void, 花田: 花田数据): void {
  const 配置 = 芙莉莲表现配置.D花海;
  const 有效半径 = Math.max(0, 花田.半径 - 配置.边缘内缩);
  const 有效半径平方 = 有效半径 * 有效半径;
  let 数量 = 0;
  for (let 行 = -配置.网格半径; 行 <= 配置.网格半径; 行++) {
      const 行偏移 = Math.abs(行) % 配置.交错行周期 === 配置.交错行余数
        ? 配置.间距X * 配置.交错行偏移比例
        : 0;
    for (let 列 = -配置.网格半径; 列 <= 配置.网格半径; 列++) {
      if (数量 >= 配置.最大实例数) return;
      const x = 花田.中心X + 列 * 配置.间距X + 行偏移;
      const y = 花田.中心Y + 行 * 配置.间距Y;
      if (距离平方(x, y, 花田.中心X, 花田.中心Y) > 有效半径平方) continue;
      const 图案索引 = Math.abs(行 * 配置.图案行步进 + 列 * 配置.图案列步进) % 配置.图案数量;
      const 缩放倍率 = 配置.基准缩放 * (1 + (图案索引 - 1) * 配置.缩放扰动);
      const 网格序号 = (行 + 配置.网格半径) * (配置.网格半径 * 2 + 1) + 列 + 配置.网格半径;
      const 朝向 = (网格序号 * 配置.旋转步进) % 配置.旋转角度周期;
      const 花簇 = DzDoodadCreate(花海装饰物ID, 配置.装饰物变体ID, x, y, 配置.高度, 朝向, 缩放倍率);
      if (花簇 != null && 花簇 !== 0) {
        DzDoodadSetModel(花簇, 配置.模型路径);
        花田.花簇句柄列表.push(花簇);
        数量++;
      }
    }
  }
}

//=============================================================================
// D 释放
//=============================================================================

function 释放D(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (!是芙莉莲(施法者)) return;
  记录芙莉莲活动(施法者);
  // 花田施法动作（送杖候选）
  播放限时动作(施法者, 芙莉莲动作槽.D花田, "芙莉莲D动作");
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const id = GetHandleId(施法者);

  // 同一芙莉莲只保留一片花田：重复释放先完整清理旧花田与一次性锁
  const 旧花田 = 花田表[id];
  if (旧花田 != null) {
    销毁花田(旧花田, false);
    // 旧花田对应实例收束
    const 旧实例列表 = 查询战斗技能实例(施法者, "芙莉莲D");
    for (let i = 0; i < 旧实例列表.length; i++) 旧实例列表[i].完成();
  }

  const 花田: 花田数据 = {
    芙莉莲: 施法者,
    中心X: 目标X,
    中心Y: 目标Y,
    半径: D配置.半径,
    区域: null,
    花瓣句柄: null,
    花簇句柄列表: [],
    视野句柄: null,
    修正已消费: false,
    盛开已消费: false,
    静止上次X: GetUnitX(施法者),
    静止上次Y: GetUnitY(施法者),
    静止采样计数: 0,
    静止标记: false,
    到期回调ID: 0,
    静止检测ID: 0,
    已结束: false,
  };
  花田表[id] = 花田;

  const 控制器 = 创建战斗技能实例({
    技能键: "芙莉莲D",
    施法者,
    技能实例ID,
    数据: 花田,
    结束回调: function D结束(this: void, _原因: string, _c: any): void {
      // 打断/死亡：立即销毁，不播放完成盛开
      销毁花田(花田, false);
    },
  });

  // 友方准备区（不伤害、不阻挡、不改寻路；区域效果承载边界）
  花田.区域 = 创建区域效果({
    X: 目标X,
    Y: 目标Y,
    半径: D配置.半径,
    持续时间: D配置.持续秒,
    影响目标: "友方",
    所有者: 施法者,
    on销毁: function 花田区域销毁(this: void): void {
      // 区域自然到期 = 花田自然结束（柔和消散）
      if (!花田.已结束) {
        销毁花田(花田, true);
        控制器.完成();
      }
    },
  });

  // 配置化视野（芙莉莲所有者玩家；真实 FogModifier，随花田销毁）
  花田.视野句柄 = jass.CreateFogModifierRadius(GetOwningPlayer(施法者), jass.FOG_OF_WAR_VISIBLE, 目标X, 目标Y, D配置.半径, true, false);
  if (花田.视野句柄 != null && 花田.视野句柄 !== 0) jass.EnableFogModifier(花田.视野句柄);

  // 环境粒子辅助层（常驻句柄随花田销毁）
  花田.花瓣句柄 = 创建点特效({
    模型路径: 芙莉莲表现配置.D花瓣.模型路径,
        X: 目标X,
    Y: 目标Y,
    Z: 芙莉莲表现配置.D花瓣.高度,
    面向角度: 芙莉莲表现配置.D花瓣.面向角度,
    动画索引: 芙莉莲表现配置.D花瓣.动画索引,
    缩放: (D配置.半径 / 芙莉莲表现配置.D花瓣.基准半径) * 芙莉莲表现配置.D花瓣.基准缩放,
    持续秒: 芙莉莲表现配置.D花瓣.持续秒,
    RGB: 芙莉莲表现配置.D花瓣.RGB,
  });
  // 花海主体：真实装饰物相邻摆盘，不参与区域判定、不阻挡寻路。
  创建花海(花田);
  // 花田生成音（花田实际建立后一次；坐标=花田中心，参数配置驱动）
  Sound3DII_CooPlayReuse(芙莉莲音效配置.D花田.路径, 目标X, 目标Y, 芙莉莲音效配置.D花田.高度, 芙莉莲音效配置.D花田.裁断距离);
  // 技能喊话：施法成功起点（全局 3D；随机二选一由喊话系统驱动）
  播放英雄技能喊话(施法者, "芙莉莲", 芙莉莲技能配置.D.技能ID);

  // 静止检测（隐匿恢复加速判定）
  启动静止检测(花田);

  // 兜底到期（区域效果销毁回调之外的第二保险）
  花田.到期回调ID = addDelayedCallback(D配置.持续秒 * 1000 + D配置.到期兜底延迟毫秒, function 花田到期(this: void): void {
    if (花田.已结束) return;
    销毁花田(花田, true);
    控制器.完成();
  });
  控制器.登记延迟回调(花田.到期回调ID);
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册芙莉莲D(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "芙莉莲-创造花田的魔法（D）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 芙莉莲技能配置.D.技能ID,
    获取或创建上下文: function D上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放D,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: D配置.持续秒 + D配置.实例收尾缓冲秒,
  });
}
