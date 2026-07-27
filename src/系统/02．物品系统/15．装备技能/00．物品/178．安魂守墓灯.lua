--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____6E05_9664_5B89_9B42_5E87_62A4_5C5E_6027, _____5B89_9B42_5E87_62A4_5C5E_6027_6548_679C
local ____index = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.index")
local _____521B_5EFA_6CBB_7597_62A4_76FE_8054_52A8 = ____index["创建治疗护盾联动"]
local _____521B_5EFA_7A97_53E3_627F_4F24_6B21_6570_89E6_53D1_5668 = ____index["创建窗口承伤次数触发器"]
local _____521B_5EFA_5355_4F4D_65F6_9650_6807_8BB0 = ____index["创建单位时限标记"]
local _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C = ____index["创建单位时限数值"]
local ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果")
local _____521B_5EFA_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_6258_7BA1_5668 = ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C["创建单位临时属性效果托管器"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有装备"]
local _____662F_654C_5BF9_5355_4F4D = ____07_FF0E_88C5_5907_8F85_52A9["是敌对单位"]
local _____53D6_5F53_524D_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取最大生命"]
local _____6062_590D_751F_547D_9B54_6CD5 = ____07_FF0E_88C5_5907_8F85_52A9["恢复生命魔法"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____00_FF0EBuff_7CFB_7EDF["移除单位指定Buff"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.23．装备属性定义")
local _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879 = ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49["创建装备玩家属性项"]
local _____88C5_5907_5C5E_6027_952E = ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49["装备属性键"]
function _____6E05_9664_5B89_9B42_5E87_62A4_5C5E_6027(unit, _buffID, _row)
    _____5B89_9B42_5E87_62A4_5C5E_6027_6548_679C["清除"](unit)
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local _____89C2_5BDF_5E8F_53F7 = _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C("安魂守墓灯-观察序号")
local _____89C2_5BDF_671F_53D7_4F24 = _____521B_5EFA_5355_4F4D_65F6_9650_6807_8BB0("安魂守墓灯-观察期受伤")
local _____5B89_9B42_89C2_5BDF_6301_7EED_79D2 = 2
local _____5B89_9B42_5E87_62A4_6301_7EED_79D2 = 4
_____5B89_9B42_5E87_62A4_5C5E_6027_6548_679C = _____521B_5EFA_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_6258_7BA1_5668()
local function _____65BD_52A0_5B89_9B42_4F59_5149Buff(source, target)
    registerManualBuff(
        target,
        _____5E38_89C4BuffID["安魂守墓灯_安魂余光"],
        _____5B89_9B42_89C2_5BDF_6301_7EED_79D2,
        0.06,
        {sourceUnit = source, effectSourceName = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["安魂守墓灯"], effectSourceType = "装备", effectValue2 = 250}
    )
end
local function _____65BD_52A0_5B89_9B42_5E87_62A4Buff(source, target)
    registerManualBuff(
        target,
        _____5E38_89C4BuffID["安魂守墓灯_安魂庇护"],
        _____5B89_9B42_5E87_62A4_6301_7EED_79D2,
        0.15,
        {sourceUnit = source, effectSourceName = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["安魂守墓灯"], effectSourceType = "装备", onRemove = _____6E05_9664_5B89_9B42_5E87_62A4_5C5E_6027}
    )
    _____5B89_9B42_5E87_62A4_5C5E_6027_6548_679C["施加"](
        target,
        0,
        {
            _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879(_____88C5_5907_5C5E_6027_952E["物理抗性"], 0.15),
            _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879(_____88C5_5907_5C5E_6027_952E["魔法抗性"], 0.15)
        }
    )
end
_____521B_5EFA_7A97_53E3_627F_4F24_6B21_6570_89E6_53D1_5668({
    ["名称"] = "安魂守墓灯-观察受伤",
    ["窗口秒"] = 0,
    ["次数阈值"] = 1,
    ["过滤伤害"] = function(event) return _____89C2_5BDF_5E8F_53F7["存在"](event["单位"]) end,
    ["on触发"] = function(event) return _____89C2_5BDF_671F_53D7_4F24["标记"](_____89C2_5BDF_671F_53D7_4F24, event["单位"], 3) end
})
_____521B_5EFA_6CBB_7597_62A4_76FE_8054_52A8({
    ["名称"] = "安魂守墓灯-安魂余光",
    ["监听方向"] = "自己给予",
    ["治疗触发阶段"] = "治疗开始",
    ["过滤事件"] = function(event) return not _____662F_654C_5BF9_5355_4F4D(event["来源单位"], event["目标单位"]) and _____5355_4F4D_6301_6709_88C5_5907(event["来源单位"], _____56DBBoss_6218_5229_54C1_88C5_5907_540D["安魂守墓灯"]) and _____53D6_5F53_524D_751F_547D(event["目标单位"]) / _____53D6_6700_5927_751F_547D(event["目标单位"]) <= 0.5 end,
    ["on治疗"] = function(event)
        local source = event["来源单位"]
        local target = event["目标单位"]
        local t = (_____89C2_5BDF_5E8F_53F7["读取"](target) or 0) + 1
        _____89C2_5BDF_5E8F_53F7["写入"](target, t, 3)
        _____89C2_5BDF_671F_53D7_4F24["清空"](_____89C2_5BDF_671F_53D7_4F24, target)
        _____65BD_52A0_5B89_9B42_4F59_5149Buff(source, target)
        _____64AD_653E_5355_4F4D_7279_6548(
            _____56DBBoss_88C5_5907_7279_6548["安魂范围"],
            target,
            "origin",
            2.2,
            0.28
        )
        addDelayedCallback(
            _____5B89_9B42_89C2_5BDF_6301_7EED_79D2 * 1000,
            function()
                if _____89C2_5BDF_5E8F_53F7["读取"](target) ~= t then
                    return
                end
                _____89C2_5BDF_5E8F_53F7["清空"](target)
                _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, _____5E38_89C4BuffID["安魂守墓灯_安魂余光"])
                if _____89C2_5BDF_671F_53D7_4F24["消耗"](_____89C2_5BDF_671F_53D7_4F24, target) then
                    _____65BD_52A0_5B89_9B42_5E87_62A4Buff(source, target)
                else
                    _____6062_590D_751F_547D_9B54_6CD5(
                        source,
                        target,
                        _____53D6_6700_5927_751F_547D(target) * 0.06,
                        250
                    )
                end
                _____64AD_653E_5355_4F4D_7279_6548(
                    _____56DBBoss_88C5_5907_7279_6548["安魂完成"],
                    target,
                    "origin",
                    1,
                    0.35
                )
            end
        )
    end
})
return ____exports
