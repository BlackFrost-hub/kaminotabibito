--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.index")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F["注册最终伤害触发模板"]
local ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果")
local _____521B_5EFA_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_6258_7BA1_5668 = ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C["创建单位临时属性效果托管器"]
local ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.23．装备属性定义")
local _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879 = ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49["创建装备玩家属性项"]
local _____88C5_5907_5C5E_6027_952E = ____23_FF0E_88C5_5907_5C5E_6027_5B9A_4E49["装备属性键"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____00_FF0EBuff_7CFB_7EDF["移除单位指定Buff"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local SFB_setSlow = ____require_result_0.SFB_setSlow
local _____6B8B_8A93_4E0D_9000_89E6_53D1_751F_547D_6BD4_4F8B = 0.35
local _____6B8B_8A93_4E0D_9000_6301_7EED_79D2_6570 = 6
local _____6B8B_8A93_4E0D_9000_9B54_6297 = 0.18
local _____6B8B_8A93_4E0D_9000_5C5E_6027_6548_679C = _____521B_5EFA_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_6258_7BA1_5668()
local function _____6E05_9664_6B8B_8A93_4E0D_9000_5C5E_6027(unit, _buffID, _row)
    _____6B8B_8A93_4E0D_9000_5C5E_6027_6548_679C["清除"](unit)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____5E38_89C4BuffID["减速"])
end
local function ____on_6B8B_8A93_4E0D_9000_89E6_53D1(e)
    registerManualBuff(
        e["持有者"],
        _____5E38_89C4BuffID["裂誓战躯重铠_残誓不退"],
        _____6B8B_8A93_4E0D_9000_6301_7EED_79D2_6570,
        0.25,
        {
            sourceUnit = e["持有者"],
            effectSourceName = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["裂誓战躯重铠"],
            effectSourceType = "装备",
            effectValue2 = _____6B8B_8A93_4E0D_9000_9B54_6297,
            onRemove = _____6E05_9664_6B8B_8A93_4E0D_9000_5C5E_6027
        }
    )
    _____6B8B_8A93_4E0D_9000_5C5E_6027_6548_679C["施加"](
        e["持有者"],
        0,
        {
            _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879(_____88C5_5907_5C5E_6027_952E["物理抗性"], 0.25),
            _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879(_____88C5_5907_5C5E_6027_952E["魔法抗性"], _____6B8B_8A93_4E0D_9000_9B54_6297),
            _____521B_5EFA_88C5_5907_73A9_5BB6_5C5E_6027_9879(_____88C5_5907_5C5E_6027_952E["控制抗性"], 0.4)
        }
    )
    SFB_setSlow(
        e["持有者"],
        e["持有者"],
        0,
        0.25,
        _____6B8B_8A93_4E0D_9000_6301_7EED_79D2_6570,
        "裂誓战躯重铠",
        "装备"
    )
end
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "裂誓战躯重铠-残誓不退",
    ["装备名"] = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["裂誓战躯重铠"],
    ["持有者"] = "受击者",
    ["冷却秒数"] = 45,
    ["受击后生命比例上限"] = _____6B8B_8A93_4E0D_9000_89E6_53D1_751F_547D_6BD4_4F8B,
    ["on触发"] = ____on_6B8B_8A93_4E0D_9000_89E6_53D1
})
return ____exports
