/** @noSelfInFile */

import {
  添加强化普攻,
  清除强化普攻,
  获取强化普攻状态,
  单位拥有强化普攻,
  type 强化普攻弹道配置,
  type 强化普攻命中上下文,
  type 强化普攻结束上下文,
  type 强化普攻状态快照,
} from "../../01．技能函数/21．攻击效果/04．强化普攻";

export interface 下一次普攻强化参数 {
  单位?: any;
  名称?: string;
  持续秒?: number;
  持续时间?: number;
  持续毫秒?: number;
  次数?: number;
  最多强化次数?: number;
  伤害倍率?: number;
  额外伤害?: number;
  仅远程?: boolean;
  仅近战?: boolean;
  只认纯普攻?: boolean;
  允许技能普攻?: boolean;
  弹道?: 强化普攻弹道配置;
  恢复弹道?: 强化普攻弹道配置;
  on命中?: (this: void, 上下文: 强化普攻命中上下文) => void;
  on结束?: (this: void, 上下文: 强化普攻结束上下文) => void;
}

function 取强化普攻单位(this: void, 参数: 下一次普攻强化参数): any {
  return 参数.单位;
}

function 取强化普攻持续秒(this: void, 参数: 下一次普攻强化参数): number | undefined {
  if (参数.持续秒 != null) return 参数.持续秒;
  return 参数.持续时间;
}

export function 添加下一次普攻强化(this: void, 参数: 下一次普攻强化参数): boolean {
  if (参数 == null) return false;
  return 添加强化普攻({
    单位: 取强化普攻单位(参数),
    名称: 参数.名称,
    持续时间: 取强化普攻持续秒(参数),
    持续毫秒: 参数.持续毫秒,
    次数: 参数.次数 ?? 参数.最多强化次数 ?? 1,
    伤害倍率: 参数.伤害倍率,
    额外伤害: 参数.额外伤害,
    仅远程: 参数.仅远程,
    仅近战: 参数.仅近战,
    允许技能普攻: 参数.只认纯普攻 === true ? false : 参数.允许技能普攻,
    弹道: 参数.弹道,
    恢复弹道: 参数.恢复弹道,
    on命中: 参数.on命中,
    on结束: 参数.on结束,
  });
}

export function 清除下一次普攻强化(this: void, 单位: any, 名称?: string): void {
  清除强化普攻(单位, 名称);
}

export function 获取下一次普攻强化状态(this: void, 单位: any, 名称?: string): 强化普攻状态快照 | null {
  return 获取强化普攻状态(单位, 名称);
}

export function 单位拥有下一次普攻强化(this: void, 单位: any, 名称?: string): boolean {
  return 单位拥有强化普攻(单位, 名称);
}

export {};
