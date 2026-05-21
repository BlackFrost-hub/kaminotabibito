/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const jass = require("jass.common");
const { createTimedEffect, 创建Dz绑定单位特效, 销毁Dz绑定单位特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效");
const { 开始充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统");
const { 获取坐标范围敌人 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围");
const GetUnitState = jass.GetUnitState;
const SetUnitState = jass.SetUnitState;
const UnitDamageTarget = jass.UnitDamageTarget;
const ConvertUnitState = jass.ConvertUnitState;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
import { 破血之戒物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 破血之戒配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
import { 破血之戒特效键, 破血之戒绑定附着点 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
const 破血之戒上下文表 = {};
function 是否为破血之戒(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return jass.GetItemTypeId(物品) === 破血之戒物品ID;
}
function 获取破血之戒单位ID(单位) {
    if (单位 == null || 单位 === 0)
        return 0;
    return jass.GetHandleId(单位);
}
function 清理破血之戒上下文(单位) {
    const 单位ID = 获取破血之戒单位ID(单位);
    if (单位ID <= 0)
        return;
    delete 破血之戒上下文表[单位ID];
}
function 结算破血之戒(施法单位) {
    const 单位ID = 获取破血之戒单位ID(施法单位);
    if (单位ID <= 0)
        return;
    const 上下文 = 破血之戒上下文表[单位ID];
    if (上下文 == null)
        return;
    const 伤害值 = 破血之戒配置.基础伤害 + GetUnitState(施法单位, ConvertUnitState(0x15)) * 3;
    const 敌人列表 = 获取坐标范围敌人(施法单位, 上下文.目标X, 上下文.目标Y, 破血之戒配置.作用范围);
    createTimedEffect(破血之戒配置.选取特效路径, 上下文.目标X, 上下文.目标Y, 0, 1);
    for (let i = 0; i < 敌人列表.length; i++) {
        const 敌人 = 敌人列表[i];
        if (敌人 == null || 敌人 === 0)
            continue;
        UnitDamageTarget(施法单位, 敌人, 伤害值, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS);
    }
}
function 开始破血之戒充能(施法单位) {
    创建Dz绑定单位特效(施法单位, 破血之戒绑定附着点, 破血之戒配置.施法特效路径, 破血之戒特效键);
    开始充能(施法单位, {
        持续时间: 破血之戒配置.充能时间,
        主单位: 施法单位,
        主单位死亡时中断: true,
        显示进度条特效: true,
        充能完成回调: function 破血之戒完成回调(单位, _充能ID) {
            结算破血之戒(单位);
        },
        结束回调: function 破血之戒结束回调(单位, _原因, _充能ID) {
            销毁Dz绑定单位特效(单位, 破血之戒特效键);
            清理破血之戒上下文(单位);
        },
    });
}
export function 处理破血之戒使用(上下文) {
    debugLogForce("05．破血之戒", "进入", "处理破血之戒使用");
    if (!是否为破血之戒(上下文.物品))
        return;
    if (上下文.目标单位 == null || 上下文.目标单位 === 0)
        return;
    const 施法单位 = 上下文.施法单位;
    const 单位ID = 获取破血之戒单位ID(施法单位);
    if (单位ID <= 0)
        return;
    破血之戒上下文表[单位ID] = {
        施法单位,
        目标X: 上下文.目标X,
        目标Y: 上下文.目标Y,
        目标单位: 上下文.目标单位,
    };
    const 当前生命 = GetUnitState(施法单位, UNIT_STATE_LIFE);
    SetUnitState(施法单位, UNIT_STATE_LIFE, 当前生命 - 1000);
    开始破血之戒充能(施法单位);
}
