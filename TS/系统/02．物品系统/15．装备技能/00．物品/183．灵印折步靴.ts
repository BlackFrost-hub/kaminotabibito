/** @noSelfInFile */
import { 注册持有战斗周期模板 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板/04．持有战斗周期模板';
import { 创建句柄上下文托管器 } from '../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/24．句柄上下文托管';
import { 注册战斗自身位移完成监听 } from '../../../03．技能系统/00．技能模板+函数/02．通用函数/20．位移技能限制';
import {
    单位持有装备,
    取装备物品ID,
    取装备冷却键,
    装备冷却就绪,
    进入装备冷却并显示,
    临时玩家属性,
    播放点特效,
    播放单位特效,
    四Boss战利品装备名,
    四Boss装备特效,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
const jass = require('jass.common') as any;
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as any;
interface 折步印记 {
    X: number;
    Y: number;
    到期: number;
    已离开: boolean;
}
const 印记 = 创建句柄上下文托管器<折步印记>('灵印折步靴');
注册战斗自身位移完成监听(function on折步位移(this: void, unit: any, startX: number, startY: number): void {
    if (!单位持有装备(unit, 四Boss战利品装备名.灵印折步靴)) return;
    const key = 取装备冷却键(unit, '折步留印');
    if (!装备冷却就绪(key)) return;
    进入装备冷却并显示(key, 12, unit, 四Boss战利品装备名.灵印折步靴);
    印记.写入(unit, { X: startX, Y: startY, 到期: getServerTime() + 5000, 已离开: false });
    播放点特效(四Boss装备特效.镇魂印, startX, startY, 5, 0.35);
});
注册持有战斗周期模板({
    名称: '灵印折步靴-返回检测',
    物品类型ID: 取装备物品ID(四Boss战利品装备名.灵印折步靴),
    周期秒: 0.25,
    on丢弃: (e) => 印记.清空(e.单位),
    on周期(e): void {
        const s = 印记.读取(e.单位);
        if (s == null) return;
        if (getServerTime() >= s.到期) {
            印记.清空(e.单位);
            return;
        }
        const dx = jass.GetUnitX(e.单位) - s.X,
            dy = jass.GetUnitY(e.单位) - s.Y,
            d2 = dx * dx + dy * dy;
        if (d2 > 220 * 220) {
            s.已离开 = true;
            return;
        }
        if (!s.已离开 || d2 > 150 * 150) return;
        印记.清空(e.单位);
        临时玩家属性(e.单位, '物理抗性', 0.18, 4);
        临时玩家属性(e.单位, '魔法抗性', 0.18, 4);
        临时玩家属性(e.单位, '控制抗性', 0.3, 4);
        播放单位特效(四Boss装备特效.魂力回灌, e.单位, 'origin', 1, 0.3);
    },
});
export {};
