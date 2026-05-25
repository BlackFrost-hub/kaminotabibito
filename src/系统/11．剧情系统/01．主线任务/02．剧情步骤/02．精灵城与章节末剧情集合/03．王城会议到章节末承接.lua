local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local _____9B54_6CD5_4FE1_4EF6_89E3_6790_6B65_9AA4 = {
    {
        type = "runAction",
        id = "city_report_magic_letter",
        ["名称"] = "向克林姆德王汇报魔法信件",
        ["动作ID"] = "JLC精灵城_魔法信件汇报",
        ["参数"] = {
            ["触发进度"] = 29,
            ["目标进度"] = 30,
            NPC = "ZX.克林姆德王",
            ["触发范围"] = 400,
            ["旧JASS功能清单"] = "QuestSetDescription / QuestMessageBJ"
        }
    },
    {
        type = "dialog",
        id = "city_letter_player_01",
        ["名称"] = "玩家呈交信件",
        ["说话者"] = "玩家",
        ["文本"] = "我们在巨魔领地发现了这封魔法信件。上面的术式不像巨魔族所有，更像是外人留下的指令。",
        ["持续时间"] = 5
    },
    {
        type = "dialog",
        id = "city_letter_king_01",
        ["名称"] = "国王判断信件",
        ["说话者"] = "克林姆德王",
        ["文本"] = "这不是普通密信。请把它交给|cff99ffcc『赫克提尔』|r，他是王城里最擅长古代术式的人。",
        ["持续时间"] = 5
    },
    {
        type = "runAction",
        id = "city_letter_to_hectel",
        ["名称"] = "前往赫克提尔处",
        ["动作ID"] = "JLC精灵城_前往赫克提尔",
        ["参数"] = {["任务描述"] = "前往术法协会，请赫克提尔解析魔法信件。", ["任务更新提示"] = "|cffffff00『主线目标』：|r前往术法协会。"}
    },
    {
        type = "runAction",
        id = "city_hectel_decode",
        ["名称"] = "赫克提尔解析信件",
        ["动作ID"] = "JLC精灵城_赫克提尔解析信件",
        ["参数"] = {
            ["触发进度"] = 30,
            ["目标进度"] = 31,
            NPC = "ZX.赫克提尔",
            ["触发范围"] = 400,
            ["旧JASS功能清单"] = "QuestMessageBJ(WARNING) / QuestSetDescription / QuestMessageBJ"
        }
    },
    {
        type = "dialog",
        id = "city_hectel_01",
        ["名称"] = "赫克提尔接收信件",
        ["说话者"] = "赫克提尔",
        ["文本"] = "王上已经传信给我。把信给我，我会尽快拆解其中的魔力结构。",
        ["持续时间"] = 4
    },
    {
        type = "wait",
        id = "city_hectel_decode_wait",
        ["名称"] = "解析等待",
        ["持续时间"] = 2,
        ["允许Esc跳过"] = true,
        ["使用原生电影系统"] = true
    },
    {
        type = "dialog",
        id = "city_hectel_02",
        ["名称"] = "解析结果",
        ["说话者"] = "赫克提尔",
        ["文本"] = "这封信中的魔力极为古老，甚至带着|cffcc99ff『死神一脉』|r的正统痕迹。若我的判断没错，敌人盯上的不是巨魔，而是王城封存的传承。",
        ["持续时间"] = 7
    },
    {
        type = "broadcast",
        id = "city_emergency_message",
        ["名称"] = "王城紧急通讯",
        ["说话者"] = "魔法通讯",
        ["文本"] = "|cffff3333『紧急传讯』：|r王宫方向出现敌袭，克林姆德王召集所有人立刻回到会议厅！",
        ["持续时间"] = 5
    }
}
local _____738B_57CE_4F1A_8BAE_4E0E_7AE0_8282Boss_6B65_9AA4 = {
    {
        type = "runAction",
        id = "city_emergency_meeting",
        ["名称"] = "紧急会议触发",
        ["动作ID"] = "JLC精灵城_紧急会议",
        ["参数"] = {
            ["触发进度"] = 31,
            ["目标进度"] = 32,
            NPC = "ZX.克林姆德王",
            ["触发范围"] = 400,
            ["旧JASS功能清单"] = "TransmissionFromUnitWithNameBJ / QuestSetDescription / QuestMessageBJ"
        }
    },
    {
        type = "dialog",
        id = "city_meeting_king_01",
        ["名称"] = "国王说明突袭",
        ["说话者"] = "克林姆德王",
        ["文本"] = "敌袭来得太快。教派真正的目标不是边境，而是王城内部的|cffffcc99『传承密室』|r。",
        ["持续时间"] = 6
    },
    {
        type = "dialog",
        id = "city_meeting_hectel_01",
        ["名称"] = "赫克提尔确认密室风险",
        ["说话者"] = "赫克提尔",
        ["文本"] = "密室中封存着王族血脉与旧神契约的记录。若被教派夺走，后果不堪设想。",
        ["持续时间"] = 6
    },
    {
        type = "dialog",
        id = "city_meeting_player_01",
        ["名称"] = "玩家请求出战",
        ["说话者"] = "玩家",
        ["文本"] = "我们一路追查至此，不会在最后关头退缩。请打开通路，我们去阻止他们。",
        ["持续时间"] = 5
    },
    {
        type = "runAction",
        id = "city_chapter_boss_death_bridge",
        ["名称"] = "章节末战后长对白承接",
        ["动作ID"] = "SW01死亡事件_章节末长对白承接",
        ["参数"] = {["触发进度"] = 32, ["目标进度"] = 33, ["旧JASS功能清单"] = "死亡触发中的章节末长对白 / QuestMessageBJ(WARNING) / QuestSetDescription"}
    },
    {
        type = "dialog",
        id = "chapter_bridge_01",
        ["名称"] = "旧神与教派线索",
        ["说话者"] = "赫克提尔",
        ["文本"] = "那股气息不会错。教派正在寻找能重启古代契约的钥匙，而王城密室只是其中一环。",
        ["持续时间"] = 6
    },
    {
        type = "dialog",
        id = "chapter_bridge_02",
        ["名称"] = "国王交代后续",
        ["说话者"] = "克林姆德王",
        ["文本"] = "诸位，使者身份已经不足以概括你们的处境。从现在起，你们也是这场战争的见证者。",
        ["持续时间"] = 6
    }
}
local _____7AE0_8282_672B_6536_675F_6B65_9AA4 = {
    {
        type = "runAction",
        id = "city_chapter_end_after_progress_34",
        ["名称"] = "章节末最终收束触发",
        ["动作ID"] = "SW01死亡事件_章节末最终收束",
        ["参数"] = {["触发进度"] = 34, ["目标进度"] = 35, ["旧JASS功能清单"] = "死亡触发中的章节末最终收束对白 / QuestSetDescription / QuestMessageBJ"}
    },
    {
        type = "dialog",
        id = "chapter_end_01",
        ["名称"] = "王城战后",
        ["说话者"] = "克林姆德王",
        ["文本"] = "王城暂时守住了，但这不是胜利。教派已经确认了钥匙的存在，下一次行动只会更快、更狠。",
        ["持续时间"] = 6
    },
    {
        type = "dialog",
        id = "chapter_end_player_01",
        ["名称"] = "玩家接下后续",
        ["说话者"] = "玩家",
        ["文本"] = "我们会继续追查。无论他们想打开什么，都不能让这片大陆再经历一次灾变。",
        ["持续时间"] = 5
    },
    {
        type = "dialog",
        id = "chapter_end_hectel_01",
        ["名称"] = "赫克提尔给出方向",
        ["说话者"] = "赫克提尔",
        ["文本"] = "下一条线索，或许在旧王国遗址。那里埋着太多被历史故意抹去的名字。",
        ["持续时间"] = 6
    },
    {
        type = "runAction",
        id = "chapter_end_next_quest",
        ["名称"] = "第二章任务指引",
        ["动作ID"] = "JLC精灵城_章节末任务刷新",
        ["参数"] = {["任务描述"] = "前往旧王国遗址，追查分离教派与古代契约。", ["任务更新提示"] = "|cffffff00『主线目标』：|r前往下一处线索地点。"}
    }
}
local ____array_0 = __TS__SparseArrayNew(table.unpack(_____9B54_6CD5_4FE1_4EF6_89E3_6790_6B65_9AA4))
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____738B_57CE_4F1A_8BAE_4E0E_7AE0_8282Boss_6B65_9AA4)
)
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____7AE0_8282_672B_6536_675F_6B65_9AA4)
)
____exports["王城会议到章节末承接剧情片段"] = {
    ["片段ID"] = "elven_city_meeting_to_chapter_end",
    ["名称"] = "王城会议到章节末承接",
    ["可Esc整段跳过"] = true,
    ["默认倍速"] = 1,
    ["步骤列表"] = {__TS__SparseArraySpread(____array_0)}
}
____exports.default = ____exports["王城会议到章节末承接剧情片段"]
return ____exports
