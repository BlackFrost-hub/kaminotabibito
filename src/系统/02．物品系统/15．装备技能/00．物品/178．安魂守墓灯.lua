--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.index")
local _____521B_5EFA_6CBB_7597_62A4_76FE_8054_52A8 = ____index["创建治疗护盾联动"]
local _____521B_5EFA_7A97_53E3_627F_4F24_6B21_6570_89E6_53D1_5668 = ____index["创建窗口承伤次数触发器"]
local _____521B_5EFA_5355_4F4D_65F6_9650_6807_8BB0 = ____index["创建单位时限标记"]
local _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C = ____index["创建单位时限数值"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有装备"]
local _____662F_654C_5BF9_5355_4F4D = ____07_FF0E_88C5_5907_8F85_52A9["是敌对单位"]
local _____53D6_5F53_524D_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____07_FF0E_88C5_5907_8F85_52A9["取最大生命"]
local _____6062_590D_751F_547D_9B54_6CD5 = ____07_FF0E_88C5_5907_8F85_52A9["恢复生命魔法"]
local _____4E34_65F6_73A9_5BB6_5C5E_6027 = ____07_FF0E_88C5_5907_8F85_52A9["临时玩家属性"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local _____89C2_5BDF_5E8F_53F7 = _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C("安魂守墓灯-观察序号")
local _____89C2_5BDF_671F_53D7_4F24 = _____521B_5EFA_5355_4F4D_65F6_9650_6807_8BB0("安魂守墓灯-观察期受伤")
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
    ["过滤事件"] = function(event) return not _____662F_654C_5BF9_5355_4F4D(event["来源单位"], event["目标单位"]) and _____5355_4F4D_6301_6709_88C5_5907(event["来源单位"], _____56DBBoss_6218_5229_54C1_88C5_5907_540D["安魂守墓灯"]) and _____53D6_5F53_524D_751F_547D(event["目标单位"]) / _____53D6_6700_5927_751F_547D(event["目标单位"]) <= 0.5 end,
    ["on治疗"] = function(event)
        local source = event["来源单位"]
        local target = event["目标单位"]
        local t = (_____89C2_5BDF_5E8F_53F7["读取"](target) or 0) + 1
        _____89C2_5BDF_5E8F_53F7["写入"](target, t, 3)
        _____89C2_5BDF_671F_53D7_4F24["清空"](_____89C2_5BDF_671F_53D7_4F24, target)
        _____64AD_653E_5355_4F4D_7279_6548(
            _____56DBBoss_88C5_5907_7279_6548["安魂范围"],
            target,
            "origin",
            2.2,
            0.28
        )
        addDelayedCallback(
            2000,
            function()
                if _____89C2_5BDF_5E8F_53F7["读取"](target) ~= t then
                    return
                end
                _____89C2_5BDF_5E8F_53F7["清空"](target)
                if _____89C2_5BDF_671F_53D7_4F24["消耗"](_____89C2_5BDF_671F_53D7_4F24, target) then
                    _____4E34_65F6_73A9_5BB6_5C5E_6027(target, "物理抗性", 0.15, 4)
                    _____4E34_65F6_73A9_5BB6_5C5E_6027(target, "魔法抗性", 0.15, 4)
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
