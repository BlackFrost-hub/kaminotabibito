/** @noSelfInFile */

import { 动态矩形区域, 动态矩形区域组, 取动态矩形区域中心 } from "./01．动态矩形区域组";

export interface Boss战场地点位 {
  ID: string;
  名称?: string;
  X: number;
  Y: number;
}

export interface Boss战场地点位集 {
  取中心(): Boss战场地点位;
  按ID取(ID: string): Boss战场地点位 | undefined;
  按名称取(名称: string): Boss战场地点位 | undefined;
  取全部(): Boss战场地点位[];
}

function 转为点位(this: void, 区域: 动态矩形区域): Boss战场地点位 {
  const 中心 = 取动态矩形区域中心(区域);
  return {
    ID: 区域.配置.ID ?? 区域.配置.名称 ?? "",
    名称: 区域.配置.名称,
    X: 中心.x,
    Y: 中心.y,
  };
}

class Boss战场地点位集实现 implements Boss战场地点位集 {
  private 点位列表: Boss战场地点位[] = [];
  private 中心点位: Boss战场地点位;

  constructor(区域组: 动态矩形区域组 | undefined, 回退X: number, 回退Y: number) {
    if (区域组 != null) {
      const 区域列表 = 区域组.区域列表;
      for (let i = 0; i < 区域列表.length; i++) {
        this.点位列表.push(转为点位(区域列表[i]));
      }
    }
    this.中心点位 = this.点位列表.length > 0 ? this.点位列表[0] : { ID: "fallback", 名称: "回退点", X: 回退X, Y: 回退Y };
  }

  取中心(): Boss战场地点位 {
    return this.中心点位;
  }

  按ID取(ID: string): Boss战场地点位 | undefined {
    for (let i = 0; i < this.点位列表.length; i++) {
      if (this.点位列表[i].ID === ID) return this.点位列表[i];
    }
    return undefined;
  }

  按名称取(名称: string): Boss战场地点位 | undefined {
    for (let i = 0; i < this.点位列表.length; i++) {
      if (this.点位列表[i].名称 === 名称) return this.点位列表[i];
    }
    return undefined;
  }

  取全部(): Boss战场地点位[] {
    return this.点位列表;
  }
}

export function 创建Boss战场地点位集(this: void, 区域组: 动态矩形区域组 | undefined, 回退X: number, 回退Y: number): Boss战场地点位集 {
  return new Boss战场地点位集实现(区域组, 回退X, 回退Y);
}
