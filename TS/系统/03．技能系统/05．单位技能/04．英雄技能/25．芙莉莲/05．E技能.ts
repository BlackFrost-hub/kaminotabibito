/** @noSelfInFile */
/**
 * 芙莉莲 E：飞行魔法·高处观察（B3：A5；R002.2 修复）
 *
 * 公共自身位移（必须传 角度，否则公共接口返回 0 不移动）；中断/死亡先标记结束再停止位移；
 * 位移结束回调按 原因 过滤（仅"完成"结算落点；中断/死亡/主单位死亡只清理）；
 * 到达后观察 Tick 按 观察持续秒 继续运行（到期停 Tick/销毁闪电/恢复高度）；
 * 观察目标死亡即时清理记录、闪电创建失败不登记；CWBM 闪电连接高处坐标，周期只更新端点；
 * 起飞动作槽与观察保持动作槽均接入（位移到达后启动观察守护，避免提前覆盖起飞动作）。
 */

import {
  芙莉莲技能配置,
  芙莉莲E配置,
  芙莉莲表现配置,
} from "./00．配置";

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
const { 开始冲锋, 停止位移 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, 单位: any, 参数: any) => number;
  停止位移: (this: void, 位移ID: number, 原因: string) => void;
};
const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 读取单位攻击力, 单位存活, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 播放限时动作, 开始循环守护, 停止循环守护, 芙莉莲动作槽 } = require("./01A．动作表现") as {
  播放限时动作: (this: void, 英雄: any, 槽: any, 登记名: string) => void;
  开始循环守护: (this: void, 英雄: any, 槽: any, 登记名: string) => any;
  停止循环守护: (this: void, 句柄: any) => void;
  芙莉莲动作槽: { E起飞: any; E观察保持: any };
};
const {
  是芙莉莲,
  记录芙莉莲活动,
  施加解析,
  提供演算普攻,
  登记芙莉莲清理,
} = require("./02．被动效果") as {
  是芙莉莲: (this: void, unit: any) => boolean;
  记录芙莉莲活动: (this: void, 英雄: any) => void;
  施加解析: (this: void, 芙莉莲: any, 目标: any, 类型: "攻击" | "防御" | "位置") => void;
  提供演算普攻: (this: void, 芙莉莲: any) => void;
  登记芙莉莲清理: (this: void, 英雄: any, 名称: string, 清理: () => void) => void;
};
// 花田联动（D 模块运行时 require 防循环依赖；E 释放时消费花田修正）
const 花田联动 = require("./07．D技能") as {
  尝试消费花田修正?: (this: void, 芙莉莲: any) => boolean;
  在花田内?: (this: void, 芙莉莲: any) => boolean;
};
const { 芙莉莲D配置 } = require("./00．配置") as {
  芙莉莲D配置: { 修正E落点倍率加成: number };
};

const 英雄单位类型ID = stringToFourCCSafe(芙莉莲技能配置.单位类型ID);
const E技能ID = stringToFourCCSafe(芙莉莲技能配置.E.技能ID);
const E配置 = 芙莉莲E配置;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetHandleId = jass.GetHandleId as (this: void, h: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitZ = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const AddLightningEx = jass.AddLightningEx as (this: void, codeName: string, checkVisibility: boolean, x1: number, y1: number, z1: number, x2: number, y2: number, z2: number) => any;
const MoveLightningEx = jass.MoveLightningEx as (this: void, lightning: any, checkVisibility: boolean, x1: number, y1: number, z1: number, x2: number, y2: number, z2: number) => boolean;
const DestroyLightning = jass.DestroyLightning as (this: void, lightning: any) => boolean;

interface 观察闪电 {
  目标: any;
  句柄: any;
}

interface E数据 {
  起点X: number;
  起点Y: number;
  起点高度: number;
  终点X: number;
  终点Y: number;
  方向角: number;
  位移ID: number;
  减伤ID: number;
  观察TickID: number;
  观察闪电列表: 观察闪电[];
  /** 花田修正已消费标志（落点结算时消费） */
  花田修正: boolean;
  /** 观察保持循环守护句柄（结束/中断统一停止） */
  观察守护: any;
  /** 位移结束（到达/中断）后观察期截止时刻（到达后 = now + 观察持续秒） */
  观察截止: number;
  已结束: boolean;
  已结算: boolean;
}

function 结算E落点(this: void, 施法者: any, 技能实例ID: number | undefined, 数据: E数据): void {
  if (数据.已结算) return;
  数据.已结算 = true;
  // 花田修正：E 在花田内释放消费一次修正（落点冲击倍率加成）
  let 冲击倍率 = E配置.落点冲击倍率;
  if (数据.花田修正 && 花田联动.尝试消费花田修正 != null && 花田联动.尝试消费花田修正(施法者)) {
    冲击倍率 += 芙莉莲D配置.修正E落点倍率加成;
  }
  // 落点魔力冲击（真实半径判定 + 敌人筛选）
  const 组 = jass.CreateGroup() as any;
  jass.GroupEnumUnitsInRange(组, 数据.终点X, 数据.终点Y, E配置.落点冲击半径, null);
  while (true) {
    const u = jass.FirstOfGroup(组) as any;
    if (u == null || u === 0) break;
    jass.GroupRemoveUnit(组, u);
    if (u === 施法者 || !单位存活(u)) continue;
    if (!IsUnitEnemy(u, GetOwningPlayer(施法者))) continue;
    造成技能伤害({
      来源: 施法者,
      目标: u,
      伤害: 读取单位攻击力(施法者) * 冲击倍率,
      伤害类型: DAMAGE_TYPE_NORMAL,
      攻击类型: ATTACK_TYPE_NORMAL,
      武器类型: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: E技能ID,
      技能实例ID,
      标签: "芙莉莲-E落点冲击",
      伤害形态: "AOE",
      参与技能伤害加成: true,
    });
    // 落点敌人施加位置解析
    施加解析(施法者, u, "位置");
  }
  jass.DestroyGroup(组);
  // 落点观察标记表现（参数配置驱动）
  创建点特效({
    模型路径: 芙莉莲表现配置.E观察落点,
    X: 数据.终点X,
    Y: 数据.终点Y,
    Z: 芙莉莲表现配置.特效参数.E观察落点.高度,
    面向角度: 0,
    动画索引: 0,
    缩放: 芙莉莲表现配置.特效参数.E观察落点.缩放,
    持续秒: 芙莉莲表现配置.特效参数.E观察落点.持续秒,
  });
  // E 成功 → 提供一次演算普攻
  提供演算普攻(施法者);
}

function 清理观察闪电(this: void, 数据: E数据): void {
  for (let i = 0; i < 数据.观察闪电列表.length; i++) {
    const 闪电 = 数据.观察闪电列表[i];
    if (闪电.句柄 != null && 闪电.句柄 !== 0) DestroyLightning(闪电.句柄);
  }
  数据.观察闪电列表 = [];
}

/** 完成收尾（停观察 Tick/销毁闪电/停动作守护/注销减伤/恢复高度；幂等） */
function 完成E收尾(this: void, 施法者: any, 数据: E数据): void {
  // 观察保持动作守护停止（恢复 stand 与动画速度）
  if (数据.观察守护 != null) {
    停止循环守护(数据.观察守护);
    数据.观察守护 = null;
  }
  // 位移减伤注销
  if (数据.减伤ID !== 0) {
    unregisterDamageModifier(数据.减伤ID);
    数据.减伤ID = 0;
  }
  // 观察 Tick 停止 + 闪电销毁
  if (数据.观察TickID !== 0) {
    removePeriodicCallback(数据.观察TickID);
    数据.观察TickID = 0;
  }
  清理观察闪电(数据);
  // 恢复飞行高度（任何结束路径必须恢复）
  if (施法者 != null && 施法者 !== 0) {
    SetUnitFlyHeight(施法者, 数据.起点高度, E配置.高度变化率);
  }
}

/**
 * 结束位移阶段：自然到达 → 结算落点 + 进入观察期（观察持续秒 后收尾）；
 * 中断/死亡/主单位死亡 → 只清理不结算。
 */
function 结束E(this: void, 施法者: any, 技能实例ID: number | undefined, 数据: E数据, 自然到达: boolean): void {
  if (数据.已结束) return;
  // 先标记结束再停止位移（停止位移同步触发结束回调，此时必须已标记结束）
  数据.已结束 = true;
  if (数据.位移ID !== 0) {
    停止位移(数据.位移ID, "中断");
    数据.位移ID = 0;
  }
  if (自然到达) {
    结算E落点(施法者, 技能实例ID, 数据);
    // 位移期减伤结束（观察期不再减免）
    if (数据.减伤ID !== 0) {
      unregisterDamageModifier(数据.减伤ID);
      数据.减伤ID = 0;
    }
    // 观察期：Tick 与闪电继续按 观察持续秒 运行（配置驱动），到期统一收尾
    数据.观察截止 = getGameTime() + E配置.观察持续秒;
    // 观察保持动作：位移到达/撞墙后启动（持续=观察持续秒，与观察截止起算点对齐；
    // 不再用固定延迟回调，避免位移未到达时提前覆盖起飞动作）
    if (数据.观察守护 == null) {
      数据.观察守护 = 开始循环守护(
        施法者,
        { ...芙莉莲动作槽.E观察保持, 持续秒: E配置.观察持续秒 },
        "芙莉莲E观察",
      );
    }
  } else {
    完成E收尾(施法者, 数据);
  }
}

/** 观察期纳入实例生命周期：观察截止回调统一收尾并完成实例（打断/死亡由实例收束清理） */
function E安排观察期收尾(this: void, 施法者: any, 控制器: any, 数据: E数据): void {
  const 观察截止ID = addDelayedCallback(E配置.观察持续秒 * 1000, function E观察到期(this: void): void {
    // 已结束表示位移阶段已结束，观察期正是此时收尾；不能因此跳过实例完成。
    完成E收尾(施法者, 数据);
    控制器.完成();
  });
  控制器.登记延迟回调(观察截止ID);
}

function 释放E(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (!是芙莉莲(施法者)) return;
  // 重复 E：已有活跃 E 实例时忽略
  if (查询战斗技能实例(施法者, "芙莉莲E").length > 0) return;
  记录芙莉莲活动(施法者);
  // 花田修正快照：释放时在花田内（落点结算时消费）
  const 花田修正 = 花田联动.尝试消费花田修正 != null && 花田联动.在花田内 != null ? 花田联动.在花田内(施法者) : false;
  // 起飞动作（送杖候选；观察保持守护延迟到起飞后开始，避免同帧覆盖）
  播放限时动作(施法者, 芙莉莲动作槽.E起飞, "芙莉莲E起飞");
  // 快照：起点/终点/方向/起点高度
  const 起点X = GetUnitX(施法者);
  const 起点Y = GetUnitY(施法者);
  const 数据: E数据 = {
    起点X,
    起点Y,
    起点高度: GetUnitZ(施法者),
    终点X: GetSpellTargetX(),
    终点Y: GetSpellTargetY(),
    方向角: 两点角度(起点X, 起点Y, GetSpellTargetX(), GetSpellTargetY()),
    位移ID: 0,
    减伤ID: 0,
    观察TickID: 0,
    观察闪电列表: [],
    花田修正,
    观察守护: null,
    观察截止: 0,
    已结束: false,
    已结算: false,
  };

  const 控制器 = 创建战斗技能实例({
    技能键: "芙莉莲E",
    施法者,
    技能实例ID,
    数据,
    结束回调: function E结束(this: void, _原因: string, _c: any): void {
      // 中断/死亡：先标记结束再停止位移（防位移结束回调误触发落点结算）；不结算落点
      // 自然到达后数据.已结束也为 true，但实例仍可能因死亡/场景清理收束，必须继续清理观察资源。
      if (数据.已结束) {
        完成E收尾(施法者, 数据);
        return;
      }
      数据.已结束 = true;
      if (数据.位移ID !== 0) {
        停止位移(数据.位移ID, "中断");
        数据.位移ID = 0;
      }
      完成E收尾(施法者, 数据);
    },
  });

  // 起飞：抬升飞行高度
  SetUnitFlyHeight(施法者, 数据.起点高度 + E配置.飞行高度, E配置.高度变化率);
  // 起飞风压表现（参数配置驱动）
  创建点特效({
    模型路径: 芙莉莲表现配置.E起落风压,
    X: 起点X,
    Y: 起点Y,
    Z: 芙莉莲表现配置.特效参数.E起落风压.高度,
    面向角度: 数据.方向角,
    动画索引: 0,
    缩放: 芙莉莲表现配置.特效参数.E起落风压.缩放,
    持续秒: 芙莉莲表现配置.特效参数.E起落风压.持续秒,
  });

  // 位移期间有限减伤（不无敌）
  数据.减伤ID = registerDamageModifier(function E位移减伤(this: void, context: any): number {
    if (数据.已结束) return context.currentDamage;
    if (context.target !== 施法者) return context.currentDamage;
    if (context.currentDamage <= 0) return context.currentDamage;
    return context.currentDamage * (1 - E配置.位移减伤比例);
  }, 45);

  // 观察 Tick（观察保持动作在位移到达/撞墙时启动，见 结束E；起飞限时动作自行恢复 stand）（0.25s）：可见合法敌人 → 闪电连接 + 位置解析（保守实现：项目无统一反隐接口，
  // 隐身/幻影/陷阱的专门检测登记为剩余项，不直接全图显隐）
  const 起点偏移 = 芙莉莲表现配置.特效参数.E闪电.起点高度偏移;
  const 终点高度 = 芙莉莲表现配置.特效参数.E闪电.终点高度;
  数据.观察TickID = addPeriodicCallback(250, function E观察Tick(this: void): void {
    if (数据.已结束) {
      // 观察期结束：停 Tick、销毁闪电、恢复高度
      if (getGameTime() > 数据.观察截止) 完成E收尾(施法者, 数据);
      return;
    }
    if (!单位存活(施法者)) return;
    const 现X = GetUnitX(施法者);
    const 现Y = GetUnitY(施法者);
    const 高度 = GetUnitZ(施法者);
    // 先清理死亡/失效目标（不占用观察名额）
    for (let i = 数据.观察闪电列表.length - 1; i >= 0; i--) {
      const 闪电 = 数据.观察闪电列表[i];
      if (闪电.目标 == null || 闪电.目标 === 0 || !单位存活(闪电.目标)) {
        if (闪电.句柄 != null && 闪电.句柄 !== 0) DestroyLightning(闪电.句柄);
        数据.观察闪电列表.splice(i, 1);
      }
    }
    // 闪电起点 = 芙莉莲真实高处坐标；终点 = 各观察目标（周期只更新端点；高度参数配置驱动）
    for (let i = 0; i < 数据.观察闪电列表.length; i++) {
      const 闪电 = 数据.观察闪电列表[i];
      MoveLightningEx(闪电.句柄, false, 现X, 现Y, 高度 + 起点偏移, GetUnitX(闪电.目标), GetUnitY(闪电.目标), 终点高度);
    }
    // 新观察目标（上限 5 条闪电）
    if (数据.观察闪电列表.length < 5) {
      const 组 = jass.CreateGroup() as any;
      jass.GroupEnumUnitsInRange(组, 现X, 现Y, E配置.观察半径, null);
      while (true) {
        const u = jass.FirstOfGroup(组) as any;
        if (u == null || u === 0) break;
        jass.GroupRemoveUnit(组, u);
        if (u === 施法者 || !单位存活(u)) continue;
        if (!IsUnitEnemy(u, GetOwningPlayer(施法者))) continue;
        let 已有 = false;
        for (let i = 0; i < 数据.观察闪电列表.length; i++) {
          if (数据.观察闪电列表[i].目标 === u) {
            已有 = true;
            break;
          }
        }
        if (已有) continue;
        const 句柄 = AddLightningEx(芙莉莲表现配置.E观察闪电ID, false, 现X, 现Y, 高度 + 起点偏移, GetUnitX(u), GetUnitY(u), 终点高度);
        // 创建失败不登记（不占用观察名额）
        if (句柄 == null || 句柄 === 0) continue;
        数据.观察闪电列表.push({ 目标: u, 句柄 });
        // 观察到目标 → 施加位置解析
        施加解析(施法者, u, "位置");
        if (数据.观察闪电列表.length >= 5) break;
      }
      jass.DestroyGroup(组);
    }
  });

  // 飞行位移（公共自身位移；必须传 角度，否则公共接口返回 0 不移动；位移特效参数配置驱动）
  数据.位移ID = 开始冲锋(施法者, {
    距离: E配置.位移距离,
    每秒速度: E配置.位移速度,
    角度: 数据.方向角,
    检查地形: true,
    朝向跟随位移: true,
    暂停单位: false,
    位移特效: 芙莉莲表现配置.E起落风压,
    位移特效缩放: 芙莉莲表现配置.特效参数.E起落风压.缩放,
    位移特效高度: 芙莉莲表现配置.特效参数.E起落风压.高度,
    位移特效持续秒: 芙莉莲表现配置.特效参数.E起落风压.持续秒,
    撞墙回调: function E撞墙(this: void, 移动单位: any, _位移ID: number): void {
      if (数据.已结束) return;
      // 撞墙：终点更新为实际停靠位置后再结算，同样进入观察期
      数据.终点X = GetUnitX(移动单位);
      数据.终点Y = GetUnitY(移动单位);
      结束E(施法者, 技能实例ID, 数据, true);
      E安排观察期收尾(施法者, 控制器, 数据);
    },
    结束回调: function E位移结束(this: void, 单位: any, 原因: string, _位移ID: number): void {
      if (数据.已结束) return;
      // 结束原因过滤：仅"完成"按到达结算落点并进入观察期；中断/死亡/主单位死亡只清理不结算并立即完成实例
      if (原因 === "完成") {
        // 到达终点：终点取实际落点；观察期纳入实例生命周期（观察截止回调统一收尾+完成）
        数据.终点X = GetUnitX(单位);
        数据.终点Y = GetUnitY(单位);
        结束E(施法者, 技能实例ID, 数据, true);
        E安排观察期收尾(施法者, 控制器, 数据);
      } else {
        结束E(施法者, 技能实例ID, 数据, false);
        控制器.完成();
      }
    },
  });
  // 位移启动失败（返回 0）：立即收尾清理，不残留减伤/观察周期/闪电
  if (数据.位移ID === 0) {
    完成E收尾(施法者, 数据);
    控制器.完成();
  }
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册芙莉莲E(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "芙莉莲-飞行魔法·高处观察（E）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 芙莉莲技能配置.E.技能ID,
    获取或创建上下文: function E上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放E,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: (E配置.位移距离 / E配置.位移速度) + E配置.观察持续秒 + 2,
  });
}
