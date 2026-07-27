/** @noSelfInFile */
import { 注册持有战斗周期模板 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板/04．持有战斗周期模板';
import { 创建句柄上下文托管器 } from '../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/24．句柄上下文托管';
import { 注册战斗自身位移完成监听 } from '../../../03．技能系统/00．技能模板+函数/02．通用函数/20．位移技能限制';
import { 创建单位临时属性效果托管器 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/19．临时属性效果';
import { 创建装备玩家属性项, 装备属性键 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/23．装备属性定义';
import { registerManualBuff } from '../../../05．Buff系统/00．Buff系统';
import { 常规BuffID } from '../../../05．Buff系统/03．Buff表/00．Buff登记';
import {
    单位持有装备,
    取装备物品ID,
    取装备冷却键,
    装备冷却就绪,
    进入装备冷却并显示,
    播放点特效,
    播放单位特效,
    四Boss战利品装备名,
    四Boss装备特效,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const R2I = jass.R2I as (value: number) => number;
const SetTextTagText = jass.SetTextTagText as (textTag: any, text: string, height: number) => void;
const { getServerTime, addPeriodicCallback, removePeriodicCallback } = require('系统.00．核心系统.05．中心计时器') as {
    getServerTime: (this: void) => number;
    addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
    removePeriodicCallback: (this: void, id: number) => void;
};
const { CreateFloatTextAtPoint, DestroyFloatText } = require('lib.扩展函数.封装函数.03．漂浮文字.index') as {
    CreateFloatTextAtPoint: (this: void, x: number, y: number, text: string, options?: any) => any;
    DestroyFloatText: (this: void, textTag: any) => void;
};
interface 折步印记 {
    X: number;
    Y: number;
    到期: number;
    已离开: boolean;
    文字: any;
    倒计时回调ID: number;
}
const 印记 = 创建句柄上下文托管器<折步印记>('灵印折步靴');
const 折步回身属性效果 = 创建单位临时属性效果托管器();
const 折步印记持续毫秒 = 8000;
const 折步文字高度 = 0.0207;

function 清除折步回身属性(this: void, unit: any, _buffID: string, _row: any): void {
    折步回身属性效果.清除(unit);
}

function 创建折步起点文字(this: void, x: number, y: number): any {
    return CreateFloatTextAtPoint(x, y, '折步起点 8.0', {
        size: 9,
        red: 160,
        green: 220,
        blue: 255,
        alpha: 0,
        duration: 0,
        permanent: true,
        speedX: 0,
        speedY: 0,
        height: 45,
    });
}

function 清除折步印记(this: void, unit: any): void {
    const s = 印记.取出(unit);
    if (s == null) return;
    if (s.倒计时回调ID > 0) removePeriodicCallback(s.倒计时回调ID);
    DestroyFloatText(s.文字);
}

function 更新折步倒计时(this: void, unit?: any): void {
    if (unit == null) return;
    const s = 印记.读取(unit);
    if (s == null) return;
    const 剩余毫秒 = s.到期 - getServerTime();
    if (剩余毫秒 <= 0) {
        清除折步印记(unit);
        return;
    }
    const 十分之一秒 = R2I((剩余毫秒 + 99) / 100);
    const 整秒 = R2I(十分之一秒 / 10);
    const 小数 = 十分之一秒 - 整秒 * 10;
    SetTextTagText(s.文字, `折步起点 ${整秒}.${小数}`, 折步文字高度);
}

function on折步装备丢弃(this: void, e: any): void {
    清除折步印记(e.单位);
}

function on折步位移(this: void, unit: any, startX: number, startY: number): void {
    if (!单位持有装备(unit, 四Boss战利品装备名.灵印折步靴)) return;
    const key = 取装备冷却键(unit, '折步留印');
    if (!装备冷却就绪(key)) return;
    进入装备冷却并显示(key, 12, unit, 四Boss战利品装备名.灵印折步靴);
    清除折步印记(unit);
    const s: 折步印记 = {
        X: startX,
        Y: startY,
        到期: getServerTime() + 折步印记持续毫秒,
        已离开: false,
        文字: 创建折步起点文字(startX, startY),
        倒计时回调ID: 0,
    };
    印记.写入(unit, s);
    s.倒计时回调ID = addPeriodicCallback(100, 更新折步倒计时, unit);
    播放点特效(四Boss装备特效.镇魂印, startX, startY, 8, 0.7);
}

function on折步返回检测(this: void, e: any): void {
    const s = 印记.读取(e.单位);
    if (s == null) return;
    if (getServerTime() >= s.到期) {
        清除折步印记(e.单位);
        return;
    }
    const dx = GetUnitX(e.单位) - s.X;
    const dy = GetUnitY(e.单位) - s.Y;
    const d2 = dx * dx + dy * dy;
    if (d2 > 220 * 220) {
        s.已离开 = true;
        return;
    }
    if (!s.已离开 || d2 > 150 * 150) return;
    清除折步印记(e.单位);
    registerManualBuff(e.单位, 常规BuffID.灵印折步靴_折步回身, 4, 0.18, {
        sourceUnit: e.单位,
        effectSourceName: 四Boss战利品装备名.灵印折步靴,
        effectSourceType: '装备',
        effectValue2: 0.18,
        onRemove: 清除折步回身属性,
    });
    折步回身属性效果.施加(e.单位, 0, [
        创建装备玩家属性项(装备属性键.物理抗性, 0.18),
        创建装备玩家属性项(装备属性键.魔法抗性, 0.18),
        创建装备玩家属性项(装备属性键.控制抗性, 0.3),
    ]);
    播放单位特效(四Boss装备特效.魂力回灌, e.单位, 'origin', 1, 0.3);
}

注册战斗自身位移完成监听(on折步位移);
注册持有战斗周期模板({
    名称: '灵印折步靴-返回检测',
    物品类型ID: 取装备物品ID(四Boss战利品装备名.灵印折步靴),
    周期秒: 0.25,
    on丢弃: on折步装备丢弃,
    on周期: on折步返回检测,
});
export {};
