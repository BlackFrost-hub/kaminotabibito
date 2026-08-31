/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 注册环境互动调查点 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心") as {
  注册环境互动调查点: (this: void, 调查点: any) => boolean;
};
const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口") as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, 物品类型ID: number, X: number, Y: number) => any;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};
const { 是否已成功完成封印守卫战 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.49．封印守卫战") as {
  是否已成功完成封印守卫战: (this: void) => boolean;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, 物品名: string) => string | undefined;
};
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
  unregisterDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
};
const { 发送单位提示给玩家 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送单位提示给玩家: (this: void, 目标玩家: any, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

const 封印调查X = 998.3;
const 封印调查Y = -9739.3;
const 小Boss名称 = "归返的封印枪卫";
const 小Boss模型 = "Unit\\Special\\SealRiftWarden.mdx";
const 小Boss玩家 = jass.Player(jass.PLAYER_NEUTRAL_AGGRESSIVE);
let 当前小Boss: any = null;
let 当前调查英雄: any = null;
let 当前调查玩家ID = -1;

function 处理封印小Boss死亡(this: void, 死亡单位: any, _击杀单位: any): void {
  if (死亡单位 !== 当前小Boss) return;
  const 英雄 = 当前调查英雄;
  const 玩家ID = 当前调查玩家ID;
  当前小Boss = null;
  当前调查英雄 = null;
  当前调查玩家ID = -1;
  unregisterDeathListener(处理封印小Boss死亡);
  if (英雄 == null || 英雄 === 0 || 玩家ID < 0) return;
  const 配置ID = 按名字反查物品ID("七晶封印棱章");
  if (配置ID == null) return;
  const 物品 = 创建物品并注册排泄监听(解析配置内部ID(配置ID), jass.GetUnitX(英雄), jass.GetUnitY(英雄));
  if (物品 == null || 物品 === 0) return;
  jass.UnitAddItem(英雄, 物品);
  发送单位提示给玩家(jass.Player(玩家ID), 英雄, "|cff66ccff『七晶封印棱章』：|r封印枪卫倒下，七颗晶石重新稳定下来，棱面上凝出一枚完整的守护徽章。|n|cffffff00获得装备：七晶封印棱章。|r", 5200);
}

function 处理封印守卫战后调查(this: void, 玩家ID: number, 英雄: any, _调查点: any): boolean {
  if (!是否已成功完成封印守卫战() || 当前小Boss != null) return false;
  const 小Boss = 创建召唤物({
    所属玩家: 小Boss玩家,
    单位类型: "n06M",
    单位名称: 小Boss名称,
    模型文件: 小Boss模型,
    X: 封印调查X,
    Y: 封印调查Y,
    朝向: 270,
    生命值: 54600,
    生命值受小怪倍率: false,
    生命值受难度倍率: true,
    攻击力: 7670,
    攻击间隔: 1.35,
    护甲: 45.5,
    索敌范围: 800,
    缩放: 1.15,
  });
  if (小Boss == null || 小Boss === 0) return false;
  当前小Boss = 小Boss;
  当前调查英雄 = 英雄;
  当前调查玩家ID = 玩家ID;
  registerDeathListener(处理封印小Boss死亡);
  发送单位提示给玩家(jass.Player(玩家ID), 英雄, "|cff66ccff『封印核心残响』：|r七颗晶石的余波重新汇聚，裂隙深处走出一名归返的封印枪卫。击败它，才能取走守护战留下的晶石力量。|r", 5200);
  return true;
}

export function 注册封印核心探索点(this: void): void {
  注册环境互动调查点({ ID: "封印核心.封印守卫战后残响", X: 封印调查X, Y: 封印调查Y, 一次性: true, 触发回调: 处理封印守卫战后调查 });
}

