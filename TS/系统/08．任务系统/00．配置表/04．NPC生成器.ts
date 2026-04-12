/**
 * NPC生成器 - 根据NPC配置表统一创建NPC
 */

const jass = require("jass.common") as any;

// 引入NPC配置表
import { NPC_CONFIGS, NPCData } from "./03．NPC配置表";
import { createUnitWithOptions } from "../../../lib/扩展函数/自定义扩展函数/00．单位相关";
import { runNpcInitAction } from "./05．NPC初始化动作";
import { tryAttachQuestMarkerForConfigNpc } from "../../09．表现系统/02．对话框系统/15．NPC头顶与气泡特效";

// 获取全局print函数
const _print = (globalThis as any).print as (...args: any[]) => void;

/**
 * 创建单个NPC
 * @param npcConfig NPC配置数据
 * @returns 创建的单位，失败返回null
 */
function createSingleNPC(npcConfig: NPCData): any {
  if (!npcConfig.unitcode || npcConfig.X == null || npcConfig.Y == null) {
    _print("[NPC生成器] 配置不完整，跳过: " + tostring(npcConfig.NpcNameID));
    return null;
  }

  // 计算FourCC
  const unitCode = npcConfig.unitcode;
  if (unitCode.length !== 4) {
    _print("[NPC生成器] 单位代码无效: " + unitCode);
    return null;
  }

  // 使用统一扩展函数创建：按配置坐标与朝向生成（函数朝向参数为弧度）
  const facingDeg = npcConfig.Facing ?? 270;
  const facingRad = facingDeg * Math.PI / 180;
  const unit = createUnitWithOptions(15, unitCode, npcConfig.X, npcConfig.Y, facingRad);

  if (!unit) {
    _print("[NPC生成器] 创建单位失败: " + tostring(npcConfig.NpcNameID) + " (" + unitCode + ")");
    return null;
  }

  // 设置单位名称
  if (npcConfig.NPCrequireName && typeof jass.SetUnitName === "function") {
    jass.SetUnitName(unit, npcConfig.NPCrequireName);
  }

  // 设置模型文件（如果配置了）
  if (npcConfig.modelFIle && typeof jass.SetUnitModel === "function") {
    jass.SetUnitModel(unit, npcConfig.modelFIle);
  }

  // 初始化动作（例如商店物品池调整）
  runNpcInitAction(unit, npcConfig.initAction);

  tryAttachQuestMarkerForConfigNpc(unit, npcConfig);

  _print("[NPC生成器] 成功创建NPC: " + tostring(npcConfig.NpcNameID) + " at (" + tostring(npcConfig.X) + ", " + tostring(npcConfig.Y) + ")");
  return unit;
}

/**
 * 初始化所有启用的NPC
 * 在游戏开始时调用此函数
 */
export function initializeNPCs(): void {
  _print("[NPC生成器] 开始初始化NPC...");

  let createdCount = 0;
  let skippedCount = 0;

  for (const npcConfig of NPC_CONFIGS) {
    // 只创建 enabled 为 true 的NPC
    if (npcConfig.enabled === true) {
      const unit = createSingleNPC(npcConfig);
      if (unit) {
        createdCount++;
      }
    } else {
      skippedCount++;
    }
  }


}

/**
 * 根据NPC名称查找并创建特定NPC（用于测试）
 * @param npcName NPC名称
 * @returns 创建的单位，失败返回null
 */
export function createNPCByName(npcName: string): any {
  const npcConfig = NPC_CONFIGS.find(npc => npc.NpcNameID === npcName || npc.NPCrequireName === npcName);

  if (!npcConfig) {
    _print("[NPC生成器] 未找到NPC配置: " + npcName);
    return null;
  }

  if (npcConfig.enabled !== true) {
    _print("[NPC生成器] NPC未启用: " + npcName);
    return null;
  }

  return createSingleNPC(npcConfig);
}

/**
 * 根据任务ID查找并创建对应NPC
 * @param requireID 任务ID
 * @returns 创建的单位，失败返回null
 */
export function createNPCByQuestId(requireID: number): any {
  const npcConfig = NPC_CONFIGS.find(npc => npc.requireID === requireID);

  if (!npcConfig) {
    _print("[NPC生成器] 未找到任务ID对应的NPC: " + tostring(requireID));
    return null;
  }

  if (npcConfig.enabled !== true) {
    _print("[NPC生成器] NPC未启用: " + tostring(npcConfig.NpcNameID) + " (任务ID: " + tostring(requireID) + ")");
    return null;
  }

  return createSingleNPC(npcConfig);
}

/**
 * 获取所有已启用的NPC配置列表
 */
export function getEnabledNPCs(): NPCData[] {
  return NPC_CONFIGS.filter(npc => npc.enabled === true);
}

/**
 * 获取所有NPC配置列表（包括未启用的）
 */
export function getAllNPCs(): NPCData[] {
  return [...NPC_CONFIGS];
}

// 初始化函数，可在游戏开始时调用
export function init(): void {
  initializeNPCs();
}

export {};
