/** @noSelfInFile */

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const 技能动作 = require("平台扩展API动作") as {
  技能_设置技能图标: (this: void, unit: any, abilityId: number, art: string) => boolean;
  技能_设置技能提示: (this: void, unit: any, abilityId: number, tip: string) => boolean;
  技能_设置技能提示扩展: (this: void, unit: any, abilityId: number, uberTip: string) => boolean;
  技能_设置刷新数据: (this: void, unit: any, abilityId: number) => boolean;
  技能_设置技能冷却时间?: (this: void, unit: any, abilityId: number, cooldown: number, maxCooldown: number) => boolean;
  技能_设置技能魔法消耗?: (this: void, unit: any, abilityId: number, cost: number) => boolean;
  技能_设置技能施法距离?: (this: void, unit: any, abilityId: number, range: number) => boolean;
  技能_设置技能快捷键?: (this: void, unit: any, abilityId: number, hotkey: string) => boolean;
};

export interface 动态技能数据配置 {
  技能ID: string;
  名称?: string;
  图标?: string;
  说明?: string;
  冷却?: number;
  最大冷却?: number;
  魔耗?: number;
  施法距离?: number;
  快捷键?: string;
}

/**
 * 只修改当前单位的技能实例，不创建技能、不替换技能、不承担技能逻辑。
 * 所有修改完成后统一刷新命令卡，适用于 Q/W/E/R/D 阶段显示切换。
 */
export function 动态修改单位技能数据(this: void, 单位: any, 配置列表: readonly 动态技能数据配置[]): void {
  if (单位 == null || 单位 === 0) return;
  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    const 技能ID = stringToFourCCSafe(配置.技能ID);
    if (技能ID === 0) continue;
    if (配置.名称 != null) 技能动作.技能_设置技能提示(单位, 技能ID, 配置.名称);
    if (配置.图标 != null) 技能动作.技能_设置技能图标(单位, 技能ID, 配置.图标);
    if (配置.说明 != null) 技能动作.技能_设置技能提示扩展(单位, 技能ID, 配置.说明);
    if (配置.冷却 != null && 技能动作.技能_设置技能冷却时间 != null) {
      技能动作.技能_设置技能冷却时间(单位, 技能ID, 配置.冷却, 配置.最大冷却 ?? 配置.冷却);
    }
    if (配置.魔耗 != null && 技能动作.技能_设置技能魔法消耗 != null) 技能动作.技能_设置技能魔法消耗(单位, 技能ID, 配置.魔耗);
    if (配置.施法距离 != null && 技能动作.技能_设置技能施法距离 != null) 技能动作.技能_设置技能施法距离(单位, 技能ID, 配置.施法距离);
    if (配置.快捷键 != null && 技能动作.技能_设置技能快捷键 != null) 技能动作.技能_设置技能快捷键(单位, 技能ID, 配置.快捷键);
    技能动作.技能_设置刷新数据(单位, 技能ID);
  }
}

export {};
