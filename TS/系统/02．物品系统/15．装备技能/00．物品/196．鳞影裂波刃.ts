/** @noSelfInFile */
// 祖地秘境·深渊鳞将掉落：鳞影裂波刃（被动·裂波）
// 裂波：战斗中完成自身主动位移后，5秒内的下一次纯普通攻击必定暴击，触发或超时后消失。
// 实现选型：注册战斗自身位移完成监听 + 添加强化普攻（次数1，命中即耗尽）+ 必定暴击临时玩家属性（嗜狱恶剑"必定暴击"键），
// Buff 与强化普攻双向互锁清除（赤誓断界剑模式）。

import {
    添加强化普攻,
    清除强化普攻,
    type 强化普攻结束上下文,
} from "../../../03．技能系统/00．技能模板+函数/01．技能函数/21．攻击效果/04．强化普攻";
import { 注册战斗自身位移完成监听 } from "../../../03．技能系统/00．技能模板+函数/02．通用函数/20．位移技能限制";
import { 创建单位临时属性效果托管器 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/19．临时属性效果";
import { 单位持有装备, 播放单位特效, 祖地秘境战利品装备名 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { registerManualBuff, 移除单位指定Buff } from "../../../05．Buff系统/00．Buff系统";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";
const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

const 裂波状态名 = "裂波";
const 裂波持续秒 = 5;
const 裂波Buff移除中: Record<number, boolean | undefined> = {};
const 裂波强化结束中: Record<number, boolean | undefined> = {};
const 裂波属性效果 = 创建单位临时属性效果托管器();
const 裂波特效 = "Common\\Effect\\Element\\Water\\WetShockMark.mdx";

function 取裂波单位ID(this: void, unit: any): number {
    if (unit == null || unit === 0) return 0;
    return GetHandleId(unit) || 0;
}

function 清除裂波属性(this: void, unit: any): void {
    裂波属性效果.清除(unit);
}

function on裂波Buff移除(this: void, unit: any, _buffID: string, _row: any): void {
    const id = 取裂波单位ID(unit);
    if (id !== 0 && 裂波强化结束中[id] === true) return;
    if (id !== 0) 裂波Buff移除中[id] = true;
    清除强化普攻(unit, 裂波状态名);
    清除裂波属性(unit);
    if (id !== 0) delete 裂波Buff移除中[id];
}

function on裂波强化结束(this: void, context: 强化普攻结束上下文): void {
    const id = 取裂波单位ID(context.单位);
    if (id !== 0 && 裂波Buff移除中[id] === true) return;
    if (id !== 0) 裂波强化结束中[id] = true;
    移除单位指定Buff(context.单位, 常规BuffID.鳞影裂波刃_裂波);
    清除裂波属性(context.单位);
    if (id !== 0) delete 裂波强化结束中[id];
}

function on裂波位移(this: void, unit: any): void {
    if (!单位持有装备(unit, 祖地秘境战利品装备名.鳞影裂波刃)) return;
    移除单位指定Buff(unit, 常规BuffID.鳞影裂波刃_裂波);
    const added = 添加强化普攻({
        单位: unit,
        名称: 裂波状态名,
        持续时间: 裂波持续秒,
        次数: 1,
        伤害倍率: 1,
        on结束: on裂波强化结束,
    });
    if (!added) return;
    registerManualBuff(unit, 常规BuffID.鳞影裂波刃_裂波, 裂波持续秒, 1, {
        sourceUnit: unit,
        effectSourceName: 祖地秘境战利品装备名.鳞影裂波刃,
        effectSourceType: "装备",
        onRemove: on裂波Buff移除,
    });
    裂波属性效果.施加(unit, 0, [
        { 类型: "玩家属性", 属性名: "必定暴击", 数值: 1 },
    ]);
    播放单位特效(裂波特效, unit, "origin", 1, 0.6);
}

注册战斗自身位移完成监听(on裂波位移);
export {};
