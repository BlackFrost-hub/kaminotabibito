-- Cloud Q/E follow-up inputs. These replace the original local hardware-key counters.

CloudComboAbilityIds = {
  Q2 = 'ACQ2',
  Q3 = 'ACQ3',
  E2 = 'ACE2',
  E3 = 'ACE3',
}

local Q_ICON = 'ReplaceableTextures\\CommandButtons\\BTNKLD-Q.blp'
local E_ICON = 'ReplaceableTextures\\CommandButtons\\BTNKLD-E.blp'

HeroComboAbilityShell.createDivineShield({
  id = CloudComboAbilityIds.Q2,
  name = 'KLD-破晃击',
  editorSuffix = '连击2Hit',
  tooltip = '破晃击（Q）- 二段',
  extendedTooltip = '再次按下 Q，选择破晃击的一次强化。继续按下可进入三段强化。',
  icon = Q_ICON,
  hotkey = 'Q',
  buttonX = 0,
  buttonY = 2,
})

HeroComboAbilityShell.createDivineShield({
  id = CloudComboAbilityIds.Q3,
  name = 'KLD-破晃击',
  editorSuffix = '连击3Hit',
  tooltip = '破晃击（Q）- 三段',
  extendedTooltip = '再次按下 Q，选择破晃击的二次强化。',
  icon = Q_ICON,
  hotkey = 'Q',
  buttonX = 0,
  buttonY = 2,
})

HeroComboAbilityShell.createDivineShield({
  id = CloudComboAbilityIds.E2,
  name = 'KLD-凶斩',
  editorSuffix = '连击2Hit',
  tooltip = '凶斩（E）- 二段',
  extendedTooltip = '第一次追加输入。继续按下 E 进入三段并确认强化击飞。',
  icon = E_ICON,
  hotkey = 'E',
  buttonX = 2,
  buttonY = 2,
})

HeroComboAbilityShell.createDivineShield({
  id = CloudComboAbilityIds.E3,
  name = 'KLD-凶斩',
  editorSuffix = '连击3Hit',
  tooltip = '凶斩（E）- 三段',
  extendedTooltip = '第二次追加输入。施放后确认凶斩的强化击飞。',
  icon = E_ICON,
  hotkey = 'E',
  buttonX = 2,
  buttonY = 2,
})
