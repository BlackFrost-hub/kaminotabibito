--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["瑟兰迪尔阶段阈值"] = {["第二阶段生命比例"] = 0.7, ["第三阶段生命比例"] = 0.4}
____exports["瑟兰迪尔数值与表现配置"] = {
    ["执法印记"] = {
        ["周期秒"] = 30,
        ["持续秒"] = 30,
        ["Boss对标记目标伤害加成"] = 0.3,
        ["单人额外伤害加成"] = 0.15,
        ["特效"] = "Common\\Effect\\Form\\Charge\\k3.mdx",
        ["挂点"] = "origin"
    },
    ["月光枷锁"] = {
        ["技能槽位"] = "AT05",
        BuffID = "BTH1",
        ["月光碎片物品ID"] = "I0E5",
        ["施法距离"] = 900,
        ["定身秒"] = 3,
        ["Tick间隔秒"] = 1,
        ["Tick伤害"] = 80,
        ["打断所需伤害"] = 1500,
        ["施法硬直秒"] = 1,
        ["动画编号"] = 3,
        ["飞行特效"] = "Common\\Effect\\Element\\Light\\TX_TSW_JINHUANGQIU.mdx",
        ["命中特效"] = "Common\\Effect\\Element\\Light\\protectionaura.mdx"
    },
    ["月光碎片"] = {
        ["物品ID"] = "I0E5",
        BuffID = "BTH2",
        ["持续秒"] = 6,
        ["基础移速百分比"] = 0.25,
        ["图标"] = "BuffIcon\\Boss\\Thranduil\\yueguangsuipian.blp",
        ["特效"] = "Common\\Effect\\Element\\Light\\protectionaura.mdx"
    },
    ["精灵箭阵"] = {
        ["技能槽位"] = "AN00",
        ["数量"] = 4,
        ["出生距离"] = 1000,
        ["持续秒"] = 20,
        ["生命倍率"] = 0.15,
        ["攻击间隔秒"] = 2,
        ["伤害倍率"] = 0.5,
        ["弹道速度"] = 800,
        ["模型文件"] = "war3mapImported\\Ancient Guard7.mdx"
    },
    ["秩序领域"] = {["半径"] = 300, ["攻击速度降低"] = 0.3, ["Tick秒"] = 0.25, ["特效"] = "Common\\Effect\\Form\\MagicCircle\\xxx09.mdx"},
    ["审判之环"] = {
        ["周期秒"] = 12,
        ["半径"] = 650,
        ["警示秒"] = 2,
        ["持续秒"] = 10,
        ["特效"] = "Common\\Effect\\Element\\Light\\WrathOfArchangels_Final.mdx"
    },
    ["罪与罚"] = {["技能槽位"] = "AT06", ["施法距离"] = 1000, ["延迟秒"] = 5, ["优先执法印记目标"] = true},
    ["律法召唤"] = {
        ["技能槽位"] = "AN00",
        ["数量单人"] = 1,
        ["数量多人"] = 2,
        ["生命倍率"] = 0.15,
        ["护甲"] = 20,
        ["模型文件"] = "war3mapImported\\Ancient Guard7.mdx",
        ["攻击范围"] = 650,
        ["普攻弹道模型"] = "Abilities\\Weapons\\MoonPriestessMissile\\MoonPriestessMissile.mdl",
        ["普攻弹道弧度"] = 0.15,
        ["普攻弹道速度"] = 900
    },
    ["月光灌注"] = {
        ["触发生命比例"] = 0.4,
        ["攻击力加成"] = 0.5,
        ["模型缩放加成"] = 0.3,
        ["移动速度降低"] = 0.2,
        ["狂暴秒"] = 180,
        ["施法硬直秒"] = 3,
        ["特效"] = "Common\\Effect\\Element\\Fantasy\\runiccaster.mdx"
    },
    ["终末审判"] = {
        ["周期秒"] = 30,
        ["引导秒"] = 5,
        ["爆炸延迟秒"] = 2,
        ["安全区半径"] = 100,
        ["警示特效"] = "war3mapImported\\arcaneseal.mdx",
        ["蓄力特效"] = "Common\\Effect\\Element\\xuli\\4.mdx",
        ["爆炸特效"] = "war3mapImported\\asuma-explosion.mdx"
    }
}
return ____exports
