/** @noSelfInFile */

const jass = require("jass.common") as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, 延迟毫秒: number, 回调: (this: void) => void) => number;
};
const { registerEnterRegionTrigger } = require("系统.00．核心系统.01．事件中心.02．区域事件中心") as {
  registerEnterRegionTrigger: (this: void, 触发器: any, 区域: any, 过滤器?: any) => (this: void) => void;
};
const { registerUnitInRangeTrigger } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitInRangeTrigger: (
    this: void,
    触发器: any,
    单位: any,
    范围: number,
    过滤器?: any,
    单次?: boolean,
  ) => (this: void) => void;
};
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
  unregisterDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
};
const { safeTriggerAddAction, safeDestroyTrigger } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTriggerAddAction: (this: void, 触发器: any, 回调: (this: void) => void) => { readonly id: number } | null;
  safeDestroyTrigger: (this: void, 触发器: any) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, 单位: any) => boolean;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};
const { 广播提示滑入毫秒, 广播提示淡出毫秒 } = require("系统.09．表现系统.06．广播提示消息.00．常量定义") as {
  广播提示滑入毫秒: number;
  广播提示淡出毫秒: number;
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
const CreateRegion = jass.CreateRegion as (this: void) => any;
const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const DestroyEffect = jass.DestroyEffect as (this: void, 特效: any) => void;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetWidgetLife = jass.GetWidgetLife as (this: void, 句柄: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, 单位: any, 类型: any) => boolean;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, 单位: any, 命令: string) => boolean;
const Player = jass.Player as (this: void, 玩家ID: number) => any;
const Rect = jass.Rect as (this: void, 最小X: number, 最小Y: number, 最大X: number, 最大Y: number) => any;
const RegionAddRect = jass.RegionAddRect as (this: void, 区域: any, 矩形: any) => void;
const RemoveRect = jass.RemoveRect as (this: void, 矩形: any) => void;
const RemoveRegion = jass.RemoveRegion as (this: void, 区域: any) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, 单位: any, 朝向: number) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, 单位: any, 玩家: any, 改变颜色: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, 单位: any, X: number, Y: number) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

let 传送门已初始化 = false;
let 传送门特效: any = null;
let 传送门矩形: any = null;
let 传送门区域: any = null;
let 传送门触发器: any = null;

let 当前莫尔特斯单位: any = null;
let 当前对话英雄: any = null;
let 靠近范围触发器: any = null;
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

function 取广播完整播放毫秒(this: void, 停留毫秒: number): number {
  return 广播提示滑入毫秒 + 停留毫秒 + 广播提示淡出毫秒;
}

function on莫尔特斯传送门进入(this: void): void {
  const 进入单位 = GetTriggerUnit();
  if (!句柄有效(进入单位) || !是玩家英雄组单位(进入单位)) return;

  SetUnitPosition(进入单位, 莫尔特斯传送落点X, 莫尔特斯传送落点Y);
  SetUnitFacing(进入单位, 莫尔特斯传送落点朝向);
  IssueImmediateOrder(进入单位, "stop");
}

function 清理失败的传送门句柄(this: void): void {
  if (句柄有效(传送门触发器)) safeDestroyTrigger(传送门触发器);
  if (句柄有效(传送门区域)) RemoveRegion(传送门区域);
  if (句柄有效(传送门矩形)) RemoveRect(传送门矩形);
  if (句柄有效(传送门特效)) DestroyEffect(传送门特效);
  传送门触发器 = null;
  传送门区域 = null;
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
  传送门区域 = CreateRegion();
  传送门触发器 = CreateTrigger();
  if (!句柄有效(传送门特效)
    || !句柄有效(传送门矩形)
    || !句柄有效(传送门区域)
    || !句柄有效(传送门触发器)) {
    清理失败的传送门句柄();
    return;
  }
  if (safeTriggerAddAction(传送门触发器, on莫尔特斯传送门进入) == null) {
    清理失败的传送门句柄();
    return;
  }

  RegionAddRect(传送门区域, 传送门矩形);
  registerEnterRegionTrigger(传送门触发器, 传送门区域, null);
  传送门已初始化 = true;
}

function 注销莫尔特斯靠近监听(this: void): void {
  if (取消靠近范围监听 != null) 取消靠近范围监听();
  取消靠近范围监听 = undefined;
  if (句柄有效(靠近范围触发器)) safeDestroyTrigger(靠近范围触发器);
  靠近范围触发器 = null;
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

const 第一段对白停留毫秒 = 4300;
const 第二段对白停留毫秒 = 4800;
const 第三段对白停留毫秒 = 4700;
const 第四段对白停留毫秒 = 4600;

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

function 播放莫尔特斯第四段对白(this: void): void {
  if (!单位存活(当前莫尔特斯单位)) return;
  广播单位提示(
    当前莫尔特斯单位,
    "结束？那就把你们的血肉留下，让森林替我记住答案！",
    第四段对白停留毫秒,
  );
  addDelayedCallback(取广播完整播放毫秒(第四段对白停留毫秒), on莫尔特斯对白结束);
}

function 播放莫尔特斯第三段对白(this: void): void {
  if (!单位存活(当前莫尔特斯单位)) return;
  广播单位提示(
    当前对话英雄,
    "赫克提尔说你曾守护这里。若你还听得见，就让我们结束这场侵蚀。",
    第三段对白停留毫秒,
  );
  addDelayedCallback(取广播完整播放毫秒(第三段对白停留毫秒), 播放莫尔特斯第四段对白);
}

function 播放莫尔特斯第二段对白(this: void): void {
  if (!单位存活(当前莫尔特斯单位)) return;
  广播单位提示(
    当前莫尔特斯单位,
    "这个名字早已埋进腐土。如今站在你们面前的，只剩山谷的伤口。",
    第二段对白停留毫秒,
  );
  addDelayedCallback(取广播完整播放毫秒(第二段对白停留毫秒), 播放莫尔特斯第三段对白);
}

function 播放莫尔特斯第一段对白(this: void): void {
  广播单位提示(
    当前对话英雄,
    "这股腐败已经侵入整片根系……你就是莫尔特斯？",
    第一段对白停留毫秒,
  );
  addDelayedCallback(取广播完整播放毫秒(第一段对白停留毫秒), 播放莫尔特斯第二段对白);
}

function on莫尔特斯靠近(this: void): void {
  if (靠近对白已触发 || Boss战已启动 || !单位存活(当前莫尔特斯单位)) return;

  const 触发英雄 = GetTriggerUnit();
  if (!句柄有效(触发英雄) || !是玩家英雄组单位(触发英雄)) return;

  靠近对白已触发 = true;
  当前对话英雄 = 触发英雄;
  注销莫尔特斯靠近监听();
  IssueImmediateOrder(当前莫尔特斯单位, "stop");
  播放莫尔特斯第一段对白();
}

function 注册莫尔特斯靠近监听(this: void): void {
  if (!单位存活(当前莫尔特斯单位) || 句柄有效(靠近范围触发器) || Boss战已启动) return;

  const 触发器 = CreateTrigger();
  if (!句柄有效(触发器)) return;
  if (safeTriggerAddAction(触发器, on莫尔特斯靠近) == null) {
    safeDestroyTrigger(触发器);
    return;
  }

  靠近范围触发器 = 触发器;
  取消靠近范围监听 = registerUnitInRangeTrigger(
    触发器,
    当前莫尔特斯单位,
    莫尔特斯Boss靠近范围,
    null,
    false,
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
