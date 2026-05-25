local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local _____56DE_6751_89E6_53D1_6559_6D3E_88AD_51FB_6B65_9AA4 = {
    {
        type = "runAction",
        id = "return_village_after_snake_guard",
        ["名称"] = "护卫试炼后返回精灵村",
        ["动作ID"] = "JLC精灵村_护卫试炼后回村",
        ["参数"] = {
            ["触发进度"] = 16,
            ["目标进度"] = 17,
            ["移除临时单位"] = "ZXCS.DW, ZXCS2.DW",
            ["停止音乐"] = "gg_snd_JQBGM03 @ gg_rct________________QY",
            ["开始音乐"] = "gg_snd_JQBGM04 @ gg_rct________________QY",
            ["族长位置X"] = -26114.4,
            ["族长位置Y"] = -28671.3,
            ["旧JASS功能清单"] = "RemoveUnit / YDUserDataClearTable / SetUnitPosition / CinematicModeBJ / QuestMessageBJ"
        }
    },
    {
        type = "broadcast",
        id = "return_village_warning",
        ["名称"] = "回村剧情提示",
        ["说话者"] = "系统",
        ["文本"] = "|cffffcc00『剧情提示』：|r精灵村内的气息骤然变冷，似乎有什么人抢先抵达了这里。",
        ["持续时间"] = 3
    },
    {
        type = "runAction",
        id = "cult_scene_spawn_units",
        ["名称"] = "教派袭击演出单位预置",
        ["动作ID"] = "JLC精灵村_教派袭击预置",
        ["参数"] = {["神秘人单位ID"] = "n05H", ["精灵护卫单位ID"] = "nhef, n01H", ["临时树木数量"] = 21, ["旧JASS功能清单"] = "CreateUnit / DzDoodadCreate / ForForce镜头与视野"}
    },
    {
        type = "dialog",
        id = "cult_return_player_01",
        ["名称"] = "玩家发现异常",
        ["说话者"] = "玩家",
        ["文本"] = "村子里不对劲。长老身边多了陌生人，守卫的位置也全乱了。",
        ["持续时间"] = 4
    },
    {
        type = "dialog",
        id = "cult_mysterious_01",
        ["名称"] = "神秘人开场",
        ["说话者"] = "蒙面人",
        ["文本"] = "你们回来的速度比预想更快。看来沙漠与蛇人族都没能拖住你们。",
        ["持续时间"] = 4
    },
    {
        type = "dialog",
        id = "cult_elder_01",
        ["名称"] = "长老质问",
        ["说话者"] = "精灵村长老",
        ["文本"] = "你究竟是什么人？为何要挑动地精、沙漠魔物与蛇人族之间的纷争？",
        ["持续时间"] = 5
    },
    {
        type = "dialog",
        id = "cult_mysterious_02",
        ["名称"] = "神秘人承认教派立场",
        ["说话者"] = "蒙面人",
        ["文本"] = "纷争？不，那只是筛选。软弱的村落、迟钝的王族、犹豫的守护者，都该被新的秩序淘汰。",
        ["持续时间"] = 6
    },
    {
        type = "dialog",
        id = "cult_player_02",
        ["名称"] = "玩家准备迎战",
        ["说话者"] = "玩家",
        ["文本"] = "说到底，你就是这一连串事件背后的教派爪牙。既然现身，就别想再走。",
        ["持续时间"] = 4
    }
}
local _____6559_6D3E_6700_7EC8Boss_6B65_9AA4 = {
    {
        type = "runAction",
        id = "cult_boss_random_stance",
        ["名称"] = "第一章最终Boss随机姿态",
        ["动作ID"] = "JLC精灵村_教派Boss随机姿态",
        ["参数"] = {
            ["剑士姿态单位ID"] = "N05N",
            ["学者姿态单位ID"] = "N05M",
            ["出生X"] = 26474.5,
            ["出生Y"] = 20889.5,
            ["朝向"] = 270,
            ["姿态标记"] = "剑士姿态 / 学者姿态",
            ["战斗桥接"] = "Boss战.绑定单位 -> gg_trg_Boss____________u",
            ["旧JASS功能清单"] = "GetRandomInt(1,2) / CreateUnit / PauseUnit / SetUnitInvulnerable / ConditionalTriggerExecute"
        }
    },
    {
        type = "dialog",
        id = "cult_boss_intro_01",
        ["名称"] = "Boss宣战",
        ["说话者"] = "蒙面人",
        ["文本"] = "很好。就让我看看，能连破两场试炼的人，究竟有没有资格挡在教派面前。",
        ["持续时间"] = 4
    },
    {
        type = "dialog",
        id = "cult_player_before_boss",
        ["名称"] = "玩家宣战",
        ["说话者"] = "玩家",
        ["文本"] = "第一章的闹剧，到这里该结束了。",
        ["持续时间"] = 3
    },
    {type = "startBossFight", id = "cult_final_boss_start", ["名称"] = "启动第一章最终Boss战", ["Boss引用"] = "Boss.蒙面人"},
    {
        type = "runAction",
        id = "cult_final_boss_death",
        ["名称"] = "第一章最终Boss死亡剧情",
        ["动作ID"] = "SW01死亡事件_蒙面人死亡",
        ["参数"] = {
            ["触发进度"] = 17,
            ["目标进度"] = 18,
            ["死亡单位ID"] = "N05N 或 N05M",
            ["停止剧情音乐"] = "gg_snd_JQBGM03 @ 精灵村相关区域",
            ["恢复环境音乐"] = "BGM006/BGM007/BGM008/bgm003/BGM016或BGM017",
            ["奖励物品"] = "I0DA",
            ["族长新位置X"] = 28775.2,
            ["族长新位置Y"] = -28660.2,
            ["旧JASS功能清单"] = "CinematicModeBJ / Kill机械敌人 / CreateUnit神秘人残影 / EC_CreateEffect / QuestSetDescription / QuestMessageBJ"
        }
    },
    {
        type = "dialog",
        id = "cult_death_mysterious_01",
        ["名称"] = "蒙面人败退",
        ["说话者"] = "蒙面人",
        ["文本"] = "咳……很好，至少你们证明了自己不是可以随手碾碎的虫豸。",
        ["持续时间"] = 5
    },
    {
        type = "dialog",
        id = "cult_death_player_01",
        ["名称"] = "玩家追问",
        ["说话者"] = "玩家",
        ["文本"] = "告诉我，你们的教派究竟在找什么？『魔力源石』又和你们有什么关系？",
        ["持续时间"] = 4
    },
    {
        type = "dialog",
        id = "cult_death_mysterious_02",
        ["名称"] = "蒙面人留下警告",
        ["说话者"] = "蒙面人",
        ["文本"] = "你们只看见了第一枚棋子。真正的局，早在王城之外就已经开始了。",
        ["持续时间"] = 5
    },
    {
        type = "dialog",
        id = "cult_death_elder_01",
        ["名称"] = "长老收束第一章",
        ["说话者"] = "精灵村长老",
        ["文本"] = "诸位，此事已经超出精灵村所能承受的范围。请带着这些线索前往王城，向克林姆德王说明一切。",
        ["持续时间"] = 6
    },
    {
        type = "runAction",
        id = "cult_final_quest_update",
        ["名称"] = "第一章完成并指向精灵城",
        ["动作ID"] = "JLC精灵村_第一章完成任务刷新",
        ["参数"] = {["任务描述"] = "前往『克林姆德王城』，汇报教派与魔力源石相关情报。", ["任务更新提示"] = "|cffffff00『主线目标』：|r前往|cffff99cc『克林姆德王城』|r。", ["小地图X"] = 28775.2, ["小地图Y"] = -28660.2}
    }
}
local ____array_0 = __TS__SparseArrayNew(table.unpack(_____56DE_6751_89E6_53D1_6559_6D3E_88AD_51FB_6B65_9AA4))
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____6559_6D3E_6700_7EC8Boss_6B65_9AA4)
)
____exports["回村击败第一章最终Boss教派剧情片段"] = {
    ["片段ID"] = "jlc_return_village_defeat_chapter_one_cult_boss",
    ["名称"] = "回村击败第一章最终Boss教派",
    ["可Esc整段跳过"] = true,
    ["默认倍速"] = 1,
    ["步骤列表"] = {__TS__SparseArraySpread(____array_0)}
}
____exports.default = ____exports["回村击败第一章最终Boss教派剧情片段"]
return ____exports
