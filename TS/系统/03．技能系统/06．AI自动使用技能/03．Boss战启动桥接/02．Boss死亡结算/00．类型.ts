/** @noSelfInFile */

export type Boss死亡结算来源 = "旧JASS_Boss死亡" | "主线剧情";

export type Boss死亡结算提示类型 =
  | "UNITACQUIRED"
  | "ITEMACQUIRED"
  | "COMPLETED"
  | "ALWAYSHINT"
  | "WARNING"
  | "UPDATED";

export interface Boss死亡清理项 {
  表名: string;
  键名?: string;
  字段名?: string;
  值类型名?: string;
  清理整表?: boolean;
}

export interface Boss死亡全员奖励 {
  经验?: number;
  基础全属性?: number;
  力量?: number;
  敏捷?: number;
  智力?: number;
  攻击力?: number;
  金币?: number;
  魔法恢复?: number;
  击杀者最高等级限制?: number;
  条件说明?: string;
}

export interface Boss死亡击杀者奖励 {
  金币?: number;
  物品名列表?: string[];
  条件说明?: string;
}

export interface Boss死亡结算配置 {
  键: string;
  /** 优先使用物编 raw id 匹配，避免颜色码、等级后缀或同名单位导致名称反查失败。 */
  Boss单位ID?: string;
  Boss单位ID列表?: string[];
  Boss单位名?: string;
  Boss单位名列表?: string[];
  Boss引用键?: string;
  清理列表?: Boss死亡清理项[];
  /** 多件候选装备 pick 1 的奖励池放在首领奖励选择系统；这里仅保存触发关系。 */
  首领奖励池ID?: string;
  /** 旧固定掉落语义：Boss 死亡后把列表里的物品全部直接掉出来。 */
  直接掉落物品名列表?: string[];
  /** 无法通过装备数据表反查时使用，例如剧情任务物品或旧 JASS raw id。 */
  直接掉落物品ID列表?: string[];
  非装备批量掉落物品名?: string;
  非装备批量掉落最小数量?: number;
  非装备批量掉落最大数量?: number;
  全员奖励?: Boss死亡全员奖励;
  击杀者奖励?: Boss死亡击杀者奖励;
  提示文本键?: string;
  提示类型?: Boss死亡结算提示类型;
  延迟提示秒数?: number;
  特殊逻辑标签?: string[];
  保留原剧情执行?: boolean;
  备注?: string;
}
