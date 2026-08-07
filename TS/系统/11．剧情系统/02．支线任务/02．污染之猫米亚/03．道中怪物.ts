/** @noSelfInFile */

const jass = require("jass.common") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 登记动态刷怪单位 } = require("系统.01．单位系统.03．怪物刷新系统.02．怪物刷新核心") as {
  登记动态刷怪单位: (this: void, unit: any) => boolean;
};

const Player = jass.Player as (this: void, playerId: number) => any;
const 中立敌对玩家ID = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;

interface 米亚道中怪物出生配置 {
  单位ID: string;
  X: number;
  Y: number;
  朝向: number;
}

export const 米亚道中普通怪出生配置表: 米亚道中怪物出生配置[] = [
  { 单位ID: "n07B", X: 29579.5, Y: -20517.2, 朝向: 270 },
  { 单位ID: "n07C", X: 28760.5, Y: -20738.6, 朝向: 270 },
  { 单位ID: "n07B", X: 28484.2, Y: -20575.6, 朝向: 270 },
  { 单位ID: "n07C", X: 28158.2, Y: -20646.8, 朝向: 270 },
];

export const 米亚道中精英出生配置: 米亚道中怪物出生配置 = {
  单位ID: "n07D",
  X: 27259.1,
  Y: -20699.3,
  朝向: 270,
};

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 创建并登记米亚道中怪物(this: void, 配置: 米亚道中怪物出生配置): any {
  const 单位类型ID = stringToFourCCSafe(配置.单位ID);
  if (!(单位类型ID > 0)) return null;

  const unit = 创建单位并登记排泄安全(
    Player(中立敌对玩家ID),
    单位类型ID,
    配置.X,
    配置.Y,
    配置.朝向,
  );
  if (句柄有效(unit)) 登记动态刷怪单位(unit);
  return unit;
}

export function 创建米亚道中怪物(this: void): void {
  for (const 配置 of 米亚道中普通怪出生配置表) 创建并登记米亚道中怪物(配置);
  创建并登记米亚道中怪物(米亚道中精英出生配置);
}
