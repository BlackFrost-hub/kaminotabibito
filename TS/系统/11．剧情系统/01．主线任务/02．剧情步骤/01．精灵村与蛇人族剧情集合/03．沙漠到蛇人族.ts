import type { 剧情片段配置, 剧情步骤 } from "../00．剧情步骤类型";

const 沙漠入口调查步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "desert_arrival_progress",
    名称: "抵达沙漠外缘",
    动作ID: "JLC沙漠_抵达沙漠外缘",
    参数: {
      触发进度: 5,
      触发区域: "gg_rct______________098",
      目标进度: 6,
      旧JASS功能清单: "IssueImmediateOrder / QuestSetDescription / QuestMessageBJ / CreateFogModifierRectBJ",
    },
  },
  {
    type: "dialog",
    id: "desert_player_arrival",
    名称: "玩家抵达沙漠",
    说话者: "玩家",
    文本: "前面就是沙漠了。这里的风向很乱，魔力源石的气息也被沙尘搅散了。",
    持续时间: 3,
  },
  {
    type: "runAction",
    id: "desert_arrival_quest",
    名称: "沙漠调查目标刷新",
    动作ID: "JLC沙漠_调查目标刷新",
    参数: {
      任务描述: "在沙漠中寻找熟悉地形的人，打听『魔力源石』的下落。",
      任务更新提示: "|cffffff00『主线目标』：|r在沙漠中寻找情报。",
    },
  },
];

const 沙漠年轻佣兵线索步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "desert_young_mercenary",
    名称: "询问沙漠年轻佣兵",
    动作ID: "JLC沙漠_年轻佣兵对话前置",
    参数: {
      触发进度: 6,
      NPC: "主线NPC.沙漠年轻佣兵",
      触发范围: 450,
      旧JASS功能清单: "SetUnitOwner(Player(6)) / IssueImmediateOrder / QuestMessageBJ",
    },
  },
  {
    type: "dialog",
    id: "desert_player_ask_mercenary",
    名称: "玩家询问佣兵",
    说话者: "玩家",
    文本: "我们在找一块带有强烈魔力反应的源石。你常年在沙漠行走，可曾听过类似的东西？",
    持续时间: 3,
  },
  {
    type: "dialog",
    id: "desert_mercenary_hint",
    名称: "佣兵提供方向",
    说话者: "沙漠年轻佣兵",
    文本: "源石？我只知道最近西边常有蛇人出没，连商队都绕着走。真要找线索，去问老一辈的人吧。",
    持续时间: 4,
  },
];

const 沙漠年长者线索步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "desert_elder_hint",
    名称: "询问沙漠年长者",
    动作ID: "JLC沙漠_年长者对话前置",
    参数: {
      触发进度: 6,
      NPC: "主线NPC.沙漠年长者",
      触发范围: 450,
      小地图X: -7139.3,
      小地图Y: -26096.7,
      旧JASS功能清单: "SetUnitOwner(Player(6)) / PingMinimap / CreateFogModifierRectBJ",
    },
  },
  {
    type: "dialog",
    id: "desert_player_ask_elder",
    名称: "玩家询问年长者",
    说话者: "玩家",
    文本: "老人家，我们想打听『魔力源石』。它可能和近期的异动有关。",
    持续时间: 3,
  },
  {
    type: "dialog",
    id: "desert_elder_snake_hint",
    名称: "年长者指向蛇人族",
    说话者: "沙漠年长者",
    文本: "若是旧沙海的宝物，多半绕不开『蛇人族』。他们的藏品管家见多识广，只是不会轻易开口。",
    持续时间: 5,
  },
];

const 沙漠情报商人线索步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "desert_intelligence_merchant",
    名称: "沙漠情报商人主线推进",
    动作ID: "JLC沙漠_情报商人对话前置",
    参数: {
      触发进度: 6,
      目标进度: 7,
      NPC: "主线NPC.沙漠情报商人",
      触发范围: 450,
      破坏物: "gg_dest_Dofw_15095",
      小地图X: 1455.7,
      小地图Y: -21980,
      旧JASS功能清单: "TransmissionFromUnitWithNameBJ / QuestSetDescription / QuestMessageBJ / RemoveDestructable",
    },
  },
  {
    type: "dialog",
    id: "desert_merchant_01",
    名称: "情报商人开价",
    说话者: "沙漠情报商人",
    文本: "想找『魔力源石』？这可不是普通情报。蛇人族的旧账、沙海里的禁忌，哪一样都不便宜。",
    持续时间: 5,
  },
  {
    type: "dialog",
    id: "desert_player_merchant_01",
    名称: "玩家追问",
    说话者: "玩家",
    文本: "我们没时间绕弯。告诉我们入口在哪里，价钱可以谈。",
    持续时间: 3,
  },
  {
    type: "dialog",
    id: "desert_merchant_02",
    名称: "商人指出蛇人领地",
    说话者: "沙漠情报商人",
    文本: "往西北走，越过风蚀岩柱，你们会看见蛇人族的边界。记住，别把他们当成普通盗匪。",
    持续时间: 6,
  },
];

const 沙漠情报商人回收夜光翡翠步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "desert_merchant_return_jade_action",
    名称: "情报商人回收夜光翡翠并交付魔力源石",
    动作ID: "JLC沙漠_情报商人回收夜光翡翠",
    参数: {
      触发进度: 15,
      目标进度: 16,
      需要物品: "|cff00ff00夜光翡翠|r",
      物品名: "|cff3366ff魔力源石|r",
      传送点单位: "能量波动标记",
      旧JASS功能清单: "RemoveItem(夜光翡翠) / UnitAddItem(魔力源石) / BlueBalllight / 清理旧精灵护卫 / 创建ZXCS.DW与ZXCS2.DW",
    },
  },
  { type: "dialog", id: "desert_return_jade_player_01", 名称: "玩家交出夜光翡翠", 说话者: "玩家", 文本: "你要的|cff00ff00『夜光翡翠』|r，我已经带来了。", 持续时间: 3 },
  { type: "dialog", id: "desert_return_jade_merchant_01", 名称: "商人验货", 说话者: "沙漠情报商人", 文本: "让我看看……黑夜中泛出彩虹般的辉光，没错，此物不假。真如传闻一般美丽。各位竟真能从|cffff9900『蛇人族』|r手中换来它。", 持续时间: 6 },
  { type: "dialog", id: "desert_return_jade_player_02", 名称: "玩家催促交易", 说话者: "玩家", 文本: "来路你不必多问。我们要的|cff3366ff『魔力源石』|r，是否也该拿出来了？", 持续时间: 4 },
  { type: "dialog", id: "desert_return_jade_merchant_02", 名称: "商人交付源石", 说话者: "沙漠情报商人", 文本: "没问题，没问题。这就是|cff3366ff『魔力源石』|r。你们尽管查验。", 持续时间: 4 },
  { type: "dialog", id: "desert_return_jade_player_03", 名称: "玩家确认源石", 说话者: "玩家", 文本: "没想到这么贵重的东西你真带在身边，就不怕在聚集地被抢走？……注入魔力后反应稳定，确实是我们要找的源石。", 持续时间: 6 },
  {
    type: "runAction",
    id: "desert_return_jade_quest_update",
    名称: "魔力源石入手后刷新回村目标",
    动作ID: "JLC沙漠_源石入手目标刷新",
    参数: {
      任务描述: "带着|cff3366ff『魔力源石』|r返回|cffff9900『精灵村』|r，向长老汇报源石与教派线索。",
      任务更新提示: "|cffffff00『主线目标』：|r返回|cffff9900『精灵村』|r。",
    },
  },
];

const 蛇人族入口步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "snake_territory_entry",
    名称: "进入蛇人族领地",
    动作ID: "SRZ蛇人族_领地入口",
    参数: {
      触发进度: 7,
      目标进度: 8,
      触发区域: "gg_rct______________106",
      扣除金币: 233,
      解锁视野: "gg_rct______________108, gg_rct______________107",
      小地图X: -20880.7,
      小地图Y: 3186.4,
      旧JASS功能清单: "RemoveRect / PauseUnit / AdjustPlayerStateBJ / QuestMessageBJ",
    },
  },
  {
    type: "dialog",
    id: "snake_gate_guard_01",
    名称: "蛇人族边界警告",
    说话者: "蛇人守卫",
    文本: "外来者止步。这里是『蛇人族』的领地，再往前一步，便视作挑衅。",
    持续时间: 3,
  },
  {
    type: "dialog",
    id: "snake_gate_player_01",
    名称: "玩家说明目的",
    说话者: "玩家",
    文本: "我们只为寻找『魔力源石』而来，并不想和蛇人族为敌。",
    持续时间: 3,
  },
  {
    type: "dialog",
    id: "snake_gate_guard_02",
    名称: "守卫放行",
    说话者: "蛇人守卫",
    文本: "既然如此，就去见藏品管家吧。你们若敢乱闯，沙漠会替我们埋葬你们。",
    持续时间: 4,
  },
];

const 蛇人族藏品管家初见步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "snake_keeper_first_meet",
    名称: "蛇人族藏品管家初见",
    动作ID: "SRZ蛇人族_藏品管家初见",
    参数: {
      触发进度: 8,
      目标进度: 9,
      NPC: "主线NPC.蛇人族藏品管家",
      触发范围: 400,
      商店新增物品: "接受任务-|cffff0000狩猎食人魔（等级24）|r",
      延迟提示: "|cffffff00『系统提示』：|r下次任务会开启|cffff0000『Boss战』|r，|cffffcc99实力不够则会团灭|r，请准备充分再来！",
      旧JASS功能清单: "AddItemToStockBJ / TimerStart(2秒提示) / QuestMessageBJ",
    },
  },
  {
    type: "dialog",
    id: "snake_keeper_01",
    名称: "管家试探",
    说话者: "蛇人族藏品管家",
    文本: "人类，精灵，佣兵……你们身上的气味很杂。说吧，想从蛇人族这里换走什么？",
    持续时间: 4,
  },
  {
    type: "dialog",
    id: "snake_keeper_task",
    名称: "管家提出交换",
    说话者: "蛇人族藏品管家",
    文本: "『魔力源石』的线索可以给你们，但先替我们处理沙漠深处那头失控的食人魔。拿回它身上的凭证，我再继续谈。",
    持续时间: 6,
  },
  {
    type: "runAction",
    id: "snake_keeper_quest",
    名称: "发布沙漠食人魔目标",
    动作ID: "SRZ蛇人族_食人魔任务刷新",
    参数: {
      任务描述: "前往沙漠深处击败『沙漠食人魔』，取得蛇人族需要的凭证。",
      任务更新提示: "|cffffff00『主线目标』：|r击败|cffff6600『沙漠食人魔』|r。",
    },
  },
];

export const 沙漠入口调查剧情片段: 剧情片段配置 = {
  片段ID: "jlc_desert_arrival",
  名称: "沙漠入口调查",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: 沙漠入口调查步骤,
};

export const 沙漠年轻佣兵线索剧情片段: 剧情片段配置 = {
  片段ID: "jlc_desert_young_mercenary",
  名称: "沙漠年轻佣兵线索",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: 沙漠年轻佣兵线索步骤,
};

export const 沙漠年长者线索剧情片段: 剧情片段配置 = {
  片段ID: "jlc_desert_elder_hint",
  名称: "沙漠年长者线索",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: 沙漠年长者线索步骤,
};

export const 沙漠情报商人线索剧情片段: 剧情片段配置 = {
  片段ID: "jlc_desert_intelligence_merchant",
  名称: "沙漠情报商人线索",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: 沙漠情报商人线索步骤,
};

export const 沙漠情报商人回收夜光翡翠剧情片段: 剧情片段配置 = {
  片段ID: "jlc_desert_merchant_return_jade",
  名称: "沙漠情报商人回收夜光翡翠",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: 沙漠情报商人回收夜光翡翠步骤,
};

export const 蛇人族入口剧情片段: 剧情片段配置 = {
  片段ID: "jlc_snake_territory_entry",
  名称: "蛇人族入口",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: 蛇人族入口步骤,
};

export const 蛇人族藏品管家初见剧情片段: 剧情片段配置 = {
  片段ID: "jlc_snake_keeper_first_meet",
  名称: "蛇人族藏品管家初见",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: 蛇人族藏品管家初见步骤,
};

export const 沙漠到蛇人族剧情片段: 剧情片段配置 = {
  片段ID: "jlc_desert_to_snake_territory",
  名称: "沙漠到蛇人族",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: [
    ...沙漠入口调查步骤,
    ...沙漠年轻佣兵线索步骤,
    ...沙漠年长者线索步骤,
    ...沙漠情报商人线索步骤,
    ...沙漠情报商人回收夜光翡翠步骤,
    ...蛇人族入口步骤,
    ...蛇人族藏品管家初见步骤,
  ],
};

export default 沙漠到蛇人族剧情片段;
