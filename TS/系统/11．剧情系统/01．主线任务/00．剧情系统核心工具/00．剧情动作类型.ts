export interface 剧情动作执行上下文 {
  片段ID?: string;
  触发配置名?: string;
  触发单位?: any;
  参数?: Record<string, string | number | boolean>;
}

export interface 剧情任务消息参数 {
  消息类型: number;
  文本: string;
}

export interface 剧情小地图参数 {
  X: number;
  Y: number;
  持续时间: number;
}

export interface 剧情大门参数 {
  可破坏物全局名: string;
  开关: "打开" | "关闭";
}

export interface 剧情广播参数 {
  文本: string;
  持续时间?: number;
  来源单位?: any;
}

export type 剧情动作参数表 = Record<string, string | number | boolean>;

export type 剧情动作处理器 = (this: void, 参数: 剧情动作参数表) => void;
