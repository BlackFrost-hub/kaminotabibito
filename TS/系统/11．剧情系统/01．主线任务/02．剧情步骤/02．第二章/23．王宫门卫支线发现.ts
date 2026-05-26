import type { 剧情片段配置, 紧凑剧情片段配置 } from "../00．剧情步骤类型";
import { 编译紧凑剧情片段 } from "../../00．剧情系统核心工具/05．紧凑剧情片段编译";

export const 王宫门卫支线发现紧凑剧情片段: 紧凑剧情片段配置 = {
  片段ID: "elven_city_side_quest_discover",
  名称: "王宫门卫支线发现",
  触发条件: "剧情进度 == 23 且玩家靠近王宫门卫2",
  可Esc整段跳过: true,
  默认倍速: 1,
  默认对白持续时间: 3,
  对白列表: [],
  动作时间线: [
    {
      序号: 1, 挂点: "absoluteTime", 时间秒: 0,
      动作ID: "JLC精灵城_王宫门卫2支线发现", 名称: "王宫门卫2支线发现",
      参数: {
        触发进度: 23,
        目标进度: 24,
        NPC: "主线NPC.jl禁军门卫2",
        触发范围: 600,
        触发单位发布命令: "stop",
        支线任务: "udg_RW[8]",
        旧JASS功能清单: "QuestSetDiscovered / QuestMessageBJ(DISCOVERED)",
      },
    },
  ],
};



export const 王宫门卫支线发现剧情片段: 剧情片段配置 = 编译紧凑剧情片段(王宫门卫支线发现紧凑剧情片段);
