export type 世界地图敌人归类 = "杂鱼" | "精英" | "Boss" | "异界Boss" | "NPC";

export type 世界地图单位朝向 = number | `${number}` | "随机";

export interface 世界地图单位出生配置 {
  配置名?: string;
  分组名: string;
  敌人归类: 世界地图敌人归类;
  单位名: string;
  兼容单位ID?: string;
  X: number;
  Y: number;
  朝向: 世界地图单位朝向;
  玩家ID?: number;
}

export interface 世界地图Boss初始注册配置 extends 世界地图单位出生配置 {
  记录到Boss表键名?: string;
  初始隐藏?: boolean;
}

export interface 世界地图单位缓步创建选项 {
  每批创建数量?: number;
  批次间隔秒?: number;
  完成回调?: (this: void, 已创建数量: number) => void;
}

export interface 世界地图单位缓步创建状态 {
  总数: number;
  当前索引: number;
  已创建数量: number;
  运行中: boolean;
}

export const 启用世界地图单位TS初始化 = true;
export const 世界地图单位默认每批创建数量 = 20;
export const 世界地图单位默认批次间隔秒 = 0.04;
