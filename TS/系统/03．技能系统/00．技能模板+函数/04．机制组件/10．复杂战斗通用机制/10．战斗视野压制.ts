/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { 施加视野变化Buff, 移除单位视野变化Buff } = require("../../01．技能函数/19．拓展效果/02．buff/05．视野变化") as {
  施加视野变化Buff: (this: void, 来源单位: any, 目标单位: any, 参数: any) => boolean;
  移除单位视野变化Buff: (this: void, 单位: any) => boolean;
};

export interface 战斗视野压制参数 {
  清理?: 机制清理篮子;
  名称: string;
  来源单位?: any;
  目标列表: any[];
  持续时间: number;
  视野减少值: number;
  BuffID?: string;
  图标路径?: string;
  特效路径?: string;
  叠加键?: string;
}

export function 施加战斗视野压制(this: void, 参数: 战斗视野压制参数): void {
  for (let i = 0; i < 参数.目标列表.length; i++) {
    const target = 参数.目标列表[i];
    if (target == null || target === 0) continue;
    施加视野变化Buff(参数.来源单位 ?? null, target, {
      BuffID: 参数.BuffID,
      持续时间: 参数.持续时间,
      视野值: 参数.视野减少值 > 0 ? -参数.视野减少值 : 参数.视野减少值,
      叠加键: 参数.叠加键 ?? 参数.名称,
      图标路径: 参数.图标路径,
      特效路径: 参数.特效路径,
    });
  }
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 战斗视野压制清理(this: void): void {
      for (let i = 0; i < 参数.目标列表.length; i++) {
        const target = 参数.目标列表[i];
        if (target != null && target !== 0) 移除单位视野变化Buff(target);
      }
    });
  }
}
