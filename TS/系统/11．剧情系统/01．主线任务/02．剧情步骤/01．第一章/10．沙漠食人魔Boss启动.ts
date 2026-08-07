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
    { 序号: 1, 说话者: "玩家", 文本: "……应该就是它了。|cffff0000『沙漠食人魔』|r。", 持续时间: 2.8 },
    { 序号: 2, 说话者: "？？？", 文本: "……", 持续时间: 1.4 },
    { 序号: 3, 说话者: "沙漠食人魔", 文本: "活着的东西……都该杀……", 持续时间: 3.2 },
  ],
  动作时间线: [
    {
      序号: 1, 挂点: "beforeDialog", 对白序号: 1,
      动作ID: "SRZ蛇人族_沙漠食人魔Boss前置", 名称: "沙漠食人魔Boss战前置",
      参数: {
        触发进度: 10,
        Boss键: "Boss.沙漠食人魔",
        触发范围: 1000,
        解锁视野: "gg_rct______________047",
        旧JASS功能清单: "GroupAddUnit / SetUnitOwner / PauseUnit(true) / SetUnitInvulnerable(true) / 镜头与朝向预置",
      },
    },
    {
      序号: 2, 挂点: "beforeDialog", 对白序号: 1,
      动作ID: "主线.写入进度", 名称: "进入沙漠食人魔Boss节点",
      参数: { 节点进度: 11 },
    },
    {
      序号: 3, 挂点: "afterDialog", 对白序号: 3,
      动作ID: "主线.发布节点目标", 名称: "发布击败沙漠食人魔目标",
      参数: { 节点进度: 11 },
    },
    {
      序号: 4, 挂点: "afterDialog", 对白序号: 3,
      动作ID: "SRZ蛇人族_沙漠食人魔Boss开战", 名称: "沙漠食人魔Boss战正式开战",
      参数: {
        Boss键: "Boss.沙漠食人魔",
        播放音效: "gg_snd_GWSY05",
        战斗桥接: "Boss战.绑定单位 -> TS 统一 Boss 战运行器",
        旧JASS功能清单: "EC_CreateEffect / PlaySoundBJ / PauseUnit(false) / SetUnitInvulnerable(false) / ConditionalTriggerExecute",
      },
    },
  ],
};



export const 沙漠食人魔Boss启动剧情片段: 剧情片段配置 = 编译紧凑剧情片段(沙漠食人魔Boss启动紧凑剧情片段);
