/** @noSelfInFile */
/**
 * 战斗技能实例生命周期工厂（H-01）
 *
 * 三级结构：单位上下文（按句柄）→ 技能实例表（按技能键）→ 实例清理篮子。
 * - 同一施法者多个同类实例并存；不同技能实例并行（全局唯一实例ID）。
 * - 每实例记录施法者/目标句柄、代次（同单位同技能键自增）、创建时间。
 * - 结束原因：完成 / 中断 / 施法者死亡 / 目标死亡 / 目标失效 / 单位替换 / 战斗结束 / 手动清理。
 * - 旧实例延迟回调通过代次比对失效，不得操作新实例（控制器提供 仍有效()）。
 * - 结束回调只执行一次；结束独立技能伤害实例（可选）；自定义清理登记。
 * - 按单位、技能键或实例 ID 查询与清理。
 *
 * 公共层只管生命周期、状态键与清理；伤害公式与表现由调用方在回调里自理。
 */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { 创建机制清理篮子 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.06．机制清理.01．机制清理篮子") as {
  创建机制清理篮子: (this: void, 名称: string) => 机制清理篮子;
};
const { 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
};
const { 单位存活, 取单位ID } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
  取单位ID: (this: void, unit: any) => number;
};

export type 战斗技能实例结束原因 =
  | "完成"
  | "中断"
  | "施法者死亡"
  | "目标死亡"
  | "目标失效"
  | "单位替换"
  | "战斗结束"
  | "手动清理";

export interface 战斗技能实例参数 {
  /** 技能键（同单位同类实例归组；代次按单位+技能键自增） */
  技能键: string;
  /** 施法者（死亡监听 + 句柄记录；单位替换检测基准） */
  施法者: any;
  /** 可选：读取当前施法者句柄，用于原单位被替换后仍由同一技能状态持有者调用校验。 */
  当前施法者读取?: (this: void) => any;
  /** 目标（可选；死亡监听 + 失效检测） */
  目标?: any;
  /** 独立技能伤害实例 ID（可选，结束时一并结束） */
  技能实例ID?: number;
  /** 外部总清理篮子（可选）；只负责触发本实例收束，实例资源始终使用私有篮子。 */
  清理篮子?: 机制清理篮子;
  /** 实例自定义数据 */
  数据?: any;
  结束回调?: (this: void, 原因: 战斗技能实例结束原因, 控制器: 战斗技能实例控制器) => void;
}

export interface 战斗技能实例控制器 {
  /** 全局唯一实例 ID */
  实例ID: number;
  /** 同单位同技能键内的代次（旧实例回调失效比对基准） */
  代次: number;
  技能键: string;
  施法者: any;
  目标: any;
  /** 创建时刻（getGameTime 毫秒） */
  创建时间: number;
  /** 结束原因（null = 未结束） */
  结束原因: 战斗技能实例结束原因 | null;
  数据: any;
  /** 当前代次是否仍有效（旧实例延迟回调进入前必须校验） */
  仍有效(this: void): boolean;
  /** 施法者句柄是否仍指向创建时单位（false = 单位替换） */
  施法者未替换(this: void): boolean;
  /** 校验目标：句柄不变且存活；失效返回 false */
  目标有效(this: void): boolean;
  /** 目标失效时自动收束（原因"目标失效"）；已结束返回 false */
  校验并收束目标(this: void): boolean;
  登记延迟回调(this: void, id: number): void;
  登记周期回调(this: void, id: number): void;
  登记特效(this: void, 特效: any): void;
  登记限时特效(this: void, 特效: any, 持续毫秒: number): void;
  登记单位(this: void, 单位: any): void;
  登记自定义清理(this: void, 名称: string, 清理: (this: void) => void): void;
  /** 正常完成 */
  完成(this: void): void;
  /** 施法中断 */
  中断(this: void): void;
  /** 手动清理 */
  手动清理(this: void): void;
  结束(this: void, 原因: 战斗技能实例结束原因): boolean;
  已结束(this: void): boolean;
}

//=============================================================================
// 单位上下文 → 技能实例表 → 实例（三级索引）
//=============================================================================

interface 单位技能表 {
  /** 技能键 → 实例列表（并存） */
  技能表: Record<string, 战斗技能实例控制器[] | undefined>;
  /** 技能键 → 当前代次 */
  代次表: Record<string, number | undefined>;
}

const 单位上下文表: Record<number, 单位技能表 | undefined> = {};
const 实例索引表: Record<number, 战斗技能实例控制器 | undefined> = {};
let 下一实例ID = 1;
let 死亡监听已注册 = false;

function 取或建单位技能表(this: void, 单位ID: number): 单位技能表 {
  let 表 = 单位上下文表[单位ID];
  if (表 == null) {
    表 = { 技能表: {}, 代次表: {} };
    单位上下文表[单位ID] = 表;
  }
  return 表;
}

function 摘除实例(this: void, 控制器: 战斗技能实例控制器): void {
  delete 实例索引表[控制器.实例ID];
  const 施法者ID = 取单位ID(控制器.施法者);
  const 表 = 单位上下文表[施法者ID];
  if (表 == null) return;
  const 列表 = 表.技能表[控制器.技能键];
  if (列表 == null) return;
  const idx = 列表.indexOf(控制器);
  if (idx >= 0) 列表.splice(idx, 1);
  if (列表.length <= 0) delete 表.技能表[控制器.技能键];
  let 技能数量 = 0;
  for (const 键 in 表.技能表) {
    if (表.技能表[键] != null) 技能数量 += 1;
  }
  if (技能数量 <= 0) delete 单位上下文表[施法者ID];
}

function 确保死亡监听(this: void): void {
  if (死亡监听已注册) return;
  死亡监听已注册 = true;
  registerDeathListener(function 战斗技能实例死亡收束(this: void, dyingUnit: any, _killingUnit: any): void {
    const 死亡ID = 取单位ID(dyingUnit);
    // 1) 作为施法者：全部实例按"施法者死亡"收束
    const 表 = 单位上下文表[死亡ID];
    if (表 != null) {
      const 快照: 战斗技能实例控制器[] = [];
      for (const 键 in 表.技能表) {
        const 列表 = 表.技能表[键];
        if (列表 == null) continue;
        for (let i = 0; i < 列表.length; i++) 快照.push(列表[i]);
      }
      for (let i = 0; i < 快照.length; i++) 快照[i].结束("施法者死亡");
      delete 单位上下文表[死亡ID];
    }
    // 2) 作为目标：含此目标的实例按"目标死亡"收束
    const 目标命中: 战斗技能实例控制器[] = [];
    for (const 单位ID in 实例索引表) {
      const 控制器 = 实例索引表[单位ID];
      if (控制器 == null) continue;
      if (控制器.目标 != null && 取单位ID(控制器.目标) === 死亡ID) 目标命中.push(控制器);
    }
    for (let i = 0; i < 目标命中.length; i++) 目标命中[i].结束("目标死亡");
  });
}

//=============================================================================
// 工厂入口
//=============================================================================

export function 创建战斗技能实例(this: void, 参数: 战斗技能实例参数): 战斗技能实例控制器 {
  确保死亡监听();
  const 实例ID = 下一实例ID++;
  const 施法者ID = 取单位ID(参数.施法者);
  const 表 = 取或建单位技能表(施法者ID);
  const 代次 = (表.代次表[参数.技能键] ?? 0) + 1;
  表.代次表[参数.技能键] = 代次;

  const 目标句柄ID = 参数.目标 != null ? 取单位ID(参数.目标) : 0;
  const 创建时间 = getGameTime();
  const 篮子 = 创建机制清理篮子("战斗技能实例-" + 参数.技能键 + "-" + 实例ID);

  let 结束原因: 战斗技能实例结束原因 | null = null;

  const 控制器 = {} as 战斗技能实例控制器;

  function 收束(this: void, 原因: 战斗技能实例结束原因): boolean {
    if (结束原因 != null) return false;
    结束原因 = 原因;
    控制器.结束原因 = 原因;
    篮子.清理全部();
    if (参数.技能实例ID != null) 结束独立技能伤害实例(参数.技能实例ID);
    摘除实例(控制器);
    if (参数.结束回调 != null) 参数.结束回调(原因, 控制器);
    return true;
  }

  控制器.实例ID = 实例ID;
  控制器.代次 = 代次;
  控制器.技能键 = 参数.技能键;
  控制器.施法者 = 参数.施法者;
  控制器.目标 = 参数.目标 ?? null;
  控制器.创建时间 = 创建时间;
  控制器.数据 = 参数.数据;

  控制器.仍有效 = function 仍有效(this: void): boolean {
    if (结束原因 != null) return false;
    const 表 = 单位上下文表[施法者ID];
    return 表 != null && (表.代次表[参数.技能键] ?? 0) === 代次;
  };
  控制器.施法者未替换 = function 施法者未替换(this: void): boolean {
    const 当前施法者 = 参数.当前施法者读取 != null ? 参数.当前施法者读取() : 参数.施法者;
    return 当前施法者 != null && 当前施法者 !== 0 && 取单位ID(当前施法者) === 施法者ID;
  };
  控制器.目标有效 = function 目标有效(this: void): boolean {
    if (参数.目标 == null) return false;
    if (取单位ID(参数.目标) !== 目标句柄ID) return false;
    return 单位存活(参数.目标);
  };
  控制器.校验并收束目标 = function 校验并收束目标(this: void): boolean {
    if (结束原因 != null) return false;
    if (参数.目标 == null) return false;
    if (控制器.目标有效()) return false;
    return 收束("目标失效");
  };
  控制器.登记延迟回调 = function (this: void, id: number): void {
    篮子.登记延迟回调("延迟回调-" + id, id);
  };
  控制器.登记周期回调 = function (this: void, id: number): void {
    篮子.登记周期回调("周期回调-" + id, id);
  };
  控制器.登记特效 = function (this: void, 特效: any): void {
    篮子.登记特效("特效-" + 实例ID + "-" + 取单位ID(特效), 特效);
  };
  控制器.登记限时特效 = function (this: void, 特效: any, 持续毫秒: number): void {
    篮子.登记限时特效("限时特效-" + 实例ID + "-" + 取单位ID(特效), 特效, 持续毫秒);
  };
  控制器.登记单位 = function (this: void, 单位: any): void {
    篮子.登记单位("单位-" + 取单位ID(单位), 单位);
  };
  控制器.登记自定义清理 = function (this: void, 名称: string, 清理: (this: void) => void): void {
    篮子.登记清理(名称, 清理);
  };
  控制器.完成 = function 完成(this: void): void {
    收束("完成");
  };
  控制器.中断 = function 中断(this: void): void {
    收束("中断");
  };
  控制器.手动清理 = function 手动清理(this: void): void {
    收束("手动清理");
  };
  控制器.结束 = function 结束(this: void, 原因: 战斗技能实例结束原因): boolean {
    return 收束(原因);
  };
  控制器.已结束 = function 已结束(this: void): boolean {
    return 结束原因 != null;
  };

  // 结束原因字段（收束时更新；读取即最新值，TSTL 安全）
  控制器.结束原因 = null;

  if (参数.清理篮子 != null) {
    参数.清理篮子.登记清理("战斗技能实例-" + 参数.技能键 + "-" + 实例ID, function 战斗技能实例总篮子收束(this: void): void {
      收束("战斗结束");
    });
  }

  实例索引表[实例ID] = 控制器;
  let 列表 = 表.技能表[参数.技能键];
  if (列表 == null) {
    列表 = [];
    表.技能表[参数.技能键] = 列表;
  }
  列表.push(控制器);
  return 控制器;
}

//=============================================================================
// 查询与批量清理
//=============================================================================

/** 按单位 + 技能键查询活跃实例（不传技能键 = 该单位全部） */
export function 查询战斗技能实例(this: void, 单位: any, 技能键?: string): 战斗技能实例控制器[] {
  const 表 = 单位上下文表[取单位ID(单位)];
  if (表 == null) return [];
  if (技能键 != null) {
    const 列表 = 表.技能表[技能键];
    if (列表 == null) return [];
    const 结果: 战斗技能实例控制器[] = [];
    for (let i = 0; i < 列表.length; i++) 结果.push(列表[i]);
    return 结果;
  }
  const 结果: 战斗技能实例控制器[] = [];
  for (const 键 in 表.技能表) {
    const 列表 = 表.技能表[键];
    if (列表 == null) continue;
    for (let i = 0; i < 列表.length; i++) 结果.push(列表[i]);
  }
  return 结果;
}

/** 按实例 ID 查询 */
export function 按ID查询战斗技能实例(this: void, 实例ID: number): 战斗技能实例控制器 | null {
  return 实例索引表[实例ID] ?? null;
}

/** 结束单位全部实例（默认原因"战斗结束"；技能键可选过滤） */
export function 结束单位战斗技能实例(
  this: void,
  单位: any,
  原因: 战斗技能实例结束原因 = "战斗结束",
  技能键?: string,
): number {
  const 列表 = 查询战斗技能实例(单位, 技能键);
  let 数量 = 0;
  for (let i = 0; i < 列表.length; i++) {
    if (列表[i].结束(原因)) 数量++;
  }
  return 数量;
}

/** 检测单位替换并收束（句柄变化时按"单位替换"结束该单位全部实例） */
export function 校验单位替换并收束(this: void, 单位: any): number {
  const 列表 = 查询战斗技能实例(单位);
  let 数量 = 0;
  for (let i = 0; i < 列表.length; i++) {
    if (!列表[i].施法者未替换() && 列表[i].结束("单位替换")) 数量++;
  }
  return 数量;
}
