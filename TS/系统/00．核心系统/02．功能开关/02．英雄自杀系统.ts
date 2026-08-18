/** @noSelfInFile */

const jass = require("jass.common") as any;
const 获取本地玩家 = jass.GetLocalPlayer as () => any;

const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};

const 聊天命令事件中心 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};

const KillUnit = jass.KillUnit as (unit: any) => void;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const Player = jass.Player as (playerId: number) => any;
const 命令 = "-zs";
const 精神伤害命令 = "-自杀";
const 精神伤害数值 = 99999;
const 自杀伤害马甲单位ID = stringToFourCCSafe("hfoo");
const 自杀伤害马甲玩家 = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE);
const 提示时间 = 5;

function 使用自杀伤害马甲(hero: any): void {
  const avatar = 创建单位并登记排泄安全(
    自杀伤害马甲玩家,
    自杀伤害马甲单位ID,
    GetUnitX(hero),
    GetUnitY(hero),
    0,
  );
  if (avatar == null || avatar === 0) return;

  造成技能伤害({
    来源: avatar,
    目标: hero,
    伤害: 精神伤害数值,
    伤害类型: jass.DAMAGE_TYPE_MIND,
    attack: false,
    ranged: false,
    attackType: jass.ATTACK_TYPE_NORMAL,
    weaponType: jass.WEAPON_TYPE_WHOKNOWS,
    来源类型: "其他",
    标签: "测试命令-自杀",
    伤害形态: "单体",
    参与技能伤害加成: false,
  });

  addDelayedCallback(500, function 延迟移除自杀伤害马甲(this: void): void {
    立即移除单位并取消排泄登记(avatar);
  });
}

function 自杀命令(this: void, whichPlayer: any, command: string): void {
  const hero = getRegisteredPlayerHero(whichPlayer);
  if (hero == null || hero === 0) {
    jass.DisplayTimedTextToPlayer(whichPlayer, 0, 0.02, 提示时间, "|cffffff00『系统提示』|r：没有找到英雄！");
    return;
  }

  if (jass.IsUnitType(hero, jass.UNIT_TYPE_DEAD)) {
    jass.DisplayTimedTextToPlayer(whichPlayer, 0, 0.02, 提示时间, "|cffffff00『系统提示』|r：英雄已死亡！");
    return;
  }

  if (command === 精神伤害命令) {
    使用自杀伤害马甲(hero);
    return;
  }

  KillUnit(hero);
}

export function 初始化自杀命令(this: void): void {
  聊天命令事件中心.注册聊天命令监听(命令, 自杀命令);
  聊天命令事件中心.注册聊天命令监听(精神伤害命令, 自杀命令);
}

export {};
