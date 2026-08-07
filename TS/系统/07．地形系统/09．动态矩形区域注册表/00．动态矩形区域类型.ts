export interface 动态矩形区域配置 {
  键: string;
  左: number;
  右: number;
  下: number;
  上: number;
  说明?: string;
}

export interface 动态矩形区域组配置 {
  键: string;
  子区域: Record<string, 动态矩形区域配置>;
  背景音乐子区域?: string[];
  说明?: string;
}
