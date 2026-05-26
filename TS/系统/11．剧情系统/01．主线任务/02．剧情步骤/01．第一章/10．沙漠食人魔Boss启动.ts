import type { 剧情片段配置, 紧凑剧情片段配置 } from "../00．剧情步骤类型";
import { 编译紧凑剧情片段 } from "../../00．剧情系统核心工具/05．紧凑剧情片段编译";

export const 沙漠食人魔Boss启动紧凑剧情片段: 紧凑剧情片段配置 = {
  片段ID: "jlc_desert_ogre_boss_start",
  名称: "沙漠食人魔Boss启动",
  触发条件: "剧情进度 == 10 且玩家靠近沙漠食人魔",
  可Esc整段跳过: true,
  默认倍速: 1,
  默认对白持续时间: 3,
  对白列表: [
    { 序号: 1, 说话者: "玩家", 文本: "就是它。蛇人族说的失控食人魔，气息比普通魔物强得多。", 持续时间: 3 },
    { 序号: 2, 说话者: "沙漠食人魔", 文本: "吼！闯进沙海的猎物，都要被砸成碎骨！", 持续时间: 3 },
  ],
  动作时间线: [
    {
      序号: 1, 挂点: "beforeDialog", 对白序号: 1,
      动作ID: "SRZ蛇人族_沙漠食人魔Boss启动", 名称: "沙漠食人魔Boss战启动",
      参数: {
        触发进度: 10,
        目标进度: 11,
        Boss键: "Boss.沙漠食人魔",
        触发范围: 1000,
        解锁视野: "gg_rct______________047",
        播放音效: "gg_snd_GWSY05",
        战斗桥接: "Boss战.绑定单位 -> gg_trg_Boss____________u",
        旧JASS功能清单: "GroupAddUnit / SetUnitOwner / PauseUnit / SetUnitInvulnerable / EC_CreateEffect / PlaySoundBJ",
      },
    },
  ],
};



export const 沙漠食人魔Boss启动剧情片段: 剧情片段配置 = 编译紧凑剧情片段(沙漠食人魔Boss启动紧凑剧情片段);
