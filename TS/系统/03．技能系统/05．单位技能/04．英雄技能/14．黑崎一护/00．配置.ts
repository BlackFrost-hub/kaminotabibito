/** @noSelfInFile */
// 黑崎一护（E006）技能组配置。
// 迁移真源：JASS\部分地图编辑器GUI的英雄jass代码\黑崎一护\{技能,被动,开启R之后的A键黑流牙突}.j
// 冲突口径与差异审计见 黑崎一护迁移计划.md；源 JASS 审计值保留在注释中。

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查玩家英雄单位ID } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置") as {
  按名字反查玩家英雄单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查技能ID } = require("系统.03．技能系统.08．技能数据表.01．技能名反查") as {
  按名字反查技能ID: (this: void, name: string) => string | undefined;
};

const 英雄名 = "黑崎一护";

// 技能名严格匹配技能数据表 Name 字段（反查器自动剥离颜色码）。
const Q技能名 = "YH-月牙天冲（Q）";
const R技能名 = "YH-解放（R）";
const D技能名 = "YH瞬步（D）";
const T技能名 = "YH地蹦裂击（T）";
const W技能名 = "YH灵压爆发（W）";
const E技能名 = "YH瞬步斩（E）";

// 单位表的 Name 是“死神”，“黑崎一护”是该英雄的显示/别名。
const 英雄单位ID = 按名字反查玩家英雄单位ID(英雄名)
  ?? 按名字反查玩家英雄单位ID("死神");
const Q技能ID = 按名字反查技能ID(Q技能名) ?? "A01G";
const R技能ID = 按名字反查技能ID(R技能名) ?? "A01H";
const D技能ID = 按名字反查技能ID(D技能名) ?? "A01I";
const T技能ID = 按名字反查技能ID(T技能名) ?? "A01J";
const W技能ID = 按名字反查技能ID(W技能名) ?? "A01K";
const E技能ID = 按名字反查技能ID(E技能名) ?? "A01L";

if (英雄单位ID == null || 英雄单位ID === "") {
  throw new Error("无法反查英雄单位ID：" + 英雄名);
}

export const 黑崎一护技能配置 = {
  英雄名,
  单位ID: 英雄单位ID,
  单位类型ID: stringToFourCCSafe(英雄单位ID),

  // ===== Q：月牙天冲（A01G） =====
  Q: {
    技能ID: Q技能ID,
    技能类型ID: stringToFourCCSafe(Q技能ID),
    物编冷却秒: 8,
    射程码: 1500, // 源：0.02s × 50 tick × 30 码 = 1500
    推进间隔秒: 0.02,
    每Tick距离: 30,
    最大推进次数: 50,
    碰撞半径: 200, // 源：马甲点 200 范围内判碰撞，每目标仅命中一次
    未解放: {
      伤害攻击力倍率: 2.5, // 介绍 250%
      音效: { 路径: "Sound\\war3mapImported\\yueyatianchongyinxiao.mp3", 裁断距离: 2000 },
      弹道模型: "Abilities\\Weapons\\WingedSerpentMissile\\WingedSerpentMissile.mdl", // 马甲 e012
      弹道缩放: 5,
      弹道高度: 220,
      弹道X轴角度: -90, // 物编 maxRoll=-90
      拖尾模型: "Abilities\\Weapons\\Bolt\\BoltImpact.mdl",
      拖尾缩放: 2,
      拖尾高度: 160, // 源：160 + 施法者飞行高度（施法者飞行高度按 0 处理）
      拖尾持续秒: 0.3,
      拖尾副模型: "Abilities\\Weapons\\GryphonRiderMissile\\GryphonRiderMissile.mdl",
      拖尾副持续秒: 0.02,
    },
    解放后: {
      伤害攻击力倍率: 3.5, // 介绍 350%
      音效: { 路径: "Sound\\war3mapImported\\YH-yueya.mp3", 裁断距离: 2000 },
      弹道模型: "war3mapImported\\!blackgetsuga!.mdl", // 马甲 e00P
      弹道缩放: 2,
      弹道高度: 240,
      弹道X轴角度: -90,
      拖尾模型: "Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaosDone.mdl",
      拖尾缩放: 1.8,
      拖尾高度: 160,
      拖尾持续秒: 0.3,
      拖尾副模型: "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl",
      拖尾副缩放: 1.8,
      拖尾副持续秒: 0.3,
      虚影模型: "Abilities\\Spells\\Undead\\CarrionSwarm\\CarrionSwarmDamage.mdl", // 马甲 e013
      虚影缩放: 1.5,
      虚影高度: 240,
      无视护甲: true, // 介绍：解放后无视100%护甲（按源口径挂 player 属性，伤害系统 getBoolAttr 回退读玩家属性）
    },
  },

  // ===== W：灵压爆发（A01K） =====
  W: {
    技能ID: W技能ID,
    技能类型ID: stringToFourCCSafe(W技能ID),
    物编冷却秒: 10,
    半径码: 400,
    伤害攻击力倍率: 1.75, // 介绍 175% 雷属性
    音效: { 路径: "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.wav", 裁断距离: 2000 },
    主特效: { 模型: "war3mapImported\\Whine.mdl", 缩放: 2, 持续秒: 2 },
    爆发特效: { 模型: "war3mapImported\\TX25.mdl", 缩放: 0.15, 持续秒: 2 },
    普通: {
      眩晕秒: 2, // 源：A01N 单体眩晕2秒
      击退总距离: 300, // 源：15 码 × 20 tick
    },
    连携: {
      眩晕秒: 3, // 源：A01O 单体眩晕3秒（介绍：眩晕时间提高1秒）
      击退总距离: 500, // 源：25 码 × 20 tick
      击退持续时间秒: 0.4, // 源：0.02s × 20 tick
      附加特效: { 模型: "war3mapImported\\!orbitalray2!.mdl", 缩放: 4, 持续秒: 2 },
    },
  },

  // ===== E：瞬步斩（A01L） =====
  E: {
    技能ID: E技能ID,
    技能类型ID: stringToFourCCSafe(E技能ID),
    物编冷却秒: 13,
    音效: { 路径: "Sound\\HeroVoice\\ichigo\\yh-w.mp3", 裁断距离: 1500 },
    金属音效: { 路径: "Sound\\Units\\Combat\\MetalMediumSliceWood1.wav", 裁断距离: 1500 },
    普通: {
      斩击间隔秒: 0.15,
      斩击次数: 10, // 源 Func007T 循环 10 次（1.5 秒）
      斩击半径: 425,
      单次伤害攻击力倍率: 0.1, // 每 tick 10%，50% 概率触发攻击效果
      减速比例: 0.2, // 源 SFB_setSlow(unit, 0, 0.20, 0.40)
      减速持续秒: 0.4,
      斩击特效: { 模型: "Common\\Effect\\Form\\Line\\coarse slash blue.mdx", 缩放: 1.75, 持续秒: 1 },
      斩击音效: { 路径: "Sound\\YX\\DJYX01.wav", 裁断距离: 1500 },
      结束: {
        伤害攻击力倍率: 1.2, // 合计 10×0.1 + 1.2 = 220%（介绍口径）
        眩晕秒: 1.5, // 介绍：结束后造成1.5秒眩晕
        特效模型: "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",
        特效缩放: 2,
        特效持续秒: 1,
        音效: { 路径: "Sound\\war3mapImported\\shenlei01.mp3", 裁断距离: 2000 },
      },
    },
    连携: {
      目标选取半径: 200, // 介绍口径（源枚举半径 240，差异审计见计划）
      幻影半径: 240,
      幻影数量: 6,
      幻影模型: "war3mapImported\\Ichigo.mdl", // 马甲 e015
      幻影缩放: 1.3,
      幻影高度: 135,
      幻影透明度: 125,
      起手眩晕秒: 2, // 源：起手 眩晕2秒 技能（辅助马甲 thunderbolt）
      冲锋延迟秒: 0.2, // 源 +0.20s 幻影播放 Spell 后启动
      推进间隔秒: 0.03,
      每Tick距离: 30,
      最大推进次数: 20,
      命中判定半径: 150, // 幻影距目标 150 内命中
      单次伤害攻击力倍率: 0.6, // 0.6 × (1 + 当前魔法/最大魔法)，6 幻影合计 3.6×(1+x)（介绍 360%）
      命中特效解放前: { 模型: "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", 缩放: 1.5, 持续秒: 2, 高度: 50 },
      命中特效解放后: { 模型: "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl", 缩放: 1.5, 持续秒: 2, 高度: 50 },
      起手特效: { 模型: "Abilities\\Spells\\Items\\AIvi\\AIviTarget.mdl", 缩放: 1, 持续秒: 1 },
      结束: {
        魔法扣除最大比例: 0.2, // 介绍：结束后固定消耗20%最大魔法值
        鲜血爆炸模型: "war3mapImported\\CrimsonWake.mdl",
        鲜血爆炸持续秒: 1.2,
      },
    },
  },

  // ===== D：瞬步（A01I） =====
  D: {
    技能ID: D技能ID,
    技能类型ID: stringToFourCCSafe(D技能ID),
    物编冷却秒: 5,
    音效: { 路径: "Sound\\YX\\DJ10.mp3", 裁断距离: 2000 },
    基础距离: 450,
    每千魔法加成距离: 50, // 450 + (最大魔法/1000) × 50
    冲锋持续时间秒: 0.15, // 源 RushSlide(0.05,0.01) 近似滑移，取 0.15 保证地形检查生效
    连携窗口秒: 2, // 源：瞬步后 2 秒内 瞬步连携开关为真
    // 5% 最大魔法消耗由统一魔耗系统按物编百分比字段处理，技能文件不重复扣除（计划第 4 节）。
  },

  // ===== T：地蹦裂击（A01J） =====
  T: {
    技能ID: T技能ID,
    技能类型ID: stringToFourCCSafe(T技能ID),
    物编冷却秒: 30,
    半径码: 500,
    准备第一延迟秒: 0.15, // 源：0.15s 后播放动作/减伤
    准备第二延迟秒: 0.6, // 源 0.55；0.15+0.6=0.75 对齐介绍“0.75秒准备”
    硬直持续秒: 3.5, // 源 GS_Suspend 3.5
    动作索引: 8, // 源 SetUnitAnimationByIndex 8
    受伤减少比例: 0.5, // player 属性“受到伤害减少” +0.5
    周期: {
      间隔秒: 0.5,
      次数: 6, // 3 秒
      减速比例: 0.9, // 介绍：移速90%、攻速90%（源 SFB_setSlow(unit,0,0.9,1.0) 每秒刷新）
      减速持续秒: 1,
      踩地特效: { 模型: "war3mapImported\\stomp.mdl", 缩放: 3, 持续秒: 2 },
      裂地特效: { 模型: "war3mapImported\\~t_cleave.mdl", 缩放: 2, 持续秒: 2 },
    },
    卍解免打断血量阈值: 0.5, // 介绍：卍解且血量高于50%不会被敌人打断
  },

  // ===== R：天锁斩月/解放（A01H） =====
  R: {
    技能ID: R技能ID,
    技能类型ID: stringToFourCCSafe(R技能ID),
    物编冷却秒: 65,
    持续秒: 30,
    移速: 666, // 介绍：移动速度提高到666（源 DYCultrams 666 → TS 移速突破系统）
    起手音效: { 路径: "Sound\\war3mapImported\\0000YHR1.mp3", 裁断距离: 2500 },
    卍解延迟秒: 0.98, // 源 +0.98s 进入卍解
    卍解音效: { 路径: "Sound\\war3mapImported\\0000YHR2.mp3", 裁断距离: 2500 },
    卍解特效: { 模型: "war3mapImported\\chaosexplosion.mdl", 缩放: 1.1, 持续秒: 2, 高度: 40 },
    // 源倒计时文字（TextTag）为本地表现，TS 不迁移（差异审计见计划）。
    // 源“卍解特效”马甲单位类型无法反查，仅保留 chaosexplosion 表现（差异审计见计划）。
  },

  // ===== A键：黑流牙突（R 开启后） =====
  黑流牙突: {
    最小距离码: 500,
    最大距离码: 1200,
    标记持续秒: 5, // 每目标独立 5 秒触发时间（YDUserData unit 表“黑流牙突”）
    出生偏移码: 75, // 施法者后方 75 码（源角度读取顺序缺陷按“反向75码”口径修正，见计划）
    特效模型: "Abilities\\Spells\\Other\\BlackArrow\\BlackArrowMissile.mdl", // 壳参数：缩放3.0/高度135
    特效缩放: 3,
    特效高度: 135,
    推进间隔秒: 0.02,
    每Tick距离: 30,
    最大推进次数: 50, // 源：循环实数 >= 50 视为未命中收尾
    命中半径码: 150,
    推进特效: { 模型: "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl", 持续秒: 0.05 },
    命中特效: { 模型: "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl", 缩放: 1.5, 持续秒: 2, 高度: 135, 面向角度: 270 },
    基础伤害倍率: 1.2, // 攻击力 × (1.20 + 0.02 × 英雄等级)
    每级伤害加成: 0.02,
  },

  // ===== 被动：卍解普攻缩减月牙天冲冷却 =====
  被动: {
    Q冷却缩减秒: 0.55, // 介绍：每次普攻减少0.55秒冷却时间
    Q冷却剩余阈值秒: 0.55, // 源：剩余 > 0.50 才缩减（TS 按缩减量对齐为 >= 0.55）
  },

  暂停来源: {
    T施法硬直: "黑崎一护-T地蹦裂击-施法硬直",
  },
};

export default 黑崎一护技能配置;
