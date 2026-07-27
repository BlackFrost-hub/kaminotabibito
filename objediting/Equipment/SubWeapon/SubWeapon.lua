-- Sub-weapon equipment.

createEquipmentItem('I0FQ', '英灵送葬法典', {
  baseId = 'ratf',
  icon = 'Equipment\\Icon\\SubWeapon\\aronkos_heroic_funeral_codex.blp',
  model = 'war3mapImported\\TomeOfRetraining.mdl',
  abilities = ' ',
  classification = 'Permanent',
  level = 6,
  score = 10400,
  tooltipExtended = '|cffccffff[副武器/法典]-法术/延迟落点|r|n|cffffcc99等级：B++|n评分：10400|r|n|cffffffcc[基础属性]|r|n智力+72|n魔法伤害+26%|n魔法穿透+22%|n冷却缩减+14%|n|cffffffcc[装备效果]|r|n英灵送葬：AOE技能命中时，在目标点预警0.9秒后对300范围敌人造成350+攻击力65%的魔法伤害，冷却10秒。|n|cFF808080法典记录的不是死者姓名，而是每一柄替他们完成送葬的武器。|r',
  description = '|cffccffff[副武器/法典]-法术/延迟落点|r|n|cffffcc99等级：B++|n评分：10400|r|n|cffffffcc[基础属性]|r|n智力+72|n魔法伤害+26%|n魔法穿透+22%|n冷却缩减+14%|n|cffffffcc[装备效果]|r|n英灵送葬：AOE技能命中时，在目标点预警0.9秒后对300范围敌人造成350+攻击力65%的魔法伤害，冷却10秒。|n|cFF808080法典记录的不是死者姓名，而是每一柄替他们完成送葬的武器。|r',
})

createEquipmentItem('I0FV', '苍影校魂法典', {
  baseId = 'ratf',
  icon = 'Equipment\\Icon\\SubWeapon\\ancestral_twin_blue_shadow_soul_codex.blp',
  model = 'war3mapImported\\TomeOfRetraining.mdl',
  abilities = ' ',
  classification = 'Permanent',
  level = 6,
  score = 7000,
  tooltipExtended = '|cffccffff[副武器/法典]-法术/组合|r|n|cffffcc99等级：B|n评分：7000|r|n|cffffffcc[基础属性]|r|n智力+50|n魔法伤害+20%|n魔法穿透+20%|n冷却缩减+10%|n|cffffffcc[装备效果]|r|n灵识校准：6秒内以2个不同技能伤害同一目标时，对其造成240+攻击力65%的魔法伤害，魔法抗性降低12%，持续4秒。|n|cFF808080两组不同灵印必须准确重合，法典才会承认一次完整的校准。|r',
  description = '|cffccffff[副武器/法典]-法术/组合|r|n|cffffcc99等级：B|n评分：7000|r|n|cffffffcc[基础属性]|r|n智力+50|n魔法伤害+20%|n魔法穿透+20%|n冷却缩减+10%|n|cffffffcc[装备效果]|r|n灵识校准：6秒内以2个不同技能伤害同一目标时，对其造成240+攻击力65%的魔法伤害，魔法抗性降低12%，持续4秒。|n|cFF808080两组不同灵印必须准确重合，法典才会承认一次完整的校准。|r',
})

createEquipmentItem('I0G0', '超位魔法残章·天空坠落', {
  baseId = 'ratf',
  icon = 'Equipment\\Icon\\SubWeapon\\ainz_super_tier_fragment_fallen_down.blp',
  model = 'war3mapImported\\TomeOfRetraining.mdl',
  abilities = 'IP02',
  cooldownGroup = 'IP02',
  classification = 'Permanent',
  level = 6,
  score = 12500,
  activelyUsed = true,
  tooltipExtended = '|cffccffff[副武器/法典]-超位法术|r|n|cffffcc99等级：A|n评分：12500|r|n|cffffffcc[基础属性]|r|n智力+90|n魔法伤害+30%|n魔法穿透+26%|n魔法值+1800|n冷却缩减+15%|n|cffffffcc[装备效果]|r|n使用·天空坠落：引导2.5秒（可被移动或强控制中断）后，对目标点500范围敌人造成1800+智力×7的魔法伤害，冷却90秒，施法距离900码。|n|cFF808080残章只保留了一页，却足以让高空的法阵重新注视地面。|r',
  description = '|cffccffff[副武器/法典]-超位法术|r|n|cffffcc99等级：A|n评分：12500|r|n|cffffffcc[基础属性]|r|n智力+90|n魔法伤害+30%|n魔法穿透+26%|n魔法值+1800|n冷却缩减+15%|n|cffffffcc[装备效果]|r|n使用·天空坠落：引导2.5秒（可被移动或强控制中断）后，对目标点500范围敌人造成1800+智力×7的魔法伤害，冷却90秒，施法距离900码。|n|cFF808080残章只保留了一页，却足以让高空的法阵重新注视地面。|r',
})

createEquipmentItem('I0G2', '黑翼守护重盾', {
  baseId = 'ratf',
  icon = 'Equipment\\Icon\\SubWeapon\\ainz_black_wing_guard_heavy_shield.blp',
  model = 'war3mapImported\\ItemRoundShield.mdl',
  abilities = 'IU00',
  cooldownGroup = 'IU00',
  classification = 'Permanent',
  level = 6,
  score = 12000,
  activelyUsed = true,
  tooltipExtended = '|cffccffff[副武器/盾牌]-前排/护卫|r|n|cffffcc99等级：A|n评分：12000|r|n|cffffffcc[基础属性]|r|n生命值+4800|n护甲+60|n物理抗性+18%|n眩晕抗性+30%|n全属性+30|n|cffffffcc[装备效果]|r|n使用·守护者之职责：引导1秒后与一名友方英雄建立8秒守护连接，双方获得不可驱散的守护契约Buff；自身获得最大生命12%的护盾，目标获得最大生命10%的护盾，均持续8秒。连接期间目标所受35%的直接伤害转移给自身；双方距离超过900码、自身生命≤20%或任意一方死亡时连接提前结束，冷却45秒。|n|cFF808080黑翼沿盾缘向内收拢，像一名永不离开至尊身前的守护者。|r',
  description = '|cffccffff[副武器/盾牌]-前排/护卫|r|n|cffffcc99等级：A|n评分：12000|r|n|cffffffcc[基础属性]|r|n生命值+4800|n护甲+60|n物理抗性+18%|n眩晕抗性+30%|n全属性+30|n|cffffffcc[装备效果]|r|n使用·守护者之职责：引导1秒后与一名友方英雄建立8秒守护连接，双方获得不可驱散的守护契约Buff；自身获得最大生命12%的护盾，目标获得最大生命10%的护盾，均持续8秒。连接期间目标所受35%的直接伤害转移给自身；双方距离超过900码、自身生命≤20%或任意一方死亡时连接提前结束，冷却45秒。|n|cFF808080黑翼沿盾缘向内收拢，像一名永不离开至尊身前的守护者。|r',
})
