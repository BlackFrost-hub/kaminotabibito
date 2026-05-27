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

export type 主线剧情物品事件触发方式 = "拾取" | "使用";

export interface 主线剧情物品事件配置 {
  配置名: string;
  触发方式: 主线剧情物品事件触发方式;
  需要剧情进度: number;
  目标剧情进度: number;
  物品名?: string;
  物品ID?: string;
  按持有物品校验?: boolean;
  移除触发物品?: boolean;
  剧情片段ID?: string;
  对白文本?: string;
  任务描述?: string;
  任务提示?: string;
  旧JASS来源?: string;
  说明?: string;
}

export interface 主线剧情技能通道事件配置 {
  配置名: string;
  技能ID: string;
  需要剧情进度?: number;
  最低剧情进度?: number;
  最高剧情进度?: number;
  检测X: number;
  检测Y: number;
  检测半径: number;
  剧情片段ID: string;
  旧JASS来源?: string;
  说明?: string;
}

export interface 主线剧情最终伤害对白配置 {
  说话者: string;
  文本: string;
  持续时间: number;
  使用攻击者名?: boolean;
}

export interface 主线剧情区域音乐切换配置 {
  添加: boolean;
  声音变量名: string;
  矩形变量名: string;
}

export interface 主线剧情支线任务发现配置 {
  任务数组索引: number;
  任务名: string;
  任务描述?: string;
  图标路径: string;
  发现提示: string;
}

export interface 主线剧情延迟显隐配置 {
  延迟秒数: number;
  语义单位名: string;
  X: number;
  Y: number;
  朝向: number;
}

export interface 主线剧情最终伤害事件配置 {
  配置名: string;
  需要剧情进度: number;
  目标剧情进度: number;
  单位ID: string;
  血线阈值比例: number;
  保底生命比例: number;
  切换所属玩家ID?: number;
  目标单位无敌?: boolean;
  暂停目标单位?: boolean;
  区域音乐切换?: 主线剧情区域音乐切换配置[];
  对白列表: 主线剧情最终伤害对白配置[];
  清理Boss语义键?: string;
  清理目标YD表?: boolean;
  移除目标单位?: boolean;
  任务描述?: string;
  任务提示: string;
  小地图X: number;
  小地图Y: number;
  小地图持续时间: number;
  支线任务发现?: 主线剧情支线任务发现配置;
  延迟显示?: 主线剧情延迟显隐配置;
  旧JASS来源?: string;
  说明?: string;
}
