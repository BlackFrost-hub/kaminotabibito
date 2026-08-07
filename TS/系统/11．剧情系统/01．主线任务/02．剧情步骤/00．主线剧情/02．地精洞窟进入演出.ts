/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { CinematicFilterGenericBJ } = require("lib.扩展函数.BJ函数.05A．电影函数") as {
  CinematicFilterGenericBJ: (
    this: void,
    duration: number,
    bmode: any,
    tex: string,
    red0: number,
    green0: number,
    blue0: number,
    trans0: number,
    red1: number,
    green1: number,
    blue1: number,
    trans1: number,
  ) => void;
};
const { SetTimeOfDay } = require("lib.扩展函数.BJ函数.07．杂项") as {
  SetTimeOfDay: (this: void, whatTime: number) => void;
};
const { TriggerRegisterEnterRectSimple } = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterEnterRectSimple: (this: void, trig: any, r: any) => any;
};
const { 切换区域背景音乐表达式 } = require("系统.07．地形系统.07．区域背景音乐.04．区域背景音乐运行时") as {
  切换区域背景音乐表达式: (this: void, expr: string | undefined, add: boolean) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { PlaySoundBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundBJ: (this: void, soundHandle: any) => void;
};
const { 进入剧情电影模式, 退出剧情电影模式并恢复镜头 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.12．剧情电影镜头") as {
  进入剧情电影模式: (this: void) => void;
  退出剧情电影模式并恢复镜头: (this: void) => void;
};
const { 添加单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, 来源: string) => boolean;
};
const { 注册剧情片段清理 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表") as {
  注册剧情片段清理: (this: void, 片段ID: string, 清理函数: (this: void) => void) => void;
};
const { 注册剧情运行时单位, 读取剧情运行时单位, 清理剧情运行时单位 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位") as {
  注册剧情运行时单位: (this: void, 语义名: string, unit: any) => void;
  读取剧情运行时单位: (this: void, 语义名: string) => any;
  清理剧情运行时单位: (this: void, 语义名: string) => void;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import {
  应用剧情电影镜头,
  type 剧情镜头预设参数,
} from "../../00．剧情系统核心工具/12．剧情电影镜头";

type 播放主线剧情片段函数 = (this: void, 片段ID: string, 上下文?: any) => boolean;
let 播放主线剧情片段实现: 播放主线剧情片段函数 | undefined;

function 播放主线剧情片段(this: void, 片段ID: string, 上下文?: any): boolean {
  if (播放主线剧情片段实现 == null) {
    const 播放器模块 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
      播放主线剧情片段: 播放主线剧情片段函数;
    };
    播放主线剧情片段实现 = 播放器模块.播放主线剧情片段;
  }
  return 播放主线剧情片段实现(片段ID, 上下文);
}

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, action: (this: void) => void) => any;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, whichUnit: any, animationIndex: number) => void;
const KillUnit = jass.KillUnit as (this: void, whichUnit: any) => void;
const IssuePointOrder = jass.IssuePointOrder as (this: void, whichUnit: any, order: string, x: number, y: number) => boolean;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const DisplayCineFilter = jass.DisplayCineFilter as (this: void, flag: boolean) => void;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const 剧情Boss预置暂停来源 = "剧情系统:Boss预置";

let 已初始化进度02核心 = false;
let 已触发地精洞窟演出 = false;
let 地精洞窟演出音乐已启动 = false;
let 地精洞窟祭坛演出已开始 = false;
const 地精洞窟临时单位键前缀 = "剧情运行时.地精洞窟演出.";
const 地精洞窟镜头预设: 剧情镜头预设参数 = {
  X: -25967.140625,
  Y: -13941.830078,
  高度偏移: 0,
  旋转角度: 90,
  攻角: 335,
  距离到目标: 2523.080078,
  滚动角度: 0,
  观察区域: 25,
  远景剪裁: 3800,
};

function 有效单位(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 切换地精洞窟区域音乐(this: void, add: boolean, soundName: string, rectName: string): boolean {
  return 切换区域背景音乐表达式(`${soundName} @ ${rectName}`, add) > 0;
}

function 开始地精洞窟演出音乐(this: void): void {
  地精洞窟演出音乐已启动 = 切换地精洞窟区域音乐(true, "gg_snd_JQBGM01", "gg_rct______________102");
}

function 停止地精洞窟演出音乐(this: void): void {
  if (!地精洞窟演出音乐已启动) return;
  切换地精洞窟区域音乐(false, "gg_snd_JQBGM01", "gg_rct______________102");
  地精洞窟演出音乐已启动 = false;
}

function 结束地精洞窟演出音乐(this: void): void {
  停止地精洞窟演出音乐();
  // 源 JASS 在正常结束和跳过分支后都会切回默认区域音乐。
  切换地精洞窟区域音乐(true, "gg_snd_BGM002", "gg_rct______________025");
}

function 创建地精洞窟临时单位(this: void, rawId: string, x: number, y: number, facing: number, key: string): any {
  const unitTypeId = Number((require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
    stringToFourCCSafe: (this: void, s: string) => number;
  }).stringToFourCCSafe(rawId));
  if (!(unitTypeId > 0)) return null;
  const unit = 创建单位并登记排泄安全(Player(PLAYER_NEUTRAL_AGGRESSIVE), unitTypeId, x, y, facing);
  if (有效单位(unit)) 注册剧情运行时单位(`${地精洞窟临时单位键前缀}${key}`, unit);
  return unit;
}

function 移除地精洞窟临时单位(this: void, key: string): void {
  const unit = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}${key}`);
  if (有效单位(unit)) 立即移除单位并取消排泄登记(unit);
  清理剧情运行时单位(`${地精洞窟临时单位键前缀}${key}`);
}

function 播放地精洞窟仪式音效(this: void): void {
  const soundHandle = jglobals.gg_snd_GWSY0101;
  if (soundHandle != null && soundHandle !== 0) PlaySoundBJ(soundHandle);
}

function 清理地精洞窟演出(this: void): void {
  DisplayCineFilter(false);
  停止地精洞窟演出音乐();
  地精洞窟祭坛演出已开始 = false;
  for (let i = 1; i <= 8; i++) {
    const unit = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}${i}`);
    if (有效单位(unit)) 立即移除单位并取消排泄登记(unit);
    清理剧情运行时单位(`${地精洞窟临时单位键前缀}${i}`);
  }
  const 魔法核心 = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}100`);
  if (有效单位(魔法核心)) 立即移除单位并取消排泄登记(魔法核心);
  清理剧情运行时单位(`${地精洞窟临时单位键前缀}100`);
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 != null && 玩家英雄组 !== 0) {
    const { ForGroupBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
      ForGroupBJ: (this: void, whichGroup: any, callback: (this: void) => void) => void;
    };
    ForGroupBJ(玩家英雄组, () => {
      const unit = jass.GetEnumUnit();
      if (unit == null || unit === 0) return;
      PauseUnit(unit, false);
      SetUnitInvulnerable(unit, false);
    });
  }
  退出剧情电影模式并恢复镜头();
}

function on地精洞窟进入触发(this: void): void {
  if (已触发地精洞窟演出) return;
  const 触发单位 = GetTriggerUnit();
  if (!是玩家英雄组单位(触发单位)) return;
  if (读取剧情进度() !== 1) return;

  const 片段ID = "jlc_goblin_cave_intro";
  if (播放主线剧情片段(片段ID, { 片段ID, 触发配置名: "地精洞窟进入演出核心", 触发单位 })) {
    已触发地精洞窟演出 = true;
  }
}

export function 执行地精洞窟演出前置(this: void, 参数: 剧情动作参数表): void {
  SetTimeOfDay(0);
  清理地精洞窟演出();
  进入剧情电影模式();
  CinematicFilterGenericBJ(2, 1, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 50, 50, 50, 50, 0, 0, 0, 0);
}

export function 执行地精洞窟祭坛演出开始(this: void): void {
  if (地精洞窟祭坛演出已开始) return;
  地精洞窟祭坛演出已开始 = true;

  // 源 JASS：首句黑场对白结束后，先关闭滤镜，再播放 BGM、创建演员并应用祭坛镜头。
  DisplayCineFilter(false);
  开始地精洞窟演出音乐();

  创建地精洞窟临时单位("n009", -26266.8, -14055.6, 45, "1");
  创建地精洞窟临时单位("n009", -25716.8, -14086.2, 135, "2");
  创建地精洞窟临时单位("n008", -26276.1, -13945.2, 45, "3");
  创建地精洞窟临时单位("n008", -25713.5, -13958.6, 135, "4");
  创建地精洞窟临时单位("n01H", -25994.5, -13977.6, 90, "5");
  创建地精洞窟临时单位("nhef", -25909.9, -14001.3, 90, "6");

  // 直接使用 CameraSetup 005 的具体参数，避免依赖未导出的旧镜头接口。
  应用剧情电影镜头(地精洞窟镜头预设, 0);

  const bossUnit = 读取剧情运行时单位("Boss.地精巫师");
  if (有效单位(bossUnit)) {
    SetUnitInvulnerable(bossUnit, true);
    添加单位暂停(bossUnit, 剧情Boss预置暂停来源);
  }
}

/** 按源 JASS 的时间顺序执行祭坛演员动作；阶段动作在跳过剧情时也会顺序消费。 */
export function 执行地精洞窟演员动作(this: void, 参数: 剧情动作参数表): void {
  const 阶段 = Number(参数.阶段) || 0;
  const bossUnit = 读取剧情运行时单位("Boss.地精巫师");

  if (阶段 === 1) {
    if (有效单位(bossUnit)) SetUnitAnimationByIndex(bossUnit, 4);
    if (!有效单位(读取剧情运行时单位(`${地精洞窟临时单位键前缀}100`))) {
      创建地精洞窟临时单位("e00U", -25959.4, -14091, 90, "100");
    }
    const 演员5 = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}5`);
    const 演员6 = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}6`);
    if (有效单位(演员5)) KillUnit(演员5);
    if (有效单位(演员6)) KillUnit(演员6);
    return;
  }

  if (阶段 === 2) {
    const 演员1 = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}1`);
    const 演员2 = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}2`);
    if (有效单位(演员1)) IssuePointOrder(演员1, "move", -25909.9, -14001.3);
    if (有效单位(演员2)) IssuePointOrder(演员2, "move", -25994.5, -13977.6);
    return;
  }

  if (阶段 === 3) {
    移除地精洞窟临时单位("1");
    移除地精洞窟临时单位("2");
    创建地精洞窟临时单位("n008", -25909.9, -14001.3, 90, "7");
    创建地精洞窟临时单位("n008", -25994.5, -13977.6, 90, "8");
    EC_CreateEffect(
      "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl",
      -25959.4,
      -14091,
      0,
      270,
      2,
      1,
      2,
    );
    播放地精洞窟仪式音效();
    return;
  }

  if (阶段 === 4) {
    const 演员3 = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}3`);
    const 演员4 = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}4`);
    const 演员7 = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}7`);
    const 演员8 = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}8`);
    if (有效单位(演员3)) SetUnitAnimationByIndex(演员3, 1);
    if (有效单位(演员4)) SetUnitAnimationByIndex(演员4, 1);
    if (有效单位(演员7)) SetUnitAnimationByIndex(演员7, 1);
    if (有效单位(演员8)) SetUnitAnimationByIndex(演员8, 1);
    if (有效单位(bossUnit)) {
      SetUnitFacing(bossUnit, 90);
      SetUnitAnimationByIndex(bossUnit, 4);
    }
    return;
  }

  if (阶段 === 5) {
    播放地精洞窟仪式音效();
    const 演员3 = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}3`);
    const 演员4 = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}4`);
    const 演员7 = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}7`);
    const 演员8 = 读取剧情运行时单位(`${地精洞窟临时单位键前缀}8`);
    if (有效单位(演员3)) SetUnitAnimationByIndex(演员3, 1);
    if (有效单位(演员4)) SetUnitAnimationByIndex(演员4, 1);
    if (有效单位(演员7)) SetUnitAnimationByIndex(演员7, 1);
    if (有效单位(演员8)) SetUnitAnimationByIndex(演员8, 1);
    return;
  }

  if (阶段 === 6) {
    CinematicFilterGenericBJ(2, 1, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 50, 50, 50, 50, 0, 0, 0, 0);
  }
}

export function 执行地精洞窟演出收尾(this: void): void {
  DisplayCineFilter(false);
  结束地精洞窟演出音乐();
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 != null && 玩家英雄组 !== 0) {
    const { ForGroupBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
      ForGroupBJ: (this: void, whichGroup: any, callback: (this: void) => void) => void;
    };
    ForGroupBJ(玩家英雄组, () => {
      const unit = jass.GetEnumUnit();
      if (unit == null || unit === 0) return;
      SetUnitInvulnerable(unit, false);
      PauseUnit(unit, false);
    });
  }
  退出剧情电影模式并恢复镜头();
}

export const 地精洞窟进入演出剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵村_地精洞窟演出前置": 执行地精洞窟演出前置,
  "JLC精灵村_地精洞窟祭坛演出开始": 执行地精洞窟祭坛演出开始,
  "JLC精灵村_地精洞窟演员动作": 执行地精洞窟演员动作,
  "JLC精灵村_地精洞窟演出收尾": 执行地精洞窟演出收尾,
};

注册剧情片段清理("jlc_goblin_cave_intro", 清理地精洞窟演出);

export function 初始化进度02_地精洞窟进入演出核心(this: void): void {
  if (已初始化进度02核心) return;
  已初始化进度02核心 = true;

  const rect = jglobals.gg_rct______________020;
  if (rect == null || rect === 0) return;
  const trigger = CreateTrigger();
  TriggerRegisterEnterRectSimple(trigger, rect);
  TriggerAddAction(trigger, on地精洞窟进入触发);
}
