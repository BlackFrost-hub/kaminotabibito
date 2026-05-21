/** @noSelfInFile */
const jass = require("jass.common");
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版");
const { 开始无敌帧 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧");
const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查");
const { 单位物品累伤次数, 获取单位指定装备 } = require("lib.扩展函数.物品相关函数.物品累伤次数函数");
const { 回沙之书累计配置 } = require("系统.02．物品系统.15．装备技能.02．累计伤害.01．累计伤害配置表");
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版");
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能");
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
const GetHandleId = jass.GetHandleId;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget;
const 回沙CD表 = {};
const 回沙之书ID = stringToFourCCSafe(resolveItemIdByName(回沙之书累计配置.物品名));
export function 处理回沙之书累计(target, _attacker, applied) {
    if (target == null || target === 0 || !(applied > 0)) {
        return;
    }
    const item = 获取单位指定装备(target, 回沙之书ID);
    if (item == null) {
        return;
    }
    const 达到阈值 = 单位物品累伤次数(target, 回沙之书累计配置.物品名, applied, 1, 回沙之书累计配置.累计阈值, {
        是否在CD中: 回沙CD表[GetHandleId(target)] === true,
        达到阈值后重置: true,
    });
    const gain = applied * 回沙之书累计配置.法力恢复倍率;
    if (gain > 0) {
        doHeal({
            HealSource: target,
            HealTarget: target,
            HealAmount: 0,
            HealManaAmount: gain,
            ItemHeal: true,
            HealEffect: false,
            ManaEffect: true,
            ManaShowText: true,
        });
    }
    if (达到阈值) {
        const hid = GetHandleId(target);
        if (回沙CD表[hid]) {
            return;
        }
        const eff = AddSpecialEffectTarget(回沙之书累计配置.特效路径, target, "overhead");
        if (eff != null) {
            YDWETimerDestroyEffectSafe(回沙之书累计配置.特效持续时间, eff);
        }
        回沙CD表[hid] = true;
        addDelayedCallback(回沙之书累计配置.冷却时间 * 1000, () => {
            delete 回沙CD表[hid];
        });
        addDelayedCallback(500, () => {
            开始无敌帧(target, 1.25);
        });
    }
}
