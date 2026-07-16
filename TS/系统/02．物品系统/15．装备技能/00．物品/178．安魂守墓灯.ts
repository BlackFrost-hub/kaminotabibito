/** @noSelfInFile */
import {
    创建治疗护盾联动,
    创建窗口承伤次数触发器,
    创建单位时限标记,
    创建单位时限数值,
} from '../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/index';
import {
    单位持有装备,
    是敌对单位,
    取当前生命,
    取最大生命,
    恢复生命魔法,
    临时玩家属性,
    播放单位特效,
    四Boss战利品装备名,
    四Boss装备特效,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as any;
const 观察序号 = 创建单位时限数值('安魂守墓灯-观察序号');
const 观察期受伤 = 创建单位时限标记('安魂守墓灯-观察期受伤');
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
        播放单位特效(四Boss装备特效.安魂范围, target, 'origin', 2.2, 0.28);
        addDelayedCallback(2000, function 安魂结算(this: void): void {
            if (观察序号.读取(target) !== t) return;
            观察序号.清空(target);
            if (观察期受伤.消耗(target)) {
                临时玩家属性(target, '物理抗性', 0.15, 4);
                临时玩家属性(target, '魔法抗性', 0.15, 4);
            } else 恢复生命魔法(source, target, 取最大生命(target) * 0.06, 250);
            播放单位特效(四Boss装备特效.安魂完成, target, 'origin', 1, 0.35);
        });
    },
});
export {};
