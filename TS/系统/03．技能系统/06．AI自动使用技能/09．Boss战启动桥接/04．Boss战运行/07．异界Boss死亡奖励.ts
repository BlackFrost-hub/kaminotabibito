/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, forceHandle: any, messageType: number, message: string) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 增加英雄基础全属性 } = require("lib.扩展函数.自定义扩展函数.index") as {
  增加英雄基础全属性: (this: void, unit: any, value: number) => void;
};
const {
  异界Boss战斗启动属性配置表,
  异界Boss死亡奖励提示文案模板,
  异界Boss默认死亡奖励基础全属性,
} = require("../03．战斗启动属性/03．异界Boss战斗启动属性配置表") as {
  异界Boss战斗启动属性配置表: Array<{
    单位ID?: string;
    死亡后所有玩家英雄基础全属性?: number;
  }>;
  异界Boss死亡奖励提示文案模板: string;
  异界Boss默认死亡奖励基础全属性: number;
};

const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const ForGroup = jass.ForGroup as (whichGroup: any, callback: () => void) => void;
const GetEnumUnit = jass.GetEnumUnit as () => any;

let 当前异界Boss死亡奖励值 = 0;

function 读取玩家英雄组(this: void): any {
  return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
}

function on发放异界Boss死亡奖励英雄(this: void): void {
  const unit = GetEnumUnit();
  if (unit == null || unit === 0) return;
  增加英雄基础全属性(unit, 当前异界Boss死亡奖励值);
}

function 获取异界Boss死亡奖励值(this: void, bossUnit: any): number {
  const unitTypeId = GetUnitTypeId(bossUnit) || 0;
  if (unitTypeId === 0) return 0;

  for (let i = 0; i < 异界Boss战斗启动属性配置表.length; i++) {
    const 配置 = 异界Boss战斗启动属性配置表[i];
    if (配置.单位ID == null || 配置.单位ID === "") continue;
    if (stringToFourCCSafe(配置.单位ID) !== unitTypeId) continue;
    return 配置.死亡后所有玩家英雄基础全属性 ?? 0;
  }

  return 0;
}

export function 发放异界Boss死亡奖励(this: void, bossUnit: any): boolean {
  const 奖励值 = 获取异界Boss死亡奖励值(bossUnit);
  if (奖励值 <= 0) return false;

  当前异界Boss死亡奖励值 = 奖励值;

  const 玩家英雄组 = 读取玩家英雄组();
  if (玩家英雄组 != null && 玩家英雄组 !== 0) {
    ForGroup(玩家英雄组, on发放异界Boss死亡奖励英雄);
  }

  const 提示文本 = "|cffffff00『系统提示』：|r|cffffcc99" + 异界Boss死亡奖励提示文案模板.replace("{value}", String(奖励值 || 异界Boss默认死亡奖励基础全属性)) + "|r";
  QuestMessageBJ(GetPlayersAll(), jglobals.bj_QUESTMESSAGE_ITEMACQUIRED, 提示文本);
  当前异界Boss死亡奖励值 = 0;
  return true;
}
