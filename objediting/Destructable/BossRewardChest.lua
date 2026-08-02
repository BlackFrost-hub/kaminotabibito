local BOSS_REWARD_CHEST_ID = 'BR01'
local BASE_CHEST_ID = 'LTbr'

local chest = DestructableDefinition:new(BOSS_REWARD_CHEST_ID, BASE_CHEST_ID)
chest:setName('首领奖励宝箱')
chest:setCategory('D')
chest:setModel('war3mapImported\\treasurechest.mdl')
chest:setPath('PathTextures\\4x4Default.tga')
chest:setSoundOnDestroy('WoodenBoxHeavyDeath')

local MORTES_LEGACY_CHEST_ID = 'BR02'
local mortesLegacyChest = DestructableDefinition:new(MORTES_LEGACY_CHEST_ID, BASE_CHEST_ID)
mortesLegacyChest:setName('11宝箱')
mortesLegacyChest:setModel('Boss\\ShadowboneMortes\\ShadowboneMortesThievesLegacyChest.mdx')
