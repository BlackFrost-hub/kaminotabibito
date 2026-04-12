/**
 * 漂浮文字 - 类型定义
 */

// 存储最后创建的漂浮文字（替代 bj_lastCreatedTextTag）
export let lastCreatedTextTag: any = null;

/**
 * 漂浮文字配置选项
 */
export interface FloatTextOptions {
  /** 显示的文字 */
  text: string;

  /** 字体大小 */
  size?: number;

  /** 红色分量 (0-255) */
  red?: number;

  /** 绿色分量 (0-255) */
  green?: number;

  /** 蓝色分量 (0-255) */
  blue?: number;

  /** 透明度 (0-255, 0=不透明, 255=全透明) */
  alpha?: number;

  /** 存在时间（秒），0=永久 */
  duration?: number;

  /** X轴移动速度 */
  speedX?: number;

  /** Y轴移动速度 */
  speedY?: number;

  /** 高度偏移（默认0） */
  height?: number;

  /** 是否允许永久显示（duration=0时有效） */
  permanent?: boolean;
}
