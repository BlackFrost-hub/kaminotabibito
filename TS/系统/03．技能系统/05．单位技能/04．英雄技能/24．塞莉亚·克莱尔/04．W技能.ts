/** @noSelfInFile */
/**
 * 塞莉亚·克莱尔 - W：解析结界（A4）
 *
 * - 无目标自身施放：一次真实保护窗口 + 结界节点。
 *   · 常驻护盾提供减免层；伤害修改器处理窗口内首次有效敌方攻击（主要攻击），
 *     按配置比例解析（默认全额），注销推迟到当前遍历之后。
 *   · 解析成功反冲：对来源造成魔法伤害并施加减速（走扩展控制入口，含抗性折算）。
 * - 自然结束（未解析）：基础减速脉冲；结界+锚定连接存在时改为范围束缚爆发。
 *   成功/自然结束/打断/死亡互斥单收口。
 * - 结界节点由被动容器管理：D 移动只迁移节点表现与连线，不复制保护层。
 * - 视觉用 Dz 单位跟随特效，随本体更新；模型只表达状态不承担判定。
 */

import {
  塞莉亚克莱尔技能配置,
  塞莉亚克莱尔W配置,
  塞莉亚克莱尔表现配置,
  塞莉亚音效配置,
} from "./00．配置";
import { 塞莉亚BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/24．塞莉亚·克莱尔";
import {
  创建塞莉亚节点,
  授予塞莉亚演算窗口,
  查询塞莉亚有效连接,
  登记塞莉亚技能清理,
} from "./02．被动效果";

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

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
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { AOE施加扩展控制, 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  AOE施加扩展控制: (this: void, 来源: any, 中心X: number, 中心Y: number, 半径: number, 类型: string, 持续秒: number) => any[];
  施加扩展控制: (this: void, 来源: any, 目标: any, 类型: string, 持续秒: number) => number;
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, u: any, 来源: string) => boolean;
  移除单位暂停: (this: void, u: any, 来源: string) => boolean;
};
const { 创建单位坐标跟随特效, 销毁单位坐标跟随特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number, animSpeed?: number, 动画索引?: number, 面向弧度?: number, RGB?: { 红: number; 绿: number; 蓝: number; 透明度?: number }) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string) => boolean;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = 塞莉亚克莱尔技能配置.单位类型ID;
const W结界特效键 = "塞莉亚-W结界";
const W硬直来源 = "塞莉亚-W硬直";

//=============================================================================
// 结界运行数据
//=============================================================================

interface 塞莉亚W结界数据 {
  英雄: any;
  窗口结束时间: number;
  主要攻击已解析: boolean;
  已关闭: boolean;
  修改器ID: number;
  护盾ID: number;
}

/** 结界+锚定连接是否成立（读分支用，不消费）。 */
function 有结界锚定连接(this: void, 英雄: any): boolean {
  const 连接 = 查询塞莉亚有效连接(英雄);
  if (连接 == null || !连接.可读取) return false;
  const 有结界 = 连接.A类型 === "结界" || 连接.B类型 === "结界";
  const 有锚定 = 连接.A类型 === "锚定" || 连接.B类型 === "锚定";
  return 有结界 && 有锚定;
}

/** 统一收口：成功 / 自然结束 / 打断 / 死亡互斥。 */
function 关闭W结界(this: void, 数据: 塞莉亚W结界数据, 收口类型: "自然结束" | "打断"): void {
  debugLogForce("塞莉亚-W", "结束", "原因", 收口类型);
  if (数据.已关闭) return;
  数据.已关闭 = true;

  if (数据.修改器ID !== 0) {
    unregisterDamageModifier(数据.修改器ID);
    数据.修改器ID = 0;
  }
  const 英雄 = 数据.英雄;
  移除护盾(数据.护盾ID);
  移除单位指定Buff(英雄, 塞莉亚BuffID.解析结界);
  销毁单位坐标跟随特效(英雄, W结界特效键);

  if (收口类型 === "自然结束" && !数据.主要攻击已解析 && 单位存活(英雄)) {
    const X = GetUnitX(英雄);
    const Y = GetUnitY(英雄);
    if (有结界锚定连接(英雄)) {
      // 联动：范围束缚爆发
      AOE施加扩展控制(英雄, X, Y, 塞莉亚克莱尔W配置.结界锚定束缚半径, "roots", 塞莉亚克莱尔W配置.结界锚定束缚秒);
    }
    // 基础自然结束脉冲：小范围减速
    AOE施加扩展控制(英雄, X, Y, 塞莉亚克莱尔W配置.自然结束脉冲半径, "slow", 塞莉亚克莱尔W配置.自然结束减速秒);
  }
}

//=============================================================================
// 施放流程
//=============================================================================

function 释放W解析结界(this: void, _context: any, 施法者: any, _技能实例ID: number | undefined): void {
  debugLogForce("塞莉亚-W", "释放", "技能实例ID", _技能实例ID ?? "-");
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) return;

  // 技能喊话：施法成功起点（前置检查通过；全局 3D；随机二选一由喊话系统驱动）
  播放英雄技能喊话(施法者, "塞莉亚·克莱尔", 塞莉亚克莱尔技能配置.W.技能ID);

  // 时序：先暂停 → 硬直结束恢复（动作分槽未确认：缺口，见报告，不冒充已确认槽位）
  添加单位暂停(施法者, W硬直来源);
  addDelayedCallback(塞莉亚克莱尔W配置.硬直秒 * 1000, function W硬直结束(this: void): void {
    移除单位暂停(施法者, W硬直来源);
  });

  const now = getGameTime();
  const 数据: 塞莉亚W结界数据 = {
    英雄: 施法者,
    窗口结束时间: now + 塞莉亚克莱尔W配置.保护窗口秒 * 1000,
    主要攻击已解析: false,
    已关闭: false,
    修改器ID: 0,
    护盾ID: 0,
  };

  // 结界视觉 + 保护 Buff + 结界节点（A1 容器负责超限替换与连线）
  // 跟随特效：高度走子配置（无内置到期，随窗口收口销毁）
  debugLogForce("塞莉亚-W", "特效", "路径", 塞莉亚克莱尔表现配置.W结界主体.模型路径);
  创建单位坐标跟随特效(
    施法者,
    塞莉亚克莱尔表现配置.W结界主体.模型路径,
    W结界特效键,
    塞莉亚克莱尔表现配置.W结界主体.缩放,
    塞莉亚克莱尔表现配置.W结界主体.高度,
    1,
    undefined,
    0,
    塞莉亚克莱尔表现配置.W结界主体.RGB,
  );
  debugLogForce("塞莉亚-W", "Buff", "操作", "施加", "目标", 施法者);
  registerManualBuff(施法者, 塞莉亚BuffID.解析结界, 塞莉亚克莱尔W配置.保护窗口秒, 0);
  // 施法真正成功（节点与保护已建立）：授予一次演算普攻窗口
  授予塞莉亚演算窗口(施法者);
  创建塞莉亚节点(施法者, "结界", GetUnitX(施法者), GetUnitY(施法者), _技能实例ID);

  // 常驻护盾
  数据.护盾ID = 开始护盾(施法者, {
    类型: 0,
    数值: 读取单位攻击力(施法者) * 塞莉亚克莱尔W配置.护盾攻击力倍率,
    持续时间: 塞莉亚克莱尔W配置.保护窗口秒,
    来源单位: 施法者,
    标签: "塞莉亚-解析结界",
    显示护盾条: true,
  });

  // 结界展开音（保护窗口与结界实际建立后；单位绑定，参数配置驱动）
  Sound3DII_UnitPlayReuse(塞莉亚音效配置.W展开.路径, 施法者, 塞莉亚音效配置.W展开.裁断距离);

  // 主要攻击解析：注销推迟到遍历之外
  数据.修改器ID = registerDamageModifier(function W解析修改器(this: void, context: any): number {
    if (数据.已关闭 || 数据.主要攻击已解析) return context.currentDamage;
    if (context.target !== 施法者) return context.currentDamage;
    if (!(context.currentDamage > 0)) return context.currentDamage;
    const 攻击者 = context.attacker;
    if (攻击者 == null || 攻击者 === 0 || 攻击者 === 施法者) return context.currentDamage;
    if (!jass.IsUnitEnemy(攻击者, jass.GetOwningPlayer(施法者))) return context.currentDamage;
    if (getGameTime() >= 数据.窗口结束时间) return context.currentDamage;

    数据.主要攻击已解析 = true;

    // 结界共鸣音（主要攻击被解析吸收的成功防御分支内一次；单位绑定，参数配置驱动）
    Sound3DII_UnitPlayReuse(塞莉亚音效配置.W共鸣.路径, 施法者, 塞莉亚音效配置.W共鸣.裁断距离);

    addDelayedCallback(10, function W解析结算(this: void): void {
      if (数据.已关闭) return;
      unregisterDamageModifier(数据.修改器ID);
      数据.修改器ID = 0;
      if (单位存活(攻击者)) {
        // 反冲 + 减速（真实控制入口）
        debugLogForce("塞莉亚-W", "伤害", "标签", "塞莉亚-解析反冲", "数值", 读取单位攻击力(施法者) * 塞莉亚克莱尔W配置.反冲伤害攻击力倍率);
        造成技能伤害({
          来源: 施法者,
          目标: 攻击者,
          伤害: 读取单位攻击力(施法者) * 塞莉亚克莱尔W配置.反冲伤害攻击力倍率,
          伤害类型: DAMAGE_TYPE_MAGIC,
          攻击类型: ATTACK_TYPE_NORMAL,
          武器类型: WEAPON_TYPE_WHOKNOWS,
          来源类型: "单位技能",
          标签: "塞莉亚-解析反冲",
          伤害形态: "单体",
          参与技能伤害加成: true,
        });
        施加扩展控制(施法者, 攻击者, "slow", 塞莉亚克莱尔W配置.反冲减速秒);
      }
      // 联动：结界+锚定连接时额外一次束缚爆发（以自身为中心）
      if (有结界锚定连接(施法者) && 单位存活(施法者)) {
        AOE施加扩展控制(施法者, GetUnitX(施法者), GetUnitY(施法者), 塞莉亚克莱尔W配置.结界锚定束缚半径, "roots", 塞莉亚克莱尔W配置.结界锚定束缚秒);
      }
    });

    return context.currentDamage * (1 - 塞莉亚克莱尔W配置.解析减免比例);
  }, 50);

  // 自然结束收口
  addDelayedCallback(塞莉亚克莱尔W配置.保护窗口秒 * 1000, function W窗口自然结束(this: void): void {
    关闭W结界(数据, "自然结束");
  });

  // 打断 / 死亡 / 场景清理兜底
  const 注销 = 登记塞莉亚技能清理(施法者, "W结界", function W结界清理(this: void): void {
    关闭W结界(数据, "打断");
  });
  void 注销;
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册塞莉亚W(this: void): void {
  debugLogForce("塞莉亚-W", "注册", "名称", "注册塞莉亚W");
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "塞莉亚·克莱尔-解析结界（W）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 塞莉亚克莱尔技能配置.W.技能ID,
    获取或创建上下文: function W上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放W解析结界,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 8,
  });
}

export {};
