/** @noSelfInFile */

interface Boss死亡音效配置 {
  单位ID: string;
  音效路径: string;
  裁断距离: number;
  延迟音效列表?: { 音效路径: string; 延迟Ms: number }[];
}

const Boss死亡音效配置表: Boss死亡音效配置[] = [
  {
    单位ID: "N057",
    音效路径: "Sound\\Boss\\Thranduil\\SFX\\thranduil_defeat_dissolve_01.mp3",
    裁断距离: 2800,
  },
  {
    单位ID: "N00V",
    音效路径: "Sound\\Boss\\Mia\\SFX\\mia_defeat_corruption_fades_01_80k.mp3",
    裁断距离: 2800,
  },
  {
    单位ID: "N03G",
    音效路径: "Sound\\Boss\\Balzaroth\\SFX\\balzaroth_defeat_molten_core_fades_04.mp3",
    裁断距离: 2800,
    延迟音效列表: [
      { 音效路径: "Sound\\Boss\\Balzaroth\\SFX\\balzaroth_defeat_embers_settle_01.mp3", 延迟Ms: 1900 },
    ],
  },
  {
    单位ID: "N00U",
    音效路径: "Sound\\Boss\\Phoenixel\\SFX\\phoenixel_defeat_cycle_cut_ashes_02_64k.mp3",
    裁断距离: 2800,
  },
  {
    单位ID: "N05S",
    音效路径: "Sound\\Boss\\TrollChief\\SFX\\troll_chief_defeat_forest_falls_quiet_01.mp3",
    裁断距离: 2800,
  },
  {
    单位ID: "N05T",
    音效路径: "Sound\\Boss\\Felice\\SFX\\felice_defeat_soul_command_fades_puremix_12_fade.mp3",
    裁断距离: 2800,
  },
  {
    单位ID: "N05V",
    音效路径: "Sound\\Boss\\Kasela\\SFX\\kasela_defeat_abyss_squid_sinks_01.mp3",
    裁断距离: 2800,
  },
  {
    单位ID: "N05W",
    音效路径: "Sound\\Boss\\Moltes\\SFX\\moltes_defeat_rotten_tree_quiet_11_subtle_tailfade.mp3",
    裁断距离: 2800,
  },
  {
    单位ID: "N01Y",
    音效路径: "Sound\\Boss\\ShadowboneMortes\\SFX\\shadowbone_mortes_defeat_shadowbone_falls_05_sandy_layered.mp3",
    裁断距离: 2800,
  },
  {
    单位ID: "N00C",
    音效路径: "Sound\\Boss\\GoblinPriest\\SFX\\goblinpriest_boss_death_64k.mp3",
    裁断距离: 2800,
  },
  {
    单位ID: "N05J",
    音效路径: "Sound\\Boss\\Ogre\\SFX\\ogre_phase_transition_64k.mp3",
    裁断距离: 2800,
  },
  {
    单位ID: "N05K",
    音效路径: "Sound\\Boss\\Ogre\\SFX\\ogre_boss_death_64k.mp3",
    裁断距离: 2800,
  },
  {
    单位ID: "N05M",
    音效路径: "Sound\\Boss\\Scholar\\SFX\\scholar_death_64k.mp3",
    裁断距离: 2800,
  },
  {
    单位ID: "N05N",
    音效路径: "Sound\\Boss\\Swordsman\\SFX\\swordsman_death_64k.mp3",
    裁断距离: 2800,
  },
];

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number, model?: any) => any;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;

function 查找Boss死亡音效配置(this: void, bossUnit: any): Boss死亡音效配置 | undefined {
  if (bossUnit == null || bossUnit === 0) return undefined;
  const unitTypeId = GetUnitTypeId(bossUnit);
  for (let i = 0; i < Boss死亡音效配置表.length; i++) {
    const config = Boss死亡音效配置表[i];
    if (stringToFourCCSafe(config.单位ID) === unitTypeId) return config;
  }
  return undefined;
}

export function 尝试播放Boss死亡音效(this: void, bossUnit: any): void {
  const config = 查找Boss死亡音效配置(bossUnit);
  if (config == null) return;
  const x = GetUnitX(bossUnit);
  const y = GetUnitY(bossUnit);
  Sound3DII_CooPlayReuse(config.音效路径, x, y, 0, config.裁断距离);
  const list = config.延迟音效列表;
  if (list == null) return;
  for (let i = 0; i < list.length; i++) {
    const item = list[i];
    addDelayedCallback(item.延迟Ms, function Boss死亡延迟音效(this: void): void {
      Sound3DII_CooPlayReuse(item.音效路径, x, y, 0, config.裁断距离);
    });
  }
}
