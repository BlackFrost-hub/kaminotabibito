---@meta

--[[
ObjEditing 技能说明模块（精简版）

这份文件只保留：
1. 通用技能基类 `AbilityDefinition`
2. 当前项目 `objediting/main.lua` 实际用到的技能类

这样可以把体积压下来，同时保留中文悬停说明。
]]

---@class AbilityDefinition
AbilityDefinition = {}

---@param ... any 通用构造参数
---@return AbilityDefinition
function AbilityDefinition:new(...) end

---@param value string 技能名称
function AbilityDefinition:setName(value) end

---@param value string 编辑器后缀
function AbilityDefinition:setEditorSuffix(value) end

---@param value boolean 是否为英雄技能
function AbilityDefinition:setHeroAbility(value) end

---@param value boolean 是否为物品技能
function AbilityDefinition:setItemAbility(value) end

---@param value any 种族，常用 `Race.Other`
function AbilityDefinition:setRace(value) end

---@param value integer 普通按钮 X
function AbilityDefinition:setButtonPositionNormalX(value) end

---@param value integer 普通按钮 Y
function AbilityDefinition:setButtonPositionNormalY(value) end

---@param value integer 关闭按钮 X
function AbilityDefinition:setButtonPositionTurnOffX(value) end

---@param value integer 关闭按钮 Y
function AbilityDefinition:setButtonPositionTurnOffY(value) end

---@param value integer 研究按钮 X
function AbilityDefinition:setButtonPositionResearchX(value) end

---@param value integer 研究按钮 Y
function AbilityDefinition:setButtonPositionResearchY(value) end

---@param value string 普通图标路径
function AbilityDefinition:setIconNormal(value) end

---@param value string 关闭图标路径
function AbilityDefinition:setIconTurnOff(value) end

---@param value string 研究图标路径
function AbilityDefinition:setIconResearch(value) end

---@param value string 施法者特效
function AbilityDefinition:setArtCaster(value) end

---@param value string 目标特效
function AbilityDefinition:setArtTarget(value) end

---@param value string 特殊特效
function AbilityDefinition:setArtSpecial(value) end

---@param value string 效果特效
function AbilityDefinition:setArtEffect(value) end

---@param value string 范围特效
function AbilityDefinition:setAreaEffect(value) end

---@param value string 闪电效果
function AbilityDefinition:setLightningEffects(value) end

---@param value string 弹道模型路径
function AbilityDefinition:setMissileArt(value) end

---@param value number 弹道速度
function AbilityDefinition:setMissileSpeed(value) end

---@param value number 弹道弧度
function AbilityDefinition:setMissileArc(value) end

---@param value boolean 是否追踪弹道
function AbilityDefinition:setMissileHomingEnabled(value) end

---@param value string 目标附着列表
function AbilityDefinition:setTargetAttachments(value) end

---@param value string 目标附着点
function AbilityDefinition:setTargetAttachmentPoint(value) end

---@param value string 施法者附着列表
function AbilityDefinition:setCasterAttachments(value) end

---@param value string 施法者附着点
function AbilityDefinition:setCasterAttachmentPoint(value) end

---@param value string 施法者附着点 1
function AbilityDefinition:setCasterAttachmentPoint1(value) end

---@param value string 特殊附着点
function AbilityDefinition:setSpecialAttachmentPoint(value) end

---@param value string 动画名，例如 `'spell,slam'`
function AbilityDefinition:setAnimationNames(value) end

---@param value string 普通提示文本
function AbilityDefinition:setTooltipNormal(value) end

---@param value string 普通扩展提示
function AbilityDefinition:setTooltipNormalExtended(value) end

---@param value string 关闭提示文本
function AbilityDefinition:setTooltipTurnOff(value) end

---@param value string 关闭扩展提示
function AbilityDefinition:setTooltipTurnOffExtended(value) end

---@param value string 学习提示文本
function AbilityDefinition:setTooltipLearn(value) end

---@param value string 学习扩展提示
function AbilityDefinition:setTooltipLearnExtended(value) end

---@param value string 学习热键
function AbilityDefinition:setHotkeyLearn(value) end

---@param value string 普通热键
function AbilityDefinition:setHotkeyNormal(value) end

---@param value string 关闭热键
function AbilityDefinition:setHotkeyTurnOff(value) end

---@param value integer 技能等级数
function AbilityDefinition:setLevels(value) end

---@param value integer 需要英雄等级
function AbilityDefinition:setRequiredLevel(value) end

---@param value integer 跳级需求
function AbilityDefinition:setLevelSkipRequirement(value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 冷却时间
function AbilityDefinition:setCooldown(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 魔法消耗
function AbilityDefinition:setManaCost(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 施法距离
function AbilityDefinition:setCastRange(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 普通单位持续时间
function AbilityDefinition:setDurationNormal(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 英雄持续时间
function AbilityDefinition:setDurationHero(level, value) end

---@param value string 科技需求，留空可写 `''`
function AbilityDefinition:setRequirements(value) end

---@param value string 科技等级需求
function AbilityDefinition:setRequirementsLevels(value) end

---@param value boolean 是否检查依赖
function AbilityDefinition:setCheckDependencies(value) end

---@param value integer 法术偷取优先级
function AbilityDefinition:setPriorityforSpellSteal(value) end

---@param value string 开启命令串
function AbilityDefinition:setOrderStringUseTurnOn(value) end

---@param value string 关闭命令串
function AbilityDefinition:setOrderStringTurnOff(value) end

---@param value string 激活命令串
function AbilityDefinition:setOrderStringActivate(value) end

---@param value string 取消激活命令串
function AbilityDefinition:setOrderStringDeactivate(value) end

---@param value string 效果音效
function AbilityDefinition:setEffectSound(value) end

---@param value string 持续效果音效
function AbilityDefinition:setEffectSoundLooping(value) end

---@param level integer 技能等级，常用填 `1`
---@param value string 允许目标，例如 `'ground,air'`
function AbilityDefinition:setTargetsAllowed(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 施法时间
function AbilityDefinition:setCastingTime(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 范围
function AbilityDefinition:setAreaofEffect(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value string Buff 原始 ID，例如 `'Bfrz'`
function AbilityDefinition:setBuffs(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value string 效果原始 ID 列表
function AbilityDefinition:setEffects(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value boolean 是否隐藏按钮
function AbilityDefinition:setHideButton(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 力量加成
function AbilityDefinition:setStrengthBonus(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 敏捷加成
function AbilityDefinition:setAgilityBonus(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 智力加成
function AbilityDefinition:setIntelligenceBonus(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 攻击力加成
function AbilityDefinition:setAttackBonus(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 护甲加成
function AbilityDefinition:setDefenseBonus(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 移动速度加成
function AbilityDefinition:setMovementSpeedBonus(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 攻击速度加成
function AbilityDefinition:setAttackSpeedIncrease(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 移速倍率
function AbilityDefinition:setMovementSpeedFactor(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 攻速倍率
function AbilityDefinition:setAttackSpeedFactor(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 丢失命中率
function AbilityDefinition:setChanceToMiss(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 禁止攻击类型
function AbilityDefinition:setAttacksPrevented(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 最大可作用野怪等级
function AbilityDefinition:setMaximumCreepLevel(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 直接伤害
function AbilityDefinition:setDamageAmount(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 实际伤害
function AbilityDefinition:setDamageDealt(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 每秒伤害
function AbilityDefinition:setDamageperSecond(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 额外伤害
function AbilityDefinition:setDamageBonus(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value string 召唤单位原始 ID
function AbilityDefinition:setSummonedUnitType(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 召唤数量
function AbilityDefinition:setSummonedUnitCount(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 回复生命值
function AbilityDefinition:setHitPointsGained(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 回复魔法值
function AbilityDefinition:setManaPointsGained(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 生命恢复速度
function AbilityDefinition:setLifeRegenerationRate(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 魔法恢复速度
function AbilityDefinition:setManaRegen(level, value) end

---@param value boolean 是否可手动关闭
function AbilityDefinition:setCanDeactivate(value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 全伤半径
function AbilityDefinition:setFullDamageRadius(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 半伤半径
function AbilityDefinition:setHalfDamageRadius(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 全伤害值
function AbilityDefinition:setFullDamageAmount(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 部分伤害值
function AbilityDefinition:setPartialDamageAmount(level, value) end

---@param level integer 技能等级，常用填 `1`
---@param value number 部分伤害半径
function AbilityDefinition:setPartialDamageRadius(level, value) end

---攻击力加成模板
---@class AbilityDefinitionAttackBonusPlus1: AbilityDefinition
AbilityDefinitionAttackBonusPlus1 = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionAttackBonusPlus1
function AbilityDefinitionAttackBonusPlus1:new(newId) end

---护甲加成模板
---@class AbilityDefinitionDefenseBonusPlus1: AbilityDefinition
AbilityDefinitionDefenseBonusPlus1 = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionDefenseBonusPlus1
function AbilityDefinitionDefenseBonusPlus1:new(newId) end

---属性加成模板
---@class AbilityDefinitionAttributeModifierSkill: AbilityDefinition
AbilityDefinitionAttributeModifierSkill = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionAttributeModifierSkill
function AbilityDefinitionAttributeModifierSkill:new(newId) end

---移速加成模板
---@class AbilityDefinitionMoveSpeedBonus: AbilityDefinition
AbilityDefinitionMoveSpeedBonus = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionMoveSpeedBonus
function AbilityDefinitionMoveSpeedBonus:new(newId) end

---攻速加成模板
---@class AbilityDefinitionAttackSpeedIncrease: AbilityDefinition
AbilityDefinitionAttackSpeedIncrease = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionAttackSpeedIncrease
function AbilityDefinitionAttackSpeedIncrease:new(newId) end

---变羊模板
---@class AbilityDefinitionPolymorph: AbilityDefinition
AbilityDefinitionPolymorph = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionPolymorph
function AbilityDefinitionPolymorph:new(newId) end

---山丘之王风暴之锤模板，这里常被拿来做“击晕”壳子
---@class AbilityDefinitionMountainKingThunderBolt: AbilityDefinition
AbilityDefinitionMountainKingThunderBolt = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionMountainKingThunderBolt
function AbilityDefinitionMountainKingThunderBolt:new(newId) end

---@param level number 技能等级
---@param value number 伤害值
function AbilityDefinitionMountainKingThunderBolt:setDamage(level, value) end

---隐形模板
---@class AbilityDefinitionInvisibility: AbilityDefinition
AbilityDefinitionInvisibility = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionInvisibility
function AbilityDefinitionInvisibility:new(newId) end

---中立单位雷击模板，这里常拿来挂冰冻 Buff
---@class AbilityDefinitionThunderBoltCreep: AbilityDefinition
AbilityDefinitionThunderBoltCreep = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionThunderBoltCreep
function AbilityDefinitionThunderBoltCreep:new(newId) end

---@param level number 技能等级
---@param value number 伤害值
function AbilityDefinitionThunderBoltCreep:setDamage(level, value) end

---减速模板
---@class AbilityDefinitionSlow: AbilityDefinition
AbilityDefinitionSlow = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionSlow
function AbilityDefinitionSlow:new(newId) end

---沉默模板
---@class AbilityDefinitionSilenceCreep: AbilityDefinition
AbilityDefinitionSilenceCreep = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionSilenceCreep
function AbilityDefinitionSilenceCreep:new(newId) end

---重击模板
---@class AbilityDefinitionBash: AbilityDefinition
AbilityDefinitionBash = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionBash
function AbilityDefinitionBash:new(newId) end

---闪电链模板
---@class AbilityDefinitionChainLightning: AbilityDefinition
AbilityDefinitionChainLightning = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionChainLightning
function AbilityDefinitionChainLightning:new(newId) end

---暴击模板
---@class AbilityDefinitionCriticalStrike: AbilityDefinition
AbilityDefinitionCriticalStrike = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionCriticalStrike
function AbilityDefinitionCriticalStrike:new(newId) end

---闪避模板
---@class AbilityDefinitionEvasion: AbilityDefinition
AbilityDefinitionEvasion = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionEvasion
function AbilityDefinitionEvasion:new(newId) end

---冰霜新星模板
---@class AbilityDefinitionFrostNova: AbilityDefinition
AbilityDefinitionFrostNova = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionFrostNova
function AbilityDefinitionFrostNova:new(newId) end

---治疗守卫模板
---@class AbilityDefinitionHealingWard: AbilityDefinition
AbilityDefinitionHealingWard = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionHealingWard
function AbilityDefinitionHealingWard:new(newId) end

---献祭模板
---@class AbilityDefinitionImmolation: AbilityDefinition
AbilityDefinitionImmolation = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionImmolation
function AbilityDefinitionImmolation:new(newId) end

---心灵之火模板
---@class AbilityDefinitionInnerFire: AbilityDefinition
AbilityDefinitionInnerFire = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionInnerFire
function AbilityDefinitionInnerFire:new(newId) end

---@param level integer
---@param value number 攻击力提升
function AbilityDefinitionInnerFire:setDamageIncrease(level, value) end

---@param level integer
---@param value integer 护甲提升
function AbilityDefinitionInnerFire:setDefenseIncrease(level, value) end

---@param level integer
---@param value number 生命恢复
function AbilityDefinitionInnerFire:setLifeRegenRate(level, value) end

---嗜血术模板
---@class AbilityDefinitionBloodlust: AbilityDefinition
AbilityDefinitionBloodlust = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionBloodlust
function AbilityDefinitionBloodlust:new(newId) end

---@param level integer
---@param value number 攻速提升
function AbilityDefinitionBloodlust:setAttackSpeedIncrease(level, value) end

---@param level integer
---@param value number 移速提升
function AbilityDefinitionBloodlust:setMovementSpeedIncrease(level, value) end

---@param level integer
---@param value number 缩放倍率
function AbilityDefinitionBloodlust:setScalingFactor(level, value) end

---残废模板
---@class AbilityDefinitionCripple: AbilityDefinition
AbilityDefinitionCripple = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionCripple
function AbilityDefinitionCripple:new(newId) end

---@param level integer
---@param value number 移速降低
function AbilityDefinitionCripple:setMovementSpeedReduction(level, value) end

---@param level integer
---@param value number 攻速降低
function AbilityDefinitionCripple:setAttackSpeedReduction(level, value) end

---@param level integer
---@param value number 伤害降低
function AbilityDefinitionCripple:setDamageReduction(level, value) end

---精灵之火模板
---@class AbilityDefinitionFaerieFire: AbilityDefinition
AbilityDefinitionFaerieFire = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionFaerieFire
function AbilityDefinitionFaerieFire:new(newId) end

---@param level integer
---@param value integer 护甲降低
function AbilityDefinitionFaerieFire:setDefenseReduction(level, value) end

---@param level integer
---@param value boolean 是否自动施放
function AbilityDefinitionFaerieFire:setAlwaysAutocast(level, value) end

---诅咒模板
---@class AbilityDefinitionCurse: AbilityDefinition
AbilityDefinitionCurse = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionCurse
function AbilityDefinitionCurse:new(newId) end

---@param level integer
---@param value number 丢失概率
function AbilityDefinitionCurse:setChancetoMiss(level, value) end

---睡眠模板
---@class AbilityDefinitionDreadlordSleep: AbilityDefinition
AbilityDefinitionDreadlordSleep = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionDreadlordSleep
function AbilityDefinitionDreadlordSleep:new(newId) end

---@param level integer
---@param value number 昏迷持续时间
function AbilityDefinitionDreadlordSleep:setStunDuration(level, value) end

---纠缠根须模板
---@class AbilityDefinitionEntanglingRootscreep: AbilityDefinition
AbilityDefinitionEntanglingRootscreep = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionEntanglingRootscreep
function AbilityDefinitionEntanglingRootscreep:new(newId) end

---@param level integer
---@param value number 每秒伤害
function AbilityDefinitionEntanglingRootscreep:setDamageperSecond(level, value) end

---飓风模板
---@class AbilityDefinitionCyclone: AbilityDefinition
AbilityDefinitionCyclone = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionCyclone
function AbilityDefinitionCyclone:new(newId) end

---@param level integer
---@param value boolean 是否可驱散
function AbilityDefinitionCyclone:setCanBeDispelled(level, value) end

---法力护盾模板
---@class AbilityDefinitionManaShield: AbilityDefinition
AbilityDefinitionManaShield = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionManaShield
function AbilityDefinitionManaShield:new(newId) end

---通魔/控制魔法常用模板
---@class AbilityDefinitionControlMagic: AbilityDefinition
AbilityDefinitionControlMagic = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionControlMagic
function AbilityDefinitionControlMagic:new(newId) end

---吸魔模板
---@class AbilityDefinitionAbsorbMana: AbilityDefinition
AbilityDefinitionAbsorbMana = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionAbsorbMana
function AbilityDefinitionAbsorbMana:new(newId) end

---法力燃烧模板
---@class AbilityDefinitionDemonHunterManaBurn: AbilityDefinition
AbilityDefinitionDemonHunterManaBurn = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionDemonHunterManaBurn
function AbilityDefinitionDemonHunterManaBurn:new(newId) end

---法力虹吸模板
---@class AbilityDefinitionBloodMageSiphonMana: AbilityDefinition
AbilityDefinitionBloodMageSiphonMana = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionBloodMageSiphonMana
function AbilityDefinitionBloodMageSiphonMana:new(newId) end

---驱散魔法模板
---@class AbilityDefinitionDispelMagic: AbilityDefinition
AbilityDefinitionDispelMagic = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionDispelMagic
function AbilityDefinitionDispelMagic:new(newId) end

---偷魔模板
---@class AbilityDefinitionManaSteal: AbilityDefinition
AbilityDefinitionManaSteal = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionManaSteal
function AbilityDefinitionManaSteal:new(newId) end

---咆哮模板
---@class AbilityDefinitionRoar: AbilityDefinition
AbilityDefinitionRoar = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionRoar
function AbilityDefinitionRoar:new(newId) end

---战争践踏模板
---@class AbilityDefinitionWarStomp: AbilityDefinition
AbilityDefinitionWarStomp = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionWarStomp
function AbilityDefinitionWarStomp:new(newId) end

---疾风步模板
---@class AbilityDefinitionWindWalk: AbilityDefinition
AbilityDefinitionWindWalk = {}

---@param newId string 4 字符新技能原始 ID
---@return AbilityDefinitionWindWalk
function AbilityDefinitionWindWalk:new(newId) end
