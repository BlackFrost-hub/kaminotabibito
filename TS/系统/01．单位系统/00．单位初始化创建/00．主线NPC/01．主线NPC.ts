const jass = require("jass.common") as any;
const BJ_DEGTORAD = 0.017453292519943295;
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  createDelayedCall: (this: void, delaySec: number, callback: () => void) => { id: number };
};
import { createUnitWithOptions } from "../../../../lib/扩展函数/自定义扩展函数/00．单位相关";
export interface MainStoryNpcMap {
  自然守护者?: any;
  八云紫?: any;
  精灵村长老?: any;
  沙漠营地领主?: any;
  熔岩小镇镇长?: any;
  恶魔城领主?: any;
  沙漠年长者?: any;
  沙漠年轻佣兵?: any;
  沙漠情报商人?: any;
  蛇人族藏品管家?: any;
  阿尔文?: any;
  jl禁军门卫?: any;
  jl禁军门卫2?: any;
  克林姆德王?: any;
}

export const MAIN_STORY_NPCS: MainStoryNpcMap = {};

function createNeutralPassive(unitId: string, x: number, y: number, facingDeg: number): any {
  // createUnitWithOptions 约定 playerId=15 对应中立被动
  const facingRad = facingDeg * BJ_DEGTORAD;
  return createUnitWithOptions(15, unitId, x, y, facingRad);
}

/**
 * 对应 JASS: Trig_____________NPC4_0SActions
 * 创建主线剧情涉及的 NPC 并写入运行时映射表。
 */
export function createMainStoryNPCs(): MainStoryNpcMap {
  MAIN_STORY_NPCS.自然守护者 = createNeutralPassive("etrp", -29053.5, -28338.0, 200.0);
  MAIN_STORY_NPCS.八云紫 = createNeutralPassive("E00O", 26486.9, -28470.7, 270.0);
  MAIN_STORY_NPCS.精灵村长老 = createNeutralPassive("edot", 28773.9, -28943.7, 0.0);
  MAIN_STORY_NPCS.沙漠营地领主 = createNeutralPassive("n01L", -18080.6, -24550.7, 290.0);
  MAIN_STORY_NPCS.熔岩小镇镇长 = createNeutralPassive("ndrp", 8668.3, -20334.0, 270.0);
  MAIN_STORY_NPCS.恶魔城领主 = createNeutralPassive("n03V", 14861.74, -15980.4, 270.0);
  MAIN_STORY_NPCS.沙漠年长者 = createNeutralPassive("n05I", -3945.7, -24963.1, 235.0);
  MAIN_STORY_NPCS.沙漠年轻佣兵 = createNeutralPassive("h008", -4550.4, -23952.4, 80.0);
  MAIN_STORY_NPCS.沙漠情报商人 = createNeutralPassive("n02G", -7139.3, -26096.7, 270.0);
  MAIN_STORY_NPCS.蛇人族藏品管家 = createNeutralPassive("h01J", -20448.3, 2966.3, 180.0);
  MAIN_STORY_NPCS.阿尔文 = createNeutralPassive("n04O", -21062.4, -14229.1, 200.0);
  MAIN_STORY_NPCS.jl禁军门卫 = createNeutralPassive("h01M", 15632.6, -25873.0, 0.0);
  MAIN_STORY_NPCS.jl禁军门卫2 = createNeutralPassive("h01M", 16207.5, -24926.0, 180.0);
  MAIN_STORY_NPCS.克林姆德王 = createNeutralPassive("h01N", 19063.9, -24612.7, 180.0);

  // 可选：同步到全局表，便于后续系统读取
  (globalThis as any).__MAIN_STORY_NPCS__ = MAIN_STORY_NPCS;
  return MAIN_STORY_NPCS;
}

/**
 * 等价于 JASS 的 TriggerRegisterTimerEventSingle(..., 1.00)
 */
export function initMainStoryNPCsWithDelay(delaySec: number = 1.0): void {
  createDelayedCall(delaySec, createMainStoryNPCs);
}

export default {
  createMainStoryNPCs,
  initMainStoryNPCsWithDelay,
};
