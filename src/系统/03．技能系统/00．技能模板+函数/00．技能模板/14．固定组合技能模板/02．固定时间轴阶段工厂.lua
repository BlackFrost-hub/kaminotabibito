local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.01．多阶段技能编排.06．技能阶段链执行器")
local _____521B_5EFA_5EF6_8FDF_6267_884C_9636_6BB5 = ____06_FF0E_6280_80FD_9636_6BB5_94FE_6267_884C_5668["创建延迟执行阶段"]
--- 将无序绝对时点事件稳定排序，并转换成阶段链需要的相对延迟阶段。
____exports["创建固定时间轴阶段列表"] = function(_____4E8B_4EF6_5217_8868)
    local _____6392_5E8F_540E = {}
    do
        local i = 0
        while i < #_____4E8B_4EF6_5217_8868 do
            local _____4E8B_4EF6 = _____4E8B_4EF6_5217_8868[i + 1]
            local _____63D2_5165_4F4D_7F6E = #_____6392_5E8F_540E
            while _____63D2_5165_4F4D_7F6E > 0 and _____6392_5E8F_540E[_____63D2_5165_4F4D_7F6E]["时点毫秒"] > _____4E8B_4EF6["时点毫秒"] do
                _____63D2_5165_4F4D_7F6E = _____63D2_5165_4F4D_7F6E - 1
            end
            __TS__ArraySplice(_____6392_5E8F_540E, _____63D2_5165_4F4D_7F6E, 0, _____4E8B_4EF6)
            i = i + 1
        end
    end
    local _____9636_6BB5_5217_8868 = {}
    local _____4E0A_4E00_65F6_70B9_6BEB_79D2 = 0
    do
        local i = 0
        while i < #_____6392_5E8F_540E do
            local _____4E8B_4EF6 = _____6392_5E8F_540E[i + 1]
            local _____5F53_524D_65F6_70B9_6BEB_79D2 = _____4E8B_4EF6["时点毫秒"] > 0 and _____4E8B_4EF6["时点毫秒"] or 0
            local _____5EF6_8FDF_6BEB_79D2 = _____5F53_524D_65F6_70B9_6BEB_79D2 - _____4E0A_4E00_65F6_70B9_6BEB_79D2
            _____9636_6BB5_5217_8868[#_____9636_6BB5_5217_8868 + 1] = _____521B_5EFA_5EF6_8FDF_6267_884C_9636_6BB5(_____5EF6_8FDF_6BEB_79D2 > 0 and _____5EF6_8FDF_6BEB_79D2 or 0, _____4E8B_4EF6["执行"], _____4E8B_4EF6["名称"])
            _____4E0A_4E00_65F6_70B9_6BEB_79D2 = _____5F53_524D_65F6_70B9_6BEB_79D2
            i = i + 1
        end
    end
    return _____9636_6BB5_5217_8868
end
return ____exports
