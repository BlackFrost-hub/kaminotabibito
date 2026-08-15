/** @noSelfInFile */

export const 阿伦劳特单位技能配置 = {
  英雄名: "阿伦劳特",
  光形态单位ID: "H00F",
  暗形态单位ID: "H00G",
  主技能ID: "A0D6",
  引爆技能ID: "A0D3",
  Q技能ID: "A0D7",
  R技能ID: "A0D5",
  R二段技能ID: "A0D2",
  D技能ID: "A0D8",
  天堂呼唤强化BuffID: "B018",
  裁决审判强化BuffID: "B015",
  裁决制裁BuffID: "B019",
  切换加攻BuffID: "B017",
  裁决护盾标签: "阿伦劳特-裁决护盾",
  神圣护甲默认持续秒: 3,
  神圣护甲强化持续秒: 5,
  裁决护盾持续秒: 4,
  裁决护盾默认最大生命比例: 0.5,
  裁决护盾强化最大生命比例: 1,
  引爆范围: 400,
  引爆眩晕秒: 1,
  引爆击退距离: 400,
  引爆击退持续秒: 0.5,

  /** D 形态切换（源 切换.j） */
  D: {
    /** 切换间隔（物编 Cool=5s；图片口径 4s，暂以物编技能冷却为准，实测确认） */
    切换间隔秒: 4,
    /** 光切暗：恢复已损失生命 15% */
    恢复已损失生命比例: 0.15,
    /** 光切暗：2 秒内攻击力 +10% */
    切换加攻比例: 0.1,
    切换加攻持续秒: 2,
    /** 暗切光：0.5 秒免伤 */
    免伤秒: 0.5,
    /** 光形态属性：治疗加成 +10%、魔法伤害加成 +5% */
    光治疗加成: 0.1,
    光魔法伤害加成: 0.05,
    /** 暗形态属性：生命恢复增幅 +12%、受到治疗 +12% */
    暗生命恢复增幅: 0.12,
    暗受到治疗加成: 0.12,
    /** 属性 key（玩家级 YDUserData） */
    光治疗加成属性名: "技能治疗加成",
    光魔法伤害加成属性名: "魔法伤害加成",
    暗生命恢复增幅属性名: "生命恢复属性增幅",
    暗受到治疗加成属性名: "受到的治疗加成",
    /** 形态切换特效 */
    光切暗特效A: "war3mapImported\\Metamorphosis.mdl",
    光切暗特效B: "war3mapImported\\BloodSlam.mdl",
    暗切光特效A: "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl",
    暗切光特效B: "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl",
    切换特效持续秒: 2,
    /** 形态图标（源 YDWESetUnitAbilityDataString 204） */
    图标: {
      暗Q: "ReplaceableTextures\\CommandButtons\\BTNALLT-Q2.blp",
      暗E: "ReplaceableTextures\\CommandButtons\\BTNSoulGem.blp",
      暗W: "ReplaceableTextures\\CommandButtons\\BTNALLT-E2.blp",
      暗R: "ReplaceableTextures\\CommandButtons\\BTNALLT-R2.blp",
      暗D: "ReplaceableTextures\\CommandButtons\\BTNArthas.blp",
      光Q: "ReplaceableTextures\\CommandButtons\\BTNALLT-Q.blp",
      光E: "ReplaceableTextures\\CommandButtons\\BTNALLT-W.blp",
      光W: "ReplaceableTextures\\CommandButtons\\BTNALLT-E.blp",
      光R: "ReplaceableTextures\\CommandButtons\\BTNALLT-R.blp",
      光D: "ReplaceableTextures\\CommandButtons\\BTNHeroDeathKnight.blp",
    },
  },

  /** Q 神圣之光/裁决制裁（源 主要技能.j A0D7 分支） */
  Q: {
    /** 范围（目标点 500） */
    范围: 500,
    /** 光形态：治疗/伤害 攻击力 × 2.0 */
    光倍率: 2.0,
    /** 光形态主目标治疗：× 1.35 */
    光主目标治疗倍率: 1.35,
    /** 光形态主目标眩晕 0.5 秒 */
    光主目标眩晕秒: 0.5,
    /** 暗形态：伤害 攻击力 × 2.0 */
    暗倍率: 2.0,
    /** 暗形态主目标：× 1.25（图片口径 = JASS 2.5 分支） */
    暗主目标倍率: 1.25,
    /** 裁决审判 B015 时主目标额外：自身最大生命 × 8% */
    裁决审判额外生命比例: 0.08,
    /** 暗形态友军：3 秒内增加 20% 最大攻击力 */
    暗友军加攻比例: 0.2,
    暗友军加攻持续秒: 3,
    /** 暗形态主目标抽取：25% 最大生命 + 25% 最大魔法，供自身恢复 */
    抽取最大生命比例: 0.25,
    抽取最大魔法比例: 0.25,
    /** 抽取恢复倍率（JASS ×2） */
    抽取恢复倍率: 2,
    /** 光敌人特效：HolyBoltSpecialArt.mdl 挂 overhead */
    光敌人特效: "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl",
    光敌人特效持续秒: 1,
    /** 暗抽取弹道：AnnihilationMissile.mdl */
    暗抽取弹道特效: "Abilities\\Spells\\Undead\\OrbOfDeath\\AnnihilationMissile.mdl",
    暗抽取弹道缩放: 2,
    暗抽取弹道高度偏移: 100,
    暗抽取弹道每tick距离: 20,
    暗抽取弹道最大tick: 80,
    /** 暗敌人命中特效 */
    暗敌人特效: "war3mapImported\\[AKE]war3AKE.com - 1668370942454584199408155.mdx",
    暗敌人特效持续秒: 1,
    /** 暗友军加攻特效 FurorEffect.mdx */
    暗友军加攻特效: "war3mapImported\\FurorEffect.mdx",
    暗友军加攻特效持续秒: 0.3,
    /** 技能间隔 8.5 秒（物编） */
    技能间隔秒: 8.5,
  },

  /** R 天堂呼唤/裁决审判 + R2 裁决冲击 */
  R: {
    /** 光祈祷 3 秒（0.42 周期 × 7 次 ≈ 2.94s） */
    光祈祷周期秒: 0.42,
    光祈祷次数: 7,
    /** 光祈祷友军范围 500 */
    光友军范围: 500,
    /** 光祈祷每周期恢复：攻击力 × 0.5 */
    光周期治疗倍率: 0.5,
    /** 光祈祷完成后强化 6 秒 */
    光强化持续秒: 6,
    /** 光强化攻击力：+200%（增幅到 300%） */
    光强化攻击倍率: 2.0,
    /** 光强化魔法伤害降低 30%（用"技能伤害减少"属性表达） */
    光强化魔法减伤: 0.3,
    光强化魔法减伤属性名: "技能伤害减少",
    /** 暗汲取范围 1000 */
    暗汲取范围: 1000,
    /** 暗汲取：当前生命 7% */
    暗汲取比例: 0.07,
    /** 暗汲取固定 10 点强化伤害（源 JASS；图片未提，保留并记录） */
    暗汲取固定伤害: 10,
    /** 暗强化（B015 裁决审判）持续 6 秒 */
    暗强化持续秒: 6,
    /** 光起手特效 Andt.mdl 挂 origin */
    光起手特效: "Abilities\\Spells\\Other\\Andt\\Andt.mdl",
    光起手特效持续秒: 0.5,
    /** 光周期特效：ResurrectTarget.mdl 缩放 4 */
    光周期特效1: "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl",
    光周期特效1缩放: 4,
    光周期特效2: "war3mapImported\\[ake]hunsebo.mdx",
    光周期特效持续秒: 3,
    /** 光强化期间特效 Life Magic.mdl */
    光强化特效: "war3mapImported\\Life Magic.mdl",
    光强化特效持续秒: 6,
    /** 暗汲取命中特效 CrimsonWake.mdl */
    暗汲取命中特效: "war3mapImported\\CrimsonWake.mdl",
    暗汲取命中特效持续秒: 2,
    /** 暗汲取弹道：DeathCoilMissile.mdl + BloodElementalMissile.mdl */
    暗汲取弹道1: "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilMissile.mdl",
    暗汲取弹道2: "war3mapImported\\BloodElementalMissile.mdl",
    暗汲取弹道每tick距离: 17.5,
    暗汲取弹道最大tick: 60,
    暗汲取弹道Z偏移: 100,
    暗汲取弹道后方偏移: 75,
    /** 暗持续鲜血爆发特效 */
    暗持续特效: "war3mapImported\\[AKE]war3AKE.com - 0115207102182414463445274.mdx",
    暗持续特效持续秒: 1.5,
    /** 结束减速 20% / 3 秒 */
    结束减速比例: 0.2,
    结束减速持续秒: 3,
    /** 技能间隔 60 秒（物编） */
    技能间隔秒: 60,
  },

  /** R2 裁决冲击（源 主要技能.j A0D2 分支） */
  R2: {
    /** 血墙点距离（施法者前 750） */
    血墙点距离: 750,
    /** 弹幕推进：每 0.02s 移动 50 码，最多 30 次（600 码） */
    弹幕每tick距离: 50,
    弹幕最大tick: 30,
    /** 路径扫描半径 300 */
    路径扫描半径: 300,
    /** 图片口径：自身当前生命 100% + 目标已损失生命 20% */
    自身生命倍率: 1.0,
    目标损失生命倍率: 0.2,
    /** 眩晕 3 秒（图片口径） */
    眩晕秒: 3,
    /** 击退 1000（图片口径） */
    击退距离: 1000,
    击退持续秒: 0.6,
    /** 血墙特效 ChaosWall.mdx（缩放 2、绕 Z 旋转角度+90） */
    血墙特效: "war3mapImported\\ChaosWall.mdx",
    血墙缩放: 2,
    /** 冲击特效 Kaiserbreath.mdl（缩放 1.5、旋转施法方向） */
    冲击特效: "war3mapImported\\Kaiserbreath.mdl",
    冲击缩放: 1.5,
    /** 路径残留特效（每 tick 目标点） */
    路径特效: "war3mapImported\\[AKE]war3AKE.com - 2393717668992390622643867.mdx",
    路径特效持续秒: 0.5,
  },

  表现资源: {
    裁决护盾特效路径: "war3mapImported\\BigBlackOrbShield.mdx",
    裁决护盾引爆特效路径A: "war3mapImported\\[AKE]war3AKE.com - 2393717668992390622643867.mdx",
    裁决护盾引爆特效路径B: "war3mapImported\\BlackChakraExplosion.mdx",
    裁决护盾特效键: "阿伦劳特-裁决护盾",
    裁决护盾特效缩放: 1.75,
    裁决护盾特效高度: 90,
    引爆特效持续秒: 2,
  },
} as const;
