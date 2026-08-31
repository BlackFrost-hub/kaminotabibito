/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 注册环境互动调查点, 注销环境互动调查点 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心") as {
  注册环境互动调查点: (this: void, 调查点: any) => boolean;
  注销环境互动调查点: (this: void, 调查点ID: string) => boolean;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, 玩家: any, 单位类型ID: number, X: number, Y: number, 朝向: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, 单位: any) => void;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, 物品类型ID: number, X: number, Y: number) => any;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, 物品名: string) => string | undefined;
};
const { 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整玩家属性: (this: void, 单位: any, 属性名: string, 增量: number) => void;
};
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
  unregisterDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
};
const { 发送单位提示给玩家 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送单位提示给玩家: (this: void, 目标玩家: any, 来源单位: any, 文本: string, 持续时间?: number) => void;
};
const { 读取当前莫尔特斯任务Boss } = require("系统.11．剧情系统.02．支线任务.04．莫尔特斯.01．任务运行") as {
  读取当前莫尔特斯任务Boss: (this: void) => any;
};

const Player = jass.Player as (this: void, 玩家ID: number) => any;
const GetWidgetLife = jass.GetWidgetLife as (this: void, 句柄: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, 单位: any, 类型: any) => boolean;
const GetUnitX = jass.GetUnitX as (this: void, 单位: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, 单位: any) => number;
const GetPlayerState = jass.GetPlayerState as (this: void, 玩家: any, 状态: number) => number;
const SetPlayerState = jass.SetPlayerState as (this: void, 玩家: any, 状态: number, 数值: number) => void;
const UnitAddItem = jass.UnitAddItem as (this: void, 单位: any, 物品: any) => boolean;

const 玩家中立敌对 = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE as number);
const PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD as number;
const PLAYER_STATE_RESOURCE_LUMBER = jass.PLAYER_STATE_RESOURCE_LUMBER as number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const 提示持续毫秒 = 5200;

const 走私账册点位ID = "盗贼洞窟.走私账册";
const 黑水退路点位ID = "盗贼洞窟.黑水退路";
const 染血通行牌点位ID = "盗贼洞窟.染血通行牌";
const 旧战旗残誓点位ID = "盗贼洞窟.旧战旗残誓";

const 盗贼洞窟杂兵类型ID = 解析配置内部ID("骷髅盗贼#nsog");
const 染血通行牌杂兵偏移列表: readonly [number, number, number][] = [
  [-220, -140, 45],
  [220, -140, 135],
  [-220, 140, 315],
  [220, 140, 225],
];
const 染血通行牌X = 26402.3;
const 染血通行牌Y = -25213.2;

let 染血通行牌遭遇已创建 = false;
let 染血通行牌已结算 = false;
let 染血通行牌遭遇英雄: any = null;
let 染血通行牌遭遇玩家ID = -1;
const 染血通行牌遭遇单位列表: any[] = [];

function 句柄有效(this: void, 句柄: any): boolean {
  return 句柄 != null && 句柄 !== 0;
}

function 增加玩家资源(this: void, 玩家ID: number, 状态: number, 数量: number): void {
  const 玩家 = Player(玩家ID);
  SetPlayerState(玩家, 状态, GetPlayerState(玩家, 状态) + 数量);
}

function 给予探索物品(this: void, 单位: any, 物品名: string): boolean {
  const 物品ID = 按名字反查物品ID(物品名);
  if (物品ID == null) return false;
  const 物品 = 创建物品并注册排泄监听(解析配置内部ID(物品ID), GetUnitX(单位), GetUnitY(单位));
  if (!句柄有效(物品)) return false;
  UnitAddItem(单位, 物品);
  return true;
}

function 处理走私账册调查(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  增加玩家资源(玩家ID, PLAYER_STATE_RESOURCE_GOLD, 15000);
  增加玩家资源(玩家ID, PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(
    Player(玩家ID),
    施法单位,
    "|cffcc99ff『走私账册』：|r账册的封皮已经泡软，里面没有货物清单，只有几组反复出现的分账记录。最后一页标着佣兵团遇袭的日期，旁边写着：清空退路，等首领验货。|n|cffffff00获得15000金币、1能量碎片。|r",
    提示持续毫秒,
  );
  return true;
}

function 处理黑水退路调查(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  调整玩家属性(施法单位, "生命恢复", 10);
  增加玩家资源(玩家ID, PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(
    Player(玩家ID),
    施法单位,
    "|cff66ccff『黑水退路』：|r黑水从岩缝里缓慢渗出，水面没有洞窟里的蓝光。沿着水痕看去，岩壁上留着几道新鲜的拖擦痕，像是有人把沉重的箱子从这里运了出去。|n|cffffff00生命恢复永久+10，获得1能量碎片。|r",
    提示持续毫秒,
  );
  return true;
}

function 清理染血通行牌遭遇单位(this: void): void {
  for (let i = 0; i < 染血通行牌遭遇单位列表.length; i++) {
    const 单位 = 染血通行牌遭遇单位列表[i];
    if (句柄有效(单位)) 立即移除单位并取消排泄登记(单位);
  }
  染血通行牌遭遇单位列表.length = 0;
}

function 结算染血通行牌遭遇(this: void): void {
  if (染血通行牌已结算 || 染血通行牌遭遇单位列表.length > 0) return;
  染血通行牌已结算 = true;
  染血通行牌遭遇已创建 = false;
  unregisterDeathListener(处理染血通行牌遭遇死亡);
  注销环境互动调查点(染血通行牌点位ID);
  if (染血通行牌遭遇英雄 == null || 染血通行牌遭遇玩家ID < 0) return;

  const 玩家ID = 染血通行牌遭遇玩家ID;
  const 英雄 = 染血通行牌遭遇英雄;
  染血通行牌遭遇英雄 = null;
  染血通行牌遭遇玩家ID = -1;
  增加玩家资源(玩家ID, PLAYER_STATE_RESOURCE_GOLD, 20000);
  给予探索物品(英雄, "盗贼神符（魔抗）");
  发送单位提示给玩家(
    Player(玩家ID),
    英雄,
    "|cffff6666『染血通行牌』：|r最后一名骷髅盗贼倒下，通行牌上的血痕终于不再渗出。附近的盗贼已经被清除。|n|cffffff00获得20000金币、盗贼神符（魔抗）。|r",
    提示持续毫秒,
  );
}

function 处理染血通行牌遭遇死亡(this: void, 死亡单位: any, _击杀单位: any): void {
  if (!染血通行牌遭遇已创建 || 染血通行牌已结算) return;
  for (let i = 0; i < 染血通行牌遭遇单位列表.length; i++) {
    if (染血通行牌遭遇单位列表[i] !== 死亡单位) continue;
    染血通行牌遭遇单位列表.splice(i, 1);
    break;
  }
  if (染血通行牌遭遇单位列表.length === 0) 结算染血通行牌遭遇();
}

function 处理染血通行牌调查(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (染血通行牌遭遇已创建 || 染血通行牌已结算) return false;
  if (盗贼洞窟杂兵类型ID <= 0) return false;

  for (let i = 0; i < 染血通行牌杂兵偏移列表.length; i++) {
    const 偏移 = 染血通行牌杂兵偏移列表[i];
    const 单位 = 创建单位并登记排泄安全(
      玩家中立敌对,
      盗贼洞窟杂兵类型ID,
      染血通行牌X + 偏移[0],
      染血通行牌Y + 偏移[1],
      偏移[2],
    );
    if (!句柄有效(单位)) {
      清理染血通行牌遭遇单位();
      return false;
    }
    染血通行牌遭遇单位列表.push(单位);
  }

  染血通行牌遭遇英雄 = 施法单位;
  染血通行牌遭遇玩家ID = 玩家ID;
  染血通行牌遭遇已创建 = true;
  registerDeathListener(处理染血通行牌遭遇死亡);
  发送单位提示给玩家(
    Player(玩家ID),
    施法单位,
    "|cffff6666『染血通行牌』：|r通行牌上的血已经干了，边缘却有一道新裂痕。你触碰牌面时，远处传来短促的金属碰撞声，洞里还有盗贼没有离开。|n|cffffff00击败出现的骷髅盗贼，清理这条通道。|r",
    提示持续毫秒,
  );
  return false;
}

function 莫尔特斯已死亡(this: void): boolean {
  const Boss单位 = 读取当前莫尔特斯任务Boss();
  if (!句柄有效(Boss单位)) return false;
  return GetWidgetLife(Boss单位) <= 0.405 || IsUnitType(Boss单位, UNIT_TYPE_DEAD) === true;
}

function 处理旧战旗残誓调查(this: void, 玩家ID: number, 施法单位: any, _调查点: any): boolean {
  if (!莫尔特斯已死亡()) return false;
  if (!给予探索物品(施法单位, "影旗追猎徽记")) return false;
  发送单位提示给玩家(
    Player(玩家ID),
    施法单位,
    "|cffcc99ff『旧战旗残誓』：|r战旗背面缝着一段没有完成的誓文，最后一句被利器划断：首领倒下之后，活着的人不再守护任何东西，只带走自己能拿走的财物。旗杆底部还藏着一枚未曾交出的追猎徽记。|n|cffffff00获得影旗追猎徽记。|r",
    提示持续毫秒,
  );
  return true;
}

/** 注册盗贼洞窟四个世界级一次性环境互动点。 */
export function 注册盗贼洞窟探索点(this: void): void {
  注册环境互动调查点({
    ID: 走私账册点位ID,
    X: 29344.9,
    Y: -24512.3,
    一次性: true,
    触发回调: 处理走私账册调查,
  });
  注册环境互动调查点({
    ID: 黑水退路点位ID,
    X: 24419.0,
    Y: -24890.9,
    一次性: true,
    触发回调: 处理黑水退路调查,
  });
  注册环境互动调查点({
    ID: 染血通行牌点位ID,
    X: 染血通行牌X,
    Y: 染血通行牌Y,
    一次性: true,
    触发回调: 处理染血通行牌调查,
  });
  注册环境互动调查点({
    ID: 旧战旗残誓点位ID,
    X: 29401.5,
    Y: -22635.5,
    一次性: true,
    触发回调: 处理旧战旗残誓调查,
  });
}

export {};
