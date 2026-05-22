/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, cb: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { ModifyGateBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  ModifyGateBJ: (this: void, gateOperation: number, d: any) => void;
};
const { 按名字反查杂鱼单位ID } = require("系统.01．单位系统.08．单位配置表.00．杂鱼配置表") as {
  按名字反查杂鱼单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查精英单位ID } = require("系统.01．单位系统.08．单位配置表.01．精英配置表") as {
  按名字反查精英单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查Boss单位ID } = require("系统.01．单位系统.08．单位配置表.02．Boss配置表") as {
  按名字反查Boss单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查异界Boss单位ID } = require("系统.01．单位系统.08．单位配置表.03．异界Boss配置表") as {
  按名字反查异界Boss单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查玩家英雄单位ID } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置") as {
  按名字反查玩家英雄单位ID: (this: void, name: string) => string | undefined;
};

import { 剧情物品掉落配置表, type 剧情物品掉落动作配置, type 剧情物品掉落配置 } from "./00．配置表";

const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const GetRandomInt = jass.GetRandomInt as (this: void, lowBound: number, highBound: number) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, whichUnit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, whichUnit: any, whichType: any) => boolean;
const IsUnitIllusion = jass["IsUnitIllusion"] as (this: void, whichUnit: any) => boolean;
const Player = jass.Player as (this: void, number: number) => any;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const UNIT_TYPE_SUMMONED = jass.UNIT_TYPE_SUMMONED as number;
const bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN as number;

interface 已解析剧情物品掉落动作配置 extends 剧情物品掉落动作配置 {
  物品类型ID?: number;
}

interface 已解析剧情物品掉落配置 extends 剧情物品掉落配置 {
  触发单位类型ID: number;
  动作列表: 已解析剧情物品掉落动作配置[];
}

const 已解析配置表: 已解析剧情物品掉落配置[] = [];
let 已初始化剧情物品掉落 = false;

function 按名字反查任意单位ID(this: void, name: string): string | undefined {
  return 按名字反查杂鱼单位ID(name)
    ?? 按名字反查精英单位ID(name)
    ?? 按名字反查Boss单位ID(name)
    ?? 按名字反查异界Boss单位ID(name)
    ?? 按名字反查玩家英雄单位ID(name);
}

function 初始化配置缓存(this: void): void {
  if (已解析配置表.length > 0) return;

  for (let i = 0; i < 剧情物品掉落配置表.length; i++) {
    const 配置 = 剧情物品掉落配置表[i];
    const 触发单位原始ID = 按名字反查任意单位ID(配置.触发单位名);
    const 触发单位类型ID = stringToFourCCSafe(触发单位原始ID);
    if (触发单位类型ID === 0) continue;

    const 动作列表: 已解析剧情物品掉落动作配置[] = [];
    for (let j = 0; j < 配置.动作列表.length; j++) {
      const 动作 = 配置.动作列表[j];
      if (动作.动作类型 === "掉落物品") {
        动作列表.push({
          ...动作,
          物品类型ID: stringToFourCCSafe(按名字反查物品ID(动作.物品名 ?? "")),
        });
        continue;
      }
      动作列表.push({ ...动作 });
    }

    已解析配置表.push({
      ...配置,
      触发单位类型ID,
      动作列表,
    });
  }
}

function 读取剧情进度(this: void): number {
  return Number(YDUserDataGetSafe("string", "剧情进度", "整数", "integer")) || 0;
}

function 德鲁伊学者属于中立被动(this: void): boolean {
  const 学者单位 = YDUserDataGetSafe("string", "支线NPC", "德鲁伊学者", "unit");
  if (学者单位 == null || 学者单位 === 0) return false;
  return GetOwningPlayer(学者单位) === Player(PLAYER_NEUTRAL_PASSIVE);
}

function 满足动作前置(this: void, 动作: 已解析剧情物品掉落动作配置): boolean {
  if ((动作.要求剧情进度至少 ?? 0) > 0 && 读取剧情进度() < (动作.要求剧情进度至少 ?? 0)) {
    return false;
  }

  if (动作.屏蔽条件 === "德鲁伊学者属于中立被动" && 德鲁伊学者属于中立被动()) {
    return false;
  }

  const 概率 = 动作.掉落概率 ?? 100;
  if (概率 < 100 && GetRandomInt(1, 100) > 概率) {
    return false;
  }

  return true;
}

function 执行掉落物品动作(this: void, dyingUnit: any, 动作: 已解析剧情物品掉落动作配置): void {
  if ((动作.物品类型ID ?? 0) === 0) return;
  创建物品并注册排泄监听(动作.物品类型ID ?? 0, GetUnitX(dyingUnit), GetUnitY(dyingUnit));
}

function 读取全局可破坏物(this: void, 全局名: string): any {
  return jglobals[全局名];
}

function 执行开启大门动作(this: void, 动作: 已解析剧情物品掉落动作配置): void {
  const 大门列表 = 动作.大门全局名列表 ?? [];
  for (let i = 0; i < 大门列表.length; i++) {
    const 大门 = 读取全局可破坏物(大门列表[i]);
    if (大门 == null || 大门 === 0) continue;
    ModifyGateBJ(bj_GATEOPERATION_OPEN, 大门);
  }
}

function 执行动作(this: void, dyingUnit: any, 动作: 已解析剧情物品掉落动作配置): void {
  if (!满足动作前置(动作)) return;

  if (动作.动作类型 === "掉落物品") {
    执行掉落物品动作(dyingUnit, 动作);
    return;
  }

  if (动作.动作类型 === "开启大门") {
    执行开启大门动作(动作);
  }
}

function 处理剧情物品掉落(this: void, dyingUnit: any): void {
  const dyingTypeId = GetUnitTypeId(dyingUnit);
  for (let i = 0; i < 已解析配置表.length; i++) {
    const 配置 = 已解析配置表[i];
    if (配置.触发单位类型ID !== dyingTypeId) continue;

    for (let j = 0; j < 配置.动作列表.length; j++) {
      执行动作(dyingUnit, 配置.动作列表[j]);
    }
  }
}

function on剧情单位死亡(this: void, dyingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  if (IsUnitType(dyingUnit, UNIT_TYPE_SUMMONED)) return;
  if (IsUnitIllusion(dyingUnit)) return;

  初始化配置缓存();
  处理剧情物品掉落(dyingUnit);
}

export function init剧情物品掉落(this: void): void {
  if (已初始化剧情物品掉落) return;
  已初始化剧情物品掉落 = true;
  初始化配置缓存();
  registerDeathListener(on剧情单位死亡);
}

export {};
