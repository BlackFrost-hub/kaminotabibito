local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____00_FF0E_652F_7EBF_4EA4_4E92_914D_7F6E = require("系统.11．剧情系统.02．支线任务.00．支线交互配置")
local _____9759_6001_652F_7EBFNPC_914D_7F6E_5217_8868 = ____00_FF0E_652F_7EBF_4EA4_4E92_914D_7F6E["静态支线NPC配置列表"]
local ____02_FF0E_5165_53E3_914D_7F6E = require("系统.11．剧情系统.02．支线任务.02．污染之猫米亚.02．入口配置")
local _____6C61_67D3_4E4B_732B_7C73_4E9ANPC_914D_7F6E_5217_8868 = ____02_FF0E_5165_53E3_914D_7F6E["污染之猫米亚NPC配置列表"]
local _____7EAF_5BF9_8BDDNPC_914D_7F6E_5217_8868 = {
    {
        ["NPC名称"] = "人类猎人",
        ["任务ID"] = 1001,
        ["NPC配置名"] = "人类猎人",
        ["单位ID"] = "hmil",
        ["类型"] = "对话",
        ["坐标X"] = -26819.3,
        ["坐标Y"] = -8344.6,
        ["朝向"] = 180,
        ["启用"] = true
    },
    {
        ["NPC名称"] = "精灵村信使",
        ["任务ID"] = 1002,
        ["NPC配置名"] = "精灵村信使",
        ["单位ID"] = "n01H",
        ["类型"] = "对话",
        ["坐标X"] = -27392.3,
        ["坐标Y"] = -28285.2,
        ["朝向"] = 200,
        ["启用"] = true
    },
    {
        ["NPC名称"] = "精灵村村民",
        ["任务ID"] = 1003,
        ["NPC配置名"] = "精灵",
        ["单位ID"] = "nhef",
        ["类型"] = "对话",
        ["坐标X"] = -26657.5,
        ["坐标Y"] = -28275.3,
        ["朝向"] = 165,
        ["模型路径"] = "war3mapImported\\ElfVillagerWomanV2.02.mdl",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "沙漠神秘刺客",
        ["任务ID"] = 1004,
        ["NPC配置名"] = "沙漠神秘刺客",
        ["单位ID"] = "nass",
        ["类型"] = "对话",
        ["坐标X"] = -15871.9,
        ["坐标Y"] = -20945.1,
        ["朝向"] = 270,
        ["初始化动作"] = "RemoveItemFromStockBJ:itemId(I0AG|I0AH|I0AI);random1",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "沙漠战斗商人",
        ["任务ID"] = 1005,
        ["NPC配置名"] = "沙漠战斗商人",
        ["单位ID"] = "n02I",
        ["类型"] = "对话",
        ["坐标X"] = -6926.7,
        ["坐标Y"] = -22781,
        ["朝向"] = 62.82,
        ["启用"] = true
    }
}
local ____array_0 = __TS__SparseArrayNew(table.unpack(_____7EAF_5BF9_8BDDNPC_914D_7F6E_5217_8868))
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____9759_6001_652F_7EBFNPC_914D_7F6E_5217_8868)
)
__TS__SparseArrayPush(
    ____array_0,
    {
        ["NPC名称"] = "内务总管-语维",
        ["任务ID"] = 10024,
        ["NPC配置名"] = "失踪的精灵侍从",
        ["单位ID"] = "e08R",
        ["类型"] = "任务",
        ["坐标X"] = 23021.7,
        ["坐标Y"] = -23819.4,
        ["朝向"] = 180,
        ["自动创建"] = false,
        ["启用"] = true
    },
    table.unpack(_____6C61_67D3_4E4B_732B_7C73_4E9ANPC_914D_7F6E_5217_8868)
)
____exports["支线NPC配置列表"] = {__TS__SparseArraySpread(____array_0)}
____exports.default = ____exports["支线NPC配置列表"]
return ____exports
