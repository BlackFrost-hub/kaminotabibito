/** @noSelfInFile */

import {
  朱雀院椿技能配置,
  朱雀院椿表现配置,
  朱雀院椿动作配置,
  朱雀院椿动作槽,
  朱雀院椿W配置,
  朱雀院椿被动配置,
  朱雀院椿音效配置,
} from "./00．配置";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
};
const { getGameTime, addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 创建战斗技能实例, 查询战斗技能实例 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂") as {
  创建战斗技能实例: (this: void, 参数: any) => any;
  查询战斗技能实例: (this: void, 施法者: any, 技能键: string) => any[];
};
const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
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
const { 获取扇形区域单位 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域") as {
  获取扇形区域单位: (this: void, 参数: any) => any[];
};
const { 单位是否在来源正面扇区, 角度差绝对值 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.08．方位判定工具") as {
  单位是否在来源正面扇区: (this: void, 来源: any, 目标: any, 扇区角度: number) => boolean;
  角度差绝对值: (this: void, a: number, b: number) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { createUnitEffect, destroyUnitEffect, 创建点特效, 设置特效缩放 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
  destroyUnitEffect: (this: void, unit: any, effectKey?: string) => void;
  创建点特效: (this: void, 参数: any) => any;
  设置特效缩放: (this: void, effect: any, scale: number) => void;
};
const { Sound3DII_UnitPlayReuse, Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string) => boolean;
};
const {
  是朱雀院椿,
  创建反击准备,
  恢复VF,
  获取姿态,
  登记椿清理,
  播放椿动作,
} = require("./02．被动效果") as {
  是朱雀院椿: (this: void, unit: any) => boolean;
  创建反击准备: (this: void, 英雄: any, 方向: number, 来源: any) => void;
  恢复VF: (this: void, 英雄: any, 量: number) => boolean;
  获取姿态: (this: void, 英雄: any) => string;
  登记椿清理: (this: void, 英雄: any, 名称: string, 清理: () => void) => void;
  播放椿动作: (this: void, 英雄: any, 槽: { 索引: number; 持续秒: number }) => void;
};
const 联动R = require("./06．R技能") as {
  椿R蓄力中?: (this: void, 英雄: any) => boolean;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(朱雀院椿技能配置.单位类型ID);
const W技能ID = stringToFourCCSafe(朱雀院椿技能配置.W.技能ID);
const W配置 = 朱雀院椿W配置;
const 招架特效键 = "朱雀院椿W招架";

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;

interface W数据 {
  窗口开始: number;
  方向角: number;
  修饰ID: number;
  已招架: boolean;
  已结束: boolean;
  招架来源: any;
}

function 结算W反击(this: void, 施法者: any, 技能实例ID: number | undefined, 数据: W数据, 完美: boolean): void {
  debugLogForce("椿-W", "伤害", "标签", "朱雀院椿-W反击", "目标", 数据.招架来源, "数值", 读取单位攻击力(施法者) * W配置.反击伤害倍率);
  播放椿动作(施法者, 朱雀院椿动作槽.W成功反击);
  const 来源 = 数据.招架来源;
  if (来源 == null || 来源 === 0 || !单位存活(来源)) {
    结束W招架(施法者, 技能实例ID, 数据);
    return;
  }
  const 攻击力 = 读取单位攻击力(施法者);
  造成技能伤害({
    来源: 施法者,
    目标: 来源,
    伤害: 攻击力 * W配置.反击伤害倍率,
    伤害类型: DAMAGE_TYPE_NORMAL,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: W技能ID,
    技能实例ID,
    标签: "朱雀院椿-W反击",
    伤害形态: "单体",
    参与技能伤害加成: true,
  });
  // 二刀攻势完美招架：来源两侧各一道短刀光
  if (完美 && 获取姿态(施法者) === "二刀") {
    造成技能伤害({
      来源: 施法者,
      目标: 来源,
      伤害: 攻击力 * W配置.二刀两侧刀光倍率,
      伤害类型: DAMAGE_TYPE_NORMAL,
      攻击类型: ATTACK_TYPE_NORMAL,
      武器类型: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: W技能ID,
      技能实例ID,
      标签: "朱雀院椿-W两侧刀光",
      伤害形态: "单体",
      参与技能伤害加成: true,
    });
  }
  // 完美招架特效
  if (完美) {
    // 完美招架音（完美招架分支；单位=施法者，参数配置驱动）
    Sound3DII_UnitPlayReuse(朱雀院椿音效配置.W完美招架.路径, 施法者, 朱雀院椿音效配置.W完美招架.裁断距离);
    创建点特效({
      模型路径: 朱雀院椿表现配置.W完美招架.模型路径,
      RGB: 朱雀院椿表现配置.W完美招架.RGB,
      X: GetUnitX(来源),
      Y: GetUnitY(来源),
      Z: 朱雀院椿表现配置.W完美招架.高度,
      缩放: 朱雀院椿表现配置.W完美招架.缩放,
      持续秒: 朱雀院椿表现配置.W完美招架.持续秒,
    });
  } else {
    // 普通招架音（普通招架分支；单位=施法者，参数配置驱动）
    Sound3DII_UnitPlayReuse(朱雀院椿音效配置.W普通招架.路径, 施法者, 朱雀院椿音效配置.W普通招架.裁断距离);
    创建点特效({
      模型路径: 朱雀院椿表现配置.W普通招架.模型路径,
      RGB: 朱雀院椿表现配置.W普通招架.RGB,
      X: GetUnitX(来源),
      Y: GetUnitY(来源),
      Z: 朱雀院椿表现配置.W普通招架.高度,
      缩放: 朱雀院椿表现配置.W普通招架.缩放,
      持续秒: 朱雀院椿表现配置.W普通招架.持续秒,
    });
  }
  // 结束本次窗口（已招架 → 不释放收刀斩）
  结束W招架(施法者, 技能实例ID, 数据);
}

function 结束W招架(this: void, 施法者: any, _技能实例ID: number | undefined, 数据: W数据): void {
  if (数据.已结束) return;
  数据.已结束 = true;
  if (数据.修饰ID !== 0) {
    unregisterDamageModifier(数据.修饰ID);
    数据.修饰ID = 0;
  }
  destroyUnitEffect(施法者, 招架特效键);
  // 未受击自然结束：基础收尾（恢复少量 VF + 收刀斩）
  if (!数据.已招架) {
    恢复VF(施法者, 朱雀院椿被动配置.收刀恢复VF);
    const 方向 = 数据.方向角;
    const X = GetUnitX(施法者);
    const Y = GetUnitY(施法者);
    // 收刀斩音（未受击收刀分支结算点；坐标=施法者位置，参数配置驱动）
    Sound3DII_CooPlayReuse(朱雀院椿音效配置.W收刀斩.路径, X, Y, 朱雀院椿音效配置.W收刀斩.高度, 朱雀院椿音效配置.W收刀斩.裁断距离);
    const 敌人 = 获取扇形区域单位({
      X,
      Y,
      半径: W配置.收刀扇形半径,
      方向角: 方向,
      扇形角度: W配置.收刀扇形角度,
      单位筛选: function W收刀筛选(this: void, 单位: any): boolean {
        return 单位 !== 施法者 && 单位存活(单位) && jass.IsUnitEnemy(单位, jass.GetOwningPlayer(施法者));
      },
    });
    for (let i = 0; i < 敌人.length; i++) {
      造成技能伤害({
        来源: 施法者,
        目标: 敌人[i],
        伤害: 读取单位攻击力(施法者) * W配置.收刀斩倍率,
        伤害类型: DAMAGE_TYPE_NORMAL,
        攻击类型: ATTACK_TYPE_NORMAL,
        武器类型: WEAPON_TYPE_WHOKNOWS,
        来源类型: "单位技能",
        技能ID: W技能ID,
        技能实例ID: undefined,
        标签: "朱雀院椿-W收刀斩",
        伤害形态: "AOE",
        参与技能伤害加成: true,
      });
    }
  }
}

function 释放W招架(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  debugLogForce("椿-W", "释放", "技能实例ID", 技能实例ID ?? "-");
  if (!是朱雀院椿(施法者)) return;
  // R 蓄力期间不能重复开启 W；已有招架窗口不叠加
  if (联动R.椿R蓄力中 != null && 联动R.椿R蓄力中(施法者)) return;
  if (查询战斗技能实例(施法者, "椿W").length > 0) return;
  // 技能喊话：施法成功起点（全局 3D；随机二选一由喊话系统驱动）
  播放英雄技能喊话(施法者, "朱雀院椿", 朱雀院椿技能配置.W.技能ID);
  播放椿动作(施法者, 朱雀院椿动作槽.W开窗);
  const 数据: W数据 = {
    窗口开始: getGameTime(),
    方向角: GetUnitFacing(施法者),
    修饰ID: 0,
    已招架: false,
    已结束: false,
    招架来源: null,
  };
  debugLogForce("椿-W", "状态", "创建战斗技能实例", 技能实例ID ?? "-");
  const 控制器 = 创建战斗技能实例({
    技能键: "椿W",
    施法者,
    技能实例ID,
    数据,
    结束回调: function W结束(this: void, _原因: string, _c: any): void {
      debugLogForce("椿-W", "结束", "原因", _原因 ?? "-");
      // 死亡/中断收束：补全清理（与 结束W招架 幂等）
      if (数据.已结束) return;
      数据.已结束 = true;
      if (数据.修饰ID !== 0) unregisterDamageModifier(数据.修饰ID);
      destroyUnitEffect(施法者, 招架特效键);
    },
  });

  // 招架窗口表现：独立招架弧（借用 W普通招架 白金半圆闪光模型——项目无独立招架窗口模型；不叠加 VF 常驻特效，VF 为 0 时窗口仍可见）
  // 窗口结束（结束W招架）/成功（结算W反击 内结束W招架）/死亡/中断（W结束回调）统一 destroyUnitEffect(招架特效键) 销毁
  const 招架窗口特效 = createUnitEffect(施法者, "origin", 朱雀院椿表现配置.W招架窗口.模型路径, 朱雀院椿表现配置.W招架窗口.持续秒, 招架特效键);
  设置特效缩放(招架窗口特效, 朱雀院椿表现配置.W招架窗口.缩放);

  // 正面招架伤害修改器：攻击来源在正面 → 按方向与时点区分普通/完美招架
  数据.修饰ID = registerDamageModifier(function W招架伤害修正(this: void, context: any): number {
    if (数据.已招架 || 数据.已结束) return context.currentDamage;
    if (context.target !== 施法者) return context.currentDamage;
    if (context.attacker == null || context.attacker === 0) return context.currentDamage;
    if (!单位是否在来源正面扇区(施法者, context.attacker, W配置.正面角度)) return context.currentDamage;
    数据.已招架 = true;
    数据.招架来源 = context.attacker;
    // 完美招架：攻击进入时点早于阈值 且 方向差更窄
    const 进入秒 = getGameTime() - 数据.窗口开始;
    const 来源方向 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), GetUnitX(context.attacker), GetUnitY(context.attacker));
    const 完美 = 进入秒 <= W配置.完美时点秒 && 角度差绝对值(数据.方向角, 来源方向) <= W配置.完美角度;
    // 反击准备（方向 = 招架来源方向）
    创建反击准备(施法者, 来源方向, context.attacker);
    // 招架恢复 VF（完美招架额外恢复；合并一次调用，恢复VF 有 1s 全局冷却，连续两次第二次必失败）
    恢复VF(施法者, 朱雀院椿被动配置.招架恢复VF + (完美 ? 朱雀院椿被动配置.完美招架额外VF : 0));
    // 收尾延迟到本次伤害修正遍历结束后执行（禁止在伤害遍历中同步注销修改器）
    addDelayedCallback(0, function W招架成功收尾(this: void): void {
      结算W反击(施法者, 技能实例ID, 数据, 完美);
    });
    return 0; // 化解本次伤害
  }, 60);

  // 窗口到期：未受击 → 基础收尾
  const 到期ID = addDelayedCallback(W配置.招架窗口秒 * 1000, function W窗口到期(this: void): void {
    结束W招架(施法者, 技能实例ID, 数据);
    if (控制器 != null) 控制器.完成();
  });
  控制器.登记延迟回调(到期ID);
  登记椿清理(施法者, "椿W招架", function W招架清理(this: void): void {
    结束W招架(施法者, 技能实例ID, 数据);
  });
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册朱雀院椿W(this: void): void {
  debugLogForce("椿-W", "注册", "名称", "注册朱雀院椿W");
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "朱雀院椿-VF场·后之先（W）",
    单位类型ID: 英雄单位类型ID,
    技能ID: "ATW1",
    获取或创建上下文: function W上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放W招架,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 1.5,
  });
}

export const 朱雀院椿W模块 = {
  技能ID: 朱雀院椿技能配置.W.技能ID,
  注册: 注册朱雀院椿W,
} as const;
