/** @noSelfInFile */
import {
    创建治疗护盾联动,
    创建窗口承伤次数触发器,
    创建单位时限标记,
    创建单位时限数值,
} from '../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/index';
import { 创建单位临时属性效果托管器 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/19．临时属性效果';
import {
    单位持有装备,
    是敌对单位,
    取当前生命,
    取最大生命,
    恢复生命魔法,
    播放单位特效,
    四Boss战利品装备名,
    四Boss装备特效,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
import { registerManualBuff, 移除单位指定Buff } from '../../../05．Buff系统/00．Buff系统';
import { 常规BuffID } from '../../../05．Buff系统/03．Buff表/00．Buff登记';
import { 创建装备玩家属性项, 装备属性键 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/23．装备属性定义';
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as any;
const 观察序号 = 创建单位时限数值('安魂守墓灯-观察序号');
const 观察期受伤 = 创建单位时限标记('安魂守墓灯-观察期受伤');
const 安魂观察持续秒 = 2;
const 安魂庇护持续秒 = 4;
const 安魂庇护属性效果 = 创建单位临时属性效果托管器();

function 施加安魂余光Buff(this: void, source: any, target: any): void {
    registerManualBuff(target, 常规BuffID.安魂守墓灯_安魂余光, 安魂观察持续秒, 0.06, {
        sourceUnit: source,
        effectSourceName: 四Boss战利品装备名.安魂守墓灯,
        effectSourceType: '装备',
        effectValue2: 250,
    });
}

function 施加安魂庇护Buff(this: void, source: any, target: any): void {
    registerManualBuff(target, 常规BuffID.安魂守墓灯_安魂庇护, 安魂庇护持续秒, 0.15, {
        sourceUnit: source,
        effectSourceName: 四Boss战利品装备名.安魂守墓灯,
        effectSourceType: '装备',
        onRemove: 清除安魂庇护属性,
    });
    安魂庇护属性效果.施加(target, 0, [
        创建装备玩家属性项(装备属性键.物理抗性, 0.15),
        创建装备玩家属性项(装备属性键.魔法抗性, 0.15),
    ]);
}

function 清除安魂庇护属性(this: void, unit: any, _buffID: string, _row: any): void {
    安魂庇护属性效果.清除(unit);
}

创建窗口承伤次数触发器({
    名称: '安魂守墓灯-观察受伤',
    窗口秒: 0,
    次数阈值: 1,
    过滤伤害: (event) => 观察序号.存在(event.单位),
    on触发: (event) => 观察期受伤.标记(event.单位, 3),
});
创建治疗护盾联动({
    名称: '安魂守墓灯-安魂余光',
    监听方向: '自己给予',
    治疗触发阶段: '治疗开始',
    过滤事件: (event) =>
        !是敌对单位(event.来源单位, event.目标单位) &&
        单位持有装备(event.来源单位, 四Boss战利品装备名.安魂守墓灯) &&
        取当前生命(event.目标单位) / 取最大生命(event.目标单位) <= 0.5,
    on治疗(event): void {
        const source = event.来源单位,
            target = event.目标单位,
            t = (观察序号.读取(target) ?? 0) + 1;
        观察序号.写入(target, t, 3);
        观察期受伤.清空(target);
        施加安魂余光Buff(source, target);
        播放单位特效(四Boss装备特效.安魂范围, target, 'origin', 2.2, 0.28);
        addDelayedCallback(安魂观察持续秒 * 1000, function 安魂结算(this: void): void {
            if (观察序号.读取(target) !== t) return;
            观察序号.清空(target);
            移除单位指定Buff(target, 常规BuffID.安魂守墓灯_安魂余光);
            if (观察期受伤.消耗(target)) {
                施加安魂庇护Buff(source, target);
            } else 恢复生命魔法(source, target, 取最大生命(target) * 0.06, 250);
            播放单位特效(四Boss装备特效.安魂完成, target, 'origin', 1, 0.35);
        });
    },
});
export {};
