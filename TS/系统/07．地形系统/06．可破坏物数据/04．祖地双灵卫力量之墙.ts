/** @noSelfInFile */

import { 祖地双灵卫力量之墙配置 } from "./03．祖地双灵卫力量之墙配置";

const jass = require("jass.common") as any;

const { CreateDestructableLoc } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  CreateDestructableLoc: (
    this: void,
    objectid: number,
    loc: any,
    facing: number,
    scale: number,
    variation: number,
  ) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const Location = jass.Location as (this: void, x: number, y: number) => any;
const RemoveLocation = jass.RemoveLocation as (this: void, location: any) => void;
const RemoveDestructable = jass.RemoveDestructable as (this: void, destructable: any) => void;
const SetDestructableInvulnerable = jass.SetDestructableInvulnerable as (
  this: void,
  destructable: any,
  flag: boolean,
) => void;

const 力量之墙可破坏物ID = stringToFourCCSafe(祖地双灵卫力量之墙配置.可破坏物ID);
const 祖地双灵卫Boss单位类型ID列表: number[] = [];
const 已登记Boss句柄表: Record<number, true | undefined> = {};

let 已登记Boss数量 = 0;
let 当前力量之墙: any = null;

for (let i = 0; i < 祖地双灵卫力量之墙配置.Boss单位ID列表.length; i++) {
  祖地双灵卫Boss单位类型ID列表.push(
    stringToFourCCSafe(祖地双灵卫力量之墙配置.Boss单位ID列表[i]),
  );
}

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 是祖地双灵卫Boss(this: void, bossUnit: any): boolean {
  if (!句柄有效(bossUnit)) return false;
  const unitTypeId = GetUnitTypeId(bossUnit);
  for (let i = 0; i < 祖地双灵卫Boss单位类型ID列表.length; i++) {
    if (祖地双灵卫Boss单位类型ID列表[i] === unitTypeId) return true;
  }
  return false;
}

function 登记祖地双灵卫Boss(this: void, bossUnit: any): void {
  const handleId = GetHandleId(bossUnit) || 0;
  if (handleId === 0 || 已登记Boss句柄表[handleId]) return;
  已登记Boss句柄表[handleId] = true;
  已登记Boss数量 += 1;
}

function 注销祖地双灵卫Boss(this: void, bossUnit: any): void {
  const handleId = GetHandleId(bossUnit) || 0;
  if (handleId === 0 || !已登记Boss句柄表[handleId]) return;
  已登记Boss句柄表[handleId] = undefined;
  if (已登记Boss数量 > 0) 已登记Boss数量 -= 1;
}

function 创建力量之墙(this: void): any {
  const location = Location(祖地双灵卫力量之墙配置.X, 祖地双灵卫力量之墙配置.Y);
  if (!句柄有效(location)) return null;

  const destructable = CreateDestructableLoc(
    力量之墙可破坏物ID,
    location,
    祖地双灵卫力量之墙配置.朝向,
    祖地双灵卫力量之墙配置.缩放,
    祖地双灵卫力量之墙配置.变体,
  );
  RemoveLocation(location);
  if (句柄有效(destructable)) SetDestructableInvulnerable(destructable, true);
  return destructable;
}

/** Boss 战启动时登记当前形态，并保证同一场战斗只存在一面力量之墙。 */
export function 重建祖地双灵卫力量之墙(this: void, bossUnit: any): void {
  if (!是祖地双灵卫Boss(bossUnit)) return;
  登记祖地双灵卫Boss(bossUnit);
  if (句柄有效(当前力量之墙)) return;
  当前力量之墙 = 创建力量之墙();
}

/** 每个双灵卫运行上下文结束时注销；最后一个上下文结束后再移除墙体。 */
export function 清理祖地双灵卫力量之墙(this: void, bossUnit: any): void {
  if (!是祖地双灵卫Boss(bossUnit)) return;
  注销祖地双灵卫Boss(bossUnit);
  if (已登记Boss数量 > 0 || !句柄有效(当前力量之墙)) return;
  RemoveDestructable(当前力量之墙);
  当前力量之墙 = null;
}

export {};

