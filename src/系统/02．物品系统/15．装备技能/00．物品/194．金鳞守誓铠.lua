--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____03_FF0E_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.03．最终伤害触发模板")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____03_FF0E_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F["注册最终伤害触发模板"]
local ____index = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.index")
local _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C = ____index["创建单位时限数值"]
local ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果")
local _____521B_5EFA_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_6258_7BA1_5668 = ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C["创建单位临时属性效果托管器"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____11_FF0E_88C5_5907_5E38_91CF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.11．装备常量")
local _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D = ____11_FF0E_88C5_5907_5E38_91CF["祖地秘境战利品装备名"]
local _____91CD_9CDE_6BCF_5C42_62A4_7532 = 4
local _____91CD_9CDE_6700_5927_5C42_6570 = 5
local _____91CD_9CDE_7A97_53E3_79D2 = 6
local _____91CD_9CDE_5C42_6570 = _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C("金鳞守誓铠-重鳞层数")
local _____91CD_9CDE_5C5E_6027_6548_679C = _____521B_5EFA_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_6258_7BA1_5668()
local function _____6E05_9664_91CD_9CDE_5C5E_6027(unit, _buffID, _row)
    _____91CD_9CDE_5C42_6570["清空"](unit)
    _____91CD_9CDE_5C5E_6027_6548_679C["清除"](unit)
end
local function ____on_91CD_9CDE_53D7_51FB(event)
    local unit = event["目标"]
    local _____5C42_6570 = math.min(
        (_____91CD_9CDE_5C42_6570["读取"](unit) or 0) + 1,
        _____91CD_9CDE_6700_5927_5C42_6570
    )
    registerManualBuff(
        unit,
        _____5E38_89C4BuffID["金鳞守誓铠_重鳞"],
        _____91CD_9CDE_7A97_53E3_79D2,
        _____5C42_6570 * _____91CD_9CDE_6BCF_5C42_62A4_7532,
        {sourceUnit = unit, effectSourceName = _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D["金鳞守誓铠"], effectSourceType = "装备", onRemove = _____6E05_9664_91CD_9CDE_5C5E_6027}
    )
    _____91CD_9CDE_5C42_6570["写入"](unit, _____5C42_6570, _____91CD_9CDE_7A97_53E3_79D2)
    _____91CD_9CDE_5C5E_6027_6548_679C["施加"](unit, 0, {{["类型"] = "护甲", ["数值"] = _____5C42_6570 * _____91CD_9CDE_6BCF_5C42_62A4_7532}})
end
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "金鳞守誓铠-重鳞",
    ["装备名"] = _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D["金鳞守誓铠"],
    ["持有者"] = "受击者",
    ["要求双方存活"] = false,
    ["on触发"] = ____on_91CD_9CDE_53D7_51FB
})
return ____exports
