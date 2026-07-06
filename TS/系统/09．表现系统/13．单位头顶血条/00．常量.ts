/** @noSelfInFile */

export const 启用单位头顶血条 = true;

export const 血条资源 = {
  底框: "UI\\UnitHealthBar\\bar_frame.tga",
  精英底框: "UI\\UnitHealthBar\\bar_elite_frame.tga",
  友方生命: "UI\\UnitHealthBar\\bar_life_green.tga",
  敌方生命: "UI\\UnitHealthBar\\bar_life_red.tga",
  自身生命: "UI\\UnitHealthBar\\bar_life_self.tga",
  生命缓降: "UI\\UnitHealthBar\\bar_damage_lag_white.tga",
  生命低血渐变: [
    "UI\\UnitHealthBar\\bar_life_native_00.tga",
    "UI\\UnitHealthBar\\bar_life_native_05.tga",
    "UI\\UnitHealthBar\\bar_life_native_10.tga",
    "UI\\UnitHealthBar\\bar_life_native_15.tga",
    "UI\\UnitHealthBar\\bar_life_native_20.tga",
    "UI\\UnitHealthBar\\bar_life_native_25.tga",
    "UI\\UnitHealthBar\\bar_life_native_30.tga",
    "UI\\UnitHealthBar\\bar_life_native_35.tga",
    "UI\\UnitHealthBar\\bar_life_native_40.tga",
    "UI\\UnitHealthBar\\bar_life_native_45.tga",
    "UI\\UnitHealthBar\\bar_life_native_50.tga",
    "UI\\UnitHealthBar\\bar_life_native_55.tga",
    "UI\\UnitHealthBar\\bar_life_native_60.tga",
  ],
  魔法: "UI\\UnitHealthBar\\bar_mana_blue.tga",
  护盾: {
    通用: "UI\\UnitHealthBar\\bar_shield_white.tga",
    物理: "UI\\UnitHealthBar\\bar_shield_physical.tga",
    魔法: "UI\\UnitHealthBar\\bar_shield_magic.tga",
    强化: "UI\\UnitHealthBar\\bar_shield_enhanced.tga",
    火: "UI\\UnitHealthBar\\bar_shield_fire.tga",
    水冰: "UI\\UnitHealthBar\\bar_shield_water.tga",
    雷: "UI\\UnitHealthBar\\bar_shield_thunder.tga",
    金毒: "UI\\UnitHealthBar\\bar_shield_metal.tga",
    木风: "UI\\UnitHealthBar\\bar_shield_wood.tga",
    光: "UI\\UnitHealthBar\\bar_shield_light.tga",
    暗: "UI\\UnitHealthBar\\bar_shield_dark.tga",
  },
} as const;

export const 血条尺寸 = {
  初始血条容量: 1000,
  血条容量扩展步长: 50,
  最大护盾分段数: 4,
  生命缓降追赶比例: 0.020,
  根宽: 0.0598,
  根高: 0.0109,
  仅生命根高: 0.0076,
  内条宽: 0.0564,
  生命高: 0.0045,
  魔法高: 0.0023,
  内条左偏移: 0.0017,
  生命Y: -0.0010,
  魔法Y: -0.0064,
  名字宽: 0.080,
  名字高: 0.010,
  名字Y: 0.016,
  控制台遮罩宽: 0.80,
  控制台遮罩高: 0.12,
  默认头顶高度: 40,
  英雄头顶高度: 40,
  Boss头顶高度: 120,
} as const;

export const 血条层级 = {
  根: 0,
  生命缓降: 1,
  生命: 2,
  魔法: 3,
  护盾: 4,
  名字: 5,
  控制台遮罩: 100,
} as const;

export const 血条刷新间隔Tick = 3;
