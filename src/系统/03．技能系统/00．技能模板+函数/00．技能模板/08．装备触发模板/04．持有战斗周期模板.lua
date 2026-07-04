--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_5355_4F4D_6218_6597_72B6_6001_6258_7BA1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.19．单位战斗状态托管")
local _____521B_5EFA_5355_4F4D_6218_6597_72B6_6001_6258_7BA1_5668 = ____19_FF0E_5355_4F4D_6218_6597_72B6_6001_6258_7BA1["创建单位战斗状态托管器"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听")
local _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03 = ____require_result_0["监听指定物品获取丢弃"]
local _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF = ____require_result_0["获取单位当前持有指定物品数量"]
____exports["注册持有战斗周期模板"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or _____53C2_6570["物品类型ID"] == 0 or _____53C2_6570["周期秒"] <= 0 or _____53C2_6570["on周期"] == nil then
        return nil
    end
    local _____6218_6597_72B6_6001
    _____6218_6597_72B6_6001 = _____521B_5EFA_5355_4F4D_6218_6597_72B6_6001_6258_7BA1_5668({
        ["名称"] = _____53C2_6570["名称"],
        ["主体类型"] = _____53C2_6570["主体类型"] or "玩家英雄",
        ["周期触发秒"] = _____53C2_6570["周期秒"],
        ["on周期触发"] = function(event)
            local unit = event["单位"]
            local count = _____83B7_53D6_5355_4F4D_5F53_524D_6301_6709_6307_5B9A_7269_54C1_6570_91CF(unit, _____53C2_6570["物品类型ID"])
            if count <= 0 then
                _____6218_6597_72B6_6001["移除"](unit)
                return
            end
            _____53C2_6570["on周期"]({["单位"] = unit, ["持有数量"] = count})
        end
    })
    local function ____on_83B7_53D6(unit, item, currentCount, previousCount)
        if currentCount > 0 then
            _____6218_6597_72B6_6001["加入"](unit)
        end
        local ____opt_1 = _____53C2_6570["on获取"]
        if ____opt_1 ~= nil then
            ____opt_1({["单位"] = unit, ["物品"] = item, ["持有数量"] = currentCount, ["前次数量"] = previousCount})
        end
    end
    local function ____on_4E22_5F03(unit, item, currentCount, previousCount)
        if currentCount <= 0 then
            _____6218_6597_72B6_6001["移除"](unit)
        end
        local ____opt_3 = _____53C2_6570["on丢弃"]
        if ____opt_3 ~= nil then
            ____opt_3({["单位"] = unit, ["物品"] = item, ["持有数量"] = currentCount, ["前次数量"] = previousCount})
        end
    end
    _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03(_____53C2_6570["物品类型ID"], ____on_83B7_53D6, ____on_4E22_5F03)
    return {["加入"] = _____6218_6597_72B6_6001["加入"], ["移除"] = _____6218_6597_72B6_6001["移除"]}
end
return ____exports
