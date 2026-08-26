--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["爱蜜莉雅技能配置"] = {
    ["单位类型ID"] = "E00C",
    Q = {["技能ID"] = "AEQ1", ["名称"] = "冰之矢（Q）", ["图标"] = "ReplaceableTextures\\CommandButtons\\BTNFreezingBreath.blp", ["快捷键"] = "Q"},
    W = {["技能ID"] = "AEW1", ["名称"] = "冰花绽放（W）", ["图标"] = "ReplaceableTextures\\CommandButtons\\BTNBlizzard.blp", ["快捷键"] = "W"},
    E = {["技能ID"] = "AEE1", ["名称"] = "冰晶护身（E）", ["图标"] = "ReplaceableTextures\\CommandButtons\\BTNIceArmor.blp", ["快捷键"] = "E"},
    R = {["技能ID"] = "AER1", ["名称"] = "永冻之庭（R）", ["图标"] = "ReplaceableTextures\\CommandButtons\\BTNFrostNova.blp", ["快捷键"] = "R"},
    D = {["技能ID"] = "AED1", ["名称"] = "帕克显现（D）", ["图标"] = "ReplaceableTextures\\CommandButtons\\BTNWaterElemental.blp", ["快捷键"] = "D"}
}
--- 冰晶节点配置（A1）。节点是世界坐标表现与联动支点，不是可选取/可攻击/可阻挡路径单位。
____exports["爱蜜莉雅冰晶配置"] = {
    ["模型"] = "Common\\Effect\\Element\\Ice\\EmiliaIceCrystalNode.mdx",
    ["数量上限"] = 3,
    ["缩放"] = 1,
    ["高度"] = 0,
    ["替换规则"] = "最旧"
}
--- 蓄力/吟唱读条默认配置（A1）：统一使用 06．施法·蓄力·充能 的世界坐标进度 UI，跟随施法者。
____exports["爱蜜莉雅读条配置"] = {["UI类型"] = "自然", ["标题"] = "", ["数值后缀"] = "", ["跟随Z偏移"] = 233}
--- 被动：冰之精灵术（A2）
-- 数值均标 待平衡，非最终值（执行规则：不得把临时值伪装成最终值）。
____exports["爱蜜莉雅被动配置"] = {
    ["寒意阈值"] = 3,
    ["寒意持续秒"] = 5,
    ["冻结秒"] = 1.25,
    ["冻结抗性秒"] = 3,
    ["霜裂秒"] = 3,
    ["碎冰攻击力倍率"] = 1,
    ["对受控目标伤害倍率"] = 0.1
}
--- 普攻联动：契约应和与帕克追击（A3）
____exports["爱蜜莉雅普攻配置"] = {
    ["契约应和持续秒"] = 5,
    ["契约应和上限"] = 3,
    ["帕克追击冷却缩减秒"] = 1,
    ["帕克追击速度"] = 1400,
    ["帕克追击伤害攻击力倍率"] = 0.5,
    ["帕克追击模型"] = "Common\\Effect\\Projectile\\file00000543.mdx",
    ["帕克追击缩放"] = 0.7,
    ["帕克追击命中半径"] = 90
}
--- Q：冰之矢（A4）
____exports["爱蜜莉雅Q配置"] = {
    ["冷却秒"] = 5,
    ["魔耗"] = 60,
    ["弹道速度"] = 1400,
    ["最大距离"] = 900,
    ["命中半径"] = 100,
    ["伤害攻击力倍率"] = 1.2,
    ["穿晶距离"] = 130,
    ["分裂冰刃数量"] = 3,
    ["分裂冰刃伤害攻击力倍率"] = 0.4,
    ["分裂冰刃速度"] = 900,
    ["终点冰晶持续秒"] = 8,
    ["弹道模型"] = "Common\\Effect\\Element\\Ice\\sem_han_bing_jian_jian_shi.mdx",
    ["命中特效模型"] = "Common\\Effect\\Element\\Ice\\file00000153.mdx",
    ["穿晶特效模型"] = "Common\\Effect\\Element\\Ice\\file00000153.mdx",
    ["动作索引"] = 9
}
--- W：冰花绽放（A5）
____exports["爱蜜莉雅W配置"] = {
    ["冷却秒"] = 9,
    ["魔耗"] = 80,
    ["二段技能ID"] = "ASW2",
    ["D强化冰晶持续秒"] = 6,
    ["半径"] = 350,
    ["持续秒"] = 4,
    ["周期秒"] = 1,
    ["减速百分比"] = 0.3,
    ["周期施加寒意"] = true,
    ["创建伤害攻击力倍率"] = 0.6,
    ["自然结束伤害攻击力倍率"] = 0.9,
    ["二段伤害攻击力倍率"] = 1.2,
    ["冰片数量"] = 6,
    ["冰片速度"] = 900,
    ["冰片伤害攻击力倍率"] = 0.3,
    ["冰花模型"] = "Common\\Effect\\Element\\Ice\\iceflower.mdx",
    ["寒气模型"] = "Common\\Effect\\Element\\Ice\\file_000916.mdx",
    ["冰片模型"] = "Common\\Effect\\Element\\Ice\\freezingsplinter.mdx",
    ["动作索引"] = 5
}
--- E：冰晶护身（A6）
____exports["爱蜜莉雅E配置"] = {
    ["冷却秒"] = 10,
    ["魔耗"] = 70,
    ["二段技能ID"] = "ASE2",
    ["保护脉冲护盾攻击力倍率"] = 1,
    ["保护脉冲持续秒"] = 3,
    ["护盾攻击力倍率"] = 3,
    ["护盾持续秒"] = 4,
    ["位移距离"] = 400,
    ["位移速度"] = 1600,
    ["落点冰爆伤害攻击力倍率"] = 0.8,
    ["破盾伤害攻击力倍率"] = 0.8,
    ["落点生成冰晶"] = true,
    ["落点冰晶持续秒"] = 8,
    ["短惩罚冷却秒"] = 2,
    ["护盾模型"] = "Common\\Effect\\Element\\Ice\\BY_Wood_Effect_Kula_3_BingGuan.mdx",
    ["冰面路径模型"] = "Common\\Effect\\Element\\Ice\\EmiliaEIcePathTile.mdx",
    ["落点冰爆模型"] = "Common\\Effect\\Element\\Ice\\EmiliaEIceExplosion.mdx",
    ["破盾裂纹模型"] = "Common\\Effect\\Element\\Ice\\EmiliaEShatterCrack.mdx",
    ["动作索引"] = 8
}
--- D：帕克显现（A7）
____exports["爱蜜莉雅D配置"] = {
    ["冷却秒"] = 15,
    ["魔耗"] = 40,
    ["持续秒"] = 12,
    ["强化次数"] = 3,
    ["环绕模型"] = "Common\\Effect\\Element\\Ice\\icespirits.mdx",
    ["扩散模型"] = "Common\\Effect\\Element\\Ice\\BY_Wood_Effect_Ord_DanGe_Wav_Kuosan_1_3_0.5s.mdx",
    ["强化提示模型"] = "BlueSoulFlashSpread.mdx",
    ["动作索引"] = 4
}
--- R：永冻之庭（A8）
____exports["爱蜜莉雅R配置"] = {
    ["冷却秒"] = 70,
    ["魔耗"] = 140,
    ["半径"] = 600,
    ["蓄力秒"] = 0.6,
    ["持续秒"] = 5,
    ["周期秒"] = 1,
    ["周期伤害攻击力倍率"] = 0.15,
    ["周期施加寒意"] = true,
    ["减速百分比"] = 0.3,
    ["冰晶读取上限"] = 3,
    ["冰晶爆发伤害攻击力倍率"] = 0.8,
    ["最终冰爆伤害攻击力倍率"] = 2,
    ["领域模型"] = "Common\\Effect\\Element\\Ice\\sem_shuang_dong_xin_xing.mdx",
    ["最终冰爆模型"] = "Common\\Effect\\Element\\Ice\\Shiva'sWrath.mdx",
    ["闪电代码"] = "BLSB",
    ["强化半径倍率"] = 1.3,
    ["强化最终冰爆伤害攻击力倍率"] = 2.8,
    ["动作索引"] = 13
}
return ____exports
