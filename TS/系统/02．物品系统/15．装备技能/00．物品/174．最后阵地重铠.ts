/** @noSelfInFile */
import { 注册持有战斗周期模板 } from '../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板/04．持有战斗周期模板';
import { 创建单位驻留进度 } from '../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/28．单位驻留进度';
import { 施加临时属性效果, type 临时属性效果实例 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/19．临时属性效果';
import { 创建装备玩家属性项, 装备属性键 } from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/23．装备属性定义';
import { getBuffRuntime, registerManualBuff, 移除单位指定Buff, 设置单位Buff层数 } from '../../../05．Buff系统/00．Buff系统';
import { 常规BuffID } from '../../../05．Buff系统/03．Buff表/00．Buff登记';
import {
    取装备物品ID,
    播放单位特效,
    四Boss战利品装备名,
    四Boss装备特效,
} from '../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助';
const jass = require('jass.common') as any;
const GetHandleId = jass.GetHandleId as (this: void, unit: any) => number;
const 驻留进度 = 创建单位驻留进度('最后阵地重铠', 160);
const 守阵最大层数 = 3;
const 守阵物理抗性 = 0.12;
const 守阵效果实例表: Record<number, 临时属性效果实例[] | undefined> = {};
const 守阵Buff刷新中: Record<number, boolean | undefined> = {};
const 守阵效果批量清除中: Record<number, boolean | undefined> = {};

function 取守阵单位ID(this: void, unit: any): number {
    if (unit == null || unit === 0) return 0;
    return GetHandleId(unit) || 0;
}

function 移除守阵效果实例记录(this: void, unit: any, instance: 临时属性效果实例): void {
    const id = 取守阵单位ID(unit);
    const 实例列表 = 守阵效果实例表[id];
    if (id === 0 || 实例列表 == null) return;
    for (let i = 实例列表.length - 1; i >= 0; i--) {
        if (实例列表[i] === instance) 实例列表.splice(i, 1);
    }
    if (实例列表.length === 0) delete 守阵效果实例表[id];
}

function 清除全部守阵效果(this: void, unit: any, _buffID: string, _row: any): void {
    const id = 取守阵单位ID(unit);
    if (id === 0 || 守阵Buff刷新中[id] === true) return;
    const 实例列表 = 守阵效果实例表[id];
    if (实例列表 == null) return;
    delete 守阵效果实例表[id];
    守阵效果批量清除中[id] = true;
    for (let i = 实例列表.length - 1; i >= 0; i--) 实例列表[i].清除();
    delete 守阵效果批量清除中[id];
}

function 取下一层守阵层数(this: void, unit: any): number {
    const 当前层数 = getBuffRuntime(unit, 常规BuffID.最后阵地重铠_守阵)?.stack ?? 0;
    return 当前层数 < 守阵最大层数 ? 当前层数 + 1 : 守阵最大层数;
}

function 减少守阵层数(this: void, unit: any): void {
    const 当前Buff = getBuffRuntime(unit, 常规BuffID.最后阵地重铠_守阵);
    if (当前Buff == null) return;
    const 剩余层数 = 当前Buff.stack - 1;
    if (剩余层数 <= 0) 移除单位指定Buff(unit, 常规BuffID.最后阵地重铠_守阵);
    else 设置单位Buff层数(unit, 常规BuffID.最后阵地重铠_守阵, 剩余层数);
}

function 施加守阵效果(this: void, unit: any): void {
    const 层数 = 取下一层守阵层数(unit);
    const id = 取守阵单位ID(unit);
    if (id !== 0) 守阵Buff刷新中[id] = true;
    registerManualBuff(unit, 常规BuffID.最后阵地重铠_守阵, 2.2, 18, {
        sourceUnit: unit,
        effectSourceName: 四Boss战利品装备名.最后阵地重铠,
        effectSourceType: '装备',
        effectValue2: 守阵物理抗性,
        stack: 层数,
        onRemove: 清除全部守阵效果,
    });
    if (id !== 0) delete 守阵Buff刷新中[id];
    let 当前实例: 临时属性效果实例 | null = null;
    当前实例 = 施加临时属性效果(unit, 2200, [
        { 类型: '护甲', 数值: 18 },
        创建装备玩家属性项(装备属性键.物理抗性, 守阵物理抗性),
        创建装备玩家属性项(装备属性键.控制抗性, 0.2),
    ], {
        on清除: function on单层守阵清除(this: void, u: any): void {
            if (当前实例 != null) 移除守阵效果实例记录(u, 当前实例);
            if (id === 0 || 守阵效果批量清除中[id] !== true) 减少守阵层数(u);
        },
    });
    if (id !== 0 && 当前实例.是否激活()) {
        const 实例列表 = 守阵效果实例表[id] ?? [];
        实例列表.push(当前实例);
        守阵效果实例表[id] = 实例列表;
    }
    播放单位特效(四Boss装备特效.安魂范围, unit, 'origin', 2.2, 0.35);
}

注册持有战斗周期模板({
    名称: '最后阵地重铠',
    物品类型ID: 取装备物品ID(四Boss战利品装备名.最后阵地重铠),
    周期秒: 1,
    on丢弃(event): void {
        驻留进度.清空(event.单位);
    },
    on周期(event): void {
        const u = event.单位;
        if (驻留进度.采样(u) >= 3) {
            施加守阵效果(u);
        }
    },
});
export {};
