/** @noSelfInFile */
// 塞拉斯（学者 / H014）技能组配置
// 迁移真源：JASS\部分地图编辑器GUI的英雄jass代码\塞拉斯\{主要技能,被动效果，配合Q}.j
// 冲突口径：技能介绍为准，JASS 审计值保留在注释与 塞拉斯迁移计划.md 审计表中

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查玩家英雄单位ID } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置") as {
  按名字反查玩家英雄单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查技能ID } = require("系统.03．技能系统.08．技能数据表.01．技能名反查") as {
  按名字反查技能ID: (this: void, name: string) => string | undefined;
};

const 英雄名 = "塞拉斯";

// 物编 Name 存在历史命名差异（A0JQ 的 Name 带 W），严格使用技能数据表 Name 反查，反查失败回落 Rawcode
const 英雄单位ID = 按名字反查玩家英雄单位ID(英雄名) ?? "H014";
const D技能ID = 按名字反查技能ID("1天赋技-调查") ?? "A0JP";
const Q入口技能ID = 按名字反查技能ID("塞拉斯-魔法知识（Q）") ?? "A0JT";
const 火焰魔法技能ID = 按名字反查技能ID("1塞拉斯-火焰魔法（W）") ?? "A0JQ";
const 冰冻魔法技能ID = 按名字反查技能ID("1塞拉斯-冰冻魔法（E）") ?? "A0JR";
const 雷击魔法技能ID = 按名字反查技能ID("1塞拉斯-雷击魔法（R）") ?? "A0JS";
const 关闭入口技能ID = 按名字反查技能ID("1塞拉斯魔法知识-关闭") ?? "A0JV";
const W技能ID = 按名字反查技能ID("塞拉斯-大魔法化（W）") ?? "A0JW";
const E技能ID = 按名字反查技能ID("塞拉斯-属性提升（E）") ?? "A0JX";
const R技能ID = 按名字反查技能ID("塞拉斯-知识与旅行的学者（R）") ?? "A0JY";

export type 塞拉斯元素 = "火" | "冰" | "雷" | "";

export const 塞拉斯技能配置 = {
  英雄名,
  单位ID: 英雄单位ID,
  单位类型ID: stringToFourCCSafe(英雄单位ID),

  D: {
    快捷键序号: 5,
    技能ID: D技能ID,
    技能类型ID: stringToFourCCSafe(D技能ID),
    施法距离: 800,
    冷却秒: 45, // 物编 Cool=45
    魔耗: "统一百分比魔耗系统处理（介绍 5%），技能文件不扣魔",
    音效键: "gg_snd_SLD_D", // 地图 war3map.j 已注册（HeroVoice\SLS\SLD-D.mp3），按逆回十六夜模式取句柄播放
    错误提示: "目标不是当前 Boss 战单位",
    提示持续秒: 15,
  },

  Q入口: {
    快捷键序号: 1,
    技能ID: Q入口技能ID,
    技能类型ID: stringToFourCCSafe(Q入口技能ID),
    切换延迟秒: 0.15, // 源 JASS 0.15 秒后切换按钮
  },

  关闭入口: {
    技能ID: 关闭入口技能ID,
    技能类型ID: stringToFourCCSafe(关闭入口技能ID),
    切换延迟秒: 0.15,
    重置Q入口冷却: true, // 源 JASS：A0JV 施放时 A0JT 冷却归零（审计保留）
  },

  元素魔法: {
    火焰技能ID: 火焰魔法技能ID,
    冰冻技能ID: 冰冻魔法技能ID,
    雷击技能ID: 雷击魔法技能ID,
    火焰技能类型ID: stringToFourCCSafe(火焰魔法技能ID),
    冰冻技能类型ID: stringToFourCCSafe(冰冻魔法技能ID),
    雷击技能类型ID: stringToFourCCSafe(雷击魔法技能ID),
    范围: 500,
    tick间隔秒: 0.21, // 源 JASS 0.21 秒周期
    普通结算次数: 1,
    大魔法结算次数: 2, // 大魔法化：同一次施法内结算两次（审计：非二次施法）

    火焰: {
      元素: "火" as const,
      基础倍率: 1.40, // 攻击力 × (1.40 + 0.10 × A0JT等级)，一级 150%
      每级成长: 0.10,
      灼烧持续秒: 2,
      灼烧每秒已损失生命比例: 0.015, // 1.5%
      灼烧每次命中加层: 2, // 源 JASS SLSQ += 2
      特效: [
        { 模型路径: "war3mapImported\\fire.mdl", 缩放: 1.45, 持续秒: 1.2 },
        { 模型路径: "war3mapImported\\FireImpact.mdl", 缩放: 1.45, 持续秒: 1.2 },
        { 模型路径: "Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl", 缩放: 1.0, 持续秒: 1.2 },
      ],
      灼烧特效: { 模型路径: "war3mapImported\\Fire2.mdl", 挂点: "origin", 持续秒: 2.0 },
      音效普通键: "gg_snd_SLS_W", // 地图已注册（HeroVoice\SLS\SLS-W.mp3）
      音效大魔法键: "gg_snd_SLS_W2", // 地图已注册（HeroVoice\SLS\SLS-W2.mp3）
    },

    冰冻: {
      元素: "冰" as const,
      基础倍率: 1.20, // 攻击力 × (1.20 + 0.10 × A0JT等级)，一级 130%
      每级成长: 0.10,
      冻结秒: 0.60,
      // 审计：源 JASS SFB_setBuff(施法者, 1, 0.60) 冻结施法者本人（源码疑似 bug）；
      // 最终按技能介绍+迁移计划冻结命中目标。
      特效: [
        { 模型路径: "war3mapImported\\FrostNova.mdl", 缩放: 0.66, 持续秒: 1.2 },
        { 模型路径: "war3mapImported\\ICE.mdl", 缩放: 4.0, 持续秒: 1.2 },
      ],
      音效普通键: "gg_snd_SLS_E", // 地图已注册（HeroVoice\SLS\SLS-E.mp3）
      音效大魔法键: "gg_snd_SLS_E2", // 地图已注册（HeroVoice\SLS\SLS-E2.mp3）
    },

    雷击: {
      元素: "雷" as const,
      基础倍率: 1.40, // 攻击力 × (1.40 + 0.10 × A0JT等级)，一级 150%
      每级成长: 0.10,
      减速秒: 1.40, // 技能介绍 1.4 秒；审计：JASS SFB_setSlow(0.0,0.99,1.20) 为 1.20 秒
      减速比例: 0.99, // 源 JASS 99% 减速
      目标特效: { 模型路径: "Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl", 缩放: 1.25, 持续秒: 1.0 },
      落点特效: { 模型路径: "war3mapImported\\OrbOfLightning.mdl", 缩放: 7.0, 持续秒: 1.2 },
      目标音效键: "gg_snd_CorrosiveBreathMissileLaunch1", // 地图已注册（原生音）
      音效普通键: "gg_snd_SLS_R", // 地图已注册（HeroVoice\SLS\SLS-R.mp3）
      音效大魔法键: "gg_snd_SLS_R2", // 地图已注册（HeroVoice\SLS\SLS-R2.mp3）
    },
  },

  W: {
    快捷键序号: 2,
    技能ID: W技能ID,
    技能类型ID: stringToFourCCSafe(W技能ID),
    魔耗: "统一百分比魔耗系统处理（介绍 20%），技能文件不扣魔",
    冷却基础秒: 20,
    冷却每级递减秒: 0.5, // 20 - 0.5×技能等级；1级19.5秒，15级12.5秒
    特效: [
      { 模型路径: "war3mapImported\\[AKE]war3AKE.com - 4824137662399555907875383.mdl", 缩放: 2.0, 持续秒: 1.2 },
      { 模型路径: "war3mapImported\\Teleport.mdl", 缩放: 3.0, 持续秒: 1.2 },
    ],
    音效键: ["gg_snd_SLS_ZW", "gg_snd_Tranquility01"], // 地图已注册（HeroVoice\SLS\SLS-ZW.mp3 + 原生 Tranquility）
    刷新冷却秒: 0.05,
    // 源 JASS：W 施放时 YDWESetUnitAbilityState 将 A0JT/A0JQ/A0JR/A0JS 剩余冷却置 0.05（介绍：刷新魔法知识 Q 冷却）；
    // 同步冷却刷新属真实游戏数据，TS 用 技能_设置技能冷却时间 同步实现，并置「大魔法化=true」。
  },

  E: {
    快捷键序号: 3,
    技能ID: E技能ID,
    技能类型ID: stringToFourCCSafe(E技能ID),
    每级魔法伤害基础增幅百分比: 10, // (10 + 3×技能等级)%
    每级魔法伤害成长百分比: 3,
    // 说明：计划要求接入项目统一魔法伤害修正入口；核对后该入口不存在，
    // 暂在塞拉斯目录内以单一增幅函数实现（只修正塞拉斯火冰雷魔法技能伤害），待公共入口落地后迁移。
  },

  R: {
    快捷键序号: 4,
    技能ID: R技能ID,
    技能类型ID: stringToFourCCSafe(R技能ID),
    智力: {
      低段每级加值: 8, // 等级 1-10
      低段上限等级: 10,
      高段每级加值: 15, // 等级 11-15
    },
    魔法穿透: "待查：项目暂无魔法穿透接口，不生效",
    旅行经验: "待查：项目暂无旅行经验公共系统，按迁移计划暂停该分支，不写私有城镇检测",
  },

  被动: {
    触发距离: 500, // 施法者到目标至少 500
    延迟秒: 0.12,
    附加伤害范围: 350,
    当前魔法值伤害比例: 0.40,
    // 审计：计划写「施法者位置附近」，JASS 真源为被击目标位置（SX/SY=受击者坐标），按 JASS 实现。
    火焰特效: { 模型路径: "war3mapImported\\minitype flame02.mdx", 缩放: 1.0, 持续秒: 1.0 },
    雷击特效: { 模型路径: "war3mapImported\\lightningwrath.mdx", 缩放: 1.0, 持续秒: 1.0 },
    冰冻特效: { 模型路径: "Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl", 缩放: 1.75, 持续秒: 1.0 },
  },
} as const;
