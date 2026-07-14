/** @noSelfInFile */
/**
 * 跳跃系统 - 驱动与实例
 *
 * 包含中心计时器注册、实例创建与销毁、Tick 驱动逻辑。
 */
import {
  CENTER_TIMER_TICKS,
  DEFAULT_JUMP_EFFECT_MODEL,
  X_GAFC,
  添加单位暂停,
  移除单位暂停,
  单位是否存在其他暂停占用,
  零秒后重置单位动画,
  跳跃实例,
  跳跃结束原因,
  跳跃参数,
  通用跳跃参数,
  活动跳跃列表,
  跳跃映射,
  单位当前跳跃,
  分配新跳跃ID,
  取句柄ID,
  单位存活,
  计算每tick位移,
  确保单位可设置飞行高度,
  单位已被暂停,
  GetUnitX,
  GetUnitY,
  GetUnitFlyHeight,
  SetUnitFlyHeight,
  IsUnitPaused,
} from "./00．共享";
import { 推进一步 } from "./01．移动与碰撞";

const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: () => void) => void;
  offTick10ms: (this: void, callback: () => void) => void;
};

let 已注册到中心计时器 = false;
let tick计数 = 0;

function 注册到中心计时器(): void {
  if (已注册到中心计时器) return;
  已注册到中心计时器 = true;
  onTick10ms(on跳跃系统Tick);
}

function 从中心计时器注销(): void {
  if (!已注册到中心计时器) return;
  已注册到中心计时器 = false;
  offTick10ms(on跳跃系统Tick);
}

function 尝试收尾中心计时器(): void {
  if (活动跳跃列表.length !== 0) return;
  tick计数 = 0;
  从中心计时器注销();
}

function 内部移除跳跃(实例: 跳跃实例): void {
  const 跳跃ID = 实例.id;
  const 单位ID = 实例.单位ID;

  delete 跳跃映射[跳跃ID];
  if (单位当前跳跃[单位ID] === 跳跃ID) {
    delete 单位当前跳跃[单位ID];
  }

  const idx = 实例.listIndex;
  const lastIdx = 活动跳跃列表.length - 1;
  if (idx !== lastIdx) {
    const last = 活动跳跃列表[lastIdx];
    活动跳跃列表[idx] = last;
    last.listIndex = idx;
  }
  活动跳跃列表.pop();
  尝试收尾中心计时器();
}

export function 结束跳跃实例(实例: 跳跃实例, 原因: 跳跃结束原因): void {
  if (跳跃映射[实例.id] !== 实例) return;

  const 单位 = 实例.单位;
  const 跳跃ID = 实例.id;
  const 结束回调 = 实例.结束回调;

  if (单位 != null && 单位 !== 0 && 实例.上次附加高度 !== 0) {
    const 当前高度 = GetUnitFlyHeight(单位);
    SetUnitFlyHeight(单位, 当前高度 - 实例.上次附加高度, 0);
    实例.上次附加高度 = 0;
  }
  if (实例.暂停单位) {
    移除单位暂停(单位, 实例.暂停来源);
  }
  if (单位存活(单位) && 原因 !== "死亡" && 原因 !== "主单位死亡") {
    零秒后重置单位动画(单位);
  }

  内部移除跳跃(实例);

  if (typeof 结束回调 === "function") {
    结束回调(单位, 原因, 跳跃ID);
  }
}

export function 结束跳跃ID(跳跃ID: number, 原因: 跳跃结束原因): boolean {
  const 实例 = 跳跃映射[跳跃ID];
  if (!实例) return false;
  结束跳跃实例(实例, 原因);
  return true;
}

export function 停止单位跳跃(单位: any, 原因: 跳跃结束原因 = "中断"): boolean {
  const 跳跃ID = 单位当前跳跃[取句柄ID(单位)];
  if (!跳跃ID) return false;
  return 结束跳跃ID(跳跃ID, 原因);
}

export function on跳跃系统Tick(): void {
  tick计数 += 1;
  if (tick计数 < CENTER_TIMER_TICKS) return;
  tick计数 = 0;

  let i = 0;
  while (i < 活动跳跃列表.length) {
    const 实例 = 活动跳跃列表[i];
    if (跳跃映射[实例.id] !== 实例) {
      i += 1;
      continue;
    }

    if (!单位存活(实例.单位)) {
      结束跳跃实例(实例, "死亡");
      continue;
    }

    if (实例.主单位死亡时中断 && 实例.主单位 != null && 实例.主单位 !== 0 && !单位存活(实例.主单位)) {
      结束跳跃实例(实例, "主单位死亡");
      continue;
    }

    if (单位已被暂停(实例.单位)) {
      if (!实例.暂停单位 || 单位是否存在其他暂停占用(实例.单位, 实例.暂停来源)) {
        i += 1;
        continue;
      }
    }

    const 结果 = 推进一步(实例);
    if (结果.停止) {
      结束跳跃实例(实例, 结果.原因 ?? "完成");
      continue;
    }

    i += 1;
  }
}

export function 解析跳跃角度(单位: any, 参数: 跳跃参数): number | null {
  if (参数.角度 != null) return 参数.角度;
  if (参数.目标X != null && 参数.目标Y != null) {
    return X_GAFC(
      GetUnitX(单位),
      GetUnitY(单位),
      参数.目标X,
      参数.目标Y
    );
  }
  return null;
}

export function 创建跳跃实例(单位: any, 角度: number, 参数: 通用跳跃参数): number {
  if (!单位存活(单位)) return 0;
  if (参数.距离 == null || 参数.距离 <= 0) return 0;
  if (参数.持续时间 == null || 参数.持续时间 <= 0) return 0;

  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return 0;

  停止单位跳跃(单位, "中断");
  确保单位可设置飞行高度(单位);

  const 每tick位移 = 计算每tick位移(参数.距离, 参数.持续时间);
  if (每tick位移 <= 0) return 0;

  const 跳跃ID = 分配新跳跃ID();
  const 实例: 跳跃实例 = {
    id: 跳跃ID,
    listIndex: 活动跳跃列表.length,
    单位,
    单位ID,
    主单位: 参数.主单位,
    主单位死亡时中断: 参数.主单位死亡时中断 !== false,
    角度,
    总距离: 参数.距离,
    已移动: 0,
    每tick位移,
    跳跃高度: 参数.跳跃高度 ?? 0,
    上次附加高度: 0,
    暂停单位: 参数.暂停单位 !== false,
    暂停来源: `跳跃系统:${跳跃ID}`,
    朝向跟随跳跃: 参数.朝向跟随跳跃 === true,
    跳跃特效: 参数.跳跃特效 ?? DEFAULT_JUMP_EFFECT_MODEL,
    落点过滤: 参数.落点过滤,
    结束回调: 参数.结束回调,
    开始回调: 参数.开始回调,
  };

  跳跃映射[跳跃ID] = 实例;
  单位当前跳跃[单位ID] = 跳跃ID;
  活动跳跃列表.push(实例);
  if (实例.暂停单位) {
    添加单位暂停(单位, 实例.暂停来源);
  }
  注册到中心计时器();

  if (typeof 参数.开始回调 === "function") {
    参数.开始回调(单位, 跳跃ID);
  }

  return 跳跃ID;
}
