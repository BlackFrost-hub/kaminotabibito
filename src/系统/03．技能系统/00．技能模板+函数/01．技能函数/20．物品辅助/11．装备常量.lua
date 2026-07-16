--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING
local DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
____exports["第二章后段Boss战利品装备名"] = {
    ["菲利斯的统御纹章"] = "菲利斯的统御纹章",
    ["剑魂狼牙坠"] = "剑魂狼牙坠",
    ["封印斩护腕"] = "封印斩护腕",
    ["异形化残刃"] = "异形化残刃",
    ["攻城号令圣印"] = "攻城号令圣印",
    ["灵心之碎片"] = "灵心之碎片",
    ["克林姆德风纹法杖"] = "克林姆德风纹法杖",
    ["神风护体披风"] = "神风护体披风",
    ["湮灭之风戒指"] = "湮灭之风戒指",
    ["卡瑟拉深渊法典"] = "卡瑟拉深渊法典",
    ["电鳗共生指环"] = "电鳗共生指环",
    ["触手残片护符"] = "触手残片护符",
    ["墨潮行者长袍"] = "墨潮行者长袍",
    ["高压水脊法杖"] = "高压水脊法杖",
    ["绝缘珊瑚圣瓶"] = "绝缘珊瑚圣瓶",
    ["腐败根须法杖"] = "腐败根须法杖",
    ["古树之心护符"] = "古树之心护符",
    ["荆棘行者披风"] = "荆棘行者披风",
    ["净化者手套"] = "净化者手套",
    ["莫尔特斯树皮盾"] = "莫尔特斯树皮盾",
    ["腐朽孢子秘瓶"] = "腐朽孢子秘瓶",
    ["净土萌芽圣铃"] = "净土萌芽圣铃"
}
____exports["四Boss战利品装备名"] = {
    ["亡冥归魂巨剑"] = "亡冥归魂巨剑",
    ["最后阵地重铠"] = "最后阵地重铠",
    ["亡者凝视面甲"] = "亡者凝视面甲",
    ["英灵送葬法典"] = "英灵送葬法典",
    ["旧誓残响徽记"] = "旧誓残响徽记",
    ["安魂守墓灯"] = "安魂守墓灯",
    ["赤誓断界剑"] = "赤誓断界剑",
    ["裂誓战躯重铠"] = "裂誓战躯重铠",
    ["苍影校魂法典"] = "苍影校魂法典",
    ["无面记忆面纱"] = "无面记忆面纱",
    ["灵印折步靴"] = "灵印折步靴",
    ["双钥归一棱镜"] = "双钥归一棱镜",
    ["月白归静圣铃"] = "月白归静圣铃",
    ["超位魔法残章天空坠落"] = "超位魔法残章·天空坠落",
    ["光辉翠绿宝石"] = "光辉翠绿宝石",
    ["黑翼守护重盾"] = "黑翼守护重盾",
    ["滴管长枪投影"] = "滴管长枪投影",
    ["真祖女武神血铠"] = "真祖女武神血铠",
    ["英灵战乙女蔷薇镜"] = "英灵战乙女蔷薇镜"
}
____exports["四Boss装备特效"] = {
    ["归魂剑痕"] = "Common\\Effect\\Form\\Line\\AronkosSoulSlashVolley.mdx",
    ["英灵陨星预警"] = "Common\\Effect\\Form\\MagicCircle\\AronkosMeteorGraveRune.mdx",
    ["英灵陨星"] = "Common\\Effect\\Form\\RiseFall\\ElectricBlizzTarget2.mdx",
    ["英灵陨星落地"] = "Common\\Effect\\Form\\RiseFall\\AronkosMeteorImpactPillar.mdx",
    ["安魂范围"] = "Common\\Effect\\Form\\Aura\\AronkosGraveSoulField.mdx",
    ["安魂完成"] = "Common\\Effect\\Form\\RiseFall\\AronkosSoulReleasePillar.mdx",
    ["英魂出现"] = "Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx",
    ["英魂消散"] = "Common\\Effect\\Form\\RiseFall\\AronkosDefeatDissolve.mdx",
    ["誓盾"] = "Common\\Effect\\Form\\Shield\\AlbedoDarkGoldBarrier.mdx",
    ["镇魂印"] = "Common\\Effect\\Form\\MagicCircle\\SpiritGuardSoulSeal.mdx",
    ["月纹"] = "Common\\Effect\\Form\\Debuff\\SpiritGuardMoonBind.mdx",
    ["灵魂崩解"] = "Common\\Effect\\Form\\Debuff\\SpiritGuardSoulCollapse.mdx",
    ["魂力回灌"] = "Common\\Effect\\Form\\RiseFall\\SpiritGuardSoulReflux.mdx",
    ["净化反冲"] = "Common\\Effect\\Form\\Debuff\\SpiritGuardPurificationRecoil.mdx",
    ["天空法阵"] = "Common\\Effect\\Form\\MagicCircle\\AinzFallingSkyWarmGoldCircle.mdx",
    ["天空光柱"] = "Common\\Effect\\Form\\RiseFall\\AinzFallingSkyLaser.mdx",
    ["天空冲击"] = "Common\\Effect\\Form\\Explosion\\AinzFallingSkyImpact.mdx",
    ["翠绿护盾"] = "Common\\Effect\\Form\\Shield\\BigYellowOrbShield.mdx",
    ["黑翼拘束"] = "Common\\Effect\\Form\\Debuff\\AlbedoWingBind.mdx",
    ["黑翼屏障"] = "Common\\Effect\\Form\\Shield\\AlbedoDarkGoldBarrier.mdx",
    ["血滴"] = "Common\\Effect\\Form\\Debuff\\ShalltearBloodDropMark.mdx",
    ["血色冲击"] = "Common\\Effect\\Form\\Explosion\\ShalltearBloodMoonImpact.mdx",
    ["血晶球壳"] = "Common\\Effect\\Form\\RiseFall\\ShalltearBloodRebirthShell.mdx",
    ["血晶重构"] = "Common\\Effect\\Form\\RiseFall\\ShalltearBloodRebirthWeave.mdx",
    ["蔷薇镜缘"] = "Common\\Effect\\Form\\Illusion\\ShalltearRoseMirrorRim.mdx"
}
____exports["装备小特效"] = {["湿痕"] = "Common\\Effect\\Element\\Water\\WetShockMark.mdx", ["护盾闪光"] = "Common\\Effect\\Form\\Shield\\EquipmentShieldFlash.mdx", ["小风爆"] = "Common\\Effect\\Element\\Wind\\SmallWindBurst.mdx", ["根须"] = "Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl"}
____exports["装备伤害类型"] = {
    ["物理"] = DAMAGE_TYPE_NORMAL,
    ["魔法"] = DAMAGE_TYPE_MAGIC,
    ["闪电"] = DAMAGE_TYPE_LIGHTNING,
    ["水"] = DAMAGE_TYPE_COLD,
    ["暗影"] = DAMAGE_TYPE_SHADOW_STRIKE,
    ["自然"] = DAMAGE_TYPE_PLANT,
    ["风"] = DAMAGE_TYPE_PLANT
}
return ____exports
