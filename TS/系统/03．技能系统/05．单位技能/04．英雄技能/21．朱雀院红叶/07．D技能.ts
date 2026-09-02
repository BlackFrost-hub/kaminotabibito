/** @noSelfInFile */

import {
  朱雀院红叶技能配置,
  朱雀院红叶表现配置,
  朱雀院红叶音效配置,
  朱雀院红叶Buff配置,
  朱雀院红叶动作配置,
  朱雀院红叶动作槽,
  朱雀院红叶待平衡数值,
} from "./00．配置";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
};
const { getGameTime, addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
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
const {
  是朱雀院红叶,
  登记朱雀院清理,
  注册破绽斩监听,
  播放红叶动作,
} = require("./02．被动效果") as {
  是朱雀院红叶: (this: void, unit: any) => boolean;
  登记朱雀院清理: (this: void, 英雄: any, 名称: string, 清理: () => void) => void;
  注册破绽斩监听: (this: void, 回调: (this: void, 红叶: any, 目标: any) => void) => void;
  播放红叶动作: (this: void, 英雄: any, 槽: { 索引: number; 持续秒: number }) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(朱雀院红叶技能配置.单位类型ID);
const 秘传BuffID = 朱雀院红叶Buff配置.秘传三式;
const D配置 = 朱雀院红叶待平衡数值.D;
const D秘传三式音效 = 朱雀院红叶音效配置.D秘传三式;
const 刀环特效键 = "朱雀院红叶D刀环";

//=============================================================================
// D 秘传三式：8 秒、3 次强化资源
//=============================================================================

interface D状态 {
  剩余次数: number;
  到期时间: number;
  延长次数: number;
  到期回调ID: number;
}

const D状态表: Record<number, D状态 | undefined> = {};

function 刷新D显示(this: void, 英雄: any, 状态: D状态): void {
  const 剩余秒 = 状态.到期时间 - getGameTime();
  if (剩余秒 <= 0) {
    移除D状态(英雄);
    return;
  }
  registerManualBuff(英雄, 秘传BuffID, 剩余秒, 状态.剩余次数, { stack: 状态.剩余次数 });
}

function 移除D状态(this: void, 英雄: any): void {
  if (英雄 == null || 英雄 === 0) return;
  const id = jass.GetHandleId(英雄);
  const 状态 = D状态表[id];
  if (状态 == null) return;
  if (状态.到期回调ID !== 0) {
    removeDelayedCallback(状态.到期回调ID);
    状态.到期回调ID = 0;
  }
  debugLogForce("红叶-D", "Buff", "操作", "移除", "目标", 英雄);
  销毁单位坐标跟随特效(英雄, 刀环特效键);
  移除单位指定Buff(英雄, 秘传BuffID);
  delete D状态表[id];
}

function 开启D秘传三式(this: void, _context: any, 施法者: any, _技能实例ID: number | undefined): void {
  debugLogForce("红叶-D", "释放", "技能实例ID", "-");
  if (!是朱雀院红叶(施法者)) return;
  播放红叶动作(施法者, 朱雀院红叶动作槽.D启动);
  // 技能喊话：施法成功起点（全局 3D；随机二选一由喊话系统驱动；重复 D 刷新同样视为成功施法）
  播放英雄技能喊话(施法者, "朱雀院红叶", 朱雀院红叶技能配置.D.技能ID);
  const id = jass.GetHandleId(施法者);
  const 已有 = D状态表[id];
  if (已有 != null) {
    // 重复 D：刷新持续时间，次数保持（不叠加到 6 次）
    if (已有.到期回调ID !== 0) removeDelayedCallback(已有.到期回调ID);
    已有.到期时间 = getGameTime() + D配置.持续秒;
    已有.到期回调ID = addDelayedCallback(D配置.持续秒 * 1000, function D到期(this: void): void {
      移除D状态(施法者);
    });
    刷新D显示(施法者, 已有);
    return;
  }
  const 状态: D状态 = {
    剩余次数: D配置.强化次数,
    到期时间: getGameTime() + D配置.持续秒,
    延长次数: 0,
    到期回调ID: 0,
  };
  状态.到期回调ID = addDelayedCallback(D配置.持续秒 * 1000, function D到期(this: void): void {
    移除D状态(施法者);
  });
  D状态表[id] = 状态;
  debugLogForce("红叶-D", "状态", "开启秘传", 状态.剩余次数);
  刷新D显示(施法者, 状态);
  // 秘传刀环表现（模型/缩放/高度/RGB 全由表现配置驱动；秘传结束 移除D状态 统一销毁）
  if ((朱雀院红叶表现配置.D刀环.模型路径 as string) !== "") {
    创建单位坐标跟随特效(
      施法者,
      朱雀院红叶表现配置.D刀环.模型路径,
      刀环特效键,
      朱雀院红叶表现配置.D刀环.缩放,
      朱雀院红叶表现配置.D刀环.高度,
      1,
      undefined,
      0,
      朱雀院红叶表现配置.D刀环.RGB,
    );
  }
  // 秘传三式启动音（单次激活成功时一次；单位绑定，参数配置驱动；重复 D 刷新不重播，强化消费不单独响）
  Sound3DII_UnitPlayReuse(D秘传三式音效.路径, 施法者, D秘传三式音效.裁断距离);
  登记朱雀院清理(施法者, "红叶D", function D清理(this: void): void {
    移除D状态(施法者);
  });
}

//=============================================================================
// 强化消费接口（Q/W/E/R 在真正进入强化分支时调用）
//=============================================================================

/** 尝试消费 1 次 D 强化（无 D 状态或次数不足返回 false，技能仍执行基础效果） */
export function 尝试消费D强化(this: void, 英雄: any): boolean {
  if (英雄 == null || 英雄 === 0) return false;
  const 状态 = D状态表[jass.GetHandleId(英雄)];
  if (状态 == null || 状态.剩余次数 <= 0) return false;
  状态.剩余次数 = 状态.剩余次数 - 1;
  刷新D显示(英雄, 状态);
  return true;
}

/** 消费 D 的全部剩余强化次数（R 终式用），返回实际消费次数 */
export function 消费全部D强化(this: void, 英雄: any): number {
  if (英雄 == null || 英雄 === 0) return 0;
  const 状态 = D状态表[jass.GetHandleId(英雄)];
  if (状态 == null) return 0;
  const 次数 = 状态.剩余次数;
  if (次数 <= 0) return 0;
  状态.剩余次数 = 0;
  刷新D显示(英雄, 状态);
  return 次数;
}

/** R 收束 / 主动结束 D（移除 Buff、刀环、计时器与表项） */
export function 结束D秘传(this: void, 英雄: any): void {
  移除D状态(英雄);
}

/** 获取 D 剩余强化次数（R 判定用） */
export function 获取D剩余强化次数(this: void, 英雄: any): number {
  if (英雄 == null || 英雄 === 0) return 0;
  const 状态 = D状态表[jass.GetHandleId(英雄)];
  return 状态 != null ? 状态.剩余次数 : 0;
}

//=============================================================================
// 破绽斩延长（最多两次）
//=============================================================================

function 破绽斩延长D(this: void, 红叶: any, _目标: any): void {
  if (红叶 == null || 红叶 === 0) return;
  const 状态 = D状态表[jass.GetHandleId(红叶)];
  if (状态 == null) return;
  if (状态.延长次数 >= D配置.最大延长次数) return;
  状态.延长次数 = 状态.延长次数 + 1;
  状态.到期时间 = 状态.到期时间 + D配置.延长秒;
  if (状态.到期回调ID !== 0) removeDelayedCallback(状态.到期回调ID);
  状态.到期回调ID = addDelayedCallback((状态.到期时间 - getGameTime()) * 1000, function D延长到期(this: void): void {
    移除D状态(红叶);
  });
  刷新D显示(红叶, 状态);
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册朱雀院红叶D(this: void): void {
  debugLogForce("红叶-D", "注册", "名称", "D", "函数", "注册朱雀院红叶D");
  if (已注册) return;
  已注册 = true;
  注册破绽斩监听(破绽斩延长D);
  注册单位技能壳监听({
    名称: "朱雀院红叶-秘传三式（D）",
    单位类型ID: 英雄单位类型ID,
    技能ID: "AMD1",
    获取或创建上下文: function D上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 开启D秘传三式,
    创建独立技能实例: false,
  });
}

export const 朱雀院红叶D模块 = {
  技能ID: 朱雀院红叶技能配置.D.技能ID,
  持续秒: D配置.持续秒,
  强化次数: D配置.强化次数,
  注册: 注册朱雀院红叶D,
} as const;
