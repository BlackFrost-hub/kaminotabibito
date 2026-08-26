/** @noSelfInFile */

export const 朱雀院红叶技能配置 = {
  单位类型ID: "E00G",
  Q: { 技能ID: "AMQ1", 名称: "飞燕·穿（Q）", 图标: "ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiQ.blp", 快捷键: "Q" },
  W: { 技能ID: "AMW1", 名称: "水镜·返刃（W）", 图标: "ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiW.blp", 快捷键: "W" },
  E: { 技能ID: "AME1", 名称: "三叶·散华（E）", 图标: "ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiE.blp", 快捷键: "E" },
  R: { 技能ID: "AMR1", 名称: "奥义·红叶一闪（R）", 图标: "ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiR.blp", 快捷键: "R" },
  D: { 技能ID: "AMD1", 名称: "朱雀流·秘传三式（D）", 图标: "ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiD.blp", 快捷键: "D" },
  Q2技能ID: "ASQ2",
} as const;

export const 朱雀院红叶物编配置 = {
  模型: "Unit\\Hero\\Momiji\\Momiji.mdx",
  主属性: "AGI",
  初始属性: { 力量: 25, 敏捷: 30, 智力: 15 },
  属性成长: { 力量: 2.0, 敏捷: 3.5, 智力: 1.5 },
  攻击模式: "近战",
  头像: "ReplaceableTextures\\CommandButtons\\Momiji\\BTNMomijiQ.blp",
} as const;

export const 朱雀院红叶动作配置 = {
  待机: "stand",
  行走: "walk",
  奔跑: "run",
  普攻: "attack",
  技能候选: ["spell 1", "spell 2", "spell 3", "spell 4", "spell 5", "spell 6", "spell 7"],
  死亡: "death",
  待实机映射: true,
} as const;

export const 朱雀院红叶表现配置 = {
  破绽标记: "Common\\Effect\\Form\\Marker\\MomijiWeakPointBlade3D.mdx",
  刀势层数: [
    "Common\\Effect\\Form\\Rotate\\MomijiVigorOrbit1.mdx",
    "Common\\Effect\\Form\\Rotate\\MomijiVigorOrbit2.mdx",
    "Common\\Effect\\Form\\Rotate\\MomijiVigorOrbit3.mdx",
  ],
  水镜主体: "Common\\Effect\\Form\\Shield\\MomijiWaterMirrorV5.mdx",
} as const;

export const 朱雀院红叶读条配置 = {
  UI类型: "自然",
  标题: "",
  数值后缀: "",
  跟随Z偏移: 220,
  显示模型进度条: false,
  死亡或打断同步销毁: true,
} as const;

export const 朱雀院红叶待平衡数值 = {
  Q: { 冷却秒: 6, 魔耗: 45, Q2窗口秒: 0.7 },
  W: { 冷却秒: 10, 魔耗: 55, 招架窗口秒: 0.6 },
  E: { 冷却秒: 9, 魔耗: 65, 剑痕持续秒: 2.5 },
  R: { 冷却秒: 65, 魔耗: 130, 蓄力秒: 0.7 },
  D: { 冷却秒: 18, 魔耗: 50, 持续秒: 8, 强化次数: 3 },
} as const;
