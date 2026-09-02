/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 注册环境互动调查点 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心") as {
  注册环境互动调查点: (this: void, 调查点: any) => boolean;
};
const { 环境互动装备奖励概率 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置") as {
  环境互动装备奖励概率: number;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, 物品类型ID: number, X: number, Y: number) => any;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, 表名: string, 键: any, 属性名: string, 类型: string) => any;
  YDUserDataSetSafe: (this: void, 表名: string, 键: any, 属性名: string, 类型: string, 值: any) => void;
};
const { 发送单位提示给玩家 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送单位提示给玩家: (this: void, 目标玩家: any, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

const GetUnitState = jass.GetUnitState as (this: void, 单位: any, 状态: number) => number;
const SetUnitState = jass.SetUnitState as (this: void, 单位: any, 状态: number, 值: number) => void;
const UnitAddItem = jass.UnitAddItem as (this: void, 单位: any, 物品: any) => boolean;
const Player = jass.Player as (this: void, 玩家ID: number) => any;
const GetUnitX = jass.GetUnitX as (this: void, 单位: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, 单位: any) => number;

const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as number;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as number;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as number;

/** 血坛奖励：攻击/续航向白嫖饰品，C+ 档。 */
const 祭血之皿物品ID = "I0G8";
/** 池底遗物奖励：均衡/守护向白嫖饰品，C+ 档。 */
const 祖地纹章徽记物品ID = "I0HH";
/** 灵泉单次恢复的生命与魔法值。 */
const 灵泉恢复量 = 100;
/** 灵泉永久祝福：满状态首次互动时写入玩家属性表。 */
const 灵泉祝福生命恢复 = 10;
const 灵泉祝福魔法恢复 = 3;

const 祖地探索点提示持续毫秒 = 4500;

/** 玩家ID -> 是否已领取灵泉永久祝福。 */
const 灵泉祝福已领取表: Record<number, boolean> = {};

function 单位是否满血满蓝(this: void, 单位: any): boolean {
  return GetUnitState(单位, UNIT_STATE_LIFE) >= GetUnitState(单位, UNIT_STATE_MAX_LIFE) - 0.5
    && GetUnitState(单位, UNIT_STATE_MANA) >= GetUnitState(单位, UNIT_STATE_MAX_MANA) - 0.5;
}

function 恢复单位生命与魔法(this: void, 单位: any, 恢复量: number): void {
  const 目标生命 = GetUnitState(单位, UNIT_STATE_LIFE) + 恢复量;
  const 最大生命 = GetUnitState(单位, UNIT_STATE_MAX_LIFE);
  if (目标生命 < 最大生命) {
    SetUnitState(单位, UNIT_STATE_LIFE, 目标生命);
  } else {
    SetUnitState(单位, UNIT_STATE_LIFE, 最大生命);
  }
  const 目标魔法 = GetUnitState(单位, UNIT_STATE_MANA) + 恢复量;
  const 最大魔法 = GetUnitState(单位, UNIT_STATE_MAX_MANA);
  if (目标魔法 < 最大魔法) {
    SetUnitState(单位, UNIT_STATE_MANA, 目标魔法);
  } else {
    SetUnitState(单位, UNIT_STATE_MANA, 最大魔法);
  }
}

function 给予探索奖励物品(this: void, 单位: any, 物品ID: string): void {
  const 物品 = 创建物品并注册排泄监听(解析配置内部ID(物品ID), GetUnitX(单位), GetUnitY(单位));
  if (物品 != null && 物品 !== 0) UnitAddItem(单位, 物品);
}

function 处理血坛调查(this: void, 玩家ID: number, 施法单位: any, 调查点: any): boolean {
  void 调查点;
  给予探索奖励物品(施法单位, 祭血之皿物品ID);
  发送单位提示给玩家(
    Player(玩家ID),
    施法单位,
    "|cffffcc00『血坛低语』：|r坛上的血迹新旧交叠，最新的那层还没有干透。指尖触及的刹那，一段不属于任何活人的祷词掠过意识——他们在这里，向祖地之外的存在献祭。低语散去时，坛边多出了一只余温尚存的祭皿。",
    祖地探索点提示持续毫秒,
  );
  return true;
}

function 处理池底遗物调查(this: void, 玩家ID: number, 施法单位: any, 调查点: any): boolean {
  void 调查点;
  给予探索奖励物品(施法单位, 祖地纹章徽记物品ID);
  发送单位提示给玩家(
    Player(玩家ID),
    施法单位,
    "|cffccffff『调查发现』：|r你探入池底，摸到一枚冰凉的物件——刻着祖地鹿王纹章的旧徽记，链绳早已腐断。它为什么会沉在这里？",
    祖地探索点提示持续毫秒,
  );
  return true;
}

function 处理灵泉汲取(this: void, 玩家ID: number, 施法单位: any, 调查点: any): boolean {
  if (!单位是否满血满蓝(施法单位)) {
    恢复单位生命与魔法(施法单位, 灵泉恢复量);
    发送单位提示给玩家(
      Player(玩家ID),
      施法单位,
      "|cffccffff『灵泉汲取』：|r你以掌心贴近灵泉，水中残留的灵心余韵顺着指尖散入四肢，生命与魔法得到了舒缓。",
      祖地探索点提示持续毫秒,
    );
    return true;
  }
  if (灵泉祝福已领取表[玩家ID] !== true) {
    灵泉祝福已领取表[玩家ID] = true;
    const 玩家 = Player(玩家ID);
    const 当前生命恢复 = Number(YDUserDataGetSafe("player", 玩家, "生命恢复", "real")) || 0;
    YDUserDataSetSafe("player", 玩家, "生命恢复", "real", 当前生命恢复 + 灵泉祝福生命恢复);
    const 当前魔法恢复 = Number(YDUserDataGetSafe("player", 玩家, "魔法恢复", "real")) || 0;
    YDUserDataSetSafe("player", 玩家, "魔法恢复", "real", 当前魔法恢复 + 灵泉祝福魔法恢复);
    发送单位提示给玩家(
      Player(玩家ID),
      施法单位,
      "|cffccffff『灵泉祝福』：|r你的身心已与灵泉同频。泉水的余韵从此常驻你的血脉——生命恢复+10，魔法恢复+3。",
      祖地探索点提示持续毫秒,
    );
    return true;
  }
  发送单位提示给玩家(
    Player(玩家ID),
    施法单位,
    "|cffccffff『灵泉』：|r泉水的余韵已融入你的血脉，此刻的你无需更多。",
    祖地探索点提示持续毫秒,
  );
  return true;
}

/** 注册精灵祖地的常驻环境互动探索点；在环境互动初始化时调用。 */
export function 注册精灵祖地探索点(this: void): void {
  注册环境互动调查点({
    ID: "祖地.血坛",
    X: -26764.5,
    Y: -1976.2,
    一次性: true,
    一次性奖励概率: 环境互动装备奖励概率,
    触发回调: 处理血坛调查,
  });
  注册环境互动调查点({
    ID: "祖地.池底遗物",
    X: -27864.4,
    Y: -5418.7,
    一次性: true,
    一次性奖励概率: 环境互动装备奖励概率,
    触发回调: 处理池底遗物调查,
  });
  注册环境互动调查点({
    ID: "祖地.灵泉",
    X: -27942.8,
    Y: -3025.5,
    一次性: false,
    触发回调: 处理灵泉汲取,
  });
}

export {};
