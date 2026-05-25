import type { 剧情片段配置, 剧情步骤 } from "../00．剧情步骤类型";

const 接受食人魔任务步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "snake_ogre_task_accept_action",
    名称: "拾取狩猎食人魔任务物品后创建沙漠食人魔预置",
    动作ID: "SRZ蛇人族_接受食人魔任务",
    参数: {
      触发进度: 9,
      目标进度: 10,
      注册范围: 850,
      任务描述: "前往沙漠深处击败『沙漠食人魔』，取得蛇人族需要的凭证。",
      任务更新提示: "|cffffff00『主线目标』：|r击败|cffff6600『沙漠食人魔』|r。",
      旧JASS功能清单: "RemoveItem(I0D0) / CreateUnit(次元裂缝) / QuestSetDescription / QuestMessageBJ / CreateUnit(沙漠食人魔) / PauseUnit / SetUnitInvulnerable / TriggerRegisterUnitInRangeSimple / CreatePermanentCorpseLocBJ",
    },
  },
  {
    type: "dialog",
    id: "snake_ogre_task_player_01",
    名称: "玩家接受狩猎委托",
    说话者: "玩家",
    文本: "任务已经接下。沙漠食人魔既然失控到让蛇人族都要借外人之手处理，恐怕不只是普通魔物。",
    持续时间: 4,
  },
  {
    type: "dialog",
    id: "snake_ogre_task_system_01",
    名称: "系统警告",
    说话者: "系统",
    文本: "|cffffff00『系统提示』：|r新的|cffff6600『Boss战』|r目标已出现，请准备充分后再接近。Boss 区域已生成尸骨标记与异常裂隙。",
    持续时间: 4,
  },
];

const 沙漠食人魔Boss启动步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "desert_ogre_boss_start",
    名称: "沙漠食人魔Boss战启动",
    动作ID: "SRZ蛇人族_沙漠食人魔Boss启动",
    参数: {
      触发进度: 10,
      目标进度: 11,
      Boss键: "Boss.沙漠食人魔",
      触发范围: 1000,
      解锁视野: "gg_rct______________047",
      战斗桥接: "Boss战.绑定单位 -> gg_trg_Boss____________u",
      旧JASS功能清单: "GroupAddUnit / SetUnitOwner / PauseUnit / SetUnitInvulnerable / EC_CreateEffect / PlaySoundBJ",
    },
  },
  {
    type: "dialog",
    id: "desert_ogre_player_01",
    名称: "玩家发现食人魔",
    说话者: "玩家",
    文本: "就是它。蛇人族说的失控食人魔，气息比普通魔物强得多。",
    持续时间: 3,
  },
  {
    type: "dialog",
    id: "desert_ogre_roar",
    名称: "食人魔咆哮",
    说话者: "沙漠食人魔",
    文本: "吼！闯进沙海的猎物，都要被砸成碎骨！",
    持续时间: 3,
  },
];

const 沙漠食人魔一阶段死亡步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "desert_ogre_first_death",
    名称: "沙漠食人魔死亡裂隙演出",
    动作ID: "SW01死亡事件_沙漠食人魔一阶段死亡",
    参数: {
      触发进度: 11,
      目标进度: 12,
      死亡单位名: "沙漠食人魔",
      裂隙单位名: "次元裂缝",
      蜥蜴人单位名: "神秘蜥蜴人",
      二阶段Boss名: "杀戮食人魔",
      Boss键: "Boss.杀戮食人魔",
      旧JASS功能清单: "UnitSuspendDecay / SetStackedSoundBJ(false, shengliBgm) / CreateUnit / PauseUnit / SetUnitInvulnerable / ConditionalTriggerExecute",
    },
  },
  {
    type: "dialog",
    id: "desert_ogre_rift_01",
    名称: "裂隙开启",
    说话者: "系统",
    文本: "食人魔倒下的瞬间，沙地深处撕开一道幽蓝裂隙，陌生的魔力从中翻涌而出。",
    持续时间: 4,
  },
  {
    type: "dialog",
    id: "desert_lizardman_01",
    名称: "蜥蜴人现身",
    说话者: "蜥蜴人",
    文本: "这具躯壳还不能倒下。祭品尚未献完，杀戮也尚未结束。",
    持续时间: 4,
  },
  {
    type: "dialog",
    id: "desert_player_rift_01",
    名称: "玩家识破异变",
    说话者: "玩家",
    文本: "原来食人魔只是容器。真正操控它的东西，藏在那道裂隙后面。",
    持续时间: 4,
  },
  {
    type: "dialog",
    id: "desert_slaughter_ogre_01",
    名称: "杀戮食人魔降临",
    说话者: "杀戮食人魔",
    文本: "血……更多的血！把你们的恐惧，全都献给我！",
    持续时间: 4,
  },
];

const 杀戮食人魔死亡步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "desert_slaughter_ogre_death",
    名称: "杀戮食人魔死亡与奖励",
    动作ID: "SW01死亡事件_杀戮食人魔死亡",
    参数: {
      触发进度: 12,
      目标进度: 13,
      Boss键: "Boss.杀戮食人魔",
      旧JASS功能清单: "QuestMessageBJ / ForGroupBJ；死亡宝箱和死亡掉落迁出到后续Boss死亡掉落系统",
    },
  },
  {
    type: "dialog",
    id: "desert_ogre_defeated",
    名称: "击败杀戮食人魔",
    说话者: "玩家",
    文本: "这次它彻底没动静了。带上凭证，回蛇人族找藏品管家。",
    持续时间: 4,
  },
];

const 蛇人族交凭证步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "snake_keeper_return_item",
    名称: "交还食人魔凭证",
    动作ID: "SRZ蛇人族_交还食人魔凭证",
    参数: {
      触发进度: 13,
      目标进度: 14,
      需要物品: "食人魔头颅",
      物品名: "|cff00ff00夜光翡翠|r",
      NPC: "主线NPC.蛇人族藏品管家",
      停止区域音乐: "gg_snd_BGM019 @ gg_rct______________107",
      开始音乐: "gg_snd_JQBGM02 @ gg_rct______________107",
      旧JASS功能清单: "RemoveItem / UnitAddItem / SetStackedSoundBJ / CreateUnit(蛇人族卫队长)",
    },
  },
  {
    type: "dialog",
    id: "snake_keeper_return_01",
    名称: "管家确认凭证",
    说话者: "蛇人族藏品管家",
    文本: "很好，这确实是那头食人魔的凭证。看来你们并不是只会夸口的外来者。",
    持续时间: 4,
  },
  {
    type: "dialog",
    id: "snake_keeper_return_02",
    名称: "交出源石线索",
    说话者: "蛇人族藏品管家",
    文本: "拿着这枚蛇纹印记。它能证明你们曾为蛇人族办事，也能带你们找到下一条线索。",
    持续时间: 4,
  },
];

const 蛇人族卫队长试炼步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "snake_guard_captain_enter",
    名称: "蛇人族卫队长入场",
    动作ID: "SRZ蛇人族_卫队长入场",
    参数: {
      卫队长单位名: "利尔·伯特",
      出生X: -22935.9,
      出生Y: 3154.3,
      目标X: -21023.4,
      目标Y: 3259.5,
      旧JASS功能清单: "CreateUnit(Player(6)) / IssuePointOrderById / SetUnitFacing / SetUnitOwner(NeutralPassive)",
    },
  },
  {
    type: "dialog",
    id: "snake_guard_captain_01",
    名称: "卫队长质问",
    说话者: "蛇人族卫队长",
    文本: "管家大人，您竟把蛇纹印记交给外族？若他们把灾祸带回神殿，谁来负责？",
    持续时间: 5,
  },
  {
    type: "dialog",
    id: "snake_keeper_guard_01",
    名称: "管家压住争执",
    说话者: "蛇人族藏品管家",
    文本: "他们已按规矩完成交换。蛇人族守信，不会因为猜疑撕毁承诺。",
    持续时间: 4,
  },
  {
    type: "dialog",
    id: "snake_guard_captain_02",
    名称: "卫队长提出试炼",
    说话者: "蛇人族卫队长",
    文本: "规矩我认。但若他们连我的护卫都过不了，就没有资格带着印记离开。",
    持续时间: 5,
  },
  {
    type: "dialog",
    id: "snake_player_guard_01",
    名称: "玩家接受护卫对战",
    说话者: "玩家",
    文本: "既然这是蛇人族的规矩，我们接下。但愿这场试炼之后，你们不再阻拦。",
    持续时间: 4,
  },
  {
    type: "runAction",
    id: "snake_guard_duel_quest",
    名称: "护卫对战目标刷新",
    动作ID: "SRZ蛇人族_护卫对战目标刷新",
    参数: {
      任务描述: "完成蛇人族卫队长提出的护卫试炼。",
      任务更新提示: "|cffffff00『主线目标』：|r通过|cffffcc99『蛇人族护卫试炼』|r。",
      旧JASS功能清单: "QuestSetDescription / QuestMessageBJ",
    },
  },
];

export const 沙漠食人魔Boss启动剧情片段: 剧情片段配置 = {
  片段ID: "jlc_desert_ogre_boss_start",
  名称: "沙漠食人魔Boss启动",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: 沙漠食人魔Boss启动步骤,
};

export const 蛇人族接受食人魔任务剧情片段: 剧情片段配置 = {
  片段ID: "jlc_snake_ogre_task_accept",
  名称: "蛇人族接受狩猎食人魔任务",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: 接受食人魔任务步骤,
};

export const 沙漠食人魔一阶段死亡剧情片段: 剧情片段配置 = {
  片段ID: "jlc_desert_ogre_first_death",
  名称: "沙漠食人魔一阶段死亡",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: 沙漠食人魔一阶段死亡步骤,
};

export const 杀戮食人魔死亡剧情片段: 剧情片段配置 = {
  片段ID: "jlc_slaughter_ogre_death",
  名称: "杀戮食人魔死亡",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: 杀戮食人魔死亡步骤,
};

export const 蛇人族交凭证剧情片段: 剧情片段配置 = {
  片段ID: "jlc_snake_keeper_return_item",
  名称: "蛇人族交还食人魔凭证",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: 蛇人族交凭证步骤,
};

export const 蛇人族卫队长试炼剧情片段: 剧情片段配置 = {
  片段ID: "jlc_snake_guard_duel",
  名称: "蛇人族卫队长试炼",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: 蛇人族卫队长试炼步骤,
};

export const 蛇人族击败食人魔到护卫对战剧情片段: 剧情片段配置 = {
  片段ID: "jlc_snake_ogre_defeated_to_guard_duel",
  名称: "蛇人族击败食人魔到护卫对战",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: [
    ...接受食人魔任务步骤,
    ...沙漠食人魔Boss启动步骤,
    ...沙漠食人魔一阶段死亡步骤,
    ...杀戮食人魔死亡步骤,
    ...蛇人族交凭证步骤,
    ...蛇人族卫队长试炼步骤,
  ],
};

export default 蛇人族击败食人魔到护卫对战剧情片段;
