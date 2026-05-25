import type { 剧情片段配置, 剧情步骤 } from "../00．剧情步骤类型";

const 地精洞窟演出步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "jlc_inner_village_cutscene",
    名称: "进入村内与洞窟前置演出",
    动作ID: "JLC精灵村_村内剧情切入",
    参数: {
      触发区域: "gg_rct______________020",
      剧情进度: 1,
      视角镜头: "gg_cam___________________005",
      旧JASS功能清单: "SetTimeOfDay / PauseUnit / CinematicModeBJ / CinematicFilterGenericBJ / SetStackedSoundBJ",
    },
  },
  {
    type: "dialog",
    id: "jlc_inner_intro_01",
    名称: "地精洞窟深处",
    说话者: "系统",
    文本: "地精洞窟深处，幽暗无光，只有不祥的气息缓缓弥散。",
    持续时间: 5,
  },
  {
    type: "runAction",
    id: "jlc_elven_wizard_spawn",
    名称: "地精巫师预置",
    动作ID: "JLC精灵村_地精巫师预置",
    参数: {
      单位ID: "N00C",
      位置X: -26032.4,
      位置Y: -13789.5,
      朝向: 270,
      旧JASS功能清单: "CreateUnit / PauseUnit / SetUnitInvulnerable / TriggerRegisterUnitInRangeSimple",
    },
  },
];

const 地精巫师Boss步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "jlc_boss_scene_start",
    名称: "地精巫师Boss战前导",
    动作ID: "JLC精灵村_Boss演出启动",
    参数: {
      剧情进度: 2,
      触发范围: "755",
      旧JASS功能清单: "GroupAddUnit / SetUnitOwner / PauseUnit / SetUnitInvulnerable / YDUserDataSet Boss战 / ConditionalTriggerExecute",
    },
  },
  {
    type: "dialog",
    id: "jlc_boss_intro_01",
    名称: "地精巫师现身",
    说话者: "地精巫师",
    文本: "嘶嘶……哈哈，既然闯到了这里，你们自然也逃不过成为祭品的命运！",
    持续时间: 3,
  },
  {
    type: "dialog",
    id: "jlc_boss_intro_02",
    名称: "玩家宣战",
    说话者: "玩家",
    文本: "原来如此。地精一族突然暴涨的力量，果然全是你在背后作祟。",
    持续时间: 3,
  },
  {
    type: "runAction",
    id: "jlc_boss_dead_cleanup_timer",
    名称: "Boss死亡后临时单位清理",
    动作ID: "JLC精灵村_Boss死亡清理",
    参数: {
      定时: "1秒轮询，90秒后回收装饰物",
      旧JASS功能清单: "RemoveUnit / DestroyTimer / DzDoodadRemove / RemoveGroup / Boss死亡判断",
    },
  },
];

const 击败地精回村步骤: 剧情步骤[] = [
  {
    type: "runAction",
    id: "jlc_return_elder_reward",
    名称: "击败地精后返回长老处",
    动作ID: "JLC精灵村_击败地精后返长老",
    参数: {
      触发进度: 4,
      触发区域: "gg_rct______________098",
      旧JASS功能清单: "IssueImmediateOrder / QuestMessageBJ / ForForce reveal / UnitAddItem I03J",
    },
  },
  {
    type: "dialog",
    id: "jlc_return_elder_player_01",
    名称: "玩家复命",
    说话者: "玩家",
    文本: "族长，我等已查明其中缘由。地精一族的异变，确是受一名神秘人物暗中操控。如今其首领已被击败，想来不久之后便会前来求和。",
    持续时间: 5,
  },
  {
    type: "dialog",
    id: "jlc_return_elder_01",
    名称: "长老致谢并赠物",
    说话者: "精灵村长老",
    文本: "多谢诸位帝国使者。如此一来，我族暂时便可免去灭族之祸。此物乃我族昔年穿行沙漠时所用的宝物，便赠与诸位，也算让它物尽其用。",
    持续时间: 5,
  },
  {
    type: "dialog",
    id: "jlc_return_elder_player_02",
    名称: "玩家接下沙漠任务",
    说话者: "玩家",
    文本: "族长言重了。既然此物能助我等一程，那我们便不再推辞。事不宜迟，我们这便启程前往沙漠，寻找『魔力源石』。",
    持续时间: 4,
  },
  {
    type: "runAction",
    id: "jlc_return_elder_desert_quest",
    名称: "长老发布沙漠任务",
    动作ID: "JLC精灵村_沙漠任务刷新",
    参数: {
      任务描述: "穿过东部巨石山谷前往沙漠寻找魔力源石",
      任务更新提示: "|cffffff00『系统提示』：|r穿过东部|cffff9900『巨石山谷』|r前往沙漠寻找|cffcc99ff『魔力源石』|r（小地图信号位置）",
      小地图X: -16003.4,
      小地图Y: -24617.3,
    },
  },
];

export const 击败地精到长老说去沙漠来剧情片段: 剧情片段配置 = {
  片段ID: "jlc_elven_village_goblin_defeated_to_desert",
  名称: "击败地精到长老说去沙漠来",
  可Esc整段跳过: true,
  默认倍速: 1,
  步骤列表: [...地精洞窟演出步骤, ...地精巫师Boss步骤, ...击败地精回村步骤],
};

export default 击败地精到长老说去沙漠来剧情片段;
