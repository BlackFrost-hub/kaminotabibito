/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, 施法单位: any, 技能ID: number) => void) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, 单位: any) => boolean;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};
const { 距离平方XY } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  距离平方XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 发送单位提示给玩家 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送单位提示给玩家: (this: void, 目标玩家: any, 来源单位: any, 文本: string, 持续时间?: number) => void;
};
const { getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
};

import type { 环境互动触发点 } from "./00．环境互动配置";
const {
  环境互动技能ID,
  环境互动默认触发范围,
  环境互动空挥提示文本,
  环境互动空挥提示持续毫秒,
  环境互动空挥提示冷却毫秒,
} = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置") as {
  环境互动技能ID: string;
  环境互动默认触发范围: number;
  环境互动空挥提示文本: string;
  环境互动空挥提示持续毫秒: number;
  环境互动空挥提示冷却毫秒: number;
};

const GetOwningPlayer = jass.GetOwningPlayer as (this: void, 单位: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, 玩家: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, 单位: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, 单位: any) => number;
const GetRandomReal = jass.GetRandomReal as (this: void, 最小值: number, 最大值: number) => number;

const 环境互动调查点列表: 环境互动触发点[] = [];
let 已初始化环境互动 = false;
/** 玩家ID -> 上次空挥提示的游戏时间。只用于提示节流，与互动点生命周期无关。 */
const 空挥提示上次时间表: Record<number, number> = {};

function 移除调查点(this: void, 调查点ID: string): boolean {
  for (let i = 0; i < 环境互动调查点列表.length; i++) {
    if (环境互动调查点列表[i].ID !== 调查点ID) continue;
    环境互动调查点列表.splice(i, 1);
    return true;
  }
  return false;
}

/** 施法范围内没有可取互动时，只对施法玩家反馈；按玩家节流，避免连续施法刷屏。 */
function 提示空挥(this: void, 玩家: any, 施法单位: any, 玩家ID: number): void {
  const 当前时间 = getGameTime();
  const 上次时间 = 空挥提示上次时间表[玩家ID];
  if (上次时间 != null && 当前时间 - 上次时间 < 环境互动空挥提示冷却毫秒) return;
  空挥提示上次时间表[玩家ID] = 当前时间;
  发送单位提示给玩家(玩家, 施法单位, 环境互动空挥提示文本, 环境互动空挥提示持续毫秒);
}

/** 概率奖励失败是一次有效互动，不能走空挥节流，否则玩家可能收不到结果。 */
function 提示环境互动无效(this: void, 玩家: any, 施法单位: any): void {
  发送单位提示给玩家(玩家, 施法单位, 环境互动空挥提示文本, 环境互动空挥提示持续毫秒);
}

function 处理环境互动技能(this: void, 施法单位: any, 技能ID: number): void {
  if (施法单位 == null || 施法单位 === 0 || !是玩家英雄组单位(施法单位)) return;
  if (技能ID !== 解析配置内部ID(环境互动技能ID)) return;

  const 玩家 = GetOwningPlayer(施法单位);
  if (玩家 == null || 玩家 === 0) return;
  const 玩家ID = GetPlayerId(玩家);
  const 施法X = GetUnitX(施法单位);
  const 施法Y = GetUnitY(施法单位);

  for (let i = 0; i < 环境互动调查点列表.length; i++) {
    const 调查点 = 环境互动调查点列表[i];
    const 触发范围 = 调查点.触发范围 != null && 调查点.触发范围 > 0
      ? 调查点.触发范围
      : 环境互动默认触发范围;
    if (距离平方XY(施法X, 施法Y, 调查点.X, 调查点.Y) > 触发范围 * 触发范围) continue;

    if (调查点.一次性奖励概率 != null) {
      if (调查点.触发前置检查 != null && !调查点.触发前置检查(玩家ID, 施法单位, 调查点)) continue;

      // 前置条件满足后立刻消费点位，成功和失败都不能再次触发。
      移除调查点(调查点.ID);
      if (GetRandomReal(0, 1) >= 调查点.一次性奖励概率) {
        提示环境互动无效(玩家, 施法单位);
        return;
      }

      if (!调查点.触发回调(玩家ID, 施法单位, 调查点)) 提示环境互动无效(玩家, 施法单位);
      return;
    }

    if (调查点.触发回调(玩家ID, 施法单位, 调查点)) {
      if (调查点.一次性 !== false) 移除调查点(调查点.ID);
      return;
    }
  }

  提示空挥(玩家, 施法单位, 玩家ID);
}

/** 注册一个可被环境互动技能触发的调查点；同 ID 会先替换旧配置。 */
export function 注册环境互动调查点(this: void, 调查点: 环境互动触发点): boolean {
  if (调查点 == null || 调查点.ID === "" || 调查点.触发回调 == null) return false;
  移除调查点(调查点.ID);
  环境互动调查点列表.push(调查点);
  return true;
}

/** 注销指定调查点，返回是否找到并移除。 */
export function 注销环境互动调查点(this: void, 调查点ID: string): boolean {
  if (调查点ID === "") return false;
  return 移除调查点(调查点ID);
}

/** 注销全部调查点；任务结束、场景切换或失败清理时使用。 */
export function 清理全部环境互动调查点(this: void): void {
  for (let i = 环境互动调查点列表.length - 1; i >= 0; i--) {
    环境互动调查点列表.pop();
  }
}

export function init环境互动(this: void): void {
  if (已初始化环境互动) return;
  已初始化环境互动 = true;
  const 旧环境互动模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.02．旧环境互动.01．旧环境互动核心") as {
    注册旧环境互动调查点?: (this: void) => void;
  };
  旧环境互动模块.注册旧环境互动调查点?.();
  const 祖地探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.02．第二章.03．精灵祖地.00．入口配置") as {
    注册精灵祖地探索点?: (this: void) => void;
  };
  祖地探索模块.注册精灵祖地探索点?.();
  const 王城探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.02．第二章.01．精灵王城.00．入口配置") as {
    注册精灵王城探索点?: (this: void) => void;
  };
  王城探索模块.注册精灵王城探索点?.();
  const 静灵森探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.01．第一章.01．静灵森.00．入口配置") as {
    注册静灵森探索点?: (this: void) => void;
  };
  静灵森探索模块.注册静灵森探索点?.();
  const 精灵村探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.01．第一章.02．精灵村.00．入口配置") as {
    注册精灵村探索点?: (this: void) => void;
  };
  精灵村探索模块.注册精灵村探索点?.();
  const 盗贼洞窟探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.01．第一章.03．盗贼洞窟.00．入口配置") as {
    注册盗贼洞窟探索点?: (this: void) => void;
  };
  盗贼洞窟探索模块.注册盗贼洞窟探索点?.();
  const 精灵传送阵探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.02．第二章.04．精灵传送阵.00．入口配置") as {
    注册精灵传送阵探索点?: (this: void) => void;
  };
  精灵传送阵探索模块.注册精灵传送阵探索点?.();
  const 灼热火山探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.03．第三章.06．灼热火山.00．入口配置") as {
    注册灼热火山探索点?: (this: void) => void;
  };
  灼热火山探索模块.注册灼热火山探索点?.();
  const 恶魔城探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.03．第三章.01．恶魔城.00．入口配置") as {
    注册恶魔城探索点?: (this: void) => void;
  };
  恶魔城探索模块.注册恶魔城探索点?.();
  const 恶魔迷宫探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.03．第三章.08．恶魔迷宫.00．入口配置") as {
    注册恶魔迷宫探索点?: (this: void) => void;
  };
  恶魔迷宫探索模块.注册恶魔迷宫探索点?.();
  const 王庭探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.02．第二章.05．王庭.00．入口配置") as {
    注册王庭探索点?: (this: void) => void;
  };
  王庭探索模块.注册王庭探索点?.();
  const 钥匙圣地探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.02．第二章.06．钥匙圣地.00．入口配置") as {
    注册钥匙圣地探索点?: (this: void) => void;
  };
  钥匙圣地探索模块.注册钥匙圣地探索点?.();
  const 火焰神殿探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.03．第三章.03．火焰神殿.00．入口配置") as {
    注册火焰神殿探索点?: (this: void) => void;
  };
  火焰神殿探索模块.注册火焰神殿探索点?.();
  const 英灵墓地探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.03．第三章.04．英灵墓地.00．入口配置") as {
    注册英灵墓地探索点?: (this: void) => void;
  };
  英灵墓地探索模块.注册英灵墓地探索点?.();
  const 封印核心探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.03．第三章.05．封印核心.00．入口配置") as {
    注册封印核心探索点?: (this: void) => void;
  };
  封印核心探索模块.注册封印核心探索点?.();
  const 悲风山谷探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.01．第一章.04．悲风山谷.00．入口配置") as {
    注册悲风山谷探索点?: (this: void) => void;
  };
  悲风山谷探索模块.注册悲风山谷探索点?.();
  const 恶魔城野外熔岩探索模块 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.03．第三章.01．恶魔城.01．野外熔岩区.00．入口配置") as {
    注册恶魔城野外熔岩探索点?: (this: void) => void;
  };
  恶魔城野外熔岩探索模块.注册恶魔城野外熔岩探索点?.();
  registerSpellEffectListener(处理环境互动技能);
}

export {};
