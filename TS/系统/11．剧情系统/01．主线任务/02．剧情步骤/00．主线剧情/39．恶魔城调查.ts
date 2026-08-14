/** @noSelfInFile */

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 给玩家组添加多个区域视野, 读取触发单位, 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 清理剧情运行时单位, 注册剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
import { 开始剧情单位保持移动, type 剧情单位移动控制器 } from "../../../00．公共/04．剧情单位移动控制";
import { 创建剧情场景单位 } from "../../../00．公共/02．剧情NPC创建";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
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
const { registerOneShotUnitRangeListener } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerOneShotUnitRangeListener: (
    this: void,
    unit: any,
    range: number,
    callback: (this: void, enteringUnit: any) => boolean,
    predicate?: (this: void, enteringUnit: any) => boolean,
  ) => () => void;
};
const { 创建矩形进入监听 } = require("系统.00．核心系统.01．事件中心.02．区域事件中心") as {
  创建矩形进入监听: (this: void, rect: any, callback: (this: void) => void, filter?: any) => {
    区域: any;
    触发器: any;
    取消: (this: void) => void;
  } | null;
};
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
  unregisterDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 动态矩形区域配置表, 注册动态矩形区域, 注销动态矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.index") as {
  动态矩形区域配置表: Record<string, { 键: string; 左: number; 右: number; 下: number; 上: number; 说明?: string }>;
  注册动态矩形区域: (this: void, 配置: { 键: string; 左: number; 右: number; 下: number; 上: number; 说明?: string }) => any;
  注销动态矩形区域: (this: void, 键: string) => boolean;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
};
const { YDUserDataSetSafe, YDUserDataClearSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
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
const { RectContainsUnit } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  RectContainsUnit: (this: void, rect: any, unit: any) => boolean;
};

const CreateDestructable = jass.CreateDestructable as (
  this: void,
  objectid: number,
  x: number,
  y: number,
  facing: number,
  scale: number,
  variation: number,
) => any;
const RemoveDestructable = jass.RemoveDestructable as (this: void, whichDestructable: any) => void;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetUnitState = jass.GetUnitState as (this: void, whichUnit: any, state: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, whichUnit: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const IssueTargetOrder = jass.IssueTargetOrder as (this: void, whichUnit: any, order: string, target: any) => boolean;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const GetPlayerState = jass.GetPlayerState as (this: void, whichPlayer: any, whichPlayerState: any) => number;
const PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD as number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const 中立敌对玩家ID = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const bj_QUESTMESSAGE_UPDATED = jglobals.bj_QUESTMESSAGE_UPDATED as number;
const bj_QUESTMESSAGE_WARNING = jglobals.bj_QUESTMESSAGE_WARNING as number;

const 中立被动玩家ID = 15;
const 调查范围 = 450;

export function 执行开启恶魔城领主区域视野(this: void): void {
  给玩家组添加多个区域视野("熔岩恶魔城");
}
const 下层仓库入口矩形键 = "剧情.恶魔城下层仓库入口";
const 下层仓库清理者待战暂停来源 = "剧情系统:恶魔城下层仓库清理者待战";
const 下层仓库赤尾待战暂停来源 = "剧情系统:恶魔城下层仓库赤尾待战";
const 下层仓库动态Boss待战暂停来源 = "剧情系统:恶魔城教派恶魔军官待战";
const 赤尾前往下层仓库保底间隔毫秒 = 400;
const 赤尾到达下层仓库距离 = 96;
const 下层仓库赤尾对白X = 20171.3;
const 下层仓库赤尾对白Y = -18292.4;
const 下层仓库赤尾对白朝向 = 45;

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
let 赤尾移动控制器: 剧情单位移动控制器 | undefined;
let 下层仓库赤尾已到达对白位置 = false;
let 下层仓库待触发玩家单位: any = null;
let 下层仓库入口矩形: any = null;
let 下层仓库入口监听: { 区域: any; 触发器: any; 取消: (this: void) => void } | null = null;
let 已触发下层仓库伏击 = false;
let 下层仓库触发玩家单位: any = null;
let 下层仓库赤尾: any = null;
let 下层仓库清理者学者: any = null;
let 下层仓库清理者战士: any = null;
let 下层仓库动态Boss: any = null;
let 下层仓库Dofw图4: any = null;
let 下层仓库Dofw图5: any = null;
let 下层仓库赤尾已死亡 = false;
let 下层仓库战斗进行中 = false;
let 下层仓库剩余敌人 = 0;
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

function 清理赤尾移动保底(this: void): void {
  if (赤尾移动控制器 != null) 赤尾移动控制器.取消();
  赤尾移动控制器 = undefined;
}

function on赤尾到达下层仓库(this: void, _赤尾: any): void {
  赤尾移动控制器 = undefined;
  下层仓库赤尾已到达对白位置 = true;
  const 待触发玩家 = 下层仓库待触发玩家单位;
  if (
    单位有效(待触发玩家) &&
    是玩家英雄组单位(待触发玩家) &&
    下层仓库入口矩形 != null &&
    RectContainsUnit(下层仓库入口矩形, 待触发玩家)
  ) {
    下层仓库待触发玩家单位 = null;
    触发下层仓库伏击(待触发玩家);
  }
}

function 赤尾移动是否继续(this: void, _赤尾: any): boolean {
  return 读取剧情进度() === 39;
}

function 赤尾转向触发玩家(this: void, _参数?: 剧情动作参数表): void {
  const 赤尾 = 读取语义单位引用("主线NPC.赤尾");
  const 触发单位 = 读取触发单位();
  if (单位有效(赤尾) && 单位有效(触发单位)) 转向目标(赤尾, 触发单位);
}

function 赤尾前往下层仓库(this: void, 参数?: 剧情动作参数表): void {
  if (!已支付赤尾定金) return;
  const 赤尾 = 读取语义单位引用("主线NPC.赤尾");
  if (!单位存活(赤尾)) return;

  清理赤尾移动保底();
  下层仓库赤尾已到达对白位置 = false;
  下层仓库待触发玩家单位 = null;
  const 目标X = 读取动作数字(参数 ?? {}, "赤尾X", 下层仓库赤尾对白X);
  const 目标Y = 读取动作数字(参数 ?? {}, "赤尾Y", 下层仓库赤尾对白Y);
  赤尾移动控制器 = 开始剧情单位保持移动({
    单位: 赤尾,
    目标X,
    目标Y,
    到达距离: 赤尾到达下层仓库距离,
    检查间隔毫秒: 赤尾前往下层仓库保底间隔毫秒,
    到达命令: "holdposition",
    到达朝向: 下层仓库赤尾对白朝向,
    是否继续: 赤尾移动是否继续,
    到达回调: on赤尾到达下层仓库,
  });
}

function on锻造区证人范围触发(this: void, 触发单位: any): boolean {
  if (已触发锻造区证人 || 读取剧情进度() !== 39) return false;
  if (触发单位 == null || 触发单位 === 0) return false;
  已触发锻造区证人 = true;
  播放调查剧情("molten_realm_forge_witness", 触发单位, "恶魔城锻造区证人入口");
  return true;
}

function on赤尾范围触发(this: void, 触发单位: any): boolean {
  if (已触发赤尾交易 || 读取剧情进度() !== 39) return false;
  if (已支付赤尾定金) return false;
  if (触发单位 == null || 触发单位 === 0) return false;
  已触发赤尾交易 = true;
  播放调查剧情("molten_realm_redtail_meet", 触发单位, "恶魔城赤尾交易入口");
  return true;
}

function 注册单位范围入口(this: void, unit: any, range: number, action: (this: void, enteringUnit: any) => boolean): () => void {
  if (unit == null || unit === 0) return 空取消范围监听;
  return registerOneShotUnitRangeListener(unit, range, action, 是玩家英雄组单位);
}

function 清理下层仓库入口监听(this: void): void {
  if (下层仓库入口监听 != null) 下层仓库入口监听.取消();
  注销动态矩形区域(下层仓库入口矩形键);
  下层仓库入口监听 = null;
  下层仓库入口矩形 = null;
}

function 触发下层仓库伏击(this: void, 触发单位: any): void {
  if (已触发下层仓库伏击 || 读取剧情进度() !== 39) return;
  if (!已支付赤尾定金 || !下层仓库赤尾已到达对白位置) return;
  if (触发单位 == null || 触发单位 === 0 || !是玩家英雄组单位(触发单位)) return;
  已触发下层仓库伏击 = true;
  下层仓库触发玩家单位 = 触发单位;
  下层仓库待触发玩家单位 = null;
  清理下层仓库入口监听();
  播放调查剧情("molten_realm_warehouse_ambush", 触发单位, "恶魔城下层仓库入口");
}

function on进入下层仓库入口(this: void): void {
  if (已触发下层仓库伏击 || 读取剧情进度() !== 39) return;
  // 必须先完成赤尾交易并支付定金，避免玩家跳过线索直接进入仓库伏击。
  if (!已支付赤尾定金) return;
  const 触发单位 = GetTriggerUnit();
  if (触发单位 == null || 触发单位 === 0 || !是玩家英雄组单位(触发单位)) return;
  if (!下层仓库赤尾已到达对白位置) {
    // 玩家可以先到仓库，但必须等赤尾走到对白站位；入口监听保持有效，不消费这次触发。
    下层仓库待触发玩家单位 = 触发单位;
    return;
  }
  触发下层仓库伏击(触发单位);
}

function 注册下层仓库入口监听(this: void): void {
  if (下层仓库入口监听 != null) return;
  下层仓库入口矩形 = 注册动态矩形区域(动态矩形区域配置表[下层仓库入口矩形键]);
  if (下层仓库入口矩形 == null || 下层仓库入口矩形 === 0) return;
  下层仓库入口监听 = 创建矩形进入监听(下层仓库入口矩形, on进入下层仓库入口);
  if (下层仓库入口监听 == null) {
    注销动态矩形区域(下层仓库入口矩形键);
    下层仓库入口矩形 = null;
  }
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
  const unit = 创建剧情场景单位({
    单位ID,
    X: 站位.X,
    Y: 站位.Y,
    朝向: 站位.朝向,
    玩家ID: 中立被动玩家ID,
    登记死亡排泄: true,
    初始化命令: "stop",
  });
  if (unit == null || unit === 0) return null;
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
  const 单位ID = 按名字反查总单位ID(单位名);
  const 单位类型ID = stringToFourCCSafe(单位ID);
  if (!(单位类型ID > 0)) return null;

  const unit = 创建剧情场景单位({
    单位ID: 单位ID!,
    X: x,
    Y: y,
    朝向,
    玩家ID: 中立敌对玩家ID,
    登记死亡排泄: true,
    初始化命令: "stop",
    初始化无敌: true,
    初始化暂停来源: 下层仓库清理者待战暂停来源,
  });
  if (!单位有效(unit)) return null;
  注册剧情运行时单位(语义引用, unit);
  return unit;
}

function 清理下层仓库战斗运行时引用(this: void): void {
  清理剧情运行时单位("剧情单位.教派清理者（学者）");
  清理剧情运行时单位("剧情单位.教派清理者（战士）");
  清理剧情运行时单位("剧情单位.教派恶魔军官");

  if (单位有效(下层仓库动态Boss)) {
    立即移除单位并取消排泄登记(下层仓库动态Boss);
  }
  YDUserDataClearSafe("string", "Boss", "教派恶魔军官", "unit");
  下层仓库动态Boss = null;

  if (下层仓库Dofw图4 != null && 下层仓库Dofw图4 !== 0) {
    RemoveDestructable(下层仓库Dofw图4);
  }
  if (下层仓库Dofw图5 != null && 下层仓库Dofw图5 !== 0) {
    RemoveDestructable(下层仓库Dofw图5);
  }
  下层仓库Dofw图4 = null;
  下层仓库Dofw图5 = null;
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
  下层仓库剩余敌人 = 0;
  下层仓库赤尾已到达对白位置 = false;
  下层仓库待触发玩家单位 = null;

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

  let 是伏击敌人 = false;
  if (dyingUnit === 下层仓库清理者学者 || dyingUnit === 下层仓库清理者战士) {
    是伏击敌人 = true;
  }
  if (dyingUnit === 下层仓库动态Boss) {
    是伏击敌人 = true;
  }
  if (!是伏击敌人) return;

  if (下层仓库剩余敌人 > 0) 下层仓库剩余敌人--;
  if (下层仓库剩余敌人 <= 0) 安排下层仓库战斗结算();
}

function 布置下层仓库伏击(this: void, 参数: 剧情动作参数表): void {
  if (
    下层仓库战斗进行中 ||
    下层仓库清理者学者 != null ||
    下层仓库清理者战士 != null ||
    下层仓库动态Boss != null
  ) return;

  const 赤尾 = 读取语义单位引用("主线NPC.赤尾");
  if (!单位有效(赤尾)) return;
  if (!下层仓库赤尾已到达对白位置) return;

  // 赤尾已经走到对白站位；这里只接管暂停和朝向，不再瞬移覆盖实际移动。
  清理赤尾移动保底();

  下层仓库战斗世代++;
  下层仓库赤尾 = 赤尾;
  下层仓库赤尾已死亡 = !单位存活(赤尾);
  下层仓库战斗结算已安排 = false;
  下层仓库剩余敌人 = 0;

  const 赤尾朝向 = 读取动作数字(参数, "赤尾朝向", 下层仓库赤尾对白朝向);
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

  const 教派恶魔军官类型ID = stringToFourCCSafe("O002");
  if (教派恶魔军官类型ID > 0) {
    下层仓库动态Boss = 创建剧情场景单位({
      单位ID: "O002",
      X: 20581.7,
      Y: -17857.8,
      朝向: 225,
      玩家ID: 中立敌对玩家ID,
      登记死亡排泄: true,
      初始化命令: "stop",
      初始化无敌: true,
      初始化暂停来源: 下层仓库动态Boss待战暂停来源,
    });
    if (单位有效(下层仓库动态Boss)) {
      注册剧情运行时单位("剧情单位.教派恶魔军官", 下层仓库动态Boss);
      YDUserDataSetSafe("string", "Boss", "教派恶魔军官", "unit", 下层仓库动态Boss);
    } else {
      下层仓库动态Boss = null;
    }
  }

  const Dofw类型ID = stringToFourCCSafe("Dofw");
  if (Dofw类型ID > 0) {
    下层仓库Dofw图4 = CreateDestructable(Dofw类型ID, 19455.5, -19092.3, 180, 1, 0);
    下层仓库Dofw图5 = CreateDestructable(Dofw类型ID, 20854.4, -17065.4, 270, 1, 0);
  }

  if (单位有效(下层仓库清理者学者)) 下层仓库剩余敌人++;
  if (单位有效(下层仓库清理者战士)) 下层仓库剩余敌人++;
  if (单位有效(下层仓库动态Boss)) 下层仓库剩余敌人++;
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
  if (单位有效(下层仓库动态Boss)) {
    解除暂停并取消无敌安全(下层仓库动态Boss, 下层仓库动态Boss待战暂停来源);
    转向目标(下层仓库动态Boss, 赤尾);
    IssueTargetOrder(下层仓库动态Boss, "attack", 赤尾);
  }
  if (单位存活(赤尾)) {
    解除暂停并取消无敌安全(赤尾, 下层仓库赤尾待战暂停来源);
  }
  if (下层仓库剩余敌人 <= 0) 安排下层仓库战斗结算();
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
  取消赤尾范围监听 = 注册单位范围入口(赤尾, 调查范围, on赤尾范围触发);
  注册下层仓库入口监听();
}

export const 恶魔城调查剧情动作注册表: Record<string, 剧情动作处理器> = {
  "第三章_开启恶魔城领主区域视野": 执行开启恶魔城领主区域视野,
  "第三章_布置恶魔城调查": 执行布置恶魔城调查,
  "第三章_支付赤尾定金": 支付赤尾定金,
  "第三章_结束赤尾交易尝试": 结束赤尾交易尝试,
  "第三章_赤尾转向触发玩家": 赤尾转向触发玩家,
  "第三章_赤尾前往下层仓库": 赤尾前往下层仓库,
  "第三章_布置下层仓库伏击": 布置下层仓库伏击,
  "第三章_下层仓库清理者转向赤尾": 下层仓库清理者转向赤尾,
  "第三章_开启下层仓库战斗": 开启下层仓库战斗,
  "第三章_记录下层仓库证据": 记录下层仓库证据,
};
