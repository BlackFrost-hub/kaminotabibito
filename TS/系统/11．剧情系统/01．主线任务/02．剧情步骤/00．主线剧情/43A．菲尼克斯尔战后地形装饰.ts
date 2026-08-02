/** @noSelfInFile */

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { DzDoodadCreate, DzDoodadRemove } = require("lib.扩展函数.KK扩展API.00．装饰物函数") as {
  DzDoodadCreate: (this: void, id: number, varId: number, x: number, y: number, z: number, rotate: number, scale: number) => number;
  DzDoodadRemove: (this: void, doodad: number) => void;
};

const 菲尼克斯尔战后地形装饰 = {
  类型ID: "D08V",
  X: 8384.9,
  Y: -13714.5,
  Z: 0,
  朝向: 180,
  缩放: 2,
  变体: 1,
};

let 菲尼克斯尔战后地形装饰句柄 = 0;

export function 创建菲尼克斯尔战后地形装饰(this: void): void {
  if (菲尼克斯尔战后地形装饰句柄 !== 0) return;
  菲尼克斯尔战后地形装饰句柄 = DzDoodadCreate(
    stringToFourCCSafe(菲尼克斯尔战后地形装饰.类型ID),
    菲尼克斯尔战后地形装饰.变体,
    菲尼克斯尔战后地形装饰.X,
    菲尼克斯尔战后地形装饰.Y,
    菲尼克斯尔战后地形装饰.Z,
    菲尼克斯尔战后地形装饰.朝向,
    菲尼克斯尔战后地形装饰.缩放,
  );
}

export function 清理菲尼克斯尔战后地形装饰(this: void): void {
  if (菲尼克斯尔战后地形装饰句柄 === 0) return;
  DzDoodadRemove(菲尼克斯尔战后地形装饰句柄);
  菲尼克斯尔战后地形装饰句柄 = 0;
}
