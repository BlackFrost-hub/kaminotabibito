---@meta

--[[
ObjEditing 单位说明模块（精简版）

目标：
1. 保留中文悬停说明，方便直接看懂常用字段。
2. 只保留通用单位 API，不再追求全量对象字段。
3. 当前项目如果只做单位物编，这一份通常已经够用。
]]

---@class ObjEditingUnitBase
local ObjEditingUnitBase = {}

---@param value string 编辑器里显示的单位名称
function ObjEditingUnitBase:setName(value) end

---@param value string 基础提示文本
function ObjEditingUnitBase:setTooltipBasic(value) end

---@param value string 扩展提示文本
function ObjEditingUnitBase:setTooltipExtended(value) end

---@param value string 编辑器描述
function ObjEditingUnitBase:setDescription(value) end

---@param value string 游戏界面图标路径，对应物编字段 `uico`
---真实定义可在 `.def/def/UnitOrBuildingOrHeroDefinition.lua` 中查 `setIconGameInterface`
function ObjEditingUnitBase:setIconGameInterface(value) end

---@param value string 热键，例如 `'Q'`
function ObjEditingUnitBase:setHotkey(value) end

---@param value integer 按钮 X 坐标
function ObjEditingUnitBase:setButtonPositionX(value) end

---@param value integer 按钮 Y 坐标
function ObjEditingUnitBase:setButtonPositionY(value) end

---@param value any 种族，常用 `Race.Other`
function ObjEditingUnitBase:setRace(value) end

---@param value string 普通技能列表，例如 `'Aloc,AInv'`
function ObjEditingUnitBase:setNormalAbilities(value) end

---@param value string 可建造单位列表
function ObjEditingUnitBase:setStructuresBuilt(value) end

---@param value string 可使用升级列表
function ObjEditingUnitBase:setUpgradesUsed(value) end

---@param value string 音效集，留空可写 `''`
function ObjEditingUnitBase:setUnitSoundSet(value) end

---@param value string 单位分类字符串，例如 `'ancient'`
function ObjEditingUnitBase:setUnitClassification(value) end

---@param value number 施法后摇时间
function ObjEditingUnitBase:setAnimationCastBackswing(value) end

---@param value number 施法前摇时间
function ObjEditingUnitBase:setAnimationCastPoint(value) end

---@param value number 行走动画速度
function ObjEditingUnitBase:setAnimationWalkSpeed(value) end

---@param value number 跑步动画速度
function ObjEditingUnitBase:setAnimationRunSpeed(value) end

---@param value number 动画混合时间
function ObjEditingUnitBase:setAnimationBlendTimeseconds(value) end

---@param value any 移动类型，常用 `MovementType.Fly`
function ObjEditingUnitBase:setMovementType(value) end

---@param value string 移动音效
function ObjEditingUnitBase:setMovementSound(value) end

---@param value number 最低飞行高度
function ObjEditingUnitBase:setMovementHeightMinimum(value) end

---@param value number 飞行高度
function ObjEditingUnitBase:setMovementHeight(value) end

---@param value number 转身速度
function ObjEditingUnitBase:setTurnRate(value) end

---@param value number 转向窗口角度
function ObjEditingUnitBase:setPropulsionWindowdegrees(value) end

---@param value integer 基础移动速度
function ObjEditingUnitBase:setSpeedBase(value) end

---@param value integer 最小移动速度
function ObjEditingUnitBase:setSpeedMinimum(value) end

---@param value integer 最大移动速度
function ObjEditingUnitBase:setSpeedMaximum(value) end

---@param value number 最大魔法值
function ObjEditingUnitBase:setManaMaximum(value) end

---@param value number 魔法恢复速度
function ObjEditingUnitBase:setManaRegeneration(value) end

---@param value number 初始魔法值
function ObjEditingUnitBase:setManaInitialAmount(value) end

---@param value number 最大生命值
function ObjEditingUnitBase:setHitPointsMaximumBase(value) end

---@param value string 生命恢复类型，例如 `'always'`
function ObjEditingUnitBase:setHitPointsRegenerationType(value) end

---@param value number 生命恢复速度
function ObjEditingUnitBase:setHitPointsRegenerationRate(value) end

---@param value integer 提供人口
function ObjEditingUnitBase:setFoodProduced(value) end

---@param value integer 消耗人口
function ObjEditingUnitBase:setFoodCost(value) end

---@param value integer 金币花费
function ObjEditingUnitBase:setGoldCost(value) end

---@param value integer 木材花费
function ObjEditingUnitBase:setLumberCost(value) end

---@param value integer 建造时间
function ObjEditingUnitBase:setBuildTime(value) end

---@param value number 碰撞体积
function ObjEditingUnitBase:setCollisionSize(value) end

---@param value string 模型路径，例如 `'units\\nightelf\\Wisp\\Wisp.mdl'`
function ObjEditingUnitBase:setModelFile(value) end

---@param value string 模型文件额外版本，例如 `'0'`
function ObjEditingUnitBase:setModelFileExtraVersions(value) end

---@param value string 特殊效果模型路径
function ObjEditingUnitBase:setSpecial(value) end

---@param value number 模型缩放
function ObjEditingUnitBase:setScalingValue(value) end

---@param value number 白天视野
function ObjEditingUnitBase:setSightRadiusDay(value) end

---@param value number 夜晚视野
function ObjEditingUnitBase:setSightRadiusNight(value) end

---@param value boolean 是否隐藏小地图显示
function ObjEditingUnitBase:setHideMinimapDisplay(value) end

---@param value boolean 是否可逃跑
function ObjEditingUnitBase:setCanFlee(value) end

---@param value integer 点数
function ObjEditingUnitBase:setPointValue(value) end

---@param value integer 单位等级
function ObjEditingUnitBase:setLevel(value) end

---@param value integer 优先级
function ObjEditingUnitBase:setPriority(value) end

---@param value number 索敌范围
function ObjEditingUnitBase:setAcquisitionRange(value) end

---@param value string 目标分类，例如 `'ground,air'`
function ObjEditingUnitBase:setTargetedAs(value) end

---@param value number 基础护甲
function ObjEditingUnitBase:setDefenseBase(value) end

---@param value number 护甲升级加成
function ObjEditingUnitBase:setDefenseUpgradeBonus(value) end

---@param value any 护甲类型，例如 `ArmorType.Divine`
function ObjEditingUnitBase:setArmorType(value) end

---@param value any 启用哪些攻击，例如 `AttacksEnabled.AttackOneOnly`
function ObjEditingUnitBase:setAttacksEnabled(value) end

---@param value string 死亡类型
function ObjEditingUnitBase:setDeathType(value) end

---@param value number 选择圈缩放
function ObjEditingUnitBase:setSelectionScale(value) end

---@param value number 选择圈高度
function ObjEditingUnitBase:setSelectionCircleHeight(value) end

---@param value boolean 选择圈是否显示在水面
function ObjEditingUnitBase:setSelectionCircleOnWater(value) end

---@param value boolean 是否缩放投射物
function ObjEditingUnitBase:setScaleProjectiles(value) end

---@param value number 染色红色值 (0-255)
function ObjEditingUnitBase:setTintingColorRed(value) end

---@param value number 染色绿色值 (0-255)
function ObjEditingUnitBase:setTintingColorGreen(value) end

---@param value number 染色蓝色值 (0-255)
function ObjEditingUnitBase:setTintingColorBlue(value) end

---@param value number 投射物发射 Z
function ObjEditingUnitBase:setProjectileLaunchZ(value) end

---@param value number 投射物命中 Z
function ObjEditingUnitBase:setProjectileImpactZ(value) end

---@param value number 是否允许自定义队伍颜色 (0/1)
function ObjEditingUnitBase:setAllowCustomTeamColor(value) end

---@param value number 队伍颜色 (-1=无, 0-11=玩家颜色)
function ObjEditingUnitBase:setTeamColor(value) end

---@param value string 出售物品列表
function ObjEditingUnitBase:setItemsSold(value) end

---@param value string 出售单位列表
function ObjEditingUnitBase:setUnitsSold(value) end

---@param value integer 商店库存上限
function ObjEditingUnitBase:setStockMaximum(value) end

---@param value integer 库存开始延迟
function ObjEditingUnitBase:setStockStartDelay(value) end

---@param value integer 库存补货间隔
function ObjEditingUnitBase:setStockReplenishInterval(value) end

---@param value integer 修理时间
function ObjEditingUnitBase:setRepairTime(value) end

---@param value integer 修理金币消耗
function ObjEditingUnitBase:setRepairGoldCost(value) end

---@param value integer 修理木材消耗
function ObjEditingUnitBase:setRepairLumberCost(value) end

---@param value integer 金币奖励基础值
function ObjEditingUnitBase:setGoldBountyAwardedBase(value) end

---@param value integer 金币奖励骰子数
function ObjEditingUnitBase:setGoldBountyAwardedNumberofDice(value) end

---@param value integer 金币奖励骰面
function ObjEditingUnitBase:setGoldBountyAwardedSidesperDie(value) end

---@param value integer 木材奖励基础值
function ObjEditingUnitBase:setLumberBountyAwardedBase(value) end

---@param value integer 木材奖励骰子数
function ObjEditingUnitBase:setLumberBountyAwardedNumberofDice(value) end

---@param value integer 木材奖励骰面
function ObjEditingUnitBase:setLumberBountyAwardedSidesperDie(value) end

---@param value integer 高度采样点数
function ObjEditingUnitBase:setElevationSamplePoints(value) end

---@param value number 高度采样半径
function ObjEditingUnitBase:setElevationSampleRadius(value) end

---@param value number 战争迷雾采样半径
function ObjEditingUnitBase:setFogOfWarSampleRadius(value) end

---@param value number 死亡时间
function ObjEditingUnitBase:setDeathTimeseconds(value) end

---@param value integer 编队优先级
function ObjEditingUnitBase:setFormationRank(value) end

---@param value string 可训练单位列表
function ObjEditingUnitBase:setUnitsTrained(value) end

---@param value string 可升级到的单位列表
function ObjEditingUnitBase:setUpgradesTo(value) end

---@param value string 英雄技能列表
function ObjEditingUnitBase:setHeroAbilities(value) end

---@param value string 主属性，例如 `'STR'`
function ObjEditingUnitBase:setPrimaryAttribute(value) end

---@param value number 初始力量
function ObjEditingUnitBase:setStartingStrength(value) end

---@param value number 初始敏捷
function ObjEditingUnitBase:setStartingAgility(value) end

---@param value number 初始智力
function ObjEditingUnitBase:setStartingIntelligence(value) end

---@param value number 每级力量成长
function ObjEditingUnitBase:setStrengthPerLevel(value) end

---@param value number 每级敏捷成长
function ObjEditingUnitBase:setAgilityPerLevel(value) end

---@param value number 每级智力成长
function ObjEditingUnitBase:setIntelligencePerLevel(value) end

---@param level integer 攻击索引，常用填 `1`
---@param value number 攻击后摇
function ObjEditingUnitBase:setAttack1AnimationBackswingPoint(level, value) end

---@param level integer 攻击索引，常用填 `1`
---@param value number 攻击伤害点
function ObjEditingUnitBase:setAttack1AnimationDamagePoint(level, value) end

---@param level integer 攻击索引，常用填 `1`
---@param value number 攻击冷却
function ObjEditingUnitBase:setAttack1CooldownTime(level, value) end

---@param level integer 攻击索引，常用填 `1`
---@param value any 攻击类型，例如 `AttackType.Magic`
function ObjEditingUnitBase:setAttack1AttackType(level, value) end

---@param level integer 攻击索引，常用填 `1`
---@param value integer 基础伤害
function ObjEditingUnitBase:setAttack1DamageBase(level, value) end

---@param level integer 攻击索引，常用填 `1`
---@param value integer 骰子数
function ObjEditingUnitBase:setAttack1DamageNumberofDice(level, value) end

---@param level integer 攻击索引，常用填 `1`
---@param value integer 骰面
function ObjEditingUnitBase:setAttack1DamageSidesperDie(level, value) end

---@param level integer 攻击索引，常用填 `1`
---@param value integer 弹道速度
function ObjEditingUnitBase:setAttack1ProjectileSpeed(level, value) end

---@param level integer 攻击索引，常用填 `1`
---@param value number 攻击距离
function ObjEditingUnitBase:setAttack1Range(level, value) end

---@param level integer 攻击索引，常用填 `1`
---@param value string 允许目标，例如 `'ground,air'`
function ObjEditingUnitBase:setAttack1TargetsAllowed(level, value) end

---@param level integer 攻击索引，常用填 `1`
---@param value any 武器音效，例如 `WeaponSound.Nothing`
function ObjEditingUnitBase:setAttack1WeaponSound(level, value) end

---@param level integer 攻击索引，常用填 `1`
---@param value any 武器类型，例如 `WeaponType.Instant`
function ObjEditingUnitBase:setAttack1WeaponType(level, value) end

---@class UnitDefinition: ObjEditingUnitBase
UnitDefinition = {}

---@param newId string 4 字符新单位原始 ID，例如 `'bHun'`
---@param baseId string 4 字符母单位原始 ID，例如 `'ewsp'`
---@return UnitDefinition
function UnitDefinition:new(newId, baseId) end

---@class HeroDefinition: ObjEditingUnitBase
HeroDefinition = {}

---@param newId string 4 字符新英雄原始 ID
---@param baseId string 4 字符母英雄原始 ID
---@return HeroDefinition
function HeroDefinition:new(newId, baseId) end

---@class BuildingDefinition: ObjEditingUnitBase
BuildingDefinition = {}

---@param newId string 4 字符新建筑原始 ID
---@param baseId string 4 字符母建筑原始 ID
---@return BuildingDefinition
function BuildingDefinition:new(newId, baseId) end

---@class BuildingAndHeroDefinition: ObjEditingUnitBase
BuildingAndHeroDefinition = {}

---@param newId string 4 字符新对象原始 ID
---@param baseId string 4 字符母对象原始 ID
---@return BuildingAndHeroDefinition
function BuildingAndHeroDefinition:new(newId, baseId) end

---@class UnitOrHeroDefinition: ObjEditingUnitBase
UnitOrHeroDefinition = {}

---@param newId string 4 字符新对象原始 ID
---@param baseId string 4 字符母对象原始 ID
---@return UnitOrHeroDefinition
function UnitOrHeroDefinition:new(newId, baseId) end
