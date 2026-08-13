/** @noSelfInFile */

import { 读取剧情进度, 注册剧情进度变更监听 } from "../../../01．主线任务/00．剧情系统核心工具/01．剧情动作上下文";
import { 祖地双灵卫副本配置 } from "./01．祖地双灵卫副本配置";
import { 祖地双灵卫副本状态 } from "./02．祖地双灵卫副本状态";
import { 创建祖地双灵卫试炼 } from "./03．祖地双灵卫试炼";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { 创建剧情NPC单位 } = require("系统.11．剧情系统.00．公共.02．剧情NPC创建") as {
  创建剧情NPC单位: (this: void, config: any) => any;
};
const { 消费世界地图单位缓存, 祖地双灵卫守门单位缓存键 } = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.09．世界地图单位缓存") as {
  消费世界地图单位缓存: (this: void, 缓存键: string) => any;
  祖地双灵卫守门单位缓存键: string;
};
const { 注册世界地图全部单位创建完成监听 } = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.10．世界地图单位总调度") as {
  注册世界地图全部单位创建完成监听: (this: void, 监听函数: (this: void) => void) => void;
};
const { addSelectionListener } = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  addSelectionListener: (
    this: void,
    listener: (this: void, player: any, playerId: number, unit: any, isSelected: boolean) => void,
  ) => void;
};
const { 创建矩形进入监听 } = require("系统.00．核心系统.01．事件中心.02．区域事件中心") as {
  创建矩形进入监听: (this: void, rect: any, callback: (this: void) => void, filter?: any) => { 取消: (this: void) => void } | null;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, sourceUnit: any, text: string, durationMs?: number) => void;
};
const { ModifyGateBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  ModifyGateBJ: (this: void, operation: number, gate: any) => void;
};
const { 是玩家英雄组单位, getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
  getRegisteredPlayerHero: (this: void, player: any) => any;
};

const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const PingMinimap = jass.PingMinimap as (this: void, x: number, y: number, duration: number) => void;
const Rect = jass.Rect as (this: void, minX: number, minY: number, maxX: number, maxY: number) => any;
const RemoveRect = jass.RemoveRect as (this: void, rect: any) => void;

const 玩家最小ID = 0;
const 玩家最大ID = 5;
const 守门触发半径 = 280;
const 守门警告已播放表: Record<number, boolean | undefined> = {};

let 入口模块已初始化 = false;
let 守门范围监听: { 取消: (this: void) => void } | null = null;
let 本思雅待对话玩家: any = null;
let 本思雅待对话英雄: any = null;

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 是玩家槽位(this: void, playerId: number): boolean {
  return playerId >= 玩家最小ID && playerId <= 玩家最大ID;
}

function 打开配置闸门(this: void, variableName: string): boolean {
  const gate = jglobals[variableName];
  if (!句柄有效(gate)) return false;
  ModifyGateBJ(jglobals.bj_GATEOPERATION_OPEN, gate);
  return true;
}

function 确保创建守门单位(this: void): any {
  if (句柄有效(祖地双灵卫副本状态.守门单位)) return 祖地双灵卫副本状态.守门单位;
  const unit = 消费世界地图单位缓存(祖地双灵卫守门单位缓存键);
  if (!句柄有效(unit)) return null;
  祖地双灵卫副本状态.守门单位 = unit;
  return unit;
}

function on世界地图单位创建完成(this: void): void {
  确保创建守门单位();
}

function 确保创建本思雅(this: void): any {
  if (句柄有效(祖地双灵卫副本状态.本思雅单位)) return 祖地双灵卫副本状态.本思雅单位;
  const progress = 读取剧情进度();
  if (progress < 祖地双灵卫副本配置.开放剧情进度最小值 || progress > 祖地双灵卫副本配置.开放剧情进度最大值) return null;
  const cfg = 祖地双灵卫副本配置.本思雅;
  const unit = 创建剧情NPC单位({
    单位ID: cfg.单位ID,
    X: cfg.X,
    Y: cfg.Y,
    朝向: cfg.朝向,
    玩家ID: 15,
    初始化无敌: true,
    初始化固定站立: true,
  });
  祖地双灵卫副本状态.本思雅单位 = unit;
  return unit;
}

function 确保创建埃德里安(this: void): any {
  if (句柄有效(祖地双灵卫副本状态.埃德里安单位)) return 祖地双灵卫副本状态.埃德里安单位;
  const cfg = 祖地双灵卫副本配置.埃德里安;
  const unit = 创建剧情NPC单位({
    单位ID: cfg.单位ID,
    X: cfg.X,
    Y: cfg.Y,
    朝向: cfg.朝向,
    玩家ID: 15,
    初始化无敌: true,
    初始化固定站立: true,
  });
  祖地双灵卫副本状态.埃德里安单位 = unit;
  return unit;
}

function 清理本思雅待对话状态(this: void): void {
  本思雅待对话玩家 = null;
  本思雅待对话英雄 = null;
}

function on拒绝本思雅任务(this: void): void {
  清理本思雅待对话状态();
}

function on接受本思雅任务(this: void): void {
  if (祖地双灵卫副本状态.任务已接受) {
    清理本思雅待对话状态();
    return;
  }
  祖地双灵卫副本状态.任务已接受 = true;
  const adrian = 确保创建埃德里安();
  清理本思雅待对话状态();
  if (句柄有效(adrian)) {
    广播单位提示(adrian, "带着长老的信物来见我。祖地只承认经得住考验的人。", 4800);
    PingMinimap(祖地双灵卫副本配置.埃德里安.X, 祖地双灵卫副本配置.埃德里安.Y, 5);
  }
}

function 打开本思雅已接受对话(this: void, player: any, hero: any): void {
  const UI函数 = require("系统.00．核心系统.03．UI函数") as {
    openNpcDialog: (this: void, player: any, data: any) => boolean;
  };
  UI函数.openNpcDialog(player, {
    lines: [
      {
        title: "本·思雅",
        text: "信物已经交给你们。守门者认得上面的灵印，埃德里安会在祖地入口等候。",
        duration: 4800,
      },
    ],
    npcUnit: 祖地双灵卫副本状态.本思雅单位,
    对话目标单位: hero,
    NPC配置朝向: 祖地双灵卫副本配置.本思雅.朝向,
  });
}

function 打开本思雅任务对话(this: void, player: any, hero: any): void {
  本思雅待对话玩家 = player;
  本思雅待对话英雄 = hero;
  const UI函数 = require("系统.00．核心系统.03．UI函数") as {
    openNpcDialog: (this: void, player: any, data: any) => boolean;
  };
  const opened = UI函数.openNpcDialog(player, {
    lines: [
      {
        title: "本·思雅",
        text: "祖地深处的灵流近来反复震荡。那不是自然的回响，而是两道旧誓正在彼此撕扯。",
        duration: 4600,
      },
      {
        title: "本·思雅",
        text: "祖地从不轻易向外人开放。但若任由那股力量继续冲撞，沉睡的旧灵迟早会波及外界。",
        duration: 4800,
      },
    ],
    quest: {
      title: "精灵往事",
      text: "前往精灵祖地，通过守护官埃德里安的三项试炼，并查清祖地深处两道异常灵息的来源。",
      acceptText: "接受委托",
      rejectText: "稍后再谈",
      onAccept: on接受本思雅任务,
      onReject: on拒绝本思雅任务,
    },
    npcUnit: 祖地双灵卫副本状态.本思雅单位,
    对话目标单位: hero,
    NPC配置朝向: 祖地双灵卫副本配置.本思雅.朝向,
    restoreYellowQuestMarkerAfterDialog: true,
  });
  if (!opened) 清理本思雅待对话状态();
}

function 取试炼进度文本(this: void, completed: boolean): string {
  return completed ? "已完成 √" : "未完成";
}

function 打开埃德里安试炼对话(this: void, player: any, hero: any): void {
  const trial = 祖地双灵卫副本状态.试炼;
  const text = "祖地认可的不是一时侥幸，而是足以承担后果的力量。\n\n"
    + "持续输出：20 秒保持 2000 DPS（" + 取试炼进度文本(trial.持续伤害.已完成) + "）\n"
    + "爆发伤害：单次伤害超过 10000（" + 取试炼进度文本(trial.单次伤害.已完成) + "）\n"
    + "限时治疗：10 秒内将 1/5000 生命的目标治满（" + 取试炼进度文本(trial.治疗.已完成) + "）";
  const UI函数 = require("系统.00．核心系统.03．UI函数") as {
    openNpcDialog: (this: void, player: any, data: any) => boolean;
  };
  UI函数.openNpcDialog(player, {
    lines: [{ title: "埃德里安", text, duration: 9000 }],
    npcUnit: 祖地双灵卫副本状态.埃德里安单位,
    对话目标单位: hero,
    NPC配置朝向: 祖地双灵卫副本配置.埃德里安.朝向,
  });
}

function on祖地双灵卫NPC选择(this: void, player: any, playerId: number, unit: any, isSelected: boolean): void {
  if (!isSelected || !是玩家槽位(playerId) || !句柄有效(unit)) return;
  if (unit === 祖地双灵卫副本状态.本思雅单位) {
    const progress = 读取剧情进度();
    if (progress < 祖地双灵卫副本配置.开放剧情进度最小值 || progress > 祖地双灵卫副本配置.开放剧情进度最大值) return;
    const hero = getRegisteredPlayerHero(player);
    if (祖地双灵卫副本状态.任务已接受) 打开本思雅已接受对话(player, hero);
    else 打开本思雅任务对话(player, hero);
    return;
  }
  if (unit === 祖地双灵卫副本状态.埃德里安单位 && 祖地双灵卫副本状态.任务已接受) {
    if (祖地双灵卫副本状态.Boss战已完成) return;
    打开埃德里安试炼对话(player, getRegisteredPlayerHero(player));
  }
}

function on守门放行广播结束(this: void): void {
  if (祖地双灵卫副本状态.守门已放行) return;
  祖地双灵卫副本状态.守门放行广播进行中 = false;
  祖地双灵卫副本状态.守门放行触发英雄 = null;
  祖地双灵卫副本状态.守门已放行 = true;
  打开配置闸门(祖地双灵卫副本配置.守门闸门变量名);
  确保创建埃德里安();
  创建祖地双灵卫试炼();
  广播单位提示(祖地双灵卫副本状态.埃德里安单位, "三座试炼靶已经准备好。每一项都必须由同一人独立完成。", 5200);
}

function 播放守门放行第三段(this: void): void {
  if (!祖地双灵卫副本状态.守门放行广播进行中) return;
  广播单位提示(
    祖地双灵卫副本状态.守门单位,
    "……确实是长老的灵印。进去吧，埃德里安会决定你们是否有资格继续前行。",
    5200,
  );
  addDelayedCallback(5200, on守门放行广播结束);
}

function 播放守门放行第二段(this: void): void {
  if (!祖地双灵卫副本状态.守门放行广播进行中) return;
  const hero = 祖地双灵卫副本状态.守门放行触发英雄;
  if (hero == null || hero === 0) {
    祖地双灵卫副本状态.守门放行广播进行中 = false;
    祖地双灵卫副本状态.守门放行触发英雄 = null;
    return;
  }
  广播单位提示(hero, "我们受本·思雅长老所托。这是她交给我们的信物。", 3800);
  addDelayedCallback(3800, 播放守门放行第三段);
}

function 开始守门放行广播(this: void, hero: any): void {
  if (祖地双灵卫副本状态.守门已放行 || 祖地双灵卫副本状态.守门放行广播进行中) return;
  祖地双灵卫副本状态.守门放行广播进行中 = true;
  祖地双灵卫副本状态.守门放行触发英雄 = hero;
  广播单位提示(祖地双灵卫副本状态.守门单位, "站住。祖地不接待外人。", 3000);
  addDelayedCallback(3000, 播放守门放行第二段);
}

function on进入祖地守门范围(this: void): void {
  const hero = GetTriggerUnit();
  if (!句柄有效(hero) || !是玩家英雄组单位(hero)) return;
  const player = GetOwningPlayer(hero);
  const playerId = 句柄有效(player) ? GetPlayerId(player) : -1;
  if (!是玩家槽位(playerId)) return;
  if (!祖地双灵卫副本状态.任务已接受) {
    if (守门警告已播放表[playerId] === true) return;
    守门警告已播放表[playerId] = true;
    广播单位提示(祖地双灵卫副本状态.守门单位, 祖地双灵卫副本配置.守门单位.靠近提示, 4200);
    return;
  }
  if (祖地双灵卫副本状态.守门已放行 || 祖地双灵卫副本状态.守门放行广播进行中) return;
  开始守门放行广播(hero);
}

function 注册守门范围(this: void): void {
  if (守门范围监听 != null) return;
  const cfg = 祖地双灵卫副本配置.守门单位;
  const rect = Rect(cfg.X - 守门触发半径, cfg.Y - 守门触发半径, cfg.X + 守门触发半径, cfg.Y + 守门触发半径);
  if (!句柄有效(rect)) return;
  守门范围监听 = 创建矩形进入监听(rect, on进入祖地守门范围, null);
  RemoveRect(rect);
}

function on祖地双灵卫剧情进度变化(this: void, newProgress: number, _oldProgress: number): void {
  if (newProgress >= 祖地双灵卫副本配置.开放剧情进度最小值 && newProgress <= 祖地双灵卫副本配置.开放剧情进度最大值) {
    确保创建本思雅();
  }
}

export function init祖地双灵卫入口与对话(this: void): void {
  if (入口模块已初始化) return;
  入口模块已初始化 = true;
  注册世界地图全部单位创建完成监听(on世界地图单位创建完成);
  确保创建守门单位();
  确保创建本思雅();
  注册守门范围();
  注册剧情进度变更监听(on祖地双灵卫剧情进度变化);
  addSelectionListener(on祖地双灵卫NPC选择);
}
