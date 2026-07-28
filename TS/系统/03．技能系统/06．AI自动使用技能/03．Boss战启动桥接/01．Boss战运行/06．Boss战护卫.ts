/** @noSelfInFile */

import type { Boss战运行上下文 } from "./01．Boss战运行上下文";
import {
  type Boss战斗启动护卫批次配置,
  type Boss战斗启动护卫配置,
  type Boss战斗启动护卫对白配置,
  type Boss战斗启动护卫单位配置,
  Boss战斗启动护卫配置表,
} from "../00．战斗启动属性/05．Boss战斗启动护卫配置表";
import { getServerTime } from "../../../../00．核心系统/05．中心计时器";
import {
  结束Boss护卫血条弱点韧性,
} from "../03．Boss血条弱点韧性/07．Boss弱点事件桥接";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, moduleName: string, ...args: any[]) => void;
};
const { 创建护卫单位, 登记护卫单位, 注销护卫单位, 处理Boss结束全部护卫 } = require("系统.01．单位系统.10．护卫系统.index") as {
  创建护卫单位: (this: void, 参数: any) => any;
  登记护卫单位: (this: void, unit: any, 参数: any) => any;
  注销护卫单位: (this: void, unit: any) => boolean;
  处理Boss结束全部护卫: (this: void, boss: any) => void;
};

const Player = jass.Player as (playerId: number) => any;
const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const SetUnitState = jass.SetUnitState as (whichUnit: any, whichState: number, newVal: number) => void;
const SetUnitStateJapi = japi.SetUnitState as (whichUnit: any, whichState: number, newVal: number) => void;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichState: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichType: number) => boolean;
const GetRandomInt = jass.GetRandomInt as (lowBound: number, highBound: number) => number;
const GetRandomReal = jass.GetRandomReal as (lowBound: number, highBound: number) => number;
const GetRectMinX = jass.GetRectMinX as (whichRect: any) => number;
const GetRectMaxX = jass.GetRectMaxX as (whichRect: any) => number;
const GetRectMinY = jass.GetRectMinY as (whichRect: any) => number;
const GetRectMaxY = jass.GetRectMaxY as (whichRect: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (whichUnit: any, facingAngle: number) => void;
const SetUnitOwner = jass.SetUnitOwner as (whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (whichUnit: any, newX: number, newY: number) => void;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;

const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as number;

const 模块名 = "Boss战护卫";
const 角度转弧度 = 0.017453292519943295;
const 带入护卫最小半径 = 250;
const 带入护卫最大半径 = 700;

interface Boss战护卫实例 {
  unit: any;
  handleId: number;
  unitTypeId: number;
}

interface Boss战待带入护卫 {
  unit: any;
  护卫类型: string;
}

interface Boss战护卫运行上下文 {
  Boss战上下文: Boss战运行上下文;
  配置: Boss战斗启动护卫配置;
  已生成护卫: Boss战护卫实例[];
  待播对白: Boss战护卫待播对白[];
  下次周期生成时间: number;
  是否已启动: boolean;
}

interface Boss战护卫待播对白 {
  触发时间: number;
  说话者: "Boss" | "护卫";
  文案池: string[];
}

const 按Boss句柄索引的护卫运行上下文表: Record<number, Boss战护卫运行上下文 | undefined> = {};
const 按Boss句柄索引的待带入护卫表: Record<number, Boss战待带入护卫[] | undefined> = {};

function 获取句柄ID(this: void, handle: any): number {
  if (handle == null || handle === 0) return 0;
  return GetHandleId(handle) || 0;
}

function 按Boss查找护卫配置(this: void, bossUnit: any): Boss战斗启动护卫配置 | undefined {
  const bossTypeId = GetUnitTypeId(bossUnit);
  if (bossTypeId === 0) return undefined;

  for (let i = 0; i < Boss战斗启动护卫配置表.length; i++) {
    const 配置 = Boss战斗启动护卫配置表[i];
    if (stringToFourCCSafe(配置.Boss单位ID) === bossTypeId) {
      return 配置;
    }
  }
  return undefined;
}

function 单位是否死亡(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return true;
  return IsUnitType(unit, UNIT_TYPE_DEAD);
}

function 记录护卫实例(this: void, 运行上下文: Boss战护卫运行上下文, unit: any): void {
  const handleId = 获取句柄ID(unit);
  if (handleId === 0) return;
  运行上下文.已生成护卫.push({
    unit,
    handleId,
    unitTypeId: GetUnitTypeId(unit),
  });
}

function 获取随机环形坐标(this: void, 中心X: number, 中心Y: number, 最小半径: number, 最大半径: number): { X: number; Y: number; 角度: number } {
  const 角度 = GetRandomReal(0, 360);
  const 半径 = GetRandomReal(最小半径, 最大半径);
  const 弧度 = 角度 * 角度转弧度;
  return {
    X: 中心X + Cos(弧度) * 半径,
    Y: 中心Y + Sin(弧度) * 半径,
    角度,
  };
}

function 获取护卫生成坐标(this: void, 运行上下文: Boss战护卫运行上下文, 配置: Boss战斗启动护卫单位配置): { X: number; Y: number } {
  const 随机位置 = 配置.随机生成位置;
  const 地点矩形 = 运行上下文.Boss战上下文.地点矩形;
  if (随机位置 != null && 随机位置.中心 === "Boss战矩形中心" && 地点矩形 != null && 地点矩形 !== 0) {
    const 中心X = (GetRectMinX(地点矩形) + GetRectMaxX(地点矩形)) * 0.5;
    const 中心Y = (GetRectMinY(地点矩形) + GetRectMaxY(地点矩形)) * 0.5;
    return 获取随机环形坐标(中心X, 中心Y, 随机位置.最小半径, 随机位置.最大半径);
  }
  return {
    X: 配置.X ?? GetUnitX(运行上下文.Boss战上下文.Boss单位),
    Y: 配置.Y ?? GetUnitY(运行上下文.Boss战上下文.Boss单位),
  };
}

function 获取同类存活数量(this: void, 运行上下文: Boss战护卫运行上下文, unitTypeId: number): number {
  let count = 0;
  for (let i = 0; i < 运行上下文.已生成护卫.length; i++) {
    const 实例 = 运行上下文.已生成护卫[i];
    if (实例.unitTypeId === unitTypeId && !单位是否死亡(实例.unit)) count++;
  }
  return count;
}

function 应用护卫额外属性(this: void, unit: any, 配置: Boss战斗启动护卫单位配置): void {
  if (配置.额外最大生命 != null && 配置.额外最大生命 !== 0) {
    const maxLife = GetUnitState(unit, UNIT_STATE_MAX_LIFE);
    SetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE, maxLife + 配置.额外最大生命);
    SetUnitState(unit, UNIT_STATE_LIFE, GetUnitState(unit, UNIT_STATE_MAX_LIFE));
  }
  if (配置.暴击率 != null) {
    YDUserDataSetSafe("unit", unit, "暴击率", "real", 配置.暴击率);
  }
  if (配置.普攻伤害吸血 != null) {
    YDUserDataSetSafe("unit", unit, "普攻伤害吸血", "real", 配置.普攻伤害吸血);
  }
}

function 播放护卫出生特效(this: void, 配置: Boss战斗启动护卫单位配置, x: number, y: number): void {
  if (配置.出生特效模型 == null || 配置.出生特效模型 === "") return;
  const effect = AddSpecialEffect(配置.出生特效模型, x, y);
  if (effect == null || effect === 0) return;
  YDWETimerDestroyEffectSafe(配置.出生特效持续秒 ?? 1.0, effect);
}

function 创建单个护卫(this: void, 运行上下文: Boss战护卫运行上下文, 配置: Boss战斗启动护卫单位配置): any {
  const unitTypeId = stringToFourCCSafe(配置.单位ID);
  if (unitTypeId === 0) return null;
  if (配置.同类最大存活数量 != null && 获取同类存活数量(运行上下文, unitTypeId) >= 配置.同类最大存活数量) return null;
  const 坐标 = 获取护卫生成坐标(运行上下文, 配置);
  const unit = 创建护卫单位({
    主Boss单位: 运行上下文.Boss战上下文.Boss单位,
    护卫类型: "战斗启动护卫:" + (配置.单位名 ?? 配置.单位ID),
    护卫血条优先级: 配置.护卫血条优先级 ?? (配置.显示护卫血条 === true ? 100 : 0),
    Boss结束处理: 配置.主Boss死亡时立刻死亡 === true ? "击杀" : "注销",
    单位类型: 配置.单位ID,
    所属玩家: Player(PLAYER_NEUTRAL_AGGRESSIVE),
    X: 坐标.X,
    Y: 坐标.Y,
    面向: 配置.面向 ?? 270.0,
  });
  if (unit == null || unit === 0) return null;

  应用护卫额外属性(unit, 配置);
  播放护卫出生特效(配置, 坐标.X, 坐标.Y);
  记录护卫实例(运行上下文, unit);
  return unit;
}

function 按配置创建护卫批次(this: void, 运行上下文: Boss战护卫运行上下文, 配置: Boss战斗启动护卫单位配置): any {
  const 生成数量 = 配置.每批生成数量 ?? 1;
  let 首个生成单位: any = null;
  for (let i = 0; i < 生成数量; i++) {
    const unit = 创建单个护卫(运行上下文, 配置);
    if (首个生成单位 == null && unit != null && unit !== 0) 首个生成单位 = unit;
  }
  return 首个生成单位;
}

function 带入待登记护卫(this: void, 运行上下文: Boss战护卫运行上下文): void {
  const context = 运行上下文.Boss战上下文;
  const 待带入列表 = 按Boss句柄索引的待带入护卫表[context.Boss句柄ID];
  按Boss句柄索引的待带入护卫表[context.Boss句柄ID] = undefined;
  if (待带入列表 == null) return;

  const bossX = GetUnitX(context.Boss单位);
  const bossY = GetUnitY(context.Boss单位);
  for (let i = 0; i < 待带入列表.length; i++) {
    const 待带入 = 待带入列表[i];
    if (单位是否死亡(待带入.unit)) continue;
    const 坐标 = 获取随机环形坐标(bossX, bossY, 带入护卫最小半径, 带入护卫最大半径);
    SetUnitOwner(待带入.unit, Player(PLAYER_NEUTRAL_AGGRESSIVE), true);
    SetUnitPosition(待带入.unit, 坐标.X, 坐标.Y);
    SetUnitFacing(待带入.unit, 坐标.角度 + 180);
    登记护卫单位(待带入.unit, {
      主Boss单位: context.Boss单位,
      护卫类型: 待带入.护卫类型,
      护卫血条优先级: 0,
      Boss结束处理: "击杀",
    });
    记录护卫实例(运行上下文, 待带入.unit);
  }
}

export function 登记Boss战待带入护卫(this: void, boss: any, guard: any, 护卫类型: string): boolean {
  const bossHandleId = 获取句柄ID(boss);
  const guardHandleId = 获取句柄ID(guard);
  if (bossHandleId === 0 || guardHandleId === 0 || 单位是否死亡(guard)) return false;
  let list = 按Boss句柄索引的待带入护卫表[bossHandleId];
  if (list == null) {
    list = [];
    按Boss句柄索引的待带入护卫表[bossHandleId] = list;
  }
  for (let i = 0; i < list.length; i++) {
    if (获取句柄ID(list[i].unit) === guardHandleId) return true;
  }
  list.push({ unit: guard, 护卫类型 });
  return true;
}

function 随机广播护卫文案(this: void, 来源单位: any, 文案池?: string[]): void {
  if (来源单位 == null || 来源单位 === 0) return;
  if (文案池 == null || 文案池.length === 0) return;
  const index = 文案池.length <= 1 ? 0 : GetRandomInt(1, 文案池.length) - 1;
  const 文案 = 文案池[index];
  if (文案 == null || 文案 === "") return;
  广播单位提示(来源单位, 文案, 4.0);
}

function 按批次获取广播来源单位(
  this: void,
  context: Boss战运行上下文,
  运行上下文: Boss战护卫运行上下文,
  批次配置: Boss战斗启动护卫批次配置
): any {
  if (批次配置.广播说话者 === "Boss") return context.Boss单位;
  return 获取护卫对白来源单位(context, 运行上下文, "护卫");
}

function 登记后续对白(this: void, 运行上下文: Boss战护卫运行上下文, 后续对白?: Boss战斗启动护卫对白配置[]): void {
  if (后续对白 == null || 后续对白.length === 0) return;
  const nowMs = getServerTime();
  for (let i = 0; i < 后续对白.length; i++) {
    const 配置 = 后续对白[i];
    if (配置.文案池 == null || 配置.文案池.length === 0) continue;
    运行上下文.待播对白.push({
      触发时间: nowMs + 配置.延迟毫秒,
      说话者: 配置.说话者,
      文案池: 配置.文案池,
    });
  }
}

function 获取护卫对白来源单位(this: void, context: Boss战运行上下文, 运行上下文: Boss战护卫运行上下文, 说话者: "Boss" | "护卫"): any {
  if (说话者 === "Boss") return context.Boss单位;
  for (let i = 0; i < 运行上下文.已生成护卫.length; i++) {
    const 实例 = 运行上下文.已生成护卫[i];
    if (!单位是否死亡(实例.unit)) return 实例.unit;
  }
  return null;
}

function 处理待播对白(this: void, context: Boss战运行上下文, 运行上下文: Boss战护卫运行上下文, nowMs: number): void {
  for (let i = 运行上下文.待播对白.length - 1; i >= 0; i--) {
    const 对白 = 运行上下文.待播对白[i];
    if (nowMs < 对白.触发时间) continue;

    const 来源单位 = 获取护卫对白来源单位(context, 运行上下文, 对白.说话者);
    随机广播护卫文案(来源单位, 对白.文案池);
    运行上下文.待播对白.splice(i, 1);
  }
}

function 清理已死亡护卫记录(this: void, 运行上下文: Boss战护卫运行上下文): void {
  for (let i = 运行上下文.已生成护卫.length - 1; i >= 0; i--) {
    if (单位是否死亡(运行上下文.已生成护卫[i].unit)) {
      结束Boss护卫血条弱点韧性(运行上下文.已生成护卫[i].unit);
      注销护卫单位(运行上下文.已生成护卫[i].unit);
      运行上下文.已生成护卫.splice(i, 1);
    }
  }
}

export function 处理Boss战护卫启动(this: void, context: Boss战运行上下文): void {
  const bossHandleId = context.Boss句柄ID;
  let 运行上下文 = 按Boss句柄索引的护卫运行上下文表[bossHandleId];
  if (运行上下文 != null && 运行上下文.是否已启动) return;

  const 配置 = 按Boss查找护卫配置(context.Boss单位);
  if (配置 == null) return;

  运行上下文 = {
    Boss战上下文: context,
    配置,
    已生成护卫: [],
    待播对白: [],
    下次周期生成时间: 0,
    是否已启动: true,
  };
  按Boss句柄索引的护卫运行上下文表[bossHandleId] = 运行上下文;
  带入待登记护卫(运行上下文);

  if (配置.初始护卫批次 != null) {
    for (let i = 0; i < 配置.初始护卫批次.单位列表.length; i++) {
      按配置创建护卫批次(运行上下文, 配置.初始护卫批次.单位列表[i]);
    }
    随机广播护卫文案(按批次获取广播来源单位(context, 运行上下文, 配置.初始护卫批次), 配置.初始护卫批次.广播文案池);
    登记后续对白(运行上下文, 配置.初始护卫批次.后续对白);
  }

  if (配置.周期护卫批次?.间隔毫秒 != null) {
    运行上下文.下次周期生成时间 = getServerTime() + 配置.周期护卫批次.间隔毫秒;
  }

  debugLogForce(模块名, "启动Boss护卫", "boss=", bossHandleId, "bossTypeId=", GetUnitTypeId(context.Boss单位));
}

export function 处理Boss战护卫Tick(this: void, context: Boss战运行上下文, nowMs: number): void {
  const 运行上下文 = 按Boss句柄索引的护卫运行上下文表[context.Boss句柄ID];
  if (运行上下文 == null) return;

  清理已死亡护卫记录(运行上下文);
  处理待播对白(context, 运行上下文, nowMs);

  const 周期配置 = 运行上下文.配置.周期护卫批次;
  if (周期配置 == null || 周期配置.间隔毫秒 == null || 周期配置.间隔毫秒 <= 0) return;
  if (nowMs < 运行上下文.下次周期生成时间) return;

  let 广播来源单位: any = null;
  for (let i = 0; i < 周期配置.单位列表.length; i++) {
    const unit = 按配置创建护卫批次(运行上下文, 周期配置.单位列表[i]);
    if (广播来源单位 == null && unit != null && unit !== 0) {
      广播来源单位 = unit;
    }
  }
  const 周期广播来源单位 = 周期配置.广播说话者 === "Boss"
    ? context.Boss单位
    : 广播来源单位;
  随机广播护卫文案(周期广播来源单位, 周期配置.广播文案池);
  运行上下文.下次周期生成时间 = nowMs + 周期配置.间隔毫秒;
}

export function 处理Boss战护卫结束(this: void, context: Boss战运行上下文): void {
  const 运行上下文 = 按Boss句柄索引的护卫运行上下文表[context.Boss句柄ID];
  if (运行上下文 == null) return;

  for (let i = 0; i < 运行上下文.已生成护卫.length; i++) {
    const 实例 = 运行上下文.已生成护卫[i];
    结束Boss护卫血条弱点韧性(实例.unit);
  }
  处理Boss结束全部护卫(context.Boss单位);

  按Boss句柄索引的护卫运行上下文表[context.Boss句柄ID] = undefined;
  debugLogForce(模块名, "结束Boss护卫", "boss=", context.Boss句柄ID);
}
