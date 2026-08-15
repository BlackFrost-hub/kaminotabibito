/** @noSelfInFile */
// Saber（亚瑟王 / H00H）技能组配置。
// 迁移真源：JASS\部分地图编辑器GUI的英雄jass代码\Saber\{主要技能,E开启后的效果}.j
// 冲突口径与差异审计见 Saber迁移计划.md；源 JASS 审计值保留在注释中。

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查玩家英雄单位ID } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置") as {
  按名字反查玩家英雄单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查技能ID } = require("系统.03．技能系统.08．技能数据表.01．技能名反查") as {
  按名字反查技能ID: (this: void, name: string) => string | undefined;
};

const 英雄名 = "亚瑟王";

// 技能名严格匹配技能数据表 Name 字段（反查器自动剥离颜色码）。
const Q技能名 = "Saber风王结界（Q）";
const Q连击2技能名 = "Saber风王结界（Q）2";
const Q连击3技能名 = "Saber风王结界（Q）3";
const W技能名 = "Saber风王铁锤（W）";
const E技能名 = "Saber魔力放出（E）";
const R技能名 = "Saber誓约胜利之剑（R）";
const D技能名 = "Saber遥远的理想乡(D)";

const 英雄单位ID = 按名字反查玩家英雄单位ID(英雄名);
const Q技能ID = 按名字反查技能ID(Q技能名) ?? "A0DB";
const Q连击2技能ID = 按名字反查技能ID(Q连击2技能名) ?? "A0DC";
const Q连击3技能ID = 按名字反查技能ID(Q连击3技能名) ?? "A0DD";
const W技能ID = 按名字反查技能ID(W技能名) ?? "A0DE";
const E技能ID = 按名字反查技能ID(E技能名) ?? "A0DG";
const R技能ID = 按名字反查技能ID(R技能名) ?? "A0DF";
const D技能ID = 按名字反查技能ID(D技能名) ?? "A0DH";

if (英雄单位ID == null || 英雄单位ID === "") {
  throw new Error("无法反查英雄单位ID：" + 英雄名);
}

export const Saber技能配置 = {
  英雄名,
  单位ID: 英雄单位ID,
  单位类型ID: stringToFourCCSafe(英雄单位ID),

  // ===== Q：风王结界三段连击（A0DB/A0DC/A0DD） =====
  Q: {
    初段: {
      技能ID: Q技能ID,
      技能类型ID: stringToFourCCSafe(Q技能ID),
      物编冷却秒: 12,
      起手延迟秒: 0.05, // 源：0.05 秒后计算方向并启动冲锋
      音效: { 路径: "Sound\\HeroVoice\\Saber\\Saber-Q1.mp3", 裁断距离: 1500 },
      动作索引: 5,
      时间流速: 3.5,
      伤害攻击力倍率: 0.5, // 初段保存攻击力×0.5 作为整段基础伤害
      冲锋: {
        推进间隔秒: 0.03, // 源 tick 间隔
        每Tick距离: 80, // 源：每 tick 向前 80，不是每秒速度
        最大推进次数: 10, // 合计最多 800 码
        最大距离: 800,
        命中半径: 175,
      },
      未命中冷却: {
        基础冷却秒: 4, // 源：Q 冷却设置为 4 - 4×冷却缩减（说明写减少8秒，审计差异见计划17.1）
        冷却缩减上限: 0.35,
      },
      命中后: {
        硬直延迟秒: 0.3, // 源：命中停止后 0.30 秒进入劈砍
        动作索引: 9,
        时间流速: 2.0,
      },
      劈砍: {
        半径: 300,
        前方角度: 180,
        控制秒: 0.5, // 源 SFB_setBuff(21, 0.5)
        伤害倍率: 1.0, // 基于初段快照（攻击力×0.5）×1.0
        命中特效: { 模型路径: "war3mapImported\\[ake]gaopin.mdx", 挂点: "origin", 持续秒: 0.35 },
        目标动作时间流速: 4.0, // 源：目标 Death 动作 + 时间流速 4
        目标击退: { 每次距离: 10, 间隔秒: 0.02, 次数: 10 },
      },
      刀光: {
        模型路径: "war3mapImported\\MirrorZI_effect_weaponAttack_blueice.mdx",
        侧向偏移: 160, // 源：Saber 位置 +160@(面向+90)
        前向偏移: 120, // 再 +120@面向
        高度增量: 50, // Z = 50 + Saber 飞行高度
        动画速度: 1.5,
        持续秒: 0.7,
      },
      连击窗口秒: 0.5, // 源：0.5 秒后若仍停留在当前连击段则复位按钮
    },
    连击2: {
      技能ID: Q连击2技能ID,
      技能类型ID: stringToFourCCSafe(Q连击2技能ID),
      音效: { 路径: "Sound\\HeroVoice\\Saber\\SaberQ2.mp3", 裁断距离: 1500 },
      伤害攻击力倍率: 0.5, // 重新快照攻击力×0.5
      时间流速: 2.0,
      动作索引: 2,
      前移距离: 75,
      第一段: {
        延迟秒: 0.3, // 源：0.30 秒后劈砍
        半径: 300,
        前方角度: 180,
        控制秒: 0.75, // 源 SFB_setBuff(21, 0.75)
        伤害倍率: 1.0, // 快照×1.0 = 攻击力×0.5
        命中特效: { 模型路径: "war3mapImported\\[ake]gaopin.mdx", 挂点: "origin", 持续秒: 0.35 },
        目标动作时间流速: 4.0,
        目标击退: { 每次距离: 10, 间隔秒: 0.02, 次数: 10 },
        刀光持续秒: 0.55,
      },
      过渡: {
        延迟秒: 0.35, // 源：0.35 秒后过渡动作
        动作索引: 7,
        前移距离: 75,
      },
      第二段: {
        延迟秒: 0.6, // 源：过渡后 0.60 秒第二段劈砍
        半径: 300,
        前方角度: 180,
        控制秒: 0.75,
        伤害倍率: 2.0, // 快照×2.0 = 攻击力×1.0（说明的 100% 链式口径）
        命中特效: { 模型路径: "war3mapImported\\[ake]gaopin.mdx", 挂点: "origin", 持续秒: 0.35 },
        目标动作时间流速: 4.0,
        目标击退: { 每次距离: 10, 间隔秒: 0.02, 次数: 10 },
        // 源在目标前方 75 创建 e061（MoonPunish，物编缩放1.5×运行时1.5）作为第二段表现
        表现特效: {
          模型路径: "war3mapImported\\MoonPunish.mdl",
          目标前方偏移: 75,
          缩放: 2.25, // 物编 1.5 × 运行时 SetUnitTimeScale(1.5) 的等效显示倍率（审计保留）
          持续秒: 0.5,
        },
      },
      连击窗口秒: 0.5,
    },
    连击3: {
      技能ID: Q连击3技能ID,
      技能类型ID: stringToFourCCSafe(Q连击3技能ID),
      音效: { 路径: "Sound\\HeroVoice\\Saber\\SaberQ3.mp3", 裁断距离: 1500 },
      伤害攻击力倍率: 0.5, // 重新快照攻击力×0.5
      时间流速: 1.65,
      动作索引: 10,
      前移距离: 75,
      上升: { 间隔秒: 0.03, 次数: 10, 每次高度: 20 }, // 启用飞行后上升
      第一段: {
        延迟秒: 0.35, // 源：0.35 秒后第一段劈砍
        半径: 300,
        前方角度: 180,
        控制秒: 1.0, // 源 SFB_setBuff(21, 1.0)
        伤害倍率: 2.0, // 快照×2.0 = 攻击力×1.0
        命中特效: { 模型路径: "war3mapImported\\[ake]gaopin.mdx", 挂点: "origin", 持续秒: 0.3 },
        目标动作时间流速: 4.0,
        目标击退: { 每次距离: 10, 间隔秒: 0.02, 次数: 10 },
      },
      过渡: {
        延迟秒: 0.25, // 源：0.25 秒后过渡
        动作索引: 3,
        前移距离: 75,
      },
      下降: { 间隔秒: 0.03, 次数: 10, 每次高度: -20 },
      第二段: {
        延迟秒: 0.55, // 源：过渡后 0.55 秒最终劈砍
        半径: 300,
        前方角度: 180,
        控制秒: 0.75, // 源 e00D 马甲施放 A0DI 风暴之锤 0.75 秒；迁移为同步控制（计划10.5）
        伤害倍率: 3.0, // 快照×3.0 = 攻击力×1.5，即说明的最后一段 150%
        命中特效: { 模型路径: "war3mapImported\\[ake]gaopin.mdx", 挂点: "origin", 持续秒: 0.35 },
        目标动作时间流速: 4.0,
        目标击退: { 每次距离: 10, 间隔秒: 0.02, 次数: 10 },
        刀光持续秒: 0.55,
      },
      复位延迟秒: 0.5, // 源：0.5 秒后 Q连击=0、恢复 A0DB、移除 A0DD、清空命中组
    },
  },

  // ===== W：风王铁锤（A0DE）双入口 =====
  W: {
    技能ID: W技能ID,
    技能类型ID: stringToFourCCSafe(W技能ID),
    物编基础冷却秒: 10,
    地面分支: {
      冷却秒: 7, // 源：地面分支把基础冷却改为 7
      冷却缩减上限: 0.3,
      传送最大距离: 300,
      气势特效: { 模型路径: "war3mapImported\\dustwaveanimate.mdl", 动画速度: 2.0, 持续秒: 2.0 },
      动作索引: 6,
      时间流速: 3.0,
      龙卷风: {
        启动延迟秒: 0.4, // 源：0.40 秒后创建 6 个龙卷风
        音效: { 路径: "Sound\\Units\\CombatSoundsFaked\\BansheeMissileLaunch2.wav", 裁断距离: 1500 }, // gg_snd_BansheeMissileLaunch2（待核对 soundlist）
        数量: 6,
        出生朝向步进度: 60, // 60°×序号
        模型路径: "Abilities\\Spells\\Other\\Tornado\\TornadoElemental.mdl", // e065 物编模型
        模型缩放: 0.78, // e065 物编 modelScale
        飞行高度: 50, // e065 物编 moveHeight
        推进间隔秒: 0.05,
        每Tick距离: 50,
        最大Tick数: 20,
        伤害半径: 175,
        伤害攻击力倍率: 2.0, // 说明 200%，与源一致；源 DAMAGE_TYPE_MIND
        控制: { 减速比例: 0.99, 减速秒: 2.0 }, // 说明：减速99%/2秒（源 id=0 硬直1.5秒，审计差异见计划17.2）
        重复组击退距离: 20, // 每 tick 对已命中单位按远离 Saber 方向击退
      },
    },
    E联动地面分支: {
      音效: { 路径: "Sound\\HeroVoice\\Saber\\Saber-EW1.mp3", 裁断距离: 1500 },
      动作索引: 7,
      路径: {
        Tick数: 12, // 源 12 个周期
        Tick间隔秒: 0.15,
        每Tick距离: 125, // 说明直线 1500 = 12×125（源为 100×12=1200，审计差异见计划17.3）
        伤害半径: 250, // 说明宽 500
      },
      表现特效: {
        模型路径: "war3mapImported\\MoonPunish.mdl", // e061 物编模型
        缩放: 7.5, // 物编 1.5 × 运行时 SetUnitScale(5)
        飞行高度: 100, // e061 物编 moveHeight
        朝向偏移: 90, // 源：路径角度 +90
        持续秒: 0.5,
      },
      首次控制秒: 2.0, // 说明硬直 2 秒（源 id=0 1.5 秒，以说明为准）
      持续伤害攻击力倍率: 0.5, // 源：重复组每周期攻击力×0.5（12 周期合计×6 = 说明 600%）
      持续击退距离: 30, // 源 GS_moveunit 30 沿路径方向
      无法闪避: true, // 说明：无法闪避；源通过记录/清零闪避率实现
    },
    敌人分支: {
      动作索引: 7,
      时间流速: 1.0,
      追击: {
        间隔秒: 0.05,
        每Tick距离: 70,
        最大Tick数: 10,
        捕捉半径: 140, // 目标进入 Saber 半径 140 即捕捉成功
      },
      主伤害攻击力倍率: 2.75,
      主控制秒: 1.0, // 源 SFB_setBuff(21, 1.0)
      目标击退距离: 70,
      目标动作时间流速: 5.0,
      命中特效: { 模型路径: "Objects\\Spawnmodels\\NightElf\\NEDeathMedium\\NEDeath.mdl", 挂点: "origin", 持续秒: 2.0 },
      E联动冲击波: {
        音效: { 路径: "Sound\\Abilities\\Weapons\\ChimaeraAcidMissile\\CorrosiveBreathMissileLaunch1.wav", 裁断距离: 1500 }, // gg_snd_CorrosiveBreathMissileLaunch1（待核对 soundlist）
        模型路径: "war3mapImported\\BladeShockwave.mdl", // e062 物编模型
        缩放: 10.0, // 物编 2 × 运行时 SetUnitScale(5)
        飞行高度: 90, // e062 物编 moveHeight
        推进间隔秒: 0.02,
        每Tick距离: 35,
        最大Tick数: 20, // 合计 700，与说明直线 700 一致
        伤害半径: 125, // 说明宽 250
        伤害攻击力倍率: 2.0, // 说明 200%，与源一致；源 DAMAGE_TYPE_PLANT
        重复组击退距离: 15,
      },
    },
  },

  // ===== E：魔力放出（A0DG） =====
  E: {
    技能ID: E技能ID,
    技能类型ID: stringToFourCCSafe(E技能ID),
    物编冷却秒: 18,
    冷却缩减上限: 0.33, // 介绍口径；war3map.lua 已有 Saber魔力放出 冷却上限记录
    持续秒: 8, // 源：0.25 秒周期 ×32，暂停期间计数不推进
    周期间隔秒: 0.25,
    最大计数: 32,
    攻击力加成比例: 0.25, // 开启时攻击力+25%（源 bonus type 3）
    武器特效: { 模型路径: "war3mapImported\\earthlyeminence.mdx", 挂点: "weapon" },
    周期特效: { 模型路径: "Abilities\\Spells\\NightElf\\MoonWell\\MoonWellCasterArt.mdl", 挂点: "weapon", 持续秒: 0.5 },
    普攻附加: {
      伤害比例: 0.25, // 当前攻击事件伤害×25% 追加魔法伤害
    },
  },

  // ===== R：誓约胜利之剑（A0DF） =====
  R: {
    技能ID: R技能ID,
    技能类型ID: stringToFourCCSafe(R技能ID),
    物编冷却秒: 15,
    起手: { 动作索引: 1 },
    蓄力: {
      间隔秒: 0.05,
      最大Tick数: 80, // 约 4 秒
      音效Tick: 78, // 第 78 周期播放 Excalibur 音效
      音效: { 路径: "Sound\\HeroVoice\\Saber\\SaberExcalibur.mp3", 裁断距离: 2500 },
      聚集粒子: {
        模型路径: "Abilities\\Weapons\\FaerieDragonMissile\\FaerieDragonMissile.mdl", // e063 物编模型
        每Tick数量: 3,
        随机半径上限: 720,
        上升段Tick数: 75, // 前 75 周期每 tick 高度 +18
        上升每次高度: 18,
        下降每次高度: -30,
        移除高度: 600,
      },
    },
    蓄力结束: {
      法阵特效: { 模型路径: "war3mapImported\\GainLife.mdl", 缩放: 3.0, 持续秒: 3.0, 朝向偏移: 90 }, // 非阿瓦隆阶段
      动作索引: 18,
      发射准备延迟秒: 1.7,
    },
    发射: {
      光束: { 模型路径: "war3mapImported\\[GH][MX]5.mdl", 缩放: 3.5, 持续秒: 2.0, 朝向偏移: 90 },
      能量准备延迟秒: 0.5, // 光束先于伤害 0.5 秒
      能量A: { 模型路径: "Abilities\\Spells\\Other\\Awaken\\Awaken.mdl", 缩放: 4.0, 动画速度: 0.75, 飞行高度: 100, 后方偏移: 75, 朝向偏移: 90 }, // e064
      能量B: { 模型路径: "war3mapImported\\Kaiserbreath.mdl", 缩放: 3.5, 动画速度: 0.9, 后方偏移: 275, 朝向偏移: 0, 蓝: 50 }, // e066（源 blue=50）
      能量重现Tick: [10, 20], // 源在光炮第 10/20 周期重新创建能量表现
    },
    光炮: {
      间隔秒: 0.02,
      最大Tick数: 40,
      每Tick距离: 50, // 伤害点 = Saber 点沿方向 50×循环数
      最大距离: 2000,
      伤害半径: 350, // 说明宽 700
      伤害攻击力倍率: 15.0, // 说明 1500%，每目标仅一次；源 DAMAGE_TYPE_DIVINE
      阿瓦隆伤害攻击力倍率: 10.0, // 阿瓦隆期间 ×10（15 的三分之二）
    },
  },

  // ===== D：遥远的理想乡（A0DH） =====
  D: {
    技能ID: D技能ID,
    技能类型ID: stringToFourCCSafe(D技能ID),
    物编冷却秒: 120,
    音效: { 路径: "Sound\\HeroVoice\\Saber\\Saber_Alter_D_Avalon.mp3", 裁断距离: 3000 },
    头顶特效: { 模型路径: "war3mapImported\\cauterize.mdx", 挂点: "overhead" },
    原点特效: { 模型路径: "war3mapImported\\HolyAurora.MDX", 挂点: "origin" },
    持续秒: 10,
    回蓝: {
      间隔秒: 0.1,
      最大Tick数: 100,
      已损失魔法比例: 0.02, // 每 0.1 秒恢复已损失魔法的 2%
    },
    粒子特效: { 模型路径: "war3mapImported\\Golden Light.mdl", 高度: 50, 缩放: 2.0, 持续秒: 1.0, 动画名: "Death" },
  },

  // 暂停来源命名（硬直暂停系统）
  暂停来源: {
    Q初段: "Saber-Q初段-施法硬直",
    Q连击2: "Saber-Q连击2-施法硬直",
    Q连击3: "Saber-Q连击3-施法硬直",
    W敌人追击: "Saber-W敌人-追击硬直",
    W地面E联动: "Saber-W地面E联动-施法硬直",
    R蓄力: "Saber-R-蓄力硬直",
  },

  说明:
    "Saber技能组配置。魔耗（固定+百分比 W8%/E15%/R60%）全部由统一魔耗系统经物编字段结算，技能文件不再扣蓝。" +
    "Q 未命中减 CD、W 地面 7 秒冷却走项目同步冷却接口；冲突审计保留在 Saber迁移计划.md。",
} as const;

export default Saber技能配置;
