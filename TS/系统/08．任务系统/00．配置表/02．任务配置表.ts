import { 静态支线任务配置列表 } from "../../11．剧情系统/02．支线任务/00．支线交互配置";
import { 污染之猫米亚任务配置列表 } from "../../11．剧情系统/02．支线任务/02．污染之猫米亚/02．入口配置";

export interface 任务结束NPC配置 {
  NPC名称: string;
  NPC配置名?: string;
  单位ID: string;
  坐标X: number;
  坐标Y: number;
  朝向: number;
  模型路径?: string;
  初始化动作?: string;
}

export interface 击杀目标组配置 {
  目标单位: string;
  显示名: string;
  需求数量: number;
}

export interface 任务配置 {
  任务ID?: number;
  名称?: string;
  类型?: string;
  开始NPC?: string;
  结束NPC?: string;
  结束NPC配置?: 任务结束NPC配置;
  前置任务ID?: number;
  任务物品?: string;
  需求物品?: string;
  需求物品分别提交?: boolean;
  需求资源?: string;
  目标单位?: string;
  目标单位分别击杀?: boolean;
  目标单位显示名?: string;
  击杀目标组?: 击杀目标组配置[];
  击杀携带物品?: string;
  提交消耗物品?: string;
  提交物品升级?: string;
  需求数量?: number;
  接取条件?: string;
  目标区域?: string;
  奖励?: string;
  奖励显示?: string;
  奖励物品?: string;
  /** 从竖线分隔的物品列表中随机发放一件。 */
  随机奖励物品?: string;
  /** 只在内部限时内完成时追加的奖励，不进入普通任务奖励展示。 */
  限时完成奖励?: string;
  限时完成奖励物品?: string;
  描述?: string;
  进度文本?: string;
  失败文本?: string;
  NPC开始对白?: string;
  任务接受对白?: string;
  接取失败对白?: string;
  NPC完成对白?: string;
  /** 在内部限时内完成时使用的额外完成对白。 */
  限时完成对白?: string;
  /** 只用于运行时判定，默认不在玩家 UI 展示。 */
  内部限时秒?: number;
  完成后对白 ?: string;
  接取后动作?: (this: 任务配置, 玩家ID: number) => void;
  完成后动作?: (this: 任务配置, 玩家ID: number) => void;
  可重复?: boolean;
  启用?: boolean;
}

export const 任务配置列表: 任务配置[] = [
  ...静态支线任务配置列表,
  ...污染之猫米亚任务配置列表,
];

export default 任务配置列表;
