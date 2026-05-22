/** @noSelfInFile */

import { MAIN_STORY_QUEST_CONFIGS, type MainStoryQuestData } from "../../08．任务系统/00．配置表/06．主线任务配置表";

export type 主线迁移状态 = "可直接迁移" | "待专题迁移";

export interface 剧情主线任务配置 extends MainStoryQuestData {
  来源ID: number;
  迁移状态: 主线迁移状态;
  迁移备注?: string;
}

export const 可直接迁移主线任务ID列表: number[] = [
  300001,
  300005,
  300006,
  300007,
  300008,
  300009,
  300012,
  300013,
  300017,
  300019,
  300020,
  300022,
  300023,
  300024,
  300025,
  300026,
  300027,
];

const 待专题迁移主线任务备注表: Record<number, string> = {
  300002: "含 NPC/Boss 创建、触发器注册、任务奖励与多段初始化，建议拆到主线演出/Boss流程。",
  300003: "含黑幕、电影模式、BGM 切换，属于纯演出段，建议拆到主线演出。",
  300004: "含 Boss 战绑定、条件触发器、护盾/弱点/YD 字段初始化，建议拆到主线 Boss 战。",
  300010: "含计时器、触发器注册、单位创建与剧情奖励，建议专题迁移。",
  300011: "含演出切场、CreateUnit、ConditionalTriggerExecute，建议专题迁移。",
  300014: "含计时器与专题剧情节点，后续单独迁。",
  300015: "含 Boss 战专题初始化，后续单独迁。",
  300016: "含 BGM、CreateUnit、给物品与剧情推进混合，建议专题迁移。",
  300018: "含计时器与强依赖旧流程动作，建议单独迁。",
  300021: "含大规模演出、BGM、刷怪、删地形、奖励金币，建议拆主线演出/战斗流程。",
};

function 查找旧主线配置(this: void, 来源ID: number): MainStoryQuestData | undefined {
  for (let i = 0; i < MAIN_STORY_QUEST_CONFIGS.length; i++) {
    const 配置 = MAIN_STORY_QUEST_CONFIGS[i];
    if (配置.requireID === 来源ID) return 配置;
  }
  return undefined;
}

function 追加兼容配置(this: void, 结果: 剧情主线任务配置[], 来源ID: number, 迁移状态: 主线迁移状态, 迁移备注?: string): void {
  const 旧配置 = 查找旧主线配置(来源ID);
  if (旧配置 == null) return;
  结果.push({
    ...旧配置,
    来源ID,
    迁移状态,
    迁移备注,
  });
}

function 构建剧情主线任务配置表(this: void): 剧情主线任务配置[] {
  const 结果: 剧情主线任务配置[] = [];

  for (let i = 0; i < 可直接迁移主线任务ID列表.length; i++) {
    追加兼容配置(结果, 可直接迁移主线任务ID列表[i], "可直接迁移");
  }

  for (const 来源IDText in 待专题迁移主线任务备注表) {
    const 来源ID = Number(来源IDText);
    追加兼容配置(结果, 来源ID, "待专题迁移", 待专题迁移主线任务备注表[来源ID]);
  }

  return 结果;
}

export const 剧情主线任务配置表: 剧情主线任务配置[] = 构建剧情主线任务配置表();

export const 可直接迁移剧情主线任务配置表: 剧情主线任务配置[] = 剧情主线任务配置表.filter((配置) => 配置.迁移状态 === "可直接迁移");

export const 待专题迁移剧情主线任务配置表: 剧情主线任务配置[] = 剧情主线任务配置表.filter((配置) => 配置.迁移状态 === "待专题迁移");
