/** @noSelfInFile */
/**
 * 伊蕾娜 - D：旅途魔法变式·即兴选择（A6）
 *
 * - 无目标主动壳；按固定顺序在 迅行 → 镜界 → 灰烬 中循环切换唯一当前变式。
 * - 只维护一套变式状态（见闻容器承载），不创建三套并行 Buff。
 * - R 蓄力期间锁定快照：设置被拒，重复 D 不改写本次 R。
 * - 消费由各受益技能在分支真正进入后调用 消费伊蕾娜变式用于 完成；
 *   到期、死亡、场景清理统一清空并熄灭提示。
 * - 不制作魔法书、翻页模型或角色语音：切换提示仅一个短寿命 feastaura 符文。
 */

import { 伊蕾娜技能配置, 伊蕾娜变式配置, 伊蕾娜表现配置, 伊蕾娜模型动作配置, 伊蕾娜音效配置 } from "./00．配置";
import { 播放伊蕾娜阶段动作 } from "./01A．动作表现";
import { 设置伊蕾娜变式, 获取伊蕾娜变式 } from "./02．被动效果";

const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string, 伊蕾娜变式?: string) => boolean;
};

const jass = require("jass.common") as any;
const { fourCCToStringSafe, stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  fourCCToStringSafe: (this: void, fourcc: number) => string;
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitName = jass.GetUnitName as (this: void, unit: any) => string;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;

const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = 伊蕾娜技能配置.单位类型ID;

//=============================================================================
// 变式切换
//=============================================================================

function 计算下一个变式(this: void, 当前: string | null): string {
  const 列表 = 伊蕾娜变式配置.变式列表 as readonly string[];
  if (当前 == null || 列表.indexOf(当前) < 0) return 列表[0];
  const 下一索引 = (列表.indexOf(当前) + 1) % 列表.length;
  return 列表[下一索引];
}

function 释放D旅途魔法变式(this: void, _context: any, 施法者: any, _技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) {
    debugLogForce("伊蕾娜-D", "释放被拒", "原因", "施法者无效", "handle", 施法者);
    return;
  }
  debugLogForce("伊蕾娜-D", "释放", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(stringToFourCCSafe(伊蕾娜技能配置.D.技能ID)), "实例", _技能实例ID ?? "-", "目标", "自身");

  const 当前 = 获取伊蕾娜变式(施法者);
  const 下一个 = 计算下一个变式(当前);
  if (!设置伊蕾娜变式(施法者, 下一个 as any)) {
    // R 蓄力期间被拒：不刷新任何提示
    debugLogForce("伊蕾娜-D", "释放被拒", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "原因", "R锁定变式", "目标变式", 下一个);
    return;
  }
  debugLogForce("伊蕾娜-D", "状态", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "切换变式", 下一个);
  播放英雄技能喊话(施法者, "伊蕾娜", 伊蕾娜技能配置.D.技能ID, 下一个);
  // 变式切换成功音（单位=施法者；R 锁定拒绝分支已在上方 return，不会播放，参数配置驱动）
  Sound3DII_UnitPlayReuse(伊蕾娜音效配置.D切换.路径, 施法者, 伊蕾娜音效配置.D切换.裁断距离);
  播放伊蕾娜阶段动作(施法者, 伊蕾娜模型动作配置.技能动作.D切换);

  // 切换提示：短暂符文（角色身边），不创建书本/翻页表现
  const 提示 = 创建点特效({
    模型路径: 伊蕾娜表现配置.D变式提示.模型路径,
   RGB: 伊蕾娜表现配置.D变式提示.RGB,
       X: GetUnitX(施法者),
    Y: GetUnitY(施法者),
    Z: 伊蕾娜表现配置.D变式提示.高度,
    缩放: 伊蕾娜表现配置.D变式提示.缩放,
    持续秒: 伊蕾娜表现配置.D变式提示.持续秒,
  });
  void 提示;
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册伊蕾娜D(this: void): void {
  debugLogForce("伊蕾娜-D", "注册", "名称", "注册伊蕾娜D");
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "伊蕾娜-旅途魔法变式（D）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 伊蕾娜技能配置.D.技能ID,
    获取或创建上下文: function D上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放D旅途魔法变式,
    创建独立技能实例: false,
  });
}

export {};
