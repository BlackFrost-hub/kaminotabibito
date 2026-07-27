--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____14_FF0E_5355_4F4D_65F6_9650_6807_8BB0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.14．单位时限标记")
local _____521B_5EFA_5355_4F4D_65F6_9650_6807_8BB0 = ____14_FF0E_5355_4F4D_65F6_9650_6807_8BB0["创建单位时限标记"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有装备"]
local _____53D6_88C5_5907_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取装备冷却键"]
local _____88C5_5907_51B7_5374_5C31_7EEA = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却就绪"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却并显示"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____76EE_6807_6B63_9762_671D_5411_6765_6E90 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["目标正面朝向来源"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____00_FF0EBuff_7CFB_7EDF["移除单位指定Buff"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local _____53CD_51FB_5F3A_5316 = _____521B_5EFA_5355_4F4D_65F6_9650_6807_8BB0("亡者凝视面甲-反击强化")
local _____53CD_51FB_5F3A_5316_6301_7EED_79D2 = 5
local _____53CD_51FB_4F24_5BB3_9608_503C = 1000
local _____53CD_51FB_5F3A_5316_5185_7F6E_51B7_5374_79D2 = 1
local function _____6E05_9664_4EA1_8005_53CD_51FB_5F3A_5316(unit, _buffID, _row)
    _____53CD_51FB_5F3A_5316["清空"](_____53CD_51FB_5F3A_5316, unit)
end
local function _____5C1D_8BD5_83B7_5F97_4EA1_8005_53CD_51FB_5F3A_5316(unit)
    local key = _____53D6_88C5_5907_51B7_5374_952E(unit, "亡者凝视反击强化")
    if not _____88C5_5907_51B7_5374_5C31_7EEA(key) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(key, _____53CD_51FB_5F3A_5316_5185_7F6E_51B7_5374_79D2, unit, _____56DBBoss_6218_5229_54C1_88C5_5907_540D["亡者凝视面甲"])
    registerManualBuff(
        unit,
        _____5E38_89C4BuffID["亡者凝视面甲_亡者反击"],
        _____53CD_51FB_5F3A_5316_6301_7EED_79D2,
        0.25,
        {
            sourceUnit = unit,
            effectSourceName = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["亡者凝视面甲"],
            effectSourceType = "装备",
            effectValue2 = _____53CD_51FB_4F24_5BB3_9608_503C,
            onRemove = _____6E05_9664_4EA1_8005_53CD_51FB_5F3A_5316
        }
    )
    _____53CD_51FB_5F3A_5316["标记"](_____53CD_51FB_5F3A_5316, unit, _____53CD_51FB_5F3A_5316_6301_7EED_79D2)
    _____64AD_653E_5355_4F4D_7279_6548(
        _____56DBBoss_88C5_5907_7279_6548["灵魂崩解"],
        unit,
        "overhead",
        0.8,
        0.18
    )
end
registerDamageModifier(
    function(c)
        local result = c.currentDamage
        if _____53CD_51FB_5F3A_5316["存在"](_____53CD_51FB_5F3A_5316, c.attacker) and (c.isNormalAttack == true and c.isSkillAttack ~= true and c.isSkillDamage ~= true or c.isSingleTargetSkillDamage == true) then
            _____53CD_51FB_5F3A_5316["消耗"](_____53CD_51FB_5F3A_5316, c.attacker)
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(c.attacker, _____5E38_89C4BuffID["亡者凝视面甲_亡者反击"])
            result = result * 1.25
        end
        if not _____5355_4F4D_6301_6709_88C5_5907(c.target, _____56DBBoss_6218_5229_54C1_88C5_5907_540D["亡者凝视面甲"]) or not _____76EE_6807_6B63_9762_671D_5411_6765_6E90(c.attacker, c.target, 100) or c.isDotDamage == true or c.isReflectedDamage == true or c.isDamageTransfer == true then
            return result
        end
        if result >= _____53CD_51FB_4F24_5BB3_9608_503C then
            _____5C1D_8BD5_83B7_5F97_4EA1_8005_53CD_51FB_5F3A_5316(c.target)
        end
        return result * 0.82
    end,
    25
)
return ____exports
