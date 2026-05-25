import type { 剧情片段配置, 紧凑剧情片段配置 } from "./00．剧情步骤类型";

export const 紧凑剧情片段模板: 紧凑剧情片段配置 = {
  片段ID: "template_compact_story_fragment",
  名称: "紧凑剧情片段模板",
  触发条件: "这里写剧情进度、进入范围、持有物品等条件说明",
  可Esc整段跳过: true,
  默认倍速: 1,
  默认对白持续时间: 3,
  对白列表: [
    {
      序号: 1,
      说话者: "系统",
      文本: "|cffffff00『系统提示』：|r这里填写剧情提示文本。",
      持续时间: 3,
    },
    {
      序号: 2,
      说话者: "|cffffcc99『重要角色』|r",
      文本: "这里填写正式剧情对白。",
      持续时间: 4.5,
    },
  ],
  动作时间线: [
    {
      序号: 1,
      挂点: "beforeDialog",
      对白序号: 1,
      动作ID: "story_prepare",
      名称: "第 1 句对白前执行",
      参数: {
        说明: "适合停单位、转向、开电影模式、准备镜头",
      },
    },
    {
      序号: 2,
      挂点: "afterDialog",
      对白序号: 2,
      动作ID: "story_reward",
      名称: "第 2 句对白后执行",
      参数: {
        说明: "适合发奖励、推进任务、启动 Boss",
      },
    },
    {
      序号: 3,
      挂点: "absoluteTime",
      时间秒: 6,
      动作ID: "story_timed_effect",
      名称: "剧情开始后第 6 秒执行",
    },
  ],
};

export const 标准剧情片段模板: 剧情片段配置 = {
  片段ID: "template_story_fragment",
  名称: "标准剧情片段模板",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: [
    {
      type: "broadcast",
      id: "intro_broadcast",
      名称: "开场提示",
      说话者: "系统",
      文本: "|cffffff00『系统提示』：|r这里填写剧情提示文本。",
      持续时间: 3,
    },
    {
      type: "wait",
      id: "intro_wait",
      名称: "演出停顿",
      持续时间: 1.5,
      允许Esc跳过: true,
      使用原生电影系统: true,
    },
    {
      type: "broadcast",
      id: "speaker_line_1",
      名称: "角色对白",
      说话者: "|cffffcc99『重要角色』|r",
      文本: "这里填写一条正式剧情对白或电影文本。",
      持续时间: 3,
    },
    {
      type: "music",
      id: "music_switch",
      名称: "切换场景音乐",
      动作: "挂载",
      场景定义: "示例场景",
      默认环境音乐变量名: "gg_snd_BGM001",
    },
    {
      type: "unitControl",
      id: "npc_face_player",
      名称: "NPC 转向玩家",
      目标: "npc_ref",
      动作: "朝向",
      朝向: 180,
    },
    {
      type: "effect",
      id: "story_effect",
      名称: "剧情特效",
      模型路径: "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl",
      X: 0,
      Y: 0,
    },
    {
      type: "runAction",
      id: "custom_action",
      名称: "自定义剧情动作",
      动作ID: "custom_story_action",
      参数: {
        说明: "这里挂关门、开门、发奖励、切任务、改状态等特殊动作",
      },
    },
    {
      type: "startBossFight",
      id: "boss_start",
      名称: "启动 Boss 战",
      Boss名: "示例Boss",
    },
  ],
};

export default 标准剧情片段模板;
