/** @noSelfInFile */

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 读取触发单位, 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 清理剧情运行时单位, 注册剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 暂停并设置无敌安全, 解除暂停并取消无敌安全 } = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装") as {
  暂停并设置无敌安全: (this: void, unit: any, 来源: string) => boolean;
  解除暂停并取消无敌安全: (this: void, unit: any, 来源: string) => boolean;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查总单位ID } = require("系统.01．单位系统.08．单位配置表.04．总单位配置表") as {
  按名字反查总单位ID: (this: void, name: string) => string | undefined;
};
const { registerUnitInRangeTrigger } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitInRangeTrigger: (this: void, trigger: any, unit: any, range: number, filter?: any, once?: boolean) => () => void;
};
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
  unregisterDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { safeTriggerAddAction, safeDestroyTrigger } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTriggerAddAction: (this: void, trigger: any, callback: (this: void) => void) => { readonly id: number } | null;
  safeDestroyTrigger: (this: void, trigger: any) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
};
const { TriggerRegisterEnterRectSimple } = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterEnterRectSimple: (this: void, trigger: any, rect: any) => any;
};
const { AdjustPlayerStateBJ } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  AdjustPlayerStateBJ: (this: void, delta: number, whichPlayer: any, whichPlayerState: any) => void;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const Rect = jass.Rect as (this: void, minX: number, minY: number, maxX: number, maxY: number) => any;
const RemoveRect = jass.RemoveRect as (this: void, rect: any) => void;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetUnitState = jass.GetUnitState as (this: void, whichUnit: any, state: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, whichUnit: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const IssueTargetOrder = jass.IssueTargetOrder as (this: void, whichUnit: any, order: string, target: any) => boolean;
const Player = jass.Player as (this: void, playerId: number) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;
const TriggerAddAction = jass.TriggerAddAction as (this: void, whichTrigger: any, action: (this: void) => void) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const GetPlayerState = jass.GetPlayerState as (this: void, whichPlayer: any, whichPlayerState: any) => number;
const PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD as number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const 中立敌对玩家ID = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const bj_QUESTMESSAGE_UPDATED = jglobals.bj_QUESTMESSAGE_UPDATED as number;
const bj_QUESTMESSAGE_WARNING = jglobals.bj_QUESTMESSAGE_WARNING as number;

const 中立被动玩家ID = 15;
const 调查范围 = 450;
const 下层仓库入口触发半径 = 700;
const 下层仓库清理者待战暂停来源 = "剧情系统:恶魔城下层仓库清理者待战";
const 下层仓库赤尾待战暂停来源 = "剧情系统:恶魔城下层仓库赤尾待战";

export interface 恶魔城调查场景站位 {
  X: number;
  Y: number;
  朝向: number;
}

// 图 1 为单个锻造区证人；图 2 是锻造区附近的双持居民，作为开放调查的环境在场单位。
// 图 3 的赤尾朝向按玩家从下方接近的动线先取 270°；图 4/5 保留给仓库入口与内部演出。
export const 恶魔城调查场景站位表 = {
  锻造区证人: { X: 13628.8, Y: -19973.6, 朝向: 90 },
  锻造区双持居民: { X: 13719.9, Y: -14276.8, 朝向: 315 },
  赤尾: { X: 16465.9, Y: -20027.5, 朝向: 270 },
  下层仓库入口: { X: 19611.0, Y: -18842.2, 朝向: 0 },
  下层仓库内部: { X: 20334.0, Y: -18094.7, 朝向: 0 },
} as const satisfies Record<string, 恶魔城调查场景站位>;

let 已布置恶魔城调查 = false;
let 已触发锻造区证人 = false;
let 已触发赤尾交易 = false;
let 已支付赤尾定金 = false;
let 取消赤尾范围监听: (() => void) | undefined;
let 下层仓库入口矩形: any = null;
let 下层仓库入口触发器: any = null;
let 已触发下层仓库伏击 = false;
let 下层仓库触发玩家单位: any = null;
let 下层仓库赤尾: any = null;
let 下层仓库清理者学者: any = null;
let 下层仓库清理者战士: any = null;
let 下层仓库赤尾已死亡 = false;
let 下层仓库战斗进行中 = false;
let 下层仓库剩余清理者 = 0;
let 下层仓库战斗世代 = 0;
let 下层仓库战斗结算已安排 = false;
let 已注册下层仓库死亡监听 = false;
let 已记录下层仓库证据 = false;

interface 下层仓库战斗结算参数 {
  世代: number;
}

function 播放调查剧情(this: void, 片段ID: string, 触发单位: any, 触发配置名: string): void {
  const { 播放主线剧情片段 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
    播放主线剧情片段: (this: void, 片段ID: string, 上下文?: any) => boolean;
  };
  播放主线剧情片段(片段ID, { 片段ID, 触发配置名, 触发单位 });
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) !== 0;
}

function 单位存活(this: void, unit: any): boolean {
  return 单位有效(unit) && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 读取动作数字(this: void, 参数: 剧情动作参数表, key: string, 默认值: number): number {
  const value = 参数[key];
  if (typeof value === "number") return value;
  if (typeof value === "string") return Number(value) || 默认值;
  return 默认值;
}

function 空取消范围监听(this: void): void {}

function 转向目标(this: void, 来源单位: any, 目标单位: any): void {
  if (!单位有效(来源单位) || !单位有效(目标单位)) return;
  const 朝向 = YDWEAngleBetweenUnitsSafe(来源单位, 目标单位);
  SetUnitFacing(来源单位, 朝向);
}

function on锻造区证人范围触发(this: void): void {
  if (已触发锻造区证人 || 读取剧情进度() !== 39) return;
  已触发锻造区证人 = true;
  播放调查剧情("molten_realm_forge_witness", GetTriggerUnit(), "恶魔城锻造区证人入口");
}

function on赤尾范围触发(this: void): void {
  if (已触发赤尾交易 || 读取剧情进度() !== 39) return;
  if (已支付赤尾定金) return;
  已触发赤尾交易 = true;
  播放调查剧情("molten_realm_redtail_meet", GetTriggerUnit(), "恶魔城赤尾交易入口");
}

function 注册单位范围入口(this: void, unit: any, range: number, action: (this: void) => void, 一次性 = true): () => void {
  if (unit == null || unit === 0) return 空取消范围监听;
  const trigger = CreateTrigger();
  TriggerAddAction(trigger, action);
  return registerUnitInRangeTrigger(trigger, unit, range, null, 一次性);
}

function 清理下层仓库入口监听(this: void): void {
  if (下层仓库入口触发器 != null && 下层仓库入口触发器 !== 0) {
    safeDestroyTrigger(下层仓库入口触发器);
  }
  if (下层仓库入口矩形 != null && 下层仓库入口矩形 !== 0) {
    RemoveRect(下层仓库入口矩形);
  }
  下层仓库入口触发器 = null;
  下层仓库入口矩形 = null;
}

function on进入下层仓库入口(this: void): void {
  if (已触发下层仓库伏击 || 读取剧情进度() !== 39) return;
  const 触发单位 = GetTriggerUnit();
  if (触发单位 == null || 触发单位 === 0 || !是玩家英雄组单位(触发单位)) return;
  已触发下层仓库伏击 = true;
  下层仓库触发玩家单位 = 触发单位;
  清理下层仓库入口监听();
  播放调查剧情("molten_realm_warehouse_ambush", 触发单位, "恶魔城下层仓库入口");
}

function 注册下层仓库入口监听(this: void): void {
  if (下层仓库入口触发器 != null && 下层仓库入口触发器 !== 0) return;
  const 入口 = 恶魔城调查场景站位表.下层仓库入口;
  下层仓库入口矩形 = Rect(
    入口.X - 下层仓库入口触发半径,
    入口.Y - 下层仓库入口触发半径,
    入口.X + 下层仓库入口触发半径,
    入口.Y + 下层仓库入口触发半径,
  );
  if (下层仓库入口矩形 == null || 下层仓库入口矩形 === 0) return;
  下层仓库入口触发器 = CreateTrigger();
  if (下层仓库入口触发器 == null || 下层仓库入口触发器 === 0) {
    RemoveRect(下层仓库入口矩形);
    下层仓库入口矩形 = null;
    return;
  }
  if (safeTriggerAddAction(下层仓库入口触发器, on进入下层仓库入口) == null) {
    safeDestroyTrigger(下层仓库入口触发器);
    RemoveRect(下层仓库入口矩形);
    下层仓库入口触发器 = null;
    下层仓库入口矩形 = null;
    return;
  }
  TriggerRegisterEnterRectSimple(下层仓库入口触发器, 下层仓库入口矩形);
}

function 支付赤尾定金(this: void, _参数: 剧情动作参数表): void {
  if (已支付赤尾定金) return;
  const 触发单位 = 读取触发单位();
  if (触发单位 == null || 触发单位 === 0) return;
  const 玩家 = GetOwningPlayer(触发单位);
  const 定金 = 300;
  if (GetPlayerState(玩家, PLAYER_STATE_RESOURCE_GOLD) < 定金) {
    QuestMessageBJ(
      GetPlayersAll(),
      bj_QUESTMESSAGE_WARNING,
      "|cffffff00『系统提示』：|r金币不足，无法支付赤尾的|cffffcc00300金币定金|r。离开后再次靠近赤尾可以重新交涉。",
    );
    return;
  }
  已支付赤尾定金 = true;
  if (取消赤尾范围监听 != null) {
    取消赤尾范围监听();
    取消赤尾范围监听 = undefined;
  }
  AdjustPlayerStateBJ(-定金, 玩家, PLAYER_STATE_RESOURCE_GOLD);
  QuestMessageBJ(
    GetPlayersAll(),
    bj_QUESTMESSAGE_UPDATED,
    "|cffffff00『系统提示』：|r已支付赤尾|cffffcc00300金币定金|r。",
  );
}

function 结束赤尾交易尝试(this: void, _参数: 剧情动作参数表): void {
  if (!已支付赤尾定金) 已触发赤尾交易 = false;
}

function 创建并登记调查单位(this: void, 单位ID: string, 站位: 恶魔城调查场景站位, 语义引用: string): any {
  const 单位类型ID = stringToFourCCSafe(单位ID);
  if (!(单位类型ID > 0)) return null;
  const unit = 创建单位并登记排泄安全(
    Player(中立被动玩家ID),
    单位类型ID,
    站位.X,
    站位.Y,
    站位.朝向,
  );
  if (unit == null || unit === 0) return null;
  SetUnitPosition(unit, 站位.X, 站位.Y);
  SetUnitFacing(unit, 站位.朝向);
  IssueImmediateOrder(unit, "stop");
  注册剧情运行时单位(语义引用, unit);
  return unit;
}

function 创建并冻结下层仓库清理者(
  this: void,
  单位名: string,
  x: number,
  y: number,
  朝向: number,
  语义引用: string,
): any {
  const 单位类型ID = stringToFourCCSafe(按名字反查总单位ID(单位名));
  if (!(单位类型ID > 0)) return null;

  const unit = 创建单位并登记排泄安全(
    Player(中立敌对玩家ID),
    单位类型ID,
    x,
    y,
    朝向,
  );
  if (!单位有效(unit)) return null;

  SetUnitPosition(unit, x, y);
  SetUnitFacing(unit, 朝向);
  IssueImmediateOrder(unit, "stop");
  暂停并设置无敌安全(unit, 下层仓库清理者待战暂停来源);
  注册剧情运行时单位(语义引用, unit);
  return unit;
}

function 清理下层仓库战斗运行时引用(this: void): void {
  清理剧情运行时单位("剧情单位.教派清理者（学者）");
  清理剧情运行时单位("剧情单位.教派清理者（战士）");
}

function 安排下层仓库战斗结算(this: void): void {
  if (下层仓库战斗结算已安排) return;
  下层仓库战斗结算已安排 = true;
  addDelayedCallback(1, 结算下层仓库战斗, { 世代: 下层仓库战斗世代 });
}

function 结算下层仓库战斗(this: void, variable?: any): void {
  const 参数 = variable as 下层仓库战斗结算参数 | undefined;
  if (参数 == null || 参数.世代 !== 下层仓库战斗世代) return;
  if (!下层仓库战斗进行中) return;

  下层仓库战斗进行中 = false;
  下层仓库战斗结算已安排 = false;
  if (已注册下层仓库死亡监听) {
    unregisterDeathListener(on下层仓库单位死亡);
    已注册下层仓库死亡监听 = false;
  }

  const 赤尾存活 = 单位存活(下层仓库赤尾) && !下层仓库赤尾已死亡;
  const 触发单位 = 下层仓库触发玩家单位;
  清理下层仓库战斗运行时引用();
  下层仓库清理者学者 = null;
  下层仓库清理者战士 = null;
  下层仓库剩余清理者 = 0;

  if (赤尾存活) {
    播放调查剧情("molten_realm_warehouse_survivor_aftermath", 触发单位, "恶魔城下层仓库战后");
  } else {
    清理剧情运行时单位("主线NPC.赤尾");
    下层仓库赤尾 = null;
    播放调查剧情("molten_realm_warehouse_redtail_death_aftermath", 触发单位, "恶魔城下层仓库战后");
  }
}

function on下层仓库单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (!下层仓库战斗进行中) return;

  if (dyingUnit === 下层仓库赤尾) {
    下层仓库赤尾已死亡 = true;
    return;
  }

  let 是清理者 = false;
  if (dyingUnit === 下层仓库清理者学者 || dyingUnit === 下层仓库清理者战士) {
    是清理者 = true;
  }
  if (!是清理者) return;

  if (下层仓库剩余清理者 > 0) 下层仓库剩余清理者--;
  if (下层仓库剩余清理者 <= 0) 安排下层仓库战斗结算();
}

function 布置下层仓库伏击(this: void, 参数: 剧情动作参数表): void {
  if (下层仓库战斗进行中 || 下层仓库清理者学者 != null || 下层仓库清理者战士 != null) return;

  const 赤尾 = 读取语义单位引用("主线NPC.赤尾");
  if (!单位有效(赤尾)) return;

  下层仓库战斗世代++;
  下层仓库赤尾 = 赤尾;
  下层仓库赤尾已死亡 = !单位存活(赤尾);
  下层仓库战斗结算已安排 = false;
  下层仓库剩余清理者 = 0;

  const 赤尾X = 读取动作数字(参数, "赤尾X", 20171.3);
  const 赤尾Y = 读取动作数字(参数, "赤尾Y", -18292.4);
  const 赤尾朝向 = 读取动作数字(参数, "赤尾朝向", 45);
  SetUnitPosition(赤尾, 赤尾X, 赤尾Y);
  SetUnitFacing(赤尾, 赤尾朝向);
  IssueImmediateOrder(赤尾, "stop");
  if (!下层仓库赤尾已死亡) 暂停并设置无敌安全(赤尾, 下层仓库赤尾待战暂停来源);

  下层仓库清理者学者 = 创建并冻结下层仓库清理者(
    "教派清理者（学者）",
    读取动作数字(参数, "学者X", 20214.6),
    读取动作数字(参数, "学者Y", -18088.2),
    读取动作数字(参数, "学者朝向", 135),
    "剧情单位.教派清理者（学者）",
  );
  下层仓库清理者战士 = 创建并冻结下层仓库清理者(
    "教派清理者（战士）",
    读取动作数字(参数, "战士X", 20409.9),
    读取动作数字(参数, "战士Y", -18284.9),
    读取动作数字(参数, "战士朝向", 315),
    "剧情单位.教派清理者（战士）",
  );

  if (单位有效(下层仓库清理者学者)) 下层仓库剩余清理者++;
  if (单位有效(下层仓库清理者战士)) 下层仓库剩余清理者++;
  if (!已注册下层仓库死亡监听) {
    registerDeathListener(on下层仓库单位死亡);
    已注册下层仓库死亡监听 = true;
  }
}

function 下层仓库清理者转向赤尾(this: void, _参数: 剧情动作参数表): void {
  const 赤尾 = 下层仓库赤尾 ?? 读取语义单位引用("主线NPC.赤尾");
  if (!单位有效(赤尾)) return;
  转向目标(下层仓库清理者学者, 赤尾);
  转向目标(下层仓库清理者战士, 赤尾);
}

function 开启下层仓库战斗(this: void, _参数: 剧情动作参数表): void {
  if (下层仓库战斗进行中) return;
  const 赤尾 = 下层仓库赤尾 ?? 读取语义单位引用("主线NPC.赤尾");
  if (!单位有效(赤尾)) return;

  下层仓库战斗进行中 = true;
  if (单位有效(下层仓库清理者学者)) {
    解除暂停并取消无敌安全(下层仓库清理者学者, 下层仓库清理者待战暂停来源);
    转向目标(下层仓库清理者学者, 赤尾);
    IssueTargetOrder(下层仓库清理者学者, "attack", 赤尾);
  }
  if (单位有效(下层仓库清理者战士)) {
    解除暂停并取消无敌安全(下层仓库清理者战士, 下层仓库清理者待战暂停来源);
    转向目标(下层仓库清理者战士, 赤尾);
    IssueTargetOrder(下层仓库清理者战士, "attack", 赤尾);
  }
  if (单位存活(赤尾)) {
    解除暂停并取消无敌安全(赤尾, 下层仓库赤尾待战暂停来源);
  }
  if (下层仓库剩余清理者 <= 0) 安排下层仓库战斗结算();
}

function 记录下层仓库证据(this: void, _参数: 剧情动作参数表): void {
  if (已记录下层仓库证据) return;
  已记录下层仓库证据 = true;
  QuestMessageBJ(
    GetPlayersAll(),
    bj_QUESTMESSAGE_UPDATED,
    "|cffffff00『系统消息』：|r已收集下层仓库的契约、路线图与教派内应证据。返回阿瓦尔处汇报。",
  );
}

export function 执行布置恶魔城调查(this: void, _参数: 剧情动作参数表): void {
  if (已布置恶魔城调查) return;
  已布置恶魔城调查 = true;

  const 锻造区证人 = 创建并登记调查单位("n03W", 恶魔城调查场景站位表.锻造区证人, "主线NPC.锻造区证人");
  创建并登记调查单位("n03Y", 恶魔城调查场景站位表.锻造区双持居民, "主线NPC.锻造区双持居民");
  const 赤尾 = 创建并登记调查单位("n03Z", 恶魔城调查场景站位表.赤尾, "主线NPC.赤尾");

  注册单位范围入口(锻造区证人, 调查范围, on锻造区证人范围触发);
  取消赤尾范围监听 = 注册单位范围入口(赤尾, 调查范围, on赤尾范围触发, false);
  注册下层仓库入口监听();
}

export const 恶魔城调查剧情动作注册表: Record<string, 剧情动作处理器> = {
  "第三章_布置恶魔城调查": 执行布置恶魔城调查,
  "第三章_支付赤尾定金": 支付赤尾定金,
  "第三章_结束赤尾交易尝试": 结束赤尾交易尝试,
  "第三章_布置下层仓库伏击": 布置下层仓库伏击,
  "第三章_下层仓库清理者转向赤尾": 下层仓库清理者转向赤尾,
  "第三章_开启下层仓库战斗": 开启下层仓库战斗,
  "第三章_记录下层仓库证据": 记录下层仓库证据,
};
