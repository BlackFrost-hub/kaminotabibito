import { 静态支线任务配置列表 } from "../../11．剧情系统/02．支线任务/00．支线交互配置";
import { 污染之猫米亚任务配置列表 } from "../../11．剧情系统/02．支线任务/02．污染之猫米亚/02．入口配置";

export interface 任务配置 {
  任务ID?: number;
  名称?: string;
  类型?: string;
  开始NPC?: string;
  结束NPC?: string;
  结束NPC位置?: string;
  前置任务ID?: number;
  任务物品?: string;
  需求物品?: string;
  需求资源?: string;
  目标单位?: string;
  目标单位分别击杀?: boolean;
  目标单位显示名?: string;
  击杀携带物品?: string;
  提交消耗物品?: string;
  提交物品升级?: string;
  需求数量?: number;
  接取条件?: string;
  目标区域?: string;
  奖励?: string;
  奖励显示?: string;
  奖励物品?: string;
  描述?: string;
  进度文本?: string;
  失败文本?: string;
  NPC开始对白?: string;
  任务接受对白?: string;
  接取失败对白?: string;
  NPC完成对白?: string;
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
