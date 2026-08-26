/** @noSelfInFile */

export type 世界坐标进度UI类型 = '通用' | '安魂' | '危险' | '自然' | '奥术';

export interface 世界坐标进度UI参数 {
  X: number;
  Y: number;
  Z?: number;
  屏幕X偏移?: number;
  屏幕Y偏移?: number;
  最大值: number;
  当前值?: number;
  标题?: string;
  数值后缀?: string;
  类型?: 世界坐标进度UI类型;
  平滑过渡秒?: number;
  初始显示?: boolean;
  雾中可见?: boolean;
  宽度?: number;
  高度?: number;
  底框贴图?: string;
  填充贴图?: string;
  跟随单位?: any;
  跟随X偏移?: number;
  跟随Y偏移?: number;
  跟随Z偏移?: number;
}

export interface 世界坐标进度UI {
  ID: number;
  根帧: number;
  填充帧: number;
  文本帧: number;
  最大值: number;
  目标值: number;
  显示值: number;
  动画起始值: number;
  动画已经过秒: number;
  平滑过渡秒: number;
  标题: string;
  数值后缀: string;
  类型: 世界坐标进度UI类型;
  数值颜色: string;
  内条宽度: number;
  内条高度: number;
  文本刷新Tick: number;
  已显示: boolean;
  已销毁: boolean;
  跟随单位: any | null;
  跟随X偏移: number;
  跟随Y偏移: number;
  跟随Z偏移: number;
}
