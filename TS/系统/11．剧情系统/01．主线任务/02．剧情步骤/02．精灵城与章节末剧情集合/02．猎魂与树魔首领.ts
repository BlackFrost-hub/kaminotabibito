import type { 剧情片段配置, 剧情步骤 } from "../00．剧情步骤类型";

const 猎魂试探步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "elven_city_hunter_start",
    名称: "猎魂试探触发",
    动作ID: "JLC精灵城_猎魂试探",
    参数: {
      触发进度: 25,
      目标进度: 26,
      NPC: "jq.npc",
      触发范围: 400,
      旧JASS功能清单: "PauseUnit(GetTriggerUnit) / SetUnitInvulnerable(false) / PauseUnit(false) / YDUserDataClear",
    },
  },
  {
    type: "dialog",
    id: "city_hunter_01",
    名称: "猎魂拦路",
    说话者: "猎魂",
    文本: "奉王命守在此处的，可不止禁军。想去巨魔领地，先证明你们不是累赘。",
    持续时间: 4,
  },
  {
    type: "dialog",
    id: "city_hunter_player_01",
    名称: "玩家回应猎魂",
    说话者: "玩家",
    文本: "若这是王城的规矩，我们接受。但别浪费太多时间，敌人不会等我们。",
    持续时间: 4,
  },
  {
    type: "dialog",
    id: "city_hunter_02",
    名称: "猎魂放行",
    说话者: "猎魂",
    文本: "眼神不错。去吧，巨魔族的边境已经不再欢迎任何外来者。",
    持续时间: 3,
  },
  {
    type: "runAction",
    id: "city_hunter_quest",
    名称: "猎魂后任务推进",
    动作ID: "JLC精灵城_猎魂后任务推进",
    参数: {
      任务描述: "前往巨魔领地深处。",
      任务更新提示: "|cffffff00『主线目标』：|r进入巨魔领地。",
    },
  },
];

const 巨魔首领战前步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "elven_city_troll_leader_start",
    名称: "巨魔首领战前触发",
    动作ID: "JLC精灵城_巨魔首领战前",
    参数: {
      触发进度: 26,
      目标进度: 27,
      Boss: "巨魔首领.Boss",
      触发范围: 400,
      旧JASS功能清单: "PauseUnit(GetTriggerUnit) / Transmission / QuestSetDescription / QuestMessageBJ",
    },
  },
  {
    type: "dialog",
    id: "city_troll_leader_01",
    名称: "巨魔首领警告",
    说话者: "巨魔首领",
    文本: "人类和精灵都一样，只会把战火带到别人的土地上。滚出这里！",
    持续时间: 4,
  },
  {
    type: "dialog",
    id: "city_troll_player_01",
    名称: "玩家交涉",
    说话者: "玩家",
    文本: "我们要查的是|cffff00ff『分离教派』|r。若你们没有参与，就让我们通过。",
    持续时间: 4,
  },
  {
    type: "dialog",
    id: "city_troll_leader_02",
    名称: "巨魔首领开战",
    说话者: "巨魔首领",
    文本: "少废话！踏入领地者，只有死路一条！",
    持续时间: 3,
  },
  {
    type: "startBossFight",
    id: "city_troll_leader_boss",
    名称: "启动巨魔首领战",
    Boss引用: "巨魔首领.Boss",
  },
];

const 树魔首领死亡承接步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "treant_leader_death_reward",
    名称: "树魔首领死亡与奖励",
    动作ID: "SW01死亡事件_树魔首领死亡",
    参数: {
      触发进度: 27,
      目标进度: 28,
      死亡单位ID: "N05S",
      选择宝箱: "e070",
      宝箱物品: "I0C3, I0C5, I0C7",
      掉落物品: "I0CA",
      旧JASS功能清单: "QuestSetDescription / QuestMessageBJ / AddItemToStockBJ / CreateItem / YDUserDataClearTable",
    },
  },
  {
    type: "dialog",
    id: "treant_leader_death_01",
    名称: "树魔首领倒下",
    说话者: "系统",
    文本: "树魔首领庞大的身躯轰然倒下，残留的魔力在树根间凝成一封破损的魔法信件。",
    持续时间: 4,
  },
  {
    type: "dialog",
    id: "treant_leader_player_01",
    名称: "玩家取得信件",
    说话者: "玩家",
    文本: "这封信上有教派的加密术式。带回王城，让克林姆德王确认。",
    持续时间: 4,
  },
  {
    type: "runAction",
    id: "treant_leader_return_quest",
    名称: "返回王城任务刷新",
    动作ID: "JLC精灵城_树魔首领死亡后返城",
    参数: {
      任务描述: "带着魔法信件返回王城。",
      任务更新提示: "|cffffff00『主线目标』：|r返回|cffff99cc『克林姆德王城』|r。",
    },
  },
];

export const 猎魂与树魔首领剧情片段: 剧情片段配置 = {
  片段ID: "elven_city_hunter_to_treant_leader",
  名称: "猎魂与树魔首领",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: [...猎魂试探步骤, ...巨魔首领战前步骤, ...树魔首领死亡承接步骤],
};

export default 猎魂与树魔首领剧情片段;
