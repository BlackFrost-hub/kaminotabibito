-- Phoenixel active ability shells.

createBossUnitTargetChannelAbility('A0F8', '炽羽散射', {
  orderId = 'acidbomb',
  castRange = 1200,
  cooldown = 10,
  manaCost = 100,
  buttonX = 0,
  buttonY = 2,
  animationNames = '',
  tooltip = '炽羽散射',
  tooltipExtended = '菲尼克斯尔振翼散射炽焰羽毛，落地后留下短暂燃烧区。',
})

createBossUnitTargetChannelAbility('A0F7', '熔岩吐息', {
  orderId = 'banish',
  castRange = 900,
  cooldown = 18,
  manaCost = 120,
  buttonX = 1,
  buttonY = 2,
  animationNames = '',
  tooltip = '熔岩吐息',
  tooltipExtended = '菲尼克斯尔朝目标方向持续喷吐熔岩，对扇形区域造成连续伤害。',
})

createBossUnitTargetChannelAbility('A0F9', '凤凰漩涡', {
  orderId = 'chainlightning',
  castRange = 1200,
  cooldown = 20,
  manaCost = 140,
  buttonX = 2,
  buttonY = 2,
  animationNames = '',
  tooltip = '凤凰漩涡',
  tooltipExtended = '菲尼克斯尔锁定玩家当前位置生成漩涡，延迟后牵引并造成持续伤害。',
})
