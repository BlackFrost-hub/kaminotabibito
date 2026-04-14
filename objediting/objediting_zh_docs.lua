---@meta

--[[
ObjEditing 中文说明

这个文件只给 VSCode / Lua Language Server 提供中文悬停说明。
它不会被 ObjEditing.exe 执行。

你可以把它理解成两部分：
1. 常用类型 / 枚举值提示
2. SLK 字段名 -> ObjEditing 方法名 对照表

--------------------------------------------------
常见 SLK / YDWE 风格字段，对应 ObjEditing 写法
--------------------------------------------------

单位相关：
- obj.Name                  -> obj:setName('名字')
- obj.abilList              -> obj:setNormalAbilities('A001,A002')
- obj.Builds                -> obj:setStructuresBuilt('')
- obj.upgrades              -> obj:setUpgradesUsed('')
- obj.unitSound             -> obj:setUnitSoundSet('')
- obj.castbsw               -> obj:setAnimationCastBackswing(0.0)
- obj.movetp = "fly"        -> obj:setMovementType(MovementType.Fly)
- obj.type = "ancient"      -> obj:setUnitClassification('ancient')
- obj.regenType = "always"  -> obj:setHitPointsRegenerationType('always')
- obj.manaN                 -> obj:setManaMaximum(10000)
- obj.regenMana             -> obj:setManaRegeneration(1000.0)
- obj.mana0                 -> obj:setManaInitialAmount(1000)
- obj.fused = 0             -> obj:setFoodProduced(0)
- obj.HP                    -> obj:setHitPointsMaximumBase(10000)
- obj.regenHP               -> obj:setHitPointsRegenerationRate(100.0)
- obj.hideOnMinimap = 1     -> obj:setHideMinimapDisplay(true)
- obj.sight                 -> obj:setSightRadiusDay(0)
- obj.nsight                -> obj:setSightRadiusNight(0)
- obj.turnRate              -> obj:setTurnRate(3.0)
- obj.propWin               -> obj:setPropulsionWindowdegrees(360.0)
- obj.file                  -> obj:setModelFile('xxx.mdl')
- obj.collision             -> obj:setCollisionSize(0.0)

技能相关：
- abil.Name                 -> abil:setName('名字')
- abil.levels               -> abil:setLevels(1)
- abil.Cool                 -> abil:setCooldown(1, 0)
- abil.Cost                 -> abil:setManaCost(1, 0)
- abil.Rng                  -> abil:setCastRange(1, 999999)
- abil.Dur1                 -> abil:setDurationNormal(1, 1)
- abil.HeroDur1             -> abil:setDurationHero(1, 1)
- abil.Requires             -> abil:setRequirements('')
- abil.targs1               -> abil:setTargetsAllowed(1, 'ground,air')
- abil.BuffID1              -> abil:setBuffs(1, 'Bfrz')
- abil.Missileart           -> abil:setMissileArt('')
- abil.Missilespeed         -> abil:setMissileSpeed(0)
- abil.Animnames            -> abil:setAnimationNames('')

特别提醒：
- `setUnitClassification` 现在看起来是字符串，不是布尔，不要写 `true/false`。
- `setHitPointsRegenerationType` 现在看起来是字符串，不是枚举对象。
- `setBuffs` 当前签名是 `(level, rawId)`。
- `setMovementType` 需要枚举值，常用写法是 `MovementType.Fly`。
]]

---@class Race
Race = {}

---@type any 平民
Race.Commoner = nil
---@type any 中立敌对
Race.Creeps = nil
---@type any 小动物
Race.Critters = nil
---@type any 恶魔
Race.Demon = nil
---@type any 人族
Race.Human = nil
---@type any 娜迦
Race.Naga = nil
---@type any 暗夜精灵
Race.Nightelf = nil
---@type any 兽族
Race.Orc = nil
---@type any 其他
Race.Other = nil
---@type any 不死族
Race.Undead = nil
---@type any 未知
Race.Unknown = nil

---@class MovementType
MovementType = {}

---@type any 步行
MovementType.Foot = nil
---@type any 骑乘
MovementType.Horse = nil
---@type any 飞行
MovementType.Fly = nil
---@type any 悬浮
MovementType.Hover = nil
---@type any 漂浮
MovementType.Float = nil
---@type any 两栖
MovementType.Amphipic = nil

---@class ArmorType
ArmorType = {}

---@type any 普通
ArmorType.Normal = nil
---@type any 轻甲
ArmorType.Small = nil
---@type any 中甲
ArmorType.Medium = nil
---@type any 重甲
ArmorType.Large = nil
---@type any 城甲
ArmorType.Fortified = nil
---@type any 英雄甲
ArmorType.Hero = nil
---@type any 神圣甲
ArmorType.Divine = nil
---@type any 无甲
ArmorType.Unarmored = nil

---@class AttackType
AttackType = {}

---@type any 穿刺
AttackType.Pierce = nil
---@type any 攻城
AttackType.Siege = nil
---@type any 法术
AttackType.Spells = nil
---@type any 混乱
AttackType.Chaos = nil
---@type any 魔法
AttackType.Magic = nil

---@class WeaponType
WeaponType = {}

---@type any 瞬发
WeaponType.Instant = nil
---@type any 投石
WeaponType.Artillery = nil
---@type any 线性投石
WeaponType.ArtilleryLine = nil
---@type any 导弹
WeaponType.Missile = nil
---@type any 溅射导弹
WeaponType.MissileSplash = nil
---@type any 反弹导弹
WeaponType.MissileBounce = nil
---@type any 线性导弹
WeaponType.MissileLine = nil
---@type any 无
WeaponType.None = nil

---@class WeaponSound
WeaponSound = {}

---@type any 无声
WeaponSound.Nothing = nil
---@type any 斧中砍击
WeaponSound.AxeMediumChop = nil
---@type any 金属重砸
WeaponSound.MetalHeavyBash = nil
---@type any 金属重砍
WeaponSound.MetalHeavyChop = nil
---@type any 金属重切
WeaponSound.MetalHeavySlice = nil
---@type any 金属轻砍
WeaponSound.MetalLightChop = nil
---@type any 金属轻切
WeaponSound.MetalLightSlice = nil
---@type any 金属中砸
WeaponSound.MetalMediumBash = nil
---@type any 金属中砍
WeaponSound.MetalMediumChop = nil
---@type any 金属中切
WeaponSound.MetalMediumSlice = nil
---@type any 石头重砸
WeaponSound.RockHeavyBash = nil
---@type any 木头重砸
WeaponSound.WoodHeavyBash = nil
---@type any 木头轻砸
WeaponSound.WoodLightBash = nil
---@type any 木头中砸

-- Split docs index:
--   objediting_zh_docs_units.lua
--   objediting_zh_docs_abilities.lua
