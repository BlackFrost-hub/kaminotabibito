import { 静态支线NPC配置列表 } from "./00．支线交互配置";
import { 污染之猫米亚NPC配置列表 } from "./02．污染之猫米亚/02．入口配置";

export interface 支线NPC配置 {
  NPC名称?: string;
  任务ID?: number;
  NPC配置名?: string;
  单位ID?: string;
  类型?: string;
  坐标X?: number;
  坐标Y?: number;
  朝向?: number;
  模型路径?: string;
  初始化动作?: string;
  自动创建?: boolean;
  启用?: boolean;
}

const 纯对话NPC配置列表: 支线NPC配置[] = [
  { NPC名称: "人类猎人", 任务ID: 1001, NPC配置名: "人类猎人", 单位ID: "hmil", 类型: "对话", 坐标X: -26819.3, 坐标Y: -8344.6, 朝向: 180, 启用: true },
  { NPC名称: "精灵村信使", 任务ID: 1002, NPC配置名: "精灵村信使", 单位ID: "n01H", 类型: "对话", 坐标X: -27392.3, 坐标Y: -28285.2, 朝向: 200, 启用: true },
  { NPC名称: "精灵村村民", 任务ID: 1003, NPC配置名: "精灵", 单位ID: "nhef", 类型: "对话", 坐标X: -26657.5, 坐标Y: -28275.3, 朝向: 165, 模型路径: "war3mapImported\\ElfVillagerWomanV2.02.mdl", 启用: true },
  { NPC名称: "沙漠神秘刺客", 任务ID: 1004, NPC配置名: "沙漠神秘刺客", 单位ID: "nass", 类型: "对话", 坐标X: -15871.9, 坐标Y: -20945.1, 朝向: 270, 初始化动作: "RemoveItemFromStockBJ:itemId(I0AG|I0AH|I0AI);random1", 启用: true },
  { NPC名称: "沙漠战斗商人", 任务ID: 1005, NPC配置名: "沙漠战斗商人", 单位ID: "n02I", 类型: "对话", 坐标X: -6926.7, 坐标Y: -22781, 朝向: 62.82, 启用: true },
];

export const 支线NPC配置列表: 支线NPC配置[] = [
  ...纯对话NPC配置列表,
  ...静态支线NPC配置列表,
  ...污染之猫米亚NPC配置列表,
];

export default 支线NPC配置列表;
