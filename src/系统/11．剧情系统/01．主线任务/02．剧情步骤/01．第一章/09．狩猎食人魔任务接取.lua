--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____05_FF0E_7D27_51D1_5267_60C5_7247_6BB5_7F16_8BD1 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.05．紧凑剧情片段编译")
local _____7F16_8BD1_7D27_51D1_5267_60C5_7247_6BB5 = ____05_FF0E_7D27_51D1_5267_60C5_7247_6BB5_7F16_8BD1["编译紧凑剧情片段"]
____exports["蛇人族接受食人魔任务紧凑剧情片段"] = {
    ["片段ID"] = "jlc_snake_ogre_task_accept",
    ["名称"] = "蛇人族接受狩猎食人魔任务",
    ["触发条件"] = "剧情进度 == 9 且玩家拾取狩猎食人魔任务物品",
    ["可Esc整段跳过"] = true,
    ["默认倍速"] = 1,
    ["默认对白持续时间"] = 3,
    ["对白列表"] = {{["序号"] = 1, ["说话者"] = "玩家", ["文本"] = "既然已经决定接下这桩委托，那就先去把那头|cffff0000『沙漠食人魔』|r找出来。若它真如蛇人族所说那般凶恶，恐怕这一战不会轻松。", ["持续时间"] = 6.5}},
    ["动作时间线"] = {{
        ["序号"] = 1,
        ["挂点"] = "beforeDialog",
        ["对白序号"] = 1,
        ["动作ID"] = "SRZ蛇人族_接受食人魔任务",
        ["名称"] = "拾取狩猎食人魔任务物品后创建沙漠食人魔预置",
        ["参数"] = {
            ["触发进度"] = 9,
            ["目标进度"] = 10,
            ["注册范围"] = 850,
            ["任务更新提示"] = "|cffffff00『主线目标』：|r击败|cffff6600『沙漠食人魔』|r。",
            ["旧JASS功能清单"] = "RemoveItem(I0D0) / CreateUnit(次元裂缝) / QuestSetDescription / QuestMessageBJ / CreateUnit(沙漠食人魔) / PauseUnit / SetUnitInvulnerable / TriggerRegisterUnitInRangeSimple / CreatePermanentCorpseLocBJ"
        }
    }, {
        ["序号"] = 2,
        ["挂点"] = "afterDialog",
        ["对白序号"] = 1,
        ["动作ID"] = "SRZ蛇人族_食人魔任务预警",
        ["名称"] = "食人魔任务预警",
        ["参数"] = {["延迟秒数"] = 0.5, ["预警文本"] = "|cffffff00『系统提示』：|r新的|cffff6600『Boss战』|r目标已出现，请准备充分后再接近。Boss 区域已生成尸骨标记与异常裂隙。"}
    }}
}
____exports["蛇人族接受食人魔任务剧情片段"] = _____7F16_8BD1_7D27_51D1_5267_60C5_7247_6BB5(____exports["蛇人族接受食人魔任务紧凑剧情片段"])
return ____exports
