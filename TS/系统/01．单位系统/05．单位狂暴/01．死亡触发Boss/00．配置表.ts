/** @noSelfInFile */

export type Boss出现位置类型 = "击杀者当前位置" | "死亡单位当前位置" | "固定坐标";
export type Boss出现触发类型 = "累计数量" | "概率";

export interface 死亡触发Boss配置 {
  配置ID: string;
  触发类型: Boss出现触发类型;
  触发单位名: string;
  Boss单位名: string;
  只触发一次?: boolean;
  需要加入血条Boss组?: boolean;
  出现位置类型: Boss出现位置类型;
  固定X?: number;
  固定Y?: number;
  固定朝向?: number;
  累计数量?: number;
  出现概率?: number;
  击杀者最低英雄等级?: number;
  击杀者最高英雄等级?: number;
  出场特效模型?: string;
  出现提示文本: string;
  Boss说话文本: string;
  Boss说话延迟Ms?: number;
  广播持续时间Ms?: number;
}

export const 死亡触发Boss配置表: 死亡触发Boss配置[] = [
  {
    配置ID: "沙丘之虫_沙漠母虫",
    触发类型: "累计数量",
    触发单位名: "沙丘之虫",
    Boss单位名: "沙漠母虫",
    只触发一次: true,
    需要加入血条Boss组: true,
    出现位置类型: "击杀者当前位置",
    累计数量: 10,
    出场特效模型: "units\\critters\\DuneWorm\\DuneWorm.mdl",
    出现提示文本: "这...糟糕！准备战斗！",
    Boss说话文本: "沙海已经苏醒，所有闯入者都会被我吞没。",
    Boss说话延迟Ms: 350,
    广播持续时间Ms: 5000,
  },
  {
    配置ID: "狂暴沙漠蜘蛛_蜘蛛女皇",
    触发类型: "概率",
    触发单位名: "狂暴沙漠蜘蛛",
    Boss单位名: "蜘蛛女皇|cffff0000（BossLV25）|r",
    只触发一次: true,
    需要加入血条Boss组: true,
    出现位置类型: "固定坐标",
    固定X: -12252.6,
    固定Y: -28635.0,
    出现概率: 18,
    击杀者最低英雄等级: 14,
    击杀者最高英雄等级: 30,
    出场特效模型: "war3mapImported\\NerubianCaster.mdl",
    出现提示文本: "怎么回事！！！？",
    Boss说话文本: "我的蛛网已经覆盖这片荒地，你们谁也逃不掉。",
    Boss说话延迟Ms: 350,
    广播持续时间Ms: 5000,
  },
];
