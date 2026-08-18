/** @noSelfInFile */

export const 阿伦劳特单位技能配置 = {
  英雄名: "阿伦劳特",
  光形态单位ID: "H00F",
  暗形态单位ID: "H00G",
  /** W 神圣护甲/裁决护盾（A0D6，物编 W 键） */
  W技能ID: "A0D6",
  /** E 光之裁决/裁决吸引（A0D4，物编 E 键） */
  E技能ID: "A0D4",
  引爆技能ID: "A0D3",
  Q技能ID: "A0D7",
  R技能ID: "A0D5",
  R二段技能ID: "A0D2",
  D技能ID: "A0D8",
  天堂呼唤强化BuffID: "B018",
  天堂呼唤强化技能ID: "S007",
  裁决审判强化BuffID: "B015",
  裁决审判强化技能ID: "S005",
  裁决制裁BuffID: "B019",
  裁决制裁技能ID: "S006",
  切换加攻BuffID: "B017",
  切换加攻技能ID: "S008",
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
    光治疗加成属性名: "技能治疗率",
    光魔法伤害加成属性名: "魔法伤害",
    暗生命恢复增幅属性名: "生命恢复效率",
    暗受到治疗加成属性名: "受到的治疗率",
    /** 形态切换特效 */
    光切暗特效A: "war3mapImported\\Metamorphosis.mdl",
    光切暗特效B: "war3mapImported\\BloodSlam.mdl",
    暗切光特效A: "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl",
    暗切光特效B: "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl",
    切换特效持续秒: 2,
    /** 形态图标（源 YDWESetUnitAbilityDataString 204） */
    图标: {
      暗Q: "ReplaceableTextures\\CommandButtons\\BTNALLT-Q2.blp",
      暗E: "ReplaceableTextures\\CommandButtons\\BTNALLT-E2.blp",
      暗W: "ReplaceableTextures\\CommandButtons\\BTNSoulGem.blp",
      暗R: "ReplaceableTextures\\CommandButtons\\BTNALLT-R2.blp",
      暗D: "ReplaceableTextures\\CommandButtons\\BTNArthas.blp",
      光Q: "ReplaceableTextures\\CommandButtons\\BTNALLT-Q.blp",
      光E: "ReplaceableTextures\\CommandButtons\\BTNALLT-E.blp",
      光W: "ReplaceableTextures\\CommandButtons\\BTNALLT-W.blp",
      光R: "ReplaceableTextures\\CommandButtons\\BTNALLT-R.blp",
      光D: "ReplaceableTextures\\CommandButtons\\BTNHeroDeathKnight.blp",
    },
  },

  /** E 光之裁决/裁决吸引（源 主要技能.j A0D4 分支，物编 E 键） */
  E: {
    /** 光形态：冲锋每 tick 移动 60 码（0.05s 周期） */
    冲锋每tick距离: 60,
    冲锋周期秒: 0.05,
    /** 光形态：主目标 300% 攻击力魔法伤害（非天堂审判） */
    光主目标倍率: 3.0,
    /** 光形态：300 范围溅射 150% 攻击力（非天堂审判） */
    光溅射倍率: 1.5,
    /** 光形态天堂审判（B018）：主目标必定暴击 200% 攻击力 */
    光天堂审判主目标倍率: 2.0,
    /** 光形态天堂审判：溅射 200% 攻击力 */
    光天堂审判溅射倍率: 2.0,
    /** 光形态天堂审判：溅射击退 */
    光天堂审判溅射击退距离: 300,
    光天堂审判溅射眩晕秒: 1,
    /** 光形态：结算前动画延迟（非天堂审判 0.27s） */
    光结算延迟秒: 0.27,
    /** 光形态：到达目标攻击范围判定（×1 进入结算判定） */
    光到达范围倍数: 1,
    /** 光形态：移动距离阈值（距离/60 决定冲锋次数；距离<攻击范围直接结算） */
    光冲锋次数上限: 20,
    /** 残影 e060：0.35s 销毁，顶点色 100/100/100/80 */
    残影持续秒: 0.35,
    残影红: 100,
    残影绿: 100,
    残影蓝: 100,
    残影透明: 80,
    /** 暗形态：目标周围 450 收集范围 */
    暗收集范围: 450,
    /** 暗形态：吸引周期 0.04s，最多 75 tick（3s） */
    暗周期秒: 0.04,
    暗最大tick: 75,
    /** 暗形态：敌人每 tick 靠近 12 码，友军 24 码 */
    暗敌人靠近距离: 12,
    暗友军靠近距离: 24,
    /** 暗形态：每 tick 吸取 每秒生命恢复 × 0.04 */
    暗吸取tick比例: 0.04,
    /** 暗形态：敌人到达攻击范围后伤害 攻击力×150% + 当前生命×15% */
    暗敌人伤害倍率: 1.5,
    暗敌人当前生命比例: 0.15,
    /** 暗形态：敌人减速 50% / 2s，友军加速 50% / 2s */
    暗减速比例: 0.5,
    暗减速持续秒: 2,
    暗加速比例: 0.5,
    暗加速持续秒: 2,
    /** 光残影单位 e060（用 创建点特效+残影单位 替代，需项目支持；先保底用 e060 马甲） */
    残影单位ID: "e060",
    /** 光结算特效 Judgement_impact_chest.mdx 缩放 2.0，Z=目标飞行高度+50，2s（源 JASS 379-382） */
    光结算特效: "war3mapImported\\Judgement_impact_chest.mdx",
    光结算特效缩放: 2.0,
    光结算特效Z偏移: 50,
    光结算特效持续秒: 2,
    /** 光结算雷击特效 ThunderClapCaster.mdl（目标位置，2s，源 JASS 307） */
    光雷击特效: "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl",
    光雷击特效持续秒: 2,
    /** 光形态溅射命中特效 CritterBloodAlbatross.mdl 挂 chest（1s，源 JASS 251/256） */
    光溅射命中特效: "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl",
    光溅射命中特效持续秒: 1,
    /** 暗形态汲取闪电：DRAB 连接 目标↔施法者，0.03s 销毁（源 JASS 130） */
    暗汲取闪电代码: "DRAB",
    暗汲取闪电持续秒: 0.03,
    /** 暗形态敌人命中特效 UndeadDissipate.mdl，Z=目标飞行高度，1s（源 JASS 158-160） */
    暗敌人命中特效: "Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdl",
    暗敌人命中特效持续秒: 1,
    /** 暗吸取音效 */
    暗吸取音效: "LifeDrain",
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
    /** 光强化期间特效 Life Magic.mdl（源 JASS：每 0.4 秒循环播放一次，挂 chest） */
    光强化特效: "war3mapImported\\Life Magic.mdl",
    光强化特效周期秒: 0.4,
    光强化特效单次持续秒: 0.6,
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
    /** 暗汲取弹道三次贝塞尔弧线：控制点抬高，纯特效不参与碰撞 */
    暗汲取弹道贝塞尔高度: 280,
    暗汲取弹道贝塞尔侧偏: 140,
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
