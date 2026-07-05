/** @noSelfInFile */
import {
  X_GAFC,
  jass,
  SetUnitAnimation,
  SetUnitTimeScale,
  零秒后播放单位动作,
  活动位移列表,
  位移映射,
  单位当前位移,
  冲锋参数,
  击退参数,
  位移结束原因,
  取句柄ID,
  快照单位组,
} from "./00．共享";
import { 创建位移实例, 结束位移ID, 停止单位位移 } from "./02．驱动与实例";
import { 尝试阻止自身位移技能 } from "../../../02．通用函数/20．位移技能限制";

function 计算冲锋行走动画倍率(持续时间?: number): number {
  if (持续时间 == null || 持续时间 <= 0) {
    return 1.5;
  }
  if (持续时间 >= 1.0) {
    return 1.5;
  }

  const 倍率 = 1.0 / 持续时间;
  if (倍率 > 2.5) {
    return 2.5;
  }
  return 倍率;
}

function 解析冲锋角度(单位: any, 参数: 冲锋参数): number | null {
  if (参数.角度 != null) return 参数.角度;
  if (参数.目标X != null && 参数.目标Y != null) {
    return X_GAFC(jass.GetUnitX(单位) as number, jass.GetUnitY(单位) as number, 参数.目标X, 参数.目标Y);
  }
  return null;
}

function 解析击退角度(单位: any, 参数: 击退参数): number | null {
  if (参数.角度 != null) return 参数.角度;

  if (参数.来源单位 != null && 参数.来源单位 !== 0) {
    return X_GAFC(
      jass.GetUnitX(参数.来源单位) as number,
      jass.GetUnitY(参数.来源单位) as number,
      jass.GetUnitX(单位) as number,
      jass.GetUnitY(单位) as number
    );
  }

  if (参数.来源X != null && 参数.来源Y != null) {
    return X_GAFC(参数.来源X, 参数.来源Y, jass.GetUnitX(单位) as number, jass.GetUnitY(单位) as number);
  }

  return null;
}

export function 开始冲锋(单位: any, 参数: 冲锋参数): number {
  if (尝试阻止自身位移技能(单位)) return 0;

  const 角度 = 解析冲锋角度(单位, 参数);
  if (角度 == null) return 0;

  const 原开始回调 = 参数.开始回调;
  const 原结束回调 = 参数.结束回调;
  const 行走动画倍率 = 计算冲锋行走动画倍率(参数.持续时间);
  const 合并参数: 冲锋参数 = {
    ...参数,
    开始回调: function (this: void, 移动单位: any, 位移ID: number): void {
      if (移动单位 != null && 移动单位 !== 0 && typeof SetUnitAnimation === "function") {
        SetUnitAnimation(移动单位, "walk");
      } else {
        零秒后播放单位动作(移动单位, "walk");
      }
      if (typeof SetUnitTimeScale === "function") {
        SetUnitTimeScale(移动单位, 行走动画倍率);
      }
      if (原开始回调 != null) {
        原开始回调(移动单位, 位移ID);
      }
    },
    结束回调: function (this: void, 移动单位: any, 原因: 位移结束原因, 位移ID: number, 命中目标?: any): void {
      if (移动单位 != null && 移动单位 !== 0 && typeof SetUnitTimeScale === "function") {
        SetUnitTimeScale(移动单位, 1.0);
      }
      if (原结束回调 != null) {
        原结束回调(移动单位, 原因, 位移ID, 命中目标);
      }
    },
  };
  return 创建位移实例(单位, 角度, 合并参数);
}

export function 开始击退(单位: any, 参数: 击退参数): number {
  const 角度 = 解析击退角度(单位, 参数);
  if (角度 == null) return 0;
  if (参数.主单位 == null && 参数.来源单位 != null && 参数.来源单位 !== 0) {
    return 创建位移实例(单位, 角度, { ...参数, 主单位: 参数.来源单位 });
  }
  return 创建位移实例(单位, 角度, 参数);
}

export function 开始单位组冲锋(单位组: any, 参数: 冲锋参数): number[] {
  const 单位列表 = 快照单位组(单位组);
  const 结果: number[] = [];
  for (const 单位 of 单位列表) {
    const 位移ID = 开始冲锋(单位, 参数);
    if (位移ID > 0) {
      结果.push(位移ID);
    }
  }
  return 结果;
}

export function 开始单位组击退(单位组: any, 参数: 击退参数): number[] {
  const 单位列表 = 快照单位组(单位组);
  const 结果: number[] = [];
  for (const 单位 of 单位列表) {
    const 位移ID = 开始击退(单位, 参数);
    if (位移ID > 0) {
      结果.push(位移ID);
    }
  }
  return 结果;
}

export function 停止位移(位移ID: number, 原因: 位移结束原因 = "中断"): boolean {
  return 结束位移ID(位移ID, 原因);
}

export { 停止单位位移 };

export function 单位是否正在位移(单位: any): boolean {
  const 位移ID = 单位当前位移[取句柄ID(单位)];
  return !!(位移ID && 位移映射[位移ID]);
}

export function 获取单位当前位移ID(单位: any): number {
  return 单位当前位移[取句柄ID(单位)] ?? 0;
}

export function 获取活跃位移数量(): number {
  return 活动位移列表.length;
}
