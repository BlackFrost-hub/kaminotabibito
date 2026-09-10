/** @noSelfInFile */
/**
 * 熔浆鱼王（n06O）技能配置。
 *
 * 单位：`objediting/Unit/Minion/MoltenFishKing.lua`
 * 技能壳：`objediting/HeroAbility/MoltenFishKing.lua`（通魔基座，壳 ID `AUQ1` / `AUW1`）
 * 本目录负责：监听技能壳的命令串 → 实现真实效果 → 并在运行时把技能显示名改成中文。
 *
 * 两个技能的伤害都**与施法者攻击力挂钩**（按倍率换算），本体攻击上调后技能伤害自动跟上。
 */

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};

export const 熔浆鱼王单位ID = "n06O";
export const 熔浆鱼王单位类型ID = stringToFourCCSafe(熔浆鱼王单位ID);

/** 技能壳 ID。 */
export const 熔岩冲击技能ID = "AUQ1";
export const 熔岩冲击技能类型ID = stringToFourCCSafe(熔岩冲击技能ID);
export const 熔渊新星技能ID = "AUW1";
export const 熔渊新星技能类型ID = stringToFourCCSafe(熔渊新星技能ID);

/** Q：朝目标地点喷吐熔岩（点目标）。先铺预警圈，延迟后爆炸。 */
export const 熔岩冲击配置 = {
  冷却秒: 12,
  /** 伤害 = 施法者攻击力 × 倍率。 */
  攻击倍率: 2.0,
  范围: 320,
  施法距离: 700,
  /** 预警：落点先出现红橙熔灼圆盘，给玩家反应窗口。 */
  预警秒: 1.0,
  /** 到点爆炸。 */
  爆炸特效: "Common\\Effect\\Form\\Explosion\\dustwave.mdx",
  爆炸特效持续秒: 1.2,
};

/** W：以自身为中心炸开熔岩（无目标），惩罚贴脸。先预警后爆炸。 */
export const 熔渊新星配置 = {
  冷却秒: 20,
  /** 伤害 = 施法者攻击力 × 倍率。 */
  攻击倍率: 1.5,
  范围: 380,
  预警秒: 0.8,
  爆炸特效: "Common\\Effect\\Form\\Explosion\\ShalltearRebirthBurst.mdx",
  爆炸特效持续秒: 1.2,
};

export {};
