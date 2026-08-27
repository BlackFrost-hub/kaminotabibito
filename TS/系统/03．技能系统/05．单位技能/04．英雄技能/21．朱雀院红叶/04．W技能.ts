/** @noSelfInFile */

import {
  朱雀院红叶技能配置,
  朱雀院红叶表现配置,
  朱雀院红叶Buff配置,
  朱雀院红叶动作配置,
  朱雀院红叶动作槽,
  朱雀院红叶待平衡数值,
} from "./00．配置";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
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
const { 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始击退: (this: void, 单位: any, 参数: any) => number;
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
const { 两点方向角, 角度差绝对值 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.08．方位判定工具") as {
  两点方向角: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  角度差绝对值: (this: void, a: number, b: number) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { createUnitEffect, destroyUnitEffect, 设置特效缩放 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
  destroyUnitEffect: (this: void, unit: any, effectKey?: string) => void;
  设置特效缩放: (this: void, effect: any, scale: number) => void;
};
const {
  施加朱雀院破绽,
  尝试消费一层刀势,
  增加刀势,
  是朱雀院红叶,
  登记朱雀院清理,
  播放红叶动作,
} = require("./02．被动效果") as {
  施加朱雀院破绽: (this: void, 红叶: any, 目标: any) => void;
  尝试消费一层刀势: (this: void, 英雄: any) => boolean;
  增加刀势: (this: void, 英雄: any, 层数: number) => void;
  是朱雀院红叶: (this: void, unit: any) => boolean;
  登记朱雀院清理: (this: void, 英雄: any, 名称: string, 清理: () => void) => void;
  播放红叶动作: (this: void, 英雄: any, 槽: { 索引: number; 持续秒: number }) => void;
};
const 联动D = require("./07．D技能") as {
  尝试消费D强化?: (this: void, 英雄: any) => boolean;
};
const { 延长Q2窗口 } = require("./03．Q技能") as {
  延长Q2窗口: (this: void, 施法者: any, 延长秒: number) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(朱雀院红叶技能配置.单位类型ID);
const W技能ID = stringToFourCCSafe(朱雀院红叶技能配置.W.技能ID);
const 水镜BuffID = 朱雀院红叶Buff配置.水镜招架;
const W配置 = 朱雀院红叶待平衡数值.W;
const 水镜特效键 = "朱雀院红叶W水镜";

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;

interface W数据 {
  方向角: number;
  修饰ID: number;
  已招架: boolean;
  已结束: boolean;
  招架来源: any;
  刀势已消费: boolean;
}

//=============================================================================
// 伤害结算
//=============================================================================

function 结算W单体伤害(this: void, 施法者: any, 目标: any, 技能实例ID: number | undefined, 伤害值: number, 标签: string): void {
  造成技能伤害({
    来源: 施法者,
    目标,
    伤害: 伤害值,
    伤害类型: DAMAGE_TYPE_NORMAL,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: W技能ID,
    技能实例ID,
    标签,
    伤害形态: "单体",
    参与技能伤害加成: true,
  });
}

//=============================================================================
// 招架窗口
//=============================================================================

function 结束W招架(this: void, 施法者: any, 控制器: any, 技能实例ID: number | undefined, 数据: W数据): void {
  if (数据.已结束) return;
  数据.已结束 = true;
  if (数据.修饰ID !== 0) {
    unregisterDamageModifier(数据.修饰ID);
    数据.修饰ID = 0;
  }
  destroyUnitEffect(施法者, 水镜特效键);
  移除单位指定Buff(施法者, 水镜BuffID);
  // 成功与失败互斥：未招架成功才释放失败前斩
  if (!数据.已招架) {
    释放失败前斩(施法者, 技能实例ID);
  }
  控制器.完成();
}

function 释放失败前斩(this: void, 施法者: any, 技能实例ID: number | undefined): void {
  播放红叶动作(施法者, 朱雀院红叶动作槽.W失败前斩);
  const 方向 = GetUnitFacing(施法者);
  const X = GetUnitX(施法者);
  const Y = GetUnitY(施法者);
  const 扇形敌人 = 获取扇形区域单位({
    X,
    Y,
    半径: W配置.前斩半径,
    方向角: 方向,
    扇形角度: W配置.前斩扇形角度,
    单位筛选: function W前斩筛选(this: void, 单位: any): boolean {
      return 单位 !== 施法者 && 单位存活(单位) && jass.IsUnitEnemy(单位, jass.GetOwningPlayer(施法者));
    },
  });
  for (let i = 0; i < 扇形敌人.length; i++) {
    结算W单体伤害(施法者, 扇形敌人[i], 技能实例ID, 读取单位攻击力(施法者) * W配置.前斩攻击力倍率, "朱雀院红叶-W失败前斩");
    施加朱雀院破绽(施法者, 扇形敌人[i]);
  }
}

function 结算W反击(this: void, 施法者: any, 控制器: any, 技能实例ID: number | undefined, 数据: W数据): void {
  const 来源 = 数据.招架来源;
  // 来源失效：安全收尾（已招架成功，不释放失败前斩）
  if (来源 == null || 来源 === 0 || !单位存活(来源)) {
    结束W招架(施法者, 控制器, 技能实例ID, 数据);
    return;
  }
  播放红叶动作(施法者, 朱雀院红叶动作槽.W成功反击);
  // 反击：对攻击来源结算伤害 + 破绽 + 刀势
  结算W单体伤害(施法者, 来源, 技能实例ID, 读取单位攻击力(施法者) * W配置.反击攻击力倍率, "朱雀院红叶-W反击");
  施加朱雀院破绽(施法者, 来源);
  增加刀势(施法者, 1);
  延长Q2窗口(施法者, W配置.Q2延长秒);
  // 刀势强化：反击追加短距离回刃剑气（一次）
  if (!数据.刀势已消费) {
    数据.刀势已消费 = true;
    if (尝试消费一层刀势(施法者)) {
      结算W单体伤害(施法者, 来源, 技能实例ID, 读取单位攻击力(施法者) * W配置.回刃剑气攻击力倍率, "朱雀院红叶-W回刃剑气");
    }
  }
  // D 强化：把攻击来源短暂拉回红叶前方（距离/目标类型/内部冷却受限）
  if (联动D.尝试消费D强化 != null && 联动D.尝试消费D强化(施法者)) {
    const 来源X = GetUnitX(来源);
    const 来源Y = GetUnitY(来源);
    const 拉回角度 = 两点角度(来源X, 来源Y, GetUnitX(施法者), GetUnitY(施法者));
    开始击退(来源, {
      距离: W配置.D强化拉回距离,
      角度: 拉回角度,
      来源单位: 施法者,
      主单位死亡时中断: true,
    });
  }
  结束W招架(施法者, 控制器, 技能实例ID, 数据);
}

function 释放W水镜返刃(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (!是朱雀院红叶(施法者)) return;
  播放红叶动作(施法者, 朱雀院红叶动作槽.W开窗);
  // 不叠加窗口：已有活跃招架时忽略本次释放
  if (查询战斗技能实例(施法者, "红叶W").length > 0) return;
  const 数据: W数据 = {
    方向角: GetUnitFacing(施法者),
    修饰ID: 0,
    已招架: false,
    已结束: false,
    招架来源: null,
    刀势已消费: false,
  };
  const 控制器 = 创建战斗技能实例({
    技能键: "红叶W",
    施法者,
    技能实例ID,
    数据,
    结束回调: function W结束(this: void, _原因: string, _c: any): void {
      // 死亡/中断收束：补全清理（与 结束W招架 幂等）
      if (数据.已结束) return;
      数据.已结束 = true;
      if (数据.修饰ID !== 0) unregisterDamageModifier(数据.修饰ID);
      destroyUnitEffect(施法者, 水镜特效键);
      移除单位指定Buff(施法者, 水镜BuffID);
    },
  });

  // 招架窗口表现：水镜主体 + 招架 Buff
  const 水镜特效 = createUnitEffect(施法者, "origin", 朱雀院红叶表现配置.水镜主体, 朱雀院红叶表现配置.参数.水镜主体.持续秒, 水镜特效键);
  设置特效缩放(水镜特效, 朱雀院红叶表现配置.参数.水镜主体.缩放);
  registerManualBuff(施法者, 水镜BuffID, W配置.招架窗口秒, 1, { stack: 1 });

  // 正面招架伤害修改器：攻击来源在红叶正面（快照朝向）时化解该次伤害
  数据.修饰ID = registerDamageModifier(function W招架伤害修正(this: void, context: any): number {
    if (数据.已招架 || 数据.已结束) return context.currentDamage;
    if (context.target !== 施法者) return context.currentDamage;
    if (context.attacker == null || context.attacker === 0) return context.currentDamage;
    const 来源方向 = 两点方向角(GetUnitX(施法者), GetUnitY(施法者), GetUnitX(context.attacker), GetUnitY(context.attacker));
    if (角度差绝对值(数据.方向角, 来源方向) > W配置.正面角度 / 2) return context.currentDamage;
    数据.已招架 = true;
    数据.招架来源 = context.attacker;
    // 收尾延迟到本次伤害修正遍历结束后执行（禁止在伤害遍历中同步注销修改器）
    addDelayedCallback(0, function W招架成功收尾(this: void): void {
      结算W反击(施法者, 控制器, 技能实例ID, 数据);
    });
    return 0; // 化解本次伤害
  }, 60);

  // 窗口到期：未招架成功则释放失败前斩
  const 到期ID = addDelayedCallback(W配置.招架窗口秒 * 1000, function W窗口到期(this: void): void {
    结束W招架(施法者, 控制器, 技能实例ID, 数据);
  });
  控制器.登记延迟回调(到期ID);
  登记朱雀院清理(施法者, "红叶W招架", function W招架清理(this: void): void {
    控制器.中断();
  });
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册朱雀院红叶W(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "朱雀院红叶-水镜·返刃（W）",
    单位类型ID: 英雄单位类型ID,
    技能ID: "AMW1",
    获取或创建上下文: function W上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放W水镜返刃,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 1.5,
  });
}

export const 朱雀院红叶W模块 = {
  技能ID: 朱雀院红叶技能配置.W.技能ID,
  招架窗口秒: W配置.招架窗口秒,
  注册: 注册朱雀院红叶W,
} as const;
