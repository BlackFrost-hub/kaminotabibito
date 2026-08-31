/** @noSelfInFile */
/**
 * 爱蜜莉雅 - 公共状态与冰晶节点（A1）
 *
 * 所有技能共享的状态容器与生命周期入口，不实现具体伤害。
 * - 以英雄句柄为索引：冰晶节点、D 强化状态、世界坐标进度 UI 列表、技能清理表。
 * - 冰晶节点最多 3 枚（配置 数量上限），记录创建序号/创建时间/来源技能/坐标/是否已读取/特效句柄。
 * - 超上限按配置替换最旧节点：旧节点特效与引用一并清除。
 * - 蓄力/吟唱读条统一登记世界坐标进度 UI（09．表现系统/15），跟随施法者，死亡/打断/正常结束统一销毁。
 * - 统一回收入口：英雄死亡（死亡监听）、技能打断/目标失效（技能清理表）、地图清理（清理全部）。
 * - 冰晶只用直接特效，不创建单位壳、不使用蝗虫单位、不进入选取与碰撞。
 */

import { 爱蜜莉雅冰晶配置, 爱蜜莉雅技能配置, 爱蜜莉雅表现配置 } from "./00．配置";

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { getGameTime, addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { 取单位ID, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  取单位ID: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { 创建点特效, 销毁点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: { 模型路径: string; X: number; Y: number; Z?: number; 面向角度?: number; 缩放?: number; 持续秒?: number; RGB?: { 红: number; 绿: number; 蓝: number; 透明度?: number } }) => any;
  销毁点特效: (this: void, effect: any) => void;
};
const { 销毁世界坐标进度UI } = require("系统.09．表现系统.15．世界坐标进度UI.01．世界坐标进度UI") as {
  销毁世界坐标进度UI: (this: void, ui: any) => void;
};
const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;

const 英雄单位类型ID = jass.FourCC(爱蜜莉雅技能配置.单位类型ID) as number;

//=============================================================================
// 类型
//=============================================================================

export type 爱蜜莉雅冰晶来源 = "Q" | "W" | "E" | "R" | "D强化";

export interface 爱蜜莉雅冰晶 {
  /** 创建序号（全局递增，用于"替换最旧"判定） */
  序号: number;
  /** 创建时间（getGameTime 毫秒） */
  创建时间: number;
  来源技能: 爱蜜莉雅冰晶来源;
  X: number;
  Y: number;
  Z: number;
  /** 是否已被技能读取（读取即销毁，字段恒为 false，保留用于可追溯） */
  已读取: boolean;
  /** 关联特效句柄（清理时销毁） */
  特效句柄: any;
}

export interface 爱蜜莉雅D强化状态 {
  激活: boolean;
  /** 剩余强化次数（初始最多 3 次） */
  剩余次数: number;
  /** 到期时间（getGameTime 毫秒） */
  到期时间: number;
}

export type 爱蜜莉雅清理原因 = "英雄死亡" | "技能清理" | "地图清理" | "主动清理";

interface 爱蜜莉雅英雄状态 {
  冰晶列表: 爱蜜莉雅冰晶[];
  下一冰晶序号: number;
  D强化: 爱蜜莉雅D强化状态 | null;
  /** 世界坐标进度 UI 列表（蓄力/吟唱/锁定/延迟窗口，统一销毁） */
  进度UI列表: any[];
  /** 技能清理表：标签 → 清理回调（技能实例登记，统一回收时执行） */
  技能清理表: Record<string, (this: void) => void | undefined>;
  已清理: boolean;
}

//=============================================================================
// 状态表与死亡监听
//=============================================================================

const 爱蜜莉雅状态表: Record<number, 爱蜜莉雅英雄状态 | undefined> = {};
let 下一全局冰晶序号 = 1;
let 死亡监听已注册 = false;

function 取句柄(this: void, 英雄: any): number {
  return 取单位ID(英雄);
}

function 取或建状态(this: void, 英雄: any): 爱蜜莉雅英雄状态 {
  const id = 取句柄(英雄);
  let 状态 = 爱蜜莉雅状态表[id];
  if (状态 == null) {
    状态 = {
      冰晶列表: [],
      下一冰晶序号: 1,
      D强化: null,
      进度UI列表: [],
      技能清理表: {},
      已清理: false,
    };
    爱蜜莉雅状态表[id] = 状态;
  }
  return 状态;
}

function 确保死亡监听(this: void): void {
  if (死亡监听已注册) return;
  死亡监听已注册 = true;
  registerDeathListener(function 爱蜜莉雅死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
    if (dyingUnit == null || dyingUnit === 0) return;
    const id = 取单位ID(dyingUnit);
    if (爱蜜莉雅状态表[id] == null) return;
    // 仅当死亡单位确为本英雄（或表内登记句柄）时清理
    清理爱蜜莉雅状态(dyingUnit, "英雄死亡");
  });
}

//=============================================================================
// 冰晶节点
//=============================================================================

/** 创建冰晶节点；超过上限时按配置替换最旧节点（旧节点特效与引用一并清除）。返回新节点或 null（创建失败）。 */
export function 创建爱蜜莉雅冰晶(
  this: void,
  英雄: any,
  来源技能: 爱蜜莉雅冰晶来源,
  X: number,
  Y: number,
  Z: number = 爱蜜莉雅表现配置.冰晶节点.高度,
): 爱蜜莉雅冰晶 | null {
  if (英雄 == null || 英雄 === 0 || !单位存活(英雄)) return null;
  const 状态 = 取或建状态(英雄);
  if (状态.已清理) return null;

  // 超上限：替换最旧（序号最小者）
  while (状态.冰晶列表.length >= 爱蜜莉雅冰晶配置.数量上限) {
    移除爱蜜莉雅冰晶(英雄, 状态.冰晶列表[0].序号);
  }

  const 特效句柄 = 创建点特效({
    模型路径: 爱蜜莉雅表现配置.冰晶节点.模型路径,
    RGB: 爱蜜莉雅表现配置.冰晶节点.RGB,
    X,
    Y,
    Z,
    面向角度: 0,
    缩放: 爱蜜莉雅表现配置.冰晶节点.缩放,
    持续秒: 爱蜜莉雅表现配置.冰晶节点.持续秒,
  });
  if (特效句柄 == null || 特效句柄 === 0) return null;

  const 节点: 爱蜜莉雅冰晶 = {
    序号: 下一全局冰晶序号++,
    创建时间: getGameTime(),
    来源技能,
    X,
    Y,
    Z,
    已读取: false,
    特效句柄,
  };
  状态.冰晶列表.push(节点);
  return 节点;
}

/** 查询冰晶节点（按创建顺序返回副本；过滤条件可选） */
export function 查询爱蜜莉雅冰晶(
  this: void,
  英雄: any,
  过滤?: (this: void, 节点: 爱蜜莉雅冰晶) => boolean,
): 爱蜜莉雅冰晶[] {
  const 状态 = 爱蜜莉雅状态表[取句柄(英雄)];
  if (状态 == null) return [];
  const 结果: 爱蜜莉雅冰晶[] = [];
  for (let i = 0; i < 状态.冰晶列表.length; i++) {
    const 节点 = 状态.冰晶列表[i];
    if (过滤 != null && !过滤(节点)) continue;
    结果.push(节点);
  }
  return 结果;
}

/**
 * 读取并移除冰晶（Q 穿晶 / R 读取前置节点）。
 * 规则："最旧" 取序号最小，"最近" 取序号最大；返回被读取节点信息（特效已销毁），无节点返回 null。
 */
export function 读取爱蜜莉雅冰晶(
  this: void,
  英雄: any,
  规则: "最旧" | "最近" = "最旧",
): 爱蜜莉雅冰晶 | null {
  const 状态 = 爱蜜莉雅状态表[取句柄(英雄)];
  if (状态 == null || 状态.冰晶列表.length <= 0) return null;
  let 目标序号 = -1;
  if (规则 === "最旧") {
    目标序号 = 状态.冰晶列表[0].序号;
  } else {
    目标序号 = 状态.冰晶列表[状态.冰晶列表.length - 1].序号;
  }
  return 移除爱蜜莉雅冰晶(英雄, 目标序号);
}

/** 按创建序号移除单枚冰晶（销毁特效与引用）。返回被移除节点或 null。 */
export function 移除爱蜜莉雅冰晶(this: void, 英雄: any, 序号: number): 爱蜜莉雅冰晶 | null {
  const 状态 = 爱蜜莉雅状态表[取句柄(英雄)];
  if (状态 == null) return null;
  for (let i = 0; i < 状态.冰晶列表.length; i++) {
    const 节点 = 状态.冰晶列表[i];
    if (节点.序号 !== 序号) continue;
    状态.冰晶列表.splice(i, 1);
    销毁点特效(节点.特效句柄);
    节点.已读取 = true;
    return 节点;
  }
  return null;
}

/** 清理全部冰晶（技能结束/场景清理）。返回清理数量。 */
export function 清理爱蜜莉雅全部冰晶(this: void, 英雄: any): number {
  const 状态 = 爱蜜莉雅状态表[取句柄(英雄)];
  if (状态 == null) return 0;
  let 数量 = 0;
  while (状态.冰晶列表.length > 0) {
    if (移除爱蜜莉雅冰晶(英雄, 状态.冰晶列表[0].序号) != null) 数量++;
  }
  return 数量;
}

//=============================================================================
// D 强化状态（A7 使用，先建立容器与生命周期）
//=============================================================================

export function 获取爱蜜莉雅D强化(this: void, 英雄: any): 爱蜜莉雅D强化状态 | null {
  const 状态 = 爱蜜莉雅状态表[取句柄(英雄)];
  if (状态 == null || 状态.D强化 == null || !状态.D强化.激活) return null;
  if (状态.D强化.到期时间 > 0 && getGameTime() >= 状态.D强化.到期时间) {
    清理爱蜜莉雅D强化(英雄);
    return null;
  }
  return 状态.D强化;
}

/** 设置 D 强化状态（重复开启时覆盖旧状态，旧计时器由技能清理表负责清理）。 */
export function 设置爱蜜莉雅D强化(this: void, 英雄: any, 剩余次数: number, 持续毫秒: number): 爱蜜莉雅D强化状态 {
  const 状态 = 取或建状态(英雄);
  const 新状态: 爱蜜莉雅D强化状态 = {
    激活: true,
    剩余次数: 剩余次数 > 0 ? 剩余次数 : 0,
    到期时间: 持续毫秒 > 0 ? getGameTime() + 持续毫秒 : 0,
  };
  状态.D强化 = 新状态;
  return 新状态;
}

/** 消费一次强化资源；无资源返回 false。 */
export function 消费爱蜜莉雅D强化(this: void, 英雄: any): boolean {
  const 状态 = 获取爱蜜莉雅D强化(英雄);
  if (状态 == null) return false;
  if (状态.剩余次数 <= 0) return false;
  状态.剩余次数 -= 1;
  return true;
}

/** 清理 D 强化状态（到期/打断/死亡/R 收束）。 */
export function 清理爱蜜莉雅D强化(this: void, 英雄: any): void {
  const 状态 = 爱蜜莉雅状态表[取句柄(英雄)];
  if (状态 == null) return;
  状态.D强化 = null;
}

//=============================================================================
// 世界坐标进度 UI（蓄力/吟唱/锁定/延迟窗口，跟随施法者，统一销毁）
//=============================================================================

/** 登记世界坐标进度 UI 句柄（随英雄状态统一销毁；重复登记同一句柄自动去重）。 */
export function 登记爱蜜莉雅进度UI(this: void, 英雄: any, ui: any): void {
  if (ui == null || ui === 0) return;
  const 状态 = 取或建状态(英雄);
  for (let i = 0; i < 状态.进度UI列表.length; i++) {
    if (状态.进度UI列表[i] === ui) return;
  }
  状态.进度UI列表.push(ui);
}

/** 立即销毁指定世界坐标进度 UI 并从登记移除。 */
export function 销毁爱蜜莉雅进度UI(this: void, 英雄: any, ui: any): void {
  if (ui == null || ui === 0) return;
  const 状态 = 爱蜜莉雅状态表[取句柄(英雄)];
  销毁世界坐标进度UI(ui);
  if (状态 == null) return;
  for (let i = 0; i < 状态.进度UI列表.length; i++) {
    if (状态.进度UI列表[i] === ui) {
      状态.进度UI列表.splice(i, 1);
      return;
    }
  }
}

function 清理全部进度UI(this: void, 状态: 爱蜜莉雅英雄状态): void {
  while (状态.进度UI列表.length > 0) {
    const ui = 状态.进度UI列表[0];
    状态.进度UI列表.splice(0, 1);
    销毁世界坐标进度UI(ui);
  }
}

//=============================================================================
// 技能清理表（技能实例登记打断/目标失效/结束清理；统一回收时执行）
//=============================================================================

/** 登记技能清理回调，返回注销函数（幂等）。 */
export function 登记爱蜜莉雅技能清理(
  this: void,
  英雄: any,
  标签: string,
  清理: (this: void) => void,
): (this: void) => void {
  const 状态 = 取或建状态(英雄);
  状态.技能清理表[标签] = 清理;
  return function 注销爱蜜莉雅技能清理(this: void): void {
    const 当前 = 爱蜜莉雅状态表[取句柄(英雄)];
    if (当前 != null && 当前.技能清理表[标签] === 清理) delete 当前.技能清理表[标签];
  };
}

function 执行全部技能清理(this: void, 状态: 爱蜜莉雅英雄状态): void {
  for (const 标签 in 状态.技能清理表) {
    const 清理 = 状态.技能清理表[标签];
    if (清理 != null) 清理();
  }
  // 清空后保留空表（防重入遍历）
  for (const 标签 in 状态.技能清理表) delete 状态.技能清理表[标签];
}

//=============================================================================
// 统一回收
//=============================================================================

/**
 * 统一回收入口：英雄死亡 / 技能打断 / 目标失效 / 地图清理 / 主动清理。
 * 依次清理：冰晶节点 → D 强化 → 世界坐标进度 UI → 技能清理表 → 摘除状态表项。幂等。
 */
export function 清理爱蜜莉雅状态(this: void, 英雄: any, 原因: 爱蜜莉雅清理原因 = "主动清理"): boolean {
  if (英雄 == null || 英雄 === 0) return false;
  const id = 取句柄(英雄);
  const 状态 = 爱蜜莉雅状态表[id];
  if (状态 == null) return false;
  if (状态.已清理) return true;
  状态.已清理 = true;
  void 原因; // 原因用于日志/扩展，当前无日志输出
  清理爱蜜莉雅全部冰晶(英雄);
  清理爱蜜莉雅D强化(英雄);
  清理全部进度UI(状态);
  执行全部技能清理(状态);
  delete 爱蜜莉雅状态表[id];
  return true;
}

function 销毁状态内全部冰晶特效(this: void, 状态: 爱蜜莉雅英雄状态): void {
  while (状态.冰晶列表.length > 0) {
    const 节点 = 状态.冰晶列表[0];
    状态.冰晶列表.splice(0, 1);
    销毁点特效(节点.特效句柄);
    节点.已读取 = true;
  }
}

/** 地图清理 / 场景结束：清理全部爱蜜莉雅状态（不依赖单位句柄反查，TSTL 无 handle 反查 API）。返回清理数量。 */
export function 清理全部爱蜜莉雅状态(this: void, 原因: 爱蜜莉雅清理原因 = "地图清理"): number {
  let 数量 = 0;
  const ids: number[] = [];
  for (const id in 爱蜜莉雅状态表) ids.push(Number(id));
  for (let i = 0; i < ids.length; i++) {
    const 状态 = 爱蜜莉雅状态表[ids[i]];
    if (状态 == null || 状态.已清理) continue;
    状态.已清理 = true;
    void 原因;
    销毁状态内全部冰晶特效(状态);
    清理全部进度UI(状态);
    执行全部技能清理(状态);
    delete 爱蜜莉雅状态表[ids[i]];
    数量++;
  }
  return 数量;
}

/** 仅供测试/调试：当前登记中的英雄数量与冰晶总数。 */
export function 获取爱蜜莉雅状态统计(this: void): { 英雄数: number; 冰晶总数: number } {
  let 英雄数 = 0;
  let 冰晶总数 = 0;
  for (const id in 爱蜜莉雅状态表) {
    const 状态 = 爱蜜莉雅状态表[id];
    if (状态 != null) {
      英雄数++;
      冰晶总数 += 状态.冰晶列表.length;
    }
  }
  return { 英雄数, 冰晶总数 };
}

// 确保死亡监听在模块加载时注册（供 index.ts 统一导入）
确保死亡监听();

export {};

//=============================================================================
// 动作表现辅助（A9：动作通过配置指定索引播放；映射待实机确认，见规划 8.1）
//=============================================================================

/** 播放爱蜜莉雅施法动作（接收动作槽，索引/持续秒全部配置驱动），持续后恢复 stand。 */
export function 播放爱蜜莉雅动作(this: void, 英雄: any, 槽: { 索引: number; 持续秒: number }): void {
  const 动作索引 = 槽.索引;
  const 持续秒 = 槽.持续秒;
  if (英雄 == null || 英雄 === 0 || 动作索引 <= 0) return;
  jass.SetUnitAnimationByIndex(英雄, 动作索引);
  if (持续秒 > 0) {
    const 恢复ID = addDelayedCallback(持续秒 * 1000, function 恢复站立动作(this: void): void {
      if (单位存活(英雄)) jass.SetUnitAnimation(英雄, "stand");
    });
    const 状态 = 爱蜜莉雅状态表[取单位ID(英雄)];
    if (状态 != null) 状态.技能清理表["动作恢复-" + 动作索引] = function 动作恢复清理(this: void): void {
      removeDelayedCallback(恢复ID);
    };
  }
}
