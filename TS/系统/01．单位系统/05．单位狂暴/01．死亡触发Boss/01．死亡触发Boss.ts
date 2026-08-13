/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, cb: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};
const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
  getServerTime: (this: void) => number;
};
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (this: void, s: string) => number;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
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

import { 死亡触发Boss配置表, type 死亡触发Boss配置 } from "./00．配置表";

const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const GetHeroLevel = jass.GetHeroLevel as (whichHero: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const GetRandomInt = jass.GetRandomInt as (lowBound: number, highBound: number) => number;
const GetUnitFacing = jass.GetUnitFacing as (whichUnit: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const GroupAddUnit = jass.GroupAddUnit as (whichGroup: any, whichUnit: any) => void;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichType: any) => boolean;

interface 已解析死亡触发Boss配置 extends 死亡触发Boss配置 {
  触发单位类型ID: number;
  Boss单位类型ID: number;
}

interface Boss延迟说话记录 {
  到期时间: number;
  Boss单位: any;
  文本: string;
  持续时间Ms?: number;
}

const 已解析配置表: 已解析死亡触发Boss配置[] = [];
const 死亡累计表: Record<string, number> = {};
const 已触发配置表: Record<string, boolean> = {};
const Boss延迟说话队列: Boss延迟说话记录[] = [];

function 按名字反查任意单位ID(this: void, name: string): string | undefined {
  return 按名字反查杂鱼单位ID(name)
    ?? 按名字反查精英单位ID(name)
    ?? 按名字反查Boss单位ID(name)
    ?? 按名字反查异界Boss单位ID(name);
}

function 初始化配置缓存(this: void): void {
  if (已解析配置表.length > 0) return;

  for (let i = 0; i < 死亡触发Boss配置表.length; i++) {
    const 配置 = 死亡触发Boss配置表[i];
    const 触发单位ID = 配置.触发单位ID ?? 按名字反查任意单位ID(配置.触发单位名);
    const Boss单位ID = 按名字反查任意单位ID(配置.Boss单位名);
    if (触发单位ID == null || Boss单位ID == null) continue;

    已解析配置表.push({
      ...配置,
      触发单位类型ID: stringToFourCC(触发单位ID),
      Boss单位类型ID: stringToFourCC(Boss单位ID),
    });
  }
}

function 取出现坐标(this: void, 配置: 已解析死亡触发Boss配置, dyingUnit: any, killingUnit: any): [number, number] {
  if (配置.出现位置类型 === "固定坐标") {
    return [配置.固定X ?? 0, 配置.固定Y ?? 0];
  }
  if (配置.出现位置类型 === "死亡单位当前位置" || killingUnit == null || killingUnit === 0) {
    return [GetUnitX(dyingUnit), GetUnitY(dyingUnit)];
  }
  return [GetUnitX(killingUnit), GetUnitY(killingUnit)];
}

function 取出现朝向(this: void, 配置: 已解析死亡触发Boss配置, dyingUnit: any, killingUnit: any): number {
  if (配置.固定朝向 != null) return 配置.固定朝向;
  if (killingUnit != null && killingUnit !== 0) return GetUnitFacing(killingUnit);
  return GetUnitFacing(dyingUnit);
}

function 加入血条Boss组(this: void, unit: any): void {
  const bossGroup = YDUserDataGetSafe("string", "血条Boss", "单位组", "group");
  if (bossGroup == null || bossGroup === 0) return;
  GroupAddUnit(bossGroup, unit);
}

function 处理Boss延迟说话队列(this: void): void {
  const now = getServerTime();
  let writeIndex = 0;

  for (let i = 0; i < Boss延迟说话队列.length; i++) {
    const 记录 = Boss延迟说话队列[i];
    if (now >= 记录.到期时间) {
      广播单位提示(记录.Boss单位, 记录.文本, 记录.持续时间Ms);
      continue;
    }
    Boss延迟说话队列[writeIndex] = 记录;
    writeIndex++;
  }

  for (let i = Boss延迟说话队列.length - 1; i >= writeIndex; i--) {
    Boss延迟说话队列.pop();
  }
}

function 安排Boss延迟说话(this: void, boss: any, 配置: 已解析死亡触发Boss配置): void {
  const 延迟Ms = 配置.Boss说话延迟Ms ?? 0;
  if (延迟Ms <= 0) {
    广播单位提示(boss, 配置.Boss说话文本, 配置.广播持续时间Ms);
    return;
  }

  Boss延迟说话队列.push({
    到期时间: getServerTime() + 延迟Ms,
    Boss单位: boss,
    文本: 配置.Boss说话文本,
    持续时间Ms: 配置.广播持续时间Ms,
  });
  addDelayedCallback(延迟Ms, 处理Boss延迟说话队列);
}

function 广播Boss出现文本(this: void, boss: any, 配置: 已解析死亡触发Boss配置): void {
  广播单位提示(boss, 配置.出现提示文本, 配置.广播持续时间Ms);
  安排Boss延迟说话(boss, 配置);
}

function 创建Boss并广播(this: void, 配置: 已解析死亡触发Boss配置, dyingUnit: any, killingUnit: any): void {
  const 出现坐标 = 取出现坐标(配置, dyingUnit, killingUnit);
  const x = 出现坐标[0];
  const y = 出现坐标[1];
  const facing = 取出现朝向(配置, dyingUnit, killingUnit);
  const owner = GetOwningPlayer(dyingUnit);
  const boss = CreateUnit(owner, 配置.Boss单位类型ID, x, y, facing);
  if (boss == null || boss === 0) return;

  if (配置.需要加入血条Boss组 !== false) {
    加入血条Boss组(boss);
  }

  if (配置.出场特效模型 != null && 配置.出场特效模型 !== "") {
    const effect = AddSpecialEffect(配置.出场特效模型, x, y);
    if (effect != null && effect !== 0) {
      DestroyEffect(effect);
    }
  }

  广播Boss出现文本(boss, 配置);
  if (配置.只触发一次 !== false) {
    已触发配置表[配置.配置ID] = true;
  }
}

function 满足概率触发条件(this: void, 配置: 已解析死亡触发Boss配置, killingUnit: any): boolean {
  if (已触发配置表[配置.配置ID] === true && 配置.只触发一次 !== false) return false;
  if (killingUnit == null || killingUnit === 0) return false;
  if (!IsUnitType(killingUnit, jass.UNIT_TYPE_HERO)) return false;

  const heroLevel = GetHeroLevel(killingUnit);
  if (配置.击杀者最低英雄等级 != null && heroLevel < 配置.击杀者最低英雄等级) return false;
  if (配置.击杀者最高英雄等级 != null && heroLevel > 配置.击杀者最高英雄等级) return false;

  const chance = 配置.出现概率 ?? 0;
  if (chance <= 0) return false;
  return GetRandomInt(1, 100) <= chance;
}

function 处理累计触发(this: void, 配置: 已解析死亡触发Boss配置, dyingUnit: any, killingUnit: any): void {
  if (已触发配置表[配置.配置ID] === true && 配置.只触发一次 !== false) return;
  const nextCount = (死亡累计表[配置.配置ID] ?? 0) + 1;
  死亡累计表[配置.配置ID] = nextCount;
  if (nextCount < (配置.累计数量 ?? 0)) return;

  死亡累计表[配置.配置ID] = 0;
  创建Boss并广播(配置, dyingUnit, killingUnit);
}

function 处理概率触发(this: void, 配置: 已解析死亡触发Boss配置, dyingUnit: any, killingUnit: any): void {
  if (!满足概率触发条件(配置, killingUnit)) return;
  创建Boss并广播(配置, dyingUnit, killingUnit);
}

function onDeath(this: void, dyingUnit: any, killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  初始化配置缓存();

  const dyingTypeId = GetUnitTypeId(dyingUnit);
  for (let i = 0; i < 已解析配置表.length; i++) {
    const 配置 = 已解析配置表[i];
    if (配置.触发单位类型ID !== dyingTypeId) continue;

    if (配置.触发类型 === "累计数量") {
      处理累计触发(配置, dyingUnit, killingUnit);
      continue;
    }

    if (配置.触发类型 === "概率") {
      处理概率触发(配置, dyingUnit, killingUnit);
    }
  }
}

registerDeathListener(onDeath);

export {};
