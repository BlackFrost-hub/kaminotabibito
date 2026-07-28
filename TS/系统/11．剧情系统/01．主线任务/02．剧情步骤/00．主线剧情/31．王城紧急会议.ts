import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 停止触发单位, 读取触发单位, 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 注册剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
import { 启动王城攻城战, 结束菲利斯攻城等待, 登记存活攻城单位为菲利斯护卫 } from "./31A．王城攻城战控制器";
import { 准备耶提尔菲利斯协战 } from "./31B．耶提尔协战控制器";

const jass = require("jass.common") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查总单位ID } = require("系统.01．单位系统.08．单位配置表.04．总单位配置表") as {
  按名字反查总单位ID: (this: void, name: string) => string | undefined;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};

const Player = jass.Player as (this: void, playerId: number) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facingAngle: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;
const 中立被动玩家ID = 15;

interface 会议席位预置 {
  角色名: string;
  单位名: string;
  X: number;
  Y: number;
  朝向: number;
}

const 会议席位预置表: 会议席位预置[] = [
  { 角色名: "克林姆德王", 单位名: "克林姆德王", X: 13013.3, Y: -23968.5, 朝向: 270 },
  { 角色名: "耶提尔", 单位名: "防卫部长-耶提尔", X: 12735.6, Y: -24115.1, 朝向: 0 },
  { 角色名: "赫克提尔", 单位名: "术法长老-赫克提尔", X: 13332.9, Y: -24146.4, 朝向: 180 },
  { 角色名: "里凡特", 单位名: "第一王子-里凡特", X: 12736.0, Y: -24254.7, 朝向: 0 },
  { 角色名: "丝费里德", 单位名: "财务总长-丝费里德", X: 13335.9, Y: -24281.8, 朝向: 180 },
  { 角色名: "语维", 单位名: "内务总管-语维", X: 12747.2, Y: -24413.6, 朝向: 0 },
  { 角色名: "本·思雅", 单位名: "精灵古老-本·思雅", X: 13333.6, Y: -24398.1, 朝向: 180 },
];

export { 王城紧急会议剧情片段 } from "../02．第二章/31．王城紧急会议";

function 读取或创建会议NPC(this: void, 预置: 会议席位预置): any {
  const 语义引用 = `主线NPC.${预置.角色名}`;
  let unit = 读取语义单位引用(语义引用);
  if (unit == null || unit === 0) {
    const unitTypeId = stringToFourCCSafe(按名字反查总单位ID(预置.单位名));
    if (!(unitTypeId > 0)) return null;
    unit = 创建单位并登记排泄安全(Player(中立被动玩家ID), unitTypeId, 预置.X, 预置.Y, 预置.朝向);
  }
  if (unit == null || unit === 0) return null;

  SetUnitPosition(unit, 预置.X, 预置.Y);
  SetUnitFacing(unit, 预置.朝向);
  注册剧情运行时单位(语义引用, unit);
  return unit;
}

export function 布置王城会议席位(this: void): void {
  for (let i = 0; i < 会议席位预置表.length; i++) {
    读取或创建会议NPC(会议席位预置表[i]);
  }
}

export function 执行紧急会议(this: void): void {
  停止触发单位();
  布置王城会议席位();
}

export function 执行启动王城攻城战(this: void): void {
  启动王城攻城战();
}

export function 执行准备耶提尔菲利斯协战(this: void): void {
  结束菲利斯攻城等待();
  登记存活攻城单位为菲利斯护卫();
  准备耶提尔菲利斯协战(读取语义单位引用("Boss.菲利斯"), 读取触发单位());
}

export const 王城紧急会议剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_前往会议室任务": 布置王城会议席位,
  "JLC精灵城_紧急会议": 执行紧急会议,
  "JLC精灵城_启动王城攻城战": 执行启动王城攻城战,
  "JLC精灵城_准备耶提尔菲利斯协战": 执行准备耶提尔菲利斯协战,
};
