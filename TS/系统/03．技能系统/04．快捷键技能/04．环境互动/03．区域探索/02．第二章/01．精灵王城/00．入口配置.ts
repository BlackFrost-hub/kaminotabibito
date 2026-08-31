/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 注册环境互动调查点 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心") as {
  注册环境互动调查点: (this: void, 调查点: any) => boolean;
};
const { 环境互动装备奖励概率 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置") as {
  环境互动装备奖励概率: number;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, 物品名: string) => string | undefined;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, 物品类型ID: number, X: number, Y: number) => any;
};
const { 发送单位提示给玩家 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送单位提示给玩家: (this: void, 目标玩家: any, 来源单位: any, 文本: string, 持续时间?: number) => void;
};
const { 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整玩家属性: (this: void, 单位: any, 属性名: string, 增量: number) => void;
};

const Player = jass.Player as (this: void, 玩家ID: number) => any;
const GetPlayerState = jass.GetPlayerState as (this: void, 玩家: any, 状态: number) => number;
const SetPlayerState = jass.SetPlayerState as (this: void, 玩家: any, 状态: number, 数值: number) => void;
const GetUnitX = jass.GetUnitX as (this: void, 单位: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, 单位: any) => number;
const UnitAddItem = jass.UnitAddItem as (this: void, 单位: any, 物品: any) => boolean;
const GetUnitState = jass.GetUnitState as (this: void, 单位: any, 状态: number) => number;
const SetUnitState = jass.SetUnitState as (this: void, 单位: any, 状态: number, 数值: number) => void;
const GetHeroInt = jass.GetHeroInt as (this: void, 英雄: any, 包含加成: boolean) => number;
const SetHeroInt = jass.SetHeroInt as (this: void, 英雄: any, 数值: number, 永久: boolean) => void;

const PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD as number;
const PLAYER_STATE_RESOURCE_LUMBER = jass.PLAYER_STATE_RESOURCE_LUMBER as number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as number;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as number;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as number;

const 王城探索提示持续毫秒 = 5200;

function 增加玩家资源(this: void, 玩家: any, 状态: number, 数量: number): void {
  const 当前数量 = GetPlayerState(玩家, 状态);
  SetPlayerState(玩家, 状态, 当前数量 + 数量);
}

function 给予探索物品(this: void, 单位: any, 物品名: string): boolean {
  const 物品ID = 按名字反查物品ID(物品名);
  if (物品ID == null) return false;
  const 物品 = 创建物品并注册排泄监听(解析配置内部ID(物品ID), GetUnitX(单位), GetUnitY(单位));
  if (物品 == null || 物品 === 0) return false;
  UnitAddItem(单位, 物品);
  return true;
}

function 处理城墙旧械调查(this: void, 玩家ID: number, 施法单位: any, 调查点: any): boolean {
  const 玩家 = Player(玩家ID);
  增加玩家资源(玩家, PLAYER_STATE_RESOURCE_GOLD, 10000);
  增加玩家资源(玩家, PLAYER_STATE_RESOURCE_LUMBER, 1);
  发送单位提示给玩家(
    玩家,
    施法单位,
    "|cffffcc00『城墙旧械』：|r这架城防器械的锁扣留有新鲜磨痕，受力方向却来自城内。有人曾绕过守卫，从内侧动过它。你在夹层中找到一袋遗落的钱币和一枚能量碎片。|n|cffffff00获得10000金币、1能量碎片。|r",
    王城探索提示持续毫秒,
  );
  return true;
}

function 处理花圃花牌调查(this: void, 玩家ID: number, 施法单位: any, 调查点: any): boolean {
  const 玩家 = Player(玩家ID);
  if (!给予探索物品(施法单位, "月影花")) return false;
  增加玩家资源(玩家, PLAYER_STATE_RESOURCE_GOLD, 5000);
  发送单位提示给玩家(
    玩家,
    施法单位,
    "|cffccffff『王城花圃』：|r泥土里压着一块折断的园丁花牌。背面的交接日期被人匆忙刮去，花圃似乎曾在无人知晓的时段换过看守。花牌旁还有一朵保存完好的月影花。|n|cffffff00获得5000金币、1朵月影花。|r",
    王城探索提示持续毫秒,
  );
  return true;
}

function 处理古树祭坛调查(this: void, 玩家ID: number, 施法单位: any, 调查点: any): boolean {
  const 玩家 = Player(玩家ID);
  SetHeroInt(施法单位, GetHeroInt(施法单位, false) + 2, true);
  发送单位提示给玩家(
    玩家,
    施法单位,
    "|cff99ff99『古树祭坛回响』：|r发光符文中的灵力并非自然消散，而是被某种力量从中途切断。残存的回响沿着掌心融入意识，也让你记住了这条异常的灵力流向。|n|cffffff00永久智力+2。|r",
    王城探索提示持续毫秒,
  );
  return true;
}

function 处理王庭圣泉调查(this: void, 玩家ID: number, 施法单位: any, 调查点: any): boolean {
  const 玩家 = Player(玩家ID);
  if (!给予探索物品(施法单位, "精灵王城三花灵药")) return false;
  SetUnitState(施法单位, UNIT_STATE_LIFE, GetUnitState(施法单位, UNIT_STATE_MAX_LIFE));
  SetUnitState(施法单位, UNIT_STATE_MANA, GetUnitState(施法单位, UNIT_STATE_MAX_MANA));
  发送单位提示给玩家(
    玩家,
    施法单位,
    "|cffccffff『王庭圣泉』：|r指尖触及水面的瞬间，一缕黑色异痕从泉底掠过，随即被重新涌出的清流冲散。泉水恢复纯净，池沿的精灵灵药也重新显露出来。|n|cffffff00生命与魔法完全恢复；获得1瓶精灵王城三花灵药。|r",
    王城探索提示持续毫秒,
  );
  return true;
}

function 处理书房旧档调查(this: void, 玩家ID: number, 施法单位: any, 调查点: any): boolean {
  const 玩家 = Player(玩家ID);
  if (!给予探索物品(施法单位, "封印旧档书签")) return false;
  发送单位提示给玩家(
    玩家,
    施法单位,
    "|cffccffff『书房旧档』：|r书架底层藏着一份被拆散的旧档。“西利乌斯”与“自愿封印”仍能从残页中辨认出来，但最关键的署名已被撕去。夹在档案中的书签仍封存着一缕旧日秘术。|n|cffffff00获得封印旧档书签。|r",
    王城探索提示持续毫秒,
  );
  return true;
}

function 处理议事厅残卷调查(this: void, 玩家ID: number, 施法单位: any, 调查点: any): boolean {
  const 玩家 = Player(玩家ID);
  调整玩家属性(施法单位, "暴击率", 0.02);
  调整玩家属性(施法单位, "命中率", 0.05);
  发送单位提示给玩家(
    玩家,
    施法单位,
    "|cffffcc99『议事厅残卷』：|r城西巡逻路线并非遗漏，而是被人刻意留出了一段空白。沿着残卷上的调度规律推演，你找到了守卫视线交替时最容易被忽略的间隙。|n|cffffff00永久暴击率+2%、命中率+5%。|r",
    王城探索提示持续毫秒,
  );
  return true;
}

function 处理王庭誓旗调查(this: void, 玩家ID: number, 施法单位: any, 调查点: any): boolean {
  const 玩家 = Player(玩家ID);
  if (!给予探索物品(施法单位, "王庭旧誓徽章")) return false;
  发送单位提示给玩家(
    玩家,
    施法单位,
    "|cff99ccff『王庭誓旗』：|r褪色的誓文仍清晰写着：灾厄来临时，王庭卫队应先护送平民撤离，而非固守王宫。旗座内留存的旧徽章见证过这道命令。|n|cffffff00获得王庭旧誓徽章。|r",
    王城探索提示持续毫秒,
  );
  return true;
}

/** 注册精灵王城的世界级一次性探索点；首次成功触发后由核心立即注销。 */
export function 注册精灵王城探索点(this: void): void {
  注册环境互动调查点({
    ID: "精灵王城.城墙旧械",
    X: -15248.4,
    Y: -7513.1,
    一次性: true,
    触发回调: 处理城墙旧械调查,
  });
  注册环境互动调查点({
    ID: "精灵王城.花圃遗落花牌",
    X: -15566.2,
    Y: -7841.0,
    一次性: true,
    触发回调: 处理花圃花牌调查,
  });
  注册环境互动调查点({
    ID: "精灵王城.古树祭坛回响",
    X: -8794.7,
    Y: -8694.0,
    一次性: true,
    触发回调: 处理古树祭坛调查,
  });
  注册环境互动调查点({
    ID: "精灵王城.王庭圣泉",
    X: -4483.8,
    Y: -7045.8,
    一次性: true,
    触发回调: 处理王庭圣泉调查,
  });
  注册环境互动调查点({
    ID: "精灵王城.书房旧档",
    X: 14301.1,
    Y: -22922.7,
    一次性: true,
    一次性奖励概率: 环境互动装备奖励概率,
    触发回调: 处理书房旧档调查,
  });
  注册环境互动调查点({
    ID: "精灵王城.议事厅残卷",
    X: 12939.1,
    Y: -24109.9,
    一次性: true,
    触发回调: 处理议事厅残卷调查,
  });
  注册环境互动调查点({
    ID: "精灵王城.王庭誓旗",
    X: 17804.7,
    Y: -23856.4,
    一次性: true,
    一次性奖励概率: 环境互动装备奖励概率,
    触发回调: 处理王庭誓旗调查,
  });
}

export {};
