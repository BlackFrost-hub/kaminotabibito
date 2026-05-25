/** @noSelfInFile */

import 主线剧情片段配置表 from "./01．剧情片段配置表";
import type { 剧情片段配置 } from "./00．剧情步骤类型";

export interface 剧情播放器运行时 {
  当前片段ID?: string;
  当前步骤索引: number;
  当前倍速: number;
  是否正在播放: boolean;
  是否请求跳过: boolean;
}

const 默认剧情播放器运行时: 剧情播放器运行时 = {
  当前步骤索引: 0,
  当前倍速: 1,
  是否正在播放: false,
  是否请求跳过: false,
};

export function 创建剧情播放器运行时(this: void): 剧情播放器运行时 {
  return { ...默认剧情播放器运行时 };
}

export function 查找主线剧情片段(this: void, 片段ID: string): 剧情片段配置 | undefined {
  for (let i = 0; i < 主线剧情片段配置表.length; i++) {
    const 片段 = 主线剧情片段配置表[i];
    if (片段.片段ID === 片段ID) return 片段;
  }
  return undefined;
}

export function 初始化剧情步骤播放器(this: void): void {
  void 主线剧情片段配置表;
  // 这里只落结构骨架，不开始接具体播放逻辑。
  // 后续补：
  // - ESC 整段跳过
  // - 聊天命令倍速
  // - 原生电影系统可选阻塞壳
  // - 各步骤执行器
}
