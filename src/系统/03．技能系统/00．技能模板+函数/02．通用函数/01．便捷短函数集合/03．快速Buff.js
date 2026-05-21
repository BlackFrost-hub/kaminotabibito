/** @noSelfInFile */
/**
 * 便捷短函数 - 快速Buff
 *
 * 只做技能侧短名转发，不改底层参数顺序：
 * 来源单位 -> 目标单位 -> Buff/数值 -> 持续时间
 */
import { SFB_增益BUFF, SFB_负面BUFF, SFB_setInnerFire, SFB_setBloodlust, SFB_setCripple, SFB_setFaerieFire, SFB_setCurse, SFB_setSleep, SFB_setEntanglingRoots, SFB_setCyclone, SFB_setParasite, SFB_setItemIllusion, } from "../../../../../lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统";
import { 施加快速Buff, 施加快速控制Buff, 施加快速减速Buff, 读取单位重伤, 施加单位重伤, 清除单位重伤, } from "../01．控制与Buff";
import { 施加禁锢, 施加寄生, } from "../../01．技能函数/18．周期范围效果/03．禁锢寄生";
export const 快速增益Buff = SFB_增益BUFF;
export const 快速负面Buff = SFB_负面BUFF;
/** 通用快速Buff。参数顺序：来源单位 -> 目标单位 -> Buff类型 -> 持续时间 */
export const 快速Buff = 施加快速Buff;
/** 通用快速控制Buff。参数顺序：来源单位 -> 目标单位 -> 控制类型 -> 持续时间 */
export const 快速控制Buff = 施加快速控制Buff;
/** 快速减速。参数顺序：来源单位 -> 目标单位 -> 攻速减幅 -> 移速减幅 -> 持续时间 */
export const 快速减速Buff = 施加快速减速Buff;
/** 快速重伤。参数顺序：目标单位 -> 重伤值 -> 持续时间 */
export const 快速重伤 = 施加单位重伤;
/** 读取单位当前重伤 */
export const 获取重伤 = 读取单位重伤;
/** 移除单位当前重伤 */
export const 移除重伤 = 清除单位重伤;
export const 快速心灵之火 = SFB_setInnerFire;
export const 快速嗜血术 = SFB_setBloodlust;
export const 快速残废 = SFB_setCripple;
export const 快速精灵之火 = SFB_setFaerieFire;
export const 快速诅咒 = SFB_setCurse;
export const 快速睡眠 = SFB_setSleep;
export const 快速纠缠根须 = SFB_setEntanglingRoots;
export const 快速飓风 = SFB_setCyclone;
export const 快速寄生 = SFB_setParasite;
export const 快速幻象物品 = SFB_setItemIllusion;
export const 快速禁锢 = 施加禁锢;
export const 快速寄生虫 = 施加寄生;
