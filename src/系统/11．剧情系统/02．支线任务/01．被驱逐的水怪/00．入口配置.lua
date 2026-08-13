--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____6CE8_9500_5361_745F_62C9_5165_53E3_8303_56F4_76D1_542C, _____6CE8_9500_5361_745F_62C9_6B7B_4EA1_76D1_542C, _____6E05_7406_5361_745F_62C9_5165_53E3_76D1_542C, ____on_5361_745F_62C9_6B7B_4EA1, unregisterDeathListener, _____5F53_524D_5361_745F_62C9_5355_4F4D, _____53D6_6D88_5361_745F_62C9_5165_53E3_8303_56F4_76D1_542C, _____5DF2_6CE8_518C_5361_745F_62C9_6B7B_4EA1_76D1_542C
local ____02_FF0E_5267_60C5NPC_521B_5EFA = require("系统.11．剧情系统.00．公共.02．剧情NPC创建")
local _____521B_5EFA_5267_60C5NPC_5355_4F4D = ____02_FF0E_5267_60C5NPC_521B_5EFA["创建剧情NPC单位"]
function _____6CE8_9500_5361_745F_62C9_5165_53E3_8303_56F4_76D1_542C()
    if _____53D6_6D88_5361_745F_62C9_5165_53E3_8303_56F4_76D1_542C ~= nil then
        _____53D6_6D88_5361_745F_62C9_5165_53E3_8303_56F4_76D1_542C()
    end
    _____53D6_6D88_5361_745F_62C9_5165_53E3_8303_56F4_76D1_542C = nil
end
function _____6CE8_9500_5361_745F_62C9_6B7B_4EA1_76D1_542C()
    if not _____5DF2_6CE8_518C_5361_745F_62C9_6B7B_4EA1_76D1_542C then
        return
    end
    unregisterDeathListener(____on_5361_745F_62C9_6B7B_4EA1)
    _____5DF2_6CE8_518C_5361_745F_62C9_6B7B_4EA1_76D1_542C = false
end
function _____6E05_7406_5361_745F_62C9_5165_53E3_76D1_542C()
    _____6CE8_9500_5361_745F_62C9_5165_53E3_8303_56F4_76D1_542C()
    _____6CE8_9500_5361_745F_62C9_6B7B_4EA1_76D1_542C()
end
function ____on_5361_745F_62C9_6B7B_4EA1(dyingUnit, _killingUnit)
    if dyingUnit ~= _____5F53_524D_5361_745F_62C9_5355_4F4D then
        return
    end
    _____6E05_7406_5361_745F_62C9_5165_53E3_76D1_542C()
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.09．表现系统.06．广播提示消息.index")
local _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6 = ____require_result_0["发送头像提示给玩家"]
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_0["广播单位提示"]
local _____64AD_653E_5E7F_64AD_5BF9_767D_5E8F_5217 = ____require_result_0["播放广播对白序列"]
local ____require_result_1 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 = ____require_result_1["广播提示玩家槽数"]
local _____5E7F_64AD_63D0_793A_5587_53ED_5934_50CF = ____require_result_1["广播提示喇叭头像"]
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerOneShotUnitRangeListener = ____require_result_2.registerOneShotUnitRangeListener
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_3.registerDeathListener
unregisterDeathListener = ____require_result_3.unregisterDeathListener
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_4["是玩家英雄组单位"]
local ____require_result_5 = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表.index")
local _____5361_745F_62C9_5956_52B1_6C60ID = ____require_result_5["卡瑟拉奖励池ID"]
local ____require_result_6 = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面")
local _____6253_5F00_9996_9886_5956_52B1_9009_62E9_754C_9762 = ____require_result_6["打开首领奖励选择界面"]
local _____5361_745F_62C9_5DF2_521B_5EFA = false
_____5F53_524D_5361_745F_62C9_5355_4F4D = nil
local _____5361_745F_62C9_5165_53E3_5DF2_89E6_53D1 = false
local _____5361_745F_62C9_5165_53E3_5BF9_767D_5DF2_5B8C_6210 = false
_____5DF2_6CE8_518C_5361_745F_62C9_6B7B_4EA1_76D1_542C = false
local Player = jass.Player
local PingMinimap = jass.PingMinimap
local function _____5E7F_64AD_5361_745F_62C9_6311_6218_63D0_793A()
    local _____6587_672C = "|cffffcc00『深海挑战』：|r前往原水龙蛇湖底区域挑战卡瑟拉！"
    do
        local _____73A9_5BB6ID = 0
        while _____73A9_5BB6ID < _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 do
            _____53D1_9001_5934_50CF_63D0_793A_7ED9_73A9_5BB6(
                Player(_____73A9_5BB6ID),
                _____5E7F_64AD_63D0_793A_5587_53ED_5934_50CF,
                _____6587_672C,
                5000
            )
            _____73A9_5BB6ID = _____73A9_5BB6ID + 1
        end
    end
end
local function ____on_5361_745F_62C9_5165_53E3_5BF9_767D_7ED3_675F()
    _____5361_745F_62C9_5165_53E3_5BF9_767D_5DF2_5B8C_6210 = true
end
local function _____8BFB_53D6_5361_745F_62C9_5165_53E3_8BF4_8BDD_5355_4F4D(______8BF4_8BDD_8005_952E)
    return _____5F53_524D_5361_745F_62C9_5355_4F4D
end
local function _____64AD_653E_5361_745F_62C9_5165_53E3_5E7F_64AD()
    _____64AD_653E_5E7F_64AD_5BF9_767D_5E8F_5217({["对白列表"] = {{["说话者键"] = "卡瑟拉", ["文本"] = "你们终于来到这里了……水龙蛇替我守住的最后一道屏障，竟也没能拦住你们。", ["停留毫秒"] = 4800}, {["说话者键"] = "卡瑟拉", ["文本"] = "沃利尔斯还在奢望重返故海。可从我自深渊苏醒的那一刻起，这片湖底便只听从我的意志。", ["停留毫秒"] = 6800}, {["说话者键"] = "卡瑟拉", ["文本"] = "潮汐战戟，还有你们想夺回的一切，都在这里。既然敢踏进我的领地，就用性命来证明你们配得上它。", ["停留毫秒"] = 4200}}, ["读取说话单位"] = _____8BFB_53D6_5361_745F_62C9_5165_53E3_8BF4_8BDD_5355_4F4D, ["播放单句"] = _____5E7F_64AD_5355_4F4D_63D0_793A, ["播放完成"] = ____on_5361_745F_62C9_5165_53E3_5BF9_767D_7ED3_675F})
end
local function ____on_5361_745F_62C9_8303_56F4_89E6_53D1(______89E6_53D1_5355_4F4D)
    if _____5361_745F_62C9_5165_53E3_5DF2_89E6_53D1 or _____5F53_524D_5361_745F_62C9_5355_4F4D == nil or _____5F53_524D_5361_745F_62C9_5355_4F4D == 0 then
        return true
    end
    _____5361_745F_62C9_5165_53E3_5DF2_89E6_53D1 = true
    _____6E05_7406_5361_745F_62C9_5165_53E3_76D1_542C()
    _____64AD_653E_5361_745F_62C9_5165_53E3_5E7F_64AD()
    return true
end
local function _____6CE8_518C_5361_745F_62C9_5165_53E3_8303_56F4_76D1_542C()
    _____53D6_6D88_5361_745F_62C9_5165_53E3_8303_56F4_76D1_542C = registerOneShotUnitRangeListener(_____5F53_524D_5361_745F_62C9_5355_4F4D, 1000, ____on_5361_745F_62C9_8303_56F4_89E6_53D1, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D)
    registerDeathListener(____on_5361_745F_62C9_6B7B_4EA1)
    _____5DF2_6CE8_518C_5361_745F_62C9_6B7B_4EA1_76D1_542C = true
end
____exports["被驱逐的水怪入口配置"] = {
    ["任务ID"] = 10020,
    ["前置Boss单位ID"] = "n011",
    ["前置Boss名称"] = "水龙蛇",
    ["前置Boss坐标X"] = 21068.2,
    ["前置Boss坐标Y"] = -27125.8,
    ["前置Boss朝向"] = 273.75
}
local function _____63A5_53D7_88AB_9A71_9010_7684_6C34_602A_4EFB_52A1_540E_521B_5EFA_5361_745F_62C9(______4EFB_52A1_914D_7F6E, ______73A9_5BB6ID)
    if _____5361_745F_62C9_5DF2_521B_5EFA then
        return
    end
    local _____5361_745F_62C9 = _____521B_5EFA_5267_60C5NPC_5355_4F4D({
        ["单位ID"] = "N05V",
        X = ____exports["被驱逐的水怪入口配置"]["前置Boss坐标X"],
        Y = ____exports["被驱逐的水怪入口配置"]["前置Boss坐标Y"],
        ["朝向"] = ____exports["被驱逐的水怪入口配置"]["前置Boss朝向"],
        ["玩家ID"] = 15
    })
    if _____5361_745F_62C9 == nil or _____5361_745F_62C9 == 0 then
        return
    end
    _____5F53_524D_5361_745F_62C9_5355_4F4D = _____5361_745F_62C9
    _____5361_745F_62C9_5DF2_521B_5EFA = true
    _____5361_745F_62C9_5165_53E3_5BF9_767D_5DF2_5B8C_6210 = false
    _____6CE8_518C_5361_745F_62C9_5165_53E3_8303_56F4_76D1_542C()
    _____5E7F_64AD_5361_745F_62C9_6311_6218_63D0_793A()
    PingMinimap(____exports["被驱逐的水怪入口配置"]["前置Boss坐标X"], ____exports["被驱逐的水怪入口配置"]["前置Boss坐标Y"], 5)
end
local function _____5B8C_6210_88AB_9A71_9010_7684_6C34_602A_4EFB_52A1_540E_6253_5F00_9996_9886_5956_52B1(______4EFB_52A1_914D_7F6E, ______73A9_5BB6ID)
    do
        local _____73A9_5BB6ID = 0
        while _____73A9_5BB6ID < _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 do
            local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
            if _____73A9_5BB6 ~= nil and jass:GetPlayerController(_____73A9_5BB6) == jass.MAP_CONTROL_USER then
                _____6253_5F00_9996_9886_5956_52B1_9009_62E9_754C_9762(_____5361_745F_62C9_5956_52B1_6C60ID, _____73A9_5BB6)
            end
            _____73A9_5BB6ID = _____73A9_5BB6ID + 1
        end
    end
end
____exports["被驱逐的水怪NPC配置列表"] = {{
    ["NPC名称"] = "被驱逐的水怪-沃利尔斯",
    ["任务ID"] = ____exports["被驱逐的水怪入口配置"]["任务ID"],
    ["NPC配置名"] = "被驱逐的水怪",
    ["单位ID"] = "n04Q",
    ["类型"] = "任务",
    ["坐标X"] = -19859.6,
    ["坐标Y"] = -16170.4,
    ["朝向"] = 150,
    ["自动创建"] = false,
    ["启用"] = true
}}
____exports["被驱逐的水怪任务配置列表"] = {{
    ["任务ID"] = ____exports["被驱逐的水怪入口配置"]["任务ID"],
    ["名称"] = "|cff33cccc被驱逐的水怪|r（|cffff0000深海Boss战任务|r）",
    ["类型"] = "目标击杀",
    ["开始NPC"] = "被驱逐的水怪-沃利尔斯",
    ["目标单位"] = "N05V",
    ["需求数量"] = 1,
    ["接取条件"] = "英雄等级＞30",
    ["奖励"] = "完成任务的玩家+1能量碎片",
    ["奖励显示"] = "完成任务的玩家+1能量碎片;卡瑟拉首领战利品（任选2件）",
    ["描述"] = "帮助沃利尔斯击败|cff33cccc深渊巨鱿·卡瑟拉|r，夺回被占据的深海家园与潮汐战戟。",
    ["进度文本"] = "击败深渊巨鱿·卡瑟拉 N/1",
    ["NPC开始对白"] = "NPC：你身上有水龙蛇的气息……它终于死了。\nPlayer：你一直在等有人杀死它？\nNPC：我叫沃利尔斯，曾是那片海域的守护者。直到深渊巨鱿·卡瑟拉从海沟中苏醒，它驱逐了我的族人，占据了我们的家园。\nNPC：它还夺走了维系海潮的|cff33cccc潮汐战戟|r，并派水龙蛇封锁海岸，不允许任何幸存者靠近。\nPlayer：所以你躲在这里，是为了寻找能击败它的人。\nNPC：没错。你能杀死水龙蛇，便有资格踏入卡瑟拉盘踞的深海。请帮我夺回家园，也夺回那柄战戟。",
    ["任务接受对白"] = "Player：我会去会会那头深渊巨鱿，让它把不属于它的东西吐出来。\nNPC：多谢。做好准备后再来找我，我会开启通往深海裂隙的道路。\nNPC：小心它的触手与墨汁。在海中，卡瑟拉远比水龙蛇危险。",
    ["接取后动作"] = _____63A5_53D7_88AB_9A71_9010_7684_6C34_602A_4EFB_52A1_540E_521B_5EFA_5361_745F_62C9,
    ["接取失败对白"] = "NPC：深海不会宽恕毫无准备的人。你们虽然击败了水龙蛇证明了实力，但再磨炼下为好（等级＞30），再来面对卡瑟拉。",
    ["NPC完成对白"] = "NPC：海潮的声音回来了……卡瑟拉真的死了。\nPlayer：你的家园和潮汐战戟都夺回来了。\nNPC：我失去的族人无法归来，但幸存者终于可以重返大海。冒险者，请接受被驱逐者最后的谢意。",
    ["完成后对白"] = "默认",
    ["完成后动作"] = _____5B8C_6210_88AB_9A71_9010_7684_6C34_602A_4EFB_52A1_540E_6253_5F00_9996_9886_5956_52B1,
    ["可重复"] = false,
    ["启用"] = true
}}
____exports["读取卡瑟拉单位"] = function()
    return _____5F53_524D_5361_745F_62C9_5355_4F4D
end
____exports["是否卡瑟拉入口对白已完成"] = function()
    return _____5361_745F_62C9_5165_53E3_5BF9_767D_5DF2_5B8C_6210
end
return ____exports
