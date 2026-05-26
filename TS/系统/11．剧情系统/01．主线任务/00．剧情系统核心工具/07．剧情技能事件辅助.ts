import { 写入当前剧情动作上下文, 写入剧情进度 } from "./01．剧情动作上下文";
import { 播放主线剧情片段 } from "../02．剧情步骤/02．剧情步骤播放器";

export interface 技能推进主线剧情参数 {
  片段ID?: string;
  触发配置名: string;
  触发单位: any;
  目标进度?: number;
}

export function 处理技能推进主线剧情(this: void, 参数: 技能推进主线剧情参数): boolean {
  const 片段ID = 参数.片段ID ?? "";
  if (typeof 参数.目标进度 === "number" && 参数.目标进度 > 0) {
    写入剧情进度(参数.目标进度);
  }

  写入当前剧情动作上下文({
    片段ID,
    触发配置名: 参数.触发配置名,
    触发单位: 参数.触发单位,
  });

  if (片段ID === "") return true;
  return 播放主线剧情片段(片段ID, {
    片段ID,
    触发配置名: 参数.触发配置名,
    触发单位: 参数.触发单位,
  });
}
