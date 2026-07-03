--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.05．视野变化")
local _____65BD_52A0_89C6_91CE_53D8_5316Buff = ____require_result_0["施加视野变化Buff"]
local _____79FB_9664_5355_4F4D_89C6_91CE_53D8_5316Buff = ____require_result_0["移除单位视野变化Buff"]
____exports["施加战斗视野压制"] = function(_____53C2_6570)
    do
        local i = 0
        while i < #_____53C2_6570["目标列表"] do
            do
                local target = _____53C2_6570["目标列表"][i + 1]
                if target == nil or target == 0 then
                    goto __continue4
                end
                local ____65BD_52A0_89C6_91CE_53D8_5316Buff_2 = _____65BD_52A0_89C6_91CE_53D8_5316Buff
                local ____53C2_6570__6765_6E90_5355_4F4D_1 = _____53C2_6570["来源单位"]
                if ____53C2_6570__6765_6E90_5355_4F4D_1 == nil then
                    ____53C2_6570__6765_6E90_5355_4F4D_1 = nil
                end
                ____65BD_52A0_89C6_91CE_53D8_5316Buff_2(____53C2_6570__6765_6E90_5355_4F4D_1, target, {
                    BuffID = _____53C2_6570.BuffID,
                    ["持续时间"] = _____53C2_6570["持续时间"],
                    ["视野值"] = _____53C2_6570["视野减少值"] > 0 and -_____53C2_6570["视野减少值"] or _____53C2_6570["视野减少值"],
                    ["叠加键"] = _____53C2_6570["叠加键"] or _____53C2_6570["名称"],
                    ["图标路径"] = _____53C2_6570["图标路径"],
                    ["特效路径"] = _____53C2_6570["特效路径"]
                })
            end
            ::__continue4::
            i = i + 1
        end
    end
    if _____53C2_6570["清理"] ~= nil then
        local ____self_3 = _____53C2_6570["清理"]
        ____self_3["登记清理"](
            ____self_3,
            _____53C2_6570["名称"],
            function()
                do
                    local i = 0
                    while i < #_____53C2_6570["目标列表"] do
                        local target = _____53C2_6570["目标列表"][i + 1]
                        if target ~= nil and target ~= 0 then
                            _____79FB_9664_5355_4F4D_89C6_91CE_53D8_5316Buff(target)
                        end
                        i = i + 1
                    end
                end
            end
        )
    end
end
return ____exports
