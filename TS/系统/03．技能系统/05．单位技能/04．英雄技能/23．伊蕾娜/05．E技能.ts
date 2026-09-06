/** @noSelfInFile */
/**
 * 伊蕾娜 - E：扫帚·远行（A5）
 *
 * - 点目标战斗自身位移，走统一 开始冲锋 封装（含位移封锁检查）。
 * - t0 快照起点/终点/方向/原飞行高度；起飞硬直后进入位移，期间按配置获得有限护盾（非无敌）。
 * - 每个 tick 由位移系统推进坐标；本文件只维护高度与尾迹，不重复叠加旋转矩阵。
 * - 到达终点（完成原因）才结算冲击、登记扫帚路线并记录"远行"见闻；
 *   中断/撞墙/死亡路径只恢复高度、动画与移动状态，不产生终点冲击和见闻。
 * - 中断/死亡：先标记技能实例结束（收束篮子注销尾迹/护盾），再停止位移，
 *   避免同步结束回调误触发终点效果；结束统一恢复 GetUnitFlyHeight 快照值。
 */

import { 伊蕾娜技能配置, 伊蕾娜E配置, 伊蕾娜表现配置, 伊蕾娜变式效果配置, 伊蕾娜模型动作配置, 伊蕾娜音效配置 } from "./00．配置";
import { 播放伊蕾娜阶段动作, 开始伊蕾娜循环动作, 停止伊蕾娜循环动作 } from "./01A．动作表现";
import {
  记录伊蕾娜见闻,
  记录伊蕾娜扫帚路线,
  获取伊蕾娜变式,
  消费伊蕾娜变式用于,
  登记伊蕾娜技能清理,
} from "./02．被动效果";
import type { 战斗技能实例控制器 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/27．战斗技能实例生命周期工厂";

const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string, 伊蕾娜变式?: string) => boolean;
};

const jass = require("jass.common") as any;
const { stringToFourCCSafe, fourCCToStringSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
  fourCCToStringSafe: (this: void, fourcc: number) => string;
};
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitName = jass.GetUnitName as (this: void, unit: any) => string;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, angle: number) => void;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 创建战斗技能实例 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂") as {
  创建战斗技能实例: (this: void, 参数: any) => 战斗技能实例控制器;
};
const { 开始冲锋, 停止位移 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, 单位: any, 参数: any) => number;
  停止位移: (this: void, 位移ID: number, 原因?: string) => boolean;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const {
  读取单位攻击力,
  两点角度,
  单位存活,
  距离XY,
  极坐标X,
  极坐标Y,
} = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  单位存活: (this: void, unit: any) => boolean;
  距离XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  极坐标X: (this: void, x: number, angleDeg: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angleDeg: number, distance: number) => number;
};
const { 获取坐标范围敌人 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  /** 注意：公共实现为 (中心来源单位, X, Y, 半径) */
  获取坐标范围敌人: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, u: any, 来源: string) => boolean;
  移除单位暂停: (this: void, u: any, 来源: string) => boolean;
};
const { SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setSlow: (this: void, sourceUnit: any, u: any, attackSlow: number, moveSlow: number, time: number, effectSourceName?: string, effectSourceType?: string) => void;
};
const { 开始护盾, 移除护盾 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统") as {
  开始护盾: (this: void, 单位: any, 参数: any) => number;
  移除护盾: (this: void, 护盾ID: number) => boolean;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = 伊蕾娜技能配置.单位类型ID;
const E技能类型ID = stringToFourCCSafe(伊蕾娜技能配置.E.技能ID) as number;
const E硬直来源 = "伊蕾娜-E硬直";

//=============================================================================
// 到达结算
//=============================================================================

/** 终点冲击 + 扫帚路线 + 远行见闻（只在完成原因时调用）。 */
function 结算E到达(this: void, 施法者: any, 实例ID: number | undefined, 数据: any): void {
  const X = GetUnitX(施法者);
  const Y = GetUnitY(施法者);
  debugLogForce("伊蕾娜-E", "结束", "原因", "完成", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "实例", 实例ID ?? "-", "X", Math.floor(X), "Y", Math.floor(Y));
  播放伊蕾娜阶段动作(施法者, 伊蕾娜模型动作配置.技能动作.E落地);

  // 冲击（AOE + 真实减速）
  const 敌人列表 = 获取坐标范围敌人(施法者, X, Y, 伊蕾娜E配置.冲击半径);
  const 冲击伤害 = 读取单位攻击力(施法者) * 伊蕾娜E配置.冲击伤害攻击力倍率;
  for (let i = 0; i < 敌人列表.length; i++) {
    const 敌人 = 敌人列表[i];
    if (!单位存活(敌人)) {
      debugLogForce("伊蕾娜-E", "命中失败", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "原因", "目标无效", "目标", GetUnitName(敌人), "handle", 敌人);
      continue;
    }
    debugLogForce("伊蕾娜-E", "命中", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(E技能类型ID), "目标", GetUnitName(敌人), "handle", 敌人, "X", Math.floor(GetUnitX(敌人)), "Y", Math.floor(GetUnitY(敌人)), "伤害", Math.floor(冲击伤害), "标签", "伊蕾娜-扫帚冲击");
    造成技能伤害({
      来源: 施法者,
      目标: 敌人,
      伤害: 冲击伤害,
      伤害类型: DAMAGE_TYPE_MAGIC,
      攻击类型: ATTACK_TYPE_NORMAL,
      武器类型: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: E技能类型ID,
      技能实例ID: 实例ID,
      标签: "伊蕾娜-扫帚冲击",
      伤害形态: "AOE",
      参与技能伤害加成: true,
    });
    SFB_setSlow(
      施法者,
      敌人,
      0,
      伊蕾娜E配置.冲击减速比例,
      伊蕾娜E配置.冲击减速秒,
      "伊蕾娜-落地风压",
      "技能",
    );
  }
  if (数据.灰烬爆发) {
    // 灰烬爆发视觉（dustwave 尘浪；与 Q 灰烬爆发共用同一表现条目）
    const 灰烬特效 = 创建点特效({
      模型路径: 伊蕾娜表现配置.灰烬爆发.模型路径,
      RGB: 伊蕾娜表现配置.灰烬爆发.RGB,
      X,
      Y,
      Z: 伊蕾娜表现配置.灰烬爆发.高度,
      缩放: 伊蕾娜表现配置.灰烬爆发.缩放,
      持续秒: 伊蕾娜表现配置.灰烬爆发.持续秒,
    });
    void 灰烬特效;
    const 灰烬敌人 = 获取坐标范围敌人(施法者, X, Y, 伊蕾娜变式效果配置.灰烬_爆发半径);
    const 灰烬伤害 = 读取单位攻击力(施法者) * 伊蕾娜变式效果配置.灰烬_爆发伤害攻击力倍率;
    for (let i = 0; i < 灰烬敌人.length; i++) {
      const 敌人 = 灰烬敌人[i];
      if (!单位存活(敌人)) {
        debugLogForce("伊蕾娜-E", "命中失败", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "原因", "目标无效", "目标", GetUnitName(敌人), "handle", 敌人);
        continue;
      }
      debugLogForce("伊蕾娜-E", "命中", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(E技能类型ID), "目标", GetUnitName(敌人), "handle", 敌人, "X", Math.floor(GetUnitX(敌人)), "Y", Math.floor(GetUnitY(敌人)), "伤害", Math.floor(灰烬伤害), "标签", "伊蕾娜-远行灰烬爆发");
      造成技能伤害({
        来源: 施法者,
        目标: 敌人,
        伤害: 灰烬伤害,
        伤害类型: DAMAGE_TYPE_MAGIC,
        攻击类型: ATTACK_TYPE_NORMAL,
        武器类型: WEAPON_TYPE_WHOKNOWS,
        来源类型: "单位技能",
        技能ID: E技能类型ID,
        技能实例ID: 实例ID,
        标签: "伊蕾娜-远行灰烬爆发",
        伤害形态: "AOE",
        参与技能伤害加成: true,
      });
    }
  }

  // 落地波纹（一次性表现）
  const 波纹 = 创建点特效({
    模型路径: 伊蕾娜表现配置.E落地波纹.模型路径,
    RGB: 伊蕾娜表现配置.E落地波纹.RGB,
    X,
    Y,
    Z: 伊蕾娜表现配置.E落地波纹.高度,
    缩放: 伊蕾娜E配置.冲击半径 / 伊蕾娜表现配置.E落地波纹.基准半径 * 伊蕾娜表现配置.E落地波纹.基准缩放,
    持续秒: 伊蕾娜表现配置.E落地波纹.持续秒,
  });
  void 波纹;
  // 落地音（坐标=落点；只在完成原因的到达结算播一次，参数配置驱动）
  Sound3DII_CooPlayReuse(伊蕾娜音效配置.E落地.路径, X, Y, 伊蕾娜音效配置.E落地.高度, 伊蕾娜音效配置.E落地.裁断距离);

  // 路线（短寿命，供 Q/R 读取）
  记录伊蕾娜扫帚路线(施法者, 数据.起点X, 数据.起点Y, 数据.终点X, 数据.终点Y, 数据.方向角);
  // 见闻最后记录
  记录伊蕾娜见闻(施法者, "远行", 实例ID);
  debugLogForce("伊蕾娜-E", "到达", "记录远行见闻", "实例", 实例ID ?? "-");
}

//=============================================================================
// 施放流程
//=============================================================================

function 释放E扫帚远行(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) {
    debugLogForce("伊蕾娜-E", "释放被拒", "原因", "施法者无效", "handle", 施法者);
    return;
  }
  debugLogForce("伊蕾娜-E", "释放", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(E技能类型ID), "实例", 技能实例ID ?? "-", "目标", "点施放");

  // t0 快照
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 起点X = GetUnitX(施法者);
  const 起点Y = GetUnitY(施法者);
  const 方向角 = 两点角度(起点X, 起点Y, 目标X, 目标Y);

  const 数据: any = {
    技能实例ID,
    起点X,
    起点Y,
    方向角,
    终点X: 0,
    终点Y: 0,
    原飞行高度: GetUnitFlyHeight(施法者),
    护盾ID: 0,
    位移ID: 0,
    飞行动作守护: null,
    灰烬爆发: false,
  };

  let 注销统一清理: (this: void) => void = function E空注销(this: void): void {};
  const 实例 = 创建战斗技能实例({
    技能键: "E扫帚远行",
    施法者,
    技能实例ID,
    数据,
    结束回调: function E实例结束(this: void, 原因: string, _控制器: any): void {
      注销统一清理();
      if (原因 !== "完成" && 单位存活(施法者)) {
        播放伊蕾娜阶段动作(施法者, 伊蕾娜模型动作配置.技能动作.E中断恢复);
      }
    },
  });
  注销统一清理 = 登记伊蕾娜技能清理(施法者, "E远行-" + 实例.实例ID, function E统一清理(this: void): void {
    if (!实例.已结束()) 实例.结束("中断");
  });
  实例.登记自定义清理("E公共收口", function E公共收口(this: void): void {
    if (数据.位移ID > 0) {
      停止位移(数据.位移ID, "中断");
      数据.位移ID = 0;
    }
    if (数据.护盾ID !== 0) {
      移除护盾(数据.护盾ID);
      数据.护盾ID = 0;
    }
    停止伊蕾娜循环动作(数据.飞行动作守护);
    数据.飞行动作守护 = null;
    if (施法者 != null && 施法者 !== 0) {
      SetUnitFlyHeight(施法者, 数据.原飞行高度, 伊蕾娜E配置.高度恢复率);
      移除单位暂停(施法者, E硬直来源);
    }
  });

  // D 变式预读：迅行页增加本次位移距离（真正起飞后才消费）
  const 预读变式 = 获取伊蕾娜变式(施法者);
  const 用迅行 = 预读变式 === "迅行";
  const 用灰烬 = 预读变式 === "灰烬";
  let 位移距离 = 伊蕾娜E配置.位移距离;
  if (用迅行) 位移距离 = 位移距离 * 伊蕾娜变式效果配置.迅行_E位移距离倍率;

  // 点击过近时不小步挪动：以到点实际距离为准（不超过加成后的最大位移）
  const 到点距离 = 距离XY(起点X, 起点Y, 目标X, 目标Y);
  const 最终距离 = 到点距离 < 位移距离 ? 到点距离 : 位移距离;
  数据.终点X = 极坐标X(起点X, 方向角, 最终距离);
  数据.终点Y = 极坐标Y(起点Y, 方向角, 最终距离);

  // 时序：先暂停 → 同阶段播起飞动作 → 硬直结束进入位移
  if (添加单位暂停(施法者, E硬直来源)) {
    SetUnitFacing(施法者, 方向角);
    播放伊蕾娜阶段动作(施法者, 伊蕾娜模型动作配置.技能动作.E起飞);
  }

  实例.登记延迟回调(addDelayedCallback(伊蕾娜E配置.硬直秒 * 1000, function E起飞(this: void): void {
    if (实例.已结束()) return;
    移除单位暂停(施法者, E硬直来源);
    if (!单位存活(施法者)) return;

    // 起飞风压（一次性）
    const 风压 = 创建点特效({
      模型路径: 伊蕾娜表现配置.E起飞风压.模型路径,
      RGB: 伊蕾娜表现配置.E起飞风压.RGB,
      X: GetUnitX(施法者),
      Y: GetUnitY(施法者),
      Z: 伊蕾娜表现配置.E起飞风压.高度,
      缩放: 伊蕾娜表现配置.E起飞风压.缩放,
      持续秒: 伊蕾娜表现配置.E起飞风压.持续秒,
    });
    void 风压;

    // 有限保护：飞行期间的短护盾（数值待平衡；非无敌）
    数据.护盾ID = 开始护盾(施法者, {
      类型: 0,
      数值: 读取单位攻击力(施法者) * 伊蕾娜E配置.位移护盾攻击力倍率,
      持续时间: (最终距离 / 伊蕾娜E配置.每秒速度) + 0.3,
      来源单位: 施法者,
      标签: "伊蕾娜-扫帚远行",
      显示护盾条: true,
    });

    // 高度抬升（起飞）
    SetUnitFlyHeight(施法者, 伊蕾娜E配置.飞行高度, 伊蕾娜E配置.高度恢复率);

    debugLogForce("伊蕾娜-E", "位移", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "类型", "冲锋", "距离", Math.floor(最终距离));
    const 位移ID = 开始冲锋(施法者, {
      距离: 最终距离,
      角度: 方向角,
      每秒速度: 伊蕾娜E配置.每秒速度,
      检查地形: true,
      暂停单位: false,
      位移特效: "",
      动画名: 伊蕾娜模型动作配置.技能动作.E飞行.名称,
      开始回调: function E飞行动作开始(this: void): void {
        数据.飞行动作守护 = 开始伊蕾娜循环动作(施法者, 伊蕾娜模型动作配置.技能动作.E飞行);
      },
      结束回调: function E位移结束(this: void, 移动单位: any, 原因: string, _位移ID: number, _命中目标?: any): void {
        // 高度恢复在所有结束路径都要执行
        if (移动单位 != null && 移动单位 !== 0 && 单位存活(移动单位)) {
          SetUnitFlyHeight(移动单位, 数据.原飞行高度, 伊蕾娜E配置.高度恢复率);
        }
        const 是完成 = 原因 === "完成";
        const 已收束 = 实例.已结束();
        if (!已收束 && 是完成) {
          // 先标记实例收束再可能触发后续同步逻辑，终点冲击只走这一条路
          结算E到达(施法者, 技能实例ID, 数据);
          实例.完成();
        } else if (!已收束) {
          实例.结束(原因 === "死亡" || 原因 === "主单位死亡" ? "施法者死亡" : "中断");
        }
      },
    });
    数据.位移ID = 位移ID;

    if (位移ID > 0) {
      播放英雄技能喊话(施法者, "伊蕾娜", 伊蕾娜技能配置.E.技能ID);
      // 起飞音（单位=施法者；冲锋位移真正建立后的扫帚起飞时点一次，参数配置驱动）
      Sound3DII_UnitPlayReuse(伊蕾娜音效配置.E起飞.路径, 施法者, 伊蕾娜音效配置.E起飞.裁断距离);
      // 迅行/灰烬分支真正进入后才消费；灰烬在到达时追加爆发。
      if (用迅行 || 用灰烬) {
        const 已消费 = 消费伊蕾娜变式用于(施法者, "E");
        数据.灰烬爆发 = 已消费 === "灰烬";
      }
      // 飞行尾迹：低频跟随创建（星光/飞行轨迹交替），随实例收束一并注销
      let 尾迹计数 = 0;
      实例.登记周期回调(addPeriodicCallback(
        伊蕾娜E配置.尾迹间隔毫秒,
        function E尾迹(this: void): void {
          if (实例.已结束() || !单位存活(施法者)) return;
          尾迹计数 += 1;
          const 表现 = 尾迹计数 % 2 === 0 ? 伊蕾娜表现配置.E飞行轨迹 : 伊蕾娜表现配置.E星光轨迹;
          const 星迹 = 创建点特效({
            模型路径: 表现.模型路径,
            RGB: 表现.RGB,
            X: GetUnitX(施法者),
            Y: GetUnitY(施法者),
            Z: 表现.高度,
            缩放: 表现.缩放,
            持续秒: 表现.持续秒,
          });
          void 星迹;
        },
      ));

    } else {
      // 位移被禁锢类 Buff 拦截等：不进入分支，恢复状态即可
      SetUnitFlyHeight(施法者, 数据.原飞行高度, 伊蕾娜E配置.高度恢复率);
      实例.结束("中断");
    }
  }));

}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册伊蕾娜E(this: void): void {
  debugLogForce("伊蕾娜-E", "注册", "名称", "注册伊蕾娜E");
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "伊蕾娜-扫帚·远行（E）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 伊蕾娜技能配置.E.技能ID,
    获取或创建上下文: function E上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放E扫帚远行,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 6,
  });
}

export {};
