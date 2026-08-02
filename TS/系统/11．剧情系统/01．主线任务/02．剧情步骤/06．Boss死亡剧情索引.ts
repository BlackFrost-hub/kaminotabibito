/** @noSelfInFile */

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查Boss单位ID } = require("系统.01．单位系统.08．单位配置表.02．Boss配置表") as {
  按名字反查Boss单位ID: (this: void, name: string) => string | undefined;
};

import { 读取剧情进度, 写入剧情进度 } from "../00．剧情系统核心工具/01．剧情动作上下文";
import { 播放主线剧情片段 } from "./02．剧情步骤播放器";

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, whichUnit: any) => number;

export interface Boss死亡剧情索引项 {
  Boss单位名: string;
  需要剧情进度?: number;
  设置剧情进度?: number;
  阶段标记?: string;
  剧情片段ID?: string;
  说明?: string;
}

export const Boss死亡剧情索引表: Boss死亡剧情索引项[] = [
  {
    Boss单位名: "地精祭祀|cffff0000（BossLV12）|r",
    需要剧情进度: 3,
    设置剧情进度: 4,
    剧情片段ID: "jlc_goblin_boss_death",
    说明: "地精祭祀死亡后播放残血地精、宝箱、神秘人出现与回村复命引导演出。",
  },
  {
    Boss单位名: "沙漠食人魔",
    需要剧情进度: 11,
    设置剧情进度: 12,
    剧情片段ID: "jlc_desert_ogre_first_death",
    说明: "沙漠食人魔一阶段死亡后，接裂隙与杀戮食人魔二阶段演出。",
  },
  {
    Boss单位名: "杀戮食人魔",
    需要剧情进度: 12,
    设置剧情进度: 13,
    阶段标记: "沙漠食人魔二阶段",
    剧情片段ID: "jlc_slaughter_ogre_death",
    说明: "杀戮食人魔死亡后，引导回蛇人族交任务；死亡掉落迁出到后续 Boss 死亡掉落系统。",
  },
  {
    Boss单位名: "教派剑士",
    需要剧情进度: 17,
    设置剧情进度: 18,
    阶段标记: "剑士姿态",
    剧情片段ID: "jlc_cult_final_boss_death",
    说明: "第一章最终 Boss 剑士姿态死亡后，接教派败退与前往王城。",
  },
  {
    Boss单位名: "教派学者",
    需要剧情进度: 17,
    设置剧情进度: 18,
    阶段标记: "学者姿态",
    剧情片段ID: "jlc_cult_final_boss_death",
    说明: "第一章最终 Boss 学者姿态死亡后，接教派败退与前往王城。",
  },
  {
    Boss单位名: "树魔首领",
    需要剧情进度: 27,
    设置剧情进度: 28,
    剧情片段ID: "elven_city_treant_leader_death",
    说明: "树魔首领死亡后，留下遗言并掉落残缺的魔法信件，等待玩家查看。",
  },
  {
    Boss单位名: "菲利斯",
    需要剧情进度: 32,
    设置剧情进度: 33,
    剧情片段ID: "elven_city_chapter_boss_death_bridge",
    说明: "王城外的菲利斯投影被击败后，揭示正面攻城只是调虎离山，并引导玩家回援王宫。",
  },
  {
    Boss单位名: "里科特",
    需要剧情进度: 34,
    设置剧情进度: 35,
    剧情片段ID: "elven_city_chapter_end",
    说明: "当前 TS 暂按第二章末战 Boss = 里科特王子 假定绑定；源 JASS 仅能确认剧情进度 34 时死亡触发后进入章节末最终收束，具体死亡单位判定仍可能补正。",
  },
  {
    Boss单位名: "双重凤凰·菲尼克斯尔",
    需要剧情进度: 44,
    设置剧情进度: 45,
    剧情片段ID: "molten_realm_phoenixel_aftermath",
    说明: "菲尼克斯尔死亡后熄灭怨火、稳定传送阵并前往英灵墓地。",
  },
  {
    Boss单位名: "沉睡英魂·亚伦柯斯",
    需要剧情进度: 47,
    设置剧情进度: 48,
    说明: "亚伦柯斯死亡后开启通往封印核心的内层墓门；传送门由 Boss 死亡监听按场景时机注册。",
  },
];

function Boss单位名匹配(this: void, unitTypeId: number, Boss单位名: string): boolean {
  const rawId = 按名字反查Boss单位ID(Boss单位名);
  return stringToFourCCSafe(rawId) === unitTypeId;
}

function 剧情进度匹配(this: void, 配置进度: number | undefined, 当前剧情进度: number): boolean {
  return 配置进度 == null || 配置进度 === 当前剧情进度;
}

function 阶段匹配(this: void, 配置阶段: string | undefined, 当前阶段: string | undefined): boolean {
  return 配置阶段 == null || 当前阶段 == null || 配置阶段 === 当前阶段;
}

export function 查找Boss死亡剧情索引(
  this: void,
  Boss单位类型ID: number,
  当前剧情进度: number,
  阶段标记?: string,
): Boss死亡剧情索引项 | undefined {
  for (let i = 0; i < Boss死亡剧情索引表.length; i++) {
    const 索引项 = Boss死亡剧情索引表[i];
    if (!Boss单位名匹配(Boss单位类型ID, 索引项.Boss单位名)) continue;
    if (!剧情进度匹配(索引项.需要剧情进度, 当前剧情进度)) continue;
    if (!阶段匹配(索引项.阶段标记, 阶段标记)) continue;
    return 索引项;
  }
  return undefined;
}

export function 尝试播放Boss死亡主线剧情(this: void, bossUnit: any, 阶段标记?: string): boolean {
  if (bossUnit == null || bossUnit === 0) return false;
  const 索引项 = 查找Boss死亡剧情索引(GetUnitTypeId(bossUnit), 读取剧情进度(), 阶段标记);
  if (索引项 == null) return false;
  if (索引项.设置剧情进度 != null) 写入剧情进度(索引项.设置剧情进度);
  if (索引项.剧情片段ID == null || 索引项.剧情片段ID === "") return true;
  return 播放主线剧情片段(索引项.剧情片段ID, {
    片段ID: 索引项.剧情片段ID,
    触发配置名: "Boss死亡剧情索引",
    触发单位: bossUnit,
  });
}

export default Boss死亡剧情索引表;
