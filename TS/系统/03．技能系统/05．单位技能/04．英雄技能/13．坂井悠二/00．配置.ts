/** @noSelfInFile */
// 坂井悠二（U2 / H00M）技能组配置
// 物编数据来源：map/table/unit.ini、ability.ini、imp.ini
// 时点真源：JASS/部分地图编辑器GUI的英雄jass代码/坂井悠二/{技能,D技能}.j
// 最终行为真源：5张技能介绍图片；冲突以图片+本文件为准

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查玩家英雄单位ID } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置") as {
  按名字反查玩家英雄单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查技能ID } = require("系统.03．技能系统.08．技能数据表.01．技能名反查") as {
  按名字反查技能ID: (this: void, name: string) => string | undefined;
};

const 英雄名 = "U2";

// 技能名严格匹配 ability.ini 中的 Name 字段（反查器会自动剥离颜色码）
const Q技能名 = "Sakaiyuuji-吸血鬼（Q）";
const W技能名 = "Sakaiyuuji-银之监牢（W）";
const E技能名 = "Sakaiyuuji-Grammatica（语法）（E）";
const R技能名 = "sakaiyuuji神门（R）";
const R二段技能名 = "sakaiyuuji胧天震（R）";
const D技能名 = "sakaiyuuji祭礼之蛇（D）";

const 英雄单位ID = 按名字反查玩家英雄单位ID(英雄名);
const Q技能ID = 按名字反查技能ID(Q技能名) ?? "A0E8";
const W技能ID = 按名字反查技能ID(W技能名) ?? "A0E9";
const E技能ID = 按名字反查技能ID(E技能名) ?? "A0EA";
const R技能ID = 按名字反查技能ID(R技能名) ?? "A0ED";
const R二段技能ID = 按名字反查技能ID(R二段技能名) ?? "A0EC";
const D技能ID = 按名字反查技能ID(D技能名) ?? "A0EB";

if (英雄单位ID == null || 英雄单位ID === "") {
  throw new Error("无法反查英雄单位ID：" + 英雄名);
}

export const 坂井悠二技能配置 = {
  英雄名,
  单位ID: 英雄单位ID,
  单位类型ID: stringToFourCCSafe(英雄单位ID),

  // ===== Q 吸血鬼 =====
  Q: {
    快捷键序号: 1,
    技能ID: Q技能ID,
    技能类型ID: stringToFourCCSafe(Q技能ID),

    // 被动：普通攻击额外造成 10% 攻击力暗魔法伤害
    被动: {
      攻击力倍率: 0.10,
      伤害属性: "暗" as const,
    },

    // 主动：直线黑暗冲击波
    // 源结构（2026-08-17 修正）：外层 0.21s ×5 段，每段在施法者位置固定创建 e06T 马甲（特效不推进）；
    // 每段内层 0.01s ×20 tick 从施法者位置沿施法方向推进伤害判定点 40码/tick，半径 175 枚举，段内去重。
    主动: {
      总伤害攻击力倍率: 3.00, // 300% 攻击力
      段数: 5, // 源 JASS 外层循环实数 >= 5.00 退出
      单段伤害比例: 0.20, // 每次命中 20%，段间不去重（可重复命中），段内去重
      段间隔秒: 0.21, // 源外层周期 0.21 秒
      扫描间隔秒: 0.01, // 源内层周期 0.01 秒
      扫描次数: 20, // 源内层循环实数2 >= 20.00 退出
      每次扫描推进距离: 40, // 源 PolarProjectionBJ(saber点, 40×循环实数2, 角度)
      命中半径: 175, // 枚举半径
      施法距离: 800,
      魔耗最大魔法比例: 0.05, // 5% 最大魔法值
      冷却秒: 8,
      伤害属性: "暗" as const,

      // 命中控制：几乎无法移动 1秒（源 JASS SetUnitMoveSpeed 0 + 1秒后恢复默认）
      命中控制: {
        暂停来源: "坂井悠二-Q-命中定身",
        控制秒: 1.00,
      },

      // e06T 吸血鬼壳（坂井悠二原壳例外：照抄，不改成直接特效）
      壳: {
        单位ID: "e06T",
        朝向偏移角度: 90, // 朝向 = 施法方向 + 90
        飞行高度增量: 100, // 源 e06T 默认飞行高度 100
        模型路径: "war3mapImported\\ShadowAssault.mdl",
        缩放: 2.0,
      },
    },
  },

  // ===== W 银之监牢 =====
  W: {
    快捷键序号: 2,
    技能ID: W技能ID,
    技能类型ID: stringToFourCCSafe(W技能ID),
    施法距离: 600,
    冷却秒: 11,
    魔耗最大魔法比例: 0.15, // 15% 最大魔法值
    眩晕秒: 2.0, // 源 JASS SFB_setBuff 2秒
    眩晕暂停来源: "坂井悠二-W-银之监牢",
    伤害攻击力倍率: 3.50, // 350% 攻击力
    伤害结算延迟秒: 0.50, // 源 JASS 0.50秒后伤害；按用户决策 B 立即眩晕+立即伤害+2秒眩晕持续
    伤害属性: "暗" as const,

    // 三段直接特效：立即创建、各持续1秒；按源 JASS 顺序 AbstruseEnergy → DarkBreathStream → ShadowAssault
    三段特效: [
      { 模型路径: "war3mapImported\\AbstruseEnergy.mdx", 持续秒: 1.0 },
      { 模型路径: "war3mapImported\\DarkBreathStream.mdx", 持续秒: 1.0 },
      { 模型路径: "war3mapImported\\ShadowAssault.mdx", 持续秒: 1.0 },
    ],

    // 音效：源 PlaySoundOnUnitBJ(gg_snd_ReviveUndead, 目标)，照源用全局音效句柄
    音效: {
      全局音效键: "gg_snd_ReviveUndead",
    },

    // e008 银之监牢马甲（迁移计划允许优化为 TS 控制 + 直接特效）
    壳优化为控制特效: {
      启用: true,
      缩放倍率: 2.0, // 源 JASS 目标 modelScale × 2
    },
  },

  // ===== E Grammatica「语法」=====
  E: {
    快捷键序号: 3,
    技能ID: E技能ID,
    技能类型ID: stringToFourCCSafe(E技能ID),
    施法距离: 500,
    冷却秒: 8,
    魔耗最大魔法比例: 0.05, // 5% 最大魔法值
    启动延迟秒: 0.05, // 源 JASS 0.05秒后执行

    // 敌方目标分支：瞬移+眩晕
    敌人分支: {
      眩晕秒: 0.5,
      眩晕暂停来源: "坂井悠二-E-语法眩晕",
      传送特效: {
        模型路径: "war3mapImported\\DGate.MDX",
        持续秒: 1.0,
        缩放: 0.35,
        动画速度: 3.0,
      },
    },

    // 自施法分支：抵挡Buff
    自施法分支: {
      持续秒: 1.5,
      减伤比例: 0.75, // 75%
      单次伤害阈值最大生命比例: 0.20, // 单次伤害 >= 20% maxHP 破除
      BuffID: "坂井悠二-E-抵挡",
      破除特效: {
        模型路径: "war3mapImported\\ancientexplodeblue.mdx",
        持续秒: 2.0,
      },
      音效: {
        全局音效键: "gg_snd_SpellShieldImpact1", // 源 gg_snd_SpellShieldImpact1，照源用全局音效句柄
      },
    },

    // 目标点分支（2026-08-17 修正：源用辅助马甲 0.01s×20 tick 每步 25 码探测地形，TS 改为提前计算路径后一次性瞬移；
    // 撞墙停在地形前且不播放落点特效，无撞墙瞬移到落点并播放落点特效）
    目标点分支: {
      探测步长: 25, // 源每步 25 码
      最大探测步数: 20, // 源最多 20 步（500 码）
      传送特效: {
        模型路径: "war3mapImported\\DGate.MDX",
        持续秒: 1.0,
        缩放: 0.35,
        动画速度: 3.0,
      },
    },
  },

  // ===== R 神门 =====
  R: {
    快捷键序号: 4,
    技能ID: R技能ID,
    技能类型ID: stringToFourCCSafe(R技能ID),
    施法距离: 800,
    冷却秒: 60,
    额外魔耗最大魔法比例: 0.30, // 30% 额外消耗

    // 持续时间按图片 7 秒（A0ED 物编 level 1 = 7秒）
    持续秒: 7.0,
    刷新E技能冷却: true,

    // 神门单位（承载单位，迁移计划保留）
    // 2026-08-17 修正：源 JASS 'e001' 是旧 ID，当前物编不存在（大写 E001 是十六夜咲夜英雄）；
    // 真身为 e06S（编辑器后缀“神门”，sichongjiejie_b.mdl，缩放 1.5，飞行 moveHeight=1300，HP10/回血-1 限时寿命，Aloc）
    神门单位: {
      单位ID: "e06S",
      // 2026-08-17 二轮修正：源 = 施法者高度 + GetUnitDefaultFlyHeight(神门)，即 moveHeight 1300；
      // 运行时创建的飞行单位 moveHeight 不自动生效，必须显式 SetUnitFlyHeight（此前高度偏低根源）
      飞行高度增量: 1300,
    },

    // 周期伤害
    周期: {
      周期间隔秒: 0.25,
      单次伤害攻击力倍率: 0.50, // 50% 攻击力
      随机落点半径: 400,
      单次伤害属性: "暗" as const,
      制裁特效: [
        { 模型路径: "war3mapImported\\DarknessMeteor.mdx", 缩放: 2.0, 动画速度: 2.0, 持续秒: 0.35 },
        { 模型路径: "war3mapImported\\ShadowSpine.mdx", 动画速度: 2.48, 持续秒: 0.35 },
      ],
      落点音效: {
        全局音效键: "gg_snd_StormBoltLaunch", // 源 JASS PlaySoundOnUnitBJ(gg_snd_StormBoltLaunch)，war3map.j 已注册
      },
      伤害延迟结算秒: 0.35, // 源 JASS 0.35秒后结算
      伤害判定半径: 250,
    },

    // 二段：胧天震（英雄等级 ≥ 20 开放，按用户决策 A）
    // 2026-08-17 用户纠正：二段是无目标技能（物编确认），伤害/特效中心 = 一段 R 的神门位置，
    // 不是施法目标点；禁止改物编目标类型
    二段: {
      技能ID: R二段技能ID,
      技能类型ID: stringToFourCCSafe(R二段技能ID),
      解锁英雄等级: 20,
      // 魔法检测条件已按用户要求删除（魔耗由物编 A0EC Cost=300 引擎自动扣）

      // 周期伤害：源 JASS 0.50秒/次，单次 50% 攻击力；物编 Ubertip 100%/秒
      持续秒: 5.0,
      周期间隔秒: 0.50,
      单次伤害攻击力倍率: 0.50,
      伤害属性: "暗" as const,
      减速比例: 0.30, // 30% 减速
      减速控制秒: 0.60, // 源 JASS A0EE 0.6秒 slow
      减速暂停来源: "坂井悠二-R2-胧天震减速",
      范围: 400,

      // 区域表现
      区域特效: {
        模型路径: "war3mapImported\\mantid_beaconlight_sha.mdx",
        持续秒: 5.0,
      },

      // 每秒 5 个冲击特效，持续 10 秒（源 JASS 外层 0.50s tick×10次 = 5s）
      冲击: {
        每秒数量: 5,
        冲击特效: { 模型路径: "war3mapImported\\!orbitalray2!.mdx", 缩放: 2.5, 持续秒: 1.0, 随机角度最小: 10, 随机角度最大: 45 },
        冲击震荡特效: { 模型路径: "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", 缩放: 2.0, 持续秒: 1.0, 随机角度最小: 10, 随机角度最大: 45 },
        随机半径最小: 25,
        随机半径最大: 325,
        地形特效: { 模型路径: "war3mapImported\\EarthSmash(noSmashGround).mdx", 缩放: 3.0, 持续秒: 1.0 },
      },

      音效: {
        // 每 tick 播放，走音效池严格 4 句柄轮转叠放（Sound3DII_Mp3Play，防泄漏）；
        // 路径对应 war3map.j 注册的 gg_snd_effect_sound12
        路径: "war3mapImported\\effect_sound12.mp3",
      },
    },
  },

  // ===== D 祭礼之蛇 =====
  D: {
    快捷键序号: 5,
    技能ID: D技能ID,
    技能类型ID: stringToFourCCSafe(D技能ID),
    冷却秒: 90,
    魔耗: 50,

    // 前置条件：神门阶段==4、英雄等级≥40、力量>300
    条件: {
      最低英雄等级: 40,
      最低力量: 300,
      失败提示: "条件未满足：需要等级≥40且力量>300，且神门已开启",
    },

    持续秒: 10.0,
    英雄飞行高度增量: 500,

    // D 期间效果
    期间: {
      暗属性伤害: 0.30,
      E技能冷却秒: 2.50, // D 期间 E 冷却固定为 2.5秒
      移速最大化技能ID: "A01P", // 物编：移速最大化（522）
    },

    // 鼓舞（800范围友军，不含自己）
    鼓舞: {
      范围: 800,
      攻击力基础倍率: 1.00, // 100% 基础攻击力
      移动速度加值: 20,
      更新周期秒: 1.0, // 源 JASS 1秒刷新
      BuffID: "坂井悠二-D-鼓舞",
    },

    // D 结束后恢复 E 冷却为 8秒
    结束恢复E冷却秒: 8.0,

    // 过去备份地图中的源 e06V dummy；origin 挂点姿态用于正确拼接蛇头与蛇身。
    马甲载体模型路径: "Common\\Model\\Dummy\\SakaiYuujiD\\dummy.mdx",
    马甲模型刷新等待秒: 0.05,

    // 第一层马甲（照抄坂井悠二原壳例外）
    马甲一: {
      // 源马甲类型 e06V：专用源 dummy、基础缩放 1.00、X/Y 最大旋转角 0、origin 挂点。
      单位类型ID: "e06V",
      HP保障值: 99999,
      动画编号: 0,
      时间缩放: 20.0,
      缩放: 1.20,
      颜色: { 红: 100, 绿: 100, 蓝: 100, 透明度: 70 },
      飞行高度增量: 200,
      特效: { 模型路径: "war3mapImported\\SakaiYuji_Snake_DAce(Head).mdx", 挂点: "origin" }, // 2026-08-17 修正：实际资源为 .mdx，原写 .mdl 导致蛇特效不显示
      绑定技能1: "S00B", // 源全局“技能”真身（ability.ini 存在，光环类）；“技能2”在当前地图无注册，不接入
      绑定技能2: "",
    },

    // 第二层马甲 ×5（照抄坂井悠二原壳例外）
    马甲二: {
      数量: 5,
      单位类型ID: "e06V",
      动画编号: 0,
      时间缩放: 20.0,
      缩放: 4.0,
      颜色: { 红: 100, 绿: 100, 蓝: 100, 透明度: 70 },
      飞行高度增量: 300,
      特效: [
        { 模型路径: "war3mapImported\\SakaiYuji_Snake_DAce.mdx", 挂点: "origin" }, // 2026-08-17 修正：.mdl → .mdx
        { 模型路径: "war3mapImported\\Beam(GreenBlack).mdx", 挂点: "origin" }, // 2026-08-17 修正：.mdl → .mdx
      ],
      // 各马甲初始参数（源 JASS ydul_i=1..5）
      初始: [
        { 距离: 600, 角度: 0, 面向角度: 180 },
        { 距离随机: [400, 1000] as [number, number], 角度随机: [1, 60] as [number, number], 面向角度: 90 },
        { 距离随机: [400, 1000] as [number, number], 角度随机: [1, 60] as [number, number], 面向角度随机: [-90, 90] as [number, number] },
        { 距离随机: [400, 1000] as [number, number], 角度随机: [1, 60] as [number, number], 面向角度随机: [-90, 90] as [number, number] },
        { 距离随机: [400, 1000] as [number, number], 角度随机: [1, 60] as [number, number], 面向角度随机: [-90, 90] as [number, number] },
      ],
      更新周期秒: 0.05,
    },
  },

  说明: "坂井悠二技能组配置。W 采用源 JASS 立即眩晕+立即伤害行为；R 二段解锁等级≥20。标有「待查」的字段需在实现前从 map/table/ 或项目封装核对后回填。",
} as const;
