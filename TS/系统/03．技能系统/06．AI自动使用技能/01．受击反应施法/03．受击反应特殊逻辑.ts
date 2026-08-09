/** @noSelfInFile */

import type { 受击反应配置 } from "./00．配置类型";

const jass = require("jass.common") as any;
const { getEnemyUnitsInRangeOfUnit } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRangeOfUnit: (this: void, centerUnit: any, radius: number) => any[];
};
const { GetUnitLifePercentBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  GetUnitLifePercentBJ: (this: void, whichUnit: any) => number;
};
const { 按名字反查BuffID } = require("系统.05．Buff系统.02．Buff数据表.01．Buff名反查工具") as {
  按名字反查BuffID: (this: void, name: string) => string | undefined;
};

import { 尝试执行受击技能, 取随机坐标偏移, 获取技能命令字串 } from "./04．受击反应执行";

const BUFF_BLOODLUST = 按名字反查BuffID("嗜血术") ?? "Bblo";
const IssuePointOrder = jass.IssuePointOrder as (whichUnit: any, order: string, x: number, y: number) => boolean;
const { 单位是否正在原生施法 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.施法状态") as {
  单位是否正在原生施法: (this: void, unit: any) => boolean;
};

const 特殊逻辑映射: Record<string, (this: void, config: 受击反应配置, unit: any, source: any) => boolean> = {};

function 蜘蛛女皇受击喷射(this: void, _config: 受击反应配置, unit: any, source: any): boolean {
  if (jass.GetRandomInt(1, 8) !== 1) return false;
  return 尝试执行受击技能({ 命令字串: "carrionswarm", 施法方式: "对点", 目标来源: "伤害来源坐标" }, unit, source);
}

function 蜥蜴怪物受击喷火(this: void, _config: 受击反应配置, unit: any, source: any): boolean {
  if (jass.GetRandomInt(1, 8) !== 1) return false;
  return 尝试执行受击技能({ 命令字串: "breathoffire", 施法方式: "对点", 目标来源: "伤害来源坐标" }, unit, source);
}

function 湖底元素受击连招(this: void, _config: 受击反应配置, unit: any, source: any): boolean {
  let executed = false;
  executed = 尝试执行受击技能({ 技能ID: "A04U", 施法方式: "对单位", 目标来源: "伤害来源", 下单归属: "中立敌对" }, unit, source) || executed;
  const skillId = jass.GetRandomInt(1, 2) === 1 ? "A04Q" : "A04P";
  executed = 尝试执行受击技能({ 技能ID: skillId, 施法方式: "对单位", 目标来源: "伤害来源", 下单归属: "中立敌对" }, unit, source) || executed;
  return executed;
}

function 神罗战士受击随机技能(this: void, _config: 受击反应配置, unit: any, source: any): boolean {
  const roll = jass.GetRandomInt(1, 3);
  let executed = false;
  executed = 尝试执行受击技能({ 技能ID: "A0HA", 施法方式: "立即", 下单归属: "中立敌对", 与伤害来源距离不大于: 450 }, unit, source) || executed;
  if (!executed && roll === 3) {
    executed = 尝试执行受击技能({ 技能ID: "A0HB", 命令字段: "Orderon", 施法方式: "立即", 下单归属: "中立敌对" }, unit, source) || executed;
  }
  return executed;
}

function 比那名居天子受击随机技能(this: void, _config: 受击反应配置, unit: any, source: any): boolean {
  if (jass.GetRandomInt(1, 2) === 1) return false;

  let executed = false;
  if (GetUnitLifePercentBJ(unit) <= 70) {
    executed = 尝试执行受击技能({ 技能ID: "A0H5", 施法方式: "立即", 下单归属: "中立敌对" }, unit, source) || executed;
  }
  if ((jass.GetUnitX(source) - jass.GetUnitX(unit)) * (jass.GetUnitX(source) - jass.GetUnitX(unit)) + (jass.GetUnitY(source) - jass.GetUnitY(unit)) * (jass.GetUnitY(source) - jass.GetUnitY(unit)) <= 1000 * 1000) {
    if (GetUnitLifePercentBJ(unit) <= 85) {
      executed = 尝试执行受击技能({ 技能ID: "A0H3", 施法方式: "立即", 下单归属: "中立敌对" }, unit, source) || executed;
    }
    if (GetUnitLifePercentBJ(unit) <= 45) {
      executed = 尝试执行受击技能({ 技能ID: "A0H4", 施法方式: "立即", 下单归属: "中立敌对" }, unit, source) || executed;
    }
  }
  return executed;
}

function 水触须范围缠绕(this: void, _config: 受击反应配置, unit: any, _source: any): boolean {
  const targets = getEnemyUnitsInRangeOfUnit(unit, 700);
  if (targets.length <= 0) return false;
  return 尝试执行受击技能({ 命令字串: "entanglingroots", 施法方式: "对单位", 目标来源: "伤害来源" }, unit, targets[0]);
}

function 奇妙鹿受击反制(this: void, _config: 受击反应配置, unit: any, source: any): boolean {
  if (jass.GetUnitAbilityLevel(unit, BUFF_BLOODLUST) > 0) return false;

  let executed = false;
  executed = 尝试执行受击技能({ 命令字串: "bloodlust", 施法方式: "对单位", 目标来源: "自己" }, unit, source) || executed;
  executed = 尝试执行受击技能({ 技能ID: "A0I3", 施法方式: "立即", 下单归属: "中立敌对", 与伤害来源距离不大于: 350 }, unit, source) || executed;
  executed = 尝试执行受击技能({ 技能ID: "A0I4", 施法方式: "对单位", 目标来源: "伤害来源", 下单归属: "中立敌对" }, unit, source) || executed;
  return executed;
}

function 灵毒王蛇受击连招(this: void, _config: 受击反应配置, unit: any, source: any): boolean {
  let executed = false;
  executed = 尝试执行受击技能({ 技能ID: "A0IC", 施法方式: "对单位", 目标来源: "伤害来源", 下单归属: "中立敌对" }, unit, source) || executed;
  executed = 尝试执行受击技能({ 技能ID: "A0IE", 施法方式: "立即", 下单归属: "中立敌对" }, unit, source) || executed;

  const point = 取随机坐标偏移(source, 400);
  const pointOrder = 获取技能命令字串({ 技能ID: "A0ID", 施法方式: "对点" });
  if (pointOrder !== "" && IssuePointOrder(unit, pointOrder, point[0], point[1]) === true) {
    executed = true;
  } else {
    executed = 尝试执行受击技能({ 技能ID: "A0ID", 施法方式: "对点", 目标来源: "伤害来源坐标", 下单归属: "中立敌对" }, unit, source) || executed;
  }
  return executed;
}

特殊逻辑映射["蜘蛛女皇受击喷射"] = 蜘蛛女皇受击喷射;
特殊逻辑映射["蜥蜴怪物受击喷火"] = 蜥蜴怪物受击喷火;
特殊逻辑映射["湖底元素受击连招"] = 湖底元素受击连招;
特殊逻辑映射["神罗战士受击随机技能"] = 神罗战士受击随机技能;
特殊逻辑映射["比那名居天子受击随机技能"] = 比那名居天子受击随机技能;
特殊逻辑映射["水触须范围缠绕"] = 水触须范围缠绕;
特殊逻辑映射["奇妙鹿受击反制"] = 奇妙鹿受击反制;
特殊逻辑映射["灵毒王蛇受击连招"] = 灵毒王蛇受击连招;

export function 执行受击反应特殊逻辑(this: void, config: 受击反应配置, unit: any, source: any): boolean {
  if (config.特殊逻辑名 == null || config.特殊逻辑名 === "") return false;
  if (单位是否正在原生施法(unit)) return false;
  const fn = 特殊逻辑映射[config.特殊逻辑名];
  if (fn == null) return false;
  return fn(config, unit, source);
}
