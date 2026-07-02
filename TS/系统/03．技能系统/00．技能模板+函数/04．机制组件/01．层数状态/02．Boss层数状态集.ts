/** @noSelfInFile */

import {
  创建可配置层数状态,
  可配置层数状态配置,
  可配置层数状态控制器,
} from "./01．可配置层数状态";

export interface Boss层数状态定义 extends 可配置层数状态配置 {
  ID: string;
}

export interface Boss层数最高结果 {
  ID: string;
  层数: number;
}

export interface Boss层数状态集 {
  取控制器(ID: string): 可配置层数状态控制器 | undefined;
  增加(ID: string, 单位: any, 层数?: number, 原因?: string): number;
  设置(ID: string, 单位: any, 层数: number, 原因?: string): number;
  减少(ID: string, 单位: any, 层数?: number, 原因?: string): number;
  清空(ID: string, 单位: any, 原因?: string): void;
  清空单位全部(单位: any, 原因?: string): void;
  取层数(ID: string, 单位: any): number;
  取最高层数(单位: any): Boss层数最高结果;
  销毁(): void;
}

class Boss层数状态集实现 implements Boss层数状态集 {
  private 控制器表: Record<string, 可配置层数状态控制器 | undefined> = {};
  private ID列表: string[] = [];

  constructor(定义列表: Boss层数状态定义[]) {
    for (let i = 0; i < 定义列表.length; i++) {
      const 定义 = 定义列表[i];
      this.ID列表.push(定义.ID);
      this.控制器表[定义.ID] = 创建可配置层数状态(定义);
    }
  }

  取控制器(ID: string): 可配置层数状态控制器 | undefined {
    return this.控制器表[ID];
  }

  增加(ID: string, 单位: any, 层数: number = 1, 原因: string = "增加"): number {
    const 控制器 = this.控制器表[ID];
    return 控制器 == null ? 0 : 控制器.增加(单位, 层数, 原因);
  }

  设置(ID: string, 单位: any, 层数: number, 原因: string = "设置"): number {
    const 控制器 = this.控制器表[ID];
    return 控制器 == null ? 0 : 控制器.设置(单位, 层数, 原因);
  }

  减少(ID: string, 单位: any, 层数: number = 1, 原因: string = "减少"): number {
    const 控制器 = this.控制器表[ID];
    return 控制器 == null ? 0 : 控制器.减少(单位, 层数, 原因);
  }

  清空(ID: string, 单位: any, 原因: string = "清空"): void {
    const 控制器 = this.控制器表[ID];
    if (控制器 != null) 控制器.清空(单位, 原因);
  }

  清空单位全部(单位: any, 原因: string = "清空全部"): void {
    for (let i = 0; i < this.ID列表.length; i++) {
      this.清空(this.ID列表[i], 单位, 原因);
    }
  }

  取层数(ID: string, 单位: any): number {
    const 控制器 = this.控制器表[ID];
    return 控制器 == null ? 0 : 控制器.取层数(单位);
  }

  取最高层数(单位: any): Boss层数最高结果 {
    let 最高ID = "";
    let 最高层数 = 0;
    for (let i = 0; i < this.ID列表.length; i++) {
      const ID = this.ID列表[i];
      const 层数 = this.取层数(ID, 单位);
      if (层数 > 最高层数) {
        最高ID = ID;
        最高层数 = 层数;
      }
    }
    return { ID: 最高ID, 层数: 最高层数 };
  }

  销毁(): void {
    for (let i = 0; i < this.ID列表.length; i++) {
      const ID = this.ID列表[i];
      const 控制器 = this.控制器表[ID];
      if (控制器 != null) 控制器.销毁();
      this.控制器表[ID] = undefined;
    }
    this.ID列表 = [];
  }
}

export function 创建Boss层数状态集(this: void, 定义列表: Boss层数状态定义[]): Boss层数状态集 {
  return new Boss层数状态集实现(定义列表);
}
