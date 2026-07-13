/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const globals = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

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
  记录Boss自动技能启动: (this: void, unit: any, source: "STES.Boss" | "Boss战.单位" | "Boss战.绑定单位") => any;
};
const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用") as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { 获取或创建巴尔扎罗斯上下文, 注册巴尔扎罗斯运行时 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.03．运行时上下文") as {
  获取或创建巴尔扎罗斯上下文: (this: void, boss: any) => any;
  注册巴尔扎罗斯运行时: (this: void) => void;
};
const { 注册巴尔扎罗斯技能结构 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.15．技能入口") as {
  注册巴尔扎罗斯技能结构: (this: void) => void;
};
const { 初始化巴尔扎罗斯熔核封印与护卫机制 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.04．熔核封印与护卫机制") as {
  初始化巴尔扎罗斯熔核封印与护卫机制: (this: void, context: any) => void;
};
const { 初始化巴尔扎罗斯格鲁姆技能 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.index") as {
  初始化巴尔扎罗斯格鲁姆技能: (this: void, context: any) => void;
};
const { 初始化巴尔扎罗斯塞拉技能 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.index") as {
  初始化巴尔扎罗斯塞拉技能: (this: void, context: any) => void;
};
const { 初始化巴尔扎罗斯地核召唤节点, 释放巴尔扎罗斯地核召唤 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.11．地核召唤") as {
  初始化巴尔扎罗斯地核召唤节点: (this: void, context: any) => void;
  释放巴尔扎罗斯地核召唤: (this: void, context: any) => void;
};
const { 初始化巴尔扎罗斯熔岩护盾节点 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.12．熔岩护盾") as {
  初始化巴尔扎罗斯熔岩护盾节点: (this: void, context: any) => void;
};
const { 初始化巴尔扎罗斯末日熔爆节点, 释放巴尔扎罗斯末日熔爆 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.13．末日熔爆") as {
  初始化巴尔扎罗斯末日熔爆节点: (this: void, context: any) => void;
  释放巴尔扎罗斯末日熔爆: (this: void, context: any) => void;
};
const { 释放巴尔扎罗斯恶魔咆哮波 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.07．恶魔咆哮波") as {
  释放巴尔扎罗斯恶魔咆哮波: (this: void, context: any) => void;
};
const { 释放巴尔扎罗斯王者天罚 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.08．王者天罚") as {
  释放巴尔扎罗斯王者天罚: (this: void, context: any) => void;
};
const { 释放巴尔扎罗斯熔岩喷发 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.09．熔岩喷发") as {
  释放巴尔扎罗斯熔岩喷发: (this: void, context: any) => void;
};
const { 释放巴尔扎罗斯火焰锁链 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.10．火焰锁链") as {
  释放巴尔扎罗斯火焰锁链: (this: void, context: any) => void;
};
const { 释放格鲁姆重锤, 释放格鲁姆火径 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.index") as {
  释放格鲁姆重锤: (this: void, context: any, target: any) => void;
  释放格鲁姆火径: (this: void, context: any, target: any) => void;
};
const { 释放冰焰双星, 释放绝对零度领域, 切换塞拉形态 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.index") as {
  释放冰焰双星: (this: void, context: any, target: any) => void;
  释放绝对零度领域: (this: void, context: any, target: any) => void;
  切换塞拉形态: (this: void, context: any, next: "火焰" | "冰霜", 播放台词: boolean) => void;
};
const { 巴尔扎罗斯战斗区域配置, 巴尔扎罗斯固定安全区配置表 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．场地配置") as {
  巴尔扎罗斯战斗区域配置: any;
  巴尔扎罗斯固定安全区配置表: any[];
};
const { 巴尔扎罗斯护卫配置 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．数值与表现配置") as {
  巴尔扎罗斯护卫配置: any;
};
const { 创建动态矩形区域组, 销毁动态矩形区域组 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.02．战斗区域.index") as {
  创建动态矩形区域组: (this: void, 名称: string, 配置列表: any[]) => any;
  销毁动态矩形区域组: (this: void, 区域组: any) => void;
};
const { 创建测试中心平移映射, 按测试映射平移矩形, 复制平移测试矩形数组, 标记测试Boss跳过死亡结算 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  创建测试中心平移映射: (this: void, 正式中心X: number, 正式中心Y: number, 测试中心X: number, 测试中心Y: number) => any;
  按测试映射平移矩形: (this: void, 矩形: any, 映射: any) => any;
  复制平移测试矩形数组: (this: void, 矩形列表: any[], 映射: any) => any[];
  标记测试Boss跳过死亡结算: (this: void, boss: any) => void;
};

const 测试命令 = "bztest";
const 巴尔扎罗斯单位ID = stringToFourCC("N03G");
const 测试步兵单位ID = stringToFourCC("hfoo");
const 中立敌对玩家ID = 12;
const 测试单位最大生命值 = 999999;
// 只给 bztest 使用的临时测试场地；不影响正式 Boss 战场地配置。
const 临时测试场地中心X = -540.6;
const 临时测试场地中心Y = -2495.2;
const 临时测试玩家X = -540.6;
const 临时测试玩家Y = -3055.2;
const 测试命令说明 = "bztest1恶魔咆哮波 2王者天罚 3熔岩喷发 4火焰锁链 5地核召唤 6末日熔爆 7格鲁姆重锤 8格鲁姆火径 9塞拉冰焰双星 10塞拉绝对零度 11塞拉切火 12塞拉切冰。";

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const Player = jass.Player as (id: number) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
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

const 最近测试Boss: Record<number, any> = {};
const 最近测试步兵1: Record<number, any> = {};
const 最近测试步兵2: Record<number, any> = {};

function 应用巴尔扎罗斯测试场地(this: void, context: any): void {
  const 正式中心X = (巴尔扎罗斯战斗区域配置.左 + 巴尔扎罗斯战斗区域配置.右) / 2;
  const 正式中心Y = (巴尔扎罗斯战斗区域配置.下 + 巴尔扎罗斯战斗区域配置.上) / 2;
  const 映射 = 创建测试中心平移映射(正式中心X, 正式中心Y, 临时测试场地中心X, 临时测试场地中心Y);
  const 测试战斗区域 = 按测试映射平移矩形(巴尔扎罗斯战斗区域配置, 映射);
  销毁动态矩形区域组(context.战斗区域组);
  context.战斗区域组 = 创建动态矩形区域组("巴尔扎罗斯测试战斗区域", [测试战斗区域]);
  context.测试固定安全区配置表 = 复制平移测试矩形数组(巴尔扎罗斯固定安全区配置表, 映射);
}

function 取巴尔扎罗斯测试场地映射(this: void): any {
  const 正式中心X = (巴尔扎罗斯战斗区域配置.左 + 巴尔扎罗斯战斗区域配置.右) / 2;
  const 正式中心Y = (巴尔扎罗斯战斗区域配置.下 + 巴尔扎罗斯战斗区域配置.上) / 2;
  return 创建测试中心平移映射(正式中心X, 正式中心Y, 临时测试场地中心X, 临时测试场地中心Y);
}

function 放置巴尔扎罗斯测试护卫(this: void, context: any): void {
  const 映射 = 取巴尔扎罗斯测试场地映射();
  if (是有效存活单位(context.格鲁姆)) {
    SetUnitPosition(context.格鲁姆, 巴尔扎罗斯护卫配置.格鲁姆.X + 映射.偏移X, 巴尔扎罗斯护卫配置.格鲁姆.Y + 映射.偏移Y);
    SetUnitFacing(context.格鲁姆, 巴尔扎罗斯护卫配置.格鲁姆.面向);
    设置测试单位满血(context.格鲁姆);
  }
  if (是有效存活单位(context.塞拉)) {
    SetUnitPosition(context.塞拉, 巴尔扎罗斯护卫配置.塞拉.X + 映射.偏移X, 巴尔扎罗斯护卫配置.塞拉.Y + 映射.偏移Y);
    SetUnitFacing(context.塞拉, 巴尔扎罗斯护卫配置.塞拉.面向);
    设置测试单位满血(context.塞拉);
  }
}

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 提示(this: void, player: any, text: string): void {
  DisplayTimedTextToPlayer(player, 0, 0, 8, "[巴尔扎罗斯测试] " + text);
}

function 是有效存活英雄(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_HERO) === true && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 是有效存活单位(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 是当前玩家测试靶(this: void, unit: any, player: any): boolean {
  return 是有效存活单位(unit) && GetPlayerId(GetOwningPlayer(unit)) === GetPlayerId(player);
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

function 获取或创建测试Boss(this: void, player: any): any {
  const pid = GetPlayerId(player);
  const cached = 最近测试Boss[pid];
  if (是有效存活单位(cached)) {
    SetUnitPosition(cached, 临时测试场地中心X, 临时测试场地中心Y);
    SetUnitFacing(cached, 270);
    设置测试单位满血(cached);
    标记测试Boss跳过死亡结算(cached);
    return cached;
  }

  const boss = CreateUnit(Player(中立敌对玩家ID), 巴尔扎罗斯单位ID, 临时测试场地中心X, 临时测试场地中心Y, 270);
  if (boss != null && boss !== 0) {
    最近测试Boss[pid] = boss;
    标记测试Boss跳过死亡结算(boss);
    SetHeroLevel(boss, 40, false);
    设置测试单位满血(boss);
  }
  return boss;
}

function 获取或创建测试步兵(this: void, 缓存表: Record<number, any>, player: any, x: number, y: number): any {
  const pid = GetPlayerId(player);
  const cached = 缓存表[pid];
  if (是当前玩家测试靶(cached, player)) {
    SetUnitPosition(cached, x, y);
    设置测试单位满血(cached);
    return cached;
  }

  const unit = CreateUnit(player, 测试步兵单位ID, x, y, 180);
  if (unit != null && unit !== 0) {
    缓存表[pid] = unit;
    设置测试单位满血(unit);
  }
  return unit;
}

function 准备巴尔扎罗斯测试场景(this: void, player: any, hero: any, boss: any): any {
  SetUnitPosition(hero, 临时测试玩家X, 临时测试玩家Y);
  SetUnitFacing(hero, 90);
  设置测试单位满血(hero);
  获取或创建测试步兵(最近测试步兵1, player, 临时测试玩家X - 220, 临时测试玩家Y + 220);
  获取或创建测试步兵(最近测试步兵2, player, 临时测试玩家X + 220, 临时测试玩家Y + 220);
  SelectUnitForPlayerSingle(boss, player);
  StarOther_PanCameraToTimedForPlayer(player, 临时测试场地中心X, 临时测试场地中心Y, 0.2);
  const context = 获取或创建巴尔扎罗斯上下文(boss);
  if (context != null) 应用巴尔扎罗斯测试场地(context);
  return context;
}

function 初始化巴尔扎罗斯测试上下文(this: void, context: any): void {
  注册巴尔扎罗斯运行时();
  注册巴尔扎罗斯技能结构();
  初始化巴尔扎罗斯熔核封印与护卫机制(context);
  初始化巴尔扎罗斯格鲁姆技能(context);
  初始化巴尔扎罗斯塞拉技能(context);
  初始化巴尔扎罗斯地核召唤节点(context);
  初始化巴尔扎罗斯熔岩护盾节点(context);
  初始化巴尔扎罗斯末日熔爆节点(context);
  应用Boss战启动属性配置(context.Boss单位);
  记录Boss自动技能启动(context.Boss单位, "Boss战.单位");
  放置巴尔扎罗斯测试护卫(context);
}

function 创建并初始化巴尔扎罗斯测试(this: void, player: any): any {
  const hero = 获取玩家测试基准英雄(player);
  if (hero == null || hero === 0) {
    提示(player, "未找到地图预设玩家1大法师，无法创建测试 Boss。");
    return undefined;
  }

  const boss = 获取或创建测试Boss(player);
  if (!是有效存活单位(boss)) {
    提示(player, "巴尔扎罗斯创建失败。");
    return undefined;
  }

  const context = 准备巴尔扎罗斯测试场景(player, hero, boss);
  if (context == null) {
    提示(player, "巴尔扎罗斯上下文创建失败。");
    return undefined;
  }
  初始化巴尔扎罗斯测试上下文(context);
  return context;
}

function on巴尔扎罗斯测试命令(this: void, player: any): void {
  const context = 创建并初始化巴尔扎罗斯测试(player);
  if (context == null) return;
  提示(player, "已创建/复用巴尔扎罗斯测试场景，并登记 Boss 自动技能。" + 测试命令说明);
}

function 执行巴尔扎罗斯技能测试(this: void, player: any, 序号: number): void {
  const context = 创建并初始化巴尔扎罗斯测试(player);
  if (context == null) return;
  const hero = 获取玩家测试基准英雄(player);

  if (序号 === 1) {
    释放巴尔扎罗斯恶魔咆哮波(context);
    提示(player, "已测试：恶魔咆哮波。");
  } else if (序号 === 2) {
    释放巴尔扎罗斯王者天罚(context);
    提示(player, "已测试：王者天罚。");
  } else if (序号 === 3) {
    释放巴尔扎罗斯熔岩喷发(context);
    提示(player, "已测试：熔岩喷发。");
  } else if (序号 === 4) {
    释放巴尔扎罗斯火焰锁链(context);
    提示(player, "已测试：火焰锁链。");
  } else if (序号 === 5) {
    释放巴尔扎罗斯地核召唤(context);
    提示(player, "已测试：地核召唤。");
  } else if (序号 === 6) {
    释放巴尔扎罗斯末日熔爆(context);
    提示(player, "已测试：末日熔爆。");
  } else if (序号 === 7) {
    if (!是有效存活单位(context.格鲁姆)) {
      提示(player, "格鲁姆不存在或已死亡，无法测试熔岩重锤。");
      return;
    }
    释放格鲁姆重锤(context, hero);
    提示(player, "已测试：格鲁姆熔岩重锤。");
  } else if (序号 === 8) {
    if (!是有效存活单位(context.格鲁姆)) {
      提示(player, "格鲁姆不存在或已死亡，无法测试熔岩火径。");
      return;
    }
    释放格鲁姆火径(context, hero);
    提示(player, "已测试：格鲁姆熔岩火径。");
  } else if (序号 === 9) {
    if (!是有效存活单位(context.塞拉)) {
      提示(player, "塞拉不存在或已死亡，无法测试冰焰双星。");
      return;
    }
    释放冰焰双星(context, hero);
    提示(player, "已测试：塞拉冰焰双星。");
  } else if (序号 === 10) {
    if (!是有效存活单位(context.塞拉)) {
      提示(player, "塞拉不存在或已死亡，无法测试绝对零度领域。");
      return;
    }
    释放绝对零度领域(context, hero);
    提示(player, "已测试：塞拉绝对零度领域。");
  } else if (序号 === 11) {
    if (!是有效存活单位(context.塞拉)) {
      提示(player, "塞拉不存在或已死亡，无法测试切换火焰形态。");
      return;
    }
    切换塞拉形态(context, "火焰", true);
    提示(player, "已测试：塞拉切换火焰形态。");
  } else if (序号 === 12) {
    if (!是有效存活单位(context.塞拉)) {
      提示(player, "塞拉不存在或已死亡，无法测试切换冰霜形态。");
      return;
    }
    切换塞拉形态(context, "冰霜", true);
    提示(player, "已测试：塞拉切换冰霜形态。");
  }
}

function on巴尔扎罗斯技能1测试命令(this: void, player: any): void { 执行巴尔扎罗斯技能测试(player, 1); }
function on巴尔扎罗斯技能2测试命令(this: void, player: any): void { 执行巴尔扎罗斯技能测试(player, 2); }
function on巴尔扎罗斯技能3测试命令(this: void, player: any): void { 执行巴尔扎罗斯技能测试(player, 3); }
function on巴尔扎罗斯技能4测试命令(this: void, player: any): void { 执行巴尔扎罗斯技能测试(player, 4); }
function on巴尔扎罗斯技能5测试命令(this: void, player: any): void { 执行巴尔扎罗斯技能测试(player, 5); }
function on巴尔扎罗斯技能6测试命令(this: void, player: any): void { 执行巴尔扎罗斯技能测试(player, 6); }
function on巴尔扎罗斯技能7测试命令(this: void, player: any): void { 执行巴尔扎罗斯技能测试(player, 7); }
function on巴尔扎罗斯技能8测试命令(this: void, player: any): void { 执行巴尔扎罗斯技能测试(player, 8); }
function on巴尔扎罗斯技能9测试命令(this: void, player: any): void { 执行巴尔扎罗斯技能测试(player, 9); }
function on巴尔扎罗斯技能10测试命令(this: void, player: any): void { 执行巴尔扎罗斯技能测试(player, 10); }
function on巴尔扎罗斯技能11测试命令(this: void, player: any): void { 执行巴尔扎罗斯技能测试(player, 11); }
function on巴尔扎罗斯技能12测试命令(this: void, player: any): void { 执行巴尔扎罗斯技能测试(player, 12); }

注册聊天命令监听(测试命令, on巴尔扎罗斯测试命令);
注册聊天命令监听("bztest1", on巴尔扎罗斯技能1测试命令);
注册聊天命令监听("bztest2", on巴尔扎罗斯技能2测试命令);
注册聊天命令监听("bztest3", on巴尔扎罗斯技能3测试命令);
注册聊天命令监听("bztest4", on巴尔扎罗斯技能4测试命令);
注册聊天命令监听("bztest5", on巴尔扎罗斯技能5测试命令);
注册聊天命令监听("bztest6", on巴尔扎罗斯技能6测试命令);
注册聊天命令监听("bztest7", on巴尔扎罗斯技能7测试命令);
注册聊天命令监听("bztest8", on巴尔扎罗斯技能8测试命令);
注册聊天命令监听("bztest9", on巴尔扎罗斯技能9测试命令);
注册聊天命令监听("bztest10", on巴尔扎罗斯技能10测试命令);
注册聊天命令监听("bztest11", on巴尔扎罗斯技能11测试命令);
注册聊天命令监听("bztest12", on巴尔扎罗斯技能12测试命令);

export {};
