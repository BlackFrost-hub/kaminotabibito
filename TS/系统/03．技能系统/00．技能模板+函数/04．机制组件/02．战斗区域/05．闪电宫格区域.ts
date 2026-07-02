/** @noSelfInFile */

import {
  默认闪电效果代码,
  闪电效果代码,
  type 闪电效果代码值,
  type 闪电效果代码名,
} from "../../02．通用函数/17．闪电效果代码";

const jass = require("jass.common") as any;

const Rect = jass.Rect as (minx: number, miny: number, maxx: number, maxy: number) => any;
const RemoveRect = jass.RemoveRect as (whichRect: any) => void;
const AddLightningEx = jass.AddLightningEx as (
  codeName: string,
  checkVisibility: boolean,
  x1: number,
  y1: number,
  z1: number,
  x2: number,
  y2: number,
  z2: number,
) => any;
const DestroyLightning = jass.DestroyLightning as (whichLightning: any) => boolean;
const SetLightningColor = jass.SetLightningColor as (whichLightning: any, r: number, g: number, b: number, a: number) => void;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;

export interface 闪电宫格颜色 {
  r: number;
  g: number;
  b: number;
  a: number;
}

export interface 闪电宫格清理篮子 {
  登记清理(名称: string, 清理: (this: void) => void): void;
}

export interface 闪电宫格配置 {
  名称?: string;
  中心X: number;
  中心Y: number;
  /** 宫格总宽度。若不传，可用 单格宽度/单格边长 自动换算。 */
  宽度?: number;
  /** 宫格总高度。若不传，可用 单格高度/单格边长 自动换算。 */
  高度?: number;
  /** 每个格子的宽度，用于按单格尺寸反推总宽度。 */
  单格宽度?: number;
  /** 每个格子的高度，用于按单格尺寸反推总高度。 */
  单格高度?: number;
  /** 正方形格子的边长；单格宽度/单格高度未传时作为兜底。 */
  单格边长?: number;
  行数?: number;
  列数?: number;
  闪电效果?: 闪电效果代码名 | 闪电效果代码值 | string;
  闪电高度?: number;
  闪电颜色?: 闪电宫格颜色;
  清理篮子?: 闪电宫格清理篮子;
}

export interface 闪电宫格格子<T状态 = string> {
  行: number;
  列: number;
  索引: number;
  名称: string;
  左: number;
  右: number;
  下: number;
  上: number;
  中心X: number;
  中心Y: number;
  矩形: any;
  状态?: T状态;
}

export interface 闪电宫格控制器<T状态 = string> {
  readonly 名称: string;
  readonly 行数: number;
  readonly 列数: number;
  readonly 宽度: number;
  readonly 高度: number;
  readonly 单格宽度: number;
  readonly 单格高度: number;
  readonly 格子列表: 闪电宫格格子<T状态>[];
  readonly 横线列表: any[];
  readonly 竖线列表: any[];
  获取格子(行: number, 列: number): 闪电宫格格子<T状态> | undefined;
  获取格子By索引(索引: number): 闪电宫格格子<T状态> | undefined;
  坐标所在格子(x: number, y: number): 闪电宫格格子<T状态> | undefined;
  单位所在格子(单位: any): 闪电宫格格子<T状态> | undefined;
  设置格子状态(行: number, 列: number, 状态: T状态 | undefined): void;
  清空格子状态(): void;
  销毁(): void;
}

const 默认闪电宫格名称 = "闪电宫格区域";
const 默认闪电高度 = 60;

function 规整数量(this: void, 值: number | undefined, 默认值: number): number {
  if (值 == null || 值 < 1) return 默认值;
  return math.floor(值);
}

function 解析宫格尺寸(this: void, 参数: 闪电宫格配置, 行数: number, 列数: number): { 宽度: number; 高度: number; 单格宽度: number; 单格高度: number } {
  const 原始单格宽度 = 参数.单格宽度 ?? 参数.单格边长;
  const 原始单格高度 = 参数.单格高度 ?? 参数.单格边长;
  const 原始宽度 = 参数.宽度 ?? (原始单格宽度 != null ? 原始单格宽度 * 列数 : undefined);
  const 原始高度 = 参数.高度 ?? (原始单格高度 != null ? 原始单格高度 * 行数 : undefined);
  if (原始宽度 == null || 原始宽度 <= 0 || 原始高度 == null || 原始高度 <= 0) {
    throw new Error("创建闪电宫格区域需要提供有效的 宽度/高度，或 单格宽度/单格高度/单格边长。");
  }
  return {
    宽度: 原始宽度,
    高度: 原始高度,
    单格宽度: 原始宽度 / 列数,
    单格高度: 原始高度 / 行数,
  };
}

function 解析闪电效果(this: void, 效果: 闪电宫格配置["闪电效果"]): string {
  if (效果 == null || 效果 === "") return 默认闪电效果代码;
  const 表 = 闪电效果代码 as Record<string, string>;
  const 可能代码 = 表[效果 as string];
  return 可能代码 ?? (效果 as string);
}

function 点在格子内<T状态>(this: void, x: number, y: number, 格子: 闪电宫格格子<T状态>): boolean {
  return x >= 格子.左 && x <= 格子.右 && y >= 格子.下 && y <= 格子.上;
}

function 创建闪电线(this: void, 参数: 闪电宫格配置, x1: number, y1: number, x2: number, y2: number): any {
  const 高度 = 参数.闪电高度 ?? 默认闪电高度;
  const 闪电 = AddLightningEx(解析闪电效果(参数.闪电效果), false, x1, y1, 高度, x2, y2, 高度);
  if (闪电 != null && 闪电 !== 0 && 参数.闪电颜色 != null) {
    SetLightningColor(闪电, 参数.闪电颜色.r, 参数.闪电颜色.g, 参数.闪电颜色.b, 参数.闪电颜色.a);
  }
  return 闪电;
}

class 闪电宫格控制器实现<T状态 = string> implements 闪电宫格控制器<T状态> {
  readonly 名称: string;
  readonly 行数: number;
  readonly 列数: number;
  readonly 宽度: number;
  readonly 高度: number;
  readonly 单格宽度: number;
  readonly 单格高度: number;
  readonly 格子列表: 闪电宫格格子<T状态>[];
  readonly 横线列表: any[];
  readonly 竖线列表: any[];
  private 已销毁 = false;

  constructor(名称: string, 行数: number, 列数: number, 宽度: number, 高度: number, 单格宽度: number, 单格高度: number, 格子列表: 闪电宫格格子<T状态>[], 横线列表: any[], 竖线列表: any[]) {
    this.名称 = 名称;
    this.行数 = 行数;
    this.列数 = 列数;
    this.宽度 = 宽度;
    this.高度 = 高度;
    this.单格宽度 = 单格宽度;
    this.单格高度 = 单格高度;
    this.格子列表 = 格子列表;
    this.横线列表 = 横线列表;
    this.竖线列表 = 竖线列表;
  }

  获取格子(行: number, 列: number): 闪电宫格格子<T状态> | undefined {
    if (行 < 0 || 行 >= this.行数 || 列 < 0 || 列 >= this.列数) return undefined;
    return this.格子列表[行 * this.列数 + 列];
  }

  获取格子By索引(索引: number): 闪电宫格格子<T状态> | undefined {
    if (索引 < 0 || 索引 >= this.格子列表.length) return undefined;
    return this.格子列表[索引];
  }

  坐标所在格子(x: number, y: number): 闪电宫格格子<T状态> | undefined {
    for (let i = 0; i < this.格子列表.length; i++) {
      const 格子 = this.格子列表[i];
      if (点在格子内(x, y, 格子)) return 格子;
    }
    return undefined;
  }

  单位所在格子(单位: any): 闪电宫格格子<T状态> | undefined {
    if (单位 == null || 单位 === 0) return undefined;
    return this.坐标所在格子(GetUnitX(单位), GetUnitY(单位));
  }

  设置格子状态(行: number, 列: number, 状态: T状态 | undefined): void {
    const 格子 = this.获取格子(行, 列);
    if (格子 != null) 格子.状态 = 状态;
  }

  清空格子状态(): void {
    for (let i = 0; i < this.格子列表.length; i++) {
      this.格子列表[i].状态 = undefined;
    }
  }

  销毁(): void {
    if (this.已销毁) return;
    this.已销毁 = true;
    for (let i = 0; i < this.横线列表.length; i++) {
      const 闪电 = this.横线列表[i];
      if (闪电 != null && 闪电 !== 0) DestroyLightning(闪电);
      this.横线列表[i] = null;
    }
    for (let i = 0; i < this.竖线列表.length; i++) {
      const 闪电 = this.竖线列表[i];
      if (闪电 != null && 闪电 !== 0) DestroyLightning(闪电);
      this.竖线列表[i] = null;
    }
    for (let i = 0; i < this.格子列表.length; i++) {
      const 格子 = this.格子列表[i];
      if (格子.矩形 != null && 格子.矩形 !== 0) RemoveRect(格子.矩形);
      格子.矩形 = null;
      格子.状态 = undefined;
    }
  }
}

export function 创建闪电宫格区域<T状态 = string>(this: void, 参数: 闪电宫格配置): 闪电宫格控制器<T状态> {
  const 名称 = 参数.名称 ?? 默认闪电宫格名称;
  const 行数 = 规整数量(参数.行数, 3);
  const 列数 = 规整数量(参数.列数, 3);
  const 尺寸 = 解析宫格尺寸(参数, 行数, 列数);
  const 左 = 参数.中心X - 尺寸.宽度 / 2;
  const 右 = 参数.中心X + 尺寸.宽度 / 2;
  const 下 = 参数.中心Y - 尺寸.高度 / 2;
  const 上 = 参数.中心Y + 尺寸.高度 / 2;
  const 单格宽度 = 尺寸.单格宽度;
  const 单格高度 = 尺寸.单格高度;
  const x线: number[] = [];
  const y线: number[] = [];
  const 格子列表: 闪电宫格格子<T状态>[] = [];
  const 横线列表: any[] = [];
  const 竖线列表: any[] = [];

  for (let i = 0; i <= 列数; i++) x线.push(左 + 单格宽度 * i);
  for (let i = 0; i <= 行数; i++) y线.push(下 + 单格高度 * i);

  for (let i = 0; i < y线.length; i++) {
    横线列表.push(创建闪电线(参数, 左, y线[i], 右, y线[i]));
  }
  for (let i = 0; i < x线.length; i++) {
    竖线列表.push(创建闪电线(参数, x线[i], 下, x线[i], 上));
  }

  for (let 行 = 0; 行 < 行数; 行++) {
    for (let 列 = 0; 列 < 列数; 列++) {
      const 格子左 = x线[列];
      const 格子右 = x线[列 + 1];
      const 格子下 = y线[行];
      const 格子上 = y线[行 + 1];
      const 索引 = 行 * 列数 + 列;
      格子列表.push({
        行,
        列,
        索引,
        名称: `${名称}-${行 + 1}-${列 + 1}`,
        左: 格子左,
        右: 格子右,
        下: 格子下,
        上: 格子上,
        中心X: (格子左 + 格子右) / 2,
        中心Y: (格子下 + 格子上) / 2,
        矩形: Rect(格子左, 格子下, 格子右, 格子上),
      });
    }
  }

  const 控制器 = new 闪电宫格控制器实现<T状态>(名称, 行数, 列数, 尺寸.宽度, 尺寸.高度, 单格宽度, 单格高度, 格子列表, 横线列表, 竖线列表);
  if (参数.清理篮子 != null) {
    参数.清理篮子.登记清理(`${名称}-销毁`, function 销毁闪电宫格区域(this: void): void {
      控制器.销毁();
    });
  }
  return 控制器;
}

export const 创建闪电九宫格区域 = 创建闪电宫格区域;
