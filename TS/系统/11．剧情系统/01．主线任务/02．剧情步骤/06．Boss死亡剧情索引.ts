export interface Boss死亡剧情索引项 {
  Boss单位ID: string;
  Boss名: string;
  需要剧情进度?: number;
  设置剧情进度?: number;
  阶段标记?: string;
  剧情片段ID: string;
  说明?: string;
}

export const Boss死亡剧情索引表: Boss死亡剧情索引项[] = [
  {
    Boss单位ID: "N00C",
    Boss名: "地精祭祀",
    需要剧情进度: 3,
    设置剧情进度: 4,
    剧情片段ID: "jlc_elven_village_goblin_defeated_to_desert",
    说明: "地精祭祀死亡后，接黑影退场、复命长老、前往沙漠。",
  },
  {
    Boss单位ID: "N05J",
    Boss名: "沙漠食人魔",
    需要剧情进度: 11,
    设置剧情进度: 12,
    剧情片段ID: "jlc_snake_ogre_defeated_to_guard_duel",
    说明: "沙漠食人魔一阶段死亡后，接裂隙与杀戮食人魔二阶段。",
  },
  {
    Boss单位ID: "N05K",
    Boss名: "杀戮食人魔",
    需要剧情进度: 12,
    设置剧情进度: 13,
    阶段标记: "沙漠食人魔二阶段",
    剧情片段ID: "jlc_snake_ogre_defeated_to_guard_duel",
    说明: "杀戮食人魔死亡后，回蛇人族交凭证并接护卫对战。",
  },
  {
    Boss单位ID: "N05N",
    Boss名: "蒙面人",
    需要剧情进度: 17,
    设置剧情进度: 18,
    阶段标记: "剑士姿态",
    剧情片段ID: "jlc_return_village_defeat_chapter_one_cult_boss",
    说明: "第一章最终Boss剑士姿态死亡后，接教派败退与前往王城。",
  },
  {
    Boss单位ID: "N05M",
    Boss名: "蒙面人",
    需要剧情进度: 17,
    设置剧情进度: 18,
    阶段标记: "学者姿态",
    剧情片段ID: "jlc_return_village_defeat_chapter_one_cult_boss",
    说明: "第一章最终Boss学者姿态死亡后，接教派败退与前往王城。",
  },
  {
    Boss单位ID: "N05S",
    Boss名: "树魔首领",
    需要剧情进度: 27,
    设置剧情进度: 28,
    剧情片段ID: "elven_city_hunter_to_treant_leader",
    说明: "树魔首领死亡后，掉落魔法信件并返回王城汇报。",
  },
];

function 剧情进度匹配(this: void, 配置进度: number | undefined, 当前剧情进度: number | undefined): boolean {
  return 配置进度 == null || 当前剧情进度 == null || 配置进度 === 当前剧情进度;
}

function 阶段匹配(this: void, 配置阶段: string | undefined, 当前阶段: string | undefined): boolean {
  return 配置阶段 == null || 当前阶段 == null || 配置阶段 === 当前阶段;
}

export function 查找Boss死亡剧情索引(
  this: void,
  Boss单位ID: string,
  当前剧情进度?: number,
  阶段标记?: string,
): Boss死亡剧情索引项 | undefined {
  for (let i = 0; i < Boss死亡剧情索引表.length; i++) {
    const 索引项 = Boss死亡剧情索引表[i];
    if (索引项.Boss单位ID !== Boss单位ID) continue;
    if (!剧情进度匹配(索引项.需要剧情进度, 当前剧情进度)) continue;
    if (!阶段匹配(索引项.阶段标记, 阶段标记)) continue;
    return 索引项;
  }
  return undefined;
}

export default Boss死亡剧情索引表;
