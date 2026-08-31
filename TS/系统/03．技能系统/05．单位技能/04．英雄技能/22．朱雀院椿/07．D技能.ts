/** @noSelfInFile */

import {
  朱雀院椿技能配置,
  朱雀院椿动作配置,
  朱雀院椿动作槽,
  朱雀院椿D配置,
  朱雀院椿音效配置,
} from "./00．配置";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
};
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, 参数: any) => void;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { 播放英雄技能喊话 } = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话") as {
  播放英雄技能喊话: (this: void, 施法者: any, 英雄名: string, 技能ID: string) => boolean;
};
const {
  是朱雀院椿,
  获取姿态,
  设置姿态,
  姿态是否锁定,
  扣除VF,
  恢复VF,
  登记椿清理,
  播放椿动作,
} = require("./02．被动效果") as {
  是朱雀院椿: (this: void, unit: any) => boolean;
  获取姿态: (this: void, 英雄: any) => string;
  设置姿态: (this: void, 英雄: any, 姿态: string) => void;
  姿态是否锁定: (this: void, 英雄: any) => boolean;
  扣除VF: (this: void, 英雄: any, 量: number) => number;
  恢复VF: (this: void, 英雄: any, 量: number) => boolean;
  登记椿清理: (this: void, 英雄: any, 名称: string, 清理: () => void) => void;
  播放椿动作: (this: void, 英雄: any, 槽: { 索引: number; 持续秒: number }) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(朱雀院椿技能配置.单位类型ID);
const D配置 = 朱雀院椿D配置;

//=============================================================================
// 二刀攻势状态：持续 VF 消耗计时器（切回一刀/死亡/场景清理立即停止）
//=============================================================================

interface 二刀状态 {
  到期回调ID: number;
  消耗周期ID: number;
}

const 二刀状态表: Record<number, 二刀状态 | undefined> = {};

function 停止二刀消耗(this: void, 英雄: any): void {
  const id = jass.GetHandleId(英雄);
  const 状态 = 二刀状态表[id];
  if (状态 == null) return;
  if (状态.到期回调ID !== 0) removeDelayedCallback(状态.到期回调ID);
  if (状态.消耗周期ID !== 0) removePeriodicCallback(状态.消耗周期ID);
  delete 二刀状态表[id];
}

function 进入二刀攻势(this: void, 施法者: any): void {
  设置姿态(施法者, "二刀");
  停止二刀消耗(施法者);
  const 状态: 二刀状态 = { 到期回调ID: 0, 消耗周期ID: 0 };
  // 到期自动回一刀
  状态.到期回调ID = addDelayedCallback(D配置.二刀持续秒 * 1000, function D二刀到期(this: void): void {
    停止二刀消耗(施法者);
    设置姿态(施法者, "一刀");
  });
  // 每秒 VF 消耗；VF 归零强制回一刀
  状态.消耗周期ID = addPeriodicCallback(1000, function D二刀消耗(this: void): void {
    if (!是朱雀院椿(施法者)) {
      停止二刀消耗(施法者);
      return;
    }
    const 剩余 = 扣除VF(施法者, D配置.二刀每秒VF消耗);
    if (D配置.VF归零强制回一刀 && 剩余 <= 0) {
      停止二刀消耗(施法者);
      设置姿态(施法者, "一刀");
    }
  });
  二刀状态表[jass.GetHandleId(施法者)] = 状态;
  登记椿清理(施法者, "椿D二刀", function D二刀清理(this: void): void {
    停止二刀消耗(施法者);
  });
}

function 释放D姿态切换(this: void, _context: any, 施法者: any, _技能实例ID: number | undefined): void {
  if (!是朱雀院椿(施法者)) return;
  // R 蓄力期间姿态锁定：禁止切换
  if (姿态是否锁定(施法者)) return;
  播放椿动作(施法者, 朱雀院椿动作槽.D切换);
  const 当前 = 获取姿态(施法者);
  if (当前 === "一刀") {
    进入二刀攻势(施法者);
  } else {
    // 切回一刀：停止消耗 + 恢复部分 VF
    停止二刀消耗(施法者);
    设置姿态(施法者, "一刀");
    恢复VF(施法者, D配置.切回一刀恢复VF);
  }
  // 姿态切换音（切换实际成功后播；8s CD 反复切换均播；单位=施法者，参数配置驱动）
  Sound3DII_UnitPlayReuse(朱雀院椿音效配置.D切换.路径, 施法者, 朱雀院椿音效配置.D切换.裁断距离);
  // 技能喊话：姿态切换成功起点（全局 3D；随机二选一由喊话系统驱动）
  播放英雄技能喊话(施法者, "朱雀院椿", 朱雀院椿技能配置.D.技能ID);
}

//=============================================================================
// 注册入口（幂等）
//=============================================================================

let 已注册 = false;

export function 注册朱雀院椿D(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "朱雀院椿-浴火鸟·二刀解放（D）",
    单位类型ID: 英雄单位类型ID,
    技能ID: "ATD1",
    获取或创建上下文: function D上下文(this: void, unit: any): any {
      return { 英雄: unit };
    },
    释放技能: 释放D姿态切换,
    创建独立技能实例: false,
  });
}

export const 朱雀院椿D模块 = {
  技能ID: 朱雀院椿技能配置.D.技能ID,
  注册: 注册朱雀院椿D,
} as const;
