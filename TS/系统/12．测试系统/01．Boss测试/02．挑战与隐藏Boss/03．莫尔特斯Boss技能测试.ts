/** @noSelfInFile */

import type { Boss测试技能命令 } from '../../00．Boss测试系统/00．Boss测试类型';

const jass = require("jass.common") as any;
const globals = require("jass.globals") as { udg_Boss?: any; [key: string]: any };
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { CreateUbersplatBJ, ShowUbersplatBJ, SetUbersplatRenderAlways } = require("lib.扩展函数.BJ函数.11．贴图函数") as {
  CreateUbersplatBJ: (this: void, where: any, file: string, red: number, green: number, blue: number, alpha: number, forcePaused: boolean, noBirthTime: boolean) => any;
  ShowUbersplatBJ: (this: void, flag: boolean, whichUbersplat: any) => void;
  SetUbersplatRenderAlways: (this: void, whichUbersplat: any, flag: boolean) => void;
};

const { SelectUnitForPlayerSingle } = require("lib.扩展函数.BJ函数.index") as {
  SelectUnitForPlayerSingle: (this: void, unit: any, player: any) => void;
};
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};
const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用") as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { 标记测试Boss跳过死亡结算 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  标记测试Boss跳过死亡结算: (this: void, boss: any) => void;
};
const { Boss测试单位存活, 设置Boss测试单位满血, 获取Boss测试玩家基准英雄, 准备Boss测试固定步兵, 准备Boss测试固定山丘之王, 移除Boss测试单位, 注册Boss测试命令组 } = require("系统.12．测试系统.00．Boss测试系统.index") as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  设置Boss测试单位满血: (this: void, unit: any, 最大生命值?: number) => void;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  准备Boss测试固定步兵: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  准备Boss测试固定山丘之王: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  移除Boss测试单位: (this: void, unit: any) => void;
  注册Boss测试命令组: (this: void, 配置: any) => void;
};

const { 获取或创建莫尔特斯上下文, 清理莫尔特斯上下文 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.01．运行时上下文") as {
  获取或创建莫尔特斯上下文: (this: void, boss: any) => any;
  清理莫尔特斯上下文: (this: void, boss: any) => void;
};
const { 确保莫尔特斯根须宫格, 应用莫尔特斯腐败值 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.03．腐败值与根须领域") as {
  确保莫尔特斯根须宫格: (this: void, context: any) => void;
  应用莫尔特斯腐败值: (this: void, context: any, unit: any, amount: number) => number;
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
const { 释放莫尔特斯共生腐朽虫群, 测试释放莫尔特斯共生腐朽虫群并延迟击杀 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.10．共生腐朽虫群") as {
  释放莫尔特斯共生腐朽虫群: (this: void, context: any) => boolean;
  测试释放莫尔特斯共生腐朽虫群并延迟击杀: (this: void, context: any) => boolean;
};
const { 释放莫尔特斯古木悲鸣 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.11．古木悲鸣") as {
  释放莫尔特斯古木悲鸣: (this: void, context: any) => void;
};
const { 测试触发莫尔特斯腐败传输 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.12．腐败传输") as {
  测试触发莫尔特斯腐败传输: (this: void, context: any) => void;
};

const 临时测试场地中心X = -540.6;
const 临时测试场地中心Y = -2495.2;
const 临时测试玩家Y = -3055.2;

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facingAngle: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const Location = jass.Location as (x: number, y: number) => any;
const RemoveLocation = jass.RemoveLocation as (whichLocation: any) => void;

const 莫尔特斯测试Boss: Record<number, any> = {};
const 莫尔特斯测试步兵: Record<number, any> = {};
const 莫尔特斯测试山丘之王: Record<number, any> = {};
const 莫尔特斯测试ULAR: Record<number, any[] | undefined> = {};
const 莫尔特斯ULAR测试模块 = "莫尔特斯-ULAR测试";
const 莫尔特斯ULAR测试覆盖边长 = 1536;
const 莫尔特斯ULAR测试覆盖行列 = 4;

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 获取或创建测试Boss(this: void, player: any): any {
  const pid = GetPlayerId(player);
  const cached = 莫尔特斯测试Boss[pid];
  if (Boss测试单位存活(cached)) {
    SetUnitPosition(cached, 临时测试场地中心X, 临时测试场地中心Y);
    SetUnitFacing(cached, 270);
    设置Boss测试单位满血(cached);
    标记测试Boss跳过死亡结算(cached);
    globals.udg_Boss = cached;
    return cached;
  }

  const boss = CreateUnit(player, stringToFourCC("N05W"), 临时测试场地中心X, 临时测试场地中心Y, 270);
  if (boss != null && boss !== 0) {
    莫尔特斯测试Boss[pid] = boss;
    标记测试Boss跳过死亡结算(boss);
    SetHeroLevel(boss, 42, false);
    设置Boss测试单位满血(boss);
    globals.udg_Boss = boss;
  }
  return boss;
}

function 准备测试场景(this: void, player: any, boss: any): void {
  const pid = GetPlayerId(player);
  const hero = 获取Boss测试玩家基准英雄(player);
  if (hero != null && hero !== 0) {
    设置Boss测试单位满血(hero);
  }
  莫尔特斯测试步兵[pid] = 准备Boss测试固定步兵(莫尔特斯测试步兵[pid], 临时测试场地中心X - 220, 临时测试玩家Y + 180, 90);
  // 将山丘之王放在 Boss 附近，确保腐败孢子云的 200 码范围能够命中并叠加腐败值。
  莫尔特斯测试山丘之王[pid] = 准备Boss测试固定山丘之王(莫尔特斯测试山丘之王[pid], 临时测试场地中心X + 100, 临时测试场地中心Y + 100, 90);
  SelectUnitForPlayerSingle(boss, player);
  StarOther_PanCameraToTimedForPlayer(player, 临时测试场地中心X, 临时测试场地中心Y, 0.2);
}

function 启动Boss测试链路(this: void, boss: any): void {
  应用Boss战启动属性配置(boss);
}

function 清理莫尔特斯测试ULAR缓存(this: void, data: any): void {
  if (data == null) return;
  莫尔特斯测试ULAR[data.pid] = undefined;
}

function on莫尔特斯ULAR测试命令(this: void, player: any, context: any): void {
  const archmage = globals.gg_unit_Hamg_0002;
  if (archmage == null || archmage === 0) {
    debugLogForce(莫尔特斯ULAR测试模块, "创建失败", "原因=找不到 gg_unit_Hamg_0002");
    return;
  }

  const pid = GetPlayerId(player);
  const cached = 莫尔特斯测试ULAR[pid];
  if (cached != null && cached.length > 0) {
    for (let i = 0; i < cached.length; i++) {
      const ubersplat = cached[i];
      SetUbersplatRenderAlways(ubersplat, true);
      ShowUbersplatBJ(true, ubersplat);
    }
    debugLogForce(莫尔特斯ULAR测试模块, "复用已有贴图阵列", "数量=", cached.length, "单位=", archmage);
    return;
  }

  if (context == null || context.清理 == null) {
    debugLogForce(莫尔特斯ULAR测试模块, "创建失败", "原因=莫尔特斯测试上下文不存在");
    return;
  }

  const x = GetUnitX(archmage);
  const y = GetUnitY(archmage);
  const 左 = x - 莫尔特斯ULAR测试覆盖边长 / 2;
  const 下 = y - 莫尔特斯ULAR测试覆盖边长 / 2;
  const 单格边长 = 莫尔特斯ULAR测试覆盖边长 / 莫尔特斯ULAR测试覆盖行列;
  const 贴图列表: any[] = [];
  for (let row = 0; row < 莫尔特斯ULAR测试覆盖行列; row++) {
    for (let col = 0; col < 莫尔特斯ULAR测试覆盖行列; col++) {
      const 贴图X = 左 + 单格边长 * (col + 0.5);
      const 贴图Y = 下 + 单格边长 * (row + 0.5);
      const loc = Location(贴图X, 贴图Y);
      const ubersplat = CreateUbersplatBJ(loc, "ULAR", 100, 100, 100, 0, false, false);
      RemoveLocation(loc);
      if (ubersplat == null || ubersplat === 0) continue;
      SetUbersplatRenderAlways(ubersplat, true);
      ShowUbersplatBJ(true, ubersplat);
      贴图列表.push(ubersplat);
      context.清理.登记贴图("莫尔特斯-ULAR测试", ubersplat);
    }
  }
  if (贴图列表.length === 0) {
    debugLogForce(莫尔特斯ULAR测试模块, "创建失败", "x=", x, "y=", y, "数量=", 贴图列表.length);
    return;
  }
  莫尔特斯测试ULAR[pid] = 贴图列表;
  context.清理.登记清理("莫尔特斯-ULAR测试缓存", 清理莫尔特斯测试ULAR缓存, { pid });
  debugLogForce(莫尔特斯ULAR测试模块, "创建成功", "x=", x, "y=", y, "覆盖网格=", 莫尔特斯ULAR测试覆盖行列, "x", 莫尔特斯ULAR测试覆盖行列, "数量=", 贴图列表.length, "单位=", archmage);
}

function 创建莫尔特斯测试(this: void, player: any): any {
  const boss = 获取或创建测试Boss(player);
  if (!Boss测试单位存活(boss)) return undefined;
  注册莫尔特斯被动效果();
  准备测试场景(player, boss);
  启动Boss测试链路(boss);
  const hero = 获取Boss测试玩家基准英雄(player);
  const context = 获取或创建莫尔特斯上下文(boss);
  if (context != null) {
    context.根须领域中心X = 临时测试场地中心X;
    context.根须领域中心Y = 临时测试场地中心Y;
    context.根须穿刺测试格子索引 = [0, 1, 2];
    context.测试额外虫尸拾取单位 = hero != null && hero !== 0 ? [hero] : [];
    debugLogForce(
      "莫尔特斯测试场景",
      "虫尸拾取测试单位",
      "大法师=",
      hero,
      "有效=",
      hero != null && hero !== 0,
      "数量=",
      context.测试额外虫尸拾取单位.length,
    );
    确保莫尔特斯根须宫格(context);
    debugLogForce("莫尔特斯测试场景", "场景初始化", "Boss=", boss, "中心=", context.根须领域中心X, context.根须领域中心Y, "根须宫格=", context.根须宫格 == null ? "nil" : "ready");
  }
  return context;
}

function 清理莫尔特斯测试(this: void, player: any, _context: any): void {
  const pid = GetPlayerId(player);
  const boss = 莫尔特斯测试Boss[pid];
  if (boss != null && boss !== 0) 清理莫尔特斯上下文(boss);
  移除Boss测试单位(莫尔特斯测试步兵[pid]);
  移除Boss测试单位(莫尔特斯测试山丘之王[pid]);
  移除Boss测试单位(boss);
  莫尔特斯测试步兵[pid] = undefined;
  莫尔特斯测试山丘之王[pid] = undefined;
  莫尔特斯测试ULAR[pid] = undefined;
  莫尔特斯测试Boss[pid] = undefined;
  if (globals.udg_Boss === boss) globals.udg_Boss = null;
}

function on莫尔特斯技能1测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放莫尔特斯腐朽根须穿刺(context);
}

function on莫尔特斯技能2测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放莫尔特斯腐败孢子云(context);
}

function on莫尔特斯技能3测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放莫尔特斯扭曲荆棘鞭笞(context);
}

function on莫尔特斯技能4测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放莫尔特斯腐败之种(context);
}

function on莫尔特斯技能5测试命令(this: void, _player: any, context: any): void {
  if (context != null) 触发莫尔特斯根系觉醒(context);
}

function on莫尔特斯技能6测试命令(this: void, _player: any, context: any): void {
  if (context != null) 触发莫尔特斯腐朽领域(context);
}

function on莫尔特斯技能7测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放莫尔特斯共生腐朽虫群(context);
}

function on莫尔特斯技能7_2测试命令(this: void, _player: any, context: any): void {
  if (context != null) 测试释放莫尔特斯共生腐朽虫群并延迟击杀(context);
}

function on莫尔特斯技能8测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放莫尔特斯古木悲鸣(context);
}

function on莫尔特斯被动腐败满层测试命令(this: void, player: any, context: any): void {
  const target = 莫尔特斯测试步兵[GetPlayerId(player)];
  const targetAlive = target != null && target !== 0 && Boss测试单位存活(target);
  if (context == null || !targetAlive) return;
  // 根须缠绕登记在固定测试靶上；BuffUI只读取当前选中单位，命令9必须切换到该靶才能看到BMO2图标。
  SelectUnitForPlayerSingle(target, player);
  StarOther_PanCameraToTimedForPlayer(player, GetUnitX(target), GetUnitY(target), 0.2);
  应用莫尔特斯腐败值(context, target, 100);
}

function on莫尔特斯被动腐败传输测试命令(this: void, player: any, context: any): void {
  const boss = context != null ? context.Boss单位 : null;
  const bossAlive = boss != null && boss !== 0 && Boss测试单位存活(boss);
  if (context == null || !bossAlive) return;
  SelectUnitForPlayerSingle(boss, player);
  StarOther_PanCameraToTimedForPlayer(player, GetUnitX(boss), GetUnitY(boss), 0.2);
  测试触发莫尔特斯腐败传输(context);
}

const 莫尔特斯测试技能列表: Boss测试技能命令[] = [
  { 序号: 11, 命令: "ular", 名称: "测试大法师位置的ULAR地表贴图", 执行: on莫尔特斯ULAR测试命令 },
  { 序号: 1, 名称: "腐朽根须穿刺", 执行: on莫尔特斯技能1测试命令 },
  { 序号: 2, 名称: "腐败孢子云", 执行: on莫尔特斯技能2测试命令 },
  { 序号: 3, 名称: "扭曲荆棘鞭笞", 执行: on莫尔特斯技能3测试命令 },
  { 序号: 4, 名称: "腐败之种", 执行: on莫尔特斯技能4测试命令 },
  { 序号: 5, 名称: "根系觉醒", 执行: on莫尔特斯技能5测试命令 },
  { 序号: 6, 名称: "腐朽领域", 执行: on莫尔特斯技能6测试命令 },
  { 序号: 7, 名称: "共生腐朽虫群", 执行: on莫尔特斯技能7测试命令 },
  { 序号: 7, 命令: "7-2", 名称: "共生腐朽虫群测试：2秒后逐只击杀并播放爆炸表现", 执行: on莫尔特斯技能7_2测试命令 },
  { 序号: 8, 名称: "古木悲鸣", 执行: on莫尔特斯技能8测试命令 },
  { 序号: 9, 名称: "被动：腐败值满层缠绕", 执行: on莫尔特斯被动腐败满层测试命令 },
  { 序号: 10, 名称: "被动：腐败传输与护盾", 执行: on莫尔特斯被动腐败传输测试命令 },
];

注册Boss测试命令组({
  命令单位名: "莫尔特斯",
  Boss名称: "莫尔特斯",
  创建或获取上下文: 创建莫尔特斯测试,
  清理上下文: 清理莫尔特斯测试,
  技能命令列表: 莫尔特斯测试技能列表,
});

export {};
