local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local _____963F_5C14_6587_63A5_5F15_6B65_9AA4 = {
    {
        type = "runAction",
        id = "elven_city_alvin_start",
        ["名称"] = "阿尔文接引触发",
        ["动作ID"] = "JLC精灵城_阿尔文接引",
        ["参数"] = {
            ["触发进度"] = 20,
            ["目标进度"] = 21,
            NPC = "主线NPC.阿尔文",
            ["触发范围"] = 400,
            ["旧JASS功能清单"] = "IssueImmediateOrder / EC_CreateEffect / QuestSetDescription / QuestMessageBJ / PingMinimap"
        }
    },
    {
        type = "dialog",
        id = "city_alvin_player_01",
        ["名称"] = "玩家抵达王城外",
        ["说话者"] = "玩家",
        ["文本"] = "这里就是|cffff99cc『克林姆德王城』|r。城内戒备森严，看来教派的事已经传到王族耳中了。",
        ["持续时间"] = 4.5
    },
    {
        type = "dialog",
        id = "city_alvin_01",
        ["名称"] = "阿尔文确认身份",
        ["说话者"] = "阿尔文",
        ["文本"] = "诸位便是帝国使者吧？王上已经命我在此等候。请随我入城，沿途不要离开卫队视线。",
        ["持续时间"] = 4.5
    },
    {
        type = "dialog",
        id = "city_alvin_02",
        ["名称"] = "阿尔文说明局势",
        ["说话者"] = "阿尔文",
        ["文本"] = "近日城中不太平。边境信使接连失踪，巨魔一族也突然切断了与王城的通行。",
        ["持续时间"] = 5
    },
    {
        type = "runAction",
        id = "city_alvin_quest",
        ["名称"] = "阿尔文路线指引",
        ["动作ID"] = "JLC精灵城_阿尔文路线指引",
        ["参数"] = {["任务描述"] = "跟随阿尔文进入克林姆德王城。", ["任务更新提示"] = "|cffffff00『主线目标』：|r跟随|cffff99cc『阿尔文』|r进入王城。", ["小地图X"] = -6997.4, ["小地图Y"] = -13110.9}
    }
}
local _____738B_57CE_95E8_7981_6B65_9AA4 = {{
    type = "runAction",
    id = "elven_city_gate_open",
    ["名称"] = "王城门禁开启",
    ["动作ID"] = "JLC精灵城_王城门禁开启",
    ["参数"] = {
        ["触发进度"] = 21,
        ["目标进度"] = 22,
        ["门卫单位"] = "gg_unit_n04R_0048",
        ["触发范围"] = 999,
        ["延迟开门秒"] = 2.5,
        ["开启门"] = "gg_dest_LTe1_11879",
        ["隐藏阻挡"] = "gg_dest_B00K_5466",
        ["解锁视野"] = "gg_rct__________u",
        ["旧JASS功能清单"] = "TimerStart / ModifyGateBJ / ShowDestructable(false) / CreateFogModifierRectBJ"
    }
}, {
    type = "dialog",
    id = "city_gate_player_01",
    ["名称"] = "玩家到达城门",
    ["说话者"] = "玩家",
    ["文本"] = "城门前的禁制还在运转。阿尔文，我们要等多久？",
    ["持续时间"] = 3
}, {
    type = "dialog",
    id = "city_gate_guard_01",
    ["名称"] = "门卫开启通路",
    ["说话者"] = "精灵禁军",
    ["文本"] = "身份确认无误。王城外门将在数息后开启，诸位请勿擅闯禁制范围。",
    ["持续时间"] = 5
}, {
    type = "runAction",
    id = "city_gate_quest",
    ["名称"] = "前往王宫外庭",
    ["动作ID"] = "JLC精灵城_前往王宫外庭",
    ["参数"] = {["任务描述"] = "进入王城外庭，继续前往王宫。", ["任务更新提示"] = "|cffffff00『主线目标』：|r进入王城外庭。", ["小地图X"] = -10900.6, ["小地图Y"] = -10601.8}
}}
local _____738B_5BAB_7981_519B_4E0E_56FD_738B_59D4_6258_6B65_9AA4 = {
    {
        type = "runAction",
        id = "elven_city_palace_guard",
        ["名称"] = "王宫禁军盘查",
        ["动作ID"] = "JLC精灵城_王宫禁军盘查",
        ["参数"] = {
            ["触发进度"] = 22,
            ["目标进度"] = 23,
            NPC = "主线NPC.jl禁军门卫",
            ["触发范围"] = 999,
            ["解锁视野"] = "gg_rct______________121, gg_rct______________122, gg_rct______________123",
            ["旧JASS功能清单"] = "CreateFogModifierRectBJ / QuestSetDescription / QuestMessageBJ / PingMinimap"
        }
    },
    {
        type = "dialog",
        id = "city_palace_guard_01",
        ["名称"] = "禁军再次盘查",
        ["说话者"] = "精灵禁军",
        ["文本"] = "王宫区域戒严。即便是帝国使者，也必须说明来意。",
        ["持续时间"] = 4.5
    },
    {
        type = "dialog",
        id = "city_palace_player_01",
        ["名称"] = "玩家说明来意",
        ["说话者"] = "玩家",
        ["文本"] = "我们带来了与|cffff00ff『分离教派』|r有关的情报，需要立刻面见|cffff99cc『克林姆德王』|r。",
        ["持续时间"] = 4
    },
    {
        type = "dialog",
        id = "city_palace_guard_02",
        ["名称"] = "禁军放行",
        ["说话者"] = "精灵禁军",
        ["文本"] = "王上确有命令。诸位请入内，但不要接近封锁区。",
        ["持续时间"] = 4
    },
    {
        type = "runAction",
        id = "city_side_quest_discover",
        ["名称"] = "王宫门卫2支线发现",
        ["动作ID"] = "JLC精灵城_王宫门卫2支线发现",
        ["参数"] = {
            ["触发进度"] = 23,
            ["目标进度"] = 24,
            NPC = "主线NPC.jl禁军门卫2",
            ["触发范围"] = 600,
            ["支线任务"] = "udg_RW[8]",
            ["旧JASS功能清单"] = "QuestSetDiscovered / QuestMessageBJ(DISCOVERED)"
        }
    },
    {
        type = "runAction",
        id = "elven_city_king_audience",
        ["名称"] = "克林姆德王接见",
        ["动作ID"] = "JLC精灵城_克林姆德王接见",
        ["参数"] = {
            ["触发进度"] = "23 或 24",
            ["目标进度"] = 25,
            NPC = "ZX.克林姆德王",
            ["触发范围"] = 999,
            ["会议音乐"] = "gg_snd_JQBGM02 @ gg_rct______________121",
            ["发放金币"] = 15000,
            ["生成猎魂单位ID"] = "ohun",
            ["猎魂位置X"] = -2823.1,
            ["猎魂位置Y"] = -14119.8,
            ["移除阻挡"] = "gg_dest_Dofw_5490",
            ["旧JASS功能清单"] = "SetUnitInvulnerable / PauseUnit / SetUnitOwner / SetStackedSoundBJ / AdjustPlayerStateBJ / CreateUnit"
        }
    },
    {
        type = "dialog",
        id = "city_king_01",
        ["名称"] = "国王开场",
        ["说话者"] = "克林姆德王",
        ["文本"] = "帝国使者，你们来得正是时候。王城表面平静，暗处却已经被教派的手伸了进来。",
        ["持续时间"] = 5
    },
    {
        type = "dialog",
        id = "city_player_report_01",
        ["名称"] = "玩家汇报第一章线索",
        ["说话者"] = "玩家",
        ["文本"] = "地精、蛇人族、沙漠魔物背后都出现了同一种痕迹。我们怀疑他们的目标与『魔力源石』有关。",
        ["持续时间"] = 5
    },
    {
        type = "dialog",
        id = "city_king_02",
        ["名称"] = "国王判断巨魔异动",
        ["说话者"] = "克林姆德王",
        ["文本"] = "巨魔族最近的反常，恐怕也不是偶然。若教派盯上的是巨魔传承圣物，王城不能坐视。",
        ["持续时间"] = 6
    },
    {
        type = "dialog",
        id = "city_king_reward",
        ["名称"] = "国王给予军费",
        ["说话者"] = "克林姆德王",
        ["文本"] = "这些军费由王城承担。请诸位前往巨魔领地查明真相，必要时，可直接镇压。",
        ["持续时间"] = 5
    },
    {
        type = "runAction",
        id = "city_king_quest",
        ["名称"] = "发布巨魔线任务",
        ["动作ID"] = "JLC精灵城_发布巨魔线任务",
        ["参数"] = {["任务描述"] = "调查巨魔一族与分离教派的联系。", ["任务更新提示"] = "|cffffff00『主线目标』：|r前往|cffffcc99『巨魔一族领地』|r调查。", ["小地图X"] = -2906.2, ["小地图Y"] = -14099.8}
    }
}
local ____array_0 = __TS__SparseArrayNew(table.unpack(_____963F_5C14_6587_63A5_5F15_6B65_9AA4))
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____738B_57CE_95E8_7981_6B65_9AA4)
)
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____738B_5BAB_7981_519B_4E0E_56FD_738B_59D4_6258_6B65_9AA4)
)
____exports["入城到王城委托剧情片段"] = {
    ["片段ID"] = "elven_city_entry_to_king_mission",
    ["名称"] = "入城到王城委托",
    ["可Esc整段跳过"] = true,
    ["默认倍速"] = 1,
    ["步骤列表"] = {__TS__SparseArraySpread(____array_0)}
}
____exports.default = ____exports["入城到王城委托剧情片段"]
return ____exports
