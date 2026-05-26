--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____05_FF0E_7D27_51D1_5267_60C5_7247_6BB5_7F16_8BD1 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.05．紧凑剧情片段编译")
local _____7F16_8BD1_7D27_51D1_5267_60C5_7247_6BB5 = ____05_FF0E_7D27_51D1_5267_60C5_7247_6BB5_7F16_8BD1["编译紧凑剧情片段"]
____exports["王宫门卫支线发现紧凑剧情片段"] = {
    ["片段ID"] = "elven_city_side_quest_discover",
    ["名称"] = "王宫门卫支线发现",
    ["触发条件"] = "剧情进度 == 23 且玩家靠近王宫门卫2",
    ["可Esc整段跳过"] = true,
    ["默认倍速"] = 1,
    ["默认对白持续时间"] = 3,
    ["对白列表"] = {},
    ["动作时间线"] = {{
        ["序号"] = 1,
        ["挂点"] = "absoluteTime",
        ["时间秒"] = 0,
        ["动作ID"] = "JLC精灵城_王宫门卫2支线发现",
        ["名称"] = "王宫门卫2支线发现",
        ["参数"] = {
            ["触发进度"] = 23,
            ["目标进度"] = 24,
            NPC = "主线NPC.jl禁军门卫2",
            ["触发范围"] = 600,
            ["触发单位发布命令"] = "stop",
            ["支线任务"] = "udg_RW[8]",
            ["旧JASS功能清单"] = "QuestSetDiscovered / QuestMessageBJ(DISCOVERED)"
        }
    }}
}
____exports["王宫门卫支线发现剧情片段"] = _____7F16_8BD1_7D27_51D1_5267_60C5_7247_6BB5(____exports["王宫门卫支线发现紧凑剧情片段"])
return ____exports
