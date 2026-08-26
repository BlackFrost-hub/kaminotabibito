/** @noSelfInFile */
/**
 * 区域进出与共享状态工厂（H-02）
 *
 * 在区域效果之上补齐可配置的进入 / 离开 / 停留 与共享引用计数：
 * - 中心：固定坐标、单位锚点或自定义读取函数（每帧取值，区域可移动）。
 * - 形状：圆形基础区域；其他形状通过 形状筛选 回调适配（先圆形粗筛再细筛）。
 * - 目标源：自定义函数返回目标列表（不限于单位枚举；目标可为任意带句柄对象）。
 * - 逐帧对比当前帧集合与上一帧集合，识别进入 / 离开 / 停留。
 * - 每实例独立状态键；可选共享状态键 + 引用计数（多区域覆盖同一目标时计数叠加）。
 * - 目标失效（句柄无效或自定义校验失败）强制离开；销毁时按进入顺序（稳定顺序）释放全部目标。
 *
 * 回调顺序（每 Tick 固定，由测试固定）：
 *   ① 离开（上一帧有、本帧无；按进入先后顺序）
 *   ② 进入（本帧新出现；按目标源返回顺序）
 *   ③ 停留（两帧都有；按进入先后顺序）
 * 销毁时：对上一帧成员按进入先后顺序逐个触发 on离开（含共享计数递减），最后 on销毁。
 */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { addPeriodicCallback, removePeriodicCallback, addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { 单位存活, 取单位ID, 距离平方XY } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
  取单位ID: (this: void, unit: any) => number;
  距离平方XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;

export type 区域中心配置 =
  | { 类型: "固定"; X: number; Y: number }
  | { 类型: "锚点单位"; 单位: any }
  | { 类型: "自定义"; 读取: (this: void) => { X: number; Y: number } };

export interface 区域进出参数 {
  名称: string;
  清理篮子?: 机制清理篮子;
  中心: 区域中心配置;
  半径: number;
  /** 检测间隔毫秒（默认 100） */
  Tick间隔毫秒?: number;
  /** 持续毫秒（可选；到期自动销毁，原因"到期"） */
  持续毫秒?: number;
  /** 目标源：返回本帧候选目标列表（自定义，不限于单位枚举） */
  目标源: (this: void) => any[];
  /** 目标 ID 提取（默认取单位句柄；非单位目标必须提供） */
  取目标ID?: (this: void, 目标: any) => number;
  /** 目标坐标读取（默认按单位句柄读取；非单位目标必须提供） */
  取目标坐标?: (this: void, 目标: any) => { X: number; Y: number };
  /** 目标有效性校验（默认单位句柄判空 + 存活；失效目标强制离开） */
  目标有效?: (this: void, 目标: any) => boolean;
  /** 其他形状适配：在圆形粗筛后进行细筛（true = 命中区域内） */
  形状筛选?: (this: void, 目标: any, X: number, Y: number) => boolean;
  /** 共享状态键（可选）：同键区域对同一目标的进入/离开叠加引用计数 */
  共享键?: string;
  on进入?: (this: void, 目标: any, 区域: 区域进出实例) => void;
  on停留?: (this: void, 目标: any, 区域: 区域进出实例) => void;
  on离开?: (this: void, 目标: any, 区域: 区域进出实例) => void;
  /** 共享计数归零（该目标不再被任何同键区域覆盖） */
  on共享离开?: (this: void, 目标: any, 共享键: string) => void;
  on销毁?: (this: void, 原因: 区域销毁原因, 区域: 区域进出实例) => void;
}

export type 区域销毁原因 = "手动销毁" | "到期" | "清理篮子";

interface 区域成员记录 {
  目标: any;
  ID: number;
  进入序号: number;
}

interface 共享计数记录 {
  计数: number;
  数据: any;
}

const 共享计数表: Record<string, Record<number, 共享计数记录 | undefined> | undefined> = {};

export interface 区域进出实例 {
  /** 当前帧成员（进入顺序） */
  取当前成员(this: void): any[];
  /** 本实例独立状态（按目标 ID 键） */
  取状态(this: void, 目标: any): any;
  /** 共享状态（同 共享键 区域共享；计数归零后清除） */
  取共享状态(this: void, 目标: any): any;
  /** 目标当前共享计数（无共享键返回 0） */
  取共享计数(this: void, 目标: any): number;
  /** 当前中心坐标 */
  取中心(this: void): { X: number; Y: number };
  销毁(this: void, 原因?: 区域销毁原因): void;
  已销毁(this: void): boolean;
}

function 默认取目标ID(this: void, 目标: any): number {
  return 取单位ID(目标);
}

function 默认目标有效(this: void, 目标: any): boolean {
  if (目标 == null || 目标 === 0) return false;
  return 单位存活(目标);
}

function 默认取目标坐标(this: void, 目标: any): { X: number; Y: number } {
  return { X: GetUnitX(目标), Y: GetUnitY(目标) };
}

export function 创建区域进出(this: void, 参数: 区域进出参数): 区域进出实例 | undefined {
  if (!(参数.半径 > 0) || !(参数.Tick间隔毫秒 == null || 参数.Tick间隔毫秒 > 0)) return undefined;
  const 取ID = 参数.取目标ID ?? 默认取目标ID;
  const 取坐标 = 参数.取目标坐标 ?? 默认取目标坐标;
  const 校验有效 = 参数.目标有效 ?? 默认目标有效;

  let 周期ID = 0;
  let 到期回调ID = 0;
  let 已销毁 = false;
  let 正在触发离开 = false;
  let 待销毁原因: 区域销毁原因 | null = null;
  let 进入序号 = 0;
  const 成员列表: 区域成员记录[] = [];
  const 实例状态: Record<number, any> = {};
  const 实例 = {} as 区域进出实例;

  function 当前中心(this: void): { X: number; Y: number } {
    if (参数.中心.类型 === "固定") return { X: 参数.中心.X, Y: 参数.中心.Y };
    if (参数.中心.类型 === "锚点单位") {
      const 单位 = 参数.中心.单位;
      if (单位 == null || 单位 === 0) return { X: 0, Y: 0 };
      return { X: GetUnitX(单位), Y: GetUnitY(单位) };
    }
    const pos = 参数.中心.读取();
    return pos != null ? pos : { X: 0, Y: 0 };
  }

  function 共享键表(this: void): Record<number, 共享计数记录 | undefined> | null {
    if (参数.共享键 == null) return null;
    let 表 = 共享计数表[参数.共享键];
    if (表 == null) {
      表 = {};
      共享计数表[参数.共享键] = 表;
    }
    return 表;
  }

  function 成员索引(this: void, ID: number): number {
    for (let i = 0; i < 成员列表.length; i++) {
      if (成员列表[i].ID === ID) return i;
    }
    return -1;
  }

  function 触发离开(this: void, 记录: 区域成员记录): void {
    正在触发离开 = true;
    const idx = 成员索引(记录.ID);
    if (idx >= 0) 成员列表.splice(idx, 1);
    if (参数.共享键 != null) {
      const 表 = 共享计数表[参数.共享键];
      const rec = 表 != null ? 表[记录.ID] : undefined;
      if (rec != null) {
        rec.计数 -= 1;
        if (rec.计数 <= 0) {
          if (表 != null) delete 表[记录.ID];
          if (表 != null) {
            let 仍有共享成员 = false;
            for (const ID in 表) {
              if (表[Number(ID)] != null) {
                仍有共享成员 = true;
                break;
              }
            }
            if (!仍有共享成员) delete 共享计数表[参数.共享键];
          }
          if (参数.on共享离开 != null) 参数.on共享离开(记录.目标, 参数.共享键);
        }
      }
    }
    if (参数.on离开 != null) 参数.on离开(记录.目标, 实例);
    delete 实例状态[记录.ID];
    正在触发离开 = false;
    if (待销毁原因 != null) {
      const 原因 = 待销毁原因;
      待销毁原因 = null;
      销毁(原因);
    }
  }

  function 销毁(this: void, 原因: 区域销毁原因): void {
    if (已销毁) return;
    if (正在触发离开) {
      if (待销毁原因 == null) 待销毁原因 = 原因;
      return;
    }
    已销毁 = true;
    if (周期ID !== 0) {
      removePeriodicCallback(周期ID);
      周期ID = 0;
    }
    if (到期回调ID !== 0) {
      removeDelayedCallback(到期回调ID);
      到期回调ID = 0;
    }
    // 稳定顺序：按进入先后释放全部成员
    while (成员列表.length > 0) 触发离开(成员列表[0]);
    if (参数.on销毁 != null) 参数.on销毁(原因, 实例);
  }

  function 处理Tick(this: void): void {
    if (已销毁) return;
    const c = 当前中心();
    const 半径平方 = 参数.半径 * 参数.半径;

    // 采集本帧命中集合
    const 候选 = 参数.目标源() ?? [];
    const 本帧: { 目标: any; ID: number }[] = [];
    for (let i = 0; i < 候选.length; i++) {
      const 目标 = 候选[i];
      if (目标 == null || 目标 === 0) continue;
      if (!校验有效(目标)) continue;
      const 坐标 = 取坐标(目标);
      if (坐标 == null) continue;
      const x = 坐标.X;
      const y = 坐标.Y;
      if (距离平方XY(x, y, c.X, c.Y) > 半径平方) continue;
      if (参数.形状筛选 != null && !参数.形状筛选(目标, c.X, c.Y)) continue;
      const ID = 取ID(目标);
      if (!(ID > 0)) continue;
      let 重复 = false;
      for (let j = 0; j < 本帧.length; j++) {
        if (本帧[j].ID === ID) {
          重复 = true;
          break;
        }
      }
      if (!重复) 本帧.push({ 目标, ID });
    }

    // ① 离开：上一帧有、本帧无（或目标失效），按进入先后顺序
    let 离开索引 = 0;
    while (离开索引 < 成员列表.length) {
      const 记录 = 成员列表[离开索引];
      if (!校验有效(记录.目标)) {
        触发离开(记录);
        if (已销毁) return;
        continue;
      }
      let 仍在 = false;
      for (let j = 0; j < 本帧.length; j++) {
        if (本帧[j].ID === 记录.ID) {
          仍在 = true;
          break;
        }
      }
      if (!仍在) {
        触发离开(记录);
        if (已销毁) return;
        continue;
      }
      离开索引 += 1;
    }

    // ② 进入：本帧新出现，按目标源顺序
    for (let i = 0; i < 本帧.length; i++) {
      const 命中 = 本帧[i];
      if (成员索引(命中.ID) >= 0) continue;
      const 记录: 区域成员记录 = { 目标: 命中.目标, ID: 命中.ID, 进入序号: 进入序号++ };
      成员列表.push(记录);
      实例状态[命中.ID] = {};
      if (参数.共享键 != null) {
        const 表 = 共享键表();
        let rec = 表 != null ? 表[命中.ID] : undefined;
        if (rec == null) {
          rec = { 计数: 0, 数据: {} };
          if (表 != null) 表[命中.ID] = rec;
        }
        rec.计数 += 1;
      }
      if (参数.on进入 != null) 参数.on进入(命中.目标, 实例);
      if (已销毁) return;
    }

    // ③ 停留：按进入先后顺序
    for (let i = 0; i < 成员列表.length; i++) {
      if (参数.on停留 != null) 参数.on停留(成员列表[i].目标, 实例);
      if (已销毁) return;
    }
  }

  实例.取当前成员 = function 取当前成员(this: void): any[] {
    const 结果: any[] = [];
    for (let i = 0; i < 成员列表.length; i++) 结果.push(成员列表[i].目标);
    return 结果;
  };
  实例.取状态 = function 取状态(this: void, 目标: any): any {
    const 状态 = 实例状态[取ID(目标)];
    return 状态 != null ? 状态 : null;
  };
  实例.取共享状态 = function 取共享状态(this: void, 目标: any): any {
    if (参数.共享键 == null) return null;
    const 表 = 共享计数表[参数.共享键];
    const rec = 表 != null ? 表[取ID(目标)] : undefined;
    return rec != null ? rec.数据 : null;
  };
  实例.取共享计数 = function 取共享计数(this: void, 目标: any): number {
    if (参数.共享键 == null) return 0;
    const 表 = 共享计数表[参数.共享键];
    const rec = 表 != null ? 表[取ID(目标)] : undefined;
    return rec != null ? rec.计数 : 0;
  };
  实例.取中心 = 当前中心;
  实例.销毁 = function 销毁包装(this: void, 原因?: 区域销毁原因): void {
    销毁(原因 ?? "手动销毁");
  };
  实例.已销毁 = function 已销毁查询(this: void): boolean {
    return 已销毁;
  };

  if (参数.清理篮子 != null) {
    参数.清理篮子.登记清理(参数.名称 + "-区域进出", function 区域进出清理(this: void): void {
      销毁("清理篮子");
    });
  }

  周期ID = addPeriodicCallback(参数.Tick间隔毫秒 ?? 100, 处理Tick);
  if (参数.持续毫秒 != null && 参数.持续毫秒 > 0) {
    const 到期处理 = function 区域进出到期(this: void): void {
      到期回调ID = 0;
      销毁("到期");
    };
    到期回调ID = addDelayedCallback(参数.持续毫秒, 到期处理);
  }
  return 实例;
}
