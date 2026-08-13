/** @noSelfInFile */

const {
  转四位ID,
  单位拥有原生Buff,
  获取范围敌军,
  在坐标播放特效,
  取单位X,
  取单位Y,
  注册指定单位暴击后监听,
} = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  转四位ID: (this: void, rawIdText: string) => number;
  单位拥有原生Buff: (this: void, unit: any, buffId: number) => boolean;
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
  在坐标播放特效: (this: void, model: string, x: number, y: number, z: number, size: number, lifeSec: number) => void;
  取单位X: (this: void, unit: any) => number;
  取单位Y: (this: void, unit: any) => number;
  注册指定单位暴击后监听: (this: void, unitTypeId: number, handler: (this: void, record: any, applied: number, snapshot: any) => void) => void;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, 参数: any) => number;
};
const jass = require("jass.common") as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const { 播放限时单位动画 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待") as {
  播放限时单位动画: (this: void, 参数: any) => any;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => any;
};
const { cloud单位技能配置 } = require("系统.03．技能系统.05．单位技能.04．英雄技能.01．cloud.00．配置") as {
  cloud单位技能配置: {
    单位ID: string;
    触发BuffID: string;
    溅射半径: number;
    特效路径: string;
    动作序号: number;
    动作时间流速: number;
    硬直毫秒: number;
  };
};

const cloud单位类型ID = 转四位ID(cloud单位技能配置.单位ID);
const cloud触发BuffID = 转四位ID(cloud单位技能配置.触发BuffID);

interface cloud溅射伤害变量 {
  主目标: any;
}

function 准备cloud溅射伤害目标(this: void, target: any, _index: number, variable?: any): any {
  const 变量 = variable as cloud溅射伤害变量 | undefined;
  if (变量 == null || target === 变量.主目标) return undefined;
  return {};
}

function cloud暴击后处理(this: void, record: any, applied: number, _snapshot: any): void {
  if (!单位拥有原生Buff(record.attacker, cloud触发BuffID)) return;
  开始硬直(record.attacker, cloud单位技能配置.硬直毫秒 * 0.001);
  播放限时单位动画({
    单位: record.attacker,
    动画编号: cloud单位技能配置.动作序号,
    持续秒: cloud单位技能配置.硬直毫秒 * 0.001,
    动画速度: cloud单位技能配置.动作时间流速,
    恢复动画: false,
  });
  const x = 取单位X(record.target);
  const y = 取单位Y(record.target);
  在坐标播放特效(cloud单位技能配置.特效路径, x, y, 0, 1, 1);
  const targets = 获取范围敌军(record.attacker, x, y, cloud单位技能配置.溅射半径);
  造成批量AOE技能伤害({
    来源: record.attacker,
    目标列表: targets,
    伤害: applied,
    伤害类型: DAMAGE_TYPE_ENHANCED,
    来源类型: "普攻强化",
    参与技能伤害加成: false,
    标签: "cloud-暴击溅射",
    每目标处理器: 准备cloud溅射伤害目标,
    变量: { 主目标: record.target },
  });
}

export function 注册cloud被动效果(this: void): void {
  注册指定单位暴击后监听(cloud单位类型ID, cloud暴击后处理);
}

注册cloud被动效果();
