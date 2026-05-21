/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器");
const jass = require("jass.common");
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效");
const { 获取坐标范围敌人, 单位是否有效且敌对 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围");
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统");
const GetItemTypeId = jass.GetItemTypeId;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitState = jass.GetUnitState;
const GetHandleId = jass.GetHandleId;
const ConvertUnitState = jass.ConvertUnitState;
const Atan2 = jass.Atan2;
const Cos = jass.Cos;
const Sin = jass.Sin;
const UnitDamageTarget = jass.UnitDamageTarget;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
import { 史诗远古魔刃物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 史诗远古魔刃配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
function 是否为史诗远古魔刃(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return GetItemTypeId(物品) === 史诗远古魔刃物品ID;
}
function on史诗远古魔刃扫掠(上下文) {
    if (上下文.次数 >= 史诗远古魔刃配置.最大次数) {
        removePeriodicCallback(上下文.timerID);
        return;
    }
    上下文.次数 += 1;
    上下文.x += Cos(上下文.角度) * 史诗远古魔刃配置.每次距离;
    上下文.y += Sin(上下文.角度) * 史诗远古魔刃配置.每次距离;
    createTimedEffect(史诗远古魔刃配置.特效路径, 上下文.x, 上下文.y, 0, 史诗远古魔刃配置.特效持续时间);
    const 伤害值 = GetUnitState(上下文.施法单位, ConvertUnitState(0x15)) * 史诗远古魔刃配置.力量系数;
    const 敌人列表 = 获取坐标范围敌人(上下文.施法单位, 上下文.x, 上下文.y, 史诗远古魔刃配置.作用范围);
    for (let i = 0; i < 敌人列表.length; i++) {
        const 敌人 = 敌人列表[i];
        if (!单位是否有效且敌对(敌人, 上下文.施法单位))
            continue;
        const 敌人ID = GetHandleId(敌人);
        if (上下文.已命中[敌人ID])
            continue;
        上下文.已命中[敌人ID] = true;
        UnitDamageTarget(上下文.施法单位, 敌人, 伤害值, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
        施加扩展控制(上下文.施法单位, 敌人, "stun", { 持续时间: 史诗远古魔刃配置.眩晕时间 });
    }
}
export function 处理史诗远古魔刃使用(上下文) {
    debugLogForce("22．史诗远古魔刃", "进入", "处理史诗远古魔刃使用");
    if (!是否为史诗远古魔刃(上下文.物品))
        return;
    const 施法单位 = 上下文.施法单位;
    if (施法单位 == null || 施法单位 === 0)
        return;
    const 起点X = GetUnitX(施法单位);
    const 起点Y = GetUnitY(施法单位);
    const 扫掠上下文 = {
        施法单位,
        x: 起点X,
        y: 起点Y,
        角度: Atan2(上下文.目标Y - 起点Y, 上下文.目标X - 起点X),
        次数: 0,
        已命中: {},
        timerID: 0,
    };
    扫掠上下文.timerID = addPeriodicCallback(史诗远古魔刃配置.周期 * 1000, () => on史诗远古魔刃扫掠(扫掠上下文));
}
