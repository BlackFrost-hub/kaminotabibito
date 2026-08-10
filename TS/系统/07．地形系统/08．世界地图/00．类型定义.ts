/** @noSelfInFile */

export interface 世界地图地点配置 {
  地点ID: number;
  按钮X: number;
  按钮Y: number;
  箭头X?: number;
  箭头Y?: number;
  初始提示: string;
  初始图标?: string;
  当前位置矩形区域名称列表?: string[];
}

export type 世界地图解锁来源 = "主线剧情" | "区域探索" | "支线剧情" | "隐藏条件";

export interface 世界地图解锁配置 {
  地点ID: number;
  解锁来源?: 世界地图解锁来源;
  矩形区域名称?: string;
  目标剧情进度?: number;
  解锁提示: string;
  解锁图标: string;
  解锁后注册传送?: boolean;
  /** 区域首次探索解锁地点时，为玩家组开放的矩形视野。 */
  进入后开启视野?: string;
}

export interface 世界地图旅行奖励配置 {
  矩形区域名称: string;
  旅行编号: number;
}

export interface 世界地图传送配置 {
  配置ID: string;
  地点ID?: number;
  目标X: number;
  目标Y: number;
  镜头X: number;
  镜头Y: number;
  镜头先于单位: boolean;
  禁止剧情进度?: number;
  所需BuffID: string;
}

export interface 世界地图地点帧组 {
  按钮: number;
  文本框: number;
  提示文本: number;
  图标: number;
  当前位置箭头: number;
}

export interface 世界地图帧组 {
  入口图标: number;
  入口提示: number;
  放大图标: number;
  地图根帧: number;
  地点帧组表: 世界地图地点帧组[];
}
