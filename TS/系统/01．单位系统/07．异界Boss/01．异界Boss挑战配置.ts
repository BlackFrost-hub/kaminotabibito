/** @noSelfInFile */

/** 异界 Boss 挑战入口的纯 TS 配置与运行缓存。 */
export interface 异界Boss挑战配置 {
  挑战物品ID: string;
  最高可挑战等级: number;
  Boss单位ID列表: readonly string[];
  基础生命值: number;
  基础生命恢复: number;
  攻击力: number;
}

export const 异界Boss挑战配置表: readonly 异界Boss挑战配置[] = [
  { 挑战物品ID: "I0BA", 最高可挑战等级: 25, Boss单位ID列表: ["E07E", "E079", "O005", "E07X"], 基础生命值: 8000, 基础生命恢复: 50, 攻击力: 250 },
  { 挑战物品ID: "I0BB", 最高可挑战等级: 35, Boss单位ID列表: ["E07E", "E079", "O005", "E07X"], 基础生命值: 13000, 基础生命恢复: 100, 攻击力: 450 },
  { 挑战物品ID: "I0B8", 最高可挑战等级: 45, Boss单位ID列表: ["E07E", "E079", "O005", "E07X"], 基础生命值: 24000, 基础生命恢复: 200, 攻击力: 750 },
  { 挑战物品ID: "I0B9", 最高可挑战等级: 55, Boss单位ID列表: ["E07E", "E079", "O005", "E07X"], 基础生命值: 32000, 基础生命恢复: 250, 攻击力: 950 },
];

export const 异界Boss挑战池: string[] = ["赫萝", "克洛克达尔", "萨菲罗斯", "天子"];
const 当前异界Boss挑战池: string[] = ["赫萝", "克洛克达尔", "萨菲罗斯", "天子"];

export interface 异界Boss挑战运行缓存 {
  Boss单位: any;
  触发单位: any;
  配置: 异界Boss挑战配置;
  难度值: number;
  最大生命值: number;
}

export const 异界Boss挑战运行缓存表: 异界Boss挑战运行缓存[] = [];

const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, value: string) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const 异界Boss挑战日志模块 = "异界Boss挑战";
let 已初始化异界Boss挑战物品监听 = false;

export function 记录异界Boss挑战运行(this: void, 记录: 异界Boss挑战运行缓存): void {
  异界Boss挑战运行缓存表.push(记录);
}

export function 获取当前异界Boss挑战运行(this: void): 异界Boss挑战运行缓存 | undefined {
  return 异界Boss挑战运行缓存表[异界Boss挑战运行缓存表.length - 1];
}

export function 移除异界Boss挑战运行(this: void, boss: any): void {
  for (let i = 异界Boss挑战运行缓存表.length - 1; i >= 0; i--) {
    if (异界Boss挑战运行缓存表[i].Boss单位 === boss) 异界Boss挑战运行缓存表.splice(i, 1);
  }
}

export function 获取异界Boss挑战配置(this: void, itemTypeId: number): 异界Boss挑战配置 | undefined {
  for (let i = 0; i < 异界Boss挑战配置表.length; i++) {
    const 配置 = 异界Boss挑战配置表[i];
    if (解析配置内部ID(配置.挑战物品ID) === itemTypeId) return 配置;
  }
  return undefined;
}

export function 随机选择异界Boss单位ID(this: void, 配置: 异界Boss挑战配置): string {
  const jass = require("jass.common") as any;
  if (当前异界Boss挑战池.length === 0) {
    for (let i = 0; i < 异界Boss挑战池.length; i++) 当前异界Boss挑战池.push(异界Boss挑战池[i]);
  }
  const index = (jass.GetRandomInt(1, 当前异界Boss挑战池.length) as number) - 1;
  const 名称 = 当前异界Boss挑战池[index] ?? 当前异界Boss挑战池[0];
  当前异界Boss挑战池.splice(index, 1);
  for (let i = 0; i < 配置.Boss单位ID列表.length; i++) {
    const candidate = 配置.Boss单位ID列表[i];
    if ((candidate === "E07E" && 名称 === "赫萝") || (candidate === "E079" && 名称 === "克洛克达尔") || (candidate === "O005" && 名称 === "萨菲罗斯") || (candidate === "E07X" && 名称 === "天子")) return candidate;
  }
  return 配置.Boss单位ID列表[0];
}

export function 初始化异界Boss挑战物品监听(this: void): void {
  if (已初始化异界Boss挑战物品监听) {
    debugLogForce(异界Boss挑战日志模块, "监听已初始化，跳过重复注册");
    return;
  }
  已初始化异界Boss挑战物品监听 = true;
  const events = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
    onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
  };
  const jass = require("jass.common") as any;
  const RemoveItem = jass.RemoveItem as (this: void, item: any) => void;
  const GetItemTypeId = jass.GetItemTypeId as (this: void, item: any) => number;
  const GetHeroLevel = jass.GetHeroLevel as (this: void, unit: any) => number;
  const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
  const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
  const SetUnitOwner = jass.SetUnitOwner as (this: void, unit: any, player: any, changeColor: boolean) => void;
  const Player = jass.Player as (this: void, id: number) => any;
  const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
  const { 启动剧情Boss战 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接") as {
    启动剧情Boss战: (this: void, boss: any, params?: { 触发单位?: any }) => boolean;
  };
  const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用") as {
    应用Boss战启动属性配置: (this: void, unit: any) => void;
  };
  const { addDelayedCallback, getGameDifficulty } = require("系统.00．核心系统.05．中心计时器") as {
    addDelayedCallback: (this: void, delayMs: number, callback: (this: void, value: any) => void, value: any) => number;
    getGameDifficulty: (this: void) => number;
  };
  const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
    创建单位并登记排泄安全: (this: void, player: any, unitTypeId: number, x: number, y: number, facing: number) => any;
  };
  const { 单位_设置每秒生命恢复 } = require("平台扩展API动作") as {
    单位_设置每秒生命恢复: (this: void, unit: any, regen: number) => boolean;
  };
  const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
  const SetUnitLifePercentBJ = jass.SetUnitLifePercentBJ as (this: void, unit: any, percent: number) => void;
  const ConvertUnitState = jass.ConvertUnitState as (this: void, value: number) => any;
  const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE;
  const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
  const CreateGroup = jass.CreateGroup as (this: void) => any;
  const DestroyGroup = jass.DestroyGroup as (this: void, group: any) => void;
  const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (this: void, group: any, x: number, y: number, radius: number, filter: any) => void;
  const FirstOfGroup = jass.FirstOfGroup as (this: void, group: any) => any;
  const GroupRemoveUnit = jass.GroupRemoveUnit as (this: void, group: any, unit: any) => boolean;
  const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
  const AddItemToStockBJ = (require("lib.扩展函数.BJ函数.03．物品与库存") as {
    AddItemToStockBJ: (this: void, itemTypeId: number, unit: any, currentStock: number, stockMax: number) => void;
  }).AddItemToStockBJ;
  const 商店单位类型ID = 解析配置内部ID("hvlt");
  const 补回挑战物品库存 = (unit: any, itemTypeId: number): void => {
    const group = CreateGroup();
    if (group == null || group === 0) return;
    GroupEnumUnitsInRange(group, GetUnitX(unit), GetUnitY(unit), 1200, null);
    let nearby: any;
    while (true) {
      nearby = FirstOfGroup(group);
      if (nearby == null || nearby === 0) break;
      GroupRemoveUnit(group, nearby);
      if (GetUnitTypeId(nearby) === 商店单位类型ID) {
        AddItemToStockBJ(itemTypeId, nearby, 1, 1);
        break;
      }
    }
    DestroyGroup(group);
  };
  const onPickup = (unit: any, item: any): void => {
    const itemTypeId = item == null || item === 0 ? 0 : GetItemTypeId(item);
    const heroLevel = unit == null || unit === 0 ? 0 : GetHeroLevel(unit);
    const 配置 = 获取异界Boss挑战配置(itemTypeId);
    if (配置 == null) {
      return;
    }
    if (unit == null || unit === 0) {
      debugLogForce(异界Boss挑战日志模块, "拾取单位为空", "itemTypeId", itemTypeId);
      return;
    }
    if (heroLevel > 配置.最高可挑战等级) {
      debugLogForce(异界Boss挑战日志模块, "等级超过上限，退回库存", "heroLevel", heroLevel, "maxLevel", 配置.最高可挑战等级);
      RemoveItem(item);
      补回挑战物品库存(unit, itemTypeId);
      return;
    }
    debugLogForce(异界Boss挑战日志模块, "挑战通过，消耗物品", "heroLevel", heroLevel, "maxLevel", 配置.最高可挑战等级);
    RemoveItem(item);
    // 对齐旧 JASS：购买挑战物品后先把商店交给 Player(6)，再触发背景框 UI。
    const shopGroup = CreateGroup();
    if (shopGroup != null && shopGroup !== 0) {
      GroupEnumUnitsInRange(shopGroup, GetUnitX(unit), GetUnitY(unit), 1000, null);
      let shop: any;
      while (true) {
        shop = FirstOfGroup(shopGroup);
        if (shop == null || shop === 0) break;
        GroupRemoveUnit(shopGroup, shop);
        if (GetUnitTypeId(shop) === 商店单位类型ID) SetUnitOwner(shop, Player(6), true);
      }
      DestroyGroup(shopGroup);
    }
    const { STES_Fire } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
      STES_Fire: (this: void, name: string) => void;
    };
    STES_Fire("异界Boss背景框");
    const 难度值 = getGameDifficulty() > 0 ? getGameDifficulty() : 1;
    const 生命倍率表: Record<number, number> = { 1: 1, 2: 1.2, 3: 1.5, 4: 2, 5: 2.6, 6: 3.2 };
    const 最大生命值 = 配置.基础生命值 * (生命倍率表[难度值] ?? (1 + (难度值 - 1) * 0.6));
    addDelayedCallback(6600, (value: { unit: any }): void => {
      debugLogForce(异界Boss挑战日志模块, "延迟回调开始", "hasUnit", value != null && value.unit != null && value.unit !== 0);
      if (value == null || value.unit == null || value.unit === 0) {
        return;
      }
      const bossUnitId = 随机选择异界Boss单位ID(配置);
      const bossTypeId = 解析配置内部ID(bossUnitId);
      debugLogForce(异界Boss挑战日志模块, "准备创建Boss", "bossUnitId", bossUnitId, "bossTypeId", bossTypeId, "difficulty", 难度值);
      const boss = 创建单位并登记排泄安全(Player(PLAYER_NEUTRAL_AGGRESSIVE), bossTypeId, 26468, 20612.5, 270);
      if (boss == null || boss === 0) {
        debugLogForce(异界Boss挑战日志模块, "Boss创建失败", "bossUnitId", bossUnitId, "bossTypeId", bossTypeId);
        return;
      }
      SetUnitState(boss, UNIT_STATE_MAX_LIFE, 最大生命值);
      SetUnitState(boss, UNIT_STATE_LIFE, 最大生命值);
      SetUnitState(boss, ConvertUnitState(0x12), 配置.攻击力);
      单位_设置每秒生命恢复(boss, 配置.基础生命恢复);
      记录异界Boss挑战运行({ Boss单位: boss, 触发单位: value.unit, 配置, 难度值, 最大生命值 });
      应用Boss战启动属性配置(boss);
      // 对齐旧 JASS：最大生命和属性应用完成后，最后强制回满到 100%。
      SetUnitLifePercentBJ(boss, 100);
      const started = 启动剧情Boss战(boss, { 触发单位: value.unit });
      debugLogForce(异界Boss挑战日志模块, "Boss创建并启动完成", "started", started, "bossUnitId", bossUnitId);
    }, { unit });
  };
  const listenerId = events.onItemPickup(onPickup);
  debugLogForce(异界Boss挑战日志模块, "拾取监听注册完成", "listenerId", listenerId);
}

export {};
