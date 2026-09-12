/** @noSelfInFile */
// 祖地秘境·环境互动掉落：祖地战冠（被动·战意）
// 战意：持有者击杀敌方单位后获得一层战意，每层攻击力+8%，最多3层，持续4秒，击杀刷新时长。
// 实现选型：单位死亡事件中心击杀监听 + 单位时限数值（层数窗口）+ 施加单体攻击力提高Buff（线性取首层快照，避免复合叠乘）。

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 创建单位时限数值 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.16．单位时限数值") as {
  创建单位时限数值: (this: void, 名称: string) => {
    写入: (this: void, unit: any, 值: number, 持续秒: number) => void;
    读取: (this: void, unit: any) => number | undefined;
    清空: (this: void, unit?: any) => void;
  };
};
const { 施加单体攻击力提高Buff } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.02．攻击力提高") as {
  施加单体攻击力提高Buff: (this: void, 来源单位: any, 目标单位: any, 参数: {
    BuffID?: string;
    持续时间: number;
    攻击力: number;
    图标路径?: string;
    特效路径?: string;
  }) => boolean;
};
import {
    单位持有装备,
    单位存活,
    是敌对单位,
    取攻击力,
    祖地秘境战利品装备名,
} from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

const 战意每层攻击比例 = 0.08;
const 战意最大层数 = 3;
const 战意持续秒 = 4;
const 战意层数 = 创建单位时限数值("祖地战冠-战意层数");
const 战意首层加成 = 创建单位时限数值("祖地战冠-战意首层加成");
const 战冠图标 = "ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Helmet\\BTNAncestralWarCrown.blp";

function on祖地战冠击杀(this: void, dyingUnit: any, killingUnit: any): void {
    if (killingUnit == null || killingUnit === 0) return;
    if (!单位持有装备(killingUnit, 祖地秘境战利品装备名.祖地战冠)) return;
    if (!单位存活(killingUnit)) return;
    if (dyingUnit == null || dyingUnit === 0 || !是敌对单位(killingUnit, dyingUnit)) return;
    const 旧层数 = 战意层数.读取(killingUnit);
    // 首次叠层时快照单层加成，后续按层数线性放大，避免攻击加成复合叠乘。
    if (旧层数 == null) 战意首层加成.写入(killingUnit, 取攻击力(killingUnit) * 战意每层攻击比例, 战意持续秒);
    const 层数 = Math.min((旧层数 ?? 0) + 1, 战意最大层数);
    战意层数.写入(killingUnit, 层数, 战意持续秒);
    const 单层加成 = 战意首层加成.读取(killingUnit) ?? 取攻击力(killingUnit) * 战意每层攻击比例;
    施加单体攻击力提高Buff(killingUnit, killingUnit, {
        BuffID: 常规BuffID.祖地战冠_战意,
        持续时间: 战意持续秒,
        攻击力: 单层加成 * 层数,
        图标路径: 战冠图标,
    });
}

registerDeathListener(on祖地战冠击杀);
export {};
