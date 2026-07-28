-- Minions from the six-stage Ancestral Tide route.

createAncestralTideUnit(
  'n056',
  'nnmg',
  '潮蚀巡鳞者',
  'Unit\\Minion\\Murlocs_master.MDX',
  'ancient',
  1.50,
  'Unit\\Minion\\Icon\\Murlocs_master.blp'
)

local reefStonehurler = createAncestralTideUnit(
  'h00Y',
  'hmtm',
  '碎礁投石手',
  'Unit\\Minion\\KetzualHero.mdx',
  'ancient',
  1.00,
  'Unit\\Minion\\Icon\\KetzualHero.blp'
)
reefStonehurler:setAttacksEnabled(AttacksEnabled.AttackOneOnly)
reefStonehurler:setAttack1AttackType(AttackType.Siege)
reefStonehurler:setAttack1WeaponType(WeaponType.Artillery)
reefStonehurler:setAttack1ProjectileArt('Abilities\\Weapons\\DemolisherMissile\\DemolisherMissile.mdl')
reefStonehurler:setAttack1ProjectileSpeed(900)
reefStonehurler:setAttack1ProjectileArc(0.35)
reefStonehurler:setAttack1TargetsAllowed('debris,ground,wall,ward,item')
reefStonehurler:setAttack1WeaponSound(WeaponSound.Nothing)
