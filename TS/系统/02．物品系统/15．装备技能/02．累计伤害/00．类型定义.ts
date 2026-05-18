/** @noSelfInFile */

export interface 累计伤害上下文 {
  target: any;
  attacker: any;
  applied: number;
  snapshot: any;
}

export interface 累计伤害处理函数 {
  (this: void, 上下文: 累计伤害上下文): void;
}

export interface 装备累计配置 {
  物品名: string;
}

export interface 回沙之书配置 {
  物品名: string;
  累计阈值: number;
  法力恢复倍率: number;
  特效路径: string;
  特效持续时间: number;
  冷却时间: number;
}

export interface 女妖头饰配置 {
  物品名: string;
  累计阈值: number;
  追踪速度: number;
  追踪模型: string;
  追踪单位类型?: string;
  命中半径: number;
  生命周期: number;
  每秒毒伤: number;
  毒伤持续时间: number;
  减速攻速: number;
  减速移速: number;
  毒影BuffID: string;
}

export interface 女妖头饰强化配置 {
  物品名: string;
  命中次数阈值: number;
  触发单位类型?: string;
}

export {};
