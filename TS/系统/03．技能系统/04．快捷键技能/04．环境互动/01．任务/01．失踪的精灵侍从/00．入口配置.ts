/** @noSelfInFile */

import type { 任务配置 } from "../../../../../08．任务系统/00．配置表/02．任务配置表";
import type { 环境互动触发点 } from "../../00．通用/00．环境互动配置";

const { 注册环境互动调查点, 注销环境互动调查点 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心") as {
  注册环境互动调查点: (this: void, 调查点: 环境互动触发点) => boolean;
  注销环境互动调查点: (this: void, 调查点ID: string) => boolean;
};
const { 创建点特效, 销毁点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: { 模型路径: string; X: number; Y: number; Z?: number; 持续秒?: number }) => any;
  销毁点特效: (this: void, 特效: any) => void;
};
const { questDB } = require("系统.08．任务系统.01．任务数据") as {
  questDB: {
    updateObjective: (this: void, 玩家ID: number, 任务ID: string, 目标ID: string, 进度: number) => boolean;
    globalData?: { quests: Map<string, { objectives: Array<{ current: number; required: number }> }> };
  };
};
const { questManager } = require("系统.08．任务系统.02．任务管理器") as {
  questManager: { triggerUIRefresh: (this: void, 玩家ID: number, 任务ID?: string) => void };
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

export const 失踪的精灵侍从任务ID = 10024;
const 失踪的精灵侍从任务键 = tostring(失踪的精灵侍从任务ID);
const 失踪的精灵侍从任务目标ID = "obj1";

interface 失踪侍从调查线索配置 {
  ID: string;
  名称: string;
  X: number;
  Y: number;
  Z: number;
  模型路径: string;
  发现文本: string;
}

interface 失踪侍从调查线索运行状态 {
  ID: string;
  特效: any;
}

const 失踪侍从调查线索配置表: 失踪侍从调查线索配置[] = [
  {
    ID: "王庭徽记",
    名称: "染血的王庭徽记",
    X: -7641.2,
    Y: -14602.9,
    Z: 0.0,
    模型路径: "Common\\Effect\\Form\\Investigation\\Radiance Psionic.mdx",
    发现文本: "|cffffff00『调查发现』：|r在王庭外墙角落找到了一枚染血的王庭徽记。徽记上的血迹已经干涸，像是有人仓促地将它从现场带走。",
  },
  {
    ID: "侍从披风",
    名称: "撕裂的侍从披风",
    X: -6552.3,
    Y: -15508.9,
    Z: 0.0,
    模型路径: "Common\\Effect\\Form\\Investigation\\MissingServantCape.mdx",
    发现文本: "|cffffff00『调查发现』：|r城外小路旁留着一件撕裂的侍从披风，布料上还沾着泥土，像是在挣扎中被硬生生扯下来的。",
  },
  {
    ID: "异常血迹",
    名称: "古树附近的异常血迹",
    X: -7877.4,
    Y: -9151.3,
    Z: 205.7,
    模型路径: "Common\\Effect\\Form\\Investigation\\MissingServantBlood.mdx",
    发现文本: "|cffffff00『调查发现』：|r古树附近残留着一片异常血迹。血迹的颜色和凝固方式都不像普通野兽留下的，附近还残留着陌生的气息。",
  },
];

const 当前调查线索运行状态表: 失踪侍从调查线索运行状态[] = [];
const 已调查线索ID表: Record<string, boolean> = {};

function 读取当前任务目标进度(this: void): { 当前: number; 需求: number } | null {
  const 活动任务 = questDB.globalData != null ? questDB.globalData.quests.get(失踪的精灵侍从任务键) : null;
  if (活动任务 == null || 活动任务.objectives == null || 活动任务.objectives.length === 0) return null;
  const 目标 = 活动任务.objectives[0];
  if (目标 == null) return null;
  return { 当前: 目标.current, 需求: 目标.required };
}

function 查找调查线索(this: void, 调查点ID: string): 失踪侍从调查线索配置 | null {
  for (let i = 0; i < 失踪侍从调查线索配置表.length; i++) {
    const 配置 = 失踪侍从调查线索配置表[i];
    if (配置.ID === 调查点ID) return 配置;
  }
  return null;
}

function 清理调查线索特效(this: void, 调查点ID: string): void {
  for (let i = 当前调查线索运行状态表.length - 1; i >= 0; i--) {
    const 状态 = 当前调查线索运行状态表[i];
    if (状态.ID !== 调查点ID) continue;
    销毁点特效(状态.特效);
    当前调查线索运行状态表.splice(i, 1);
    return;
  }
}

function 清理失踪侍从调查入口(this: void): void {
  for (let i = 失踪侍从调查线索配置表.length - 1; i >= 0; i--) {
    注销环境互动调查点(失踪侍从调查线索配置表[i].ID);
  }
  for (let i = 当前调查线索运行状态表.length - 1; i >= 0; i--) {
    销毁点特效(当前调查线索运行状态表[i].特效);
    当前调查线索运行状态表.pop();
  }
  for (let i = 失踪侍从调查线索配置表.length - 1; i >= 0; i--) {
    已调查线索ID表[失踪侍从调查线索配置表[i].ID] = false;
  }
}

function 处理失踪侍从调查点(this: void, 玩家ID: number, 施法单位: any, 调查点: 环境互动触发点): boolean {
  const 线索 = 查找调查线索(调查点.ID);
  if (线索 == null || 已调查线索ID表[线索.ID] === true) return false;
  if (读取当前任务目标进度() == null) return false;

  const 进度 = 读取当前任务目标进度();
  if (进度 == null || 进度.当前 >= 进度.需求) return false;
  if (!questDB.updateObjective(玩家ID, 失踪的精灵侍从任务键, 失踪的精灵侍从任务目标ID, 进度.当前 + 1)) {
    return false;
  }

  已调查线索ID表[线索.ID] = true;
  注销环境互动调查点(线索.ID);
  清理调查线索特效(线索.ID);
  广播单位提示(施法单位, 线索.发现文本, 5000);
  questManager.triggerUIRefresh(玩家ID, 失踪的精灵侍从任务键);

  const 新进度 = 进度.当前 + 1;
  if (新进度 >= 进度.需求) {
    广播单位提示(施法单位, "|cffffff00『调查结果』：|r三处线索已经查齐了。回去向内务总管·语维复命吧。", 5000);
  }
  return true;
}

function 注册失踪侍从调查点(this: void): void {
  清理失踪侍从调查入口();
  for (let i = 0; i < 失踪侍从调查线索配置表.length; i++) {
    const 线索 = 失踪侍从调查线索配置表[i];
    const 调查点: 环境互动触发点 = {
      ID: 线索.ID,
      X: 线索.X,
      Y: 线索.Y,
      触发范围: 300,
      触发回调: 处理失踪侍从调查点,
    };
    if (!注册环境互动调查点(调查点)) continue;
    const 特效 = 创建点特效({ 模型路径: 线索.模型路径, X: 线索.X, Y: 线索.Y, Z: 线索.Z });
    当前调查线索运行状态表.push({ ID: 线索.ID, 特效 });
  }
  广播单位提示(null, "|cffffff00『任务提示』：|r王庭外墙、城外小路和古树附近都可能留下了线索。请在附近使用环境互动。", 5000);
}

export function 接受失踪的精灵侍从任务(this: void, _玩家ID: number): void {
  注册失踪侍从调查点();
}

export function 完成失踪的精灵侍从任务(this: void, _玩家ID: number): void {
  清理失踪侍从调查入口();
}

export const 失踪的精灵侍从任务配置: Omit<任务配置, "任务ID" | "开始NPC"> = {
  名称: "失踪的精灵侍从",
  类型: "调查",
  需求数量: 3,
  进度文本: "调查线索N/3",
  描述: "调查王庭外墙、城外小路和古树附近，寻找失踪精灵侍从留下的线索",
  奖励: "所有玩家+10000金币;所有玩家+当前等级升级所需经验的30%经验;完成任务的玩家+1能量碎片",
  奖励显示: "所有玩家+10000金币;所有玩家+当前等级升级所需经验的30%;完成任务的玩家+1能量碎片",
  NPC开始对白: "NPC：有一名侍从失踪了。按理说，他只是负责王庭内务，不该离开城里这么久。\nNPC：我已经派人查过城门和巡逻记录，可这件事越查越不对劲。\nPlayer：你怀疑他在城外遇到了麻烦？\nNPC：我不敢妄下结论，但外墙角落、城外小路，还有古树附近，都有人发现过不寻常的痕迹。",
  任务接受对白: "Player：我去把这几处地方查一遍。\nNPC：好。先别惊动城里的守卫，找到什么就记下什么，等线索齐了再回来告诉我。",
  NPC完成对白: "NPC：王庭徽记、侍从披风，还有古树旁的血迹……看来他确实不是自行离城。\nNPC：这件事已经不能再当作普通失踪处理了。我会立刻封存巡逻记录，并安排人手继续追查。\nPlayer：如果还有新的线索，随时来找我们。",
  接取后动作: 接受失踪的精灵侍从任务,
  完成后动作: 完成失踪的精灵侍从任务,
  可重复: false,
  启用: true,
};

export {};
