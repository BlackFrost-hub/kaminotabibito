--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有装备"]
local _____5355_4F4D_5B58_6D3B = ____07_FF0E_88C5_5907_8F85_52A9["单位存活"]
local _____662F_654C_5BF9_5355_4F4D = ____07_FF0E_88C5_5907_8F85_52A9["是敌对单位"]
local _____53D6_653B_51FB_529B = ____07_FF0E_88C5_5907_8F85_52A9["取攻击力"]
local _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["祖地秘境战利品装备名"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.16．单位时限数值")
local _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C = ____require_result_1["创建单位时限数值"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.02．攻击力提高")
local _____65BD_52A0_5355_4F53_653B_51FB_529B_63D0_9AD8Buff = ____require_result_2["施加单体攻击力提高Buff"]
local _____6218_610F_6BCF_5C42_653B_51FB_6BD4_4F8B = 0.08
local _____6218_610F_6700_5927_5C42_6570 = 3
local _____6218_610F_6301_7EED_79D2 = 4
local _____6218_610F_5C42_6570 = _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C("祖地战冠-战意层数")
local _____6218_610F_9996_5C42_52A0_6210 = _____521B_5EFA_5355_4F4D_65F6_9650_6570_503C("祖地战冠-战意首层加成")
local _____6218_51A0_56FE_6807 = "ReplaceableTextures\\CommandButtons\\Equipment\\Icon\\Helmet\\BTNAncestralWarCrown.blp"
local function ____on_7956_5730_6218_51A0_51FB_6740(dyingUnit, killingUnit)
    if killingUnit == nil or killingUnit == 0 then
        return
    end
    if not _____5355_4F4D_6301_6709_88C5_5907(killingUnit, _____7956_5730_79D8_5883_6218_5229_54C1_88C5_5907_540D["祖地战冠"]) then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(killingUnit) then
        return
    end
    if dyingUnit == nil or dyingUnit == 0 or not _____662F_654C_5BF9_5355_4F4D(killingUnit, dyingUnit) then
        return
    end
    local _____65E7_5C42_6570 = _____6218_610F_5C42_6570["读取"](killingUnit)
    if _____65E7_5C42_6570 == nil then
        _____6218_610F_9996_5C42_52A0_6210["写入"](
            killingUnit,
            _____53D6_653B_51FB_529B(killingUnit) * _____6218_610F_6BCF_5C42_653B_51FB_6BD4_4F8B,
            _____6218_610F_6301_7EED_79D2
        )
    end
    local _____5C42_6570 = math.min((_____65E7_5C42_6570 or 0) + 1, _____6218_610F_6700_5927_5C42_6570)
    _____6218_610F_5C42_6570["写入"](killingUnit, _____5C42_6570, _____6218_610F_6301_7EED_79D2)
    local _____5355_5C42_52A0_6210 = _____6218_610F_9996_5C42_52A0_6210["读取"](killingUnit) or _____53D6_653B_51FB_529B(killingUnit) * _____6218_610F_6BCF_5C42_653B_51FB_6BD4_4F8B
    _____65BD_52A0_5355_4F53_653B_51FB_529B_63D0_9AD8Buff(killingUnit, killingUnit, {BuffID = _____5E38_89C4BuffID["祖地战冠_战意"], ["持续时间"] = _____6218_610F_6301_7EED_79D2, ["攻击力"] = _____5355_5C42_52A0_6210 * _____5C42_6570, ["图标路径"] = _____6218_51A0_56FE_6807})
end
registerDeathListener(____on_7956_5730_6218_51A0_51FB_6740)
return ____exports
