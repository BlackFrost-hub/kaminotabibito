-- 熔浆鱼王（n06O）：第三章熔浆钓点的隐藏遭遇。
-- 触发方式：携带 熔岩能量(I05V) 在 熔浆钓点 抛竿 → 消耗材料，改钓出本体（见 鱼竿核心）。
-- 底子沿用「钓出的怪物」家族（湖底元素 n02S 也是 nele），保证可被攻击、可掉落的单位行为一致。
-- 定位：第三章隐藏精英，强度对齐第二章最终 Boss 档（沙丘母虫/蜘蛛女皇 20000HP/1000dmg/LV25）——它要掉 9000 分装备，必须打得过那个档次的硬仗。
-- 注意：湖底元素那套技能（A04X/A04P/A04Q）是水属性，熔岩鱼王不复用。

local fishKing = UnitDefinition:new('n06O', 'nele')
fishKing:setName('|cffFF8000熔浆鱼王|r|cffff0000（隐藏精英）|r')
fishKing:setHitPointsMaximumBase(20000)
fishKing:setAttack1DamageBase(1500)
fishKing:setAttack1CooldownTime(1.2)
fishKing:setDefenseBase(35)
fishKing:setLevel(30)
fishKing:setScalingValue(2.2)
-- 近战：贴脸撕咬。攻击距离 128（近战档）、武器类型 Normal（无投射物）。
fishKing:setAttack1Range(128)
fishKing:setAttack1WeaponType(WeaponType.Normal)
fishKing:setCollisionSize(48.0)
fishKing:setAcquisitionRange(1200.0)
fishKing:setSpeedBase(372)
fishKing:setTurnRate(1.0)
fishKing:setHitPointsRegenerationRate(40.0)
fishKing:setModelFile('Unit\\Minion\\Dunkleosteus.mdx')
fishKing:setIconGameInterface('Unit\\Minion\\Icon\\Dunkleosteus.blp')
-- 唯一技能：熔岩冲击（AUQ1）。**自建的通魔(Channel)壳**，效果由 TS 运行时监听命令串实现
-- （见 TS/系统/03．技能系统/05．单位技能/03．Boss技能/02．挑战与隐藏Boss/02．熔浆鱼王）。
-- 命名与做法沿用项目 Boss 壳规律，不复用 n02S 湖底元素的 A04X/A04P/A04Q（水属性，不合适）。
fishKing:setNormalAbilities('AUQ1,AUW1')
-- 熔岩冲击耗 100 魔法；给足蓝量使其能按冷却反复放（配合 AI 配置里 12 秒冷却）。
fishKing:setManaInitialAmount(800)
fishKing:setManaMaximum(800)
fishKing:setManaRegeneration(5.0)
fishKing:setRace(Race.Demon)
-- 隐藏遭遇的一次性收益：金币 1000 + 2~1000（2 骰 500 面）= 1200~2000，经验点数 200
fishKing:setGoldBountyAwardedBase(1500)
fishKing:setGoldBountyAwardedNumberofDice(2)
fishKing:setGoldBountyAwardedSidesperDie(750)
fishKing:setPointValue(400)
