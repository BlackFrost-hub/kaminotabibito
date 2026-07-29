/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const {
  registerImmediateOrderListener,
  registerPointOrderListener,
  registerTargetOrderListener,
} = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心") as {
  registerImmediateOrderListener: (this: void, callback: (this: void, unit: any, orderId: number) => void) => void;
  registerPointOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, x: number, y: number) => void) => void;
  registerTargetOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, targetUnit: any, targetItem: any, targetDestructable: any) => void) => void;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, sourceUnit: any, text: string, duration?: number) => void;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { safeForForce } = require("系统.00．核心系统.07．联机安全工具") as {
  safeForForce: (this: void, whichForce: any, callback: (this: void) => void) => void;
};
const { registerUnitInRangeTrigger } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitInRangeTrigger: (this: void, trigger: any, unit: any, range: number, filter?: any, once?: boolean) => (this: void) => void;
};
const { safeTriggerAddAction, safeDestroyTrigger } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTriggerAddAction: (this: void, trigger: any, callback: (this: void) => void) => { readonly id: number } | null;
  safeDestroyTrigger: (this: void, trigger: any) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 发放首领奖励装备 } = require("系统.02．物品系统.18．首领奖励选择.08．奖励物品发放") as {
  发放首领奖励装备: (this: void, 玩家: any, 装备名: string) => boolean;
};
const { 第二章后段Boss战利品装备名 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.11．装备常量") as {
  第二章后段Boss战利品装备名: {
    菲利斯的战阵徽章: string;
    第二军团攻城秘戒: string;
  };
};

import { 发送剧情任务消息 } from "../../00．剧情系统核心工具/02．剧情动作桥接";
import { 读取语义单位引用, 执行通用剧情动作 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";

const GetDestructableX = jass.GetDestructableX as (this: void, destructable: any) => number;
const GetDestructableY = jass.GetDestructableY as (this: void, destructable: any) => number;
const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetItemX = jass.GetItemX as (this: void, item: any) => number;
const GetItemY = jass.GetItemY as (this: void, item: any) => number;
const GetEnumPlayer = jass.GetEnumPlayer as (this: void) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerState = jass.GetPlayerState as (this: void, player: any, state: any) => number;
const GetRandomInt = jass.GetRandomInt as (this: void, lowBound: number, highBound: number) => number;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, unit: any, order: string) => boolean;
const IssueTargetOrder = jass.IssueTargetOrder as (this: void, unit: any, order: string, target: any) => boolean;
const Player = jass.Player as (this: void, playerId: number) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, unit: any, owner: any, changeColor: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const SetPlayerState = jass.SetPlayerState as (this: void, player: any, state: any, value: number) => void;
const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const PLAYER_STATE_RESOURCE_LUMBER = jass.PLAYER_STATE_RESOURCE_LUMBER as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const bj_QUESTMESSAGE_ITEMACQUIRED = (require("jass.globals") as any).bj_QUESTMESSAGE_ITEMACQUIRED as number;

const 耶提尔约束距离 = 1200;
const 耶提尔约束距离平方 = 耶提尔约束距离 * 耶提尔约束距离;
const 耶提尔入场靠近玩家距离平方 = 900 * 900;
const 耶提尔越界检查间隔毫秒 = 100;
const 耶提尔临时脱离控制毫秒 = 1000;
const Boss转场等待毫秒 = 2200;
const 耶提尔越界对白 = "不能再退了！菲利斯就在眼前——先解决他！";
const 耶提尔战后位置X = -10430.3;
const 耶提尔战后位置Y = -13610.4;
const 耶提尔战后朝向 = 270;
const 耶提尔战后奖励触发范围 = 450;
const 耶提尔战后对白持续毫秒 = 5200;
const 耶提尔战后对白 = "诸位，城门一战辛苦了。菲利斯投影消散后留下了一些东西，我替你们收在兵营里——这些战利品理应归你们。";

interface 耶提尔协战状态 {
  世代: number;
  耶提尔: any;
  菲利斯: any;
  控制玩家: any;
  原归属玩家: any;
  玩家主动离场: boolean;
  正在强制回战: boolean;
  周期回调ID: number;
}

interface 耶提尔协战准备参数 {
  世代: number;
  菲利斯: any;
  玩家单位: any;
}

interface 耶提尔恢复控制参数 {
  世代: number;
}

interface 耶提尔战后奖励状态 {
  世代: number;
  耶提尔: any;
  奖励档位: number;
  已领取: boolean;
  领取触发器: any;
  取消领取监听: ((this: void) => void) | undefined;
}

interface 耶提尔战后奖励回调参数 {
  世代: number;
}

interface 耶提尔战后触发器清理参数 {
  状态: 耶提尔战后奖励状态;
  触发器: any;
}

let 当前耶提尔协战状态: 耶提尔协战状态 | undefined;
let 耶提尔协战世代 = 0;
let 已注册耶提尔指令监听 = false;
let 当前耶提尔战后奖励状态: 耶提尔战后奖励状态 | undefined;
let 耶提尔战后奖励世代 = 0;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) !== 0;
}

function 坐标超出菲利斯约束(this: void, 状态: 耶提尔协战状态, x: number, y: number): boolean {
  if (!单位有效(状态.菲利斯)) return false;
  const dx = x - GetUnitX(状态.菲利斯);
  const dy = y - GetUnitY(状态.菲利斯);
  return dx * dx + dy * dy > 耶提尔约束距离平方;
}

function 设置玩家离场意图(this: void, unit: any, x: number, y: number): void {
  const 状态 = 当前耶提尔协战状态;
  if (状态 == null || unit !== 状态.耶提尔 || 状态.正在强制回战) return;
  状态.玩家主动离场 = 坐标超出菲利斯约束(状态, x, y);
}

function on耶提尔点目标指令(this: void, unit: any, _orderId: number, x: number, y: number): void {
  设置玩家离场意图(unit, x, y);
}

function on耶提尔单位目标指令(this: void, unit: any, _orderId: number, targetUnit: any, targetItem: any, targetDestructable: any): void {
  const 状态 = 当前耶提尔协战状态;
  if (状态 == null || unit !== 状态.耶提尔 || 状态.正在强制回战) return;
  if (targetUnit != null && targetUnit !== 0) {
    设置玩家离场意图(unit, GetUnitX(targetUnit), GetUnitY(targetUnit));
    return;
  }
  if (targetItem != null && targetItem !== 0) {
    设置玩家离场意图(unit, GetItemX(targetItem), GetItemY(targetItem));
    return;
  }
  if (targetDestructable != null && targetDestructable !== 0) {
    设置玩家离场意图(unit, GetDestructableX(targetDestructable), GetDestructableY(targetDestructable));
    return;
  }
  状态.玩家主动离场 = false;
}

function on耶提尔立即指令(this: void, unit: any, _orderId: number): void {
  const 状态 = 当前耶提尔协战状态;
  if (状态 == null || unit !== 状态.耶提尔 || 状态.正在强制回战) return;
  状态.玩家主动离场 = false;
}

function 确保耶提尔指令监听(this: void): void {
  if (已注册耶提尔指令监听) return;
  已注册耶提尔指令监听 = true;
  registerPointOrderListener(on耶提尔点目标指令);
  registerTargetOrderListener(on耶提尔单位目标指令);
  registerImmediateOrderListener(on耶提尔立即指令);
}

function 停止当前耶提尔协战(this: void): void {
  const 状态 = 当前耶提尔协战状态;
  if (状态 != null) {
    if (状态.周期回调ID !== 0) removePeriodicCallback(状态.周期回调ID);
    if (单位有效(状态.耶提尔)) {
      SetUnitOwner(状态.耶提尔, 状态.原归属玩家, true);
      IssueImmediateOrder(状态.耶提尔, "stop");
    }
  }
  当前耶提尔协战状态 = undefined;
}

function 停止耶提尔协战Tick(this: void, 状态: 耶提尔协战状态): void {
  if (状态.周期回调ID === 0) return;
  removePeriodicCallback(状态.周期回调ID);
  状态.周期回调ID = 0;
}

function 计算耶提尔存活奖励档位(this: void, 耶提尔: any): number {
  if (!单位有效(耶提尔)) return 0;
  const 当前生命 = GetUnitState(耶提尔, UNIT_STATE_LIFE);
  const 最大生命 = GetUnitStateJapi(耶提尔, UNIT_STATE_MAX_LIFE);
  if (当前生命 <= 0.405 || 最大生命 <= 0) return 0;
  const 生命比例 = 当前生命 / 最大生命;
  if (生命比例 >= 0.75) return 3;
  if (生命比例 >= 0.40) return 2;
  return 1;
}

function on发放菲利斯随机装备(this: void): void {
  const 玩家 = GetEnumPlayer();
  if (玩家 == null || 玩家 === 0) return;
  const 装备名 = GetRandomInt(0, 1) === 0
    ? 第二章后段Boss战利品装备名.菲利斯的战阵徽章
    : 第二章后段Boss战利品装备名.第二军团攻城秘戒;
  发放首领奖励装备(玩家, 装备名);
}

function on发放一枚能量碎片(this: void): void {
  const 玩家 = GetEnumPlayer();
  if (玩家 == null || 玩家 === 0) return;
  const 当前能量碎片 = GetPlayerState(玩家, PLAYER_STATE_RESOURCE_LUMBER);
  SetPlayerState(玩家, PLAYER_STATE_RESOURCE_LUMBER, 当前能量碎片 + 1);
}

function 遍历剧情玩家组(this: void, callback: (this: void) => void): void {
  const 玩家组 = YDUserDataGetSafe("string", "玩家", "玩家组", "force");
  if (玩家组 == null || 玩家组 === 0) return;
  safeForForce(玩家组, callback);
}

function 发放耶提尔存活奖励(this: void, 奖励档位: number): void {
  if (奖励档位 === 3) {
    遍历剧情玩家组(on发放菲利斯随机装备);
    发送剧情任务消息({
      消息类型: bj_QUESTMESSAGE_ITEMACQUIRED,
      文本: "|cffffff00『额外奖励』：|r耶提尔状态良好，所有英雄分别收到一件|cff66ccff『菲利斯战利品』|r！",
    });
    return;
  }
  if (奖励档位 === 2) {
    执行通用剧情动作({ 发放金币: 10000 });
    遍历剧情玩家组(on发放一枚能量碎片);
    发送剧情任务消息({
      消息类型: bj_QUESTMESSAGE_ITEMACQUIRED,
      文本: "|cffffff00『额外奖励』：|r所有英雄收到|cffffff0010000金币|r与|cff66ccff1能量碎片|r！",
    });
    return;
  }
  if (奖励档位 === 1) {
    执行通用剧情动作({ 发放金币: 5000 });
    发送剧情任务消息({
      消息类型: bj_QUESTMESSAGE_ITEMACQUIRED,
      文本: "|cffffff00『额外奖励』：|r所有英雄收到|cffffff005000金币|r！",
    });
  }
}

function on延迟销毁耶提尔战后触发器(this: void, variable?: any): void {
  const 参数 = variable as 耶提尔战后触发器清理参数 | undefined;
  if (参数 == null || 参数.触发器 == null || 参数.触发器 === 0) return;
  const 取消监听 = 参数.状态.取消领取监听;
  参数.状态.取消领取监听 = undefined;
  if (取消监听 != null) 取消监听();
  safeDestroyTrigger(参数.触发器);
}

function 清理耶提尔战后领取监听(this: void, 状态: 耶提尔战后奖励状态): void {
  const 取消监听 = 状态.取消领取监听;
  状态.取消领取监听 = undefined;
  if (取消监听 != null) 取消监听();

  const 触发器 = 状态.领取触发器;
  状态.领取触发器 = null;
  if (触发器 != null && 触发器 !== 0) safeDestroyTrigger(触发器);
}

function 完成耶提尔战后一次性监听(this: void, 状态: 耶提尔战后奖励状态): void {
  const 触发器 = 状态.领取触发器;
  状态.领取触发器 = null;
  if (触发器 != null && 触发器 !== 0) {
    // 离开当前范围事件派发栈后，再注销中心监听并销毁业务触发器。
    addDelayedCallback(1, on延迟销毁耶提尔战后触发器, { 状态, 触发器 } as 耶提尔战后触发器清理参数);
  }
}

function 清空耶提尔战后奖励状态(this: void): void {
  const 状态 = 当前耶提尔战后奖励状态;
  当前耶提尔战后奖励状态 = undefined;
  if (状态 != null) 清理耶提尔战后领取监听(状态);
}

function on发放耶提尔战后奖励(this: void, variable?: any): void {
  const 参数 = variable as 耶提尔战后奖励回调参数 | undefined;
  const 状态 = 当前耶提尔战后奖励状态;
  if (参数 == null || 状态 == null || 参数.世代 !== 状态.世代 || !状态.已领取) return;
  当前耶提尔战后奖励状态 = undefined;
  发放耶提尔存活奖励(状态.奖励档位);
}

function on耶提尔战后奖励接近(this: void): void {
  const 状态 = 当前耶提尔战后奖励状态;
  if (状态 == null || 状态.已领取) return;
  const 进入单位 = GetTriggerUnit();
  if (!单位有效(进入单位) || !是玩家英雄组单位(进入单位)) return;

  状态.已领取 = true;
  完成耶提尔战后一次性监听(状态);
  广播单位提示(状态.耶提尔, 耶提尔战后对白, 耶提尔战后对白持续毫秒);
  addDelayedCallback(耶提尔战后对白持续毫秒, on发放耶提尔战后奖励, { 世代: 状态.世代 } as 耶提尔战后奖励回调参数);
}

export function 布置耶提尔战后奖励NPC(this: void): void {
  const 状态 = 当前耶提尔战后奖励状态;
  if (状态 == null || 状态.已领取 || 状态.奖励档位 <= 0) return;
  if (!单位有效(状态.耶提尔) || GetUnitState(状态.耶提尔, UNIT_STATE_LIFE) <= 0.405) {
    清空耶提尔战后奖励状态();
    return;
  }

  清理耶提尔战后领取监听(状态);
  SetUnitPosition(状态.耶提尔, 耶提尔战后位置X, 耶提尔战后位置Y);
  SetUnitFacing(状态.耶提尔, 耶提尔战后朝向);
  IssueImmediateOrder(状态.耶提尔, "holdposition");

  const 触发器 = CreateTrigger();
  状态.领取触发器 = 触发器;
  if (safeTriggerAddAction(触发器, on耶提尔战后奖励接近) == null) {
    状态.领取触发器 = null;
    safeDestroyTrigger(触发器);
    return;
  }
  状态.取消领取监听 = registerUnitInRangeTrigger(
    触发器,
    状态.耶提尔,
    耶提尔战后奖励触发范围,
    null,
    false
  );
}

export function 结算耶提尔菲利斯协战(this: void): void {
  const 状态 = 当前耶提尔协战状态;
  if (状态 == null) return;
  当前耶提尔协战状态 = undefined;
  停止耶提尔协战Tick(状态);

  const 奖励档位 = 计算耶提尔存活奖励档位(状态.耶提尔);
  if (单位有效(状态.耶提尔)) {
    SetUnitOwner(状态.耶提尔, 状态.原归属玩家, true);
    if (奖励档位 > 0) IssueImmediateOrder(状态.耶提尔, "stop");
  }
  清空耶提尔战后奖励状态();
  if (奖励档位 <= 0) return;
  耶提尔战后奖励世代++;
  当前耶提尔战后奖励状态 = {
    世代: 耶提尔战后奖励世代,
    耶提尔: 状态.耶提尔,
    奖励档位,
    已领取: false,
    领取触发器: null,
    取消领取监听: undefined,
  };
}

function on恢复耶提尔玩家控制(this: void, variable?: any): void {
  const 参数 = variable as 耶提尔恢复控制参数 | undefined;
  const 状态 = 当前耶提尔协战状态;
  if (参数 == null || 状态 == null || 参数.世代 !== 状态.世代) return;
  if (!单位有效(状态.耶提尔) || !单位有效(状态.菲利斯)) {
    停止当前耶提尔协战();
    return;
  }

  SetUnitOwner(状态.耶提尔, 状态.控制玩家, true);
  IssueTargetOrder(状态.耶提尔, "attack", 状态.菲利斯);
  状态.正在强制回战 = false;
}

function 强制耶提尔返回战斗(this: void, 状态: 耶提尔协战状态): void {
  状态.玩家主动离场 = false;
  状态.正在强制回战 = true;
  广播单位提示(状态.耶提尔, 耶提尔越界对白, 3200);
  SetUnitOwner(状态.耶提尔, Player(PLAYER_NEUTRAL_PASSIVE), true);
  IssueTargetOrder(状态.耶提尔, "attack", 状态.菲利斯);
  addDelayedCallback(耶提尔临时脱离控制毫秒, on恢复耶提尔玩家控制, { 世代: 状态.世代 } as 耶提尔恢复控制参数);
}

function on耶提尔越界检查(this: void): void {
  const 状态 = 当前耶提尔协战状态;
  if (状态 == null) return;
  if (!单位有效(状态.菲利斯)) {
    停止当前耶提尔协战();
    return;
  }
  if (!单位有效(状态.耶提尔) || GetUnitState(状态.耶提尔, UNIT_STATE_LIFE) <= 0.405) {
    停止耶提尔协战Tick(状态);
    return;
  }
  if (!状态.玩家主动离场 || 状态.正在强制回战) return;
  if (!坐标超出菲利斯约束(状态, GetUnitX(状态.耶提尔), GetUnitY(状态.耶提尔))) return;
  强制耶提尔返回战斗(状态);
}

function on耶提尔协战转场完成(this: void, variable?: any): void {
  const 参数 = variable as 耶提尔协战准备参数 | undefined;
  if (参数 == null || 参数.世代 !== 耶提尔协战世代) return;

  const 耶提尔 = 读取语义单位引用("主线NPC.耶提尔");
  if (!单位有效(耶提尔) || !单位有效(参数.菲利斯) || !单位有效(参数.玩家单位)) return;

  const 玩家X = GetUnitX(参数.玩家单位);
  const 玩家Y = GetUnitY(参数.玩家单位);
  const bossX = GetUnitX(参数.菲利斯);
  const bossY = GetUnitY(参数.菲利斯);
  const dx = 玩家X - bossX;
  const dy = 玩家Y - bossY;
  const 靠近玩家 = dx * dx + dy * dy <= 耶提尔入场靠近玩家距离平方;

  SetUnitPosition(耶提尔, 靠近玩家 ? 玩家X + 160 : bossX - 400, 靠近玩家 ? 玩家Y : bossY);
  const 控制玩家 = GetOwningPlayer(参数.玩家单位);
  const 原归属玩家 = GetOwningPlayer(耶提尔);
  SetUnitOwner(耶提尔, 控制玩家, true);

  当前耶提尔协战状态 = {
    世代: 参数.世代,
    耶提尔,
    菲利斯: 参数.菲利斯,
    控制玩家,
    原归属玩家,
    玩家主动离场: false,
    正在强制回战: true,
    周期回调ID: 0,
  };
  IssueTargetOrder(耶提尔, "attack", 参数.菲利斯);
  当前耶提尔协战状态.正在强制回战 = false;
  当前耶提尔协战状态.周期回调ID = addPeriodicCallback(耶提尔越界检查间隔毫秒, on耶提尔越界检查);
}

export function 准备耶提尔菲利斯协战(this: void, 菲利斯: any, 玩家单位: any): void {
  停止当前耶提尔协战();
  清空耶提尔战后奖励状态();
  if (!单位有效(菲利斯) || !单位有效(玩家单位)) return;

  确保耶提尔指令监听();
  耶提尔协战世代++;
  addDelayedCallback(Boss转场等待毫秒, on耶提尔协战转场完成, {
    世代: 耶提尔协战世代,
    菲利斯,
    玩家单位,
  } as 耶提尔协战准备参数);
}

export {};
