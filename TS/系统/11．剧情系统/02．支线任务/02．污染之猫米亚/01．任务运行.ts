/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 广播单位提示, 播放广播对白序列 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
  播放广播对白序列: (this: void, 配置: any) => void;
};
const { 广播提示玩家槽数 } = require("系统.09．表现系统.06．广播提示消息.00．常量定义") as {
  广播提示玩家槽数: number;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, 延迟毫秒: number, 回调: (this: void) => void) => number;
  addPeriodicCallback: (this: void, 间隔毫秒: number, 回调: (this: void) => void) => number;
  removePeriodicCallback: (this: void, 回调ID: number) => void;
};
const { 创建矩形进入监听 } = require("系统.00．核心系统.01．事件中心.02．区域事件中心") as {
  创建矩形进入监听: (this: void, rect: any, callback: (this: void) => void, filter?: any) => { 区域: any; 触发器: any; 取消: (this: void) => void } | null;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { 暂停并设置无敌安全 } = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装") as {
  暂停并设置无敌安全: (this: void, unit: any, source: string) => boolean;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: {
    模型路径: string;
    X: number;
    Y: number;
    Z?: number;
    缩放?: number;
    动画速度?: number;
    Z轴角度?: number;
    持续秒?: number;
  }) => any;
};
const { YDWEAngleBetweenUnitsSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { 记录Boss自动技能启动, 是否已登记Boss自动技能 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  记录Boss自动技能启动: (this: void, unit: any, source: "Boss战.绑定单位") => any;
  是否已登记Boss自动技能: (this: void, unit: any) => boolean;
};
const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用") as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { 启动Boss战运行 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动") as {
  启动Boss战运行: (this: void, bossUnit: any) => void;
};
const { 米亚单位技能配置 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置") as {
  米亚单位技能配置: { 特效: { 入出水水花: string } };
};
const { 米亚奖励池ID } = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表.index") as {
  米亚奖励池ID: string;
};
const { 打开首领奖励选择界面 } = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面") as {
  打开首领奖励选择界面: (this: void, 奖励池ID: string, 玩家: any) => void;
};
const { 按配置键注册动态矩形区域, 注销动态矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.02．动态矩形区域动作") as {
  按配置键注册动态矩形区域: (this: void, 键: string) => any;
  注销动态矩形区域: (this: void, 键: string) => boolean;
};

import {
  米亚Boss区入口ID,
  米亚Boss区入口X,
  米亚Boss区入口Y,
  米亚Boss区入口朝向,
  米亚Boss区落点X,
  米亚Boss区落点Y,
  米亚Boss区落点朝向,
  米亚传送入口半径,
  米亚入水X,
  米亚入水Y,
  米亚入水朝向,
  米亚单位ID,
  米亚最终X,
  米亚最终Y,
  米亚永久传送门模型,
  米亚污染区入口ID,
  米亚污染区入口X,
  米亚污染区入口Y,
  米亚污染区入口朝向,
  米亚污染区落点X,
  米亚污染区落点Y,
  米亚污染区落点朝向,
  米亚登岸移动总步数,
  米亚登岸移动间隔毫秒,
} from "./00．常量";
import { 创建米亚道中怪物 } from "./03．道中怪物";

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetTriggeringTrigger = jass.GetTriggeringTrigger as (this: void) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, unit: any, order: string) => boolean;
const Player = jass.Player as (this: void, playerId: number) => any;
const Rect = jass.Rect as (this: void, minX: number, minY: number, maxX: number, maxY: number) => any;
const RemoveRect = jass.RemoveRect as (this: void, rect: any) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitPathing = jass.SetUnitPathing as (this: void, unit: any, flag: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const 中立敌对玩家ID = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const 中立被动玩家ID = jass.PLAYER_NEUTRAL_PASSIVE as number;
const 米亚一次性入口监听矩形键 = "支线.米亚一次性入口监听";

interface 永久传送状态 {
  ID: string;
  目标X: number;
  目标Y: number;
  目标面向: number;
  触发器: any;
  区域: any;
  取消监听: (this: void) => void;
  首次抵达广播: boolean;
}

interface 米亚入口监听状态 {
  取消: (this: void) => void;
  已触发: boolean;
}

const 永久传送状态表: Record<number, 永久传送状态 | undefined> = {};
let 米亚任务内容已创建 = false;
let 污染区首次抵达已播放 = false;
let 污染区首次抵达单位: any = null;
let 当前米亚单位: any = null;
let 当前米亚演出玩家单位: any = null;
let 当前米亚入口监听: 米亚入口监听状态 | undefined;
let 米亚登岸移动回调ID = 0;
let 米亚登岸移动步数 = 0;

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 读取污染区首次抵达单位(this: void, _说话者键: string): any {
  return 污染区首次抵达单位;
}

function 播放污染区首次抵达第一段(this: void, unit: any): void {
  污染区首次抵达单位 = unit;
  播放广播对白序列({
    对白列表: [
      { 说话者键: "玩家", 文本: "刚踏出裂隙，一股浓重的污臭便从水道深处涌来，连呼吸都带着刺痛。", 停留毫秒: 4800 },
      { 说话者键: "玩家", 文本: "越往西走，水面上的紫黑色沉积越厚。污染源应该就在那个方向。", 停留毫秒: 4800 },
    ],
    读取说话单位: 读取污染区首次抵达单位,
    播放单句: 广播单位提示,
  });
}

function on永久传送进入(this: void): void {
  const trigger = GetTriggeringTrigger();
  if (!句柄有效(trigger)) return;
  const 状态 = 永久传送状态表[GetHandleId(trigger)];
  if (状态 == null) return;
  const unit = GetTriggerUnit();
  if (!句柄有效(unit) || !是玩家英雄组单位(unit)) return;

  SetUnitPosition(unit, 状态.目标X, 状态.目标Y);
  SetUnitFacing(unit, 状态.目标面向);
  IssueImmediateOrder(unit, "stop");
  if (状态.首次抵达广播 && !污染区首次抵达已播放) {
    污染区首次抵达已播放 = true;
    播放污染区首次抵达第一段(unit);
  }
}

function 注册永久传送入口(
  this: void,
  ID: string,
  入口X: number,
  入口Y: number,
  入口面向: number,
  目标X: number,
  目标Y: number,
  目标面向: number,
  首次抵达广播: boolean,
  显示传送门: boolean,
): boolean {
  const rect = Rect(
    入口X - 米亚传送入口半径,
    入口Y - 米亚传送入口半径,
    入口X + 米亚传送入口半径,
    入口Y + 米亚传送入口半径,
  );
  if (!句柄有效(rect)) return false;
  const 监听 = 创建矩形进入监听(rect, on永久传送进入, null);
  RemoveRect(rect);
  if (监听 == null) return false;

  const 状态: 永久传送状态 = {
    ID,
    目标X,
    目标Y,
    目标面向,
    触发器: 监听.触发器,
    区域: 监听.区域,
    取消监听: 监听.取消,
    首次抵达广播,
  };
  永久传送状态表[GetHandleId(监听.触发器)] = 状态;
  if (显示传送门) {
    创建点特效({
      模型路径: 米亚永久传送门模型,
      X: 入口X,
      Y: 入口Y,
      Z轴角度: 入口面向,
      缩放: 0.75,
    });
  }
  return true;
}

function 清理米亚入口监听(this: void): void {
  const 状态 = 当前米亚入口监听;
  if (状态 == null) return;
  状态.取消();
  注销动态矩形区域(米亚一次性入口监听矩形键);
  当前米亚入口监听 = undefined;
}

function 创建米亚单位(this: void): any {
  if (句柄有效(当前米亚单位)) return 当前米亚单位;
  const unit = 创建单位并登记排泄安全(
    Player(中立被动玩家ID),
    stringToFourCCSafe(米亚单位ID),
    米亚入水X,
    米亚入水Y,
    米亚入水朝向,
  );
  if (!句柄有效(unit)) return null;
  当前米亚单位 = unit;
  暂停并设置无敌安全(unit, "支线.污染之猫米亚待战");
  SetUnitPathing(unit, false);
  return unit;
}

function 创建米亚登岸水花(this: void): void {
  if (!句柄有效(当前米亚单位)) return;
  创建点特效({
    模型路径: 米亚单位技能配置.特效.入出水水花,
    X: GetUnitX(当前米亚单位),
    Y: GetUnitY(当前米亚单位),
    缩放: 1.25,
    动画速度: 1.5,
    持续秒: 1.4,
  });
}

function 读取米亚对白单位(this: void, 说话者键: string): any {
  return 说话者键 === "米亚" ? 当前米亚单位 : 当前米亚演出玩家单位;
}

function 播放米亚对话(this: void): void {
  播放广播对白序列({
    对白列表: [
      { 说话者键: "米亚", 文本: "别再靠近……清水会刺痛我。这里已经是米亚的巢。", 停留毫秒: 4400 },
      { 说话者键: "玩家", 文本: "原来污染水源的就是你。城里的人正在中毒，水源必须恢复原样。", 停留毫秒: 4800 },
      { 说话者键: "米亚", 文本: "中毒？不……黑色的水才不会痛。只要全都染黑，就没有谁能再伤害米亚。", 停留毫秒: 5200 },
      { 说话者键: "玩家", 文本: "那就只能先阻止你了。", 停留毫秒: 3400 },
      { 说话者键: "米亚", 文本: "你也想把这里洗干净……不许碰我的水！", 停留毫秒: 4200 },
    ],
    读取说话单位: 读取米亚对白单位,
    播放单句: 广播单位提示,
    播放完成: 启动米亚Boss战,
  });
}

function 完成米亚登岸(this: void): void {
  if (!句柄有效(当前米亚单位) || !句柄有效(当前米亚演出玩家单位)) return;
  SetUnitPosition(当前米亚单位, 米亚最终X, 米亚最终Y);
  SetUnitPathing(当前米亚单位, true);
  SetUnitFacing(当前米亚单位, YDWEAngleBetweenUnitsSafe(当前米亚单位, 当前米亚演出玩家单位));
  SetUnitFacing(当前米亚演出玩家单位, YDWEAngleBetweenUnitsSafe(当前米亚演出玩家单位, 当前米亚单位));
  播放米亚对话();
}

function on米亚登岸移动(this: void): void {
  if (!句柄有效(当前米亚单位)) {
    if (米亚登岸移动回调ID !== 0) removePeriodicCallback(米亚登岸移动回调ID);
    米亚登岸移动回调ID = 0;
    return;
  }

  米亚登岸移动步数++;
  const 进度 = 米亚登岸移动步数 / 米亚登岸移动总步数;
  SetUnitPosition(
    当前米亚单位,
    米亚入水X + (米亚最终X - 米亚入水X) * 进度,
    米亚入水Y + (米亚最终Y - 米亚入水Y) * 进度,
  );
  if (米亚登岸移动步数 === 1 || 米亚登岸移动步数 % 2 === 0) 创建米亚登岸水花();
  if (米亚登岸移动步数 < 米亚登岸移动总步数) return;

  if (米亚登岸移动回调ID !== 0) removePeriodicCallback(米亚登岸移动回调ID);
  米亚登岸移动回调ID = 0;
  完成米亚登岸();
}

function 开始米亚登岸演出(this: void, 触发单位: any): void {
  当前米亚演出玩家单位 = 触发单位;
  const boss = 创建米亚单位();
  if (!句柄有效(boss)) return;
  米亚登岸移动步数 = 0;
  创建米亚登岸水花();
  米亚登岸移动回调ID = addPeriodicCallback(米亚登岸移动间隔毫秒, on米亚登岸移动);
}

function on米亚入口区域进入(this: void): void {
  const 状态 = 当前米亚入口监听;
  if (状态 == null || 状态.已触发) return;
  const unit = GetTriggerUnit();
  if (!句柄有效(unit) || !是玩家英雄组单位(unit)) return;
  状态.已触发 = true;
  清理米亚入口监听();
  开始米亚登岸演出(unit);
}

function 注册米亚一次性入口监听(this: void): boolean {
  if (当前米亚入口监听 != null) return false;
  const rect = 按配置键注册动态矩形区域(米亚一次性入口监听矩形键);
  if (!句柄有效(rect)) {
    注销动态矩形区域(米亚一次性入口监听矩形键);
    return false;
  }
  const 监听 = 创建矩形进入监听(rect, on米亚入口区域进入, null);
  if (监听 == null) {
    注销动态矩形区域(米亚一次性入口监听矩形键);
    return false;
  }
  当前米亚入口监听 = {
    取消: 监听.取消,
    已触发: false,
  };
  return true;
}

function 启动米亚Boss战(this: void): void {
  const boss = 当前米亚单位;
  if (!句柄有效(boss)) return;
  if (!是否已登记Boss自动技能(boss)) 记录Boss自动技能启动(boss, "Boss战.绑定单位");
  应用Boss战启动属性配置(boss);
  YDUserDataSetSafe("string", "Boss战", "绑定单位", "unit", boss);
  if (句柄有效(当前米亚演出玩家单位)) {
    YDUserDataSetSafe("string", "Boss战", "触发玩家", "unit", 当前米亚演出玩家单位);
  }
  启动Boss战运行(boss);
}

export function 接受污染之猫米亚任务后创建入口(_任务配置?: any, _玩家ID?: number): void {
  if (米亚任务内容已创建) return;
  米亚任务内容已创建 = true;
  创建米亚道中怪物();
  注册永久传送入口(
    米亚污染区入口ID,
    米亚污染区入口X,
    米亚污染区入口Y,
    米亚污染区入口朝向,
    米亚污染区落点X,
    米亚污染区落点Y,
    米亚污染区落点朝向,
    true,
    true,
  );
  注册永久传送入口(
    米亚Boss区入口ID,
    米亚Boss区入口X,
    米亚Boss区入口Y,
    米亚Boss区入口朝向,
    米亚Boss区落点X,
    米亚Boss区落点Y,
    米亚Boss区落点朝向,
    false,
    false,
  );
  注册米亚一次性入口监听();
}

export function 完成污染之猫米亚任务后打开首领奖励(_任务配置?: any, _玩家ID?: number): void {
  for (let 玩家ID = 0; 玩家ID < 广播提示玩家槽数; 玩家ID++) {
    const 玩家 = Player(玩家ID);
    if (玩家 != null && jass.GetPlayerController(玩家) === jass.MAP_CONTROL_USER) {
      打开首领奖励选择界面(米亚奖励池ID, 玩家);
    }
  }
}

export function 读取米亚任务Boss单位(this: void): any {
  return 当前米亚单位;
}
