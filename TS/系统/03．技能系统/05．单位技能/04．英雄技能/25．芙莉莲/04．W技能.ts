/** @noSelfInFile */
/**
 * 芙莉莲 W：防御魔法·魔力护壁（B2：A4）
 *
 * 快照正面方向开启一次真实防御窗口（非 360° 无敌）；伤害修改入口处理一次主要攻击
 * （修改器在当前伤害遍历结束后注销）；成功→防御解析+演算普攻；自然结束→基础护盾；
 * 花田只小幅延长持续时间；成功/自然/中断/死亡互斥。
 */

import {
  芙莉莲技能配置,
  芙莉莲W配置,
  芙莉莲表现配置,
} from "./00．配置";
const { 开始循环守护, 停止循环守护, 芙莉莲动作槽 } = require("./01A．动作表现") as {
  开始循环守护: (this: void, 英雄: any, 槽: any, 登记名: string) => any;
  停止循环守护: (this: void, 句柄: any) => void;
  芙莉莲动作槽: { W保持防御: any };
};

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
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};
const { 开始护盾 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统") as {
  开始护盾: (this: void, 单位: any, 参数: any) => number;
};
const { 角度差绝对值 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  角度差绝对值: (this: void, a: number, b: number) => number;
};
const { 创建点特效, 创建单位坐标跟随特效, 销毁单位坐标跟随特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  /** 挂载特效（scale + height 驱动；替代 createUnitEffect 无高度入口的短板） */
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
};
const { 读取单位攻击力, 单位存活, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
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
// 花田联动（D 模块运行时 require 防循环依赖）
const 花田联动 = require("./07．D技能") as {
  尝试消费花田修正?: (this: void, 芙莉莲: any) => boolean;
};
const { 芙莉莲D配置 } = require("./00．配置") as {
  芙莉莲D配置: { 修正W持续加成秒: number };
};

const 英雄单位类型ID = stringToFourCCSafe(芙莉莲技能配置.单位类型ID);
const W技能ID = stringToFourCCSafe(芙莉莲技能配置.W.技能ID);
const W配置 = 芙莉莲W配置;
const 护壁特效键 = "芙莉莲W护壁";
const 公式层特效键 = "芙莉莲W公式层";

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;

interface W数据 {
  方向角: number;
  修饰ID: number;
  已防御: boolean;
  已结束: boolean;
  到期ID: number;
  /** 保持防御循环守护句柄（成功/自然/中断/死亡统一停止） */
  动作守护: any;
}

function 结束W护壁(this: void, 施法者: any, 技能实例ID: number | undefined, 数据: W数据, 自然结束: boolean): void {
  if (数据.已结束) return;
  数据.已结束 = true;
  // 保持防御动作守护停止（恢复 stand 与动画速度）
  if (数据.动作守护 != null) {
    停止循环守护(数据.动作守护);
    数据.动作守护 = null;
  }
  if (数据.修饰ID !== 0) {
    unregisterDamageModifier(数据.修饰ID);
    数据.修饰ID = 0;
  }
  if (数据.到期ID !== 0) {
    removeDelayedCallbackSafe(数据.到期ID);
    数据.到期ID = 0;
  }
  销毁单位坐标跟随特效(施法者, 护壁特效键);
  销毁单位坐标跟随特效(施法者, 公式层特效键);
  // 自然结束（无攻击进入）：基础护盾收尾（不伪造"已防御攻击"）
  if (自然结束 && 单位存活(施法者)) {
    开始护盾(施法者, {
      数值: 读取单位攻击力(施法者) * W配置.自然结束护盾倍率,
      持续时间: W配置.自然结束护盾持续秒,
      来源单位: 施法者,
      标签: "芙莉莲W自然护盾",
    });
  }
  // 完成/收尾由调用方决定
  void 技能实例ID;
}

const { removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  removeDelayedCallback: (this: void, id: number) => void;
};
function removeDelayedCallbackSafe(this: void, id: number): void {
  removeDelayedCallback(id);
}

function 释放W(this: void, _context: any, 施法者: any, 技能实例ID: number | undefined): void {
  if (!是芙莉莲(施法者)) return;
  // 不叠加窗口：已有活跃 W 实例时忽略
  if (查询战斗技能实例(施法者, "芙莉莲W").length > 0) return;
  记录芙莉莲活动(施法者);
  // 快照正面方向
  const 方向角 = GetUnitFacing(施法者);
  // 窗口时长：花田修正只小幅延长（单次消费锁），不增加保护次数
  let 窗口秒 = W配置.护壁持续秒;
  if (花田联动.尝试消费花田修正 != null && 花田联动.尝试消费花田修正(施法者)) {
    窗口秒 += 芙莉莲D配置.修正W持续加成秒;
  }
  const 数据: W数据 = { 方向角, 修饰ID: 0, 已防御: false, 已结束: false, 到期ID: 0, 动作守护: null };
  // 招架窗口保持防御动作（循环守护，结束/成功/自然/中断统一停止）
  数据.动作守护 = 开始循环守护(施法者, 芙莉莲动作槽.W保持防御, "芙莉莲W动作");

  const 控制器 = 创建战斗技能实例({
    技能键: "芙莉莲W",
    施法者,
    技能实例ID,
    数据,
    结束回调: function W结束(this: void, _原因: string, _c: any): void {
      // 中断/死亡收束（与 结束W护壁 幂等；自然结束=false 不给基础护盾）
      结束W护壁(施法者, 技能实例ID, 数据, false);
    },
  });

  // 护壁主体 + 防御公式层（常驻句柄，随实例/窗口统一销毁；不叠加定时自毁；缩放/高度 经 创建单位坐标跟随特效 配置驱动）
  const 护壁句柄 = 创建单位坐标跟随特效(施法者, 芙莉莲表现配置.W护壁, 护壁特效键, 芙莉莲表现配置.特效参数.W护壁.缩放, 芙莉莲表现配置.特效参数.W护壁.高度);
  void 护壁句柄;
  const 公式层句柄 = 创建单位坐标跟随特效(施法者, 芙莉莲表现配置.W公式层, 公式层特效键, 芙莉莲表现配置.特效参数.W公式层.缩放, 芙莉莲表现配置.特效参数.W公式层.高度);
  void 公式层句柄;

  // 一次主要攻击防御：来源在快照正面扇区内 → 化解一次（非 360° 无敌）
  数据.修饰ID = registerDamageModifier(function W防御修正(this: void, context: any): number {
    if (数据.已防御 || 数据.已结束) return context.currentDamage;
    if (context.target !== 施法者) return context.currentDamage;
    if (context.attacker == null || context.attacker === 0) return context.currentDamage;
    // 正面判定用窗口快照方向（公共扇区函数读当前面向；窗口期间转身不应改变防御扇区）
    const 来源角 = 两点角度(GetUnitX(施法者), GetUnitY(施法者), GetUnitX(context.attacker), GetUnitY(context.attacker));
    if (角度差绝对值(数据.方向角, 来源角) > W配置.正面角度 / 2) return context.currentDamage;
    if (context.currentDamage <= 0) return context.currentDamage;
    // 一次性防御成功
    数据.已防御 = true;
    const 来源 = context.attacker;
    // 收尾延迟到本次伤害修正遍历结束后（禁止在遍历中同步注销修改器）
    addDelayedCallback(0, function W防御成功收尾(this: void): void {
      // 受击反馈（参数配置驱动）
      创建点特效({
        模型路径: 芙莉莲表现配置.R命中反馈,
        X: GetUnitX(施法者),
        Y: GetUnitY(施法者),
        Z: 芙莉莲表现配置.特效参数.W受击反馈.高度,
        面向角度: 0,
        动画索引: 0,
        缩放: 芙莉莲表现配置.特效参数.W受击反馈.缩放,
        持续秒: 芙莉莲表现配置.特效参数.W受击反馈.持续秒,
      });
      // 对攻击来源记录防御解析
      施加解析(施法者, 来源, "防御");
      // 成功防御 → 提供一次演算普攻
      提供演算普攻(施法者);
      结束W护壁(施法者, 技能实例ID, 数据, false);
      控制器.完成();
    });
    // 化解本次伤害（防御化解比例 1 = 完全阻挡一次主要攻击）
    return context.currentDamage * (1 - W配置.防御化解比例);
  }, 60);

  // 自然结束（无攻击进入）
  数据.到期ID = addDelayedCallback(窗口秒 * 1000, function W窗口到期(this: void): void {
    if (数据.已结束) return;
    结束W护壁(施法者, 技能实例ID, 数据, true);
    控制器.完成();
  });
  控制器.登记延迟回调(数据.到期ID);
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册芙莉莲W(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "芙莉莲-防御魔法·魔力护壁（W）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 芙莉莲技能配置.W.技能ID,
    获取或创建上下文: function W上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放W,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: W配置.护壁持续秒 + 2,
  });
}
