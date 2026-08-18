/** @noSelfInFile */
// 云端（E03I / 神秘剑客）技能组配置。
// 迁移真源：JASS\部分地图编辑器GUI的英雄jass代码\云端\{Q技能,W,云端E被动,R}.j
// 冲突口径与差异审计见 云端迁移计划.md；源 JASS 审计值保留在注释中。

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查玩家英雄单位ID } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置") as {
  按名字反查玩家英雄单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查技能ID } = require("系统.03．技能系统.08．技能数据表.01．技能名反查") as {
  按名字反查技能ID: (this: void, name: string) => string | undefined;
};

const 英雄名 = "云端";

// 技能名严格匹配技能数据表 Name 字段（反查器自动剥离颜色码）。
const Q技能名 = "YD-冰火魔剑(Q)";
const W技能名 = "YD-光暗魔剑(W)";
const E技能名 = "YD-无双剑法（E）";
const R技能名 = "YD-暗黑制裁魔剑(R)";

const 英雄单位ID = 按名字反查玩家英雄单位ID(英雄名);
const Q技能ID = 按名字反查技能ID(Q技能名) ?? "A0KN";
const W技能ID = 按名字反查技能ID(W技能名) ?? "A0KO";
const E技能ID = 按名字反查技能ID(E技能名) ?? "A0KP";
const R技能ID = 按名字反查技能ID(R技能名) ?? "A0KM";

if (英雄单位ID == null || 英雄单位ID === "") {
  throw new Error("无法反查英雄单位ID：" + 英雄名);
}

export const 云端技能配置 = {
  英雄名,
  单位ID: 英雄单位ID,
  单位类型ID: stringToFourCCSafe(英雄单位ID),

  // ===== Q：冰火魔剑（A0KN） =====
  Q: {
    技能ID: Q技能ID,
    技能类型ID: stringToFourCCSafe(Q技能ID),
    物编冷却秒: 12,
    施法距离码: 500,
    伤害公式: { 基础倍率: 1.5, 每级加成: 0.1 }, // 攻击力 × (150% + 10% × 等级)
    硬直秒: 0.75, // 源 GS_Suspend 0.75
    动作名: "Spell One",
    // 源马甲（e07G 换模型 finalfield）迁移为直接特效；源 .mdl 后缀按 imp.ini 注册修正为 .mdx
    护场特效: { 模型: "war3mapImported\\finalfield.mdx", 缩放: 3, 持续秒: 1.5 },
    火: {
      颜色: { 红: 255, 绿: 0, 蓝: 0, 透明度: 255 },
      音效: { 全局音效键: "gg_snd_effect_sound" }, // 源 PlaySoundOnUnitBJ(gg_snd_effect_sound)，war3map.j 已注册
      移动特效: { 模型: "Abilities\\Spells\\Other\\Doom\\DoomTarget.mdl", 缩放: 5, 高度: 25, 持续秒: 0.5 },
      // 源 fire.mdl 已核实等价于项目内 war3mapImported\123.mdx（SHA-256 与导出特效 fire.mdx 一致），直接使用真源
      命中特效: { 模型: "war3mapImported\\123.mdx", 缩放: 2, 高度: 25, 持续秒: 2 },
      灼烧: { 次数: 3, 间隔秒: 1, 单次比例: 0.1 }, // 每秒一次，共 3 次，各为初始伤害 10%
      灼烧挂点模型: "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeEmbers.mdl",
      灼烧挂点持续秒: 3,
    },
    冰: {
      颜色: { 红: 20, 绿: 20, 蓝: 255, 透明度: 255 },
      移动特效: { 模型: "war3mapImported\\bluestrikearray.mdx", 缩放: 2.5, 高度: 25, 持续秒: 2 },
      命中特效: { 模型: "war3mapImported\\plazma_boom.mdx", 缩放: 1.25, 高度: 25, 持续秒: 2 },
      减速比例: 0.5, // 移速/攻速各 50%
      减速持续秒: 2,
    },
    冲锋: {
      每Tick距离: 40, // 源 0.02s/tick × 40 码 = 2000 码/秒
      Tick间隔秒: 0.02,
      命中距离码: 85, // 距目标 85 码内判定到达
      动作索引: 2,
      移动音效: { 全局音效键: "gg_snd_effect_sound13" }, // 源 gg_snd_effect_sound13
    },
    目标跳跃: { 距离: 1, 持续时间秒: 0.4, 跳跃高度: 400 }, // 源 YDWEJumpTimer(dw, 随机方向, 1.0, 0.40, 0.03, 400)
    摄像机震动强度: 30,
    震动清除延迟秒: 0.5,
  },

  // ===== W：光暗魔剑（A0KO） =====
  W: {
    技能ID: W技能ID,
    技能类型ID: stringToFourCCSafe(W技能ID),
    物编冷却秒: 15,
    施法距离码: 800,
    伤害公式: { 攻击力倍率: 1.5, 智力每级系数: 0.4 }, // 攻击力×150% + 智力×(0.4×等级)
    硬直秒: 0.75,
    时间流速: 1.75,
    动作名: "Spell Throw",
    路径: {
      启动延迟秒: 0.1,
      Tick间隔秒: 0.02,
      每Tick距离: 40,
      最大Tick数: 20, // 800 码
      结算半径码: 350,
    },
    光剑: {
      // 源 MJ=false 分支：视觉 infernoarmor + skybomb/theholybomb；伤害 DIVINE + 友军治疗
      起手特效: { 模型: "war3mapImported\\infernoarmor.mdx", 缩放: 2.5, 持续秒: 1.5 },
      护场颜色: { 红: 255, 绿: 80, 蓝: 0, 透明度: 255 },
      路径特效: [
        { 模型: "war3mapImported\\skybomb.mdx", 缩放: 3, 高度: 25, 持续秒: 1.5 },
        { 模型: "war3mapImported\\theholybomb.mdx", 缩放: 2.5, 高度: 25, 持续秒: 1.5 },
        { 模型: "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", 缩放: 2, 高度: 25, 持续秒: 1.5 },
      ],
      治疗比例: 0.35, // 友军恢复伤害量的 35%
    },
    暗剑: {
      // 源 MJ=true 分支：视觉 arcanewave + darkpillar/AIilTarget；伤害 SHADOW_STRIKE + 眩晕
      起手特效: { 模型: "war3mapImported\\arcanewave.mdx", 缩放: 3, 持续秒: 1.5 },
      护场颜色: { 红: 20, 绿: 20, 蓝: 255, 透明度: 255 },
      路径特效: [
        { 模型: "war3mapImported\\darkpillar.mdx", 缩放: 3, 高度: 25, 持续秒: 1.5 },
        { 模型: "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", 缩放: 3, 高度: 25, 持续秒: 1.5 },
        { 模型: "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", 缩放: 2, 高度: 25, 持续秒: 1.5 },
      ],
      眩晕秒: 1,
    },
    护场特效: { 模型: "war3mapImported\\finalfield.mdx", 缩放: 3, 持续秒: 1.5 },
    // 源 e005（暗剑创建后无逻辑）与 e031/A065 治疗马甲：前者不存在于物编直接省略，
    // 后者由 doHeal 统一治疗封装替代（计划第 6.4 节）。
  },

  // ===== E：无双剑法（A0KP，被动） =====
  E: {
    技能ID: E技能ID,
    技能类型ID: stringToFourCCSafe(E技能ID),
    触发冷却秒: 8,
    增益持续秒: 4,
    音效: { 全局音效键: "gg_snd_effect_sound18" }, // 源 PlaySoundOnUnitBJ(gg_snd_effect_sound18)
    // 源 blood2022720203813.mdl 不存在于 imp.ini/资源，触发特效省略（差异审计见计划）
    洞察: { 每级暴击提升: 0.02, 漂浮字: "无双一击" }, // 目标生命 ≥95%（源 GUI/JASS 均为“或等于”）：暴击率/暴击伤害各 +2%×级
    破势: { 每级敏捷系数: 0.4, 漂浮字: "趁胜追击" }, // 目标生命 ≤50%：攻击力 + 当前敏捷×(0.4×级)（源误用智力，按介绍修正）
    御势: { 每级护甲提升: 3, 漂浮字: "无所畏惧" }, // 其它：护甲 + 3×级
    高生命阈值: 95,
    低生命阈值: 50,
    // 三分支漂浮字公共参数（源 CreateTextTagUnitBJ：尺寸12/透明20%/上浮0.05/3秒销毁）
    漂浮字: { 尺寸: 12, 透明度: 51, 上浮速度: 0.05, 持续秒: 3 },
  },

  // ===== R：暗黑制裁魔剑（A0KM） =====
  R: {
    技能ID: R技能ID,
    技能类型ID: stringToFourCCSafe(R技能ID),
    物编冷却秒: 36,
    施法距离码: 500,
    伤害公式: { 基础倍率: 2.5, 每级加成: 0.5 }, // 攻击力 × (250% + 50%×级)
    硬直秒: 3, // 源 GS_Suspend 3.0
    起手音效: { 全局音效键: "gg_snd_YD_R" }, // 源 PlaySoundOnUnitBJ(gg_snd_YD_R)
    起手动作名: "Spell Channel",
    // 源入口 CreateTextTagUnitBJ(TRIGSTR_188, 施法者, 40, 15, 0, 0, 100, 20) 喊话漂浮字；原文据源 GUI 截图为“魔攻↑”
    起手漂浮字: { 文本: "魔攻↑", 高度: 40, 尺寸: 15, 透明度: 51, 上浮速度: 0.05, 持续秒: 3 },
    阶段: {
      第一段延迟秒: 0.75, // 退后冲刺 + 目标再次控制
      第二段延迟秒: 0.5, // 突进冲刺
      升空准备延迟秒: 0.5, // Stand Cinematic + 升空周期启动
      结算延迟秒: 0.5, // 升空满后结算
      敏捷保留秒: 5, // 结算后敏捷翻倍再保持 5 秒
    },
    冲刺: {
      第一段: { 距离: 400, 持续时间秒: 0.4 }, // 源：朝目标反向退后 400（b→a 方向）
      第二段: { 基础距离: 200, 持续时间秒: 0.4 }, // 距离 = 200 + 实时两者距离，朝目标
      动作名: "Spell Throw",
      第一段流速: 1.5,
      // 源 YDWETimerPatternRushSlide 两段冲刺均带 DeathCoilSpecialArt 尾迹，用冲锋残影表现模板模拟
      尾迹模型: "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl",
    },
    升空: {
      Tick间隔秒: 0.05,
      最大Tick数: 25,
      每Tick高度: 20,
      特效基础高度: 25,
      特效: [
        { 模型: "war3mapImported\\darkpillar.mdx", 缩放: 3, 高度: 25, 持续秒: 1.5 },
        { 模型: "war3mapImported\\arcdirve02b.mdx", 缩放: 3, 持续秒: 2, 跟随SS: true },
        { 模型: "Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayTarget.mdl", 缩放: 3, 持续秒: 2, 跟随SS: true },
      ],
      震屏强度: 10,
    },
    坠落: {
      表现模型: "Abilities\\Spells\\Other\\Doom\\DoomTarget.mdl", // 源 e03U 马甲（DoomTarget/缩放1.5/高50），按 8.4 转直接特效
      表现缩放: 1.5,
      表现高度: 400,
      表现持续秒: 2,
      跳跃: { 距离: 100, 持续时间秒: 0.45, 跳跃高度: 500 },
      震屏强度: 45,
    },
    眩晕秒: 1,
    飞行技能ID: "Amrf", // 目标临时加/移除以允许设置飞行高度
    // 源 e0BF 不存在于物编且创建后无逻辑，省略（差异审计见计划）。
  },

  暂停来源: {
    Q施法硬直: "云端-Q冰火魔剑-施法硬直",
    W施法硬直: "云端-W光暗魔剑-施法硬直",
    R施法硬直: "云端-R暗黑制裁-施法硬直",
  },
};

export default 云端技能配置;
