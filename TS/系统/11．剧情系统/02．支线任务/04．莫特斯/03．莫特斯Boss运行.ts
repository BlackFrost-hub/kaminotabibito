/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { 获取矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.index") as {
  获取矩形区域: (this: void, 名称: string) => any;
};

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, 延迟毫秒: number, 回调: (this: void) => void) => number;
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
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};
const { 添加单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, 单位: any, 来源: string) => boolean;
};
const { YDUserDataSetSafe, YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, 表类型: string, 表名: any, 字段: string, 值类型: string, 值: any) => void;
  YDWEAngleBetweenUnitsSafe: (this: void, 起点单位: any, 终点单位: any) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, 模块: string, ...参数: any[]) => void;
};
const { SetStackedSoundBJ } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  SetStackedSoundBJ: (this: void, add: boolean, soundHandle: any, rectHandle: any) => void;
};
const { 创建剧情NPC单位 } = require("系统.11．剧情系统.00．公共.02．剧情NPC创建") as {
  创建剧情NPC单位: (this: void, 配置: any) => any;
};
const { 启动剧情Boss战 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接") as {
  启动剧情Boss战: (this: void, Boss单位: any, 参数?: { 触发单位?: any; 暂停来源?: string }) => boolean;
};
const { 剧情Boss预置暂停来源 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接") as {
  剧情Boss预置暂停来源: string;
};

import {
  莫特斯Boss单位ID,
  莫特斯Boss出生X,
  莫特斯Boss出生Y,
  莫特斯Boss出生面向,
  莫特斯Boss表键,
  莫特斯Boss触发范围,
  莫特斯模块名,
} from "./00．常量";
import {
  关闭莫特斯洞窟门,
  单位存活,
  句柄有效,
  取广播完整播放毫秒,
  打开莫特斯洞窟门,
  是莫特斯副本玩家英雄,
  莫特斯运行状态,
} from "./01．运行状态";

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, 单位: any, 命令: string) => boolean;
const SetUnitFacing = jass.SetUnitFacing as (this: void, 单位: any, 角度: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, 单位: any, 无敌: boolean) => void;

function 移除莫特斯洞窟区域背景音乐(this: void): void {
  if (莫特斯运行状态.洞窟区域背景音乐已移除) return;
  SetStackedSoundBJ(false, jglobals.gg_snd_BGM014, 获取矩形区域("盗贼洞窟"));
  莫特斯运行状态.洞窟区域背景音乐已移除 = true;
}

function 恢复莫特斯洞窟区域背景音乐(this: void): void {
  if (!莫特斯运行状态.洞窟区域背景音乐已移除) return;
  SetStackedSoundBJ(true, jglobals.gg_snd_BGM014, 获取矩形区域("盗贼洞窟"));
  莫特斯运行状态.洞窟区域背景音乐已移除 = false;
}

function 注销莫特斯范围监听(this: void): void {
  if (莫特斯运行状态.取消莫特斯范围监听 != null) 莫特斯运行状态.取消莫特斯范围监听();
  莫特斯运行状态.取消莫特斯范围监听 = undefined;
  if (句柄有效(莫特斯运行状态.莫特斯范围触发器)) safeDestroyTrigger(莫特斯运行状态.莫特斯范围触发器);
  莫特斯运行状态.莫特斯范围触发器 = null;
}

function 注销莫特斯死亡监听(this: void): void {
  if (!莫特斯运行状态.莫特斯死亡监听已注册) return;
  unregisterDeathListener(on莫特斯死亡);
  莫特斯运行状态.莫特斯死亡监听已注册 = false;
}

function on莫特斯死亡(this: void, 死亡单位: any, _击杀单位: any): void {
  if (死亡单位 !== 莫特斯运行状态.莫特斯单位) return;

  莫特斯运行状态.莫特斯已经死亡 = true;
  恢复莫特斯洞窟区域背景音乐();
  注销莫特斯范围监听();
  addDelayedCallback(1, 注销莫特斯死亡监听);
  打开莫特斯洞窟门();
  莫特斯运行状态.莫特斯单位 = null;
  莫特斯运行状态.当前入口英雄 = null;
}

function 播放莫特斯第五段对白(this: void): void {
  if (!单位存活(莫特斯运行状态.莫特斯单位)) return;
  广播单位提示(莫特斯运行状态.莫特斯单位, "很好。既然主动走进我的巢穴，就把命和财物都留下吧。", 3800);
  addDelayedCallback(取广播完整播放毫秒(3800), on莫特斯对白结束);
}

function 播放莫特斯第四段对白(this: void): void {
  if (!单位存活(莫特斯运行状态.莫特斯单位)) return;
  if (!单位存活(莫特斯运行状态.当前入口英雄)) {
    on莫特斯对白结束();
    return;
  }
  广播单位提示(莫特斯运行状态.当前入口英雄, "那就看看，今天倒下的究竟是谁。", 2800);
  addDelayedCallback(取广播完整播放毫秒(2800), 播放莫特斯第五段对白);
}

function 播放莫特斯第三段对白(this: void): void {
  if (!单位存活(莫特斯运行状态.莫特斯单位)) return;
  广播单位提示(莫特斯运行状态.莫特斯单位, "血债？沙漠里每天都有人死。只有踩过弱者尸体的人，才有资格活下去。", 4800);
  addDelayedCallback(取广播完整播放毫秒(4800), 播放莫特斯第四段对白);
}

function 播放莫特斯第二段对白(this: void): void {
  if (!单位存活(莫特斯运行状态.莫特斯单位)) return;
  if (!单位存活(莫特斯运行状态.当前入口英雄)) {
    on莫特斯对白结束();
    return;
  }
  广播单位提示(莫特斯运行状态.当前入口英雄, "你就是莫特斯？佣兵团的血债，该算清了。", 3200);
  addDelayedCallback(取广播完整播放毫秒(3200), 播放莫特斯第三段对白);
}

function 播放莫特斯第一段对白(this: void): void {
  if (!单位存活(莫特斯运行状态.莫特斯单位)) return;
  广播单位提示(莫特斯运行状态.莫特斯单位, "脚步声比我预想得更近。看来外面那些废物没能拦住你们。", 4200);
  addDelayedCallback(取广播完整播放毫秒(4200), 播放莫特斯第二段对白);
}

function on莫特斯对白结束(this: void): void {
  if (!单位存活(莫特斯运行状态.莫特斯单位) || 莫特斯运行状态.莫特斯战斗已启动) return;

  关闭莫特斯洞窟门();
  const 已启动 = 启动剧情Boss战(莫特斯运行状态.莫特斯单位, {
    触发单位: 莫特斯运行状态.当前入口英雄,
    暂停来源: 剧情Boss预置暂停来源,
  });
  if (已启动) {
    莫特斯运行状态.莫特斯战斗已启动 = true;
    移除莫特斯洞窟区域背景音乐();
    return;
  }

  debugLogForce(莫特斯模块名, "莫特斯Boss战启动失败");
  打开莫特斯洞窟门();
  莫特斯运行状态.莫特斯对白已触发 = false;
  注册莫特斯范围监听();
}

function on莫特斯范围触发(this: void): void {
  if (莫特斯运行状态.莫特斯对白已触发
    || 莫特斯运行状态.莫特斯战斗已启动
    || 莫特斯运行状态.莫特斯已经死亡
    || !单位存活(莫特斯运行状态.莫特斯单位)) return;

  const 触发英雄 = GetTriggerUnit();
  if (!是莫特斯副本玩家英雄(触发英雄)) return;

  莫特斯运行状态.莫特斯对白已触发 = true;
  莫特斯运行状态.当前入口英雄 = 触发英雄;
  注销莫特斯范围监听();
  IssueImmediateOrder(莫特斯运行状态.莫特斯单位, "stop");
  SetUnitFacing(
    莫特斯运行状态.莫特斯单位,
    YDWEAngleBetweenUnitsSafe(莫特斯运行状态.莫特斯单位, 触发英雄),
  );
  SetUnitFacing(
    触发英雄,
    YDWEAngleBetweenUnitsSafe(触发英雄, 莫特斯运行状态.莫特斯单位),
  );
  播放莫特斯第一段对白();
}

function 注册莫特斯范围监听(this: void): void {
  if (!单位存活(莫特斯运行状态.莫特斯单位)
    || 句柄有效(莫特斯运行状态.莫特斯范围触发器)
    || 莫特斯运行状态.莫特斯战斗已启动
    || 莫特斯运行状态.莫特斯已经死亡) return;

  const 触发器 = CreateTrigger();
  if (!句柄有效(触发器)) return;
  if (safeTriggerAddAction(触发器, on莫特斯范围触发) == null) {
    safeDestroyTrigger(触发器);
    return;
  }

  莫特斯运行状态.莫特斯范围触发器 = 触发器;
  莫特斯运行状态.取消莫特斯范围监听 = registerUnitInRangeTrigger(
    触发器,
    莫特斯运行状态.莫特斯单位,
    莫特斯Boss触发范围,
    null,
    false,
  );
}

export function 确保创建莫特斯(this: void): void {
  if (莫特斯运行状态.莫特斯已经死亡 || 单位存活(莫特斯运行状态.莫特斯单位)) return;

  const Boss单位 = 创建剧情NPC单位({
    单位ID: 莫特斯Boss单位ID,
    X: 莫特斯Boss出生X,
    Y: 莫特斯Boss出生Y,
    朝向: 莫特斯Boss出生面向,
    玩家ID: 15,
    初始化无敌: true,
    登记死亡排泄: true,
  });
  if (!句柄有效(Boss单位)) {
    debugLogForce(莫特斯模块名, "莫特斯创建失败", "unitId=", 莫特斯Boss单位ID);
    return;
  }

  莫特斯运行状态.莫特斯单位 = Boss单位;
  IssueImmediateOrder(Boss单位, "stop");
  SetUnitInvulnerable(Boss单位, true);
  添加单位暂停(Boss单位, 剧情Boss预置暂停来源);
  YDUserDataSetSafe("string", "Boss", 莫特斯Boss表键, "unit", Boss单位);
  注册莫特斯范围监听();
  if (!莫特斯运行状态.莫特斯死亡监听已注册) {
    registerDeathListener(on莫特斯死亡);
    莫特斯运行状态.莫特斯死亡监听已注册 = true;
  }
}

export function 读取当前莫特斯单位(this: void): any {
  return 莫特斯运行状态.莫特斯单位;
}
