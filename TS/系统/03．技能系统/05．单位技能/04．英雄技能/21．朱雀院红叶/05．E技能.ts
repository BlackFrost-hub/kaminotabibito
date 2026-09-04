/** @noSelfInFile */

import {
  朱雀院红叶技能配置,
  朱雀院红叶表现配置,
  朱雀院红叶音效配置,
  朱雀院红叶动作配置,
  朱雀院红叶动作槽,
  朱雀院红叶待平衡数值,
} from "./00．配置";

const jass = require("jass.common") as any;
const { stringToFourCCSafe, fourCCToStringSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
  fourCCToStringSafe: (this: void, fourcc: number) => string;
};
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { 创建战斗技能实例, 查询战斗技能实例 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂") as {
  创建战斗技能实例: (this: void, 参数: any) => any;
  查询战斗技能实例: (this: void, 施法者: any, 技能键: string) => any[];
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
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string) => boolean;
};
const {
  施加朱雀院破绽,
  尝试消费一层刀势,
  是朱雀院红叶,
  登记朱雀院清理,
  播放红叶动作,
} = require("./02．被动效果") as {
  施加朱雀院破绽: (this: void, 红叶: any, 目标: any) => void;
  尝试消费一层刀势: (this: void, 英雄: any) => boolean;
  是朱雀院红叶: (this: void, unit: any) => boolean;
  登记朱雀院清理: (this: void, 英雄: any, 名称: string, 清理: () => void) => void;
  播放红叶动作: (this: void, 英雄: any, 槽: { 索引: number; 持续秒: number }) => void;
};
const 联动D = require("./07．D技能") as {
  尝试消费D强化?: (this: void, 英雄: any) => boolean;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(朱雀院红叶技能配置.单位类型ID);
const E技能ID = stringToFourCCSafe(朱雀院红叶技能配置.E.技能ID);
const E配置 = 朱雀院红叶待平衡数值.E;
const E轻斩音效 = 朱雀院红叶音效配置.E轻斩;
const E终结音效 = 朱雀院红叶音效配置.E终结;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const GetUnitName = jass.GetUnitName as (this: void, unit: any) => string;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;

//=============================================================================
// 剑痕（固定世界坐标，不阻挡路径，不可选取；供 Q/W/R 读取，先锁再消费）
//=============================================================================

export interface 红叶剑痕 {
  序号: number;
  来源英雄: any;
  X: number;
  Y: number;
  方向角: number;
  已读取: boolean;
  到期回调ID: number;
  特效句柄: any;
}

let 剑痕序号 = 0;
const 剑痕表: Record<number, 红叶剑痕 | undefined> = {};
const 英雄剑痕列表: Record<number, number[] | undefined> = {};

function 移除剑痕(this: void, 剑痕: 红叶剑痕): void {
  if (剑痕.到期回调ID !== 0) {
    removeDelayedCallback(剑痕.到期回调ID);
    剑痕.到期回调ID = 0;
  }
  if (剑痕.特效句柄 != null && 剑痕.特效句柄 !== 0) {
    jass.DestroyEffect(剑痕.特效句柄);
    剑痕.特效句柄 = null;
  }
  delete 剑痕表[剑痕.序号];
  const 英雄ID = jass.GetHandleId(剑痕.来源英雄);
  const 列表 = 英雄剑痕列表[英雄ID];
  if (列表 != null) {
    const idx = 列表.indexOf(剑痕.序号);
    if (idx >= 0) 列表.splice(idx, 1);
    if (列表.length <= 0) delete 英雄剑痕列表[英雄ID];
  }
}

function 创建剑痕(this: void, 来源英雄: any, X: number, Y: number, 方向角: number): 红叶剑痕 {
  debugLogForce("红叶-E", "状态", "创建剑痕", "玩家", GetPlayerId(GetOwningPlayer(来源英雄)) + 1, "X", Math.floor(X), "Y", Math.floor(Y), "方向角", 方向角);
  const 序号 = ++剑痕序号;
  const 剑痕: 红叶剑痕 = {
    序号,
    来源英雄,
    X,
    Y,
    方向角,
    已读取: false,
    到期回调ID: 0,
    特效句柄: null,
  };
  剑痕.到期回调ID = addDelayedCallback(E配置.剑痕持续秒 * 1000, function 剑痕到期(this: void): void {
    移除剑痕(剑痕);
  });
  剑痕表[序号] = 剑痕;
  const 英雄ID = jass.GetHandleId(来源英雄);
  let 列表 = 英雄剑痕列表[英雄ID];
  if (列表 == null) {
    列表 = [];
    英雄剑痕列表[英雄ID] = 列表;
  }
  列表.push(序号);
  // 地面表现（候选未迁入则留空不播）
  if (朱雀院红叶表现配置.E剑痕.模型路径 != null && 朱雀院红叶表现配置.E剑痕.模型路径 !== "") {
    剑痕.特效句柄 = 创建点特效({
      模型路径: 朱雀院红叶表现配置.E剑痕.模型路径,
      RGB: 朱雀院红叶表现配置.E剑痕.RGB,
      X,
      Y,
      Z: 朱雀院红叶表现配置.E剑痕.高度,
      缩放: 朱雀院红叶表现配置.E剑痕.缩放,
      持续秒: 朱雀院红叶表现配置.E剑痕.持续秒,
    });
  }
  return 剑痕;
}

/** 读取最近一条有效 E 剑痕并锁定（Q/W/R 调用；同帧重复读取返回 null） */
export function 读取最近剑痕并锁定(this: void, 英雄: any): 红叶剑痕 | null {
  if (英雄 == null || 英雄 === 0) return null;
  const 列表 = 英雄剑痕列表[jass.GetHandleId(英雄)];
  if (列表 == null || 列表.length <= 0) return null;
  // 最近 = 创建序号最大（时间最近），且未读取
  for (let i = 列表.length - 1; i >= 0; i--) {
    const 剑痕 = 剑痕表[列表[i]];
    if (剑痕 == null) {
      列表.splice(i, 1);
      continue;
    }
    if (剑痕.已读取) continue;
    剑痕.已读取 = true;
    return 剑痕;
  }
  return null;
}

/** 清理指定英雄的全部剑痕（死亡/场景清理） */
export function 清理英雄剑痕(this: void, 英雄: any): void {
  if (英雄 == null || 英雄 === 0) return;
  const 列表 = 英雄剑痕列表[jass.GetHandleId(英雄)];
  if (列表 == null) return;
  const 副本 = 列表.slice(0);
  for (let i = 0; i < 副本.length; i++) {
    const 剑痕 = 剑痕表[副本[i]];
    if (剑痕 != null) 移除剑痕(剑痕);
  }
}

//=============================================================================
// E 三叶·散华：三段斩击
//=============================================================================

interface E数据 {
  方向角: number;
  目标X: number;
  目标Y: number;
  已斩段数: number;
  段回调ID: number[];
  同目标次数: Record<number, number>;
  本E剑痕: 红叶剑痕[];
}

function 结算E段伤害(this: void, 施法者: any, 目标: any, 技能实例ID: number | undefined, 伤害值: number, 标签: string): void {
  debugLogForce("红叶-E", "伤害", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "目标", GetUnitName(目标), "handle", 目标, "X", Math.floor(GetUnitX(目标)), "Y", Math.floor(GetUnitY(目标)), "伤害", Math.floor(伤害值), "标签", 标签, "实例", 技能实例ID ?? "-");
  造成技能伤害({
    来源: 施法者,
    目标,
    伤害: 伤害值,
    伤害类型: DAMAGE_TYPE_NORMAL,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: E技能ID,
    技能实例ID,
    标签,
    伤害形态: "单体",
    参与技能伤害加成: true,
  });
  施加朱雀院破绽(施法者, 目标);
}

function 取段扇形敌人(this: void, 施法者: any, 数据: E数据, 半径: number, 角度: number): any[] {
  return 获取扇形区域单位({
    X: 数据.目标X,
    Y: 数据.目标Y,
    半径,
    方向角: 数据.方向角,
    扇形角度: 角度,
    单位筛选: function E段筛选(this: void, 单位: any): boolean {
      return 单位 !== 施法者 && 单位存活(单位) && jass.IsUnitEnemy(单位, jass.GetOwningPlayer(施法者));
    },
  });
}

function 执行E一段(this: void, 施法者: any, 控制器: any, 技能实例ID: number | undefined, 数据: E数据): void {
  数据.已斩段数 = 1;
  // 第一斩轻斩音（段回调结算点一次；坐标=斩击点，参数配置驱动）
  Sound3DII_CooPlayReuse(E轻斩音效.路径, 数据.目标X, 数据.目标Y, E轻斩音效.高度, E轻斩音效.裁断距离);
  const 敌人 = 取段扇形敌人(施法者, 数据, E配置.第一斩半径, E配置.第一斩扇形角度);
  for (let i = 0; i < 敌人.length; i++) {
    const id = jass.GetHandleId(敌人[i]);
    const 次数 = 数据.同目标次数[id] ?? 0;
    if (次数 >= E配置.同目标最大次数) continue;
    数据.同目标次数[id] = 次数 + 1;
    结算E段伤害(施法者, 敌人[i], 技能实例ID, 读取单位攻击力(施法者) * E配置.第一斩攻击力倍率, "朱雀院红叶-E第一斩");
  }
}

function 执行E二段(this: void, 施法者: any, 控制器: any, 技能实例ID: number | undefined, 数据: E数据): void {
  数据.已斩段数 = 2;
  // 第二斩轻斩音（段回调结算点一次；坐标=斩击点，参数配置驱动）
  Sound3DII_CooPlayReuse(E轻斩音效.路径, 数据.目标X, 数据.目标Y, E轻斩音效.高度, E轻斩音效.裁断距离);
  const 敌人 = 取段扇形敌人(施法者, 数据, E配置.第二斩半径, E配置.第二斩扇形角度);
  for (let i = 0; i < 敌人.length; i++) {
    const id = jass.GetHandleId(敌人[i]);
    const 次数 = 数据.同目标次数[id] ?? 0;
    if (次数 >= E配置.同目标最大次数) continue;
    数据.同目标次数[id] = 次数 + 1;
    结算E段伤害(施法者, 敌人[i], 技能实例ID, 读取单位攻击力(施法者) * E配置.第二斩攻击力倍率, "朱雀院红叶-E第二斩");
  }
}

function 执行E三段(this: void, 施法者: any, 控制器: any, 技能实例ID: number | undefined, 数据: E数据): void {
  数据.已斩段数 = 3;
  // 第三斩终结音（确认的二选一随机槽：运行时从 槽.候选路径 随机取一；坐标=第三斩结算点，参数配置驱动）
  const 候选 = E终结音效.候选路径;
  const 终结路径 = 候选 != null && 候选.length > 0 ? 候选[GetRandomInt(1, 候选.length) - 1] : E终结音效.路径;
  Sound3DII_CooPlayReuse(终结路径, 数据.目标X, 数据.目标Y, E终结音效.高度, E终结音效.裁断距离);
  const 敌人 = 取段扇形敌人(施法者, 数据, E配置.第三斩半径, E配置.第三斩扇形角度);
  for (let i = 0; i < 敌人.length; i++) {
    const id = jass.GetHandleId(敌人[i]);
    const 次数 = 数据.同目标次数[id] ?? 0;
    if (次数 >= E配置.同目标最大次数) continue;
    数据.同目标次数[id] = 次数 + 1;
    结算E段伤害(施法者, 敌人[i], 技能实例ID, 读取单位攻击力(施法者) * E配置.第三斩攻击力倍率, "朱雀院红叶-E第三斩");
  }
  // 第三斩创建主剑痕（固定世界坐标 = 目标区域中心，方向 = 施法快照方向）
  const 主剑痕 = 创建剑痕(施法者, 数据.目标X, 数据.目标Y, 数据.方向角);
  数据.本E剑痕.push(主剑痕);
  // 强化第二条短剑痕：刀势强化优先，其次 D 强化（都只进一次强化分支）
  if (E配置.刀势强化第二剑痕 && 尝试消费一层刀势(施法者)) {
    数据.本E剑痕.push(创建剑痕(施法者, 数据.目标X, 数据.目标Y, 数据.方向角 + 90));
  } else if (E配置.D强化第二剑痕 && 联动D.尝试消费D强化 != null && 联动D.尝试消费D强化(施法者)) {
    数据.本E剑痕.push(创建剑痕(施法者, 数据.目标X, 数据.目标Y, 数据.方向角 + 90));
  }
  控制器.完成();
}

function 释放E三叶散华(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  debugLogForce("红叶-E", "释放", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(E技能ID), "实例", 技能实例ID ?? "-", "目标", "点施放", "施法者X", Math.floor(GetUnitX(施法者)), "施法者Y", Math.floor(GetUnitY(施法者)), "目标X", Math.floor(GetSpellTargetX()), "目标Y", Math.floor(GetSpellTargetY()));
  if (!是朱雀院红叶(施法者)) {
    debugLogForce("红叶-E", "释放被拒", "原因", "非红叶单位", "施法者", 施法者);
    return;
  }
  播放红叶动作(施法者, 朱雀院红叶动作槽.E连续三斩);
  // 重复 E：已有活跃 E 实例时忽略（三段未完成不叠加）
  if (查询战斗技能实例(施法者, "红叶E").length > 0) {
    debugLogForce("红叶-E", "释放被拒", "原因", "重复E活跃实例", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1);
    return;
  }
  // 技能喊话：施法成功起点（全局 3D；随机二选一由喊话系统驱动）
  播放英雄技能喊话(施法者, "朱雀院红叶", 朱雀院红叶技能配置.E.技能ID);
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 方向角 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), 目标X, 目标Y);
  const 数据: E数据 = { 方向角, 目标X, 目标Y, 已斩段数: 0, 段回调ID: [], 同目标次数: {}, 本E剑痕: [] };
  const 控制器 = 创建战斗技能实例({
    技能键: "红叶E",
    施法者,
    技能实例ID,
    数据,
    结束回调: function E结束(this: void, 原因: string, _c: any): void {
      debugLogForce("红叶-E", "结束", "原因", 原因 || "-", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1);
      // 未执行段数回调随实例清理移除；打断/死亡销毁本 E 已创建的剑痕
      for (let i = 0; i < 数据.段回调ID.length; i++) {
        removeDelayedCallback(数据.段回调ID[i]);
      }
      数据.段回调ID = [];
      if (原因 !== "完成") {
        for (let i = 0; i < 数据.本E剑痕.length; i++) 移除剑痕(数据.本E剑痕[i]);
        数据.本E剑痕 = [];
      }
    },
  });

  // 三段按动作时点延迟执行（被打断/死亡时随实例清理，未执行段不再结算）
  const 段回调: ((this: void) => void)[] = [
    function E一段(this: void): void {
      执行E一段(施法者, 控制器, 技能实例ID, 数据);
    },
    function E二段(this: void): void {
      执行E二段(施法者, 控制器, 技能实例ID, 数据);
    },
    function E三段(this: void): void {
      执行E三段(施法者, 控制器, 技能实例ID, 数据);
    },
  ];
  for (let i = 0; i < 段回调.length; i++) {
    const 延迟 = E配置.每段延迟毫秒[i] ?? 0;
    const 回调ID = addDelayedCallback(延迟, 段回调[i]);
    数据.段回调ID.push(回调ID);
    控制器.登记延迟回调(回调ID);
  }
  // 死亡/场景清理：清剑痕
  登记朱雀院清理(施法者, "红叶E剑痕", function E剑痕清理(this: void): void {
    for (let i = 0; i < 数据.本E剑痕.length; i++) 移除剑痕(数据.本E剑痕[i]);
    数据.本E剑痕 = [];
  });
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册朱雀院红叶E(this: void): void {
  debugLogForce("红叶-E", "注册", "名称", "E", "函数", "注册朱雀院红叶E");
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "朱雀院红叶-三叶·散华（E）",
    单位类型ID: 英雄单位类型ID,
    技能ID: "AME1",
    获取或创建上下文: function E上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放E三叶散华,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 2.5,
  });
}

export const 朱雀院红叶E模块 = {
  技能ID: 朱雀院红叶技能配置.E.技能ID,
  剑痕持续秒: E配置.剑痕持续秒,
  注册: 注册朱雀院红叶E,
} as const;
