/** @noSelfInFile */

import {
  创建可攻击机制单位,
  type 可攻击机制单位实例,
  type 可攻击机制单位参数,
} from "../../04．机制组件/05．机制单位/01．可攻击机制单位";

const jass = require("jass.common") as any;
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};
const { registerUnitInRangeTrigger } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitInRangeTrigger: (this: void, trigger: any, unit: any, range: number, filter?: any, once?: boolean) => (this: void) => void;
};
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
  unregisterDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { safeTriggerAddAction, safeDestroyTrigger } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTriggerAddAction: (this: void, trigger: any, callback: (this: void) => void) => { readonly id: number } | null;
  safeDestroyTrigger: (this: void, trigger: any) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, sourceUnit: any, text: string, duration?: number) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetTriggeringTrigger = jass.GetTriggeringTrigger as (this: void) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const IssueTargetOrder = jass.IssueTargetOrder as (this: void, unit: any, order: string, target: any) => boolean;
const PingMinimap = jass.PingMinimap as (this: void, x: number, y: number, duration: number) => void;
const Player = jass.Player as (this: void, playerId: number) => any;
const 中立敌对玩家ID = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const 中立被动玩家ID = jass.PLAYER_NEUTRAL_PASSIVE as number;

export interface 通用防守波次单位配置 {
  单位ID: string;
  数量: number;
}

export interface 通用防守广播配置 {
  文本: string;
  持续毫秒: number;
}

export interface 通用防守配置 {
  唯一键: string;
  中心X: number;
  中心Y: number;
  触发范围: number;
  守护目标: Omit<可攻击机制单位参数, "所属玩家" | "X" | "Y" | "on被击杀" | "变量"> & { 所属玩家ID?: number };
  波次: readonly (readonly 通用防守波次单位配置[])[];
  出生偏移: readonly { X: number; Y: number }[];
  敌对玩家ID?: number;
  接取提示?: 通用防守广播配置;
  靠近广播?: readonly 通用防守广播配置[];
  波次提示模板?: string;
  完成提示?: 通用防守广播配置;
  失败提示?: 通用防守广播配置;
  重试提示?: 通用防守广播配置;
  重试延迟毫秒?: number;
  波次间隔毫秒?: number;
  小地图信号秒?: number;
  上下文?: any;
  on完成?: (this: void, 上下文?: any) => void;
  on失败?: (this: void, 上下文?: any) => void;
}

interface 通用防守状态 {
  配置: 通用防守配置;
  运行中: boolean;
  战斗中: boolean;
  已完成: boolean;
  当前波次索引: number;
  当前广播索引: number;
  当前存活敌人数: number;
  守护目标实例?: 可攻击机制单位实例;
  守护目标单位: any;
  敌人列表: any[];
  范围触发器: any;
  取消范围监听?: (this: void) => void;
}

const 防守状态表: Record<string, 通用防守状态 | undefined> = {};
const 范围触发器状态表: Record<number, 通用防守状态 | undefined> = {};
const 敌人状态表: Record<number, 通用防守状态 | undefined> = {};
let 已注册敌人死亡监听 = false;

function 注销范围监听(this: void, 状态: 通用防守状态): void {
  if (状态.取消范围监听 != null) 状态.取消范围监听();
  状态.取消范围监听 = undefined;
  if (状态.范围触发器 != null && 状态.范围触发器 !== 0) {
    delete 范围触发器状态表[GetHandleId(状态.范围触发器)];
    safeDestroyTrigger(状态.范围触发器);
  }
  状态.范围触发器 = null;
}

function 清理敌人(this: void, 状态: 通用防守状态): void {
  for (let i = 0; i < 状态.敌人列表.length; i++) {
    const 敌人 = 状态.敌人列表[i];
    if (敌人 == null || 敌人 === 0) continue;
    delete 敌人状态表[GetHandleId(敌人)];
    立即移除单位并取消排泄登记(敌人);
  }
  状态.敌人列表 = [];
  状态.当前存活敌人数 = 0;
}

function 尝试注销敌人死亡监听(this: void): void {
  for (const key in 敌人状态表) {
    if (敌人状态表[key] != null) return;
  }
  if (!已注册敌人死亡监听) return;
  unregisterDeathListener(on通用防守敌人死亡);
  已注册敌人死亡监听 = false;
}

function 清理防守状态(this: void, 状态: 通用防守状态, 是否删除状态: boolean): void {
  状态.运行中 = false;
  状态.战斗中 = false;
  注销范围监听(状态);
  清理敌人(状态);
  const 守护目标实例 = 状态.守护目标实例;
  状态.守护目标实例 = undefined;
  状态.守护目标单位 = null;
  if (守护目标实例 != null && 守护目标实例.是否存活()) 守护目标实例.销毁();
  if (是否删除状态) delete 防守状态表[状态.配置.唯一键];
  尝试注销敌人死亡监听();
}

function 创建守护目标(this: void, 状态: 通用防守状态): boolean {
  const 参数 = 状态.配置.守护目标;
  const 实例 = 创建可攻击机制单位({
    ...参数,
    所属玩家: Player(参数.所属玩家ID ?? 中立被动玩家ID),
    X: 状态.配置.中心X,
    Y: 状态.配置.中心Y,
    on被击杀: on通用防守目标被击杀,
    变量: 状态,
  });
  if (实例 == null) return false;
  状态.守护目标实例 = 实例;
  状态.守护目标单位 = 实例.单位;
  return true;
}

function 注册靠近监听(this: void, 状态: 通用防守状态): void {
  注销范围监听(状态);
  if (状态.守护目标单位 == null || 状态.守护目标单位 === 0) return;
  const 触发器 = CreateTrigger();
  if (触发器 == null || 触发器 === 0) return;
  if (safeTriggerAddAction(触发器, on通用防守英雄靠近) == null) {
    safeDestroyTrigger(触发器);
    return;
  }
  状态.范围触发器 = 触发器;
  范围触发器状态表[GetHandleId(触发器)] = 状态;
  状态.取消范围监听 = registerUnitInRangeTrigger(触发器, 状态.守护目标单位, 状态.配置.触发范围, null, false);
}

function 重新创建防守入口(this: void, variable?: any): void {
  const 状态 = variable as 通用防守状态 | undefined;
  if (状态 == null || !状态.运行中 || 状态.已完成 || 状态.守护目标单位 != null) return;
  if (!创建守护目标(状态)) return;
  注册靠近监听(状态);
  const 提示 = 状态.配置.重试提示;
  if (提示 != null) 广播单位提示(状态.守护目标单位, 提示.文本, 提示.持续毫秒);
  const 信号秒 = 状态.配置.小地图信号秒 ?? 0;
  if (信号秒 > 0) PingMinimap(状态.配置.中心X, 状态.配置.中心Y, 信号秒);
}

function on通用防守目标被击杀(this: void, 死亡单位: any, _击杀者: any, variable?: any): void {
  const 状态 = variable as 通用防守状态 | undefined;
  if (状态 == null || !状态.运行中 || 状态.已完成 || 死亡单位 !== 状态.守护目标单位) return;
  const 提示 = 状态.配置.失败提示;
  if (提示 != null) 广播单位提示(死亡单位, 提示.文本, 提示.持续毫秒);
  状态.守护目标实例 = undefined;
  状态.守护目标单位 = null;
  状态.战斗中 = false;
  状态.当前波次索引 = 0;
  注销范围监听(状态);
  清理敌人(状态);
  尝试注销敌人死亡监听();
  if (状态.配置.on失败 != null) 状态.配置.on失败(状态.配置.上下文);
  addDelayedCallback(状态.配置.重试延迟毫秒 ?? 5000, 重新创建防守入口, 状态);
}

function 完成通用防守(this: void, 状态: 通用防守状态): void {
  if (!状态.运行中 || 状态.已完成) return;
  状态.战斗中 = false;
  状态.已完成 = true;
  注销范围监听(状态);
  尝试注销敌人死亡监听();
  const 提示 = 状态.配置.完成提示;
  if (提示 != null) 广播单位提示(状态.守护目标单位, 提示.文本, 提示.持续毫秒);
  if (状态.配置.on完成 != null) 状态.配置.on完成(状态.配置.上下文);
}

function 开始下一波(this: void, variable?: any): void {
  const 状态 = variable as 通用防守状态 | undefined;
  if (状态 == null || !状态.运行中 || !状态.战斗中 || 状态.已完成 || 状态.当前存活敌人数 > 0) return;
  if (状态.当前波次索引 >= 状态.配置.波次.length) {
    完成通用防守(状态);
    return;
  }
  const 波次 = 状态.配置.波次[状态.当前波次索引];
  状态.当前波次索引++;
  let 出生序号 = 0;
  for (let i = 0; i < 波次.length; i++) {
    const 单位配置 = 波次[i];
    const 单位类型ID = stringToFourCCSafe(单位配置.单位ID);
    if (单位类型ID === 0) continue;
    for (let j = 0; j < 单位配置.数量; j++) {
      const 偏移 = 状态.配置.出生偏移[出生序号 % 状态.配置.出生偏移.length];
      出生序号++;
      const 敌人 = 创建单位并登记排泄安全(
        Player(状态.配置.敌对玩家ID ?? 中立敌对玩家ID),
        单位类型ID,
        状态.配置.中心X + 偏移.X,
        状态.配置.中心Y + 偏移.Y,
        270,
      );
      if (敌人 == null || 敌人 === 0) continue;
      状态.敌人列表.push(敌人);
      状态.当前存活敌人数++;
      敌人状态表[GetHandleId(敌人)] = 状态;
      IssueTargetOrder(敌人, "attack", 状态.守护目标单位);
    }
  }
  if (!已注册敌人死亡监听 && 状态.当前存活敌人数 > 0) {
    registerDeathListener(on通用防守敌人死亡);
    已注册敌人死亡监听 = true;
  }
  const 模板 = 状态.配置.波次提示模板;
  if (模板 != null && 模板 !== "") {
    广播单位提示(状态.守护目标单位, 模板.replace("{波次}", tostring(状态.当前波次索引)), 4200);
  }
  if (状态.当前存活敌人数 <= 0) addDelayedCallback(1000, 开始下一波, 状态);
}

function on通用防守敌人死亡(this: void, 死亡单位: any, _击杀者: any): void {
  if (死亡单位 == null || 死亡单位 === 0) return;
  const 单位句柄ID = GetHandleId(死亡单位);
  const 状态 = 敌人状态表[单位句柄ID];
  if (状态 == null || !状态.战斗中 || 状态.当前存活敌人数 <= 0) return;
  delete 敌人状态表[单位句柄ID];
  for (let i = 0; i < 状态.敌人列表.length; i++) {
    if (状态.敌人列表[i] !== 死亡单位) continue;
    状态.敌人列表.splice(i, 1);
    状态.当前存活敌人数--;
    break;
  }
  if (状态.当前存活敌人数 <= 0) {
    尝试注销敌人死亡监听();
    addDelayedCallback(状态.配置.波次间隔毫秒 ?? 2500, 开始下一波, 状态);
  }
}

function 开始防守战斗(this: void, 状态: 通用防守状态): void {
  if (!状态.运行中 || 状态.已完成 || 状态.战斗中 || 状态.守护目标单位 == null) return;
  状态.战斗中 = true;
  状态.当前波次索引 = 0;
  状态.当前存活敌人数 = 0;
  开始下一波(状态);
}

function 播放下一段靠近广播(this: void, variable?: any): void {
  const 状态 = variable as 通用防守状态 | undefined;
  if (状态 == null || !状态.运行中 || 状态.已完成 || 状态.守护目标单位 == null) return;
  const 广播列表 = 状态.配置.靠近广播 ?? [];
  if (状态.当前广播索引 >= 广播列表.length) {
    开始防守战斗(状态);
    return;
  }
  const 广播 = 广播列表[状态.当前广播索引];
  状态.当前广播索引++;
  广播单位提示(状态.守护目标单位, 广播.文本, 广播.持续毫秒);
  addDelayedCallback(广播.持续毫秒 + 400, 播放下一段靠近广播, 状态);
}

function on通用防守英雄靠近(this: void): void {
  const 触发器 = GetTriggeringTrigger();
  if (触发器 == null || 触发器 === 0) return;
  const 状态 = 范围触发器状态表[GetHandleId(触发器)];
  if (状态 == null || !状态.运行中 || 状态.已完成 || 状态.战斗中) return;
  const 触发单位 = GetTriggerUnit();
  if (触发单位 == null || 触发单位 === 0 || !是玩家英雄组单位(触发单位)) return;
  注销范围监听(状态);
  状态.当前广播索引 = 0;
  播放下一段靠近广播(状态);
}

export function 启动通用防守(this: void, 配置: 通用防守配置): boolean {
  停止通用防守(配置.唯一键);
  if (配置.唯一键 === "" || 配置.波次.length <= 0 || 配置.出生偏移.length <= 0) return false;
  const 状态: 通用防守状态 = {
    配置,
    运行中: true,
    战斗中: false,
    已完成: false,
    当前波次索引: 0,
    当前广播索引: 0,
    当前存活敌人数: 0,
    守护目标单位: null,
    敌人列表: [],
    范围触发器: null,
  };
  防守状态表[配置.唯一键] = 状态;
  if (!创建守护目标(状态)) {
    清理防守状态(状态, true);
    return false;
  }
  注册靠近监听(状态);
  const 提示 = 配置.接取提示;
  if (提示 != null) 广播单位提示(状态.守护目标单位, 提示.文本, 提示.持续毫秒);
  const 信号秒 = 配置.小地图信号秒 ?? 0;
  if (信号秒 > 0) PingMinimap(配置.中心X, 配置.中心Y, 信号秒);
  return true;
}

export function 停止通用防守(this: void, 唯一键: string): void {
  const 状态 = 防守状态表[唯一键];
  if (状态 != null) 清理防守状态(状态, true);
}
