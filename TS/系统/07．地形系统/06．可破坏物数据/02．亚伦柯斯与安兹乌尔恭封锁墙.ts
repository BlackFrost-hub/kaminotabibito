/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

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

const GetDestructableX = jass.GetDestructableX as (this: void, destructable: any) => number;
const GetDestructableY = jass.GetDestructableY as (this: void, destructable: any) => number;
const RemoveDestructable = jass.RemoveDestructable as (this: void, destructable: any) => void;
const SetDestructableInvulnerable = jass.SetDestructableInvulnerable as (
  this: void,
  destructable: any,
  flag: boolean,
) => void;
const Location = jass.Location as (this: void, x: number, y: number) => any;
const RemoveLocation = jass.RemoveLocation as (this: void, location: any) => void;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;

const 封锁墙物编ID = stringToFourCCSafe("Dofw");
const 封锁墙创建朝向 = 270;
const 封锁墙缩放 = 1;
const 封锁墙变体 = 0;
const 亚伦柯斯单位ID = stringToFourCCSafe("U006");
const 安兹乌尔恭单位ID = stringToFourCCSafe("U007");

const 封锁墙全局名表 = [
  "gg_dest_Dofw_4579",
  "gg_dest_Dofw_4580",
  "gg_dest_Dofw_5037",
  "gg_dest_Dofw_5038",
] as const;

interface 封锁墙坐标记录 {
  X: number;
  Y: number;
}

let 封锁墙坐标缓存: 封锁墙坐标记录[] | undefined;
let 已创建封锁墙: any[] = [];
const 亚伦柯斯墓地阻挡全局名 = "gg_dest_Dofw_10481";

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 是封锁墙Boss(this: void, bossUnit: any): boolean {
  if (!句柄有效(bossUnit)) return false;
  const unitTypeId = GetUnitTypeId(bossUnit);
  return unitTypeId === 亚伦柯斯单位ID || unitTypeId === 安兹乌尔恭单位ID;
}

/**
 * 在封锁墙仍存在时读取坐标并移除原始地图对象。
 * 坐标只缓存一次，后续 Boss 战重建不再依赖地图全局句柄。
 */
export function 缓存并移除亚伦柯斯安兹封锁墙(this: void): boolean {
  if (封锁墙坐标缓存 != null) return 封锁墙坐标缓存.length === 封锁墙全局名表.length;

  const 坐标列表: 封锁墙坐标记录[] = [];
  for (let i = 0; i < 封锁墙全局名表.length; i++) {
    const 全局名 = 封锁墙全局名表[i];
    const destructable = jglobals[全局名];
    if (!句柄有效(destructable)) continue;

    坐标列表.push({
      X: GetDestructableX(destructable),
      Y: GetDestructableY(destructable),
    });
    RemoveDestructable(destructable);
    jglobals[全局名] = null;
  }

  封锁墙坐标缓存 = 坐标列表;
  return 坐标列表.length === 封锁墙全局名表.length;
}

function 创建封锁墙(this: void, 坐标: 封锁墙坐标记录): any {
  const loc = Location(坐标.X, 坐标.Y);
  if (!句柄有效(loc)) return null;

  const destructable = CreateDestructableLoc(
    封锁墙物编ID,
    loc,
    封锁墙创建朝向,
    封锁墙缩放,
    封锁墙变体,
  );
  RemoveLocation(loc);
  if (句柄有效(destructable)) SetDestructableInvulnerable(destructable, true);
  return destructable;
}

/** Boss 战开始时重新建立四道不可破坏封锁墙。 */
export function 重建亚伦柯斯安兹封锁墙(this: void, bossUnit: any): void {
  if (!是封锁墙Boss(bossUnit) || 已创建封锁墙.length > 0) return;
  if (!缓存并移除亚伦柯斯安兹封锁墙() || 封锁墙坐标缓存 == null) return;

  for (let i = 0; i < 封锁墙坐标缓存.length; i++) {
    const destructable = 创建封锁墙(封锁墙坐标缓存[i]);
    if (句柄有效(destructable)) 已创建封锁墙.push(destructable);
  }
}

/** Boss 战结束或提前中止时移除战斗期间重建的封锁墙。 */
export function 清理亚伦柯斯安兹封锁墙(this: void, bossUnit: any): void {
  if (!是封锁墙Boss(bossUnit)) return;

  for (let i = 0; i < 已创建封锁墙.length; i++) {
    const destructable = 已创建封锁墙[i];
    if (句柄有效(destructable)) RemoveDestructable(destructable);
  }
  已创建封锁墙 = [];

  if (GetUnitTypeId(bossUnit) !== 亚伦柯斯单位ID) return;
  const 墓地阻挡 = jglobals[亚伦柯斯墓地阻挡全局名];
  if (!句柄有效(墓地阻挡)) return;
  RemoveDestructable(墓地阻挡);
  jglobals[亚伦柯斯墓地阻挡全局名] = null;
}

export {};
