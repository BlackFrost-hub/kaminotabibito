-- Balzaroth active ability shells.
-- Keep the historical raw ids, but make them clean Boss Channel abilities.

createBossUnitTargetChannelAbility('A0C9', '恶魔咆哮波', {
  orderId = 'acidbomb',
  castRange = 1500,
  cooldown = 12,
  manaCost = 0,
  buttonX = 0,
  buttonY = 2,
  tooltip = '|cffff9900恶魔咆哮波|r',
  tooltipExtended = '巴尔扎罗斯凝聚恶魔咆哮波，向当前目标方向释放直线冲击。',
})

createBossUnitTargetChannelAbility('A0CC', '熔岩喷发', {
  orderId = 'banish',
  castRange = 1000,
  cooldown = 30,
  manaCost = 0,
  buttonX = 1,
  buttonY = 2,
  tooltip = '|cffff6600熔岩喷发|r',
  tooltipExtended = '巴尔扎罗斯在玩家附近制造熔岩预警，短暂延迟后爆发并留下熔岩残留。',
})

createBossUnitTargetChannelAbility('A0CA', '王者天罚', {
  orderId = 'chainlightning',
  castRange = 1200,
  cooldown = 26,
  manaCost = 0,
  buttonX = 2,
  buttonY = 2,
  tooltip = '|cff993366王者天罚|r',
  tooltipExtended = '巴尔扎罗斯引导多波天罚，连续轰击战场上的玩家。',
})

createBossUnitTargetChannelAbility('A0CB', '火焰锁链', {
  orderId = 'cripple',
  castRange = 900,
  cooldown = 22,
  manaCost = 0,
  buttonX = 3,
  buttonY = 2,
  tooltip = '|cffff3300火焰锁链|r',
  tooltipExtended = '巴尔扎罗斯点名远处玩家并生成火焰锁链，攻击锁链单位可提前切断。',
})
