/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const globals = require("jass.globals") as { gg_unit_Hamg_0002?: any; udg_Boss?: any; [key: string]: any };

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { SelectUnitForPlayerSingle } = require("lib.扩展函数.BJ函数.index") as {
  SelectUnitForPlayerSingle: (this: void, unit: any, player: any) => void;
};
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};
const { 记录Boss自动技能启动 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  记录Boss自动技能启动: (this: void, unit: any, source: any) => any;
};
const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用") as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { 标记测试Boss跳过死亡结算 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  标记测试Boss跳过死亡结算: (this: void, boss: any) => void;
};

const { 获取或创建菲利斯上下文 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.01．运行时上下文") as {
  获取或创建菲利斯上下文: (this: void, boss: any) => any;
};
const { 注册菲利斯被动效果 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.10．被动效果") as {
  注册菲利斯被动效果: (this: void) => void;
};
const { 释放菲利斯剑魂杀 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.04．剑魂杀") as {
  释放菲利斯剑魂杀: (this: void, context: any) => void;
};
const { 释放菲利斯剑气灵斩 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.05．剑气灵斩") as {
  释放菲利斯剑气灵斩: (this: void, context: any) => void;
};
const { 释放菲利斯全力封印斩 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.06．全力封印斩") as {
  释放菲利斯全力封印斩: (this: void, context: any) => void;
};
const { 释放菲利斯异形化 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.07．异形化") as {
  释放菲利斯异形化: (this: void, context: any) => void;
};

const { 获取或创建里科特上下文 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.01．运行时上下文") as {
  获取或创建里科特上下文: (this: void, boss: any) => any;
};
const { 注册里科特被动效果 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.12．被动效果") as {
  注册里科特被动效果: (this: void) => void;
};
const { 释放里科特四重风刃 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.04．四重风刃") as {
  释放里科特四重风刃: (this: void, context: any) => void;
};
const { 释放里科特追击风刃 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.05．追击风刃") as {
  释放里科特追击风刃: (this: void, context: any) => void;
};
const { 释放里科特湮灭之炮 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.07．湮灭之炮") as {
  释放里科特湮灭之炮: (this: void, context: any) => void;
};
const { 释放里科特湮灭之风 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.08．湮灭之风") as {
  释放里科特湮灭之风: (this: void, context: any) => void;
};
const { 释放里科特破魔反击 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.09．破魔反击") as {
  释放里科特破魔反击: (this: void, context: any) => void;
};

const { 获取或创建卡瑟拉上下文 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.01．运行时上下文") as {
  获取或创建卡瑟拉上下文: (this: void, boss: any) => any;
};
const { 注册卡瑟拉被动效果 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.13．被动效果") as {
  注册卡瑟拉被动效果: (this: void) => void;
};
const { 释放卡瑟拉深渊召唤 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.06．深渊召唤") as {
  释放卡瑟拉深渊召唤: (this: void, context: any) => void;
};
const { 释放卡瑟拉深海涡流 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.03．深海涡流") as {
  释放卡瑟拉深海涡流: (this: void, context: any) => void;
};
const { 释放卡瑟拉触手鞭笞 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.04．触手鞭笞") as {
  释放卡瑟拉触手鞭笞: (this: void, context: any) => void;
};
const { 释放卡瑟拉墨汁喷吐 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.05．墨汁喷吐") as {
  释放卡瑟拉墨汁喷吐: (this: void, context: any) => void;
};
const { 释放卡瑟拉高压水炮 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.07．高压水炮") as {
  释放卡瑟拉高压水炮: (this: void, context: any) => void;
};
const { 触发卡瑟拉触手解放 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.08．触手解放") as {
  触发卡瑟拉触手解放: (this: void, context: any) => void;
};
const { 释放卡瑟拉共生电击 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.09．共生电击") as {
  释放卡瑟拉共生电击: (this: void, context: any) => boolean;
};

const { 获取或创建莫尔特斯上下文 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.01．运行时上下文") as {
  获取或创建莫尔特斯上下文: (this: void, boss: any) => any;
};
const { 注册莫尔特斯被动效果 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.15．被动效果") as {
  注册莫尔特斯被动效果: (this: void) => void;
};
const { 释放莫尔特斯腐朽根须穿刺 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.04．腐朽根须穿刺") as {
  释放莫尔特斯腐朽根须穿刺: (this: void, context: any) => void;
};
const { 释放莫尔特斯腐败孢子云 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.05．腐败孢子云") as {
  释放莫尔特斯腐败孢子云: (this: void, context: any) => void;
};
const { 释放莫尔特斯扭曲荆棘鞭笞 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.06．扭曲荆棘鞭笞") as {
  释放莫尔特斯扭曲荆棘鞭笞: (this: void, context: any) => void;
};
const { 释放莫尔特斯腐败之种 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.07．腐败之种") as {
  释放莫尔特斯腐败之种: (this: void, context: any) => void;
};
const { 触发莫尔特斯根系觉醒 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.08．根系觉醒") as {
  触发莫尔特斯根系觉醒: (this: void, context: any) => void;
};
const { 触发莫尔特斯腐朽领域 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.09．腐朽领域") as {
  触发莫尔特斯腐朽领域: (this: void, context: any) => void;
};
const { 释放莫尔特斯共生腐朽虫群 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.10．共生腐朽虫群") as {
  释放莫尔特斯共生腐朽虫群: (this: void, context: any) => boolean;
};
const { 释放莫尔特斯古木悲鸣 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.11．古木悲鸣") as {
  释放莫尔特斯古木悲鸣: (this: void, context: any) => void;
};

const { 获取或创建影骨莫特斯上下文 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.01．运行时上下文") as {
  获取或创建影骨莫特斯上下文: (this: void, boss: any) => any;
};
const { 注册影骨莫特斯被动效果 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.10．被动效果") as {
  注册影骨莫特斯被动效果: (this: void) => void;
};
const { 释放影骨暗影禁锢 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.05．暗影禁锢") as {
  释放影骨暗影禁锢: (this: void, context: any, target: any) => void;
};
const { 释放影骨阴影穿梭 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.03．阴影穿梭") as {
  释放影骨阴影穿梭: (this: void, context: any) => void;
};
const { 释放影骨骸骨召唤 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.04．骸骨召唤") as {
  释放影骨骸骨召唤: (this: void, context: any) => void;
};
const { 释放影骨幽影爆发 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.06．幽影爆发") as {
  释放影骨幽影爆发: (this: void, context: any) => void;
};
const { 释放影骨盗贼遗产 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.07．盗贼的遗产") as {
  释放影骨盗贼遗产: (this: void, context: any) => void;
};

const 中立敌对玩家ID = 12;
const 测试单位最大生命值 = 999999;
const 临时测试场地中心X = -540.6;
const 临时测试场地中心Y = -2495.2;
const 临时测试玩家Y = -3055.2;

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const Player = jass.Player as (id: number) => any;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facingAngle: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (player: any, x: number, y: number, duration: number, text: string) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const CreateGroup = jass.CreateGroup as () => any;
const DestroyGroup = jass.DestroyGroup as (whichGroup: any) => void;
const GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer as (whichGroup: any, whichPlayer: any, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (whichGroup: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (whichGroup: any, whichUnit: any) => void;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const SetUnitStateJapi = japi.SetUnitState as (unit: any, state: any, value: number) => void;

const 菲利斯测试Boss: Record<number, any> = {};
const 里科特测试Boss: Record<number, any> = {};
const 卡瑟拉测试Boss: Record<number, any> = {};
const 莫尔特斯测试Boss: Record<number, any> = {};
const 影骨测试Boss: Record<number, any> = {};

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 提示(this: void, player: any, bossName: string, text: string): void {
  DisplayTimedTextToPlayer(player, 0, 0, 8, "[" + bossName + "测试] " + text);
}

function 是有效存活英雄(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_HERO) === true && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 是有效存活单位(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 设置测试单位满血(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  SetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE, 测试单位最大生命值);
  SetUnitState(unit, UNIT_STATE_LIFE, 测试单位最大生命值);
}

function 获取玩家测试基准英雄(this: void, player: any): any {
  const presetArchmage = globals.gg_unit_Hamg_0002;
  if (是有效存活英雄(presetArchmage)) return presetArchmage;

  const registeredHero = getRegisteredPlayerHero(player);
  if (是有效存活英雄(registeredHero)) return registeredHero;

  const group = CreateGroup();
  GroupEnumUnitsOfPlayer(group, player, null);
  let result: any = null;
  let unit = FirstOfGroup(group);
  while (unit != null && unit !== 0) {
    GroupRemoveUnit(group, unit);
    if (是有效存活英雄(unit)) {
      result = unit;
      break;
    }
    unit = FirstOfGroup(group);
  }
  DestroyGroup(group);
  return result;
}

function 获取或创建测试Boss(this: void, player: any, cache: Record<number, any>, unitId: string, level: number): any {
  const pid = GetPlayerId(player);
  const cached = cache[pid];
  if (是有效存活单位(cached)) {
    SetUnitPosition(cached, 临时测试场地中心X, 临时测试场地中心Y);
    SetUnitFacing(cached, 270);
    设置测试单位满血(cached);
    标记测试Boss跳过死亡结算(cached);
    globals.udg_Boss = cached;
    return cached;
  }

  const boss = CreateUnit(Player(中立敌对玩家ID), stringToFourCC(unitId), 临时测试场地中心X, 临时测试场地中心Y, 270);
  if (boss != null && boss !== 0) {
    cache[pid] = boss;
    标记测试Boss跳过死亡结算(boss);
    SetHeroLevel(boss, level, false);
    设置测试单位满血(boss);
    globals.udg_Boss = boss;
  }
  return boss;
}

function 准备通用Boss测试场景(this: void, player: any, boss: any): void {
  const hero = 获取玩家测试基准英雄(player);
  if (hero != null && hero !== 0) {
    SetUnitPosition(hero, 临时测试场地中心X, 临时测试玩家Y);
    SetUnitFacing(hero, 90);
    设置测试单位满血(hero);
  }
  SelectUnitForPlayerSingle(boss, player);
  StarOther_PanCameraToTimedForPlayer(player, 临时测试场地中心X, 临时测试场地中心Y, 0.2);
}

function 启动Boss测试链路(this: void, boss: any): void {
  应用Boss战启动属性配置(boss);
  记录Boss自动技能启动(boss, "Boss战.单位");
}

function 创建菲利斯测试(this: void, player: any): any {
  const boss = 获取或创建测试Boss(player, 菲利斯测试Boss, "N05T", 38);
  if (!是有效存活单位(boss)) {
    提示(player, "菲利斯", "Boss 创建失败。");
    return undefined;
  }
  注册菲利斯被动效果();
  准备通用Boss测试场景(player, boss);
  启动Boss测试链路(boss);
  return 获取或创建菲利斯上下文(boss);
}

function 创建里科特测试(this: void, player: any): any {
  const boss = 获取或创建测试Boss(player, 里科特测试Boss, "N05U", 40);
  if (!是有效存活单位(boss)) {
    提示(player, "里科特", "Boss 创建失败。");
    return undefined;
  }
  注册里科特被动效果();
  准备通用Boss测试场景(player, boss);
  启动Boss测试链路(boss);
  return 获取或创建里科特上下文(boss);
}

function 创建卡瑟拉测试(this: void, player: any): any {
  const boss = 获取或创建测试Boss(player, 卡瑟拉测试Boss, "N05V", 42);
  if (!是有效存活单位(boss)) {
    提示(player, "卡瑟拉", "Boss 创建失败。");
    return undefined;
  }
  注册卡瑟拉被动效果();
  准备通用Boss测试场景(player, boss);
  启动Boss测试链路(boss);
  return 获取或创建卡瑟拉上下文(boss);
}

function 创建莫尔特斯测试(this: void, player: any): any {
  const boss = 获取或创建测试Boss(player, 莫尔特斯测试Boss, "N05W", 42);
  if (!是有效存活单位(boss)) {
    提示(player, "莫尔特斯", "Boss 创建失败。");
    return undefined;
  }
  注册莫尔特斯被动效果();
  准备通用Boss测试场景(player, boss);
  启动Boss测试链路(boss);
  return 获取或创建莫尔特斯上下文(boss);
}

function 创建影骨测试(this: void, player: any): any {
  const boss = 获取或创建测试Boss(player, 影骨测试Boss, "N01Y", 42);
  if (!是有效存活单位(boss)) {
    提示(player, "影骨莫特斯", "Boss 创建失败。");
    return undefined;
  }
  注册影骨莫特斯被动效果();
  准备通用Boss测试场景(player, boss);
  启动Boss测试链路(boss);
  return 获取或创建影骨莫特斯上下文(boss);
}

function on菲利斯测试命令(this: void, player: any): void {
  const context = 创建菲利斯测试(player);
  if (context == null) return;
  提示(player, "菲利斯", "已创建/复用测试场景，并启动 Boss 自动技能。flstest1剑魂杀 2剑气灵斩 3全力封印斩 4异形化。");
}

function on菲利斯技能1测试命令(this: void, player: any): void {
  const context = 创建菲利斯测试(player);
  if (context != null) {
    释放菲利斯剑魂杀(context);
    提示(player, "菲利斯", "已测试：剑魂杀。");
  }
}

function on菲利斯技能2测试命令(this: void, player: any): void {
  const context = 创建菲利斯测试(player);
  if (context != null) {
    释放菲利斯剑气灵斩(context);
    提示(player, "菲利斯", "已测试：剑气灵斩。");
  }
}

function on菲利斯技能3测试命令(this: void, player: any): void {
  const context = 创建菲利斯测试(player);
  if (context != null) {
    释放菲利斯全力封印斩(context);
    提示(player, "菲利斯", "已测试：全力封印斩。");
  }
}

function on菲利斯技能4测试命令(this: void, player: any): void {
  const context = 创建菲利斯测试(player);
  if (context != null) {
    释放菲利斯异形化(context);
    提示(player, "菲利斯", "已测试：异形化。");
  }
}

function on里科特测试命令(this: void, player: any): void {
  const context = 创建里科特测试(player);
  if (context == null) return;
  提示(player, "里科特", "已创建/复用测试场景，并启动 Boss 自动技能。rktest1四重风刃 2追击风刃 3湮灭之炮 4湮灭之风 5破魔反击。");
}

function on里科特技能1测试命令(this: void, player: any): void {
  const context = 创建里科特测试(player);
  if (context != null) {
    释放里科特四重风刃(context);
    提示(player, "里科特", "已测试：四重风刃。");
  }
}

function on里科特技能2测试命令(this: void, player: any): void {
  const context = 创建里科特测试(player);
  if (context != null) {
    释放里科特追击风刃(context);
    提示(player, "里科特", "已测试：追击风刃。");
  }
}

function on里科特技能3测试命令(this: void, player: any): void {
  const context = 创建里科特测试(player);
  if (context != null) {
    释放里科特湮灭之炮(context);
    提示(player, "里科特", "已测试：湮灭之炮。");
  }
}

function on里科特技能4测试命令(this: void, player: any): void {
  const context = 创建里科特测试(player);
  if (context != null) {
    释放里科特湮灭之风(context);
    提示(player, "里科特", "已测试：湮灭之风。");
  }
}

function on里科特技能5测试命令(this: void, player: any): void {
  const context = 创建里科特测试(player);
  if (context != null) {
    释放里科特破魔反击(context);
    提示(player, "里科特", "已测试：破魔反击。");
  }
}

function on卡瑟拉测试命令(this: void, player: any): void {
  const context = 创建卡瑟拉测试(player);
  if (context == null) return;
  提示(player, "卡瑟拉", "已创建/复用测试场景，并启动 Boss 自动技能。ksltest1深海涡流 2触手鞭笞 3墨汁喷吐 4深渊召唤 5高压水炮 6触手解放 7共生电击。");
}

function on卡瑟拉技能1测试命令(this: void, player: any): void {
  const context = 创建卡瑟拉测试(player);
  if (context != null) {
    释放卡瑟拉深海涡流(context);
    提示(player, "卡瑟拉", "已测试：深海涡流。");
  }
}

function on卡瑟拉技能2测试命令(this: void, player: any): void {
  const context = 创建卡瑟拉测试(player);
  if (context != null) {
    释放卡瑟拉触手鞭笞(context);
    提示(player, "卡瑟拉", "已测试：触手鞭笞。");
  }
}

function on卡瑟拉技能3测试命令(this: void, player: any): void {
  const context = 创建卡瑟拉测试(player);
  if (context != null) {
    释放卡瑟拉墨汁喷吐(context);
    提示(player, "卡瑟拉", "已测试：墨汁喷吐。");
  }
}

function on卡瑟拉技能4测试命令(this: void, player: any): void {
  const context = 创建卡瑟拉测试(player);
  if (context != null) {
    释放卡瑟拉深渊召唤(context);
    提示(player, "卡瑟拉", "已测试：深渊召唤。");
  }
}

function on卡瑟拉技能5测试命令(this: void, player: any): void {
  const context = 创建卡瑟拉测试(player);
  if (context != null) {
    释放卡瑟拉高压水炮(context);
    提示(player, "卡瑟拉", "已测试：高压水炮。");
  }
}

function on卡瑟拉技能6测试命令(this: void, player: any): void {
  const context = 创建卡瑟拉测试(player);
  if (context != null) {
    触发卡瑟拉触手解放(context);
    提示(player, "卡瑟拉", "已测试：触手解放。");
  }
}

function on卡瑟拉技能7测试命令(this: void, player: any): void {
  const context = 创建卡瑟拉测试(player);
  if (context != null) {
    释放卡瑟拉共生电击(context);
    提示(player, "卡瑟拉", "已测试：共生电击。");
  }
}

function on莫尔特斯测试命令(this: void, player: any): void {
  const context = 创建莫尔特斯测试(player);
  if (context == null) return;
  提示(player, "莫尔特斯", "已创建/复用测试场景，并启动 Boss 自动技能。mltstest1根须穿刺 2孢子云 3荆棘鞭笞 4腐败之种 5根系觉醒 6腐朽领域 7腐朽虫群 8古木悲鸣。");
}

function on莫尔特斯技能1测试命令(this: void, player: any): void {
  const context = 创建莫尔特斯测试(player);
  if (context != null) {
    释放莫尔特斯腐朽根须穿刺(context);
    提示(player, "莫尔特斯", "已测试：腐朽根须穿刺。");
  }
}

function on莫尔特斯技能2测试命令(this: void, player: any): void {
  const context = 创建莫尔特斯测试(player);
  if (context != null) {
    释放莫尔特斯腐败孢子云(context);
    提示(player, "莫尔特斯", "已测试：腐败孢子云。");
  }
}

function on莫尔特斯技能3测试命令(this: void, player: any): void {
  const context = 创建莫尔特斯测试(player);
  if (context != null) {
    释放莫尔特斯扭曲荆棘鞭笞(context);
    提示(player, "莫尔特斯", "已测试：扭曲荆棘鞭笞。");
  }
}

function on莫尔特斯技能4测试命令(this: void, player: any): void {
  const context = 创建莫尔特斯测试(player);
  if (context != null) {
    释放莫尔特斯腐败之种(context);
    提示(player, "莫尔特斯", "已测试：腐败之种。");
  }
}

function on莫尔特斯技能5测试命令(this: void, player: any): void {
  const context = 创建莫尔特斯测试(player);
  if (context != null) {
    触发莫尔特斯根系觉醒(context);
    提示(player, "莫尔特斯", "已测试：根系觉醒。");
  }
}

function on莫尔特斯技能6测试命令(this: void, player: any): void {
  const context = 创建莫尔特斯测试(player);
  if (context != null) {
    触发莫尔特斯腐朽领域(context);
    提示(player, "莫尔特斯", "已测试：腐朽领域。");
  }
}

function on莫尔特斯技能7测试命令(this: void, player: any): void {
  const context = 创建莫尔特斯测试(player);
  if (context != null) {
    释放莫尔特斯共生腐朽虫群(context);
    提示(player, "莫尔特斯", "已测试：共生腐朽虫群。");
  }
}

function on莫尔特斯技能8测试命令(this: void, player: any): void {
  const context = 创建莫尔特斯测试(player);
  if (context != null) {
    释放莫尔特斯古木悲鸣(context);
    提示(player, "莫尔特斯", "已测试：古木悲鸣。");
  }
}

function on影骨测试命令(this: void, player: any): void {
  const context = 创建影骨测试(player);
  if (context == null) return;
  提示(player, "影骨莫特斯", "已创建/复用测试场景，并启动 Boss 自动技能。ygtest1阴影穿梭 2骸骨召唤 3暗影禁锢 4幽影爆发 5盗贼的遗产。");
}

function on影骨技能1测试命令(this: void, player: any): void {
  const context = 创建影骨测试(player);
  if (context != null) {
    释放影骨阴影穿梭(context);
    提示(player, "影骨莫特斯", "已测试：阴影穿梭。");
  }
}

function on影骨技能2测试命令(this: void, player: any): void {
  const context = 创建影骨测试(player);
  if (context != null) {
    释放影骨骸骨召唤(context);
    提示(player, "影骨莫特斯", "已测试：骸骨召唤。");
  }
}

function on影骨技能3测试命令(this: void, player: any): void {
  const context = 创建影骨测试(player);
  const hero = 获取玩家测试基准英雄(player);
  if (context != null && 是有效存活英雄(hero)) {
    释放影骨暗影禁锢(context, hero);
    提示(player, "影骨莫特斯", "已测试：暗影禁锢。");
  }
}

function on影骨技能4测试命令(this: void, player: any): void {
  const context = 创建影骨测试(player);
  if (context != null) {
    释放影骨幽影爆发(context);
    提示(player, "影骨莫特斯", "已测试：幽影爆发。");
  }
}

function on影骨技能5测试命令(this: void, player: any): void {
  const context = 创建影骨测试(player);
  if (context != null) {
    释放影骨盗贼遗产(context);
    提示(player, "影骨莫特斯", "已测试：盗贼的遗产。");
  }
}

注册聊天命令监听("flstest", on菲利斯测试命令);
注册聊天命令监听("flstest1", on菲利斯技能1测试命令);
注册聊天命令监听("flstest2", on菲利斯技能2测试命令);
注册聊天命令监听("flstest3", on菲利斯技能3测试命令);
注册聊天命令监听("flstest4", on菲利斯技能4测试命令);

注册聊天命令监听("rktest", on里科特测试命令);
注册聊天命令监听("rktest1", on里科特技能1测试命令);
注册聊天命令监听("rktest2", on里科特技能2测试命令);
注册聊天命令监听("rktest3", on里科特技能3测试命令);
注册聊天命令监听("rktest4", on里科特技能4测试命令);
注册聊天命令监听("rktest5", on里科特技能5测试命令);

注册聊天命令监听("ksltest", on卡瑟拉测试命令);
注册聊天命令监听("ksltest1", on卡瑟拉技能1测试命令);
注册聊天命令监听("ksltest2", on卡瑟拉技能2测试命令);
注册聊天命令监听("ksltest3", on卡瑟拉技能3测试命令);
注册聊天命令监听("ksltest4", on卡瑟拉技能4测试命令);
注册聊天命令监听("ksltest5", on卡瑟拉技能5测试命令);
注册聊天命令监听("ksltest6", on卡瑟拉技能6测试命令);
注册聊天命令监听("ksltest7", on卡瑟拉技能7测试命令);

注册聊天命令监听("mltstest", on莫尔特斯测试命令);
注册聊天命令监听("mltstest1", on莫尔特斯技能1测试命令);
注册聊天命令监听("mltstest2", on莫尔特斯技能2测试命令);
注册聊天命令监听("mltstest3", on莫尔特斯技能3测试命令);
注册聊天命令监听("mltstest4", on莫尔特斯技能4测试命令);
注册聊天命令监听("mltstest5", on莫尔特斯技能5测试命令);
注册聊天命令监听("mltstest6", on莫尔特斯技能6测试命令);
注册聊天命令监听("mltstest7", on莫尔特斯技能7测试命令);
注册聊天命令监听("mltstest8", on莫尔特斯技能8测试命令);

注册聊天命令监听("ygtest", on影骨测试命令);
注册聊天命令监听("ygtest1", on影骨技能1测试命令);
注册聊天命令监听("ygtest2", on影骨技能2测试命令);
注册聊天命令监听("ygtest3", on影骨技能3测试命令);
注册聊天命令监听("ygtest4", on影骨技能4测试命令);
注册聊天命令监听("ygtest5", on影骨技能5测试命令);

export {};
