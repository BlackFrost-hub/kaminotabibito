/**
 * 吟唱条系统 - 类型定义
 */

export interface 吟唱条输入参数 {
  通道?: string;
  类型?: string;

  总时长?: number;
  sj?: number;
  time?: number;

  颜色ID?: number;
  颜色?: number;

  标题文本?: string;
  标题?: string;

  提示文本?: string;
  文本?: string;
  string?: string;
}

export interface 规范化吟唱条参数 {
  通道: string;
  总时长: number;
  颜色ID: number;
  标题文本: string;
  提示文本: string;
}

export interface 吟唱条状态 {
  通道: string;
  活跃: boolean;
  总时长: number;
  已过时间: number;
  进度: number;
  颜色ID: number;
  标题文本: string;
  提示文本: string;
}
