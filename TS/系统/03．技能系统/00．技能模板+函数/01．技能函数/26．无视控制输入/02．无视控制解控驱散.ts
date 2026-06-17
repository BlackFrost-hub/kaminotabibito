/** @noSelfInFile */

import {
  按驱散等级清除单位Buff,
  清除单位控制类负面Buff,
  清除单位硬控制Buff合集,
  清除单位软控制Buff合集,
} from "../../02．通用函数/01．控制与Buff";
import {
  配置无视控制技能壳子,
  注册无视控制输入监听,
  注销无视控制输入监听,
  无视控制输入事件,
  无视控制输入回调,
  无视控制输入类型,
} from "./01．无视控制命令输入";

export interface 无视控制解控驱散配置 {
  驱散等级?: 1 | 2;
  清除控制?: boolean;
  清除软控制?: boolean;
  清除负面?: boolean;
  控制只清可驱散?: boolean;
  负面只清可驱散?: boolean;
  负面类型前缀?: string;
}

export interface 无视控制解控驱散结果 {
  控制Buff池数量: number;
  原生硬控制数量: number;
  原生软控制数量: number;
  负面驱散数量: number;
  总数: number;
}

export interface 无视控制解控驱散绑定配置 extends 无视控制解控驱散配置 {
  单位?: any;
  输入类型?: 无视控制输入类型 | 无视控制输入类型[];
  过滤?: (this: void, event: 无视控制输入事件) => boolean;
  完成?: (this: void, event: 无视控制输入事件, result: 无视控制解控驱散结果) => void;
}

export interface 简单无视控制解控驱散技能配置 extends 无视控制解控驱散绑定配置 {
  单位: any;
  技能ID: string | number;
  输入类型: 无视控制输入类型;
  命令?: string | number;
  图标?: string;
  提示?: string;
  扩展提示?: string;
  热键?: string;
  按钮X?: number;
  按钮Y?: number;
  冷却?: number;
  魔法消耗?: number;
}

export interface 简单无视控制解控驱散技能实例 {
  技能ID: number;
  输入监听: 无视控制输入回调;
}

function 输入类型匹配(实际类型: 无视控制输入类型, 配置类型: 无视控制输入类型 | 无视控制输入类型[] | undefined): boolean {
  if (配置类型 == null) return true;
  if (typeof 配置类型 === "string") return 实际类型 === 配置类型;

  for (let i = 0; i < 配置类型.length; i++) {
    if (实际类型 === 配置类型[i]) return true;
  }
  return false;
}

export function 执行无视控制解控驱散(单位: any, 配置: 无视控制解控驱散配置 = {}): 无视控制解控驱散结果 {
  const result: 无视控制解控驱散结果 = {
    控制Buff池数量: 0,
    原生硬控制数量: 0,
    原生软控制数量: 0,
    负面驱散数量: 0,
    总数: 0,
  };
  if (单位 == null || 单位 === 0) return result;

  if (配置.清除控制 !== false) {
    result.控制Buff池数量 = 清除单位控制类负面Buff(单位, 配置.控制只清可驱散 !== false);
    result.原生硬控制数量 = 清除单位硬控制Buff合集(单位);
  }

  if (配置.清除软控制 === true) {
    result.原生软控制数量 = 清除单位软控制Buff合集(单位);
  }

  if (配置.清除负面 !== false) {
    const 驱散等级 = 配置.驱散等级 ?? 1;
    const 负面类型前缀 = 配置.负面类型前缀 ?? "Debuff:";
    result.负面驱散数量 = 按驱散等级清除单位Buff(单位, 驱散等级, 负面类型前缀, 配置.负面只清可驱散 !== false);
  }

  result.总数 = result.控制Buff池数量 + result.原生硬控制数量 + result.原生软控制数量 + result.负面驱散数量;
  return result;
}

export function 绑定无视控制解控驱散输入(配置: 无视控制解控驱散绑定配置 = {}): 无视控制输入回调 {
  const callback = function (this: void, event: 无视控制输入事件): void {
    if (!输入类型匹配(event.输入类型, 配置.输入类型)) return;
    if (配置.单位 != null && 配置.单位 !== 0 && event.单位 !== 配置.单位) return;
    if (配置.过滤 != null && !配置.过滤(event)) return;

    const result = 执行无视控制解控驱散(event.单位, 配置);
    if (配置.完成 != null) 配置.完成(event, result);
  };

  注册无视控制输入监听(callback);
  return callback;
}

export function 解绑无视控制解控驱散输入(callback: 无视控制输入回调): void {
  注销无视控制输入监听(callback);
}

export function 配置简单无视控制解控驱散技能(配置: 简单无视控制解控驱散技能配置): 简单无视控制解控驱散技能实例 {
  const 技能ID = 配置无视控制技能壳子({
    单位: 配置.单位,
    技能ID: 配置.技能ID,
    输入类型: 配置.输入类型,
    命令: 配置.命令,
    图标: 配置.图标 ?? "ReplaceableTextures\\CommandButtons\\BTNDispelMagic.blp",
    提示: 配置.提示 ?? "解控驱散",
    扩展提示: 配置.扩展提示 ?? "无视控制立即使用，解除自身控制，并驱散可驱散负面效果。",
    热键: 配置.热键 ?? "D",
    按钮X: 配置.按钮X,
    按钮Y: 配置.按钮Y,
    冷却: 配置.冷却,
    魔法消耗: 配置.魔法消耗,
    持续时间: 0.01,
    英雄持续时间: 0.01,
  });

  const 输入监听 = 绑定无视控制解控驱散输入(配置);
  return { 技能ID, 输入监听 };
}

export {};
