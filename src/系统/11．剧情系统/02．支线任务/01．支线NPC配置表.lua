local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____00_FF0E_5165_53E3_914D_7F6E = require("系统.11．剧情系统.02．支线任务.01．被驱逐的水怪.00．入口配置")
local _____88AB_9A71_9010_7684_6C34_602ANPC_914D_7F6E_5217_8868 = ____00_FF0E_5165_53E3_914D_7F6E["被驱逐的水怪NPC配置列表"]
local ____02_FF0E_5165_53E3_914D_7F6E = require("系统.11．剧情系统.02．支线任务.02．污染之猫米亚.02．入口配置")
local _____6C61_67D3_4E4B_732B_7C73_4E9ANPC_914D_7F6E_5217_8868 = ____02_FF0E_5165_53E3_914D_7F6E["污染之猫米亚NPC配置列表"]
local ____02_FF0E_5165_53E3_914D_7F6E = require("系统.11．剧情系统.02．支线任务.04．莫尔特斯.02．入口配置")
local _____83AB_5C14_7279_65AFNPC_914D_7F6E_5217_8868 = ____02_FF0E_5165_53E3_914D_7F6E["莫尔特斯NPC配置列表"]
local ____array_0 = __TS__SparseArrayNew(
    {
        ["NPC名称"] = "人类农民",
        ["任务ID"] = 1000,
        ["NPC配置名"] = "收集豺狼皮2",
        ["单位ID"] = "hpea",
        ["类型"] = "任务",
        ["坐标X"] = -327.9,
        ["坐标Y"] = -88.9,
        ["朝向"] = 270,
        ["模型路径"] = "units\\human\\Peasant\\Peasant",
        ["启用"] = true
    },
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
        ["模型路径"] = "units\\critters\\HighElfPeasant\\HighElfPeasant",
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
        ["模型路径"] = "units\\creeps\\BanditSpearThrower\\BanditSpearThrower",
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
        ["模型路径"] = "units\\creeps\\Bandit\\Bandit.mdl",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "精灵村弓箭手",
        ["任务ID"] = 10001,
        ["NPC配置名"] = "猎杀豺狼人",
        ["单位ID"] = "n01I",
        ["类型"] = "任务",
        ["坐标X"] = -25549.1,
        ["坐标Y"] = -26008.7,
        ["朝向"] = 120,
        ["模型路径"] = "units\\creeps\\HighElfArcher\\HighElfArcher",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "精灵村民",
        ["任务ID"] = 10002,
        ["NPC配置名"] = "采集荧光草",
        ["单位ID"] = "n01J",
        ["类型"] = "任务",
        ["坐标X"] = -23827.3,
        ["坐标Y"] = -27726.2,
        ["朝向"] = 220,
        ["模型路径"] = "war3mapImported\\ElfVillagerWomanV2.02.mdl",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "黑暗巫师",
        ["任务ID"] = 10003,
        ["NPC配置名"] = "收集蜘蛛毒液",
        ["单位ID"] = "n01N",
        ["类型"] = "任务",
        ["坐标X"] = -18313.7,
        ["坐标Y"] = -25518.5,
        ["朝向"] = 0,
        ["模型路径"] = "units\\creeps\\BanditMage\\BanditMage",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "亡灵法师-安格斯",
        ["任务ID"] = 10004,
        ["NPC配置名"] = "收集熔岩能量",
        ["单位ID"] = "n040",
        ["类型"] = "任务",
        ["模型路径"] = "units\\undead\\Necromancer\\Necromancer.mdl",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "精灵村民",
        ["任务ID"] = 10005,
        ["NPC配置名"] = "收集豺狼皮",
        ["单位ID"] = "nhef",
        ["类型"] = "任务",
        ["坐标X"] = -26609,
        ["坐标Y"] = -26978,
        ["朝向"] = 138,
        ["模型路径"] = "war3mapImported\\ElfVillagerWomanV2.02.mdl",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "布里强",
        ["任务ID"] = 10006,
        ["NPC配置名"] = "收集20个蝎肉",
        ["单位ID"] = "nban",
        ["类型"] = "任务",
        ["坐标X"] = -5460.2,
        ["坐标Y"] = -24955.4,
        ["朝向"] = 90,
        ["模型路径"] = "units\\creeps\\Bandit\\Bandit",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "树魔",
        ["任务ID"] = 10007,
        ["NPC配置名"] = "收集7个蝎壳",
        ["单位ID"] = "nftt",
        ["类型"] = "任务",
        ["坐标X"] = -8105.6,
        ["坐标Y"] = -21191.5,
        ["朝向"] = 270,
        ["模型路径"] = "war3mapImported\\ForestTrollShadowPriest.mdl",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "精灵猎手",
        ["任务ID"] = 10008,
        ["NPC配置名"] = "收集有毒杂草",
        ["单位ID"] = "e08B",
        ["类型"] = "任务",
        ["坐标X"] = -23856.2,
        ["坐标Y"] = -29293.1,
        ["朝向"] = 270,
        ["模型路径"] = "war3mapImported\\Watcher.mdl",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "精灵村民",
        ["任务ID"] = 10009,
        ["NPC配置名"] = "寻找聚灵花",
        ["单位ID"] = "nhef",
        ["类型"] = "任务",
        ["坐标X"] = -23161.8,
        ["坐标Y"] = -26556.9,
        ["朝向"] = 45,
        ["模型路径"] = "war3mapImported\\ElfVillagerWomanV2.02.mdl",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "熔岩术士",
        ["任务ID"] = 10010,
        ["NPC配置名"] = "送信",
        ["单位ID"] = "nsra",
        ["类型"] = "任务",
        ["坐标X"] = 6903.8,
        ["坐标Y"] = -25005.3,
        ["朝向"] = 10,
        ["模型路径"] = "units\\creeps\\OrcWarlock\\OrcWarlock",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "守望者",
        ["任务ID"] = 10011,
        ["NPC配置名"] = "希望获得品质较好的道具或饰品",
        ["单位ID"] = "n036",
        ["类型"] = "任务",
        ["坐标X"] = 8864.6,
        ["坐标Y"] = -22209.2,
        ["朝向"] = 255.96,
        ["模型路径"] = "units\\creeps\\assassin\\assassin",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "精灵弓箭手",
        ["任务ID"] = 10012,
        ["NPC配置名"] = "有提高视力的道具吗",
        ["单位ID"] = "e06Q",
        ["类型"] = "任务",
        ["坐标X"] = -27950.6,
        ["坐标Y"] = -26851.8,
        ["朝向"] = 45,
        ["模型路径"] = "war3mapImported\\maleelfarcher.mdl",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "冒险者阿利亚",
        ["任务ID"] = 10013,
        ["NPC配置名"] = "消失的笛子",
        ["单位ID"] = "n058",
        ["类型"] = "任务",
        ["坐标X"] = -27974.4,
        ["坐标Y"] = -7209.5,
        ["朝向"] = 270,
        ["模型路径"] = "units\\critters\\VillagerMan\\VillagerMan",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "德鲁伊学者-卢伊",
        ["任务ID"] = 10014,
        ["NPC配置名"] = "暗狱之书",
        ["单位ID"] = "n059",
        ["类型"] = "任务",
        ["坐标X"] = 29335.3,
        ["坐标Y"] = -27943.2,
        ["朝向"] = 270,
        ["模型路径"] = "war3mapImported\\Hero Druid.mdl",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "德鲁伊指引者-阿莫斯",
        ["任务ID"] = 10016,
        ["NPC配置名"] = "净化狂暴之熊",
        ["单位ID"] = "n04M",
        ["类型"] = "任务",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "德鲁伊看守者-阿尔文",
        ["任务ID"] = 10017,
        ["NPC配置名"] = "给予圣果",
        ["单位ID"] = "n04O",
        ["类型"] = "任务",
        ["模型路径"] = "war3mapImported\\Annurion.mdl",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "知识古树",
        ["任务ID"] = 10018,
        ["NPC配置名"] = "补充生命力",
        ["单位ID"] = "e06N",
        ["类型"] = "任务",
        ["坐标X"] = -18950.5,
        ["坐标Y"] = -14412.4,
        ["朝向"] = 270,
        ["模型路径"] = "war3mapImported\\druidtreeform.mdl",
        ["启用"] = true
    },
    {
        ["NPC名称"] = "精灵族长-斯韦尔",
        ["任务ID"] = 10019,
        ["NPC配置名"] = "|cffff0000失踪的精灵村民（Boss战任务）|r",
        ["单位ID"] = "edot",
        ["类型"] = "任务",
        ["模型路径"] = "units\\nightelf\\DruidoftheTalon\\DruidoftheTalon",
        ["启用"] = true
    },
    table.unpack(_____88AB_9A71_9010_7684_6C34_602ANPC_914D_7F6E_5217_8868)
)
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____6C61_67D3_4E4B_732B_7C73_4E9ANPC_914D_7F6E_5217_8868)
)
__TS__SparseArrayPush(
    ____array_0,
    table.unpack(_____83AB_5C14_7279_65AFNPC_914D_7F6E_5217_8868)
)
____exports["支线NPC配置列表"] = {__TS__SparseArraySpread(____array_0)}
____exports.default = ____exports["支线NPC配置列表"]
return ____exports
