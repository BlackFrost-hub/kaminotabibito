/** @noSelfInFile */
/**
 * 塞莉亚·克莱尔 - R：高阶术式·闭锁（A7）
 *
 * - t0 快照领域中心/方向/至多 2 个节点与 1 条有效连接，并锁定 D 的改写入口；
 *   充能期间快照不可被 D 影响，D 对节点的转写请求被容器拒绝。
 * - 通用 开始充能：指令中断 true、保留硬控/死亡中断、不传强制硬直；
 *   世界坐标进度 UI 跟随施法者（Z 读读条配置），模型进度条关闭。
 * - 高阶法阵/闭锁核心/范围控制/连接消费/主伤害只在完成回调创建；
 *   中断与死亡只清预警视觉并解除锁定，不消费连接、不伤害。
 * - 基础 R 始终结算：主伤害 + 减速 + 硬直控制；连接分支最多一次，
 *   由容器的 可读取 位原子保护；无连接时按单一存活节点给对应单独强化。
 * - 收束视觉只走自然完成路径；打断/死亡/场景清理不得触发最终爆发。
 */

import {
  塞莉亚克莱尔技能配置,
  塞莉亚克莱尔R配置,
  塞莉亚克莱尔读条配置,
  塞莉亚克莱尔表现子配置,
} from "./00．配置";
import { 塞莉亚BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/24．塞莉亚·克莱尔";
import type { 塞莉亚节点类型 } from "./02．被动效果";
import {
  查询塞莉亚节点,
  查询塞莉亚有效连接,
  消费塞莉亚连接,
  锁定塞莉亚R,
  解除塞莉亚R锁定,
  登记塞莉亚技能清理,
} from "./02．被动效果";
import { 开始塞莉亚循环动作, 停止塞莉亚循环动作 } from "./01A．动作表现";

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, angle: number) => void;
const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 创建战斗技能实例, 查询战斗技能实例 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂") as {
  创建战斗技能实例: (this: void, 参数: any) => any;
  查询战斗技能实例: (this: void, 单位: any, 技能键?: string) => any[];
};
const { 开始充能, 停止充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, 单位: any, 参数: any) => number;
  停止充能: (this: void, 充能ID: number) => boolean;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { AOE施加扩展控制, 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  AOE施加扩展控制: (this: void, 来源: any, 中心X: number, 中心Y: number, 半径: number, 类型: string, 持续秒: number) => any[];
  施加扩展控制: (this: void, 来源: any, 目标: any, 类型: string, 持续秒: number) => number;
};
const { 发射弹道 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.09．复杂战斗模板.05．弹道编排工厂") as {
  发射弹道: (this: void, 参数: any) => any;
};
const {
  读取单位攻击力,
  单位存活,
  两点角度,
  极坐标X,
  极坐标Y,
} = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  极坐标X: (this: void, x: number, angleDeg: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angleDeg: number, distance: number) => number;
};
const { 获取坐标范围敌人 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  /** 注意：公共实现为 (中心来源单位, X, Y, 半径) */
  获取坐标范围敌人: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 开始护盾 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统") as {
  开始护盾: (this: void, 单位: any, 参数: any) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};

const 英雄单位类型ID = 塞莉亚克莱尔技能配置.单位类型ID;
const R技能类型ID = jass.FourCC(塞莉亚克莱尔技能配置.R.技能ID) as number;
const R技能键 = "R高阶术式闭锁";

//=============================================================================
// 结算辅助
//=============================================================================

function R技能伤害(
  this: void,
  施法者: any,
  目标: any,
  伤害值: number,
  数据: any,
  标签: string,
): boolean {
  return 造成技能伤害({
    来源: 施法者,
    目标,
    伤害: 伤害值,
    伤害类型: DAMAGE_TYPE_MAGIC,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: R技能类型ID,
    技能实例ID: 数据.技能实例ID,
    标签,
    伤害形态: "AOE",
    参与技能伤害加成: true,
  });
}

function 范围爆发(this: void, 施法者: any, X: number, Y: number, 半径: number, 倍率: number, 数据: any, 标签: string): void {
  const 列表 = 获取坐标范围敌人(施法者, X, Y, 半径);
  const 伤害 = 读取单位攻击力(施法者) * 倍率;
  for (let i = 0; i < 列表.length; i++) {
    const 敌人 = 列表[i];
    if (!单位存活(敌人)) continue;
    R技能伤害(施法者, 敌人, 伤害, 数据, 标签);
  }
}

function 发射R魔弹(
  this: void,
  施法者: any,
  数据: any,
  参数: { 名称: string; 标签: string; 发射X: number; 发射Y: number; 方向角: number; 形态: "单体" | "AOE"; 穿透: boolean; 最大命中数: number; 倍率: number; 距离: number; 追踪目标?: any },
): void {
  发射弹道({
    名称: 参数.名称,
    所有者: 施法者,
    发射X: 参数.发射X,
    发射Y: 参数.发射Y,
    发射方向角: 参数.方向角,
    速度: 塞莉亚克莱尔R配置.贯穿炮速度,
    轨迹: 参数.追踪目标 != null
      ? { 类型: "追踪", 目标: 参数.追踪目标, 追踪转向速度: 480, 追踪保持秒: 1.2 }
      : { 类型: "直线", 距离: 参数.距离 },
    命中半径: 120,
    影响目标: "敌方",
    碰撞消失: !参数.穿透,
    每单位最大命中次数: 1,
    最大总命中次数: 参数.穿透 ? 参数.最大命中数 : undefined,
    伤害值: 读取单位攻击力(施法者) * 参数.倍率,
    伤害类型: DAMAGE_TYPE_MAGIC,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: R技能类型ID,
    技能实例ID: 数据.技能实例ID,
    技能标签: 参数.标签,
    伤害形态: 参数.形态,
    参与技能伤害加成: false,
    模型: 塞莉亚克莱尔表现子配置.Q弹道.模型路径,
    缩放: 塞莉亚克莱尔表现子配置.Q弹道.缩放,
  });
}

//=============================================================================
// 分支（最多一次；连接由可读取位原子消费）
//=============================================================================

/** 分支执行：传入已经原子消费成功的连接信息（本函数不再触碰消费锁）。 */
function 执行连接分支(
  this: void,
  施法者: any,
  实例: any,
  数据: any,
  已消费连接: { A序号: number; B序号: number; A类型: 塞莉亚节点类型; B类型: 塞莉亚节点类型 },
): void {
  const 有棱晶 = 已消费连接.A类型 === "棱晶" || 已消费连接.B类型 === "棱晶";
  const 有结界 = 已消费连接.A类型 === "结界" || 已消费连接.B类型 === "结界";
  const 有锚定 = 已消费连接.A类型 === "锚定" || 已消费连接.B类型 === "锚定";

  if (有棱晶 && 有结界) {
    // 多重折射魔弹扇形 + 一次穿透冲击
    for (let i = 0; i < 塞莉亚克莱尔R配置.分支折射弹数量; i++) {
      const 偏移 = (i - (塞莉亚克莱尔R配置.分支折射弹数量 - 1) / 2) * 20;
      发射R魔弹(施法者, 数据, {
        名称: "塞莉亚-多重折射魔弹",
        标签: "塞莉亚-闭锁·折射",
        发射X: 数据.中心X,
        发射Y: 数据.中心Y,
        方向角: 数据.方向角 + 偏移,
        形态: "单体",
        穿透: false,
        最大命中数: 1,
        倍率: 塞莉亚克莱尔R配置.分支折射弹倍率,
        距离: 塞莉亚克莱尔R配置.分支穿透冲击距离,
      });
    }
    发射R魔弹(施法者, 数据, {
      名称: "塞莉亚-解析穿透冲击",
      标签: "塞莉亚-闭锁·穿透",
      发射X: 数据.中心X,
      发射Y: 数据.中心Y,
      方向角: 数据.方向角,
      形态: "AOE",
      穿透: true,
      最大命中数: 塞莉亚克莱尔R配置.分支穿透冲击命中数,
      倍率: 塞莉亚克莱尔R配置.分支穿透冲击倍率,
      距离: 塞莉亚克莱尔R配置.分支穿透冲击距离,
    });
  } else if (有结界 && 有锚定) {
    // 范围封锁 + 结界爆裂
    AOE施加扩展控制(施法者, 数据.中心X, 数据.中心Y, 塞莉亚克莱尔R配置.领域半径, "roots", 塞莉亚克莱尔R配置.封锁束缚秒);
    范围爆发(施法者, 数据.中心X, 数据.中心Y, 塞莉亚克莱尔R配置.领域半径, 塞莉亚克莱尔R配置.封锁爆裂倍率, 数据, "塞莉亚-闭锁·结界爆裂");
  } else if (有棱晶 && 有锚定) {
    // 锁定阵内最近目标 → 贯穿魔法炮（追踪后保持方向贯穿）
    const 最近敌人 = 取阵内最近敌人(施法者, 数据.中心X, 数据.中心Y, 塞莉亚克莱尔R配置.领域半径);
    发射R魔弹(施法者, 数据, {
      名称: "塞莉亚-闭锁贯穿炮",
      标签: "塞莉亚-闭锁·贯穿炮",
      发射X: 数据.中心X,
      发射Y: 数据.中心Y,
      方向角: 数据.方向角,
      形态: "AOE",
      穿透: true,
      最大命中数: 塞莉亚克莱尔R配置.贯穿炮最大命中数,
      倍率: 塞莉亚克莱尔R配置.贯穿炮倍率,
      距离: 塞莉亚克莱尔R配置.分支穿透冲击距离 + 塞莉亚克莱尔R配置.领域半径,
      追踪目标: 最近敌人 ?? undefined,
    });
  }

  void 实例;
}

function 取阵内最近敌人(this: void, 来源: any, X: number, Y: number, 半径: number): any {
  const 列表 = 获取坐标范围敌人(来源, X, Y, 半径);
  let 最近: any = null;
  let 最近平方 = 半径 * 半径;
  for (let i = 0; i < 列表.length; i++) {
    const 敌人 = 列表[i];
    if (!单位存活(敌人)) continue;
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

/** 无连接时的单节点单独强化（取快照中仍存活的第一个节点类型）。 */
function 执行单节点强化(this: void, 施法者: any, 实例: any, 数据: any, 节点类型: 塞莉亚节点类型): void {
  if (节点类型 === "棱晶") {
    发射R魔弹(施法者, 数据, {
      名称: "塞莉亚-单体棱晶折射",
      标签: "塞莉亚-闭锁·单体棱晶",
      发射X: 数据.中心X,
      发射Y: 数据.中心Y,
      方向角: 数据.方向角 + 30,
      形态: "单体",
      穿透: false,
      最大命中数: 1,
      倍率: 塞莉亚克莱尔R配置.单节点棱晶折射倍率,
      距离: 塞莉亚克莱尔R配置.分支穿透冲击距离,
    });
  } else if (节点类型 === "结界") {
    开始护盾(施法者, {
      类型: 0,
      数值: 读取单位攻击力(施法者) * 塞莉亚克莱尔R配置.单节点结界护盾倍率,
      持续时间: 塞莉亚克莱尔R配置.单节点结界护盾秒,
      来源单位: 施法者,
      标签: "塞莉亚-闭锁结界",
      显示护盾条: true,
    });
  } else {
    AOE施加扩展控制(
      施法者,
      数据.中心X,
      数据.中心Y,
      塞莉亚克莱尔R配置.单节点锚定束缚半径,
      "roots",
      塞莉亚克莱尔R配置.单节点锚定束缚秒,
    );
  }
  void 实例;
}

//=============================================================================
// 主结算（只在充能完成回调执行）
//=============================================================================

function 执行R完成结算(this: void, 施法者: any, 实例: any, 数据: any): void {
  // 阵心核心表现
  const 核心 = 创建点特效({
    模型路径: 塞莉亚克莱尔表现子配置.R闭锁核心.模型路径,
    X: 数据.中心X,
    Y: 数据.中心Y,
    Z: 塞莉亚克莱尔表现子配置.R闭锁核心.高度,
    缩放: 塞莉亚克莱尔表现子配置.R闭锁核心.缩放,
    持续秒: 塞莉亚克莱尔表现子配置.R闭锁核心.持续秒,
  });
  void 核心;

  // 基础主效果始终结算：主伤害 + 减速 + 短硬直
  const 攻击力 = 读取单位攻击力(施法者);
  const 列表 = 获取坐标范围敌人(施法者, 数据.中心X, 数据.中心Y, 塞莉亚克莱尔R配置.领域半径);
  for (let i = 0; i < 列表.length; i++) {
    const 敌人 = 列表[i];
    if (!单位存活(敌人)) continue;
    R技能伤害(施法者, 敌人, 攻击力 * 塞莉亚克莱尔R配置.主伤害攻击力倍率, 数据, "塞莉亚-高阶术式·闭锁");
    施加扩展控制(施法者, 敌人, "slow", 塞莉亚克莱尔R配置.主减速秒);
    施加扩展控制(施法者, 敌人, "stagger", 塞莉亚克莱尔R配置.主控制硬直秒);
  }

  // 连接分支：只有完成时刻的当前连接仍与 t0 快照同对且可读取时才原子消费；
  // 蓄力期间节点被 Q/W/E 替换导致连接换对 ⇒ 与快照不一致，本次 R 不消费、不进入错误分支。
  let 分支已结算 = false;
  if (数据.连接快照 != null && 数据.有连接快照) {
    const 当前 = 查询塞莉亚有效连接(施法者);
    if (
      当前 != null &&
      当前.可读取 &&
      当前.A序号 === 数据.连接快照.A序号 &&
      当前.B序号 === 数据.连接快照.B序号
    ) {
      const 消费结果 = 消费塞莉亚连接(施法者);
      if (消费结果 != null) {
        执行连接分支(施法者, 实例, 数据, {
          A序号: 消费结果.A序号,
          B序号: 消费结果.B序号,
          A类型: 消费结果.A类型,
          B类型: 消费结果.B类型,
        });
        分支已结算 = true;
      }
    }
  }
  if (!分支已结算 && 数据.节点快照.length > 0) {
    const 存活列表 = 查询塞莉亚节点(施法者);
    for (let i = 0; i < 数据.节点快照.length; i++) {
      const 快照序号 = 数据.节点快照[i].序号;
      for (let j = 0; j < 存活列表.length; j++) {
        if (存活列表[j].序号 === 快照序号) {
          执行单节点强化(施法者, 实例, 数据, 存活列表[j].类型);
          分支已结算 = true;
          break;
        }
      }
      if (分支已结算) break;
    }
  }

  // 自然收束（唯一允许的收束路径）
  const 收束特效 = 创建点特效({
    模型路径: 塞莉亚克莱尔表现子配置.R收束.模型路径,
    X: 数据.中心X,
    Y: 数据.中心Y,
    Z: 塞莉亚克莱尔表现子配置.R收束.高度,
    缩放: 塞莉亚克莱尔表现子配置.R收束.缩放
      * 塞莉亚克莱尔R配置.领域半径 / 塞莉亚克莱尔R配置.高阶法阵基准半径,
    持续秒: 塞莉亚克莱尔表现子配置.R收束.持续秒,
  });
  void 收束特效;

  实例.完成();
}

//=============================================================================
// 施放流程
//=============================================================================

function 释放R高阶术式(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) return;
  // 禁止并行两个高阶领域
  if (查询战斗技能实例(施法者, R技能键).length > 0) return;

  // t0 快照：节点（≤2）与连接；同时锁定 D 改写入口
  const 中心X = GetSpellTargetX();
  const 中心Y = GetSpellTargetY();
  const 方向角 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), 中心X, 中心Y);
  const 存活节点 = 查询塞莉亚节点(施法者);
  const 节点快照: { 序号: number; 类型: 塞莉亚节点类型 }[] = [];
  for (let i = 0; i < 存活节点.length && i < 2; i++) {
    节点快照.push({ 序号: 存活节点[i].序号, 类型: 存活节点[i].类型 });
  }
  const 当前连接 = 查询塞莉亚有效连接(施法者);
  const 连接快照 = 当前连接 != null ? { A序号: 当前连接.A序号, B序号: 当前连接.B序号 } : null;

  锁定塞莉亚R(施法者);

  const 数据: any = {
    技能实例ID,
    中心X,
    中心Y,
    方向角,
    节点快照,
    连接快照,
    有连接快照: 连接快照 != null,
  };

  const 实例 = 创建战斗技能实例({
    技能键: R技能键,
    施法者,
    技能实例ID,
    数据,
    结束回调: function R实例结束(this: void, 原因: string, _控制器: any): void {
      // 所有结束路径解除 D 锁并移除蓄力 Buff；失败路径不再做任何结算
      解除塞莉亚R锁定(施法者);
      移除单位指定Buff(施法者, 塞莉亚BuffID.高阶术式蓄力);
    },
  });

  let 充能ID = 0;

  // 场景清理兜底：停止充能会同步销毁世界坐标 UI，并进入统一结束回调。
  const 注销 = 登记塞莉亚技能清理(施法者, "R闭锁-" + (技能实例ID ?? 0), function R统一清理(this: void): void {
    if (充能ID > 0) {
      const 待停止充能ID = 充能ID;
      充能ID = 0;
      停止充能(待停止充能ID);
    }
    if (!实例.已结束()) 实例.结束("中断");
  });
  void 注销;

  // 时序说明：不得在开始充能前手动暂停英雄——那会拦截玩家指令，
  // 使 指令中断 失去触发机会；中断完全交由充能系统的 指令中断/硬控/死亡 内置路径。
  SetUnitFacing(施法者, 方向角);

  // 蓄力预警（大型高阶法阵），常驻句柄由充能结束回调统一销毁
  let 法阵特效: any = null;
  法阵特效 = 创建点特效({
    模型路径: 塞莉亚克莱尔表现子配置.R高阶法阵.模型路径,
    X: 中心X,
    Y: 中心Y,
    Z: 塞莉亚克莱尔表现子配置.R高阶法阵.高度,
    缩放: 塞莉亚克莱尔R配置.领域半径 / 塞莉亚克莱尔R配置.高阶法阵基准半径
      * 塞莉亚克莱尔表现子配置.R高阶法阵.基准缩放,
    持续秒: 塞莉亚克莱尔表现子配置.R高阶法阵.持续秒,
  });

  // 充能真正开始后才挂动作循环与蓄力 Buff（被拒时走失败清理）
  let R守护: any = null;

  充能ID = 开始充能(施法者, {
    持续时间: 塞莉亚克莱尔R配置.蓄力秒,
    指令中断: true,
    世界坐标进度UI: true,
    世界坐标进度UI类型: 塞莉亚克莱尔读条配置.UI类型 as any,
    世界坐标进度UI标题: "高阶术式·闭锁",
    世界坐标进度UI数值后缀: "",
    世界坐标进度UI高度偏移: 塞莉亚克莱尔读条配置.跟随Z偏移,
    显示进度条特效: 塞莉亚克莱尔读条配置.显示模型进度条,
    充能完成回调: function R充能完成(this: void, _单位: any, _充能ID: number): void {
      if (!实例.仍有效() || !单位存活(施法者)) return;
      停止塞莉亚循环动作(施法者, R守护);
      执行R完成结算(施法者, 实例, 数据);
    },
    结束回调: function R蓄力结束(this: void, _单位: any, _原因: string, _充能ID: number): void {
      充能ID = 0;
      if (法阵特效 != null && 法阵特效 !== 0) {
        DestroyEffect(法阵特效);
        法阵特效 = null;
      }
      停止塞莉亚循环动作(施法者, R守护);
      if (!实例.已结束()) {
        // 中断/死亡：清预警与读条，不消费连接、不伤害（快照随实例销毁）
        实例.结束("中断");
      }
      注销();
    },
  });

  if (充能ID > 0) {
    R守护 = 开始塞莉亚循环动作(施法者, "R蓄力");
    registerManualBuff(施法者, 塞莉亚BuffID.高阶术式蓄力, 塞莉亚克莱尔R配置.蓄力秒, 0);
  } else {
    // 充能被拒（单位异常等）：安全收口——清预警、解除锁定、结束实例
    if (法阵特效 != null && 法阵特效 !== 0) {
      DestroyEffect(法阵特效);
      法阵特效 = null;
    }
    解除塞莉亚R锁定(施法者);
    移除单位指定Buff(施法者, 塞莉亚BuffID.高阶术式蓄力);
    if (!实例.已结束()) 实例.结束("中断");
    注销();
  }
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册塞莉亚R(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "塞莉亚·克莱尔-高阶术式·闭锁（R）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 塞莉亚克莱尔技能配置.R.技能ID,
    获取或创建上下文: function R上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放R高阶术式,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 12,
  });
}

export {};
