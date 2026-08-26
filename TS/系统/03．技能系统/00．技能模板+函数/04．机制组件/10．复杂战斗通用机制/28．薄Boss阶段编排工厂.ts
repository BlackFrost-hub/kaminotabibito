/** @noSelfInFile */
/**
 * 薄 Boss 阶段编排工厂（H-04）
 *
 * 审查结论：现有组件已覆盖大部分阶段能力——
 * - 阶段上下文（01）：阶段 ID、血量节点触发、on进入、防重复进入、销毁。
 * - 战斗技能调度器（13）：技能级 阶段允许 + 互斥锁 + 可抢占独占。
 * - 非死亡Boss收束时间线（24）：战斗结束统一收束。
 * 缺口仅三项：阶段离开回调、每阶段独立清理篮子、阶段技能池启停适配。
 * 本工厂只补这三项（组合 阶段上下文，不重复实现阶段驱动）：
 *
 * - 阶段切换顺序固定：旧阶段 on离开 → 清理旧阶段篮子 → 新阶段 on进入。
 * - 每阶段独立清理篮子：登记的回调/特效/单位随离开或销毁统一清理。
 * - 阶段技能池：定义后可生成 阶段允许 函数直接接入战斗技能调度器；未定义 = 不限制。
 * - 战斗结束统一收束：销毁() 等价全部阶段离开 + 清理（幂等）。
 *
 * 公共层不含 Boss 名称、台词、模型、坐标、护卫与剧情条件。
 */

import { 创建阶段上下文, type 阶段上下文 } from "./01．阶段上下文";
import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { 创建机制清理篮子 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.06．机制清理.01．机制清理篮子") as {
  创建机制清理篮子: (this: void, 名称: string) => 机制清理篮子;
};

export interface 薄阶段定义 {
  /** 阶段 ID（唯一） */
  ID: string;
  /** 低于等于该血量百分比时进入此阶段；初始阶段不用填 */
  血量百分比?: number;
  /** 进入阶段回调（在旧阶段离开与清理之后触发） */
  on进入?: (this: void, 编排: 薄Boss阶段编排) => void;
  /** 离开阶段回调（先于清理篮子执行） */
  on离开?: (this: void, 编排: 薄Boss阶段编排) => void;
  /** 阶段技能池：定义后仅池内技能允许释放（配合 生成阶段允许函数 接入战斗技能调度器） */
  技能池?: string[];
}

export interface 薄Boss阶段编排参数 {
  名称: string;
  /** Boss 单位 */
  单位: any;
  初始阶段ID: string;
  阶段列表: 薄阶段定义[];
  /** 外部总清理篮子（可选；登记编排整体销毁） */
  清理篮子?: 机制清理篮子;
  /** 血量节点检测间隔毫秒（透传阶段上下文） */
  Tick间隔毫秒?: number;
}

export interface 薄Boss阶段编排 {
  单位: any;
  取当前阶段ID(this: void): string;
  是阶段(this: void, 阶段ID: string): boolean;
  /** 业务条件触发：手动进入阶段（同 ID 防重复；返回 false = 已在该阶段或不存在） */
  手动进入阶段(this: void, 阶段ID: string, 当前百分比?: number): boolean;
  /**
   * 生成指定技能键的阶段允许函数，直接作为 战斗技能定义.阶段允许 使用。
   * 技能所属阶段未定义技能池时不限制（始终允许）。
   */
  生成阶段允许函数(this: void, 技能键: string): (this: void) => boolean;
  /** 取阶段清理篮子（登记本阶段回调/特效/单位；离开或销毁时统一清理） */
  取阶段清理篮子(this: void, 阶段ID: string): 机制清理篮子 | null;
  /** 战斗结束 / 手动收束：离开当前阶段 + 清理全部阶段篮子（幂等） */
  销毁(this: void): void;
}

function 创建空薄Boss阶段编排(this: void, 单位: any): 薄Boss阶段编排 {
  const 空编排 = {} as 薄Boss阶段编排;
  空编排.单位 = 单位;
  空编排.取当前阶段ID = function 空阶段ID(this: void): string { return ""; };
  空编排.是阶段 = function 空是阶段(this: void, _阶段ID: string): boolean { return false; };
  空编排.手动进入阶段 = function 空进入阶段(this: void, _阶段ID: string, _当前百分比?: number): boolean { return false; };
  空编排.生成阶段允许函数 = function 空生成阶段允许(this: void, _技能键: string): (this: void) => boolean {
    return function 空阶段允许(this: void): boolean { return false; };
  };
  空编排.取阶段清理篮子 = function 空取阶段篮子(this: void, _阶段ID: string): 机制清理篮子 | null { return null; };
  空编排.销毁 = function 空销毁(this: void): void {};
  return 空编排;
}

function 转换阶段定义(
  this: void,
  阶段: 薄阶段定义,
  执行进入: (this: void, 阶段: 薄阶段定义) => void,
): {
  ID: string;
  血量百分比?: number;
  on进入?: (this: void, c: 阶段上下文, 百分比: number) => void;
} {
  return {
    ID: 阶段.ID,
    血量百分比: 阶段.血量百分比,
    on进入: function 阶段进入(this: void, _c: 阶段上下文, _百分比: number): void {
      执行进入(阶段);
    },
  };
}

export function 创建薄Boss阶段编排(this: void, 参数: 薄Boss阶段编排参数): 薄Boss阶段编排 {
  if (参数 == null || 参数.单位 == null || 参数.单位 === 0 || 参数.阶段列表 == null || 参数.阶段列表.length <= 0) {
    return 创建空薄Boss阶段编排(参数 != null ? 参数.单位 : null);
  }
  const 阶段表: Record<string, 薄阶段定义 | undefined> = {};
  const 篮子表: Record<string, 机制清理篮子 | undefined> = {};
  const 阶段技能池表: Record<string, string[] | undefined> = {};
  let 已销毁 = false;
  let 正在销毁 = false;
  let 待销毁 = false;
  let 当前已进入阶段ID = 参数.初始阶段ID;
  let 正在离开阶段 = false;

  let 初始阶段存在 = false;
  for (let i = 0; i < 参数.阶段列表.length; i++) {
    const 阶段 = 参数.阶段列表[i];
    if (阶段 == null || 阶段.ID == null || 阶段.ID === "" || 阶段表[阶段.ID] != null) {
      return 创建空薄Boss阶段编排(参数.单位);
    }
    阶段表[阶段.ID] = 阶段;
    if (阶段.ID === 参数.初始阶段ID) 初始阶段存在 = true;
    篮子表[阶段.ID] = 创建机制清理篮子(参数.名称 + "-阶段-" + 阶段.ID);
    if (阶段.技能池 != null) {
      const 池: string[] = [];
      for (let j = 0; j < 阶段.技能池.length; j++) 池.push(阶段.技能池[j]);
      阶段技能池表[阶段.ID] = 池;
    }
  }
  if (!初始阶段存在) return 创建空薄Boss阶段编排(参数.单位);

  const 编排 = {} as 薄Boss阶段编排;

  function 执行阶段进入(this: void, 阶段: 薄阶段定义): void {
    if (已销毁) return;
    当前已进入阶段ID = 阶段.ID;
    if (阶段.on进入 != null) 阶段.on进入(编排);
  }

  function 执行阶段离开(this: void, 阶段ID: string): void {
    if (阶段ID === "") return;
    const 阶段 = 阶段表[阶段ID];
    正在离开阶段 = true;
    if (阶段 != null && 阶段.on离开 != null) 阶段.on离开(编排);
    正在离开阶段 = false;
    if (当前已进入阶段ID === 阶段ID) 当前已进入阶段ID = "";
  }

  function 完成销毁(this: void): void {
    if (已销毁) return;
    已销毁 = true;
    待销毁 = false;
    for (const ID in 篮子表) {
      const 篮子 = 篮子表[ID];
      if (篮子 != null) 篮子.清理全部();
    }
    上下文.销毁();
    正在销毁 = false;
  }

  function 阶段键允许(this: void, 阶段ID: string, 技能键: string): boolean {
    const 池 = 阶段技能池表[阶段ID];
    if (池 == null) return true;
    for (let i = 0; i < 池.length; i++) {
      if (池[i] === 技能键) return true;
    }
    return false;
  }

  const 阶段上下文列表: Array<{
    ID: string;
    血量百分比?: number;
    on进入?: (this: void, c: 阶段上下文, 百分比: number) => void;
  }> = [];
  for (let i = 0; i < 参数.阶段列表.length; i++) {
    阶段上下文列表.push(转换阶段定义(参数.阶段列表[i], 执行阶段进入));
  }

  const 上下文: 阶段上下文 = 创建阶段上下文({
    名称: 参数.名称,
    单位: 参数.单位,
    初始阶段ID: 参数.初始阶段ID,
    Tick间隔毫秒: 参数.Tick间隔毫秒,
    阶段列表: 阶段上下文列表,
    on阶段变化: function 阶段变化(this: void, 新阶段ID: string, 旧阶段ID: string, _百分比: number): void {
      // 固定顺序：旧阶段 on离开 → 清理旧阶段篮子（新阶段 on进入 由阶段上下文随后触发）
      执行阶段离开(旧阶段ID);
      if (待销毁 || 已销毁) {
        完成销毁();
        return;
      }
      const 旧篮子 = 篮子表[旧阶段ID];
      if (旧篮子 != null) 旧篮子.清理全部();
      if (待销毁 || 已销毁) {
        完成销毁();
        return;
      }
      const 新篮子 = 篮子表[新阶段ID];
      if (新篮子 == null || 新篮子.已清理()) {
        篮子表[新阶段ID] = 创建机制清理篮子(参数.名称 + "-阶段-" + 新阶段ID);
      }
    },
  });

  编排.单位 = 参数.单位;
  编排.取当前阶段ID = function 取当前阶段ID(this: void): string {
    return 已销毁 ? "" : 当前已进入阶段ID;
  };
  编排.是阶段 = function 是阶段(this: void, 阶段ID: string): boolean {
    return !已销毁 && 当前已进入阶段ID === 阶段ID;
  };
  编排.手动进入阶段 = function 手动进入阶段(this: void, 阶段ID: string, 当前百分比?: number): boolean {
    if (已销毁 || 正在销毁 || 待销毁) return false;
    return 上下文.手动进入阶段(阶段ID, 当前百分比 ?? 1);
  };
  编排.生成阶段允许函数 = function 生成阶段允许函数(this: void, 技能键: string): (this: void) => boolean {
    return function 阶段允许(this: void): boolean {
      if (已销毁) return false;
      return 阶段键允许(当前已进入阶段ID, 技能键);
    };
  };
  编排.取阶段清理篮子 = function 取阶段清理篮子(this: void, 阶段ID: string): 机制清理篮子 | null {
    if (已销毁) return null;
    return 篮子表[阶段ID] ?? null;
  };
  编排.销毁 = function 销毁(this: void): void {
    if (已销毁) return;
    if (正在销毁) {
      待销毁 = true;
      return;
    }
    正在销毁 = true;
    const 当前ID = 当前已进入阶段ID;
    if (!正在离开阶段) 执行阶段离开(当前ID);
    else 当前已进入阶段ID = "";
    完成销毁();
  };

  if (参数.清理篮子 != null) {
    参数.清理篮子.登记清理(参数.名称 + "-薄阶段编排", function 薄阶段编排清理(this: void): void {
      编排.销毁();
    });
  }

  // 阶段上下文只在后续切换时调用 on进入；初始阶段需要由工厂补一次。
  const 初始阶段 = 阶段表[参数.初始阶段ID];
  if (初始阶段 != null) 执行阶段进入(初始阶段);

  return 编排;
}

/** 便捷：为战斗技能定义生成阶段允许（技能键绑定） */
export function 为技能生成阶段允许(this: void, 编排: 薄Boss阶段编排, 技能键: string): (this: void) => boolean {
  return 编排.生成阶段允许函数(技能键);
}
