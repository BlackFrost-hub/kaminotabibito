/** @noSelfInFile */

import type { Boss测试技能命令 } from '../../00．Boss测试系统/00．Boss测试类型';

const jass = require("jass.common") as any;
const globals = require("jass.globals") as { udg_Boss?: any; [key: string]: any };

const { SelectUnitForPlayerSingle } = require("lib.扩展函数.BJ函数.index") as {
  SelectUnitForPlayerSingle: (this: void, unit: any, player: any) => void;
};
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};
const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用") as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { 获取或创建巴尔扎罗斯上下文, 清理巴尔扎罗斯上下文, 注册巴尔扎罗斯运行时 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.03．运行时上下文") as {
  获取或创建巴尔扎罗斯上下文: (this: void, boss: any) => any;
  清理巴尔扎罗斯上下文: (this: void, boss: any) => void;
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
const { Boss测试单位存活, 设置Boss测试单位满血, 获取Boss测试玩家基准英雄, 准备Boss测试固定步兵, 移除Boss测试单位, 注册Boss测试命令组 } = require("系统.12．测试系统.00．Boss测试系统.index") as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  设置Boss测试单位满血: (this: void, unit: any, 最大生命值?: number) => void;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  准备Boss测试固定步兵: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  移除Boss测试单位: (this: void, unit: any) => void;
  注册Boss测试命令组: (this: void, 配置: any) => void;
};

const 巴尔扎罗斯单位ID = stringToFourCC("N03G");
const 临时测试场地中心X = -540.6;
const 临时测试场地中心Y = -2495.2;
const 临时测试玩家X = -540.6;
const 临时测试玩家Y = -3055.2;

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facingAngle: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;

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
  if (Boss测试单位存活(context.格鲁姆)) {
    SetUnitPosition(context.格鲁姆, 巴尔扎罗斯护卫配置.格鲁姆.X + 映射.偏移X, 巴尔扎罗斯护卫配置.格鲁姆.Y + 映射.偏移Y);
    SetUnitFacing(context.格鲁姆, 巴尔扎罗斯护卫配置.格鲁姆.面向);
    设置Boss测试单位满血(context.格鲁姆);
  }
  if (Boss测试单位存活(context.塞拉)) {
    SetUnitPosition(context.塞拉, 巴尔扎罗斯护卫配置.塞拉.X + 映射.偏移X, 巴尔扎罗斯护卫配置.塞拉.Y + 映射.偏移Y);
    SetUnitFacing(context.塞拉, 巴尔扎罗斯护卫配置.塞拉.面向);
    设置Boss测试单位满血(context.塞拉);
  }
}

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 获取或创建测试Boss(this: void, player: any): any {
  const pid = GetPlayerId(player);
  const cached = 最近测试Boss[pid];
  if (Boss测试单位存活(cached)) {
    SetUnitPosition(cached, 临时测试场地中心X, 临时测试场地中心Y);
    SetUnitFacing(cached, 270);
    设置Boss测试单位满血(cached);
    标记测试Boss跳过死亡结算(cached);
    globals.udg_Boss = cached;
    return cached;
  }

  const boss = CreateUnit(player, 巴尔扎罗斯单位ID, 临时测试场地中心X, 临时测试场地中心Y, 270);
  if (boss != null && boss !== 0) {
    最近测试Boss[pid] = boss;
    标记测试Boss跳过死亡结算(boss);
    SetHeroLevel(boss, 40, false);
    设置Boss测试单位满血(boss);
    globals.udg_Boss = boss;
  }
  return boss;
}

function 准备巴尔扎罗斯测试场景(this: void, player: any, hero: any, boss: any): any {
  const pid = GetPlayerId(player);
  SetUnitPosition(hero, 临时测试玩家X, 临时测试玩家Y);
  SetUnitFacing(hero, 90);
  设置Boss测试单位满血(hero);
  最近测试步兵1[pid] = 准备Boss测试固定步兵(最近测试步兵1[pid], 临时测试玩家X - 220, 临时测试玩家Y + 220, 90);
  最近测试步兵2[pid] = 准备Boss测试固定步兵(最近测试步兵2[pid], 临时测试玩家X + 220, 临时测试玩家Y + 220, 90);
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
  放置巴尔扎罗斯测试护卫(context);
}

function 创建并初始化巴尔扎罗斯测试(this: void, player: any): any {
  const hero = 获取Boss测试玩家基准英雄(player);
  if (!Boss测试单位存活(hero)) return undefined;

  const boss = 获取或创建测试Boss(player);
  if (!Boss测试单位存活(boss)) return undefined;

  const context = 准备巴尔扎罗斯测试场景(player, hero, boss);
  if (context == null) return undefined;
  初始化巴尔扎罗斯测试上下文(context);
  return context;
}

function 清理巴尔扎罗斯测试(this: void, player: any, _context: any): void {
  const pid = GetPlayerId(player);
  const boss = 最近测试Boss[pid];
  if (boss != null && boss !== 0) 清理巴尔扎罗斯上下文(boss);
  移除Boss测试单位(最近测试步兵1[pid]);
  移除Boss测试单位(最近测试步兵2[pid]);
  移除Boss测试单位(boss);
  最近测试步兵1[pid] = undefined;
  最近测试步兵2[pid] = undefined;
  最近测试Boss[pid] = undefined;
  if (globals.udg_Boss === boss) globals.udg_Boss = null;
}

function on巴尔扎罗斯技能1测试命令(this: void, _player: any, context: any): void {
  释放巴尔扎罗斯恶魔咆哮波(context);
}

function on巴尔扎罗斯技能2测试命令(this: void, _player: any, context: any): void {
  释放巴尔扎罗斯王者天罚(context);
}

function on巴尔扎罗斯技能3测试命令(this: void, _player: any, context: any): void {
  释放巴尔扎罗斯熔岩喷发(context);
}

function on巴尔扎罗斯技能4测试命令(this: void, _player: any, context: any): void {
  释放巴尔扎罗斯火焰锁链(context);
}

function on巴尔扎罗斯技能5测试命令(this: void, _player: any, context: any): void {
  释放巴尔扎罗斯地核召唤(context);
}

function on巴尔扎罗斯技能6测试命令(this: void, _player: any, context: any): void {
  释放巴尔扎罗斯末日熔爆(context);
}

function on巴尔扎罗斯技能7测试命令(this: void, player: any, context: any): void {
  const target = 最近测试步兵1[GetPlayerId(player)];
  if (Boss测试单位存活(context.格鲁姆) && Boss测试单位存活(target)) 释放格鲁姆重锤(context, target);
}

function on巴尔扎罗斯技能8测试命令(this: void, player: any, context: any): void {
  const target = 最近测试步兵1[GetPlayerId(player)];
  if (Boss测试单位存活(context.格鲁姆) && Boss测试单位存活(target)) 释放格鲁姆火径(context, target);
}

function on巴尔扎罗斯技能9测试命令(this: void, player: any, context: any): void {
  const target = 最近测试步兵1[GetPlayerId(player)];
  if (Boss测试单位存活(context.塞拉) && Boss测试单位存活(target)) 释放冰焰双星(context, target);
}

function on巴尔扎罗斯技能10测试命令(this: void, player: any, context: any): void {
  const target = 最近测试步兵1[GetPlayerId(player)];
  if (Boss测试单位存活(context.塞拉) && Boss测试单位存活(target)) 释放绝对零度领域(context, target);
}

function on巴尔扎罗斯技能11测试命令(this: void, _player: any, context: any): void {
  if (Boss测试单位存活(context.塞拉)) 切换塞拉形态(context, "火焰", true);
}

function on巴尔扎罗斯技能12测试命令(this: void, _player: any, context: any): void {
  if (Boss测试单位存活(context.塞拉)) 切换塞拉形态(context, "冰霜", true);
}

const 巴尔扎罗斯测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 名称: "恶魔咆哮波", 执行: on巴尔扎罗斯技能1测试命令 },
  { 序号: 2, 名称: "王者天罚", 执行: on巴尔扎罗斯技能2测试命令 },
  { 序号: 3, 名称: "熔岩喷发", 执行: on巴尔扎罗斯技能3测试命令 },
  { 序号: 4, 名称: "火焰锁链", 执行: on巴尔扎罗斯技能4测试命令 },
  { 序号: 5, 名称: "地核召唤", 执行: on巴尔扎罗斯技能5测试命令 },
  { 序号: 6, 名称: "末日熔爆", 执行: on巴尔扎罗斯技能6测试命令 },
  { 序号: 7, 名称: "格鲁姆熔岩重锤", 执行: on巴尔扎罗斯技能7测试命令 },
  { 序号: 8, 名称: "格鲁姆熔岩火径", 执行: on巴尔扎罗斯技能8测试命令 },
  { 序号: 9, 名称: "塞拉冰焰双星", 执行: on巴尔扎罗斯技能9测试命令 },
  { 序号: 10, 名称: "塞拉绝对零度领域", 执行: on巴尔扎罗斯技能10测试命令 },
  { 序号: 11, 名称: "塞拉切换火焰形态", 执行: on巴尔扎罗斯技能11测试命令 },
  { 序号: 12, 名称: "塞拉切换冰霜形态", 执行: on巴尔扎罗斯技能12测试命令 },
];

注册Boss测试命令组({
  命令单位名: "巴尔扎罗斯",
  Boss名称: "巴尔扎罗斯",
  创建或获取上下文: 创建并初始化巴尔扎罗斯测试,
  清理上下文: 清理巴尔扎罗斯测试,
  技能命令列表: 巴尔扎罗斯测试技能列表,
});

export {};
