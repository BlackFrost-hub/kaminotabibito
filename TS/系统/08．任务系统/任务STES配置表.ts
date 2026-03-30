/**
 * 任务系统 — STES 事件与任务目标的对照表（给 Excel 导出 / 人工维护用）
 *
 * =============================================================================
 * 一、整体数据流（给策划、填表、AI 对齐用）
 * =============================================================================
 * 1) 地图编辑器 / YDWE 里：某处触发「STES 自定义事件」，事件名字符串 = 本表每一行的「事件键」。
 * 2) STES 运行时会调用已注册的 native trigger；本项目的 Lua 在「任务STES桥接」里对每个事件键
 *    各注册一个 Trigger，回调里根据事件键查本表，再改对应任务的 objective 进度。
 * 3) 因此：**Excel 里「STES事件名」列、地图里写的字符串、本表 Record 的键，三者必须逐字一致**
 *    （同一编码、同一全角/半角、无多余空格）。
 *
 * =============================================================================
 * 二、建议的 Excel 表结构（列名可按你们习惯改，导出时映射到下面接口字段即可）
 * =============================================================================
 * | Excel 列名（建议）     | 对应 TS 字段    | 类型/说明 |
 * |------------------------|-----------------|-----------|
 * | STES事件名 / 事件键    | （作为表的 key） | string，与地图 STES 完全一致 |
 * | 任务ID                 | questId         | string，与 任务数据.ts 里 QuestData.id 一致 |
 * | 目标ID                 | objectiveId     | string，与对应任务 objectives[].id 一致 |
 * | 进度模式               | mode            | "add" 在现有进度上加 amount；"set" 设为 amount |
 * | 数值                   | amount          | number，加算或设定值 |
 *
 * 可选扩展列（当前代码未读，可后续在桥接里加 udg_* 读取）：
 * | Excel 列名（建议）     | 说明 |
 * | 仅指定玩家             | 若地图不写 udg_QuestPlayerId，则用 STES_GetTriggerPlayer 推断 |
 *
 * =============================================================================
 * 三、与「任务目标更新.ts」那条管线的区别
 * =============================================================================
 * - LuaEvent_QuestObjectiveUpdate：地图**显式**写好 udg_QuestPlayerId / udg_QuestId /
 *   udg_ObjectiveId / udg_Progress，适合通用脚本。
 * - 本表：**只根据「事件名字符串」**自动映射到 questId + objectiveId，适合「击杀某怪」「到达某点」
 *   一类与 STES 强绑定的配置驱动逻辑。
 *
 * =============================================================================
 * 四、与 装备提取.ts 的相同点
 * =============================================================================
 * - 每个 STES 事件名对应一次 STES_Register(trigger, "事件字符串")（或经 Bridge_STES_Register）。
 * - 若 jass 上存在 STES_Register 则直接调；否则写 udg_RegTrigger + udg_RegEventStr 后 ExecuteFunc。
 */

/** 单行配置：由 Excel 一行导出为一项（key 为 STES 事件名，不要放进对象里重复一份，除非你们导出工具要求） */
export interface QuestStesObjectiveRow {
  /** 任务定义 ID，须已在 questDB 中 register（如 任务数据 / 测试数据） */
  questId: string;
  /** 该任务下 QuestObjective.id */
  objectiveId: string;
  /**
   * add：新进度 = min(当前+amount, required)；set：新进度 = min(amount, required)
   * （封顶逻辑在 questDB.updateObjective 内）
   */
  mode: "add" | "set";
  amount: number;
}

/**
 * 主表：键 = STES 事件名字符串（与地图里写的完全一致）。
 * 后续可用脚本从 Excel 生成/合并进此对象；AI 修改时请保持键与 JASS 侧一致。
 */
export const QUEST_STES_OBJECTIVE_ROWS: Record<string, QuestStesObjectiveRow> = {
  /**
   * 示例（可删）：与 createTestQuests 里 side_002「击杀步兵」对应。
   * 地图 STES 里写事件名「击杀步兵」时，会推进 side_002 / obj1。
   */
  击杀步兵: { questId: "side_002", objectiveId: "obj1", mode: "add", amount: 1 },
  // 在 Excel 增加一行并在导出后在此添加，例如：
  // 击杀豺狼人: { questId: "你的任务id", objectiveId: "obj1", mode: "add", amount: 1 },
};
