/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 创建矩形进入监听 } = require("系统.00．核心系统.01．事件中心.02．区域事件中心") as {
  创建矩形进入监听: (this: void, 矩形: any, 回调: (this: void) => void, 过滤器?: any) => { 区域: any; 触发器: any; 取消: (this: void) => void } | null;
};
const { registerOneShotUnitRangeListener } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerOneShotUnitRangeListener: (
    this: void,
    单位: any,
    范围: number,
    回调: (this: void, 进入单位: any) => boolean,
    条件?: (this: void, 进入单位: any) => boolean,
  ) => (this: void) => void;
};
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
  unregisterDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, 单位: any) => boolean;
};
const { 广播单位提示, 播放广播对白序列 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
  播放广播对白序列: (this: void, 配置: any) => void;
};
const { 创建并冻结剧情Boss预置, 剧情Boss预置暂停来源 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接") as {
  创建并冻结剧情Boss预置: (this: void, 参数: any) => any;
  剧情Boss预置暂停来源: string;
};
const { 启动剧情Boss战 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接") as {
  启动剧情Boss战: (this: void, Boss单位: any, 参数?: { 触发单位?: any; 暂停来源?: string }) => boolean;
};
const { questDB } = require("系统.08．任务系统.01．任务数据") as {
  questDB: {
    updateObjective: (玩家ID: number, 任务ID: string, 目标ID: string, 进度: number) => boolean;
  };
};
const { 触发任务UI刷新 } = require("系统.08．任务系统.02．任务管理器") as {
  触发任务UI刷新: (this: void, 玩家ID: number, 任务ID?: string) => void;
};
const { 莫尔特斯奖励池ID } = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表.index") as {
  莫尔特斯奖励池ID: string;
};
const { 打开首领奖励选择界面 } = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面") as {
  打开首领奖励选择界面: (this: void, 奖励池ID: string, 玩家: any) => void;
};
const { 广播提示玩家槽数 } = require("系统.09．表现系统.06．广播提示消息.00．常量定义") as {
  广播提示玩家槽数: number;
};

import {
  莫尔特斯任务ID,
  莫尔特斯传送门特效路径,
  莫尔特斯传送门X,
  莫尔特斯传送门Y,
  莫尔特斯传送门半径,
  莫尔特斯传送落点X,
  莫尔特斯传送落点Y,
  莫尔特斯传送落点朝向,
  莫尔特斯Boss语义键,
  莫尔特斯Boss名称,
  莫尔特斯Boss单位ID,
  莫尔特斯Boss预置玩家ID,
  莫尔特斯Boss出生X,
  莫尔特斯Boss出生Y,
  莫尔特斯Boss出生朝向,
  莫尔特斯Boss靠近范围,
} from "./00．常量";

const AddSpecialEffect = jass.AddSpecialEffect as (this: void, 模型路径: string, X: number, Y: number) => any;
const DestroyEffect = jass.DestroyEffect as (this: void, 特效: any) => void;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetWidgetLife = jass.GetWidgetLife as (this: void, 句柄: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, 单位: any, 类型: any) => boolean;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, 单位: any, 命令: string) => boolean;
const Player = jass.Player as (this: void, 玩家ID: number) => any;
const Rect = jass.Rect as (this: void, 最小X: number, 最小Y: number, 最大X: number, 最大Y: number) => any;
const RemoveRect = jass.RemoveRect as (this: void, 矩形: any) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, 单位: any, 朝向: number) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, 单位: any, 玩家: any, 改变颜色: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, 单位: any, X: number, Y: number) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

let 传送门已初始化 = false;
let 传送门特效: any = null;
let 传送门矩形: any = null;
let 传送门区域: any = null;
let 传送门触发器: any = null;
let 取消传送门监听: ((this: void) => void) | undefined;

let 当前莫尔特斯单位: any = null;
let 当前对话英雄: any = null;
let 取消靠近范围监听: ((this: void) => void) | undefined;
let 靠近对白已触发 = false;
let Boss战已启动 = false;
let Boss死亡监听已注册 = false;

function 句柄有效(this: void, 句柄: any): boolean {
  return 句柄 != null && 句柄 !== 0;
}

function 单位存活(this: void, 单位: any): boolean {
  return 句柄有效(单位) && GetWidgetLife(单位) > 0.405 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

function on莫尔特斯传送门进入(this: void): void {
  const 进入单位 = GetTriggerUnit();
  if (!句柄有效(进入单位) || !是玩家英雄组单位(进入单位)) return;

  SetUnitPosition(进入单位, 莫尔特斯传送落点X, 莫尔特斯传送落点Y);
  SetUnitFacing(进入单位, 莫尔特斯传送落点朝向);
  IssueImmediateOrder(进入单位, "stop");
}

function 清理失败的传送门句柄(this: void): void {
  if (取消传送门监听 != null) 取消传送门监听();
  if (句柄有效(传送门矩形)) RemoveRect(传送门矩形);
  if (句柄有效(传送门特效)) DestroyEffect(传送门特效);
  传送门触发器 = null;
  传送门区域 = null;
  取消传送门监听 = undefined;
  传送门矩形 = null;
  传送门特效 = null;
}

function 确保创建永久传送门(this: void): void {
  if (传送门已初始化) return;

  传送门特效 = AddSpecialEffect(莫尔特斯传送门特效路径, 莫尔特斯传送门X, 莫尔特斯传送门Y);
  传送门矩形 = Rect(
    莫尔特斯传送门X - 莫尔特斯传送门半径,
    莫尔特斯传送门Y - 莫尔特斯传送门半径,
    莫尔特斯传送门X + 莫尔特斯传送门半径,
    莫尔特斯传送门Y + 莫尔特斯传送门半径,
  );
  if (!句柄有效(传送门特效)
    || !句柄有效(传送门矩形)) {
    清理失败的传送门句柄();
    return;
  }
  const 监听 = 创建矩形进入监听(传送门矩形, on莫尔特斯传送门进入, null);
  if (监听 == null) {
    清理失败的传送门句柄();
    return;
  }
  传送门区域 = 监听.区域;
  传送门触发器 = 监听.触发器;
  取消传送门监听 = 监听.取消;
  传送门已初始化 = true;
}

function 注销莫尔特斯靠近监听(this: void): void {
  if (取消靠近范围监听 != null) 取消靠近范围监听();
  取消靠近范围监听 = undefined;
}

function 注销莫尔特斯死亡监听(this: void): void {
  if (!Boss死亡监听已注册) return;
  unregisterDeathListener(on莫尔特斯死亡);
  Boss死亡监听已注册 = false;
}

function on莫尔特斯死亡(this: void, 死亡单位: any, _击杀单位: any): void {
  if (死亡单位 !== 当前莫尔特斯单位) return;

  注销莫尔特斯靠近监听();
  注销莫尔特斯死亡监听();
  const 任务ID = tostring(莫尔特斯任务ID);
  if (questDB.updateObjective(0, 任务ID, "obj1", 1)) {
    触发任务UI刷新(0, 任务ID);
  }
}

function on莫尔特斯对白结束(this: void): void {
  if (!单位存活(当前莫尔特斯单位) || Boss战已启动) return;

  const 已启动 = 启动剧情Boss战(当前莫尔特斯单位, {
    触发单位: 当前对话英雄,
    暂停来源: 剧情Boss预置暂停来源,
  });
  if (已启动) {
    Boss战已启动 = true;
    return;
  }

  靠近对白已触发 = false;
  注册莫尔特斯靠近监听();
}

function 读取莫尔特斯对白单位(this: void, 说话者键: string): any {
  return 说话者键 === "Boss" ? 当前莫尔特斯单位 : 当前对话英雄;
}

function 播放莫尔特斯对白(this: void): void {
  播放广播对白序列({
    对白列表: [
      { 说话者键: "玩家", 文本: "这股腐败已经侵入整片根系……你就是莫尔特斯？", 停留毫秒: 4300 },
      { 说话者键: "Boss", 文本: "这个名字早已埋进腐土。如今站在你们面前的，只剩山谷的伤口。", 停留毫秒: 4800 },
      { 说话者键: "玩家", 文本: "赫克提尔说你曾守护这里。若你还听得见，就让我们结束这场侵蚀。", 停留毫秒: 4700 },
      { 说话者键: "Boss", 文本: "结束？那就把你们的血肉留下，让森林替我记住答案！", 停留毫秒: 4600 },
    ],
    读取说话单位: 读取莫尔特斯对白单位,
    播放单句: 广播单位提示,
    播放前校验: 校验莫尔特斯对白状态,
    播放完成: on莫尔特斯对白结束,
  });
}

function 校验莫尔特斯对白状态(this: void): boolean {
  return 单位存活(当前莫尔特斯单位);
}

function on莫尔特斯靠近(this: void, 触发英雄: any): boolean {
  if (靠近对白已触发 || Boss战已启动 || !单位存活(当前莫尔特斯单位)) return true;
  if (!句柄有效(触发英雄)) return false;

  靠近对白已触发 = true;
  当前对话英雄 = 触发英雄;
  注销莫尔特斯靠近监听();
  IssueImmediateOrder(当前莫尔特斯单位, "stop");
  播放莫尔特斯对白();
  return true;
}

function 注册莫尔特斯靠近监听(this: void): void {
  if (!单位存活(当前莫尔特斯单位) || 取消靠近范围监听 != null || Boss战已启动) return;

  取消靠近范围监听 = registerOneShotUnitRangeListener(
    当前莫尔特斯单位,
    莫尔特斯Boss靠近范围,
    on莫尔特斯靠近,
    是玩家英雄组单位,
  );
}

function 确保创建莫尔特斯Boss(this: void): void {
  if (单位存活(当前莫尔特斯单位)) return;

  const Boss单位 = 创建并冻结剧情Boss预置({
    Boss键: 莫尔特斯Boss语义键,
    Boss名: 莫尔特斯Boss名称,
    允许单位类型: [莫尔特斯Boss单位ID],
    X: 莫尔特斯Boss出生X,
    Y: 莫尔特斯Boss出生Y,
    朝向: 莫尔特斯Boss出生朝向,
    预创建后暂停: true,
    预创建后无敌: true,
  });
  if (!单位存活(Boss单位)) return;

  当前莫尔特斯单位 = Boss单位;
  SetUnitOwner(Boss单位, Player(莫尔特斯Boss预置玩家ID), true);
  SetUnitPosition(Boss单位, 莫尔特斯Boss出生X, 莫尔特斯Boss出生Y);
  SetUnitFacing(Boss单位, 莫尔特斯Boss出生朝向);
  IssueImmediateOrder(Boss单位, "stop");
  注册莫尔特斯靠近监听();
  if (!Boss死亡监听已注册) {
    registerDeathListener(on莫尔特斯死亡);
    Boss死亡监听已注册 = true;
  }
}

export function 接受莫尔特斯任务后初始化战场(_任务配置?: any, _玩家ID?: number): void {
  确保创建永久传送门();
  确保创建莫尔特斯Boss();
}

export function 完成莫尔特斯任务后打开首领奖励(_任务配置?: any, _玩家ID?: number): void {
  for (let 玩家ID = 0; 玩家ID < 广播提示玩家槽数; 玩家ID++) {
    const 玩家 = Player(玩家ID);
    if (玩家 != null && jass.GetPlayerController(玩家) === jass.MAP_CONTROL_USER) {
      打开首领奖励选择界面(莫尔特斯奖励池ID, 玩家);
    }
  }
}

export function 读取当前莫尔特斯任务Boss(this: void): any {
  return 当前莫尔特斯单位;
}
