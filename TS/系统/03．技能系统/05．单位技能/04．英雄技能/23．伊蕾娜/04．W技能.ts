/** @noSelfInFile */
/**
 * 伊蕾娜 - W：镜界护符（A4）
 *
 * - 无目标自身施放，建立一次真实保护窗口：
 *   · 常驻通用护盾（数值走配置倍率）提供减免层；
 *   · 伤害修改器处理"主要攻击"——窗口内首次有效敌方伤害按配置比例偏折（默认全额），
 *     偏折成功才记录"镜界"见闻；修改器注销延迟到当前遍历结束之后。
 * - 自然结束（未触发主要攻击）释放一次配置化减速脉冲；成功触发/打断/死亡只走一个收口。
 * - 结界视觉跟随施法者（Dz 跟随特效）：E 携带时坐标随人更新，持续时间与保护次数不刷新。
 * - 友军、无效来源、窗口外伤害不触发；重复施放先收旧结界再建新窗，不叠加虚假保护。
 */

import { 伊蕾娜技能配置, 伊蕾娜W配置, 伊蕾娜表现配置, 伊蕾娜模型动作配置, 伊蕾娜变式效果配置, 伊蕾娜音效配置 } from "./00．配置";
import { 播放伊蕾娜阶段动作, 开始伊蕾娜循环动作, 停止伊蕾娜循环动作 } from "./01A．动作表现";
import { 伊蕾娜BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/23．伊蕾娜";
import {
  记录伊蕾娜见闻,
  获取伊蕾娜变式,
  消费伊蕾娜变式用于,
  存伊蕾娜W结界,
  取伊蕾娜W结界,
  登记伊蕾娜技能清理,
} from "./02．被动效果";

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
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number | undefined, priority?: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};
const { 开始护盾, 移除护盾 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统") as {
  开始护盾: (this: void, 单位: any, 参数: any) => number;
  移除护盾: (this: void, 护盾ID: number) => boolean;
};
const { 读取单位攻击力, 单位存活, 两点角度, 极坐标X, 极坐标Y } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
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
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, u: any, 来源: string) => boolean;
  移除单位暂停: (this: void, u: any, 来源: string) => boolean;
};
const { SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setSlow: (this: void, sourceUnit: any, u: any, attackSlow: number, moveSlow: number, time: number, effectSourceName?: string, effectSourceType?: string) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const {
  创建单位坐标跟随特效,
  销毁单位坐标跟随特效,
  创建点特效,
  销毁点特效,
} = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number, animSpeed?: number, 动画索引?: number, 面向弧度?: number, RGB?: { 红: number; 绿: number; 蓝: number; 透明度?: number }) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
  创建点特效: (this: void, 参数: any) => any;
  销毁点特效: (this: void, effect: any) => void;
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
const W镜界特效键 = "伊蕾娜-W镜界";
const W硬直来源 = "伊蕾娜-W硬直";

//=============================================================================
// 结界运行数据
//=============================================================================

interface 伊蕾娜W结界数据 {
  英雄: any;
  窗口结束时间: number;
  主要攻击已处理: boolean;
  已关闭: boolean;
  修改器ID: number;
  护盾ID: number;
  镜界变式待消费: boolean;
  注销清理: ((this: void) => void) | null;
  保持动作守护: any;
  /** 本结界实例是否已提供过 Q 折射读取 */
  折射已用: boolean;
}

function 关闭W镜界(this: void, 数据: 伊蕾娜W结界数据, 允许脉冲: boolean): void {
  debugLogForce("伊蕾娜-W", "结束", "原因", 允许脉冲 ? "自然结束" : "提前收口", "单位", GetUnitName(数据.英雄), "handle", 数据.英雄);
  if (数据.已关闭) return; // 单一收口
  数据.已关闭 = true;

  if (数据.修改器ID !== 0) {
    unregisterDamageModifier(数据.修改器ID);
    数据.修改器ID = 0;
  }
  const 英雄 = 数据.英雄;
  移除护盾(数据.护盾ID);
  移除单位指定Buff(英雄, 伊蕾娜BuffID.镜界结界);
  销毁单位坐标跟随特效(英雄, W镜界特效键);
  停止伊蕾娜循环动作(数据.保持动作守护);
  数据.保持动作守护 = null;
  if (数据.注销清理 != null) {
    数据.注销清理();
    数据.注销清理 = null;
  }
  if (单位存活(英雄)) 播放伊蕾娜阶段动作(英雄, 伊蕾娜模型动作配置.技能动作.W收势);

  // 自然结束（窗口内没有触发主要攻击）：配置化减速脉冲
  if (允许脉冲 && !数据.主要攻击已处理 && 单位存活(英雄)) {
    const X = GetUnitX(英雄);
    const Y = GetUnitY(英雄);
    const 敌人列表 = 获取坐标范围敌人(英雄, X, Y, 伊蕾娜W配置.自然结束脉冲半径);
    for (let i = 0; i < 敌人列表.length; i++) {
      const 敌人 = 敌人列表[i];
      if (!单位存活(敌人)) continue;
      SFB_setSlow(
        英雄,
        敌人,
        0,
        伊蕾娜W配置.自然结束减速比例,
        伊蕾娜W配置.自然结束减速秒,
        "伊蕾娜-镜界碎裂",
        "技能",
      );
    }
  }

  // 摘除容器槽（仅当槽仍指向本结界）
  if (取伊蕾娜W结界(英雄) === 数据) {
    存伊蕾娜W结界(英雄, null);
  }
}

/** 折射可用查询（Q 联动读取）。 */
export function 查询伊蕾娜W折射可用(this: void, 英雄: any): boolean {
  const 数据 = 取伊蕾娜W结界(英雄) as 伊蕾娜W结界数据 | null;
  if (数据 == null || 数据.已关闭) return false;
  if (getGameTime() >= 数据.窗口结束时间) return false;
  return !数据.折射已用;
}

/** 折射消费（Q 联动调用；每个结界实例只允许一次；不影响主要攻击偏折机会）。 */
export function 消费伊蕾娜W折射(this: void, 英雄: any): boolean {
  const 数据 = 取伊蕾娜W结界(英雄) as 伊蕾娜W结界数据 | null;
  if (数据 == null || 数据.已关闭) return false;
  if (数据.折射已用) return false;
  if (getGameTime() >= 数据.窗口结束时间) return false;
  数据.折射已用 = true;
  return true;
}

//=============================================================================
// 施放流程
//=============================================================================

function 释放W镜界护符(this: void, _context: any, 施法者: any, _技能实例ID: number | undefined): void {
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) {
    debugLogForce("伊蕾娜-W", "释放被拒", "原因", "施法者无效", "handle", 施法者);
    return;
  }
  debugLogForce("伊蕾娜-W", "释放", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(stringToFourCCSafe(伊蕾娜技能配置.W.技能ID)), "实例", _技能实例ID ?? "-", "目标", "自身", "X", Math.floor(GetUnitX(施法者)), "Y", Math.floor(GetUnitY(施法者)));
  播放英雄技能喊话(施法者, "伊蕾娜", 伊蕾娜技能配置.W.技能ID);

  // 重复施放：旧结界独立收尾（无脉冲），不叠加虚假保护
  const 旧数据 = 取伊蕾娜W结界(施法者) as 伊蕾娜W结界数据 | null;
  if (旧数据 != null && !旧数据.已关闭) {
    关闭W镜界(旧数据, false);
  }

  // 时序：先暂停 → 同阶段播动作；硬直到达时长后恢复
  if (添加单位暂停(施法者, W硬直来源)) {
    播放伊蕾娜阶段动作(施法者, 伊蕾娜模型动作配置.技能动作.W展开);
  }
  addDelayedCallback(伊蕾娜W配置.硬直秒 * 1000, function W硬直结束(this: void): void {
    移除单位暂停(施法者, W硬直来源);
  });

  const now = getGameTime();
  const 数据: 伊蕾娜W结界数据 = {
    英雄: 施法者,
    窗口结束时间: now + 伊蕾娜W配置.保护窗口秒 * 1000,
    主要攻击已处理: false,
    已关闭: false,
    修改器ID: 0,
    护盾ID: 0,
    镜界变式待消费: 获取伊蕾娜变式(施法者) === "镜界",
    注销清理: null,
    保持动作守护: null,
    折射已用: false,
  };
  存伊蕾娜W结界(施法者, 数据);

  addDelayedCallback(伊蕾娜模型动作配置.技能动作.W展开.持续秒 * 1000, function W进入保持动作(this: void): void {
    if (!数据.已关闭 && 单位存活(施法者)) {
      数据.保持动作守护 = 开始伊蕾娜循环动作(施法者, 伊蕾娜模型动作配置.技能动作.W保持);
    }
  });

  // 镜界 Buff 与跟随视觉（E 携带时自动跟随坐标，不在此刷新任何计时）
  registerManualBuff(施法者, 伊蕾娜BuffID.镜界结界, 伊蕾娜W配置.保护窗口秒, 0);
  const 镜界表现 = 伊蕾娜表现配置.W镜界主体;
  const 镜界缩放 = 伊蕾娜W配置.结界接触半径 / 镜界表现.基准半径 * 镜界表现.基准缩放;
  debugLogForce("伊蕾娜-W", "特效", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "路径", 镜界表现.模型路径);
  创建单位坐标跟随特效(施法者, 镜界表现.模型路径, W镜界特效键, 镜界缩放, 镜界表现.高度, 1, undefined, 0, 镜界表现.RGB);
  // 镜界展开音（单位=施法者；保护窗口与结界视觉建立时一次，参数配置驱动）
  Sound3DII_UnitPlayReuse(伊蕾娜音效配置.W展开.路径, 施法者, 伊蕾娜音效配置.W展开.裁断距离);

  // 常驻护盾：窗口内全程有效的减免层
  数据.护盾ID = 开始护盾(施法者, {
    类型: 0,
    数值: 读取单位攻击力(施法者) * 伊蕾娜W配置.护盾攻击力倍率,
    持续时间: 伊蕾娜W配置.保护窗口秒,
    来源单位: 施法者,
    标签: "伊蕾娜-镜界护盾",
    显示护盾条: true,
  });

  // 主要攻击偏折：注销延迟到当前遍历结束之后（下一 tick 回调中执行）
  数据.修改器ID = registerDamageModifier(function W偏折修改器(this: void, context: any): number {
    if (数据.已关闭 || 数据.主要攻击已处理) return context.currentDamage;
    if (context.target !== 施法者) return context.currentDamage;
    if (!(context.currentDamage > 0)) return context.currentDamage;
    const 攻击者 = context.attacker;
    if (攻击者 == null || 攻击者 === 0 || 攻击者 === 施法者) return context.currentDamage;
    if (!IsUnitEnemy(攻击者, GetOwningPlayer(施法者))) return context.currentDamage;
    if (getGameTime() >= 数据.窗口结束时间) return context.currentDamage;

    // 主要攻击确认进入偏折分支
    数据.主要攻击已处理 = true;
    debugLogForce("伊蕾娜-W", "命中", "玩家", GetPlayerId(GetOwningPlayer(施法者)) + 1, "四码", fourCCToStringSafe(stringToFourCCSafe(伊蕾娜技能配置.W.技能ID)), "目标", GetUnitName(攻击者), "handle", 攻击者, "X", Math.floor(GetUnitX(攻击者)), "Y", Math.floor(GetUnitY(攻击者)), "伤害", Math.floor(context.currentDamage), "类型", "主要攻击偏折");

    // 接触点：由攻击方向与结界近似圆面求出，禁止绑定骨骼或固定在中心冒充接触位置
    const 接触角 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), GetUnitX(攻击者), GetUnitY(攻击者));
    const 接触X = 极坐标X(GetUnitX(施法者), 接触角, 伊蕾娜W配置.结界接触半径);
    const 接触Y = 极坐标Y(GetUnitY(施法者), 接触角, 伊蕾娜W配置.结界接触半径);
    const 反馈特效 = 创建点特效({
      模型路径: 伊蕾娜表现配置.W偏折反馈.模型路径,
      RGB: 伊蕾娜表现配置.W偏折反馈.RGB,
      X: 接触X,
      Y: 接触Y,
      Z: 伊蕾娜表现配置.W偏折反馈.高度,
      面向角度: 接触角,
      缩放: 伊蕾娜表现配置.W偏折反馈.缩放,
      持续秒: 伊蕾娜表现配置.W偏折反馈.持续秒,
    });
    void 反馈特效;
    // 偏折成功音（坐标=结界接触点；主要攻击确认进入偏折分支时一次，参数配置驱动）
    Sound3DII_CooPlayReuse(伊蕾娜音效配置.W偏折.路径, 接触X, 接触Y, 伊蕾娜音效配置.W偏折.高度, 伊蕾娜音效配置.W偏折.裁断距离);

    // 注销推迟到当前伤害遍历结束后执行
    addDelayedCallback(10, function W偏折结算(this: void): void {
      if (数据.已关闭) return;
      // 成功触发：记录镜界见闻（A4）
      记录伊蕾娜见闻(施法者, "镜界", undefined);
      关闭W镜界(数据, false);
      if (数据.镜界变式待消费 && 消费伊蕾娜变式用于(施法者, "W") === "镜界") {
        开始护盾(施法者, {
          类型: 0,
          数值: 读取单位攻击力(施法者) * 伊蕾娜变式效果配置.镜界_W回响护盾攻击力倍率,
          持续时间: 伊蕾娜变式效果配置.镜界_W回响护盾秒,
          来源单位: 施法者,
          标签: "伊蕾娜-镜界变式回响",
          显示护盾条: false,
        });
      }
    });

    return context.currentDamage * (1 - 伊蕾娜W配置.偏折减免比例);
  }, 50);

  // 自然结束路径：窗口到点 → 有脉冲资格的统一收口
  addDelayedCallback(伊蕾娜W配置.保护窗口秒 * 1000, function W窗口自然结束(this: void): void {
    关闭W镜界(数据, true);
  });
  实例化W收尾守护(施法者, 数据);
}

/** 死亡/场景清理兜底：把打断路径挂进伊蕾娜统一清理表（无脉冲收口）。 */
function 实例化W收尾守护(this: void, 施法者: any, 数据: 伊蕾娜W结界数据): void {
  数据.注销清理 = 登记伊蕾娜技能清理(
    施法者,
    "W镜界",
    function W镜界清理(this: void): void {
      关闭W镜界(数据, false);
    },
  );
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册伊蕾娜W(this: void): void {
  debugLogForce("伊蕾娜-W", "注册", "名称", "注册伊蕾娜W");
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "伊蕾娜-镜界护符（W）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 伊蕾娜技能配置.W.技能ID,
    获取或创建上下文: function W上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放W镜界护符,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 8,
  });
}

export {};
