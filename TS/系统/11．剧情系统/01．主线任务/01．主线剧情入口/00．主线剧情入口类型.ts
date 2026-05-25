export type 旧主线剧情触发器名 = "JLC精灵村001" | "SRZ蛇人族002" | "JLC精灵城003";

export type 主线剧情入口触发方式 = "单位范围" | "矩形进入" | "全局单位范围";

export interface 主线NPC初始化配置 {
  配置名: string;
  单位ID: string;
  X: number;
  Y: number;
  朝向: number;
  玩家ID?: number;
  YD表?: string;
  YD键?: string;
  YD字段?: string;
  YD类型?: "unit";
  说明?: string;
}

export interface 主线剧情入口配置基础 {
  配置名: string;
  触发方式: 主线剧情入口触发方式;
  剧情片段ID?: string;
  旧JASS触发器?: 旧主线剧情触发器名;
  需要剧情进度?: number;
  最低剧情进度?: number;
  最高剧情进度?: number;
  需要物品名?: string;
  说明?: string;
}

export interface 主线剧情单位范围入口配置 extends 主线剧情入口配置基础 {
  触发方式: "单位范围";
  NPC配置名: string;
  注册范围: number;
}

export interface 主线剧情矩形入口配置 extends 主线剧情入口配置基础 {
  触发方式: "矩形进入";
  矩形变量名: string;
}

export interface 主线剧情全局单位入口配置 extends 主线剧情入口配置基础 {
  触发方式: "全局单位范围";
  单位变量名: string;
  注册范围: number;
}

export type 主线剧情入口配置 =
  | 主线剧情单位范围入口配置
  | 主线剧情矩形入口配置
  | 主线剧情全局单位入口配置;

export interface 主线剧情可破坏物初始化配置 {
  配置名: string;
  变量名: string;
  无敌: boolean;
  说明?: string;
}
